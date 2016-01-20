:log info "Updating Yahoo Messenger ip address list"

:global ListName yahoo_messenger
:global Comments ym_rproxy4
:global Servers {"rproxy4.messenger.yahooapis.com"}
/system script run script_ip_to_dns_static

:global ListName yahoo_messenger
:global Comments ym_displayimage
:global Servers {"displayimage.messenger.yahooapis.com"}
/system script run script_ip_to_dns_static

:global ListName yahoo_messenger
:global Comments basic3_chat
:global Servers {"scsc.msg.yahoo.com"}
/system script run script_ip_to_dns_static

:global ListName yahoo_messenger
:global Comments basic2_chat
:global Servers {"scsa.msg.yahoo.com"}
/system script run script_ip_to_dns_static

:global ListName yahoo_messenger
:global Comments basic1_chat
:global Servers {"scs.msg.yahoo.com"}
/system script run script_ip_to_dns_static

#:global ListName yahoo_messenger
#:global Comments webcam_chat
#:global Servers {"webcam.yahoo.com"}
#/system script run script_ip_to_dns_static

#:global ListName yahoo_messenger
#:global Comments voice_chat
#:global Servers {"vc.yahoo.com"}
#/system script run script_ip_to_dns_static

:log info "Done - Updating Yahoo Messenger ip address list"