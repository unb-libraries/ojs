#!/usr/bin/perl
###############################################################################
#
# importSubscriberIPs.pl [-v] --ojs=path/to/ojs --data=http://www.example.com/erudit.xml
#
# See show_usage() and show_help().
# 
# @todo this is a re-write of a Perl script written ca. 2008. It's a little
# more robust and fixes a couple of bugs, but it *should* be rewritten as an
# OJS command-line tool that uses methods added to the ipSubscriptionsDAO class
# to truncate / reload IP address ranges. 
###############################################################################
use strict;
use warnings;

use Carp;
use Config::Tiny;
use DBI;
use Encode;
use Getopt::Long;
use Log::Handler;
use LWP::UserAgent;
use Socket;
use XML::LibXML;

###############################################################################
# Set up logger. Log everything to the screen & let invoker direct the output.
###############################################################################
my $log = Log::Handler->new(
    screen => {
      log_to    => 'STDOUT',
      maxlevel  => 'info',
      minlevel  => 'critical',
    }
);

###############################################################################
# Process command line 
###############################################################################
{
  # Variables set in response to command-line arguments, with defaults
  my $ojs_dir  = '';
  my $data_url = '';
  my $verbose  = 0;

  # Process command line...
  my $options_ok = GetOptions(
    # Application-specific options
    'ojs=s'   => \$ojs_dir,   # --ojs=/path/to/ojs
    'data=s'  => \$data_url,  # --data=http://www.get-the-data.org/erudit.xml
    'verbose' => \$verbose,   # --verbose flag is boolean
  
    # Standard meta-options
    'usage'   => sub { print show_usage() and exit; },
    'help'    => sub { print show_help() and exit; },
  );

  # Fail if unknown arguments encountered
  print show_usage() and exit if ! $options_ok;
  
  # Fail if there is no OJS directory or data URL
  print show_usage() and exit if !$ojs_dir or !$data_url;
  
  # Use OJS base dir to load config file for database connection
  $log->info("Reading config file...") if verbose();
  my $config = Config::Tiny->new;
  
  $config = Config::Tiny->read("$ojs_dir/config.inc.php")
    or $log->critical("Can't read OJS config file: $ojs_dir/config.inc.php")
      and die;

  # Fetch database, username & password from PHP config file. Because this is a 
  # hack, strip possibly-double-quoted values: Config::Tiny does not do this.
  foreach my $setting ( ('name', 'username', 'password') ) {
    s/^\"//, s/\"$// for $config->{'database'}->{$setting};
  }
  
  # closures to fetch arguments as read-only values
  sub verbose { $verbose; }
  sub data_url { $data_url; }
  sub config { $config; }
}

###############################################################################
# Fetch XML document of CRKN subscriber IPs. Build a hash of IP addresses keyed
# by subscriber name.
###############################################################################
{
  # Fetch CRKN subscriber list or die. Use LWP::UserAgent to control request timeout
  my $ua = LWP::UserAgent->new;
  $ua->timeout(300);
  $ua->env_proxy;

  $log->info("Downlaoding CRKN subscriber data...") if verbose();
  
  my $response = $ua->get(data_url());
  $log->critical('Failed to read CRKN subscriber data: ' . $response->status_line)
    and die unless $response->is_success;
    
  # Decode HTTP response & create DOM from source XML
  $log->info("Parsing subscriber data...") if verbose();
  
  my $crkn_xml = $response->decoded_content;
  my $crkn_dom = XML::LibXML->load_xml(
    string => $crkn_xml
  );

  # Build hash ref of subscriber data
  my $subscriber_data = {};
    
  SUBSCRIBER:
  foreach my $node ($crkn_dom->findnodes('//listeip')) {
    # We expect each <listeip> to contain one <abonne> child and one <ip> child
    my $child_nodes = {};
    
    SUBSCRIBER_CHILD: 
    foreach my $child ($node->childNodes()) {
      # skip empty text nodes
      next SUBSCRIBER_CHILD if $child->nodeName =~ /#text/;
      
      # add to hash of child node data and trim node content
      ($child_nodes->{$child->nodeName} = $child->textContent) =~ s/^[ ]*(.*)[ ]*$/$1/;
    }

    # skip this subscriber node if we don't have name and IP 
    $log->warn("Incomplete subscriber information: " . $node->toString())
      and next SUBSCRIBER 
        unless $child_nodes->{'abonne'} and $child_nodes->{'ip'};
    
    # Store list of hash refs, each containing ip address, start of range, and
    # end of range, in subscriber data hashref that is keyed by subscriber name
    
    # If IP address is actually a host name, try to get host IP address
    if ($child_nodes->{'ip'} =~ /[a-z]/i) {
      
      # Skip to next subscriber node if we can't convert the host name
      my $host_ip = host_ip($child_nodes->{'ip'}) 
        or $log->warn("Can't resolve hostname: " . $child_nodes->{'ip'})
          and next SUBSCRIBER;
      
      # store converted value back in hash
      $child_nodes->{'ip'} = $host_ip;
    }
    
    # Convert possibly-wildcarded IP address (192.131.2.*) to a range of
    # decimal IP addresses
    my $ip_data = {
      'ip'    => $child_nodes->{'ip'},
      'start' => range_start($child_nodes->{'ip'}),
      'end'   => range_end($child_nodes->{'ip'}),
    };
    
    # store IP data in hash
    push( @{$subscriber_data->{$child_nodes->{'abonne'}}}, $ip_data);
  }
  
  # closure to fetch subscriber data
  sub subscriber_data { return $subscriber_data; }
}  

