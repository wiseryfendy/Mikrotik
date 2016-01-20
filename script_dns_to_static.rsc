:global Servers
:global Comments
:global Done
:local skipAddDns
:local theName
:local aName
:local skipAddAddressList
:global ListName
:local theAddress
:local redirectIp
:local listComments
#has $Done been initialized?
:if ([:typeof $Done] != "boolean") do={
  :set Done true;
}

#make sure previous runs have finished
while (!$Done) do={
  :nothing;
}

#block any other runs
:set Done false;
:set skipAddDns false;
:set skipAddAddressList false;
:set Comments "Unwanted website - Blocked"
:set listComments [:put ("Unwanted website - " . $Servers)]
:set theName "Nothing"
:set aName "Nothing"
:set ListName "Blocked website"
:set theAddress "Null"
:set redirectIp "192.168.99.254"

#delete old address lists
:foreach aListItem in=[/ip dns static find comment=$listComments] do={
  /ip dns static remove $aListItem;
}
:foreach aListItem in=[/ip firewall address-list find comment=$listComments] do={
  /ip firewall address-list remove $aListItem;
}

/ip dns cache flush

#force the dns entries to be cached
:foreach aServer in=$Servers do={
  :resolve $aServer;

  :foreach dnsRecord in=[/ip dns cache all find where (name=$aServer)] do={
    set aName $aServer

    #if it's an A records add it directly
    :if ([/ip dns cache all get $dnsRecord type]="A") do={
      :foreach aListItem in=[/ip dns static find where (name=$aServer && address=$redirectIp)] do={
        :set skipAddDns true;
      }
      
      :if ($skipAddDns=false) do={
        /ip dns static add name=$aServer address=$redirectIp comment=$listComments;
      }
      :foreach aListItem in=[/ip firewall address-list find where (comment=$listComments && address=[/ip dns cache all get $dnsRecord data])] do={
        :set skipAddAddressList true;
      }
      :set theAddress [/ip dns cache all get $dnsRecord data];
      :if ($skipAddAddressList=false && [:len $theIpAddress]>0) do={
        /ip firewall address-list add list=$ListName address=$theAddress comment=$listComments;
      }
      :if ([:len $theAddress]<=0) do={
        :log error "Could not get ip address for $aName"
      }
      :log info "Hostname: $aName IP address: $theAddress";
      :set skipAddDns false;
      :set skipAddAddressList false;
    }

    #if it's a CNAME follow it until we get A records
    :if ([/ip dns cache all get $dnsRecord type]="CNAME") do={
      :local cname;
      :local nextCname;
      :set cname [/ip dns cache all find where (name=$aServer && type="CNAME")];
      :set nextCname [/ip dns cache all find where (name=[/ip dns cache all get $cname data] && type="CNAME")];

      :while ($nextCname != "") do={
          :set cname $nextCname;
          :set nextCname [/ip dns cache all find where (name=[/ip dns cache all get $cname data] && type="CNAME")];
        }
  
      #add the a records we found
      :foreach aRecord in=[/ip dns cache all find where (name=[/ip dns cache all get $cname data] && type="A")] do={
        set theName [/ip dns cache all get $cname data]

        :resolve $theName;
        
        :foreach aListItem in=[/ip dns static find where (name=$theName && address=$redirectIp)] do={
          :set skipAddDns true;
        }
        :if ($skipAddDns=false) do={
          /ip dns static add name=$theName address=$redirectIp comment=$listComments;
        }
        
        set theAddress [/ip dns cache all get $aRecord data]
        :foreach aListItem in=[/ip firewall address-list find where (list=$ListName && address=$theAddress)] do={
          :set skipAddAddressList true;
        }

        :if ($skipAddAddressList=false && [:len $theAddress]>0) do={
          /ip firewall address-list add list=$ListName address=[/ip dns cache all get $aRecord data] comment=$listComments;
        }

        :if ([:len $theAddress]<=0) do={
        :log error "Could not get ip address for $theName"
      }
        :log info "Hostname: $aName CNAME: $theName IP address: $theAddress";
        :set skipAddDns false;
        :set skipAddAddressList false;
      }
    }
  }
}

#allow other scripts to call this
:set Done true