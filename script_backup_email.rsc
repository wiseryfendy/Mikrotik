:local date
:local day
:local month
:local year
:local filename
:set date [/system clock get date]
:set day [:pick $date 4 6]
:set month [:pick $date 0 3]
:set year [:pick $date 7 11]
:set $filename [:put ($day . " " . $month . " " . $year) ]
:log info "Backing up configuration file and start sending email"
/system backup save name= $filename;
/tool e-mail send to="fendie_c080@sendtodropbox.com" subject=([/system identity get name]." backup") body="attached is the backup settings. \n\nThanks \n\nmagnify.pms" file= "$filename.backup";
:log info "Backup mail sent."; 
/delay delay-time=10s
:log info "Deleting backup file."; 
/file remove "$filename.backup"