###############################################################################
# Connect to OJS database and update CRKN IP data 
###############################################################################
{
  $log->info("Connecting to OJS database...") if verbose();

  my $dbh = DBI->connect(
    'dbi:mysql:database='. config()->{'database'}->{'name'} . ';host=localhost;port=3306', 
    config()->{'database'}->{'username'},
    config()->{'database'}->{'password'},    
    { 
      RaiseError => 0,
      AutoCommit => 0 
    }
  ) or $log->critical("Can't connect to database: ". $DBI::errstr) and die;

  # truncate the existing CRKN IP data table
  $log->info(
    "Truncating 'crkn_ips' table in database '" . 
    config()->{'database'}->{'name'}  . 
    "'..."
  ) if verbose();

  my $truncated = $dbh->do('TRUNCATE TABLE crkn_ips')
    or $dbh->disconnect
      and $log->critical($dbh->errstr);

  # prepare the insert statement...
  my $sth = $dbh->prepare(
    "INSERT INTO crkn_ips (institution, ip, start, end) VALUES (?, ?, ?, ?)"
  );

  # Grab the subscriber data 
  $log->info("Loading subscriber data...") if verbose();
  
  my $subscriber_data = subscriber_data();
  foreach my $institution (sort keys %$subscriber_data) {
    my $ip_list = $subscriber_data->{$institution};
    
    foreach my $ip_data (@$ip_list) {
      $sth->execute(
        # IP data is UTF8-encoded but database's default character set is Latin-1.
        encode("latin1", $institution),  
        $ip_data->{'ip'},
        $ip_data->{'start'},
        $ip_data->{'end'}
      )
      or $log->warn($sth->errstr);
    } # end foreach (ip range)
    
  } # end foreach institution

  # Done.
  $dbh->disconnect;
  $log->info("Done.") if verbose();
}

exit 0;

###############################################################################
# Convert host name to numeric IP address
###############################################################################
sub host_ip {
  my $hostname = shift(@_);
  if (my $packed = gethostbyname($hostname)) {
    return inet_ntoa($packed);
  }
}

###############################################################################
# Convert possibly-wildcarded dotted quad IP address (192.131.2.*) to a decimal
# IP address marking the start of the range in the wildcareded address
###############################################################################
sub range_start {
  my $ip = shift(@_);

  # Replace wilcards with zeroes
  (my $start_ip = $ip) =~ s/\*/0/g;
  
  return convert($start_ip);
}

###############################################################################
# Convert possibly-wildcarded dotted quad IP address (192.131.2.*) to a decimal
# IP address marking the end of the range in the wildcareded address
###############################################################################
sub range_end {
  my $ip = shift(@_);

  # Replace wilcards with 255's
  (my $end_ip = $ip) =~ s/\*/255/g;
  
  return convert($end_ip);
}

###############################################################################
# Convert a dotted decimal IP address (e.g., 192.131.2.12) to a decimal IP
# address (3229811212)
###############################################################################
sub convert {
  my $ip = shift(@_);
  
  # split address into octets
  my @octets = split(/\./, $ip);

  my $decimal_ip = 0;
  foreach my $octet (@octets) {
    $decimal_ip <<= 8;
    $decimal_ip |= $octet;
  }

  return $decimal_ip;
}

###############################################################################
# Standard meta-option: usage summary
###############################################################################
sub show_usage {
  my $usage = <<'END_USAGE';
Usage: importSubscriberIPs.pl [-v] --ojs=/etcdata/www/ojs --data=http://www.example.com/erudit.xml 
END_USAGE
# end heredoc

  return $usage;
}

###############################################################################
# Standard meta-option: detailed help
###############################################################################
sub show_help {
  my $usage = show_usage();
  my $help  = <<"END_HELP";
importSubscriberIPs.pl - fetches XML data file identifying IP address ranges of 
  institutional Erudit subscribers, parses data, and updates custom table in
  OJS database with institution and IP address range data.  The custom table is
  used by OJS 'ipSubscriptions' plugin to grant / deny institutional subscribers
  access to Erudit-distributed journals.
            
${usage}
Options:
  -v, --verbose   Display details of script progress.
  -u, --usage     Print the usage line of this summary.
  -h, --help      Print this summary.

Arguments:
  --ojs path/to/ojs             OJS base path; script uses OJS config file to
                                  connect to database.
  --data http://data/file.xml   URL of XML-encoded Erudit subscription data
  
END_HELP
# end heredoc

  return $help;
}
