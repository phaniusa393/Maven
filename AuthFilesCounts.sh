#!/bin/sh

rm -f /oil-local/batch/AutomationScripts/Auth_Counts.txt
rm -f /oil-local/batch/AutomationScripts/Auth_Counts1.html

#echo "Stats of $(date +"%b %d %Y" --date="yesterday") Auth-278 Files Processing" >> /oil-local/batch/AutomationScripts/Auth_Counts.txt

#--------------Input files count---------------#
{ echo -n "Total # of input XML's : " &  echo $(ls -rt /oil/AR001/authorization/archive/in/AR001_AUT_*_*_M$(date +%Y%m%d --date="yesterday")*.xml| cut -d'/' -f7 | wc -l ); } >> /oil-local/batch/AutomationScripts/Auth_Counts.txt

#--------------Unique files count---------------#
{ echo -n "Total # of Unique PAs(Input) : " &  echo $(ls -rt /oil/AR001/authorization/archive/in/AR001_AUT_*_*_M$(date +%Y%m%d --date="yesterday")*.xml| cut -d'/' -f7 | sort -nr | uniq -w 20 | wc -l ); } >> /oil-local/batch/AutomationScripts/Auth_Counts.txt

#--------------Error files count---------------#
{ echo -n "Total # of Error XML's : " &  echo $(ls -rt /oil/AR001/authorization/error/AR001_AUT_*_*_M$(date +%Y%m%d --date="yesterday")*.xml_Error.xml| cut -d'/' -f7 | wc -l ); } >> /oil-local/batch/AutomationScripts/Auth_Counts.txt

#--------------Warnings files count---------------#
{ echo -n "Total # of Warnings XML's : " &  echo $(ls -rt /oil/AR001/authorization/error/AR001_AUT_*_*_M$(date +%Y%m%d --date="yesterday")*.xml_Warning.xml| cut -d'/' -f7 | wc -l ); } >> /oil-local/batch/AutomationScripts/Auth_Counts.txt

#--------------EDI files count---------------#
{ echo -n "Total # of EDIs produced : " &  echo $(ls -rt /oil/WY001/authorization/archive/out/AR001_AUT_*_*_M$(date +%Y%m%d --date="yesterday")*.edi| cut -d'/' -f7 | wc -l ); } >> /oil-local/batch/AutomationScripts/Auth_Counts.txt

#--------------EDI's Submitted files count---------------#
{ echo -n "Total # of EDIs SubmittedToXerox : " &  echo $(ls -rt /oil/ECG/WY001/archive-state/AR001_AUT_*_*_M$(date +%Y%m%d --date="yesterday")*.edi| cut -d'/' -f6 | wc -l ); } >> /oil-local/batch/AutomationScripts/Auth_Counts.txt

#-------------------------Communication to Operations-------------------------#
awk 'BEGIN { print "<html><body><table border=1>" 
             print "<tr><th colspan="2" align="center">Stats of Auth-278 Files Processing</th></tr>" 
           }
 
 { print "<tr>\n<td>"$1" "$2" "$3" "$4" "$5"</td><td width=20%>"$7"</td>\n</tr>"} 

END{ print "</table></body></html> " }' /oil-local/batch/AutomationScripts/Auth_Counts.txt >> /oil-local/batch/AutomationScripts/Auth_Counts1.html

mutt -e 'set from="DoNotReply@optum.com" content_type="text/html"' WYUMSolutionMO@Optum.com -s "Auths(278) File Processing Stats - $(date +"%b %d %Y" --date="yesterday")" <  /oil-local/batch/AutomationScripts/Auth_Counts1.html
