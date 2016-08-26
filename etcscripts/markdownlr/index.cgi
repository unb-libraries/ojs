#!/usr/bin/perl
use strict;
use warnings;

use CGI ();
use HTML::Entities;
use Readonly;

my $cgi = CGI->new;

if( $cgi->request_method() ne 'POST' ) {
  print $cgi->header(-charset => 'utf-8');
  print <<EOFORM;
<html>
<body>
<form method="post" enctype="multipart/form-data">
<input type="file" name="source">
<input type="submit" value="Convert">
</form>
</body>
</html>
EOFORM

exit;
}

my $fh = $cgi->upload( 'source' );
binmode $fh, ':utf8';
my $xhtml = do { local $/; <$fh>; };

Readonly my $SPACE    => ' ';
Readonly my @REPLACEABLES => (
  # Discard style-based markup that conveys nothing useful: 
  # replace with $SPACE to preserve word breaks
  sub { $_[0] =~ s{ <br /? >  }{$SPACE}g; },   # <br/> or <br>
  sub { $_[0] =~ s{ </?code>  }{$SPACE}g; },   # <small> or </small>
  sub { $_[0] =~ s{ </?small> }{$SPACE}g; },   # <code> or </code>
  
  # Discard <h1>, <h2>, ... <h6> headings
  sub { $_[0] =~ s{ < /? h ([123456]) > }{$SPACE}g; },
  
  # Translate style-based markup to Érudit equivalents
#  sub { $_[0] =~ s{ <i>   (.*?) </i>   }{<marquage typemarq="italique">$1</marquage>}g; },  # and <em>?
#  sub { $_[0] =~ s{ <b>   (.*?) </b>   }{<marquage typemarq="gras">$1</marquage>}g; },      # and <strong>?
#  sub { $_[0] =~ s{ <sup> (.*?) </sup> }{<exposant>$1</exposant>}g; },
#  sub { $_[0] =~ s{ <sub> (.*?) </sub> }{<indice>$1</indice>}g; },
  
  # Hack to work around Gemini's inconsistent character encoding: in converting
  # PDF to HTML, some non-ASCII characters entity-encoded, most are not.
  # Double-encode &, <, and > so the call to decode_entities() results in 
  # uniformly decoded characters with properly-escaped special characters.
  sub { $_[0] =~ s{ &amp; }{&amp;amp;}g; },
  sub { $_[0] =~ s{ &gt;  }{&amp;gt;}g; },
  sub { $_[0] =~ s{ &lt;  }{&amp;lt;}g; },  
);

# Replace the replaceables
foreach my $sub (@REPLACEABLES) {
  &{$sub}($xhtml);
}
    
print $cgi->header(-charset => 'utf-8', -attachment => $cgi->param('source'));
binmode STDOUT, ":utf8";
print $xhtml;
