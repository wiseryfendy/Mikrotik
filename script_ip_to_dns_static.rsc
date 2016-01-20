:global ListName
:global Servers
:global Comments
:global Done
:local skipAddAddressList
:local skipAddDns
:local theIpAddress
:local theName
#has $Done been initialized?
:if ([:typeof $Done] != "boolean") do={
  :set Done true;
}

#make sure previous runs have finished
while (!$Done) do={
  :nothing;
}
:log info "Resolving $Servers"
#block any other runs
:set Done false;
:set skipAddDns false;
:set skipAddAddressList false;

#delete old address lists
:foreach aListItem in=[/ip firewall address-list find comment=$Comments] do={
  /ip firewall address-list remove $aListItem;
}

:foreach aListItem in=[/ip dns static find comment=$Comments] do={
  /ip dns static remove $aListItem;
}

/ip dns cache flush;

#force the dns entries to be cached
:foreach aServer in=$Servers do={
  :resolve $aServer;

  :foreach dnsRecord in=[/ip dns cache all find where (name=$aServer)] do={
    #if it's an A records add it directly
    set theIpAddress [/ip dns cache all get $dnsRecord data]
    :if ([/ip dns cache all get $dnsRecord type]="A") do={
      :foreach aListItem in=[/ip firewall address-list find where (list=$ListName && address=$theIpAddress)] do={
        :set skipAddAddressList true;
        :set skipAddDns true;
      }
      :if ($skipAddAddressList=false) do={
        /ip firewall address-list add list=$ListName address=$theIpAddress comment=$Comments;
      }
      
      :if ($skipAddDns=false) do={
        /ip dns static add name=$aServer address=$theIpAddress comment=$Comments;
      }

      :if ([:len $theIpAddress]<=0) do={
        :log error "Could not get ip address for $theName"
      }
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
        :set theIpAddress [/ip dns cache all get $aRecord data];
        :set theName [/ip dns cache all get $cname data];
        :resolve $theName;
        
        :foreach aListItem in=[/ip firewall address-list find where (list=$ListName && address=$theIpAddress)] do={
          
          :set skipAddAddressList true;
          :set skipAddDns true;
        }
        
        #Debug output
        :log info "$theName Ip address is $theIpAddress"

        :if ([:len $theIpAddress]<=0) do={
          :log error "Could not get ip address for $theName";
        }
        :if ($skipAddAddressList=false && [:len $theIpAddress]>0) do={
          /ip firewall address-list add list=$ListName address=$theIpAddress comment=$Comments;
        }

        :if ($skipAddDns=false && [:len $theIpAddress]>0) do={
          /ip dns static add name=$theName address=$theIpAddress comment=$Comments;
        }
        
        :set skipAddDns false;
        :set skipAddAddressList false;
      }
    }
  }
}

#allow other scripts to call this
:set Done true