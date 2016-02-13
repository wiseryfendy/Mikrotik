#------------------------------------------------
#Script by Ahmad Affendi, Version 1.1
#Update Radius server ip address using 
#latest ip address from gateway-pms interface
#------------------------------------------------

:log info "Checking radius server ip address"

#Interface name
:local InterfaceName gateway-pms

#internal variables
:local intAddress
:local radAddress

#main logic
:set radAddress [/radius get 0 address]

:foreach i in=[/ip address find actual-interface=$InterfaceName] do={	
	:set intAddress [/ip address get $i address]
	:set intAddress [:pick $intAddress 0 ([:find $intAddress "/"])]
	:if ($intAddress != $radAddress) do={
		:log warning "Radius server ip address change. - $radAddress -> $intAddress"
		/radius set 0 address=$intAddress
		/tool user-manager router set 0 ip-address=$intAddress
	}
}
:log info "Done updating radius server ip address"