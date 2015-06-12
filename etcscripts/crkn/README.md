Custom content in the CRKN stack is probably poorly labelled. CRKN, or the [Canada Research Knowledge Network](http://crkn.ca/lang), were/are a giant funding agency for expanding digital scholarship in Canada. In 2009/2010, they were principally responsible for the invitation of our journals being invited to the broader Érudit distribution platform. This explains why these things are named after CRKN, because the work done at the time was largely reflective of sending content to include our journals in their subscription package. 

Over time, these workflows became more about getting content to Érudit and/or their subscribers. 

##[fiche](https://github.com/unb-libraries/ojs/tree/master/etcscripts/crkn/fiche)

One of the major issues getting content out to Érudit was that our content was hosted online in OJS, but our XML sat in working directories outside of the OJS filesystem. We developed the "fiche" – it's just french for "file" – in order to attach urls to ojs galleys to their matching XML files. To our general dismay, these sometimes still need to be passed along. Érudit continue to modify their ingest formats and, ideally, will someday move away from the proprietary and our lives will be easier. Hopefully, we won't be using this script within a year. 

##[ipSubscriptions](https://github.com/unb-libraries/ojs/tree/master/etcscripts/crkn/ipSubscriptions)

Additionally, our partnership with Érudit requires that we make available content to their users via a list of IPs that are regularly pushed to us from their servers. This script is for that process. 
