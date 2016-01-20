:global Done

#has $Done been initialized?
:if ([:typeof $Done] != "boolean") do={
  :set Done true;
}

#make sure previous runs have finished
while (!$Done) do={
  :nothing;
}

/system reboot