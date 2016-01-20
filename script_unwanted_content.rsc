:log info "Adding unwanted website to static DNS"
:global Servers {"rhtag.com"};
/system script run script_dns_to_static;
:global Servers {"ad.doubleclick.net"}; #CNAME dart.l.doubleclick.net
/system script run script_dns_to_static;
:global Servers {"doubleclick.net"};
/system script run script_dns_to_static;
:global Servers {"go.ad2up.com"};
/system script run script_dns_to_static;
:global Servers {"go.padsdel.com"};
/system script run script_dns_to_static;
:global Servers {"googleads.g.doubleclick.net"}; #CNAME pagead46.l.doubleclick.net
/system script run script_dns_to_static;
:global Servers {"kovla.com"};
/system script run script_dns_to_static;
:global Servers {"static.doubleclick.net"};
/system script run script_dns_to_static;
:global Servers {"tpc.googlesyndication.com"};
/system script run script_dns_to_static;
:global Servers {"www.kovla.com"}; #CNAME kovla.com
/system script run script_dns_to_static;
:global Servers {"imgg.mgid.com"}; #CNAME img.mgid.com
/system script run script_dns_to_static;
:global Servers {"pagead2.googlesyndication.com"}; #CNAME pagead46.l.doubleclick.net
/system script run script_dns_to_static;
:global Servers {"googleadservices.com"};
/system script run script_dns_to_static;
:global Servers {"static.doubleclick.net"}; #CNAME static-doubleclick-net.l.google.com
/system script run script_dns_to_static;
:global Servers {"steepto.com"};
/system script run script_dns_to_static; 
:global Servers {"store.livfe.net"}; #CNAME elb049710.1343736460.us-east-1.elb.amazonaws.com
/system script run script_dns_to_static;
:global Servers {"totaladperformance.com"};
/system script run script_dns_to_static;
:global Servers {"partner.googleadservices.com"}; #CNAME partnerad.l.doubleclick.net
/system script run script_dns_to_static;
:global Servers {"pubads.g.doubleclick.net"}; #CNAME partnerad.l.doubleclick.net
/system script run script_dns_to_static;
:global Servers {"www.googleadservices.com"}; #pagead.l.doubleclick.net
/system script run script_dns_to_static;
:global Servers {"static.crowdynews.com"};
/system script run script_dns_to_static;
:global Servers {"blank.org"};
/system script run script_dns_to_static;
:log info "Done - Adding unwanted website to static DNS";