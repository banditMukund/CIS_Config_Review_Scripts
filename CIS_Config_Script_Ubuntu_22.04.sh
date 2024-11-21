
result_file='result2204.csv'
echo 'Hostname,Testcase,Status,Detail' > "$result_file"
thehostname=$(hostname)

testcase="1.1.1.1 Ensure cramfs kernel module is not available"
echo "$testcase"
detail=""
output=$({
   l_output="" l_output2="" l_output3="" l_dl="" # Unset output variables
   l_mname="cramfs" # set module name
   l_mtype="fs" # set module type
   l_searchloc="/lib/modprobe.d/*.conf /usr/local/lib/modprobe.d/*.conf /run/modprobe.d/*.conf /etc/modprobe.d/*.conf"
   l_mpath="/lib/modules/**/kernel/$l_mtype"
   l_mpname="$(tr '-' '_' <<< "$l_mname")"
   l_mndir="$(tr '-' '/' <<< "$l_mname")"

   module_loadable_chk()
   {
      # Check if the module is currently loadable
      l_loadable="$(modprobe -n -v "$l_mname")"
      [ "$(wc -l <<< "$l_loadable")" -gt "1" ] && l_loadable="$(grep -P -- "(^\h*install|\b$l_mname)\b" <<< "$l_loadable")"
      if grep -Pq -- '^\h*install \/bin\/(true|false)' <<< "$l_loadable"; then
         l_output="$l_output \n- module: \"$l_mname\" is not loadable: \"$l_loadable\""
      else
         l_output2="$l_output2 \n- module: \"$l_mname\" is loadable: \"$l_loadable\""
      fi
   }
   module_loaded_chk()
   {
      # Check if the module is currently loaded
      if ! lsmod | grep "$l_mname" > /dev/null 2>&1; then
         l_output="$l_output \n- module: \"$l_mname\" is not loaded"
      else
         l_output2="$l_output2 \n- module: \"$l_mname\" is loaded"
      fi
   }
   module_deny_chk()
   {
      # Check if the module is deny listed
      l_dl="y"
      if modprobe --showconfig | grep -Pq -- '^\h*blacklist\h+'"$l_mpname"'\b'; then
         l_output="$l_output \n- module: \"$l_mname\" is deny listed in: \"$(grep -Pls -- "^\h*blacklist\h+$l_mname\b" $l_searchloc)\""
      else
         l_output2="$l_output2 \n- module: \"$l_mname\" is not deny listed"
      fi
   }
   # Check if the module exists on the system
   for l_mdir in $l_mpath; do
      if [ -d "$l_mdir/$l_mndir" ] && [ -n "$(ls -A $l_mdir/$l_mndir)" ]; then
         l_output3="$l_output3 - \"$l_mdir\""
         [ "$l_dl" != "y" ] && module_deny_chk
         if [ "$l_mdir" = "/lib/modules/$(uname -r)/kernel/$l_mtype" ]; then
            module_loadable_chk
            module_loaded_chk
         fi
      else
         l_output="$l_output \n- module: \"$l_mname\" doesn't exist in \"$l_mdir\""
      fi
   done
   # Report results. If no failures output in l_output2, we pass
   [ -n "$l_output3" ] && echo -e "\n -- INFO -- \n- module: \"$l_mname\" exists in:$l_output3"
   if [ -z "$l_output2" ]; then
      echo -e "\n- Audit Result: ** PASS ** $l_output"
   else
      echo -e "\n- Audit Result: ** FAIL ** - Reason(s) for audit failure: $l_output2"
      [ -n "$l_output" ] && echo -e "\n - Correctly set: $l_output"
   fi
})

status=''
if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
output=$(echo "$output" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.1.2 Ensure freevxfs kernel module is not available"
echo "$testcase"
detail=""
output=$({
   l_output="" l_output2="" l_output3="" l_dl="" # Unset output variables
   l_mname="freevxfs" # set module name
   l_mtype="fs" # set module type
   l_searchloc="/lib/modprobe.d/*.conf /usr/local/lib/modprobe.d/*.conf /run/modprobe.d/*.conf /etc/modprobe.d/*.conf"
   l_mpath="/lib/modules/**/kernel/$l_mtype"
   l_mpname="$(tr '-' '_' <<< "$l_mname")"
   l_mndir="$(tr '-' '/' <<< "$l_mname")"
   module_loadable_chk()
   {
      # Check if the module is currently loadable
      l_loadable="$(modprobe -n -v "$l_mname")"
      [ "$(wc -l <<< "$l_loadable")" -gt "1" ] && l_loadable="$(grep -P -- "(^\h*install|\b$l_mname)\b" <<< "$l_loadable")"
      if grep -Pq -- '^\h*install \/bin\/(true|false)' <<< "$l_loadable"; then
         l_output="$l_output
 - module: \"$l_mname\" is not loadable: \"$l_loadable\""
      else
         l_output2="$l_output2
 - module: \"$l_mname\" is loadable: \"$l_loadable\""
      fi
   }
   module_loaded_chk()
   {
      # Check if the module is currently loaded
      if ! lsmod | grep "$l_mname" > /dev/null 2>&1; then
         l_output="$l_output
 - module: \"$l_mname\" is not loaded"
      else
         l_output2="$l_output2
 - module: \"$l_mname\" is loaded"
      fi
   }
   module_deny_chk()
   {
      # Check if the module is deny listed
      l_dl="y"
      if modprobe --showconfig | grep -Pq -- '^\h*blacklist\h+'"$l_mpname"'\b'; then
         l_output="$l_output
 - module: \"$l_mname\" is deny listed in: \"$(grep -Pls -- "^\h*blacklist\h+$l_mname\b" $l_searchloc)\""
      else
         l_output2="$l_output2
 - module: \"$l_mname\" is not deny listed"
      fi
   }
   # Check if the module exists on the system
   for l_mdir in $l_mpath; do
      if [ -d "$l_mdir/$l_mndir" ] && [ -n "$(ls -A $l_mdir/$l_mndir)" ]; then
         l_output3="$l_output3
  - \"$l_mdir\""
         [ "$l_dl" != "y" ] && module_deny_chk
         if [ "$l_mdir" = "/lib/modules/$(uname -r)/kernel/$l_mtype" ]; then
            module_loadable_chk
            module_loaded_chk
         fi
      else
         l_output="$l_output
 - module: \"$l_mname\" doesn't exist in \"$l_mdir\""
      fi
   done
   # Report results. If no failures output in l_output2, we pass
   [ -n "$l_output3" ] && echo -e "

 -- INFO --
 - module: \"$l_mname\" exists in:$l_output3"
   if [ -z "$l_output2" ]; then
      echo -e "
- Audit Result:
  ** PASS **
$l_output
"
   else
      echo -e "
- Audit Result:
  ** FAIL **
 - Reason(s) for audit failure:
$l_output2
"
      [ -n "$l_output" ] && echo -e "
- Correctly set:
$l_output
"
   fi
   })

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')

fi
output=$(echo "$output" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.1.3 Ensure hfs kernel module is not available"
echo "$testcase"
detail=""

output=$({
   l_output="" l_output2="" l_output3="" l_dl="" # Unset output variables
   l_mname="hfs" # set module name
   l_mtype="fs" # set module type
   l_searchloc="/lib/modprobe.d/*.conf /usr/local/lib/modprobe.d/*.conf /run/modprobe.d/*.conf /etc/modprobe.d/*.conf"
   l_mpath="/lib/modules/**/kernel/$l_mtype"
   l_mpname="$(tr '-' '_' <<< "$l_mname")"
   l_mndir="$(tr '-' '/' <<< "$l_mname")"

   module_loadable_chk()
   {
      # Check if the module is currently loadable
      l_loadable="$(modprobe -n -v "$l_mname")"
      [ "$(wc -l <<< "$l_loadable")" -gt "1" ] && l_loadable="$(grep -P -- "(^\h*install|\b$l_mname)\b" <<< "$l_loadable")"
      if grep -Pq -- '^\h*install \/bin\/(true|false)' <<< "$l_loadable"; then
         l_output="$l_output\n - module: \"$l_mname\" is not loadable: \"$l_loadable\""
      else
         l_output2="$l_output2\n - module: \"$l_mname\" is loadable: \"$l_loadable\""
      fi
   }
   module_loaded_chk()
   {
      # Check if the module is currently loaded
      if ! lsmod | grep "$l_mname" > /dev/null 2>&1; then
         l_output="$l_output\n - module: \"$l_mname\" is not loaded"
      else
         l_output2="$l_output2\n - module: \"$l_mname\" is loaded"
      fi
   }
   module_deny_chk()
   {
      # Check if the module is deny listed
      l_dl="y"
      if modprobe --showconfig | grep -Pq -- '^\h*blacklist\h+'"$l_mpname"'\b'; then
         l_output="$l_output\n - module: \"$l_mname\" is deny listed in: \"$(grep -Pls -- "^\h*blacklist\h+$l_mname\b" $l_searchloc)\""
      else
         l_output2="$l_output2\n - module: \"$l_mname\" is not deny listed"
      fi
   }
   # Check if the module exists on the system
   for l_mdir in $l_mpath; do
      if [ -d "$l_mdir/$l_mndir" ] && [ -n "$(ls -A $l_mdir/$l_mndir)" ]; then
         l_output3="$l_output3\n  - \"$l_mdir\""
         [ "$l_dl" != "y" ] && module_deny_chk
         if [ "$l_mdir" = "/lib/modules/$(uname -r)/kernel/$l_mtype" ]; then
            module_loadable_chk
            module_loaded_chk
         fi
      else
         l_output="$l_output\n - module: \"$l_mname\" doesn't exist in \"$l_mdir\""
      fi
   done
   # Report results. If no failures output in l_output2, we pass
   [ -n "$l_output3" ] && echo -e "\n\n -- INFO --\n - module: \"$l_mname\" exists in:$l_output3"
   if [ -z "$l_output2" ]; then
      echo -e "\n- Audit Result:\n  ** PASS **\n$l_output\n"
   else
      echo -e "\n- Audit Result:\n  ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
      [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
   fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
output=$(echo "$output" | tr '\n' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.1.4 Ensure hfsplus kernel module is not available"
echo "$testcase"
detail=""
output=$({
   l_output="" l_output2="" l_output3="" l_dl="" # Unset output variables
   l_mname="hfsplus" # set module name
   l_mtype="fs" # set module type
   l_searchloc="/lib/modprobe.d/*.conf /usr/local/lib/modprobe.d/*.conf /run/modprobe.d/*.conf /etc/modprobe.d/*.conf"
   l_mpath="/lib/modules/**/kernel/$l_mtype"
   l_mpname="$(tr '-' '_' <<< "$l_mname")"
   l_mndir="$(tr '-' '/' <<< "$l_mname")"

   module_loadable_chk()
   {
      # Check if the module is currently loadable
      l_loadable="$(modprobe -n -v "$l_mname")"
      [ "$(wc -l <<< "$l_loadable")" -gt "1" ] && l_loadable="$(grep -P -- "(^\h*install|\b$l_mname)\b" <<< "$l_loadable")"
      if grep -Pq -- '^\h*install \/bin\/(true|false)' <<< "$l_loadable"; then
         l_output="$l_output\n - module: \"$l_mname\" is not loadable: \"$l_loadable\""
      else
         l_output2="$l_output2\n - module: \"$l_mname\" is loadable: \"$l_loadable\""
      fi
   }
   module_loaded_chk()
   {
      # Check if the module is currently loaded
      if ! lsmod | grep "$l_mname" > /dev/null 2>&1; then
         l_output="$l_output\n - module: \"$l_mname\" is not loaded"
      else
         l_output2="$l_output2\n - module: \"$l_mname\" is loaded"
      fi
   }
   module_deny_chk()
   {
      # Check if the module is deny listed
      l_dl="y"
      if modprobe --showconfig | grep -Pq -- '^\h*blacklist\h+'"$l_mpname"'\b'; then
         l_output="$l_output\n - module: \"$l_mname\" is deny listed in: \"$(grep -Pls -- "^\h*blacklist\h+$l_mname\b" $l_searchloc)\""
      else
         l_output2="$l_output2\n - module: \"$l_mname\" is not deny listed"
      fi
   }
   # Check if the module exists on the system
   for l_mdir in $l_mpath; do
      if [ -d "$l_mdir/$l_mndir" ] && [ -n "$(ls -A $l_mdir/$l_mndir)" ]; then
         l_output3="$l_output3\n  - \"$l_mdir\""
         [ "$l_dl" != "y" ] && module_deny_chk
         if [ "$l_mdir" = "/lib/modules/$(uname -r)/kernel/$l_mtype" ]; then
            module_loadable_chk
            module_loaded_chk
         fi
      else
         l_output="$l_output\n - module: \"$l_mname\" doesn't exist in \"$l_mdir\""
      fi
   done
   # Report results. If no failures output in l_output2, we pass
   [ -n "$l_output3" ] && echo -e "\n\n -- INFO --\n - module: \"$l_mname\" exists in:$l_output3"
   if [ -z "$l_output2" ]; then
      echo -e "\n- Audit Result:\n  ** PASS **\n$l_output\n"
   else
      echo -e "\n- Audit Result:\n  ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
      [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
   fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.1.5 Ensure jffs2 kernel module is not available"
echo "$testcase"
detail=""
output=$({
   l_output="" l_output2="" l_output3="" l_dl="" # Unset output variables
   l_mname="jffs2" # set module name
   l_mtype="fs" # set module type
   l_searchloc="/lib/modprobe.d/*.conf /usr/local/lib/modprobe.d/*.conf /run/modprobe.d/*.conf /etc/modprobe.d/*.conf"
   l_mpath="/lib/modules/**/kernel/$l_mtype"
   l_mpname="$(tr '-' '_' <<< "$l_mname")"
   l_mndir="$(tr '-' '/' <<< "$l_mname")"

   module_loadable_chk()
   {
      # Check if the module is currently loadable
      l_loadable="$(modprobe -n -v "$l_mname")"
      [ "$(wc -l <<< "$l_loadable")" -gt "1" ] && l_loadable="$(grep -P -- "(^\h*install|\b$l_mname)\b" <<< "$l_loadable")"
      if grep -Pq -- '^\h*install \/bin\/(true|false)' <<< "$l_loadable"; then
         l_output="$l_output\n - module: \"$l_mname\" is not loadable: \"$l_loadable\""
      else
         l_output2="$l_output2\n - module: \"$l_mname\" is loadable: \"$l_loadable\""
      fi
   }
   module_loaded_chk()
   {
      # Check if the module is currently loaded
      if ! lsmod | grep "$l_mname" > /dev/null 2>&1; then
         l_output="$l_output\n - module: \"$l_mname\" is not loaded"
      else
         l_output2="$l_output2\n - module: \"$l_mname\" is loaded"
      fi
   }
   module_deny_chk()
   {
      # Check if the module is deny listed
      l_dl="y"
      if modprobe --showconfig | grep -Pq -- '^\h*blacklist\h+'"$l_mpname"'\b'; then
         l_output="$l_output\n - module: \"$l_mname\" is deny listed in: \"$(grep -Pls -- "^\h*blacklist\h+$l_mname\b" $l_searchloc)\""
      else
         l_output2="$l_output2\n - module: \"$l_mname\" is not deny listed"
      fi
   }
   # Check if the module exists on the system
   for l_mdir in $l_mpath; do
      if [ -d "$l_mdir/$l_mndir" ] && [ -n "$(ls -A $l_mdir/$l_mndir)" ]; then
         l_output3="$l_output3\n  - \"$l_mdir\""
         [ "$l_dl" != "y" ] && module_deny_chk
         if [ "$l_mdir" = "/lib/modules/$(uname -r)/kernel/$l_mtype" ]; then
            module_loadable_chk
            module_loaded_chk
         fi
      else
         l_output="$l_output\n - module: \"$l_mname\" doesn't exist in \"$l_mdir\""
      fi
   done
   # Report results. If no failures output in l_output2, we pass
   [ -n "$l_output3" ] && echo -e "\n\n -- INFO --\n - module: \"$l_mname\" exists in:$l_output3"
   if [ -z "$l_output2" ]; then
      echo -e "\n- Audit Result:\n  ** PASS **\n$l_output\n"
   else
      echo -e "\n- Audit Result:\n  ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
      [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
   fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
output=$(echo "$output" | tr '\n' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.1.8 Ensure usb-storage kernel module is not available"
echo "$testcase"
detail=""
output=$({
   l_output="" l_output2="" l_output3="" l_dl="" # Unset output variables
   l_mname="usb-storage" # set module name
   l_mtype="drivers" # set module type
   l_searchloc="/lib/modprobe.d/*.conf /usr/local/lib/modprobe.d/*.conf /run/modprobe.d/*.conf /etc/modprobe.d/*.conf"
   l_mpath="/lib/modules/**/kernel/$l_mtype"
   l_mpname="$(tr '-' '_' <<< "$l_mname")"
   l_mndir="$(tr '-' '/' <<< "$l_mname")"

   module_loadable_chk()
   {
      # Check if the module is currently loadable
      l_loadable="$(modprobe -n -v "$l_mname")"
      [ "$(wc -l <<< "$l_loadable")" -gt "1" ] && l_loadable="$(grep -P -- "(^\h*install|\b$l_mname)\b" <<< "$l_loadable")"
      if grep -Pq -- '^\h*install \/bin\/(true|false)' <<< "$l_loadable"; then
         l_output="$l_output\n - module: \"$l_mname\" is not loadable: \"$l_loadable\""
      else
         l_output2="$l_output2\n - module: \"$l_mname\" is loadable: \"$l_loadable\""
      fi
   }
   module_loaded_chk()
   {
      # Check if the module is currently loaded
      if ! lsmod | grep "$l_mname" > /dev/null 2>&1; then
         l_output="$l_output\n - module: \"$l_mname\" is not loaded"
      else
         l_output2="$l_output2\n - module: \"$l_mname\" is loaded"
      fi
   }
   module_deny_chk()
   {
      # Check if the module is deny listed
      l_dl="y"
      if modprobe --showconfig | grep -Pq -- '^\h*blacklist\h+'"$l_mpname"'\b'; then
         l_output="$l_output\n - module: \"$l_mname\" is deny listed in: \"$(grep -Pls -- "^\h*blacklist\h+$l_mname\b" $l_searchloc)\""
      else
         l_output2="$l_output2\n - module: \"$l_mname\" is not deny listed"
      fi
   }
   # Check if the module exists on the system
   for l_mdir in $l_mpath; do
      if [ -d "$l_mdir/$l_mndir" ] && [ -n "$(ls -A $l_mdir/$l_mndir)" ]; then
         l_output3="$l_output3\n  - \"$l_mdir\""
         [ "$l_dl" != "y" ] && module_deny_chk
         if [ "$l_mdir" = "/lib/modules/$(uname -r)/kernel/$l_mtype" ]; then
            module_loadable_chk
            module_loaded_chk
         fi
      else
         l_output="$l_output\n - module: \"$l_mname\" doesn't exist in \"$l_mdir\""
      fi
   done
   # Report results. If no failures output in l_output2, we pass
   [ -n "$l_output3" ] && echo -e "\n\n -- INFO --\n - module: \"$l_mname\" exists in:$l_output3"
   if [ -z "$l_output2" ]; then
      echo -e "\n- Audit Result:\n  ** PASS **\n$l_output\n"
   else
      echo -e "\n- Audit Result:\n  ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
      [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
   fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
output=$(echo "$output" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.2.1.1 Ensure /tmp is a separate partition"
echo "$testcase"
detail=""
output=$(/bin/findmnt -kn /tmp)
tmpoutput=$(/bin/findmnt -kn /tmp)
if [ -n "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="no separate partition"; fi
output=$(echo "$output" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >>  $result_file

if [ -n "$tmpoutput" ]; then

testcase="1.1.2.1.2 Ensure nodev option set on /tmp partition"
echo "$testcase"
detail=""
output=$(/bin/findmnt -kn /tmp | grep -v nodev)
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="nodev is not set on /tmp"; fi
output=$(echo "$output" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.2.1.3 Ensure nosuid option set on /tmp partition"
echo "$testcase"
detail=""
output=$(/bin/findmnt -kn /tmp | grep -v nosuid)
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="nosuid is not set on /tmp"; fi
output=$(echo "$output" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.2.1.4 Ensure noexec option set on /tmp partition"
echo "$testcase"
detail=""
output=$(/bin/findmnt -kn /tmp | grep -v noexec)
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="noexec is not set on /tmp"; fi
output=$(echo "$output" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

fi

testcase="1.1.2.2.1 Ensure /dev/shm is a separate partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /dev/shm)
shmoutput=$(findmnt -kn /dev/shm)
if [ -n "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="no separate partition"; fi
output=$(echo "$output" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

if [ -n "$shmoutput" ]; then

testcase="1.1.2.2.2 Ensure nodev option set on /dev/shm partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /dev/shm | grep -v 'nodev')
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="nodev is not set on /dev/shm"; fi
output=$(echo "$output" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.2.2.3 Ensure nosuid option set on /dev/shm partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /dev/shm | grep -v 'nosuid')
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="nosuid is not set on /dev/shm"; fi
output=$(echo "$output" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.2.2.4 Ensure noexec option set on /dev/shm partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /dev/shm | grep -v 'noexec')
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="noexec is not set on /dev/shm"; fi
output=$(echo "$output" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

fi

testcase="1.1.2.3.1 Ensure /home is a separate partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /home)
homeoutput=$(findmnt -kn /home)
if [ -n "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="no separate partition"; fi
output=$(echo "$output" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

if [ -n "$homeoutput" ]; then

testcase="1.1.2.3.2 Ensure nodev option set on /home partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /home | grep -v 'nodev')
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="noexec is not set on /home"; fi
output=$(echo "$output" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.2.3.3 Ensure nosuid option set on /home partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /home | grep -v 'nosuid')
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="noexec is not set on /home"; fi
output=$(echo "$output" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

fi

testcase="1.1.2.4.1 Ensure /var is a separate partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /var)
varoutput=$(findmnt -kn /var)
if [ -n "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="no separate partition"; fi
output=$(echo "$output" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

if [ -n "$varoutput" ]; then

testcase="1.1.2.4.2 Ensure nodev option set on /var partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /var | grep -v 'nodev')
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="nodev is not set on /var"; fi
output=$(echo "$output" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.2.4.3 Ensure nosuid option set on /var partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /var | grep -v 'nosuid')
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="nosuid is not set on /var"; fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

fi

testcase="1.1.2.5.1 Ensure /var/tmp is a separate partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /var/tmp)
vartmpoutput=$(findmnt -kn /var/tmp)
if [ -n "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="no separate partition"; fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

if [ -n "$vartmpoutput" ]; then

testcase="1.1.2.5.2 Ensure nodev option set on /var/tmp partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /var/tmp | grep -v nodev)
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="nodev is not set on /var/tmp"; fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.2.5.3 Ensure nosuid option set on /var/tmp partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /var/tmp | grep -v nosuid)
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="nosuid is not set on /var/tmp"; fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.2.5.4 Ensure noexec option set on /var/tmp partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /var/tmp | grep -v noexec)
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="noexec is not set on /var/tmp"; fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

fi

testcase="1.1.2.6.1 Ensure /var/log is a separate partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /var/log)
varlogoutput=$(findmnt -kn /var/log)
if [ -n "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="no separate partition"; fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

if [ -n "$varlogoutput" ]; then

testcase="1.1.2.6.2 Ensure nodev option set on /var/log partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /var/log | grep -v nodev)
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="nodev is not set on /var/log"; fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.2.6.3 Ensure nosuid option set on /var/log partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /var/log | grep -v nodsuid)
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="nosuid is not set on /var/log"; fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.2.6.4 Ensure noexec option set on /var/log partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /var/log | grep -v nodexec)
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="noexec is not set on /var/log"; fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

fi

testcase="1.1.2.7.1 Ensure /var/log/audit is a separate partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /var/log/audit)
varlogauditoutput=$(findmnt -kn /var/log/audit)
if [ -n "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="no separate partition"; fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

if [ -n "$varlogauditoutput" ]; then

testcase="1.1.2.7.2 Ensure nodev option set on /var/log/audit partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /var/log/audit | grep -v nodev)
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="nodev is not set on /var/log/audit"; fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.2.7.3 Ensure nosuid option set on /var/log/audit partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /var/log/audit | grep -v nosuid)
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="nosuid is not set on /var/log/audit"; fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.2.7.4 Ensure noexec option set on /var/log/audit partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /var/log/audit | grep -v noexec)
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="noexec is not set on /var/log/audit"; fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

fi

testcase="1.2.1.1 Ensure GPG keys are configured"
echo "$testcase"
detail=""
output=$(apt-key list)
status="Pending"
detail="Check manually"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.2.1.2 Ensure package manager repositories are configured"
echo "$testcase"
detail=""
output=$(apt-cache policy)
status="Pending"
detail="Check manually"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.2.2.1 Ensure updates patches and additional security software are installed"
echo "$testcase"
detail=""
#output=$(apt-get -s upgrade | /bin/grep -Ev '(Reading|Building|Calculating)')
status="Pending"
detail="Check manually. Update and upgrade command - not to be run on the server."
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.3.1.1 Ensure AppArmor is installed"
echo "$testcase"
detail=""
apparmorout=""
output=$(dpkg-query -s apparmor &>/dev/null && echo "apparmor is installed"
dpkg-query -s apparmor-utils &>/dev/null && echo "apparmor-utils is installed")
if [[ $output == *"apparmor"*  && $output == *"apparmor-utils"* ]]; then
   status="Pass"
   detail=""
   apparmorout="TRUE"
else
   status="Fail"
   detail="apparmor-utils is not enabled"
   apparmorout="FALSE"
fi

detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

if [[ $apparmorout == "TRUE" ]]; then

testcase="1.3.1.2 Ensure AppArmor is enabled in the bootloader configuration"
echo "$testcase"
detail=""
output=$(grep "^\s*linux" /boot/grub/grub.cfg | grep -v "apparmor=1"
grep "^\s*linux" /boot/grub/grub.cfg | grep -v "security=apparmor")
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="Overwritten by bootloader boot parameters"; fi
output=$(echo "$output" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.3.1.3 Ensure all AppArmor Profiles are in enforce or complain mode"
echo "$testcase"
detail=""
output=$(apparmor_status | grep profiles | grep unconfined
apparmor_status | grep processes | grep unconfined)
if [[ $output == *"0 processes"*  && $output == *"0 profiles"* ]]; then
   status="PASS"
   else
      if [[ $output != *"0 processes"* ]]; then
         status="FAIL"
         detail="Some processes are in unconfined mode"
      else
         status="FAIL"
         detail="Some profiles are in unconfined mode"
      fi
fi
output=$(echo "$output" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

fi

testcase="1.4.1 Ensure bootloader password is set"
echo "$testcase"
detail=""
output1=$(grep "^set superusers" /boot/grub/grub.cfg)
output2=$(awk -F. '/^\s*password/ {print $1"."$2"."$3}' /boot/grub/grub.cfg)
if [ -n "$output1" && -n "$output2" ]; then status="PASS" detail=""; else status="FAIL" detail="Password protection not enabled"; fi
output=$(echo "$output" | tr '\n' ' ')
echo "$output1"
echo "$output2"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.4.2 Ensure access to bootloader config is configured"
echo "$testcase"
detail=""
output=$(stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /boot/grub/grub.cfg)
if [[ $output == *"(0600/-rw-------) Uid: ( 0/ root) Gid: ( 0/ root)"* ]]; then
   status="PASS"
else
   status="FAIL"
   detail="Configurations not properly set"
fi
output=$(echo "$output" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.5.1 Ensure address space layout randomization is enabled"

echo "$testcase"
detail=""
detail=""
output=$({
   l_output="" l_output2=""
   a_parlist=("kernel.randomize_va_space=2")
   l_ufwscf="$([ -f /etc/default/ufw ] && awk -F= '/^\s*IPT_SYSCTL=/ {print $2}' /etc/default/ufw)"
   kernel_parameter_chk()
   {
      l_krp="$(sysctl "$l_kpname" | awk -F= '{print $2}' | xargs)" # Check running configuration
      if [ "$l_krp" = "$l_kpvalue" ]; then
         l_output="$l_output\n - \"$l_kpname\" is correctly set to \"$l_krp\" in the running configuration"
      else
         l_output2="$l_output2\n - \"$l_kpname\" is incorrectly set to \"$l_krp\" in the running configuration and should have a value of: \"$l_kpvalue\""
      fi
      unset A_out; declare -A A_out # Check durable setting (files)
      while read -r l_out; do
         if [ -n "$l_out" ]; then
            if [[ $l_out =~ ^\s*# ]]; then
               l_file="${l_out//# /}"
            else
               l_kpar="$(awk -F= '{print $1}' <<< "$l_out" | xargs)"
               [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_file")
            fi
         fi
      done < <(/usr/lib/systemd/systemd-sysctl --cat-config | grep -Po '^\h*([^#\n\r]+|#\h*\/[^#\n\r\h]+\.conf\b)')
      if [ -n "$l_ufwscf" ]; then # Account for systems with UFW (Not covered by systemd-sysctl --cat-config)
         l_kpar="$(grep -Po "^\h*$l_kpname\b" "$l_ufwscf" | xargs)"
         l_kpar="${l_kpar//\//.}"
         [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_ufwscf")
      fi
      if (( ${#A_out[@]} > 0 )); then # Assess output from files and generate output
         while IFS="=" read -r l_fkpname l_fkpvalue; do
            l_fkpname="${l_fkpname// /}"; l_fkpvalue="${l_fkpvalue// /}"
            if [ "$l_fkpvalue" = "$l_kpvalue" ]; then
               l_output="$l_output\n - \"$l_kpname\" is correctly set to \"$l_krp\" in \"$(printf '%s' "${A_out[@]}")\"\n"
            else
               l_output2="$l_output2\n - \"$l_kpname\" is incorrectly set to \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\" and should have a value of: \"$l_kpvalue\"\n"
            fi
         done < <(grep -Po -- "^\h*$l_kpname\h*=\h*\H+" "${A_out[@]}")
      else
         l_output2="$l_output2\n - \"$l_kpname\" is not set in an included file\n   ** Note: \"$l_kpname\" May be set in a file that's ignored by load procedure **\n"
      fi
   }
   while IFS="=" read -r l_kpname l_kpvalue; do # Assess and check parameters
      l_kpname="${l_kpname// /}"; l_kpvalue="${l_kpvalue// /}"
      if ! grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable && grep -q '^net.ipv6.' <<< "$l_kpname"; then
         l_output="$l_output\n - IPv6 is disabled on the system, \"$l_kpname\" is not applicable"
      else
         kernel_parameter_chk
      fi
   done < <(printf '%s\n' "${a_parlist[@]}")
   if [ -z "$l_output2" ]; then # Provide output from checks
      echo -e "\n- Audit Result:\n  ** PASS **\n$l_output\n"
   else
      echo -e "\n- Audit Result:\n  ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
      [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
   fi
})

echo $output
if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi

detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.5.2 Ensure ptrace_scope is restricted"

echo "$testcase"
detail=""
output=$({
   l_output="" l_output2=""
   a_parlist=("kernel.yama.ptrace_scope=1")
   l_ufwscf="$([ -f /etc/default/ufw ] && awk -F= '/^\s*IPT_SYSCTL=/ {print $2}' /etc/default/ufw)"
   kernel_parameter_chk()
   {
      l_krp="$(sysctl "$l_kpname" | awk -F= '{print $2}' | xargs)" # Check running configuration
      if [ "$l_krp" = "$l_kpvalue" ]; then
         l_output="$l_output\n - \"$l_kpname\" is correctly set to \"$l_krp\" in the running configuration"
      else
         l_output2="$l_output2\n - \"$l_kpname\" is incorrectly set to \"$l_krp\" in the running configuration and should have a value of: \"$l_kpvalue\""
      fi
      unset A_out; declare -A A_out # Check durable setting (files)
      while read -r l_out; do
         if [ -n "$l_out" ]; then
            if [[ $l_out =~ ^\s*# ]]; then
               l_file="${l_out//# /}"
            else
               l_kpar="$(awk -F= '{print $1}' <<< "$l_out" | xargs)"
               [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_file")
            fi
         fi
      done < <(/usr/lib/systemd/systemd-sysctl --cat-config | grep -Po '^\h*([^#\n\r]+|#\h*\/[^#\n\r\h]+\.conf\b)')
      if [ -n "$l_ufwscf" ]; then # Account for systems with UFW (Not covered by systemd-sysctl --cat-config)
         l_kpar="$(grep -Po "^\h*$l_kpname\b" "$l_ufwscf" | xargs)"
         l_kpar="${l_kpar//\//.}"
         [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_ufwscf")
      fi
      if (( ${#A_out[@]} > 0 )); then # Assess output from files and generate output
         while IFS="=" read -r l_fkpname l_fkpvalue; do
            l_fkpname="${l_fkpname// /}"; l_fkpvalue="${l_fkpvalue// /}"
            if [ "$l_fkpvalue" = "$l_kpvalue" ]; then
               l_output="$l_output\n - \"$l_kpname\" is correctly set to \"$l_krp\" in \"$(printf '%s' "${A_out[@]}")\"\n"
            else
               l_output2="$l_output2\n - \"$l_kpname\" is incorrectly set to \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\" and should have a value of: \"$l_kpvalue\"\n"
            fi
         done < <(grep -Po -- "^\h*$l_kpname\h*=\h*\H+" "${A_out[@]}")
      else
         l_output2="$l_output2\n - \"$l_kpname\" is not set in an included file\n   ** Note: \"$l_kpname\" May be set in a file that's ignored by load procedure **\n"
      fi
   }
   while IFS="=" read -r l_kpname l_kpvalue; do # Assess and check parameters
      l_kpname="${l_kpname// /}"; l_kpvalue="${l_kpvalue// /}"
      if ! grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable && grep -q '^net.ipv6.' <<< "$l_kpname"; then
         l_output="$l_output\n - IPv6 is disabled on the system, \"$l_kpname\" is not applicable"
      else
         kernel_parameter_chk
      fi
   done < <(printf '%s\n' "${a_parlist[@]}")
   if [ -z "$l_output2" ]; then # Provide output from checks
      echo -e "\n- Audit Result:\n  ** PASS **\n$l_output\n"
   else
      echo -e "\n- Audit Result:\n  ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
      [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
   fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi


echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.5.3 Ensure core dumps are restricted"

echo "$testcase"
detail=""

output=$(l_output="" l_output2=""
 a_parlist=("fs.suid_dumpable=0")
 l_ufwscf="$([ -f /etc/default/ufw ] && awk -F= '/^\s*IPT_SYSCTL=/ {print $2}' /etc/default/ufw)"
 kernel_parameter_chk()
 { 
 l_krp="$(sysctl "$l_kpname" | awk -F= '{print $2}' | xargs)" # Check running configuration
 if [ "$l_krp" = "$l_kpvalue" ]; then
 l_output="$l_output\n - \"$l_kpname\" is correctly set to \"$l_krp\" in the running configuration"
 else
 l_output2="$l_output2\n - \"$l_kpname\" is incorrectly set to \"$l_krp\" in the running configuration and should have a value of: \"$l_kpvalue\""
 fi
 unset A_out; declare -A A_out # Check durable setting (files)
 while read -r l_out; do
 if [ -n "$l_out" ]; then
 if [[ $l_out =~ ^\s*# ]]; then
 l_file="${l_out//# /}"
 else
 l_kpar="$(awk -F= '{print $1}' <<< "$l_out" | xargs)"
 [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_file")
 fi
 fi
 done < <(/usr/lib/systemd/systemd-sysctl --cat-config | grep -Po '^\h*([^#\n\r]+|#\h*\/[^#\n\r\h]+\.conf\b)')
 if [ -n "$l_ufwscf" ]; then # Account for systems with UFW (Not covered by systemd-sysctl --cat-config)
 l_kpar="$(grep -Po "^\h*$l_kpname\b" "$l_ufwscf" | xargs)"
 l_kpar="${l_kpar//\//.}"
 [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_ufwscf")
 fi
 if (( ${#A_out[@]} > 0 )); then # Assess output from files and generate output
 while IFS="=" read -r l_fkpname l_fkpvalue; do
 l_fkpname="${l_fkpname// /}"; l_fkpvalue="${l_fkpvalue// /}"
 if [ "$l_fkpvalue" = "$l_kpvalue" ]; then
 l_output="$l_output\n - \"$l_kpname\" is correctly set to \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\"\n"
 else
 l_output2="$l_output2\n - \"$l_kpname\" is incorrectly set to \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\" and should have a value of: \"$l_kpvalue\"\n"
 fi
 done < <(grep -Po -- "^\h*$l_kpname\h*=\h*\H+" "${A_out[@]}")
 else
 l_output2="$l_output2\n - \"$l_kpname\" is not set in an included file\n ** Note: \"$l_kpname\" May be set in a file that's ignored by load procedure **\n"
 fi
 }
 while IFS="=" read -r l_kpname l_kpvalue; do # Assess and check parameters
 l_kpname="${l_kpname// /}"; l_kpvalue="${l_kpvalue// /}"
 if ! grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable && grep -q '^net.ipv6.' <<< "$l_kpname"; then
 l_output="$l_output\n - IPv6 is disabled on the system, \"$l_kpname\" is not applicable"
 else
 kernel_parameter_chk
 fi
 done < <(printf '%s\n' "${a_parlist[@]}")
 if [ -z "$l_output2" ]; then # Provide output from checks
 echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
 [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
 fi)

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.5.4 Ensure prelink is not installed"
echo "$testcase"
detail=""
output=$(dpkg -s prelink 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ $output == *"'prelink' is not installed"* ]]; then status="PASS" detail=""; else status="FAIL" detail="Prelink is not installed"; fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.5.5 Ensure Automatic Error Reporting is not enabled"
echo "$testcase"
detail=""
output1=$(dpkg-query -s apport &> /dev/null && grep -Psi -- '^\h*enabled\h*=\h*[^0]\b' /etc/default/apport)
output2=$(systemctl is-active apport.service | grep '^active')
if [[ -z $output1 && -z $output2 ]]; then status="PASS" detail=""; else status="FAIL" detail="Automatic error reporting enabled"; fi
echo "$output1"
echo "$output2"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.6.1 Ensure message of the day is configured properly"
echo "$testcase"
detail=""
output1=$(cat /etc/motd)
echo "/etc/motd -> $output1"
output2=$(grep -E -i "(\\\v|\\\r|\\\m|\\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g'))" /etc/motd)
echo "grep command -> $output2"
if [[ $output1 == *"No such file"* ]]; then
   status="FAIL"
   detail="/etc/motd not present. Verify manually from output."
else
   if [[ -z "$output2" ]]; then
      status="PASS"
   else
      status="FAIL"
      detail="Not configured properly. Verify manually from output."
   fi
fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.6.2 Ensure local login warning banner is configured properly"
echo "$testcase"
detail=""
output1=$(cat "/etc/issue")
output2=$(grep -E -i "(\\\v|\\\r|\\\m|\\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g'))" /etc/issue)
echo "$output1"
echo "$output2"
status="Pending"
detail="Verify manually from output."
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.6.3 Ensure remote login warning banner is configured properly"
echo "$testcase"
detail=""
output1=$(cat /etc/issue)
output2=$(grep -E -i "(\\\v|\\\r|\\\m|\\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g'))" /etc/issue.net)
echo "$output1"
echo "$output2"
status="Pending"
detail="Verify manually from output."
detail=$(echo "$detail" | tr '\n,' ' ')

echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.6.4 Ensure access to /etc/motd is configured"
output=$([ -e /etc/motd ] && stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /etc/motd)
if [[ -z "$output" ]]; then
   status="PASS"
else
   if [[ $output == *"(0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)"* ]]; then
      status="PASS"
   else
      status="FAIL"
      detail=$output
   fi
fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.6.5 Ensure access to /etc/issue is configured"
echo "$testcase"
detail=""
output=$(stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: { %g/ %G)' /etc/issue)
if [[ $output == *"(0644/-rw-r--r--) Uid: ( 0/ root) Gid: { 0/ root)"* ]]; then
   detail=""
   status="PASS"
else
   status="FAIL"
   detail=$output
fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.6.6 Ensure access to /etc/issue.net is configured"
echo "$testcase"
detail=""
output=$(stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: { %g/ %G)' /etc/issue.net)
if [[ $output == *"(0644/-rw-r--r--) Uid: ( 0/ root) Gid: { 0/ root)"* ]]; then
   detail=""
   status="PASS"
else
   status="FAIL"
   detail=$output
fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.7.1 Check if GDM is installed"
echo "$testcase"
detail=""
gdmoutput=""
output=$(dpkg-query -s gdm3 &>/dev/null && echo "gdm3 is installed")
if [[ -z "$output" ]]; then
   gdmoutput="FALSE"
else
   gdmoutput="TRUE"
fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"

if [[ $gdmoutput == "TRUE" ]]; then

testcase="1.7.2 Ensure GDM login banner is configured"

echo "$testcase"
detail=""
output=$({
   l_pkgoutput=""
   if command -v dpkg-query &> /dev/null; then
      l_pq="dpkg-query -s"
   elif command -v rpm &> /dev/null; then
      l_pq="rpm -q"
   fi
   l_pcl="gdm gdm3" # Space separated list of packages to check
   for l_pn in $l_pcl; do
      $l_pq "$l_pn" &> /dev/null && l_pkgoutput="$l_pkgoutput\n - Package: \"$l_pn\" exists on the system\n - checking configuration"
   done
   if [ -n "$l_pkgoutput" ]; then
      l_output="" l_output2=""
      echo -e "$l_pkgoutput"
      # Look for existing settings and set variables if they exist
      l_gdmfile="$(grep -Prils '^\h*banner-message-enable\b' /etc/dconf/db/*.d)"
      if [ -n "$l_gdmfile" ]; then
         # Set profile name based on dconf db directory ({PROFILE_NAME}.d)
         l_gdmprofile="$(awk -F\/ '{split($(NF-1),a,".");print a[1]}' <<< "$l_gdmfile")"
         # Check if banner message is enabled
         if grep -Pisq '^\h*banner-message-enable=true\b' "$l_gdmfile"; then
            l_output="$l_output\n - The \"banner-message-enable\" option is enabled in \"$l_gdmfile\""
         else
            l_output2="$l_output2\n - The \"banner-message-enable\" option is not enabled"
         fi
         l_lsbt="$(grep -Pios '^\h*banner-message-text=.*$' "$l_gdmfile")"
         if [ -n "$l_lsbt" ]; then
            l_output="$l_output\n - The \"banner-message-text\" option is set in \"$l_gdmfile\"\n  - banner-message-text is set to:\n  - \"$l_lsbt\""
         else
            l_output2="$l_output2\n - The \"banner-message-text\" option is not set"
         fi
         if grep -Pq "^\h*system-db:$l_gdmprofile" /etc/dconf/profile/"$l_gdmprofile"; then
            l_output="$l_output\n - The \"$l_gdmprofile\" profile exists"
         else
            l_output2="$l_output2\n - The \"$l_gdmprofile\" profile doesn't exist"
         fi
         if [ -f "/etc/dconf/db/$l_gdmprofile" ]; then
            l_output="$l_output\n - The \"$l_gdmprofile\" profile exists in the dconf database"
         else
            l_output2="$l_output2\n - The \"$l_gdmprofile\" profile doesn't exist in the dconf database"
         fi
      else
         l_output2="$l_output2\n - The \"banner-message-enable\" option isn't configured"
      fi
   else
      echo -e "\n\n - GNOME Desktop Manager isn't installed\n - Recommendation is Not Applicable\n- Audit result:\n  *** PASS ***\n"
   fi
   # Report results. If no failures output in l_output2, we pass
   if [ -z "$l_output2" ]; then
      echo -e "\n- Audit Result:\n  ** PASS **\n$l_output\n"
   else
      echo -e "\n- Audit Result:\n  ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
      [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
   fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.7.3 Ensure GDM disable-user-list option is enabled"

resoutput=$({
   l_pkgoutput=""
   if command -v dpkg-query &> /dev/null; then
      l_pq="dpkg-query -s"
   elif command -v rpm &> /dev/null; then
      l_pq="rpm -q"
   fi
   l_pcl="gdm gdm3" # Space separated list of packages to check
   for l_pn in $l_pcl; do
      $l_pq "$l_pn" &> /dev/null && l_pkgoutput="$l_pkgoutput\n - Package: \"$l_pn\" exists on the system\n - checking configuration"
   done
   if [ -n "$l_pkgoutput" ]; then
      output="" output2=""
      l_gdmfile="$(grep -Pril '^\h*disable-user-list\h*=\h*true\b' /etc/dconf/db)"
      if [ -n "$l_gdmfile" ]; then
         output="$output\n - The \"disable-user-list\" option is enabled in \"$l_gdmfile\""
         l_gdmprofile="$(awk -F\/ '{split($(NF-1),a,".");print a[1]}' <<< "$l_gdmfile")"
         if grep -Pq "^\h*system-db:$l_gdmprofile" /etc/dconf/profile/"$l_gdmprofile"; then
            output="$output\n - The \"$l_gdmprofile\" exists"
         else
            output2="$output2\n - The \"$l_gdmprofile\" doesn't exist"
         fi
         if [ -f "/etc/dconf/db/$l_gdmprofile" ]; then
            output="$output\n - The \"$l_gdmprofile\" profile exists in the dconf database"
         else
            output2="$output2\n - The \"$l_gdmprofile\" profile doesn't exist in the dconf database"
         fi
      else
         output2="$output2\n - The \"disable-user-list\" option is not enabled"
      fi
      if [ -z "$output2" ]; then
         echo -e "$l_pkgoutput\n- Audit result:\n   *** PASS: ***\n$output\n"
      else
         echo -e "$l_pkgoutput\n- Audit Result:\n   *** FAIL: ***\n$output2\n"
         [ -n "$output" ] && echo -e "$output\n"
      fi
   else
      echo -e "\n\n - GNOME Desktop Manager isn't installed\n - Recommendation is Not Applicable\n- Audit result:\n  *** PASS ***\n"
   fi
})

if [[ "$resoutput" =~ '*** PASS ***' ]]; then
status='PASS';
else
status='FAIL';
detail=$output
fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.7.4 Ensure GDM screen locks when the user is idle"
echo "$testcase"
detail=""
output1=$(gsettings get org.gnome.desktop.screensaver lock-delay)
output2=$(gsettings get org.gnome.desktop.session idle-delay)

if [[ $output1 == *"uint32 5"* || $output2 == *"uint32 900"* ]]; then
   status="PASS"
else
   status="FAIL"
   detail="Lock time not idle"
fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo -e "$output1\n$output2"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.7.5 Ensure GDM screen locks cannot be overridden"

echo "$testcase"
detail=""
output=$({
   # Check if GNOME Desktop Manager is installed. If package isn't installed, recommendation is Not Applicable
   # Determine system's package manager
   l_pkgoutput=""
   if command -v dpkg-query > /dev/null 2>&1; then
      l_pq="dpkg-query -s"
   elif command -v rpm > /dev/null 2>&1; then
      l_pq="rpm -q"
   fi
   # Check if GDM is installed
   l_pcl="gdm gdm3" # Space-separated list of packages to check
   for l_pn in $l_pcl; do
      $l_pq "$l_pn" > /dev/null 2>&1 && l_pkgoutput="$l_pkgoutput\n - Package: \"$l_pn\" exists on the system\n - checking configuration"
   done
   # Check configuration (If applicable)
   if [ -n "$l_pkgoutput" ]; then
      l_output="" l_output2=""
      # Check if the idle-delay is locked
      if grep -Psrilq '^\h*idle-delay\h*=\h*uint32\h+\d+\b' /etc/dconf/db/*/; then
         if grep -Prilq '\/org\/gnome\/desktop\/session\/idle-delay\b' /etc/dconf/db/*/locks; then
            l_output="$l_output\n - \"idle-delay\" is locked"
         else
            l_output2="$l_output2\n - \"idle-delay\" is not locked"
         fi
      else
         l_output2="$l_output2\n - \"idle-delay\" is not set so it cannot be locked"
      fi
      # Check if the lock-delay is locked
      if grep -Psrilq '^\h*lock-delay\h*=\h*uint32\h+\d+\b' /etc/dconf/db/*/; then
         if grep -Prilq '\/org\/gnome\/desktop\/screensaver\/lock-delay\b' /etc/dconf/db/*/locks; then
            l_output="$l_output\n - \"lock-delay\" is locked"
         else
            l_output2="$l_output2\n - \"lock-delay\" is not locked"
         fi
      else
         l_output2="$l_output2\n - \"lock-delay\" is not set so it cannot be locked"
      fi
   else
      l_output="$l_output\n - GNOME Desktop Manager package is not installed on the system\n  - Recommendation is not applicable"
   fi
   # Report results. If no failures output in l_output2, we pass
   [ -n "$l_pkgoutput" ] && echo -e "\n$l_pkgoutput"
   if [ -z "$l_output2" ]; then
      echo -e "\n- Audit Result:\n  ** PASS **\n$l_output\n"
   else
      echo -e "\n- Audit Result:\n  ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
      [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
   fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.7.6 Ensure GDM automatic mounting of removable media is disabled"

echo "$testcase"
detail=""
output=$({
   l_pkgoutput="" l_output="" l_output2=""
   # Check if GNOME Desktop Manager is installed.  If package isn't installed, recommendation is Not Applicable\n
   # determine system's package manager
   if command -v dpkg-query > /dev/null 2>&1; then
      l_pq="dpkg-query -s"
   elif command -v rpm > /dev/null 2>&1; then
      l_pq="rpm -q"
   fi
   # Check if GDM is installed
   l_pcl="gdm gdm3" # Space seporated list of packages to check
   for l_pn in $l_pcl; do
      $l_pq "$l_pn" > /dev/null 2>&1 && l_pkgoutput="$l_pkgoutput\n - Package: \"$l_pn\" exists on the system\n - checking configuration"
   done
   # Check configuration (If applicable)
   if [ -n "$l_pkgoutput" ]; then
      echo -e "$l_pkgoutput"
      # Look for existing settings and set variables if they exist
      l_kfile="$(grep -Prils -- '^\h*automount\b' /etc/dconf/db/*.d)"
      l_kfile2="$(grep -Prils -- '^\h*automount-open\b' /etc/dconf/db/*.d)"
      # Set profile name based on dconf db directory ({PROFILE_NAME}.d)
      if [ -f "$l_kfile" ]; then
         l_gpname="$(awk -F\/ '{split($(NF-1),a,".");print a[1]}' <<< "$l_kfile")"
      elif [ -f "$l_kfile2" ]; then
         l_gpname="$(awk -F\/ '{split($(NF-1),a,".");print a[1]}' <<< "$l_kfile2")"
      fi
      # If the profile name exist, continue checks
      if [ -n "$l_gpname" ]; then
         l_gpdir="/etc/dconf/db/$l_gpname.d"
         # Check if profile file exists
         if grep -Pq -- "^\h*system-db:$l_gpname\b" /etc/dconf/profile/*; then
            l_output="$l_output\n - dconf database profile file \"$(grep -Pl -- "^\h*system-db:$l_gpname\b" /etc/dconf/profile/*)\" exists"
         else
            l_output2="$l_output2\n - dconf database profile isn't set"
         fi
         # Check if the dconf database file exists
         if [ -f "/etc/dconf/db/$l_gpname" ]; then
            l_output="$l_output\n - The dconf database \"$l_gpname\" exists"
         else
            l_output2="$l_output2\n - The dconf database \"$l_gpname\" doesn't exist"
         fi
         # check if the dconf database directory exists
         if [ -d "$l_gpdir" ]; then
            l_output="$l_output\n - The dconf directory \"$l_gpdir\" exitst"
         else
            l_output2="$l_output2\n - The dconf directory \"$l_gpdir\" doesn't exist"
         fi
         # check automount setting
         if grep -Pqrs -- '^\h*automount\h*=\h*false\b' "$l_kfile"; then
            l_output="$l_output\n - \"automount\" is set to false in: \"$l_kfile\""
         else
            l_output2="$l_output2\n - \"automount\" is not set correctly"
         fi
         # check automount-open setting
         if grep -Pqs -- '^\h*automount-open\h*=\h*false\b' "$l_kfile2"; then
            l_output="$l_output\n - \"automount-open\" is set to false in: \"$l_kfile2\""
         else
            l_output2="$l_output2\n - \"automount-open\" is not set correctly"
         fi
      else
         # Setings don't exist. Nothing further to check
         l_output2="$l_output2\n - neither \"automount\" or \"automount-open\" is set"
      fi
   else
      l_output="$l_output\n - GNOME Desktop Manager package is not installed on the system\n  - Recommendation is not applicable"
   fi
   # Report results. If no failures output in l_output2, we pass
   if [ -z "$l_output2" ]; then
      echo -e "\n- Audit Result:\n  ** PASS **\n$l_output\n"
   else
      echo -e "\n- Audit Result:\n  ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
      [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
   fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.7.7 Ensure GDM disabling automatic mounting of removable media is not overridden"

echo "$testcase"
detail=""
output=$({
   # Check if GNOME Desktop Manager is installed.
   l_pkgoutput=""
   if command -v dpkg-query &> /dev/null; then
      l_pq="dpkg-query -s"
   elif command -v rpm &> /dev/null; then
      l_pq="rpm -q"
   fi
   l_pcl="gdm gdm3" # space-separated list of packages to check
   for l_pn in $l_pcl; do
      $l_pq "$l_pn" &> /dev/null && l_pkgoutput="$l_pkgoutput\n - Package: \"$l_pn\" exists on the system\n - Checking configuration"
   done
   # Check for GDM configuration (If applicable)
   if [ -n "$l_pkgoutput" ]; then
      l_output=""
      l_output2=""
      # Search /etc/dconf/db/local.d/ for automount settings
      l_automount_setting=$(grep -Psir -- '^\h*automount=false\b' /etc/dconf/db/local.d/*)
      l_automount_open_setting=$(grep -Psir -- '^\h*automount-open=false\b' /etc/dconf/db/local.d/*)
      # Check for automount setting
      if [[ -n "$l_automount_setting" ]]; then
         l_output="$l_output\n - \"automount\" setting found"
      else
         l_output2="$l_output2\n - \"automount\" setting not found"
      fi
      # Check for automount-open setting
      if [[ -n "$l_automount_open_setting" ]]; then
         l_output="$l_output\n - \"automount-open\" setting found"
      else
         l_output2="$l_output2\n - \"automount-open\" setting not found"
      fi
   else
      l_output="$l_output\n - GNOME Desktop Manager package is not installed on the system\n  - Recommendation is not applicable"
   fi
   # Report results. If no failures in l_output2, we pass
   [ -n "$l_pkgoutput" ] && echo -e "\n$l_pkgoutput"
   if [ -z "$l_output2" ]; then
      echo -e "\n- Audit Result:\n  ** PASS **\n$l_output\n"
   else
      echo -e "\n- Audit Result:\n  ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
      [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
   fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.7.8 Ensure GDM autorun-never is enabled"

echo "$testcase"
detail=""
output=$({
   l_pkgoutput="" l_output="" l_output2=""
   # Check if GNOME Desktop Manager is installed.  If package isn't installed, recommendation is Not Applicable\n
   # determine system's package manager
   if command -v dpkg-query &> /dev/null; then
      l_pq="dpkg-query -s"
   elif command -v rpm &> /dev/null; then
      l_pq="rpm -q"
   fi
   # Check if GDM is installed
   l_pcl="gdm gdm3" # Space separated list of packages to check
   for l_pn in $l_pcl; do
      $l_pq "$l_pn" &> /dev/null && l_pkgoutput="$l_pkgoutput\n - Package: \"$l_pn\" exists on the system\n - checking configuration"
      echo -e "$l_pkgoutput"
   done
   # Check configuration (If applicable)
   if [ -n "$l_pkgoutput" ]; then
      echo -e "$l_pkgoutput"
      # Look for existing settings and set variables if they exist
      l_kfile="$(grep -Prils -- '^\h*autorun-never\b' /etc/dconf/db/*.d)"
      # Set profile name based on dconf db directory ({PROFILE_NAME}.d)
      if [ -f "$l_kfile" ]; then
         l_gpname="$(awk -F\/ '{split($(NF-1),a,".");print a[1]}' <<< "$l_kfile")"
      fi
      # If the profile name exist, continue checks
      if [ -n "$l_gpname" ]; then
         l_gpdir="/etc/dconf/db/$l_gpname.d"
         # Check if profile file exists
         if grep -Pq -- "^\h*system-db:$l_gpname\b" /etc/dconf/profile/*; then
            l_output="$l_output\n - dconf database profile file \"$(grep -Pl -- "^\h*system-db:$l_gpname\b" /etc/dconf/profile/*)\" exists"
         else
            l_output2="$l_output2\n - dconf database profile isn't set"
         fi
         # Check if the dconf database file exists
         if [ -f "/etc/dconf/db/$l_gpname" ]; then
            l_output="$l_output\n - The dconf database \"$l_gpname\" exists"
         else
            l_output2="$l_output2\n - The dconf database \"$l_gpname\" doesn't exist"
         fi
         # check if the dconf database directory exists
         if [ -d "$l_gpdir" ]; then
            l_output="$l_output\n - The dconf directory \"$l_gpdir\" exitst"
         else
            l_output2="$l_output2\n - The dconf directory \"$l_gpdir\" doesn't exist"
         fi
         # check autorun-never setting
         if grep -Pqrs -- '^\h*autorun-never\h*=\h*true\b' "$l_kfile"; then
            l_output="$l_output\n - \"autorun-never\" is set to true in: \"$l_kfile\""
         else
            l_output2="$l_output2\n - \"autorun-never\" is not set correctly"
         fi
      else
         # Settings don't exist. Nothing further to check
         l_output2="$l_output2\n - \"autorun-never\" is not set"
      fi
   else
      l_output="$l_output\n - GNOME Desktop Manager package is not installed on the system\n  - Recommendation is not applicable"
   fi
   # Report results. If no failures output in l_output2, we pass
   if [ -z "$l_output2" ]; then
      echo -e "\n- Audit Result:\n  ** PASS **\n$l_output\n"
   else
      echo -e "\n- Audit Result:\n  ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
      [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
   fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.7.9 Ensure GDM autorun-never is not overridden"

echo "$testcase"
detail=""
output=$({
   # Check if GNOME Desktop Manager is installed.  If package isn't installed, recommendation is Not Applicable\n
   # determine system's package manager
   l_pkgoutput=""
   if command -v dpkg-query &> /dev/null; then
      l_pq="dpkg-query -s"
   elif command -v rpm &> /dev/null; then
      l_pq="rpm -q"
   fi
   # Check if GDM is installed
   l_pcl="gdm gdm3" # Space separated list of packages to check
   for l_pn in $l_pcl; do
      $l_pq "$l_pn" &> /dev/null && l_pkgoutput="$l_pkgoutput\n - Package: \"$l_pn\" exists on the system\n - checking configuration"
   done
   # Search /etc/dconf/db/ for [org/gnome/desktop/media-handling] settings)
    l_desktop_media_handling=$(grep -Psir -- '^\h*\[org/gnome/desktop/media-handling\]' /etc/dconf/db/*)
    if [[ -n "$l_desktop_media_handling" ]]; then
        l_output="" l_output2=""
        l_autorun_setting=$(grep -Psir -- '^\h*autorun-never=true\b' /etc/dconf/db/local.d/*)
        # Check for auto-run setting
        if [[ -n "$l_autorun_setting" ]]; then
            l_output="$l_output\n - \"autorun-never\" setting found"
        else
            l_output2="$l_output2\n - \"autorun-never\" setting not found"
        fi
    else
         l_output="$l_output\n - [org/gnome/desktop/media-handling] setting not found in /etc/dconf/db/*"
    fi
   # Report results. If no failures output in l_output2, we pass
	[ -n "$l_pkgoutput" ] && echo -e "\n$l_pkgoutput"
   if [ -z "$l_output2" ]; then
      echo -e "\n- Audit Result:\n  ** PASS **\n$l_output\n"
   else
      echo -e "\n- Audit Result:\n  ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
      [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
   fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"

echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.7.10 Ensure XDCMP is not enabled"
echo "$testcase"
detail=""
output=$({
   while IFS= read -r l_file; do
      /bin/awk '/\[xdmcp\]/{ f = 1;next } /\[/{ f = 0 } f {if (/^\s*Enable\s*=\s*true/) print "The file: \"'"$l_file"'\" includes: \"" $0 "\" in the \"[xdmcp]\" block"}' "$l_file"
   done < <(/bin/grep -Psil -- '^\h*\[xdmcp\]' /etc/{gdm3,gdm}/{custom,daemon}.conf)
} | /bin/awk '{print} END {if (NR == 0) print "PASS"; else print "FAIL"}')
if [[ -z "$output" ]]; then
   status="PASS"
else
   status="FAIL"
   detail="XDCMP is enabled"
fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

fi


testcase="2.1.1 Ensure autofs services are not in use"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s autofs 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ -n "$output" ]]; then
   status="PASS"
else
   output1=$(/bin/systemctl is-active autofs.service 2>/dev/null | /bin/grep '^active')
   output2=$(/bin/systemctl is-enabled autofs.service 2>/dev/null | /bin/grep 'enabled')
   detail="$output1"$'\n'"$output2"
   if [[ -z "$output1" && -z "$output2" ]]; then
      status="PASS"
   else
      status="FAIL"
      detail="active or enabled"
   fi
   echo "autofs.service active -> $output1"
   echo "autofs.service enabled -> $output2"
fi
echo "autofs installed -> $output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="2.1.2 Ensure avahi daemon services are not in use"
output=$(/bin/dpkg -s avahi-daemon 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ -n "$output" ]]; then
   status="PASS"
else
   output1=$(systemctl is-enabled avahi-daemon.socket avahi-daemon.service 2>/dev/null | grep 'enabled')
   output2=$(systemctl is-active avahi-daemon.socket avahi-daemon.service 2>/dev/null | grep '^active')
   if [[ -z "$output1" && -z "$output2" ]]; then
      status="PASS"
   else
      status="FAIL"
      detail="active or enabled"
   fi
   echo "avahi-daemon enabled -> $output1"
   echo "avahi-daemon active -> $output2"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="2.1.3 Ensure dhcp server services are not in use"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s isc-dhcp-server 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ -n $output ]]; then
   status="PASS"
else
   output1=$(systemctl is-enabled isc-dhcp-server.service isc-dhcp-server6.service 2>/dev/null | grep 'enabled')
   output2=$(systemctl is-active isc-dhcp-server.service isc-dhcp-server6.service 2>/dev/null | grep '^active')
   if [[ -z "$output1" && -z "$output2" ]]; then
      status="PASS"
   else
      status="FAIL"
      detail="active or enabled"
   fi
   echo "dhcp server enabled -> $output1"
   echo "dhcp server active -> $output2"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.1.4 Ensure dns server services are not in use"
echo "$testcase"
detail=""

output=$(/bin/dpkg -s bind9 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ -n $output ]]; then
   status="PASS"
else
   output1=$(/bin/systemctl is-enabled bind9.service 2>/dev/null | /bin/grep '^enabled')
   output2=$(/bin/systemctl is-active bind9.service 2>/dev/null | /bin/grep '^active')
   if [[ -z "$output1" && -z "$output2" ]]; then
      status="PASS"
   else
      status="FAIL"
      detail="service is installed or enabled"
   fi
   echo "bind9 service enabled -> $output1"
   echo "bind9 service active -> $output2"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="2.1.5 Ensure dnsmasq services are not in use"
echo "$testcase"
detail=""

echo "dnsmasq services exist"
output=$(/bin/dpkg -s dnsmasq 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ -n $output ]]; then
   status="PASS"
else 
   output1=$(/bin/systemctl is-active dnsmasq.service 2>/dev/null | /bin/grep '^active')
   output2=$(/bin/systemctl is-enabled dnsmasq.service 2>/dev/null | /bin/grep 'enabled')
   if [[ -z "$output1" && -z "$output2" ]]; then
      status="PASS"
   else
      status="FAIL"
      detail="dnsmasq service enabled or installed"
   fi
   echo "dnsmasq.service active -> $output1"
   echo "dnsmasq.service enabled -> $output2"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.1.6 Ensure ftp server services are not in use"
echo "$testcase"
detail=""

echo "ftp services exist"
output=$(/bin/dpkg -s vsftpd 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ -n $output ]]; then
   status="PASS"
else 
   output1=$(/bin/systemctl is-active vsftpd.service 2>/dev/null | /bin/grep '^active')
   output2=$(/bin/systemctl is-enabled vsftpd.service 2>/dev/null | /bin/grep 'enabled')
   if [[ -z "$output1" && -z "$output2" ]]; then
      status="PASS"
   else
      status="FAIL"
      detail="vsftpd service enabled or installed"
   fi
   echo "vsftpd.service active"
   echo "vsftpd.service enabled"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="2.1.7 Ensure ldap server services are not in use"
echo "$testcase"
detail=""

echo "installed"
output=$(/bin/dpkg -s slapd 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ -n $output ]]; then 
   status="PASS"
else
   output1=$(/bin/systemctl is-enabled slapd.service 2>/dev/null | /bin/grep '^enabled')
   output2=$(/bin/systemctl is-active slapd.service 2>/dev/null | /bin/grep '^active')
   if [[ -z "$output1" && -z "$output2" ]]; then
      status="PASS"
   else
      status="FAIL"
      detail="enabled or active"
   fi
   echo "enabled -> $output1"
   echo "active -> $output2"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="2.1.8 Ensure message access server services are not in use"
echo "$testcase"
detail=""
output_imapd=$(dpkg-query -s dovecot-imapd &>/dev/null && echo "dovecot-imapd is installed")
output_pop3d=$(dpkg-query -s dovecot-pop3d &>/dev/null && echo "dovecot-pop3d is installed")
if [[ -z "$output_imapd" && -z "$output_pop3d" ]]; then
   status="PASS"
else
   output1=$(/bin/systemctl is-active dovecot.socket 2>/dev/null | /bin/grep '^active')
   output2=$(/bin/systemctl is-enabled dovecot.service 2>/dev/null | /bin/grep '^enabled')
   if [[ -z "$output1" && -z  "$output2" ]]; then
      status="PASS"
   else
      status="FAIL"
      detail="dovecot enabled or active"
   fi
   echo "dovecot active -> $output1"
   echo "dovecot enabled -> $output2"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="2.1.9 Ensure network file system services are not in use"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s nfs-kernel-server 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ -n $output ]]; then 
   status="PASS"
else
   output1=$(systemctl is-enabled nfs-server.service 2>/dev/null | grep 'enabled')
   output2=$(systemctl is-active nfs-server.service 2>/dev/null | grep '^active')
   if [[ -z "$output1" && -z "$output2" ]]; then
      status="PASS"
   else
      status="FAIL"
      detail="nfs enabled or active"
   fi
   echo "enabled -> $output1"
   echo "active -> $output2"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.1.10 Ensure nis server services are not in use"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s ypserv 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ -n "$output" ]]; then
   status="PASS"
else
   output1=$(systemctl is-enabled ypserv.service 2>/dev/null | grep 'enabled')
   output2=$(systemctl is-active ypserv.service 2>/dev/null | grep '^active')
   if [[ -z "$output1" && -z "$output2" ]]; then
      status="PASS"
   else
      status="FAIL"
      detail=""
   fi
   echo "enabled -> $output1"
   echo "active -> $output2"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.1.11 Ensure print server services are not in use"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s cups 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ -n "$output" ]]; then
   status="PASS"
else
   output1=$(systemctl is-enabled cups.socket cups.service 2>/dev/null | grep 'enabled')
   output2=$(systemctl is-active cups.socket cups.service 2>/dev/null | grep '^active')
   if [[ -z "$output1" && -z "$output2" ]]; then
      status="PASS"
   else
      status="FAIL"
      detail="cups enabled or active"
   fi
   echo "enabled -> $output1"
   echo "active -> $output2"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.1.12 Ensure rpcbind services are not in use"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s rpcbind 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ -n "$output" ]]; then
   status="PASS"
else
   output1=$(/bin/systemctl is-active rpcbind.socket rpcbind.service 2>/dev/null | grep '^active')
   output2=$(/bin/systemctl is-enabled rpcbind.socket rpcbind.service 2>/dev/null | grep 'enabled')
   if [[ -z "$output1" && -z "$output2" ]]; then
      status="PASS"
   else
      status="FAIL"
      detail="rpcbind enabled or active"
   fi
   echo "active -> $output1"
   echo "enabled -> $output2"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.1.13 Ensure rsync services are not in use"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s rsync 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ -n "$output" ]]; then 
   status="PASS"
else
   output1=$(/bin/systemctl is-enabled smbd.service 2>/dev/null | /bin/grep '^enabled')
   output2=$(/bin/systemctl is-active smbd.service 2>/dev/null | /bin/grep '^active')
   if [[ -z "$output1" && -z "$output2" ]]; then
      status="PASS"
   else
      status="FAIL"
      detail="rsync enabled or active"
   fi
   echo "enabled -> $output1"
   echo "active -> $output2"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.1.14 Ensure samba file server services are not in use"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s samba 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ -n "$output" ]]; then
   status="PASS"
else
   output1=$(/bin/systemctl is-active smbd.service 2>/dev/null | /bin/grep '^active')
   output2=$(/bin/systemctl is-enabled smbd.service 2>/dev/null | /bin/grep '^enabled')
   if [[ -z "$output1" && -z "$output2" ]]; then
      status="PASS"
   else
      status="FAIL"
      detail="samba enabled or active"
   fi
   echo "enabled -> $output1"
   echo "active -> $output2"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.1.15 Ensure snmp services are not in use"
echo "$testcase"
detail=""
output=$(dpkg-query -s snmpd &>/dev/null && echo "snmpd is installed")
if [[ -z "$output" ]]; then 
   status="PASS"
else
   output1=$(/bin/systemctl is-enabled snmpd.service 2>/dev/null | /bin/grep '^enabled')
   output2=$(/bin/systemctl is-active snmpd.service 2>/dev/null | /bin/grep '^active')
   if [[ -z "$output1" && -z "$output2" ]]; then
      status="PASS"
   else
      status="FAIL"
      detail="snmpd service enabled or active"
   fi
   echo "enabled -> $output1"
   echo "active -> $output2" 
fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.1.16 Ensure tftp server services are not in use"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s tftpd-hpa 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ -n "$output" ]]; then 
   status="PASS"
else
   output1=$(/bin/systemctl is-active tftpd-hpa.service 2>/dev/null | /bin/grep '^active')
   output2=$(/bin/systemctl is-enabled tftpd-hpa.service 2>/dev/null | /bin/grep 'enabled')
   if [[ -z "$output1" && -z "$output2" ]]; then
      status="PASS"
   else
      status="FAIL"
      detail="tftp server enabled or active"
   fi
   echo "squid.service active -> $output1"
   echo "squid.service enabled -> $output2"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.1.17 Ensure web proxy server services are not in use"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s squid 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ -n "$output" ]]; then 
   status="PASS"
else
   output1=$(/bin/systemctl is-enabled squid.service 2>/dev/null | /bin/grep 'enabled')
   output2=$(/bin/systemctl is-active squid.service 2>/dev/null | /bin/grep '^active')
   if [[ -z "$output1" && -z "$output2" ]]; then
      status="PASS"
   else
      status="FAIL"
      detail="squid service enabled or active"
   fi
fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.1.18 Ensure web server services are not in use"
echo "$testcase"
detail=""
output_apache=$(dpkg-query -s apache2 &>/dev/null && echo "apache2 is installed")
output_nginx=$(dpkg-query -s nginx &>/dev/null && echo "nginx is installed")
if [[ -z "$output_apache" && -z "$output_nginx" ]]; then 
   status="PASS"
else 
   output1=$(systemctl is-enabled apache2.socket apache2.service nginx.service 2>/dev/null | grep 'enabled')
   output2=$(systemctl is-active apache2.socket apache2.service nginx.service 2>/dev/null | grep '^active')
   if [[ -z "$output1" && -z "$output2" ]]; then
      status="PASS"
   else
      status="FAIL"
      detail="apache2 nginx enabled or active"
   fi
   echo "enabled -> $output1"
   echo "active -> $output2"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.1.19 Ensure xinetd services are not in use"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s xinetd 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ -n "$output" ]]; then 
   status="PASS"
else
   output1=$(/bin/systemctl is-enabled xinetd.service 2>/dev/null | /bin/grep 'enabled')
   output2=$(/bin/systemctl is-active xinetd.service 2>/dev/null | /bin/grep '^active')
   if [[ -z "$output1" && -z "$output2" ]]; then
      status="PASS"
   else
      status="FAIL"
      detail="xinetd enabled or active"
   fi
   echo "enabled -> $output1"
   echo "active -> $output2"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.1.21 Ensure mail transfer agent is configured for local-only mode"
echo "$testcase"
detail=""
output=$({
l_output=""
l_output2=""
a_port_list=("25" "465" "587")

# Check if inet_interfaces is not set to all
if [ "$(postconf -n inet_interfaces)" != "inet_interfaces = all" ]; then
    for l_port_number in "${a_port_list[@]}"; do
        if ss -plntu | grep -P -- ':'"$l_port_number"'\b' | grep -Pvq -- '\h+(127\.0\.0\.1|\[?::1\]?):'"$l_port_number"'\b'; then
            l_output2="$l_output2\n - Port \"$l_port_number\" is listening on a non-loopback network interface"
        else
            l_output="$l_output\n - Port \"$l_port_number\" is not listening on a non-loopback network interface"
        fi
    done
else
    l_output2="$l_output2\n - Postfix is bound to all interfaces"
fi

unset a_port_list

# Provide output from checks
if [ -z "$l_output2" ]; then
    echo -e "\n- Audit Result:\n  ** PASS **\n$l_output\n"
else
    # If error output (l_output2) is not empty, we fail. Also output anything that's correctly configured
    echo -e "\n- Audit Result:\n  ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
    [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.1.22 Ensure only approved services are listening on a network interface"
echo "$testcase"
detail=""
output=$(/bin/ss -plntu)
status="Pending"
detail="Verify manually"
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="2.2.1 Ensure NIS Client is not installed"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s nis 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ -n $output ]]; then status="PASS"; else status="FAIL" detail="nis client installed"; fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.2.2 Ensure rsh client is not installed"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s rsh-client 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ -n $output ]]; then status="PASS"; else status="FAIL" detail="rsh client installed"; fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.2.3 Ensure talk client is not installed"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s talk 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ -n $output ]]; then status="PASS"; else status="FAIL" detail="talk client installed"; fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.2.4 Ensure telnet client is not installed"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s telnet 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ -n $output ]]; then status="PASS"; else status="FAIL" detail="telnet client installed"; fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.2.5 Ensure ldap client is not installed"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s ldap-utils 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ -n $output ]]; then status="PASS"; else status="FAIL" detail="ldap client installed"; fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.2.6 Ensure ftp client is not installed"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s ftp 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ -n $output ]]; then status="PASS"; else status="FAIL" detail="ftp client installed"; fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.3.1.1 Ensure a single time synchronization daemon is in use"
echo "$testcase"
detail=""

output=$({
   l_output="" l_output2=""
   service_not_enabled_chk()
   {
      l_out2=""
      if systemctl is-enabled "$l_service_name" 2>/dev/null | grep -q 'enabled'; then
         l_out2="$l_out2\n  - Daemon: \"$l_service_name\" is enabled on the system"
      fi
      if systemctl is-active "$l_service_name" 2>/dev/null | grep -q '^active'; then
         l_out2="$l_out2\n  - Daemon: \"$l_service_name\" is active on the system"
      fi
   }
   l_service_name="systemd-timesyncd.service" # Check systemd-timesyncd daemon
   service_not_enabled_chk
   if [ -n "$l_out2" ]; then
      l_timesyncd="y"
      l_out_tsd="$l_out2"
   else
      l_timesyncd="n"
      l_out_tsd="\n  - Daemon: \"$l_service_name\" is not enabled and not active on the system"
   fi
   l_service_name="chrony.service" # Check chrony
   service_not_enabled_chk
   if [ -n "$l_out2" ]; then
      l_chrony="y"
      l_out_chrony="$l_out2"
   else
      l_chrony="n"
      l_out_chrony="\n  - Daemon: \"$l_service_name\" is not enabled and not active on the system"
   fi
   l_status="$l_timesyncd$l_chrony"
   
   if [ "$l_status" = "yy" ]; then
      l_output2=" - More than one time sync daemon is in use on the system$l_out_tsd$l_out_chrony"
   elif [ "$l_status" = "nn" ]; then
      l_output2=" - No time sync daemon is in use on the system$l_out_tsd$l_out_chrony"
   elif [ "$l_status" = "yn" ] || [ "$l_status" = "ny" ]; then
      l_output=" - Only one time sync daemon is in use on the system$l_out_tsd$l_out_chrony"
   else
      l_output2=" - Unable to determine time sync daemon(s) status"
   fi


    if [ -z "$l_output2" ]; then
        echo -e "\n- Audit Result:\n  ** PASS **\n$l_output\n"
    else
        echo -e "\n- Audit Result:\n  ** FAIL **\n - * Reasons for audit failure * :\n$l_output2\n"
    fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.3.2.1 Ensure systemd-timesyncd configured with authorized timeserver"
echo "$testcase"
detail=""
output=$({
   l_output="" l_output2=""
   a_parlist=("NTP=[^#\n\r]+" "FallbackNTP=[^#\n\r]+")
   l_systemd_config_file="/etc/systemd/timesyncd.conf" # Main systemd configuration file
   config_file_parameter_chk()
   {
      unset A_out; declare -A A_out # Check config file(s) setting
      while read -r l_out; do
         if [ -n "$l_out" ]; then
            if [[ $l_out =~ ^\s*# ]]; then
               l_file="${l_out//# /}"
            else
               l_systemd_parameter="$(awk -F= '{print $1}' <<< "$l_out" | xargs)"
               grep -Piq -- "^\h*$l_systemd_parameter_name\b" <<< "$l_systemd_parameter" && A_out+=(["$l_systemd_parameter"]="$l_file")
            fi
         fi
      done < <(/usr/bin/systemd-analyze cat-config "$l_systemd_config_file" | grep -Pio '^\h*([^#\n\r]+|#\h*\/[^#\n\r\h]+\.conf\b)')
      if (( ${#A_out[@]} > 0 )); then # Assess output from files and generate output
         while IFS="=" read -r l_systemd_file_parameter_name l_systemd_file_parameter_value; do
            l_systemd_file_parameter_name="${l_systemd_file_parameter_name// /}"
            l_systemd_file_parameter_value="${l_systemd_file_parameter_value// /}"
            if grep -Piq "^\h*$l_systemd_parameter_value\b" <<< "$l_systemd_file_parameter_value"; then
               l_output="$l_output\n - \"$l_systemd_parameter_name\" is correctly set to \"$l_systemd_file_parameter_value\" in \"$(printf '%s' "${A_out[@]}")\"\n"
            else
               l_output2="$l_output2\n - \"$l_systemd_parameter_name\" is incorrectly set to \"$l_systemd_file_parameter_value\" in \"$(printf '%s' "${A_out[@]}")\" and should have a value matching: \"$l_systemd_parameter_value\"\n"
            fi
         done < <(grep -Pio -- "^\h*$l_systemd_parameter_name\h*=\h*\H+" "${A_out[@]}")
      else
         l_output2="$l_output2\n - \"$l_systemd_parameter_name\" is not set in an included file\n   ** Note: \"$l_systemd_parameter_name\" May be set in a file that's ignored by load procedure **\n"
      fi
   }
   while IFS="=" read -r l_systemd_parameter_name l_systemd_parameter_value; do # Assess and check parameters
      l_systemd_parameter_name="${l_systemd_parameter_name// /}"
      l_systemd_parameter_value="${l_systemd_parameter_value// /}"
      config_file_parameter_chk
   done < <(printf '%s\n' "${a_parlist[@]}")
   if [ -z "$l_output2" ]; then # Provide output from checks
      echo -e "\n- Audit Result:\n  ** PASS **\n$l_output\n"
   else
      echo -e "\n- Audit Result:\n  ** FAIL **\n - Reason(s) for audit failure:\n$l_output2"
      [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
   fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.3.2.2 Ensure systemd-timesyncd is enabled and running"
echo "$testcase"
detail=""
echo "enabled"
output1=$(systemctl is-enabled systemd-timesyncd.service)
if [[ $output1 == "enabled" ]]; then status="PASS"; else status="FAIL" detail="service not enabled"; fi
echo "active"
output2=$(systemctl is-active systemd-timesyncd.service)
if [[ $output2 == "active" ]]; then status="PASS"; else status="FAIL" detail="service not active"; fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo -e "$output1\n$output2"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.3.3.1 Ensure chrony is configured with authorized timeserver"
echo "$testcase"
detail=""

output=$({
    l_output=""
    l_output2=""
    a_parlist=("^\h*(server|pool)\h+\H+")
    l_chrony_config_dir="/etc/chrony" # Chrony configuration directory
    config_file_parameter_chk() {
        unset A_out
        declare -A A_out
        while read -r l_out; do
            if [ -n "$l_out" ]; then
                if [[ $l_out =~ ^\s*# ]]; then
                    l_file="${l_out//# /}"
                else
                    l_chrony_parameter="$(awk -F= '{print $1}' <<< "$l_out" | xargs)"
                    A_out+=(["$l_chrony_parameter"]="$l_file")
                fi
            fi
        done < <(find "$l_chrony_config_dir" -name '*.conf' -exec systemd-analyze cat-config {} + | grep -Pio '^\h*((server|pool)\h+\H+|#\h*\/[^#\n\r\h]+\.conf\b)')

        if (( ${#A_out[@]} > 0 )); then
            for l_chrony_parameter in "${!A_out[@]}"; do
                l_file="${A_out[$l_chrony_parameter]}"
                l_output="$l_output\n - \"$l_chrony_parameter\" is set in \"$l_file\"\n"
            done
        else
            l_output2="$l_output2\n - No 'server' or 'pool' settings found in Chrony configuration files\n"
        fi
    }
    for l_chrony_parameter_regex in "${a_parlist[@]}"; do
        config_file_parameter_chk "$l_chrony_parameter_regex"
    done

    if [ -z "$l_output2" ]; then
        echo -e "\n- Audit Result:\n  ** PASS **\n$l_output\n"
    else
        echo -e "\n- Audit Result:\n  ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
        [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
    fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.3.3.2 Ensure chrony is running as user _chrony"
echo "$testcase"
detail=""

output=$(ps -ef | awk '(/[c]hronyd/ && $1!="_chrony") { print $1 }')
if [[ -z "$output" ]]; then status="PASS"; else status="FAIL" detail="not running as _chrony user"; fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.3.3.3 Ensure chrony is enabled and running"
echo "$testcase"
detail=""
echo "check if chrony is enabled"
output1=$(systemctl is-enabled chrony.service)
echo "$output1"
echo "check if chrony is active"
output2=$(systemctl is-active chrony.service)
echo "$output2"
if [[ $output1 == "enabled" && $output2 == "active" ]]; then status="PASS"; else status="FAIL" detail="not enabled or active"; fi
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.4.1.1 Ensure cron daemon is enabled and active"
echo "$testcase"
detail=""
output1=$(systemctl list-unit-files | awk '$1~/^crond?\.service/{print $2}')
if [[ $output1 == "enabled" ]]; then status="PASS"; else status="FAIL" detail="not enabled"; fi
output2=$(systemctl list-units | awk '$1~/^crond?\.service/{print $3}')
if [[ $output2 == "active" ]]; then status="PASS"; else status="FAIL" detail="not active"; fi
echo -e "$output1\n$output2"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.4.1.2 Ensure permissions on /etc/crontab are configured"
echo "$testcase"
detail=""
output=$(stat -Lc 'Access: (%a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /etc/crontab)

if [[ $output == *"Access: (600/-rw-------) Uid: ( 0/ root) Gid: ( 0/ root)"* ]]; then
   status="PASS"
else
   status="FAIL"
   detail="Permissions not properly set"
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.4.1.3 Ensure permissions on /etc/cron.hourly are configured"
echo "$testcase"
detail=""
output=$(stat -Lc 'Access: (%a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /etc/cron.hourly/)

if [[ $output == *"Access: (700/drwx------) Uid: ( 0/ root) Gid: ( 0/ root)"* ]]; then
   status="PASS"
else
   status="FAIL"
   detail="Permissions not properly set"
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.4.1.4 Ensure permissions on /etc/cron.daily are configured"
echo "$testcase"
detail=""
output=$(stat -Lc 'Access: (%a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /etc/cron.daily/)

if [[ $output == *"Access: (700/drwx------) Uid: ( 0/ root) Gid: ( 0/ root)"* ]]; then
   status="PASS"
else
   status="FAIL"
   detail="Permissions not properly set"
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.4.1.5 Ensure permissions on /etc/cron.weekly are configured"
echo "$testcase"
detail=""
output=$(stat -Lc 'Access: (%a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /etc/cron.weekly/)

if [[ $output == *"Access: (700/drwx------) Uid: ( 0/ root) Gid: ( 0/ root)"* ]]; then
   status="PASS"
else
   status="FAIL"
   detail="Permissions not properly set"
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.4.1.6 Ensure permissions on /etc/cron.monthly are configured"
echo "$testcase"
detail=""
output=$(stat -Lc 'Access: (%a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /etc/cron.monthly/)

if [[ $output == *"Access: (700/drwx------) Uid: ( 0/ root) Gid: ( 0/ root)"* ]]; then
   status="PASS"
else
   status="FAIL"
   detail="Permissions not properly set"
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.4.1.7 Ensure permissions on /etc/cron.d are configured"
echo "$testcase"
detail=""
output=$(stat -Lc 'Access: (%a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /etc/cron.d/)

if [[ $output == *"Access: (700/drwx------) Uid: ( 0/ root) Gid: ( 0/ root)"* ]]; then
   status="PASS"
else
   status="FAIL"
   detail="Permissions not properly set"
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.4.1.8 Ensure crontab is restricted to authorized users"
echo "$testcase"
detail=""
output1=$(stat -Lc 'Access: (%a/%A) Owner: (%U) Group: (%G)' /etc/cron.allow)
output2=$([ -e "/etc/cron.deny" ] && stat -Lc 'Access: (%a/%A) Owner: (%U) Group: (%G)' /etc/cron.deny)
if [[ $output1 =~ Access:[[:space:]]+\([0-6][0-4][0]/-rw-------\)[[:space:]]Owner:[[:space:]]\(root\)[[:space:]]Group:[[:space:]]\(root\) ]]; then
   if [[ -z "$output2" || $output2 =~ Access:[[:space:]]+\([0-6][0-4][0]/-rw-------\)[[:space:]]Owner:[[:space:]]\(root\)[[:space:]]Group:[[:space:]]\(root\) ]]; then
      status="PASS"
   else
      status="FAIL"
      detail="Error in cron.deny"
   fi
else
   status="FAIL"
   detail="Error in cron.allow"
fi
echo -e "$output1\n$output2"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.4.2.1 Ensure at is restricted to authorized users"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s at 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ $output == *"install ok installed"* ]]; then
   output1=$(stat -Lc 'Access: (%a/%A) Owner: (%U) Group: (%G)' /etc/at.allow)
   output2=$([ -e "/etc/at.deny" ] && stat -Lc 'Access: (%a/%A) Owner: (%U) Group: (%G)' /etc/at.deny)
   if [[ $output1 =~ Access:[[:space:]]+\([0-6][0-4][0]/-rw-------\)[[:space:]]Owner:[[:space:]]\(root\)[[:space:]]Group:[[:space:]]\((root|daemon)\) ]]; then   
      if [[ -z "$output2" || $output2 =~ Access:[[:space:]]+\([0-6][0-4][0]/-rw-------\)[[:space:]]Owner:[[:space:]]\(root\)[[:space:]]Group:[[:space:]]\((root|daemon)\) ]]; then
         status="PASS"
      else
         status="FAIL"
         detail="Permissions not properly set for at.deny"
      fi
   else
      status="FAIL"
      detail="Permissions not properly set for at.allow"
   fi
else
   status="NA"
   detail="at not installed"
fi
echo -e "$output\n$output1\n$output2"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.1.1 Ensure IPv6 status is identified"
echo "$testcase"
detail=""
output=$(/bin/grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable && echo -e "\n - IPv6 is enabled\n" || echo -e "\n - IPv6 is not enabled\n")
status="Pending"
detail="Verify manually"
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.1.2 Ensure wireless interfaces are disabled"
echo "$testcase"
detail=""
output=$({
        l_output="" l_output2=""
   module_chk()
   {
      # Check how module will be loaded
      l_loadable="$(modprobe -n -v "$l_mname")"
      if grep -Pq -- '^\h*install \/bin\/(true|false)' <<< "$l_loadable"; then
         l_output="$l_output
 - module: \"$l_mname\" is not loadable: \"$l_loadable\""
      else
         l_output2="$l_output2
 - module: \"$l_mname\" is loadable: \"$l_loadable\""
      fi
      # Check is the module currently loaded
      if ! lsmod | grep "$l_mname" > /dev/null 2>&1; then
         l_output="$l_output
 - module: \"$l_mname\" is not loaded"
      else
         l_output2="$l_output2
 - module: \"$l_mname\" is loaded"
      fi
      # Check if the module is deny listed
      if modprobe --showconfig | grep -Pq -- "^\h*blacklist\h+$l_mname\b"; then
         l_output="$l_output
 - module: \"$l_mname\" is deny listed in: \"$(grep -Pl -- "^\h*blacklist\h+$l_mname\b" /etc/modprobe.d/*)\""
      else
         l_output2="$l_output2
 - module: \"$l_mname\" is not deny listed"
      fi
   }
   if [ -n "$(find /sys/class/net/*/ -type d -name wireless)" ]; then
      l_dname=$(for driverdir in $(find /sys/class/net/*/ -type d -name wireless | xargs -0 dirname); do basename "$(readlink -f "$driverdir"/device/driver/module)";done | sort -u)
      for l_mname in $l_dname; do
         module_chk
      done
   fi
   # Report results. If no failures output in l_output2, we pass
   if [ -z "$l_output2" ]; then
      echo -e "
- Audit Result:
  ** PASS **"
      if [ -z "$l_output" ]; then
         echo -e "
 - System has no wireless NICs installed"
      else
         echo -e "
$l_output
"
      fi
   else
      echo -e "
- Audit Result:
  ** FAIL **
 - Reason(s) for audit failure:
$l_output2
"
      [ -n "$l_output" ] && echo -e "
- Correctly set:
$l_output
"
   fi
  })

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.1.3 Ensure bluetooth services are not in use"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s bluez 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ $output == *"not installed"* ]]; then 
   status="PASS"
else
   output1=$(/bin/systemctl is-active bluetooth.service 2>/dev/null | /bin/grep '^active')
   output2=$(/bin/systemctl is-enabled bluetooth.service 2>/dev/null | /bin/grep 'enabled')
   if [[ -z "$output1" && -z "$output2" ]]; then
      status="PASS"
   else
      status="FAIL"
      detail="enabled or active"
   fi
   echo "bluetooth.service active -> $outpu1"
   echo "bluetooth.service enabled -> $output2"
fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="3.3.1 Ensure ip forwarding is disabled"
echo "$testcase"
detail=""

output=$({
   l_output="" l_output2=""
   a_parlist=("net.ipv4.ip_forward=0" "net.ipv6.conf.all.forwarding=0")
   l_ufwscf="$([ -f /etc/default/ufw ] && awk -F= '/^\s*IPT_SYSCTL=/ {print $2}' /etc/default/ufw)"
   kernel_parameter_chk()
   {
      l_krp="$(sysctl "$l_kpname" | awk -F= '{print $2}' | xargs)" # Check running configuration
      if [ "$l_krp" = "$l_kpvalue" ]; then
         l_output="$l_output
 - \"$l_kpname\" is correctly set to \"$l_krp\" in the running configuration"
      else
         l_output2="$l_output2
 - \"$l_kpname\" is incorrectly set to \"$l_krp\" in the running configuration and should have a value of: \"$l_kpvalue\""
      fi
      unset A_out; declare -A A_out # Check durable setting (files)
      while read -r l_out; do
         if [ -n "$l_out" ]; then
            if [[ $l_out =~ ^\s*# ]]; then
               l_file="${l_out//# /}"
            else
               l_kpar="$(awk -F= '{print $1}' <<< "$l_out" | xargs)"
               [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_file")
            fi
         fi
      done < <(/usr/lib/systemd/systemd-sysctl --cat-config | grep -Po '^\h*([^#\n\r]+|#\h*\/[^#\n\r\h]+\.conf\b)')
      if [ -n "$l_ufwscf" ]; then # Account for systems with UFW (Not covered by systemd-sysctl --cat-config)
         l_kpar="$(grep -Po "^\h*$l_kpname\b" "$l_ufwscf" | xargs)"
         l_kpar="${l_kpar//\//.}"
         [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_ufwscf")
      fi
      if (( ${#A_out[@]} > 0 )); then # Assess output from files and generate output
         while IFS="=" read -r l_fkpname l_fkpvalue; do
            l_fkpname="${l_fkpname// /}"; l_fkpvalue="${l_fkpvalue// /}"
            if [ "$l_fkpvalue" = "$l_kpvalue" ]; then
               l_output="$l_output
 - \"$l_kpname\" is correctly set to \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\"
"
            else
               l_output2="$l_output2
 - \"$l_kpname\" is incorrectly set to \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\" and should have a value of: \"$l_kpvalue\"
"
            fi
         done < <(grep -Po -- "^\h*$l_kpname\h*=\h*\H+" "${A_out[@]}")
      else
         l_output2="$l_output2
 - \"$l_kpname\" is not set in an included file
   ** Note: \"$l_kpname\" May be set in a file that's ignored by load procedure **
"
      fi
   }
   while IFS="=" read -r l_kpname l_kpvalue; do # Assess and check parameters
      l_kpname="${l_kpname// /}"; l_kpvalue="${l_kpvalue// /}"
      if ! grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable && grep -q '^net.ipv6.' <<< "$l_kpname"; then
         l_output="$l_output
 - IPv6 is disabled on the system, \"$l_kpname\" is not applicable"
      else
         kernel_parameter_chk
      fi
   done < <(printf '%s
' "${a_parlist[@]}")
   if [ -z "$l_output2" ]; then # Provide output from checks
      echo -e "
- Audit Result:
  ** PASS **
$l_output
"
   else
      echo -e "
- Audit Result:
  ** FAIL **
 - Reason(s) for audit failure:
$l_output2
"
      [ -n "$l_output" ] && echo -e "
- Correctly set:
$l_output
"
   fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="3.3.2 Ensure packet redirect sending is disabled"
echo "$testcase"
detail=""

output=$({
   l_output="" l_output2=""
   a_parlist=("net.ipv4.conf.all.send_redirects=0" "net.ipv4.conf.default.send_redirects=0")
   l_ufwscf="$([ -f /etc/default/ufw ] && awk -F= '/^\s*IPT_SYSCTL=/ {print $2}' /etc/default/ufw)"
   kernel_parameter_chk()
   {
      l_krp="$(sysctl "$l_kpname" | awk -F= '{print $2}' | xargs)" # Check running configuration
      if [ "$l_krp" = "$l_kpvalue" ]; then
         l_output="$l_output
 - \"$l_kpname\" is correctly set to \"$l_krp\" in the running configuration"
      else
         l_output2="$l_output2
 - \"$l_kpname\" is incorrectly set to \"$l_krp\" in the running configuration and should have a value of: \"$l_kpvalue\""
      fi
      unset A_out; declare -A A_out # Check durable setting (files)
      while read -r l_out; do
         if [ -n "$l_out" ]; then
            if [[ $l_out =~ ^\s*# ]]; then
               l_file="${l_out//# /}"
            else
               l_kpar="$(awk -F= '{print $1}' <<< "$l_out" | xargs)"
               [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_file")
            fi
         fi
      done < <(/usr/lib/systemd/systemd-sysctl --cat-config | grep -Po '^\h*([^#\n\r]+|#\h*\/[^#\n\r\h]+\.conf\b)')
      if [ -n "$l_ufwscf" ]; then # Account for systems with UFW (Not covered by systemd-sysctl --cat-config)
         l_kpar="$(grep -Po "^\h*$l_kpname\b" "$l_ufwscf" | xargs)"
         l_kpar="${l_kpar//\//.}"
         [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_ufwscf")
      fi
      if (( ${#A_out[@]} > 0 )); then # Assess output from files and generate output
         while IFS="=" read -r l_fkpname l_fkpvalue; do
            l_fkpname="${l_fkpname// /}"; l_fkpvalue="${l_fkpvalue// /}"
            if [ "$l_fkpvalue" = "$l_kpvalue" ]; then
               l_output="$l_output
 - \"$l_kpname\" is correctly set to \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\"
"
            else
               l_output2="$l_output2
 - \"$l_kpname\" is incorrectly set to \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\" and should have a value of: \"$l_kpvalue\"
"
            fi
         done < <(grep -Po -- "^\h*$l_kpname\h*=\h*\H+" "${A_out[@]}")
      else
         l_output2="$l_output2
 - \"$l_kpname\" is not set in an included file
   ** Note: \"$l_kpname\" May be set in a file that's ignored by load procedure **
"
      fi
   }
   while IFS="=" read -r l_kpname l_kpvalue; do # Assess and check parameters
      l_kpname="${l_kpname// /}"; l_kpvalue="${l_kpvalue// /}"
      if ! grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable && grep -q '^net.ipv6.' <<< "$l_kpname"; then
         l_output="$l_output
 - IPv6 is disabled on the system, \"$l_kpname\" is not applicable"
      else
         kernel_parameter_chk
      fi
   done < <(printf '%s
' "${a_parlist[@]}")
   if [ -z "$l_output2" ]; then # Provide output from checks
      echo -e "
- Audit Result:
  ** PASS **
$l_output
"
   else
      echo -e "
- Audit Result:
  ** FAIL **
 - Reason(s) for audit failure:
$l_output2
"
      [ -n "$l_output" ] && echo -e "
- Correctly set:
$l_output
"
   fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.3.3 Ensure bogus icmp responses are ignored"
echo "$testcase"
detail=""

output=$({
   l_output="" l_output2=""
   a_parlist=("net.ipv4.icmp_ignore_bogus_error_responses=1")
   l_ufwscf="$([ -f /etc/default/ufw ] && awk -F= '/^\s*IPT_SYSCTL=/ {print $2}' /etc/default/ufw)"
   kernel_parameter_chk()
   {
      l_krp="$(sysctl "$l_kpname" | awk -F= '{print $2}' | xargs)" # Check running configuration
      if [ "$l_krp" = "$l_kpvalue" ]; then
         l_output="$l_output
 - \"$l_kpname\" is correctly set to \"$l_krp\" in the running configuration"
      else
         l_output2="$l_output2
 - \"$l_kpname\" is incorrectly set to \"$l_krp\" in the running configuration and should have a value of: \"$l_kpvalue\""
      fi
      unset A_out; declare -A A_out # Check durable setting (files)
      while read -r l_out; do
         if [ -n "$l_out" ]; then
            if [[ $l_out =~ ^\s*# ]]; then
               l_file="${l_out//# /}"
            else
               l_kpar="$(awk -F= '{print $1}' <<< "$l_out" | xargs)"
               [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_file")
            fi
         fi
      done < <(/usr/lib/systemd/systemd-sysctl --cat-config | grep -Po '^\h*([^#\n\r]+|#\h*\/[^#\n\r\h]+\.conf\b)')
      if [ -n "$l_ufwscf" ]; then # Account for systems with UFW (Not covered by systemd-sysctl --cat-config)
         l_kpar="$(grep -Po "^\h*$l_kpname\b" "$l_ufwscf" | xargs)"
         l_kpar="${l_kpar//\//.}"
         [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_ufwscf")
      fi
      if (( ${#A_out[@]} > 0 )); then # Assess output from files and generate output
         while IFS="=" read -r l_fkpname l_fkpvalue; do
            l_fkpname="${l_fkpname// /}"; l_fkpvalue="${l_fkpvalue// /}"
            if [ "$l_fkpvalue" = "$l_kpvalue" ]; then
               l_output="$l_output
 - \"$l_kpname\" is correctly set to \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\"
"
            else
               l_output2="$l_output2
 - \"$l_kpname\" is incorrectly set to \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\" and should have a value of: \"$l_kpvalue\"
"
            fi
         done < <(grep -Po -- "^\h*$l_kpname\h*=\h*\H+" "${A_out[@]}")
      else
         l_output2="$l_output2
 - \"$l_kpname\" is not set in an included file
   ** Note: \"$l_kpname\" May be set in a file that's ignored by load procedure **
"
      fi
   }
   while IFS="=" read -r l_kpname l_kpvalue; do # Assess and check parameters
      l_kpname="${l_kpname// /}"; l_kpvalue="${l_kpvalue// /}"
      if ! grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable && grep -q '^net.ipv6.' <<< "$l_kpname"; then
         l_output="$l_output
 - IPv6 is disabled on the system, \"$l_kpname\" is not applicable"
      else
         kernel_parameter_chk
      fi
   done < <(printf '%s
' "${a_parlist[@]}")
   if [ -z "$l_output2" ]; then # Provide output from checks
      echo -e "
- Audit Result:
  ** PASS **
$l_output
"
   else
      echo -e "
- Audit Result:
  ** FAIL **
 - Reason(s) for audit failure:
$l_output2
"
      [ -n "$l_output" ] && echo -e "
- Correctly set:
$l_output
"
   fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.3.4 Ensure broadcast icmp requests are ignored"
echo "$testcase"
detail=""

output=$({
   l_output="" l_output2=""
   a_parlist=("net.ipv4.icmp_echo_ignore_broadcasts=1")
   l_ufwscf="$([ -f /etc/default/ufw ] && awk -F= '/^\s*IPT_SYSCTL=/ {print $2}' /etc/default/ufw)"
   kernel_parameter_chk()
   {
      l_krp="$(sysctl "$l_kpname" | awk -F= '{print $2}' | xargs)" # Check running configuration
      if [ "$l_krp" = "$l_kpvalue" ]; then
         l_output="$l_output
 - \"$l_kpname\" is correctly set to \"$l_krp\" in the running configuration"
      else
         l_output2="$l_output2
 - \"$l_kpname\" is incorrectly set to \"$l_krp\" in the running configuration and should have a value of: \"$l_kpvalue\""
      fi
      unset A_out; declare -A A_out # Check durable setting (files)
      while read -r l_out; do
         if [ -n "$l_out" ]; then
            if [[ $l_out =~ ^\s*# ]]; then
               l_file="${l_out//# /}"
            else
               l_kpar="$(awk -F= '{print $1}' <<< "$l_out" | xargs)"
               [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_file")
            fi
         fi
      done < <(/usr/lib/systemd/systemd-sysctl --cat-config | grep -Po '^\h*([^#\n\r]+|#\h*\/[^#\n\r\h]+\.conf\b)')
      if [ -n "$l_ufwscf" ]; then # Account for systems with UFW (Not covered by systemd-sysctl --cat-config)
         l_kpar="$(grep -Po "^\h*$l_kpname\b" "$l_ufwscf" | xargs)"
         l_kpar="${l_kpar//\//.}"
         [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_ufwscf")
      fi
      if (( ${#A_out[@]} > 0 )); then # Assess output from files and generate output
         while IFS="=" read -r l_fkpname l_fkpvalue; do
            l_fkpname="${l_fkpname// /}"; l_fkpvalue="${l_fkpvalue// /}"
            if [ "$l_fkpvalue" = "$l_kpvalue" ]; then
               l_output="$l_output
 - \"$l_kpname\" is correctly set to \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\"
"
            else
               l_output2="$l_output2
 - \"$l_kpname\" is incorrectly set to \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\" and should have a value of: \"$l_kpvalue\"
"
            fi
         done < <(grep -Po -- "^\h*$l_kpname\h*=\h*\H+" "${A_out[@]}")
      else
         l_output2="$l_output2
 - \"$l_kpname\" is not set in an included file
   ** Note: \"$l_kpname\" May be set in a file that's ignored by load procedure **
"
      fi
   }
   while IFS="=" read -r l_kpname l_kpvalue; do # Assess and check parameters
      l_kpname="${l_kpname// /}"; l_kpvalue="${l_kpvalue// /}"
      if ! grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable && grep -q '^net.ipv6.' <<< "$l_kpname"; then
         l_output="$l_output
 - IPv6 is disabled on the system, \"$l_kpname\" is not applicable"
      else
         kernel_parameter_chk
      fi
   done < <(printf '%s
' "${a_parlist[@]}")
   if [ -z "$l_output2" ]; then # Provide output from checks
      echo -e "
- Audit Result:
  ** PASS **
$l_output
"
   else
      echo -e "
- Audit Result:
  ** FAIL **
 - Reason(s) for audit failure:
$l_output2
"
      [ -n "$l_output" ] && echo -e "
- Correctly set:
$l_output
"
   fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.3.5 Ensure icmp redirects are not accepted"
echo "$testcase"
detail=""

output=$({
   l_output="" l_output2=""
   a_parlist=("net.ipv4.conf.all.accept_redirects=0" "net.ipv4.conf.default.accept_redirects=0" "net.ipv6.conf.all.accept_redirects=0" "net.ipv6.conf.default.accept_redirects=0")
   l_ufwscf="$([ -f /etc/default/ufw ] && awk -F= '/^\s*IPT_SYSCTL=/ {print $2}' /etc/default/ufw)"
   kernel_parameter_chk()
   {
      l_krp="$(sysctl "$l_kpname" | awk -F= '{print $2}' | xargs)" # Check running configuration
      if [ "$l_krp" = "$l_kpvalue" ]; then
         l_output="$l_output
 - \"$l_kpname\" is correctly set to \"$l_krp\" in the running configuration"
      else
         l_output2="$l_output2
 - \"$l_kpname\" is incorrectly set to \"$l_krp\" in the running configuration and should have a value of: \"$l_kpvalue\""
      fi
      unset A_out; declare -A A_out # Check durable setting (files)
      while read -r l_out; do
         if [ -n "$l_out" ]; then
            if [[ $l_out =~ ^\s*# ]]; then
               l_file="${l_out//# /}"
            else
               l_kpar="$(awk -F= '{print $1}' <<< "$l_out" | xargs)"
               [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_file")
            fi
         fi
      done < <(/usr/lib/systemd/systemd-sysctl --cat-config | grep -Po '^\h*([^#\n\r]+|#\h*\/[^#\n\r\h]+\.conf\b)')
      if [ -n "$l_ufwscf" ]; then # Account for systems with UFW (Not covered by systemd-sysctl --cat-config)
         l_kpar="$(grep -Po "^\h*$l_kpname\b" "$l_ufwscf" | xargs)"
         l_kpar="${l_kpar//\//.}"
         [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_ufwscf")
      fi
      if (( ${#A_out[@]} > 0 )); then # Assess output from files and generate output
         while IFS="=" read -r l_fkpname l_fkpvalue; do
            l_fkpname="${l_fkpname// /}"; l_fkpvalue="${l_fkpvalue// /}"
            if [ "$l_fkpvalue" = "$l_kpvalue" ]; then
               l_output="$l_output
 - \"$l_kpname\" is correctly set to \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\"
"
            else
               l_output2="$l_output2
 - \"$l_kpname\" is incorrectly set to \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\" and should have a value of: \"$l_kpvalue\"
"
            fi
         done < <(grep -Po -- "^\h*$l_kpname\h*=\h*\H+" "${A_out[@]}")
      else
         l_output2="$l_output2
 - \"$l_kpname\" is not set in an included file
   ** Note: \"$l_kpname\" May be set in a file that's ignored by load procedure **
"
      fi
   }
   while IFS="=" read -r l_kpname l_kpvalue; do # Assess and check parameters
      l_kpname="${l_kpname// /}"; l_kpvalue="${l_kpvalue// /}"
      if ! grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable && grep -q '^net.ipv6.' <<< "$l_kpname"; then
         l_output="$l_output
 - IPv6 is disabled on the system, \"$l_kpname\" is not applicable"
      else
         kernel_parameter_chk
      fi
   done < <(printf '%s
' "${a_parlist[@]}")
   if [ -z "$l_output2" ]; then # Provide output from checks
      echo -e "
- Audit Result:
  ** PASS **
$l_output
"
   else
      echo -e "
- Audit Result:
  ** FAIL **
 - Reason(s) for audit failure:
$l_output2
"
      [ -n "$l_output" ] && echo -e "
- Correctly set:
$l_output
"
   fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.3.6 Ensure secure icmp redirects are not accepted"
echo "$testcase"
detail=""

output=$({
     l_output="" l_output2=""
   a_parlist=("net.ipv4.conf.all.secure_redirects=0" "net.ipv4.conf.default.secure_redirects=0")
   l_ufwscf="$([ -f /etc/default/ufw ] && awk -F= '/^\s*IPT_SYSCTL=/ {print $2}' /etc/default/ufw)"
   kernel_parameter_chk()
   {
      l_krp="$(sysctl "$l_kpname" | awk -F= '{print $2}' | xargs)" # Check running configuration
      if [ "$l_krp" = "$l_kpvalue" ]; then
         l_output="$l_output\n - \"$l_kpname\" is correctly set to \"$l_krp\" in the running configuration"
      else
         l_output2="$l_output2\n - \"$l_kpname\" is incorrectly set to \"$l_krp\" in the running configuration and should have a value of: \"$l_kpvalue\""
      fi
      unset A_out; declare -A A_out # Check durable setting (files)
      while read -r l_out; do
         if [ -n "$l_out" ]; then
            if [[ $l_out =~ ^\s*# ]]; then
               l_file="${l_out//# /}"
            else
               l_kpar="$(awk -F= '{print $1}' <<< "$l_out" | xargs)"
               [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_file")
            fi
         fi
      done < <(/usr/lib/systemd/systemd-sysctl --cat-config | grep -Po '^\h*([^#\n\r]+|#\h*\/[^#\n\r\h]+\.conf\b)')
      if [ -n "$l_ufwscf" ]; then # Account for systems with UFW (Not covered by systemd-sysctl --cat-config)
         l_kpar="$(grep -Po "^\h*$l_kpname\b" "$l_ufwscf" | xargs)"
         l_kpar="${l_kpar//\//.}"
         [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_ufwscf")
      fi
      if (( ${#A_out[@]} > 0 )); then # Assess output from files and generate output
         while IFS="=" read -r l_fkpname l_fkpvalue; do
            l_fkpname="${l_fkpname// /}"; l_fkpvalue="${l_fkpvalue// /}"
            if [ "$l_fkpvalue" = "$l_kpvalue" ]; then
               l_output="$l_output\n - \"$l_kpname\" is correctly set to \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\"\n"
            else
               l_output2="$l_output2\n - \"$l_kpname\" is incorrectly set to \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\" and should have a value of: \"$l_kpvalue\"\n"
            fi
         done < <(grep -Po -- "^\h*$l_kpname\h*=\h*\H+" "${A_out[@]}")
      else
         l_output2="$l_output2\n - \"$l_kpname\" is not set in an included file\n   ** Note: \"$l_kpname\" May be set in a file that's ignored by load procedure **\n"
      fi
   }
   while IFS="=" read -r l_kpname l_kpvalue; do # Assess and check parameters
      l_kpname="${l_kpname// /}"; l_kpvalue="${l_kpvalue// /}"
      if ! grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable && grep -q '^net.ipv6.' <<< "$l_kpname"; then
         l_output="$l_output\n - IPv6 is disabled on the system, \"$l_kpname\" is not applicable"
      else
         kernel_parameter_chk
      fi
   done < <(printf '%s\n' "${a_parlist[@]}")
   if [ -z "$l_output2" ]; then # Provide output from checks
      echo -e "\n- Audit Result:\n  ** PASS **\n$l_output\n"
   else
      echo -e "\n- Audit Result:\n  ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
      [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
   fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="3.3.7 Ensure reverse path filtering is enabled"
echo "$testcase"
detail=""

output=$({
    l_output="" l_output2=""
   a_parlist=("net.ipv4.conf.all.rp_filter=1" "net.ipv4.conf.default.rp_filter=1")
   l_ufwscf="$([ -f /etc/default/ufw ] && awk -F= '/^\s*IPT_SYSCTL=/ {print $2}' /etc/default/ufw)"
   kernel_parameter_chk()
   {
      l_krp="$(sysctl "$l_kpname" | awk -F= '{print $2}' | xargs)" # Check running configuration
      if [ "$l_krp" = "$l_kpvalue" ]; then
         l_output="$l_output\n - \"$l_kpname\" is correctly set to \"$l_krp\" in the running configuration"
      else
         l_output2="$l_output2\n - \"$l_kpname\" is incorrectly set to \"$l_krp\" in the running configuration and should have a value of: \"$l_kpvalue\""
      fi
      unset A_out; declare -A A_out # Check durable setting (files)
      while read -r l_out; do
         if [ -n "$l_out" ]; then
            if [[ $l_out =~ ^\s*# ]]; then
               l_file="${l_out//# /}"
            else
               l_kpar="$(awk -F= '{print $1}' <<< "$l_out" | xargs)"
               [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_file")
            fi
         fi
      done < <(/usr/lib/systemd/systemd-sysctl --cat-config | grep -Po '^\h*([^#\n\r]+|#\h*\/[^#\n\r\h]+\.conf\b)')
      if [ -n "$l_ufwscf" ]; then # Account for systems with UFW (Not covered by systemd-sysctl --cat-config)
         l_kpar="$(grep -Po "^\h*$l_kpname\b" "$l_ufwscf" | xargs)"
         l_kpar="${l_kpar//\//.}"
         [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_ufwscf")
      fi
      if (( ${#A_out[@]} > 0 )); then # Assess output from files and generate output
         while IFS="=" read -r l_fkpname l_fkpvalue; do
            l_fkpname="${l_fkpname// /}"; l_fkpvalue="${l_fkpvalue// /}"
            if [ "$l_fkpvalue" = "$l_kpvalue" ]; then
               l_output="$l_output\n - \"$l_kpname\" is correctly set to \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\"\n"
            else
               l_output2="$l_output2\n - \"$l_kpname\" is incorrectly set to \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\" and should have a value of: \"$l_kpvalue\"\n"
            fi
         done < <(grep -Po -- "^\h*$l_kpname\h*=\h*\H+" "${A_out[@]}")
      else
         l_output2="$l_output2\n - \"$l_kpname\" is not set in an included file\n   ** Note: \"$l_kpname\" May be set in a file that's ignored by load procedure **\n"
      fi
   }
   while IFS="=" read -r l_kpname l_kpvalue; do # Assess and check parameters
      l_kpname="${l_kpname// /}"; l_kpvalue="${l_kpvalue// /}"
      if ! grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable && grep -q '^net.ipv6.' <<< "$l_kpname"; then
         l_output="$l_output\n - IPv6 is disabled on the system, \"$l_kpname\" is not applicable"
      else
         kernel_parameter_chk
      fi
   done < <(printf '%s\n' "${a_parlist[@]}")
   if [ -z "$l_output2" ]; then # Provide output from checks
      echo -e "\n- Audit Result:\n  ** PASS **\n$l_output\n"
   else
      echo -e "\n- Audit Result:\n  ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
      [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
   fi
})

echo $output
if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.3.8 Ensure source routed packets are not accepted"
echo "$testcase"
detail=""

output=$({
   l_output="" l_output2=""
   a_parlist=("net.ipv4.conf.all.accept_source_route=0" "net.ipv4.conf.default.accept_source_route=0" "net.ipv6.conf.all.accept_source_route=0" "net.ipv6.conf.default.accept_source_route=0")
   l_ufwscf="$([ -f /etc/default/ufw ] && awk -F= '/^\s*IPT_SYSCTL=/ {print $2}' /etc/default/ufw)"
   kernel_parameter_chk()
   {
      l_krp="$(sysctl "$l_kpname" | awk -F= '{print $2}' | xargs)" # Check running configuration
      if [ "$l_krp" = "$l_kpvalue" ]; then
         l_output="$l_output\n - \"$l_kpname\" is correctly set to \"$l_krp\" in the running configuration"
      else
         l_output2="$l_output2\n - \"$l_kpname\" is incorrectly set to \"$l_krp\" in the running configuration and should have a value of: \"$l_kpvalue\""
      fi
      unset A_out; declare -A A_out # Check durable setting (files)
      while read -r l_out; do
         if [ -n "$l_out" ]; then
            if [[ $l_out =~ ^\s*# ]]; then
               l_file="${l_out//# /}"
            else
               l_kpar="$(awk -F= '{print $1}' <<< "$l_out" | xargs)"
               [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_file")
            fi
         fi
      done < <(/usr/lib/systemd/systemd-sysctl --cat-config | grep -Po '^\h*([^#\n\r]+|#\h*\/[^#\n\r\h]+\.conf\b)')
      if [ -n "$l_ufwscf" ]; then # Account for systems with UFW (Not covered by systemd-sysctl --cat-config)
         l_kpar="$(grep -Po "^\h*$l_kpname\b" "$l_ufwscf" | xargs)"
         l_kpar="${l_kpar//\//.}"
         [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_ufwscf")
      fi
      if (( ${#A_out[@]} > 0 )); then # Assess output from files and generate output
         while IFS="=" read -r l_fkpname l_fkpvalue; do
            l_fkpname="${l_fkpname// /}"; l_fkpvalue="${l_fkpvalue// /}"
            if [ "$l_fkpvalue" = "$l_kpvalue" ]; then
               l_output="$l_output\n - \"$l_kpname\" is correctly set to \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\"\n"
            else
               l_output2="$l_output2\n - \"$l_kpname\" is incorrectly set to \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\" and should have a value of: \"$l_kpvalue\"\n"
            fi
         done < <(grep -Po -- "^\h*$l_kpname\h*=\h*\H+" "${A_out[@]}")
      else
         l_output2="$l_output2\n - \"$l_kpname\" is not set in an included file\n   ** Note: \"$l_kpname\" May be set in a file that's ignored by load procedure **\n"
      fi
   }
   while IFS="=" read -r l_kpname l_kpvalue; do # Assess and check parameters
      l_kpname="${l_kpname// /}"; l_kpvalue="${l_kpvalue// /}"
      if ! grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable && grep -q '^net.ipv6.' <<< "$l_kpname"; then
         l_output="$l_output\n - IPv6 is disabled on the system, \"$l_kpname\" is not applicable"
      else
         kernel_parameter_chk
      fi
   done < <(printf '%s\n' "${a_parlist[@]}")
   if [ -z "$l_output2" ]; then # Provide output from checks
      echo -e "\n- Audit Result:\n  ** PASS **\n$l_output\n"
   else
      echo -e "\n- Audit Result:\n  ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
      [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
   fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.3.9 Ensure suspicious packets are logged"
echo "$testcase"
detail=""

output=$({
   l_output="" l_output2=""
   a_parlist=("net.ipv4.conf.all.log_martians=1" "net.ipv4.conf.default.log_martians=1")
   l_ufwscf="$([ -f /etc/default/ufw ] && awk -F= '/^\s*IPT_SYSCTL=/ {print $2}' /etc/default/ufw)"
   kernel_parameter_chk()
   {
      l_krp="$(sysctl "$l_kpname" | awk -F= '{print $2}' | xargs)" # Check running configuration
      if [ "$l_krp" = "$l_kpvalue" ]; then
         l_output="$l_output\n - \"$l_kpname\" is correctly set to \"$l_krp\" in the running configuration"
      else
         l_output2="$l_output2\n - \"$l_kpname\" is incorrectly set to \"$l_krp\" in the running configuration and should have a value of: \"$l_kpvalue\""
      fi
      unset A_out; declare -A A_out # Check durable setting (files)
      while read -r l_out; do
         if [ -n "$l_out" ]; then
            if [[ $l_out =~ ^\s*# ]]; then
               l_file="${l_out//# /}"
            else
               l_kpar="$(awk -F= '{print $1}' <<< "$l_out" | xargs)"
               [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_file")
            fi
         fi
      done < <(/usr/lib/systemd/systemd-sysctl --cat-config | grep -Po '^\h*([^#\n\r]+|#\h*\/[^#\n\r\h]+\.conf\b)')
      if [ -n "$l_ufwscf" ]; then # Account for systems with UFW (Not covered by systemd-sysctl --cat-config)
         l_kpar="$(grep -Po "^\h*$l_kpname\b" "$l_ufwscf" | xargs)"
         l_kpar="${l_kpar//\//.}"
         [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_ufwscf")
      fi
      if (( ${#A_out[@]} > 0 )); then # Assess output from files and generate output
         while IFS="=" read -r l_fkpname l_fkpvalue; do
            l_fkpname="${l_fkpname// /}"; l_fkpvalue="${l_fkpvalue// /}"
            if [ "$l_fkpvalue" = "$l_kpvalue" ]; then
               l_output="$l_output\n - \"$l_kpname\" is correctly set to \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\"\n"
            else
               l_output2="$l_output2\n - \"$l_kpname\" is incorrectly set to \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\" and should have a value of: \"$l_kpvalue\"\n"
            fi
         done < <(grep -Po -- "^\h*$l_kpname\h*=\h*\H+" "${A_out[@]}")
      else
         l_output2="$l_output2\n - \"$l_kpname\" is not set in an included file\n   ** Note: \"$l_kpname\" May be set in a file that's ignored by load procedure **\n"
      fi
   }
   while IFS="=" read -r l_kpname l_kpvalue; do # Assess and check parameters
      l_kpname="${l_kpname// /}"; l_kpvalue="${l_kpvalue// /}"
      if ! grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable && grep -q '^net.ipv6.' <<< "$l_kpname"; then
         l_output="$l_output\n - IPv6 is disabled on the system, \"$l_kpname\" is not applicable"
      else
         kernel_parameter_chk
      fi
   done < <(printf '%s\n' "${a_parlist[@]}")
   if [ -z "$l_output2" ]; then # Provide output from checks
      echo -e "\n- Audit Result:\n  ** PASS **\n$l_output\n"
   else
      echo -e "\n- Audit Result:\n  ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
      [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
   fi
})


if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="3.3.10 Ensure tcp syn cookies is enabled"
echo "$testcase"
detail=""

output=$({
   l_output="" l_output2=""
   a_parlist=("net.ipv4.tcp_syncookies=1")
   l_ufwscf="$([ -f /etc/default/ufw ] && awk -F= '/^\s*IPT_SYSCTL=/ {print $2}' /etc/default/ufw)"
   kernel_parameter_chk()
   {
      l_krp="$(sysctl "$l_kpname" | awk -F= '{print $2}' | xargs)" # Check running configuration
      if [ "$l_krp" = "$l_kpvalue" ]; then
         l_output="$l_output\n - \"$l_kpname\" is correctly set to \"$l_krp\" in the running configuration"
      else
         l_output2="$l_output2\n - \"$l_kpname\" is incorrectly set to \"$l_krp\" in the running configuration and should have a value of: \"$l_kpvalue\""
      fi
      unset A_out; declare -A A_out # Check durable setting (files)
      while read -r l_out; do
         if [ -n "$l_out" ]; then
            if [[ $l_out =~ ^\s*# ]]; then
               l_file="${l_out//# /}"
            else
               l_kpar="$(awk -F= '{print $1}' <<< "$l_out" | xargs)"
               [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_file")
            fi
         fi
      done < <(/usr/lib/systemd/systemd-sysctl --cat-config | grep -Po '^\h*([^#\n\r]+|#\h*\/[^#\n\r\h]+\.conf\b)')
      if [ -n "$l_ufwscf" ]; then # Account for systems with UFW (Not covered by systemd-sysctl --cat-config)
         l_kpar="$(grep -Po "^\h*$l_kpname\b" "$l_ufwscf" | xargs)"
         l_kpar="${l_kpar//\//.}"
         [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_ufwscf")
      fi
      if (( ${#A_out[@]} > 0 )); then # Assess output from files and generate output
         while IFS="=" read -r l_fkpname l_fkpvalue; do
            l_fkpname="${l_fkpname// /}"; l_fkpvalue="${l_fkpvalue// /}"
            if [ "$l_fkpvalue" = "$l_kpvalue" ]; then
               l_output="$l_output\n - \"$l_kpname\" is correctly set to \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\"\n"
            else
               l_output2="$l_output2\n - \"$l_kpname\" is incorrectly set to \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\" and should have a value of: \"$l_kpvalue\"\n"
            fi
         done < <(grep -Po -- "^\h*$l_kpname\h*=\h*\H+" "${A_out[@]}")
      else
         l_output2="$l_output2\n - \"$l_kpname\" is not set in an included file\n   ** Note: \"$l_kpname\" May be set in a file that's ignored by load procedure **\n"
      fi
   }
   while IFS="=" read -r l_kpname l_kpvalue; do # Assess and check parameters
      l_kpname="${l_kpname// /}"; l_kpvalue="${l_kpvalue// /}"
      if ! grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable && grep -q '^net.ipv6.' <<< "$l_kpname"; then
         l_output="$l_output\n - IPv6 is disabled on the system, \"$l_kpname\" is not applicable"
      else
         kernel_parameter_chk
      fi
   done < <(printf '%s\n' "${a_parlist[@]}")
   if [ -z "$l_output2" ]; then # Provide output from checks
      echo -e "\n- Audit Result:\n  ** PASS **\n$l_output\n"
   else
      echo -e "\n- Audit Result:\n  ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
      [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
   fi
})


if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.3.11 Ensure ipv6 router advertisements are not accepted"
echo "$testcase"
detail=""

output=$({
   l_output="" l_output2=""
   a_parlist=("net.ipv6.conf.all.accept_ra=0" "net.ipv6.conf.default.accept_ra=0")
   l_ufwscf="$([ -f /etc/default/ufw ] && awk -F= '/^\s*IPT_SYSCTL=/ {print $2}' /etc/default/ufw)"
   kernel_parameter_chk()
   {
      l_krp="$(sysctl "$l_kpname" | awk -F= '{print $2}' | xargs)" # Check running configuration
      if [ "$l_krp" = "$l_kpvalue" ]; then
         l_output="$l_output\n - \"$l_kpname\" is correctly set to \"$l_krp\" in the running configuration"
      else
         l_output2="$l_output2\n - \"$l_kpname\" is incorrectly set to \"$l_krp\" in the running configuration and should have a value of: \"$l_kpvalue\""
      fi
      unset A_out; declare -A A_out # Check durable setting (files)
      while read -r l_out; do
         if [ -n "$l_out" ]; then
            if [[ $l_out =~ ^\s*# ]]; then
               l_file="${l_out//# /}"
            else
               l_kpar="$(awk -F= '{print $1}' <<< "$l_out" | xargs)"
               [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_file")
            fi
         fi
      done < <(/usr/lib/systemd/systemd-sysctl --cat-config | grep -Po '^\h*([^#\n\r]+|#\h*\/[^#\n\r\h]+\.conf\b)')
      if [ -n "$l_ufwscf" ]; then # Account for systems with UFW (Not covered by systemd-sysctl --cat-config)
         l_kpar="$(grep -Po "^\h*$l_kpname\b" "$l_ufwscf" | xargs)"
         l_kpar="${l_kpar//\//.}"
         [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_ufwscf")
      fi
      if (( ${#A_out[@]} > 0 )); then # Assess output from files and generate output
         while IFS="=" read -r l_fkpname l_fkpvalue; do
            l_fkpname="${l_fkpname// /}"; l_fkpvalue="${l_fkpvalue// /}"
            if [ "$l_fkpvalue" = "$l_kpvalue" ]; then
               l_output="$l_output\n - \"$l_kpname\" is correctly set to \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\"\n"
            else
               l_output2="$l_output2\n - \"$l_kpname\" is incorrectly set to \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\" and should have a value of: \"$l_kpvalue\"\n"
            fi
         done < <(grep -Po -- "^\h*$l_kpname\h*=\h*\H+" "${A_out[@]}")
      else
         l_output2="$l_output2\n - \"$l_kpname\" is not set in an included file\n   ** Note: \"$l_kpname\" May be set in a file that's ignored by load procedure **\n"
      fi
   }
   while IFS="=" read -r l_kpname l_kpvalue; do # Assess and check parameters
      l_kpname="${l_kpname// /}"; l_kpvalue="${l_kpvalue// /}"
      if ! grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable && grep -q '^net.ipv6.' <<< "$l_kpname"; then
         l_output="$l_output\n - IPv6 is disabled on the system, \"$l_kpname\" is not applicable"
      else
         kernel_parameter_chk
      fi
   done < <(printf '%s\n' "${a_parlist[@]}")
   if [ -z "$l_output2" ]; then # Provide output from checks
      echo -e "\n- Audit Result:\n  ** PASS **\n$l_output\n"
   else
      echo -e "\n- Audit Result:\n  ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
      [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
   fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file



testcase="4.1.1 Ensure ufw is installed"
echo "$testcase"
detail=""
ufwoutput=""
output=$(dpkg-query -s ufw &>/dev/null && echo "ufw is installed")
if [[ $output == *"ufw is installed"* ]]; then 
   status="PASS"
   ufwoutput="TRUE"
else 
   status="FAIL" 
   detail="Not installed"
   ufwoutput="FALSE"
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

if [[ $ufwoutput == "TRUE" ]]; then

testcase="4.1.2 Ensure iptables-persistent is not installed with ufw"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s iptables-persistent 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ $output == *"not installed"* ]]; then status="PASS"; else status="FAIL" detail="Ip tables persistent Not installed"; fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.1.3 Ensure ufw service is enabled"
echo "$testcase"
detail=""
output=$(systemctl is-enabled ufw.service)
if [[ $output == "enabled" ]]; then
   output2=$(systemctl is-active ufw)
   if [[ $output == "active" ]]; then
      output3=$(ufw status)
      if [[ $output3 == *"active"* ]]; then
         status="PASS"
      else
         status="FAIL"
         detail="ufw not active"
      fi
   else
      status="FAIL"
      detail="ufw daemon not active"
   fi
else
   status="FAIL"
   detail="ufw daemon not enabled"
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.1.4 Ensure ufw loopback traffic is configured"
echo "$testcase"
detail=""
output=$(ufw status verbose)
status="Pending"
detail="Verify manually"
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.1.5 Ensure ufw outbound connections are configured"
echo "$testcase"
detail=""
output=$(/sbin/ufw status numbered)
status="Pending"
detail="Verify manually"
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="4.1.6 Ensure ufw firewall rules exist for all open ports"
echo "$testcase"
detail=""
output=$({
 unset a_ufwout;unset a_openports
 while read -r l_ufwport; do
 [ -n "$l_ufwport" ] && a_ufwout+=("$l_ufwport")
 done < <(ufw status verbose | grep -Po '^\h*\d+\b' | sort -u)
 while read -r l_openport; do
 [ -n "$l_openport" ] && a_openports+=("$l_openport")
 done < <(ss -tuln | awk '($5!~/%lo:/ && $5!~/127.0.0.1:/ && $5!~/\[?::1\]?:/) {split($5, a, ":"); print a[2]}' | sort -u)
 a_diff=("$(printf '%s\n' "${a_openports[@]}" "${a_ufwout[@]}" "${a_ufwout[@]}" | sort | uniq -u)")
 if [[ -n "${a_diff[*]}" ]]; then
 echo -e "\n- Audit Result:\n ** FAIL **\n- The following port(s) don't have a rule in UFW: $(printf '%s\n' \\n"${a_diff[*]}")\n- End List"
 else
 echo -e "\n - Audit Passed -\n ** PASS **\n- All open ports have a rule in UFW\n"
 fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
fi
echo "$output"
detail=$(echo "$output" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.1.7 Ensure ufw default deny firewall policy"
echo "$testcase"
detail=""
output=$(/sbin/ufw status verbose | /bin/grep 'Default:')
if [[ $output == "Default: deny (incoming), deny (outgoing), disabled (routed)" ]]; then
   status="PASS"
else
   if [[ $output != *"inactive"* ]]; then
      status="FAIL"
      detail="Improper configuration"
   else
      status="PASS"
      detail="ufw inactive"
   fi
fi
output1=$(/sbin/ufw status verbose)
echo "$output1"
detail=$(echo "$output" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

fi

testcase="4.2.1 Ensure nftables is installed"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s nftables 2>&1 | /bin/grep -E '(Status:|not installed)')
nftablesout=""
if [[ $output == *"ok installed"* ]]; then
   status="PASS"
   nftablesout="TRUE"
else
   status="FAIL"
   detail="nftables not installed"
   nftablesout="FALSE"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

if [[ $nftablesout == "TRUE" ]]; then

testcase="4.2.2 Ensure ufw is uninstalled or disabled with nftables"
output=$(/bin/dpkg -s ufw 2>&1 | /bin/grep -E '(Status:|not installed)')
if [[ $nftablesout == "TRUE" ]]; then
   if [[ -z "$output" ]]; then
      status="PASS"
   else
      output1=$(ufw status)
      output2=$(systemctl is-enabled ufw.service)
      if [[ $output1 == "Status: inactive" && $output2 == "masked" ]]; then
         status="PASS"
      else
         status="FAIL"
         detail="Error in ufw - ufw service. Not disabled or is active."
      fi
      echo "ufw -> $output1"
      echo "ufw service -> $output2"
   fi
else
   status="NA"
   detail="nftables is not installed"
fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="4.2.3 Ensure iptables are flushed with nftables"
echo "$testcase"
detail=""
output1=$(iptables -L)
output2=$(ip6tables -L)
status="Pending"
detail="Verify Manually with output"
echo "iptables -> $output1"
echo "ip6tables -> $output2"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.2.4 Ensure a nftables table exists"
echo "$testcase"
detail=""
output=$(/sbin/nft list tables)
status="Pending"
detail="Verify manually with output"
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.2.5 Ensure nftables base chains exist"
echo "$testcase"
detail=""
output1=$(nft list ruleset | grep 'hook input')
output2=$(nft list ruleset | grep 'hook forward')
output3=$(nft list ruleset | grep 'hook output')

if [[ $output1 == "type filter hook input priority 0;" ]]; then
   if [[ $output2 == "type filter hook forward priority 0;" ]]; then
      if [[ $output3 == "type filter hook output priority 0;" ]]; then
         status="PASS"
      else
         status="FAIL"
         detail="hook output error"
      fi
   else
      status="FAIL"
      detail="hook forward error"
   fi
else
   status="FAIL"
   detail="hook input error"
fi
detail=$(echo "$output" | tr '\n,' ' ')
echo -e "$output1\n$output2\n$output3"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.2.6 Ensure nftables loopback traffic is configured"
echo "$testcase"
detail=""

echo "iif lo accept"
output1=$(/sbin/nft list ruleset | /bin/awk '/hook input/,/}/' | /bin/grep 'iif "lo" accept')
echo "ip saddr"
output2=$(/sbin/nft list ruleset | /bin/awk '/hook input/,/}/' | /bin/grep 'ip saddr')
echo "ip6 saddr"
output3=$(/sbin/nft list ruleset | /bin/awk '/hook input/,/}/' | /bin/grep 'ip6 saddr')

if [[ $output1 == *"iif \"lo\" accept"* ]]; then
   if [[ $output2 == "ip saddr;" ]]; then
      if [[ $output3 == "ip6 saddr" ]]; then
         status="PASS"
      else
         status="FAIL"
         detail="ip6 saddr error"
      fi
   else
      status="FAIL"
      detail="ip saddr error"
   fi
else
   status="FAIL"
   detail="iif lo accept error"
fi
detail+=" Verify manually."
detail=$(echo "$output" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.2.7 Ensure nftables outbound and established connections are configured"
echo "$testcase"
detail=""

echo "nft list ruleset - ct state"
output1=$(/sbin/nft list ruleset | /bin/awk '/hook output/,/}/' | /bin/grep -E 'ip protocol (tcp|udp|icmp) ct state')

echo "nft list ruleset - ct state"
output2=$(/sbin/nft list ruleset | /bin/awk '/hook input/,/}/' | /bin/grep -E 'ip protocol (tcp|udp|icmp) ct state')

if [[ -z "$output1" || -z "$output2" ]]; then
   status="FAIL"
   detail="Not configured"
else
   status="PASS"
fi
detail+=" Verify manually."
detail=$(echo "$output" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.2.8 Ensure nftables default deny firewall policy"
echo "$testcase"
detail=""

echo "input"
output1=$(/sbin/nft list ruleset | /bin/grep 'hook input')

echo "output"
output2=$(/sbin/nft list ruleset | /bin/grep 'hook output')

echo "forward"
output3=$(/sbin/nft list ruleset | /bin/grep 'hook forward')

status="PASS"
if [[ $output1 != *"policy drop"* ]]; then
   status="FAIL"
   detail="hook input error"
fi
if [[ $output2 != *"policy drop"* ]]; then
   status="FAIL"
   detail="hook output error"
fi
if [[ $output3 != *"policy drop"* ]]; then
   status="FAIL"
   detail="hook forward error"
fi
detail+=" Verify manually."
detail=$(echo "$output" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.2.9 Ensure nftables service is enabled"
echo "$testcase"
detail=""
output=$(/bin/systemctl is-enabled nftables)
if [[ $output == "enabled" ]]; then
   status="PASS"
else
   status="FAIL"
   detail="nftables service not enabled"
fi
echo "$output"
detail+=" Verify manually."
detail=$(echo "$output" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.2.10 Ensure nftables rules are permanent"
echo "$testcase"
detail=""
output=$([ -n "$(grep -E '^\s*include' /etc/nftables.conf)" ] && awk '/hook input/,/}/' $(awk '$1 ~ /^\s*include/ { gsub("\"","",$2);print $2 }' /etc/nftables.conf))
if [[ -n "$output" ]]; then status="PASS"; else status="FAIL" detail="nftables rules are not present"; fi
detail+=" Verify manually."
detail=$(echo "$output" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

fi

testcase="4.3.1.1 Ensure iptables packages are installed"
echo "$testcase"
detail=""
iptablesout=""
ippersistentout=""
output=$(dpkg-query -s iptables &>/dev/null && echo "iptables is installed")
if [[ $output == *"iptables is installed"* ]]; then
   iptablesout="TRUE"
   output1=$(dpkg-query -s iptables-persistent &>/dev/null && echo "iptables-persistent is installed")
   if [[ $output1 == *"iptables-persistent is installed"* ]]; then
      ippersistentout="TRUE"
      status="PASS"
   else
      status="FAIL"
      detail="iptables persistent not installed"
   fi
else
   status="FAIL"
   detail="iptables not installed"
fi
detail=$(echo "$output" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

if [[ $iptablesout == "TRUE" ]]; then

testcase="4.3.1.2 Ensure nftables is not installed with iptables"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s nftables 2>&1 | /bin/grep -E '(Status:|not installed)')
if [[ $output == "nftables is installed" ]]; then
   status="FAIL"
   detail="both iptables and nftables are installed"
else
   status="PASS"
fi
detail=$(echo "$output" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.3.1.3 Ensure ufw is uninstalled or disabled with iptables"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s ufw 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ $output != "Status: install ok installed" ]]; then
   status="PASS"
else
   output2=$(ufw status)
   output3=$(systemctl is-enabled ufw)
   if [[ $output2 == "Status: inactive" && $output3 == "systemctl is-enabled ufw" ]]; then
      status="PASS"
   else
      status="FAIL"
      detail="ufw enabled or active"
   fi
   echo "ufw -> $output2"
   echo "ufw enables -> $output3"
fi
detail=$(echo "$output" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

fi

testcase="4.3.2.1 Ensure iptables default deny firewall policy"
echo "$testcase"
detail=""

output1=$(/sbin/iptables -L -n | /bin/grep 'Chain INPUT')
output2=$(/sbin/iptables -L -n | /bin/grep 'Chain FORWARD')
output3=$(/sbin/iptables -L -n | /bin/grep 'Chain OUTPUT')

if [[ $output1 == *"DROP"* || $output1 == *"REJECT"* ]]; then
   if [[ $output2 == *"DROP"* || $output2 == *"REJECT"* ]]; then
      if [[ $output3 == *"DROP"* || $output3 == *"REJECT"* ]]; then
         status="PASS"
      else
         status="FAIL"
         detail="Output chain error"
      fi
   else
      status="FAIL"
      detail="Forward chain error"
   fi
else
   status="FAIL"
   detail="Input chain error"
fi
detail=$(echo "$output" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.3.2.2 Ensure iptables loopback traffic is configured"
echo "$testcase"
detail=""
echo "iptables OUTPUT"
output1=$(/sbin/iptables -L OUTPUT -v -n | /bin/awk '{ a[$3":"$4":"$6":"$7":"$8":"$9] = NR; print } END { if (a["ACCEPT:all:*:lo:0.0.0.0/0:0.0.0.0/0"] > 0) { print "pass" } else { print "fail" } }')
output=$(iptables -L INPUT -v -n)
echo "$output"
echo "iptables INPUT"
output2=$(/sbin/iptables -L INPUT -v -n | /bin/awk '{ a[$3":"$4":"$6":"$7":"$8":"$9] = NR; print } END { if (a["ACCEPT:all:lo:*:0.0.0.0/0:0.0.0.0/0"] > 0 && a["ACCEPT:all:lo:*:0.0.0.0/0:0.0.0.0/0"] < a["DROP:all:*:*:127.0.0.0/8:0.0.0.0/0"]) { print "pass" } else { print "fail" } }')
output=$(iptables -L OUTPUT -v -n)
echo "$output"
if [[ $output1 == "pass" && $output2 == "pass" ]]; then
   status="PASS"
else
   status="FAIL"
   detail="Misconfigured loopback traffic"
fi
detail=$(echo "$output" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.3.2.3 Ensure iptables outbound and established connections are configured"
echo "$testcase"
detail=""
output=$(/sbin/iptables -L -v -n)
echo "$output"
status="Pending"
detail="Verify manually"

echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.3.2.4 Ensure iptables firewall rules exist for all open ports"
echo "$testcase"
detail=""
output1=$(/bin/ss -4tuln)
output2=$(/sbin/iptables -L INPUT -v -n)
status="Pending"
detail="Verify manually"
echo -e "$output1\n$output2"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.3.3.1 Ensure ip6tables default deny firewall policy"
echo "$testcase"
detail=""

output1=$(ip6tables -L | /bin/grep 'Chain INPUT')
output2=$(ip6tables -L | /bin/grep 'Chain FORWARD')
output3=$(ip6tables -L | /bin/grep 'Chain OUTPUT')

if [[ $output1 == *"DROP"* || $output1 == *"REJECT"* ]]; then
   if [[ $output2 == *"DROP"* || $output2 == *"REJECT"* ]]; then
      if [[ $output3 == *"DROP"* || $output3 == *"REJECT"* ]]; then
         status="PASS"
      else
         output=$(/bin/grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable && /bin/echo 'IPv6 is enabled' || /bin/echo 'IPv6 is not enabled')
         if [[ $output != "IPv6 is enabled" ]]; then
            status="PASS"
            detail="IPv6 not enabled"
         else
            status="FAIL"
            detail="Ouput chain error"
         fi
      fi
   else
      status="FAIL"
      detail="Forward chain error"
   fi
else
   status="FAIL"
   detail="Input chain error"
fi
echo "$output"
echo -e "$output1\n$output2\n$output3"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.3.3.2 Ensure ip6tables loopback traffic is configured"
echo "$testcase"
detail=""
output=$(/bin/grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable && /bin/echo 'IPv6 is enabled' || /bin/echo 'IPv6 is not enabled')
if [[ $output == "IPv6 is not enabled" ]]; then
   status="PASS"
else
   output1=$(/sbin/ip6tables -L OUTPUT -v -n | /bin/awk '{ a[$3":"$4":"$5":"$6":"$7":"$8] = NR; print } END { if (a["ACCEPT:all:*:lo:::/0:::/0"] > 0) { print "pass" } else { print "fail" } }')
   output2=$(/sbin/ip6tables -L INPUT -v -n | /bin/awk '{ a[$3":"$4":"$5":"$6":"$7":"$8] = NR; print } END { if (a["ACCEPT:all:lo:*:::/0:::/0"] > 0 && a["ACCEPT:all:lo:*:::/0:::/0"] < a["DROP:all:*:*:::1:::/0"]) { print "pass" } else { print "fail" } }')
   if [[ $output1 == "pass" && $output2 == "pass" ]]; then
      status="PASS"
   else
      status="FAIL"
      detail="ip6tables INPUT OUTPUT error"
   fi
   output=$(/sbin/ip6tables -L INPUT -v -n)
   echo "$output"
   output=$(/sbin/ip6tables -L OUTPUT -v -n)
   echo "$output"
fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.3.3.3 Ensure ip6tables outbound and established connections are configured"
echo "$testcase"
detail="" output1="" output2=""
output=$(/bin/grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable && /bin/echo 'IPv6 is enabled' || /bin/echo 'IPv6 is not enabled')
if [[ $output == "IPv6 is not enabled" ]]; then
   status="PASS"
else
   output=$(/sbin/ip6tables -L -v -n)
   status="Pending"
   detail="Verify manually"
   detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.3.3.4 Ensure ip6tables firewall rules exist for all open ports"
echo "$testcase"
detail="" output1="" output2=""
output=$(/bin/grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable && /bin/echo 'IPv6 is enabled' || /bin/echo 'IPv6 is not enabled')
if [[ $output == "IPv6 is not enabled" ]]; then
   status="PASS"
else
   output1=$(/bin/ss -6tuln)
   output2=$(/sbin/ip6tables -L INPUT -v -n)
   status="Pending"
   detail="Verify manually"
fi
echo "$output1"
echo "$output2"
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="5.1.1 Ensure permissions on /etc/ssh/sshd_config are configured"
echo "$testcase"
detail=""

output=$({
   l_output="" l_output2=""
   perm_mask='0177' && maxperm="$( printf '%o' $(( 0777 & ~$perm_mask)) )"
   SSHD_FILES_CHK()
   {
      while IFS=: read -r l_mode l_user l_group; do
         l_out2=""
         [ $(( $l_mode & $perm_mask )) -gt 0 ] && l_out2="$l_out2\n  - Is mode: \"$l_mode\" should be: \"$maxperm\" or more restrictive"
         [ "$l_user" != "root" ] && l_out2="$l_out2\n  - Is owned by \"$l_user\" should be owned by \"root\""
         [ "$l_group" != "root" ] && l_out2="$l_out2\n  - Is group owned by \"$l_user\" should be group owned by \"root\""
         if [ -n "$l_out2" ]; then
            l_output2="$l_output2\n - File: \"$l_file\":$l_out2"
         else
            l_output="$l_output\n - File: \"$l_file\":\n  - Correct: mode ($l_mode), owner ($l_user), and group owner ($l_group) configured"
         fi
      done < <(stat -Lc '%#a:%U:%G' "$l_file")
   }
   [ -e "/etc/ssh/sshd_config" ] && l_file="/etc/ssh/sshd_config" && SSHD_FILES_CHK
   while IFS= read -r -d $'\0' l_file; do
      [ -e "$l_file" ] && SSHD_FILES_CHK
   done < <(find -L /etc/ssh/sshd_config.d -type f  \( -perm /077 -o ! -user root -o ! -group root \) -print0)
   if [ -z "$l_output2" ]; then
      echo -e "\n- Audit Result:\n  ** PASS **\n- * Correctly set * :\n$l_output\n"
   else
      echo -e "\n- Audit Result:\n  ** FAIL **\n - * Reasons for audit failure * :\n$l_output2\n"
      [ -n "$l_output" ] && echo -e " - * Correctly set * :\n$l_output\n"
   fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.2 Ensure permissions on SSH private host key files are configured"
echo "$testcase"
detail=""

output=$({
   l_output="" l_output2=""
   l_ssh_group_name="$(awk -F: '($1 ~ /^(ssh_keys|_?ssh)$/) {print $1}' /etc/group)"
   FILE_CHK()
   {
      while IFS=: read -r l_file_mode l_file_owner l_file_group; do
         l_out2=""
         [ "l_file_group" = "$l_ssh_group_name" ] && l_pmask="0137" || l_pmask="0177"
         l_maxperm="$( printf '%o' $(( 0777 & ~$l_pmask )) )"
         if [ $(( $l_file_mode & $l_pmask )) -gt 0 ]; then
            l_out2="$l_out2\n  - Mode: \"$l_file_mode\" should be mode: \"$l_maxperm\" or more restrictive"
         fi
         if [ "$l_file_owner" != "root" ]; then
            l_out2="$l_out2\n  - Owned by: \"$l_file_owner\" should be owned by \"root\""
         fi
         if [[ ! "$l_file_group" =~ ($l_ssh_group_name|root) ]]; then
            l_out2="$l_out2\n  - Owned by group \"$l_file_group\" should be group owned by: \"$l_ssh_group_name\" or \"root\""
         fi
         if [ -n "$l_out2" ]; then
            l_output2="$l_output2\n - File: \"$l_file\"$l_out2"
         else
            l_output="$l_output\n - File: \"$l_file\"\n  - Correct: mode: \"$l_file_mode\", owner: \"$l_file_owner\", and group owner: \"$l_file_group\" configured"
         fi
      done < <(stat -Lc '%#a:%U:%G' "$l_file")
   }
   while IFS= read -r -d $'\0' l_file; do
      if ssh-keygen -lf &>/dev/null "$l_file"; then
         file "$l_file" | grep -Piq -- '\bopenssh\h+([^#\n\r]+\h+)?private\h+key\b' && FILE_CHK
      fi
   done < <(find -L /etc/ssh -xdev -type f -print0)
   if [ -z "$l_output2" ]; then
      [ -z "$l_output" ] && l_output="\n  - No openSSH private keys found"
      echo -e "\n- Audit Result:\n  ** PASS **\n - * Correctly configured * :$l_output"
   else
      echo -e "\n- Audit Result:\n  ** FAIL **\n - * Reasons for audit failure * :$l_output2\n"
      [ -n "$l_output" ] && echo -e "\n - * Correctly configured * :\n$l_output\n"
   fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.3 Ensure permissions on SSH public host key files are configured"
echo "$testcase"
detail=""

output=$({
   l_output="" l_output2=""
   l_pmask="0133" && l_maxperm="$( printf '%o' $(( 0777 & ~$l_pmask )) )"
   FILE_CHK()
   {
      while IFS=: read -r l_file_mode l_file_owner l_file_group; do
         l_out2=""
         if [ $(( $l_file_mode & $l_pmask )) -gt 0 ]; then
            l_out2="$l_out2\n  - Mode: \"$l_file_mode\" should be mode: \"$l_maxperm\" or more restrictive"
         fi
         if [ "$l_file_owner" != "root" ]; then
            l_out2="$l_out2\n  - Owned by: \"$l_file_owner\" should be owned by \"root\""
         fi
         if [ "$l_file_group" != "root" ]; then
            l_out2="$l_out2\n  - Owned by group \"$l_file_group\" should be group owned by group: \"root\""
         fi
         if [ -n "$l_out2" ]; then
            l_output2="$l_output2\n - File: \"$l_file\"$l_out2"
         else
            l_output="$l_output\n - File: \"$l_file\"\n  - Correct: mode: \"$l_file_mode\", owner: \"$l_file_owner\", and group owner: \"$l_file_group\" configured"
         fi
      done < <(stat -Lc '%#a:%U:%G' "$l_file")
   }
   while IFS= read -r -d $'\0' l_file; do
      if ssh-keygen -lf &>/dev/null "$l_file"; then
         file "$l_file" | grep -Piq -- '\bopenssh\h+([^#\n\r]+\h+)?public\h+key\b' && FILE_CHK
      fi
   done < <(find -L /etc/ssh -xdev -type f -print0)
   if [ -z "$l_output2" ]; then
      [ -z "$l_output" ] && l_output="\n  - No openSSH public keys found"
      echo -e "\n- Audit Result:\n  ** PASS **\n - * Correctly configured * :$l_output"
   else
      echo -e "\n- Audit Result:\n  ** FAIL **\n - * Reasons for audit failure * :$l_output2\n"
      [ -n "$l_output" ] && echo -e "\n - * Correctly configured * :\n$l_output\n"
   fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.4 Ensure sshd access is configured"
echo "$testcase"
detail=""
output=$(sshd -T | grep -Pi -- '^\h*(allow|deny)(users|groups)\h+\H+')
status="Pending"
detail="Verify manually"
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.5 Ensure sshd Banner is configured"
echo "$testcase"
detail=""
output=$(sshd -T | grep -Pi -- '^banner\h+\/\H+')
if [[ -n "$output" ]]; then status="PASS"; else status="FAIL" detail="Not configured"; fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.6 Ensure sshd Ciphers are configured"
echo "$testcase"
detail=""
output=$(sshd -T | grep ciphers)
if [[ $output == *"3des-cbc"* || $output == *"aes128-cbc"* || $output == *"aes192-cbc"* || $output == *"aes256-cbc"* ]]; then
   status="FAIL"
   detail="$output"
else
   status="PASS"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.7 Ensure sshd ClientAliveInterval and ClientAliveCountMax are configured"
echo "$testcase"
detail=""
output=$(sshd -T | grep -Pi -- '(clientaliveinterval|clientalivecountmax)')
echo "ClientAliveCountMax is greater than 0"
output1=$(echo "$output" | grep clientaliveinterval)
echo "$output1"
echo "ClientAliveInterval is greater than 0"
output2=$(echo "$output" | grep clientalivecountmax)
echo "$output2"
let int1="$output1"
let int2="$output2"
if [ $int1 -gt 0 && $int2 -gt 0 ]; then status="PASS"; else status="FAIL" detail="Value less than 0"; fi
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.10 Ensure sshd HostbasedAuthentication is disabled"
echo "$testcase"
detail=""
output=$(sshd -T | grep hostbasedauthentication)
if [[ $output == "hostbasedauthentication no" ]]; then status="PASS"; else status="FAIL" detail="$output"; fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.11 Ensure sshd IgnoreRhosts is enabled"
echo "$testcase"
detail=""
output=$(sshd -T | grep ignorerhosts)
if [[ $output == "ignorerhosts yes" ]]; then status="PASS"; else status="FAIL" detail="$output"; fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.12 Ensure sshd KexAlgorithms is configured"
echo "$testcase"
detail=""
output=$(sshd -T | grep kexalgorithms)
if [[ $output == *"diffie-hellman-group1-sha1"* || $output == *"diffie-hellman-group14-sha1"* || $output == *"diffie-hellman-group-exchange-sha1"* ]]; then
   status="FAIL"
   detail="$output"
else 
   status="PASS"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.13 Ensure sshd LoginGraceTime is configured"
echo "$testcase"
detail=""
output=$(sshd -T | grep logingracetime)
output1=${output:15}
let int="$output1"
if [ $int -le 60 && $int -ge 1 ]; then
   status="PASS"
else
   status="FAIL"
   detail="$output"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.14 Ensure sshd LogLevel is configured"
echo "$testcase"
detail=""
output=$(sshd -T | grep loglevel)
if [[ $output == "loglevel VERBOSE" || $output == "loglevel INFO" ]]; then status="PASS"; else status="FAIL"; fi
echo "$output"
detail=$(echo "$output" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.15 Ensure sshd MACs are configured"
echo "$testcase"
detail=""
output=$(sshd -T | grep macs | grep -E "hmac-md5|hmac-md5-96|hmac-ripemd160|hmac-sha1-96|umac-64@openssh\.com|hmac-md5-etm@openssh\.com|hmac-md5-96-etm@openssh\.com|hmac-ripemd160-etm@openssh\.com|hmac-sha1-96-etm@openssh\.com|umac-64-etm@openssh\.com|umac-128-etm@openssh\.com")
if [[ -z "$output" ]]; then
   status="PASS"
else
   status="FAIL"
   detail="$output"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.16 Ensure sshd MaxAuthTries is configured"
echo "$testcase"
detail=""
output=$(sshd -T | grep maxauthtries)
output1=${output:13}
let int="$output1"
if [ "$int" -le 4 ]; then status="PASS"; else status="FAIL"; fi
echo "$output"
detail=$(echo "$output" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.17 Ensure sshd MaxSessions is configured"
echo "$testcase"
detail=""
output=$(sshd -T | grep -i maxsessions)
output1=${output:12}
let int="$output1"
if [ "$int" -le 10 ]; then status="PASS"; else status="FAIL" detail="maxsessions error"; fi
echo "$output"
output2=$(grep -Psi -- '^\h*MaxSessions\h+\"?(1[1-9]|[2-9][0-9]|[1-9][0-9][0-9]+)\b' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf)
if [[ -z "$output2" ]]; then status="PASS"; else status="FAIL"; fi
echo "$output2"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.18 Ensure sshd MaxStartups is configured"
echo "$testcase"
detail=""
output=$(sshd -T | awk '$1 ~ /^\s*maxstartups/{split($2, a, ":");{if(a[1] > 10 || a[2] > 30 || a[3] > 60) print $0}}')
if [[ -z "$output" ]]; then status="PASS"; else status="FAIL" detail="$output"; fi
echo "$output"
detail=$(echo "$output" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.19 Ensure sshd PermitEmptyPasswords is disabled"
echo "$testcase"
detail=""
output=$(sshd -T | grep permitemptypasswords)
if [[ $output == "permitemptypasswords no" ]]; then status="PASS"; else status="FAIL"; fi
echo "$output"
detail=$(echo "$output" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.20 Ensure sshd PermitRootLogin is disabled"
echo "$testcase"
detail=""
output=$(sshd -T | grep permitrootlogin)
if [[ $output == "permitrootlogin no" ]]; then status="PASS"; else status="FAIL"; fi
echo "$output"
detail=$(echo "$output" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.21 Ensure sshd PermitUserEnvironment is disabled"
echo "$testcase"
detail=""
output=$(sshd -T | grep permituserenvironment)
if [[ $output == "permituserenvironment no" ]]; then status="PASS"; else status="FAIL"; fi
echo "$output"
detail=$(echo "$output" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.22 Ensure sshd UsePAM is enabled"
echo "$testcase"
detail=""
output=$(sshd -T | grep -i usepam)
if [[ $output == "usepam yes" ]]; then status="PASS"; else status="FAIL"; fi
echo "$output"
detail=$(echo "$output" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="5.2.1 Ensure sudo is installed"
echo "$testcase"
detail=""
output1=$(/usr/bin/dpkg -s sudo 2>&1)
output2=$(/usr/bin/dpkg -s sudo-ldap 2>&1)
if [[ $output1 == *"install ok installed"* ]]; then 
   status="PASS"
else 
   if [[ $output2 == *"install ok installed"* ]]; then 
      status="PASS"
   else
      status="FAIL"
      detail="sudo and sudo-ldap not installed"
   fi
fi
echo "$output1"
echo "$output2"
detail=$(echo "$output" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.2.2 Ensure sudo commands use pty"
echo "$testcase"
detail=""

echo "/etc/sudoers use_pty"
output1=$(/bin/grep -rPi -- '^\h*Defaults\h+([^#\n\r]+,)?use_pty(,\h*\h+\h*)*\h*(#.*)?$' /etc/sudoers*)
if [[ $output1 == "/etc/sudoers:Defaults        use_pty" ]]; then
   output2=$(/bin/grep -rPi -- '^\h*Defaults\h+([^#\n\r]+,)?!use_pty(,\h*\h+\h*)*\h*(#.*)?$' /etc/sudoers* | /bin/awk '{print} END {if (NR == 0) print "pass" ; else print "fail"}')
   if [[ -z $output2 ]]; then
      status="PASS"
   else
      status="FAIL"
      detail="Defaults !use_pty"
   fi
else
   status="FAIL"
   detail="Defaults use_pty"
fi
echo "$output1"
echo "$output2"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.2.3 Ensure sudo log file exists"
echo "$testcase"
detail=""
$output=$(grep -rPsi "^\h*Defaults\h+([^#]+,\h*)?logfile\h*=\h*(\"|\')?\H+(\"|\')?(,\h*\H+\h*)*\h*(#.*)?$" /etc/sudoers*)
if [[ $output == "Defaults logfile=\"/var/log/sudo.log\"" ]]; then 
   status="PASS"
else
   status="FAIL"
   detail="$output"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.2.5 Ensure re-authentication for privilege escalation is not disabled globally"
echo "$testcase"
detail=""
output=$(grep -r "^[^#].*\!authenticate" /etc/sudoers*)
if [[ $output == *"!authenticate"* ]]; then status="FAIL" detail="!authenticate tag found"; else status="PASS" ; fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.2.6 Ensure sudo authentication timeout is configured correctly"
echo "$testcase"
detail=""
output=$(grep -roP "timestamp_timeout=\K[0-9]*" /etc/sudoers*)
if [[ -n $output ]]; then
   output1=${output:18}
   let int=$output1
   if [ "$int" -le 15 ]; then
      status="PASS"
   else
      status="FAIL"
      detail="Large timeout"
   fi
else
   output2=$(sudo -V | grep "Authentication timestamp timeout:")
   if [[ $output2 == *"15"* ]]; then
      status="PASS"
   else
      status="FAIL"
      detail="$output2"
   fi
   detail="Timeout not set"
fi
echo "$output"
echo "$output2"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.2.7 Ensure access to the su command is restricted"
echo "$testcase"
detail=""
output=$(/bin/grep -Pi '^\h*auth\h+(?:required|requisite)\h+pam_wheel\.so\h+(?:[^#\n\r]+\h+)?((?!\2)(use_uid\b|group=\H+\b))\h+(?:[^#\n\r]+\h+)?((?!\1)(use_uid\b|group=\H+\b))(\h+.*)?$' /etc/pam.d/su)
if [[ $output =~ auth[[:space:]]+required[[:space:]]+pam_wheel.so[[:space:]]+use_uid[[:space:]]+group=.* ]]; then
   output1=$(echo $output | grep -o "group=.*" | cut -d'=' -f2)
   echo "$output1"
   output2=$(grep $output1 /etc/group)
   echo "$output1"
   if [[ -z "$output2" ]]; then
      status="PASS"
   else
      status="FAIL"
      detail="Users present in the allowed group"
   fi
else
   status="FAIL"
   detail=$output
fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.3.1.1 Ensure latest version of pam is installed"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s libpam-runtime | /bin/grep -E '(Status:|Version)')
status="Pending - Verify manually"
detail=$output
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.3.1.2 Ensure libpam-modules is installed"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s libpam-modules | /bin/grep -E '(Status:|Version)')
if [[ $output == *"install ok installed"* ]]; then
   status="PASS"
else
   status="FAIL"
fi
detail=$output
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.3.1.3 Ensure libpam-pwquality is installed"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s libpam-pwquality 2>&1 | /bin/grep -E '(Status:|not installed)')
if [[ $output == *"install ok installed"* ]]; then
   status="PASS"
else
   status="FAIL"
fi
detail=$output
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.3.2.1 Ensure pam_unix module is enabled"
echo "$testcase"
detail=""
output=$(grep -P -- '\bpam_unix\.so\b' /etc/pam.d/common-{account,session,auth,password})
status="Pending - Verify manually"
detail=$output
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.3.2.2 Ensure pam_faillock module is enabled"
echo "$testcase"
detail=""
output=$(grep -P -- '\bpam_faillock\.so\b' /etc/pam.d/common-{auth,account})
status="Pending - Verify manually"
detail=$output
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.3.2.3 Ensure pam_pwquality module is enabled"
echo "$testcase"
detail=""
output=$(grep -P -- '\bpam_pwquality\.so\b' /etc/pam.d/common-password)
status="Pending - Verify manually"
detail=$output
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.3.2.4 Ensure pam_pwhistory module is enabled"
echo "$testcase"
detail=""
output=$(grep -P -- '\bpam_pwhistory\.so\b' /etc/pam.d/common-password)
status="Pending - Verify manually"
detail=$output
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.3.3.1.1 Ensure password failed attempts lockout is configured"
echo "$testcase"
detail=""
output1=$(grep -E '^.*deny = [0-5]$' /etc/security/faillock.conf)
output2=$(grep -Pi -- '^\h*auth\h+(requisite|required|sufficient)\h+pam_faillock\.so\h+([^#\n\r]+\h+)?deny\h*=\h*(0|[6-9]|[1-9][0-9]+)\b' /etc/pam.d/common-auth)
if [[ -n "$output1" && -z "$output2" ]]; then status="PASS"; else status="FAIL" detail="Misconfig in deny or auth"; fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo "Deny -> $output1"
echo "Auth -> $output2"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.3.3.1.2 Ensure password unlock time is configured"
echo "$testcase"
detail=""
output=$(grep -o "^# unlock_time = .*" /etc/security/faillock.conf)
output1=${output:16}
output2=$(grep -Pi -- '^\h*auth\h+(requisite|required|sufficient)\h+pam_faillock\.so\h+([^#\n\r]+\h+)?unlock_time\h*=\h*([1-9]|[1-9][0-9]|[1-8][0-9][0-9])\b' /etc/pam.d/common-auth)
let int="$output1"
if [[ $int -eq 0 || $int -ge 900 ]]; then
   if [[ -z "$output2" ]]; then 
      status="PASS"
   else 
      status="FAIL"
      detail="Issue in Auth pam_faillock.so" 
   fi
else
   status="FAIL"
   detail="unlock_time not proper"
fi
echo "$output"
echo "$output2"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.3.3.2.1 Ensure password number of changed characters is configured"
echo "$testcase"
detail=""
output1=$(grep "difok" /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf 2>&1)
output2=$(grep -Psi -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?difok\h*=\h*([0-1])\b' /etc/pam.d/common-password)
if [[ $outpu1 =~ difok[[:space:]]+=[[:space:]][2-9][0-9]+ && -z "$output2" ]]; then status="PASS"; else status="FAIL" detail="pwquality not set properly"; fi
echo "$output1"
echo "$output2"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.3.3.2.2 Ensure minimum password length is configured"
echo "$testcase"
detail=""
output1=$(grep "difok" /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf 2>&1)
output2=$(grep -Psi -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?minlen\h*=\h*([0-9]|1[0-3])\b' /etc/pam.d/system-auth /etc/pam.d/common-password)
if [[ $output1 =~ minlen[[:space:]]+=[[:space:]][1-9][4-9][0-9]+  && -z "$output2" ]]; then status="PASS"; else status="FAIL" detail="minlen value not proper"; fi
echo "$output1"
echo "$output2"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.3.3.2.3 Ensure password complexity is configured"
echo "$testcase"
detail=""
output1=$(grep -Psi -- '^\h*(minclass|[dulo]credit)\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf)
echo "$output1"
output2=$(grep -Psi -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?(minclass=\d*|[dulo]credit=-?\d*)\b' /etc/pam.d/common-password)
echo "$output2"
status="Pending"
detail="Verify manually"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.3.3.2.4 Ensure password same consecutive characters is configured"
echo "$testcase"
detail=""
output1=$(grep "maxrepeat" /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf)
output2=$(grep -Psi -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?maxrepeat\h*=\h*(0|[4-9]|[1-9][0-9]+)\b' /etc/pam.d/common-password)
if [[ $outpu1 =~ maxrepeat[[:space:]]+=[[:space:]][1-3] && -z "$output2" ]]; then status="PASS"; else status="FAIL" detail="pwquality not set properly"; fi
echo "$output1"
echo "$output2"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.3.3.2.5 Ensure password maximum sequential characters is configured"
echo "$testcase"
detail=""
output1=$(grep "maxsequence" /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf 2>&1)
output2=$(grep -Psi -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?maxsequence\h*=\h*(0|[4-9]|[1-9][0-9]+)\b' /etc/pam.d/common-password)
if [[ $outpu1 =~ maxsequence[[:space:]]+=[[:space:]][1-3] && -z "$output2" ]]; then status="PASS"; else status="FAIL" detail="pwquality not set properly"; fi
echo "$output1"
echo "$output2"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.3.3.2.6 Ensure password dictionary check is enabled"
echo "$testcase"
detail=""
output1=$(grep "dictcheck" /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf 2>&1)
output2=$( grep -Psi -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?dictcheck\h*=\h*0\b' /etc/pam.d/common-password)
if [[ $output1 != *"dictcheck = 0" && -z "$output2" ]]; then status="PASS"; else status="FAIL" detail="pwquality not set properly"; fi
echo "$output1"
echo "$output2"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.3.3.2.7 Ensure password quality checking is enforced"
echo "$testcase"
detail=""
output1=$(grep "enforcing" /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf 2>&1)
output2=$(grep -PHsi -- '^\h*password\h+[^#\n\r]+\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?enforcing=0\b' /etc/pam.d/common-password)
if [[ $output1 != *"enforcing = 0" && -z "$output2" ]]; then status="PASS"; else status="FAIL" detail="pwquality not set properly"; fi
echo "$output1"
echo "$output2"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.3.3.2.8 Ensure password quality is enforced for the root user"
echo "$testcase"
detail=""
output=$(grep "enforce_for_root" /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf 2>&1)
if [[ -n "$output" ]]; then status="PASS"; else status="FAIL" detail="$output"; fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.3.3.3.1 Ensure password history remember is configured"
echo "$testcase"
detail=""
output=$(grep -Psi -- '^\h*password\h+[^#\n\r]+\h+pam_pwhistory\.so\h+([^#\n\r]+\h+)?remember=\d+\b' /etc/pam.d/common-password)
status="Pending - Verify manually"
detail=$output
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.3.3.3.2 Ensure password history is enforced for the root user"
echo "$testcase"
detail=""
output=$(grep -Psi -- '^\h*password\h+[^#\n\r]+\h+pam_pwhistory\.so\h+([^#\n\r]+\h+)?enforce_for_root\b' /etc/pam.d/common-password)
status="Pending - Verify manually"
detail=$output
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.3.3.3.3 Ensure pam_pwhistory includes use_authtok"
echo "$testcase"
detail=""
output=$(grep -Psi -- '^\h*password\h+[^#\n\r]+\h+pam_pwhistory\.so\h+([^#\n\r]+\h+)?use_authtok\b' /etc/pam.d/common-password)
status="Pending - Verify manually"
detail=$output
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.3.3.4.1 Ensure pam_unix does not include nullok"
echo "$testcase"
detail=""
output=$(grep -PH -- '^\h*^\h*[^#\n\r]+\h+pam_unix\.so\b' /etc/pam.d/common-{password,auth,account,session,session-noninteractive} | grep -Pv -- '\bnullok\b')
status="Pending - Verify manually"
detail=$output
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
output=$(grep "pam_unix.so" /etc/pam.d/common-password /etc/pam.d/common-auth /etc/pam.d/common-account /etc/pam.d/common-session /etc/pam.d/common-session-noninteractive)
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.3.3.4.2 Ensure pam_unix does not include remember"
echo "$testcase"
detail=""
output=$(grep -PH -- '^\h*^\h*[^#\n\r]+\h+pam_unix\.so\b' /etc/pam.d/common-{password,auth,account,session,session-noninteractive} | grep -Pv -- '\bremember=\d+\b')
status="Pending - Verify manually"
detail=$output
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
output=$(grep "pam_unix.so" /etc/pam.d/common-password /etc/pam.d/common-auth /etc/pam.d/common-account /etc/pam.d/common-session /etc/pam.d/common-session-noninteractive)
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.3.3.4.3 Ensure pam_unix includes a strong password hashing algorithm"
echo "$testcase"
detail=""
output=$(grep -PH -- '^\h*password\h+([^#\n\r]+)\h+pam_unix\.so\h+([^#\n\r]+\h+)?(sha512|yescrypt)\b' /etc/pam.d/common-password)
status="Pending - Verify manually"
detail=$output
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
output=$(grep "pam_unix.so" /etc/pam.d/common-password)
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.3.3.4.4 Ensure pam_unix includes use_authtok"
echo "$testcase"
detail=""
output=$(grep -PH -- '^\h*password\h+([^#\n\r]+)\h+pam_unix\.so\h+([^#\n\r]+\h+)?use_authtok\b' /etc/pam.d/common-password)
status="Pending - Verify manually"
detail=$output
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
output=$(grep "pam_unix.so" /etc/pam.d/common-password)
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.4.1.1 Ensure password expiration is configured"
echo "$testcase"
detail=""
output1=$(grep -Pi -- '^\h*PASS_MAX_DAYS\h+\d+\b' /etc/login.defs)
if [[ $output1 =~ PASS_MAX_DAYS[[:space:]]+[1-365]+ ]]; then
   output2=$(awk -F: '($2~/^\$.+\$/) {if($5 > 365 || $5 < 1)print "User: " $1 " PASS_MAX_DAYS: " $5}' /etc/shadow)
   echo "/etc/shadow -> $output2"
   if [[ -z "$output2 " ]]; then status="PASS"; else status="FAIL" detail="More than 365 days - /etc/shadow"; fi
else
   status="FAIL"
   detail="/etc/login.defs -> $output1"
fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output1"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.4.1.3 Ensure password expiration warning days is configured"
echo "$testcase"
detail=""
output1=$(grep -Pi -- '^\h*PASS_WARN_AGE\h+\d+\b' /etc/login.defs)
if [[ $output1 =~ PASS_WARN_AGE[[:space:]]+[7-9][0-9]* ]]; then
   output2=$(awk -F: '($2~/^\$.+\$/) {if($6 < 7)print "User: " $1 " PASS_WARN_AGE: " $6}' /etc/shadow)
   if [[ -z "$output2" ]]; then status="PASS"; else status="FAIL" detail="Less than 7 - etc shadow"; fi
else
   status="FAIL"
   detail="/etc/login.defs -> $output1"
fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output1"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.4.1.4 Ensure strong password hashing algorithm is configured"
echo "$testcase"
detail=""
output=$(grep -Pi -- '^\h*ENCRYPT_METHOD\h+(SHA512|yescrypt)\b' /etc/login.defs)
if [[ $output == "ENCRYPT_METHOD SHA512" || $output == "ENCRYPT_METHOD YESCRYPT" ]]; then status="PASS"; else status="FAIL"; fi
detail=$output
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.4.1.5 Ensure inactive password lock is configured"
echo "$testcase"
detail=""
output=$(useradd -D | grep INACTIVE)
output1=${output:9}
let int=$output1
if [[ $int -le 45 ]]; then 
   output2=$(awk -F: '($2~/^\$.+\$/) {if($7 > 45 || $7 < 0)print "User: " $1 " INACTIVE: " $7}' /etc/shadow)
   echo "/etc/shadow -> $output2"
   if [[ -z "$output" ]]; then
      status="PASS"
   else
      status="FAIL"
      detail="Etc shadow error"
   fi
else 
   status="FAIL"
fi
detail=$output
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.4.1.6 Ensure all users last password change date is in the past"
echo "$testcase"
detail=""
output=$({
while IFS= read -r l_user; do
   l_change=$(date -d "$(chage --list $l_user | grep '^Last password change' | cut -d: -f2 | grep -v 'never$')" +%s)
   if [[ "$l_change" -gt "$(date +%s)" ]]; then
      echo "User: \"$l_user\" last password change was \"$(chage --list $l_user | grep '^Last password change' | cut -d: -f2)\""
   fi
done < <(awk -F: '/^[^:\r]+:[^!*xX\r]/{print $1}' /etc/shadow)
} | /bin/awk '{print} END {if (NR == 0) print "Pass"}')
if [[ $output == "Pass" ]]; then status="PASS"; else status="FAIL"; fi
detail=$output
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.4.2.1 Ensure root is the only UID 0 account"
echo "$testcase"
detail=""
output=$(awk -F: '($3 == 0) { print $1 }' /etc/passwd)
if [[ $output == "root" ]]; then status="PASS"; else status="FAIL"; fi
detail=$output
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.4.2.2 Ensure root is the only GID 0 account"
echo "$testcase"
detail=""
output=$(awk -F: '($1 !~ /^(sync|shutdown|halt|operator)/ && $4=="0") {print $1":"$4}' /etc/passwd)
if [[ $output == "root:0" ]]; then status="PASS"; else status="FAIL"; fi

detail=$output
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.4.2.3 Ensure group root is the only GID 0 group"
echo "$testcase"
detail=""
output=$(awk -F: '$3=="0"{print $1":"$3}' /etc/group)
if [[ $output == "root:0" ]]; then status="PASS"; else status="FAIL"; fi
detail=$output
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.4.2.4 Ensure root password is set"
echo "$testcase"
detail=""
output=$(/bin/passwd -S root | /bin/awk '$2 ~ /^P/ {print "User: \"" $1 "\" Password is set"}')
if [[ $output == "User: \"root\" Password is set" ]]; then status="PASS"; else status="FAIL"; fi
detail=$output
detail=$(echo "$detail" | tr '\n,' ' ')
output=$(/bin/passwd -S root)
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.4.2.5 Ensure root path integrity"
echo "$testcase"
detail=""

output=$({
   l_output2=""
   l_pmask="0022"
   l_maxperm="$( printf '%o' $(( 0777 & ~$l_pmask )) )"
   l_root_path="$(sudo -Hiu root env | grep '^PATH' | cut -d= -f2)"
   unset a_path_loc && IFS=":" read -ra a_path_loc <<< "$l_root_path"
   grep -q "::" <<< "$l_root_path" && l_output2="$l_output2
 - root's path contains a empty directory (::)"
   grep -Pq ":\h*$" <<< "$l_root_path" && l_output2="$l_output2
 - root's path contains a trailing (:)"
   grep -Pq '(\h+|:)\.(:|\h*$)' <<< "$l_root_path" && l_output2="$l_output2
 - root's path contains current working directory (.)"
   while read -r l_path; do
      if [ -d "$l_path" ]; then
         while read -r l_fmode l_fown; do
            [ "$l_fown" != "root" ] && l_output2="$l_output2
 - Directory: \"$l_path\" is owned by: \"$l_fown\" should be owned by \"root\""
            [ $(( $l_fmode & $l_pmask )) -gt 0 ] && l_output2="$l_output2
 - Directory: \"$l_path\" is mode: \"$l_fmode\" and should be mode: \"$l_maxperm\" or more restrictive"
         done <<< "$(stat -Lc '%#a %U' "$l_path")"
      else
         l_output2="$l_output2
 - \"$l_path\" is not a directory"
      fi
   done <<< "$(printf "%s
" "${a_path_loc[@]}")"
   if [ -z "$l_output2" ]; then
      echo -e "
- Audit Result:
  *** PASS ***
 - Root's path is correctly configured
"
   else
      echo -e "
- Audit Result:
  ** FAIL **
 - * Reasons for audit failure * :
$l_output2
"
   fi
})

if [[ "$output" =~ '*** PASS ***' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.4.2.6 Ensure root user umask is configured"
echo "$testcase"
detail=""
output=$(grep -Psi -- '^\h*umask\h+(([0-7][0-7][01][0-7]\b|[0-7][0-7][0-7][0-6]\b)|([0-7][01][0-7]\b|[0-7][0-7][0-6]\b)|(u=[rwx]{1,3},)?(((g=[rx]?[rx]?w[rx]?[rx]?\b)(,o=[rwx]{1,3})?)|((g=[wrx]{1,3},)?o=[wrx]{1,3}\b)))' /root/.bash_profile /root/.bashrc)
if [[ -z "$output" ]]; then status="PASS"; else status="FAIL"; fi
echo "$thehostname,$testcase,$status,$detail" >> $result_file
detail=$output
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.4.2.7 Ensure system accounts do not have a valid login shell"
echo "$testcase"
detail=""
output=$({
   l_valid_shells="^($(awk -F\/ '$NF != "nologin" {print}' /etc/shells | sed -rn '/^\//{s,/,\\\\/,g;p}' | paste -s -d '|' - ))$"
   awk -v pat="$l_valid_shells" -F: '($1!~/^(root|halt|sync|shutdown|nfsnobody)$/ && ($3<'"$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)"' || $3 == 65534) && $(NF) ~ pat) {print "Service account: \"" $1 "\" has a valid shell: " $7}' /etc/passwd
})
if [[ -z "$output" ]]; then status="PASS"; else status="FAIL"; fi
detail=$output
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.4.2.8 Ensure accounts without a valid login shell are locked"
echo "$testcase"
detail=""
output=$({
   l_valid_shells="^($(awk -F\/ '$NF != "nologin" {print}' /etc/shells | sed -rn '/^\//{s,/,\\\\/,g;p}' | paste -s -d '|' - ))$"
   while IFS= read -r l_user; do
      passwd -S "$l_user" | awk '$2 !~ /^L/ {print "Account: \"" $1 "\" does not have a valid login shell and is not locked"}'
   done < <(awk -v pat="$l_valid_shells" -F: '($1 != "root" && $(NF) !~ pat) {print $1}' /etc/passwd)
})
if [[ -z "$output" ]]; then status="PASS"; else status="FAIL"; fi
detail=$output
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.4.3.2 Ensure default user shell timeout is configured"
echo "$testcase"
detail=""

output=$({
   output1="" output2=""
   [ -f /etc/bashrc ] && BRC="/etc/bashrc"
   for f in "$BRC" /etc/profile /etc/profile.d/*.sh ; do
      grep -Pq '^\s*([^#]+\s+)?TMOUT=(900|[1-8][0-9][0-9]|[1-9][0-9]|[1-9])\b' "$f" && grep -Pq '^\s*([^#]+;\s*)?readonly\s+TMOUT(\s+|\s*;|\s*$|=(900|[1-8][0-9][0-9]|[1-9][0-9]|[1-9]))\b' "$f" && grep -Pq '^\s*([^#]+;\s*)?export\s+TMOUT(\s+|\s*;|\s*$|=(900|[1-8][0-9][0-9]|[1-9][0-9]|[1-9]))\b' "$f" &&
   output1="$f"
   done
   grep -Pq '^\s*([^#]+\s+)?TMOUT=(9[0-9][1-9]|9[1-9][0-9]|0+|[1-9]\d{3,})\b' /etc/profile /etc/profile.d/*.sh "$BRC" && output2=$(grep -Ps '^\s*([^#]+\s+)?TMOUT=(9[0-9][1-9]|9[1-9][0-9]|0+|[1-9]\d{3,})\b' /etc/profile /etc/profile.d/*.sh $BRC)
   if [ -n "$output1" ] && [ -z "$output2" ]; then
      echo -e "PASSED TMOUT is configured in: \"$output1\""
   else
      [ -z "$output1" ] && echo -e "FAILED TMOUT is not configured"
      [ -n "$output2" ] && echo -e "FAILED TMOUT is incorrectly configured in: \"$output2\""
   fi
})
if [[ $output == *"PASSED"* ]]; then status="PASS"; else status="FAIL" detail=$output; fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.4.3.3 Ensure default user umask is configured"
echo "$testcase"
detail=""

output=$({
    l_output="" l_output2=""
    file_umask_chk()
    {
       if grep -Psiq -- '^\h*umask\h+(0?[0-7][2-7]7|u(=[rwx]{0,3}),g=([rx]{0,2}),o=)(\h*#.*)?$' "$l_file"; then
          l_output="$l_output\n - umask is set correctly in \"$l_file\""
       elif grep -Psiq -- '^\h*umask\h+(([0-7][0-7][01][0-7]\b|[0-7][0-7][0-7][0-6]\b)|([0-7][01][0-7]\b|[0-7][0-7][0-6]\b)|(u=[rwx]{1,3},)?(((g=[rx]?[rx]?w[rx]?[rx]?\b)(,o=[rwx]{1,3})?)|((g=[wrx]{1,3},)?o=[wrx]{1,3}\b)))' "$l_file"; then
          l_output2="$l_output2\n - umask is incorrectly set in \"$l_file\""
       fi
    }
    while IFS= read -r -d $'\0' l_file; do
       file_umask_chk
    done < <(find /etc/profile.d/ -type f -name '*.sh' -print0)
    [ -z "$l_output" ] && l_file="/etc/profile" && file_umask_chk
    [ -z "$l_output" ] && l_file="/etc/bashrc" && file_umask_chk
    [ -z "$l_output" ] && l_file="/etc/bash.bashrc" && file_umask_chk
    [ -z "$l_output" ] && l_file="/etc/pam.d/postlogin"
    if [ -z "$l_output" ]; then
       if grep -Psiq -- '^\h*session\h+[^#\n\r]+\h+pam_umask\.so\h+([^#\n\r]+\h+)?umask=(0?[0-7][2-7]7)\b' "$l_file"; then
          l_output1="$l_output1\n - umask is set correctly in \"$l_file\""
       elif grep -Psiq '^\h*session\h+[^#\n\r]+\h+pam_umask\.so\h+([^#\n\r]+\h+)?umask=(([0-7][0-7][01][0-7]\b|[0-7][0-7][0-7][0-6]\b)|([0-7][01][0-7]\b))' "$l_file"; then
          l_output2="$l_output2\n - umask is incorrectly set in \"$l_file\""
       fi
    fi
    [ -z "$l_output" ] && l_file="/etc/login.defs" && file_umask_chk
    [ -z "$l_output" ] && l_file="/etc/default/login" && file_umask_chk
    [[ -z "$l_output" && -z "$l_output2" ]] && l_output2="$l_output2\n - umask is not set"
    if [ -z "$l_output2" ]; then
       echo -e "\n- Audit Result:\n  ** PASS **\n - * Correctly configured * :\n$l_output\n"
    else
       echo -e "\n- Audit Result:\n  ** FAIL **\n - * Reasons for audit failure * :\n$l_output2"
       [ -n "$l_output" ] && echo -e "\n- * Correctly configured * :\n$l_output\n"
    fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="6.1.1 Ensure AIDE is installed"
echo "$testcase"
detail=""
aidecheck=""
output1=$(dpkg-query -s aide &>/dev/null && echo "aide is installed")
output2=$(dpkg-query -s aide-common &>/dev/null && echo "aide-common is installed")
if [[ $output1 == *"aide is installed"* && $output2 == *"aide-common is installed"* ]]; then
   status="PASS"
   aidecheck="TRUE"
else
   status="FAIL"
   detail="Not installed"
   aidecheck="FALSE"
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

if [[ $aidecheck == "TRUE" ]]; then 

testcase="6.1.2 Ensure filesystem integrity is regularly checked"
echo "$testcase"
detail=""

echo "check if aidecheck.service is enabled"
output1=$(/bin/systemctl is-enabled aidecheck.service)

echo "check if aidecheck.timer is enabled"
output2=$(/bin/systemctl is-enabled aidecheck.timer)

echo "check if aidecheck.timer is active"
output3=$(/bin/systemctl status aidecheck.timer)

if [[ $output1 == *"enabled"* ]]; then
   if [[ $output2 == *"enabled"* ]]; then
      if [[ $output3 != *"aidecheck.timer could not be found"* ]]; then
         status="PASS"
      else
         status="FAIL"
         detail="aidecheck timer not running"
      fi
   else
      status="FAIL"
      detail="aidecheck timer not enabled"
   fi
else
   status="FAIL"
   detail="aidecheck service not enabled"
fi
echo -e "$output1\n$output2\n$output3"    
echo "$thehostname,$testcase,$status,$detail" >> $result_file

fi

testcase="6.2.1.1.1 Ensure journald service is enabled and active"
echo "$testcase"
detail=""
journaldserviceout=""
output1=$(systemctl is-enabled systemd-journald.service)
output2=$(systemctl is-active systemd-journald.service)
if [[ $output1 == "static" && $output2 == "active" ]]; then
   status="PASS"
   journaldserviceout="TRUE"
else
   status="FAIL"
   journaldserviceout="FALSE"
   detail="Not enabled or not active"
fi
echo -e "$output1\n$output2"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

if [[ $journaldserviceout == "TRUE" ]]; then

testcase="6.2.1.1.2 Ensure journald log file access is configured"
echo "$testcase"
detail=""
output1=$(cat /etc/tmpfiles.d/systemd.conf)
output2=$(cat /usr/lib/tmpfiles.d/systemd.conf)
status="Pending"
detail="Verify manually - Check output"
echo -e "$output1\n$output2"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="6.2.1.1.3 Ensure journald log file rotation is configured"
echo "$testcase"
detail=""
output1=$(grep -e "SystemMaxUse=" -e "SystemKeepFree=" -e "RuntimeMaxUse=" -e "RuntimeKeepFree=" -e "MaxFileSec=" /etc/systemd/journald.conf)
output2=$(grep -e "SystemMaxUse=" -e "SystemKeepFree=" -e "RuntimeMaxUse=" -e "RuntimeKeepFree=" -e "MaxFileSec=" /etc/systemd/journald.conf.d/*.conf)
status="Pending"
detail="Verify manually - Check output"
echo -e "$output1\n$output2"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="6.2.1.1.4 Ensure journald ForwardToSyslog is disabled"
echo "$testcase"
detail=""

output=$({
   l_output="" l_output2=""
   a_parlist=("ForwardToSyslog=yes")
   l_systemd_config_file="/etc/systemd/journald.conf" # Main systemd configuration file
   config_file_parameter_chk()
   {
      unset A_out; declare -A A_out # Check config file(s) setting
      while read -r l_out; do
         if [ -n "$l_out" ]; then
            if [[ $l_out =~ ^\s*# ]]; then
               l_file="${l_out//# /}"
            else
               l_systemd_parameter="$(awk -F= '{print $1}' <<< "$l_out" | xargs)"
               grep -Piq -- "^\h*$l_systemd_parameter_name\b" <<< "$l_systemd_parameter" && A_out+=(["$l_systemd_parameter"]="$l_file")
            fi
         fi
      done < <(/usr/bin/systemd-analyze cat-config "$l_systemd_config_file" | grep -Pio '^\h*([^#\n\r]+|#\h*\/[^#\n\r\h]+\.conf\b)')
      if (( ${#A_out[@]} > 0 )); then # Assess output from files and generate output
         while IFS="=" read -r l_systemd_file_parameter_name l_systemd_file_parameter_value; do
            l_systemd_file_parameter_name="${l_systemd_file_parameter_name// /}"
            l_systemd_file_parameter_value="${l_systemd_file_parameter_value// /}"
            if ! grep -Piq "^\h*$l_systemd_parameter_value\b" <<< "$l_systemd_file_parameter_value"; then
               l_output="$l_output\n - \"$l_systemd_parameter_name\" is correctly set to \"$l_systemd_file_parameter_value\" in \"$(printf '%s' "${A_out[@]}")\"\n"
            else
               l_output2="$l_output2\n - \"$l_systemd_parameter_name\" is incorrectly set to \"$l_systemd_file_parameter_value\" in \"$(printf '%s' "${A_out[@]}")\"\n"
            fi
         done < <(grep -Pio -- "^\h*$l_systemd_parameter_name\h*=\h*\H+" "${A_out[@]}")
      else
         l_output="$l_output\n - \"$l_systemd_parameter_name\" is not set in an included file\n   ** Note: \"$l_systemd_parameter_name\" May be set in a file that's ignored by load procedure **\n"
      fi
   }
   while IFS="=" read -r l_systemd_parameter_name l_systemd_parameter_value; do # Assess and check parameters
      l_systemd_parameter_name="${l_systemd_parameter_name// /}"
      l_systemd_parameter_value="${l_systemd_parameter_value// /}"
      config_file_parameter_chk
   done < <(printf '%s\n' "${a_parlist[@]}")
   if [ -z "$l_output2" ]; then # Provide output from checks
      echo -e "\n- Audit Result:\n  ** PASS **\n$l_output\n"
   else
      echo -e "\n- Audit Result:\n  ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
      [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
   fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="6.2.1.1.5 Ensure journald Storage is configured"
echo "$testcase"
detail=""

output=$({
   l_output="" l_output2=""
   a_parlist=("Storage=persistent")
   l_systemd_config_file="/etc/systemd/journald.conf" # Main systemd configuration file
   config_file_parameter_chk()
   {
      unset A_out; declare -A A_out # Check config file(s) setting
      while read -r l_out; do
         if [ -n "$l_out" ]; then
            if [[ $l_out =~ ^\s*# ]]; then
               l_file="${l_out//# /}"
            else
               l_systemd_parameter="$(awk -F= '{print $1}' <<< "$l_out" | xargs)"
               grep -Piq -- "^\h*$l_systemd_parameter_name\b" <<< "$l_systemd_parameter" && A_out+=(["$l_systemd_parameter"]="$l_file")
            fi
         fi
      done < <(/usr/bin/systemd-analyze cat-config "$l_systemd_config_file" | grep -Pio '^\h*([^#\n\r]+|#\h*\/[^#\n\r\h]+\.conf\b)')
      if (( ${#A_out[@]} > 0 )); then # Assess output from files and generate output
         while IFS="=" read -r l_systemd_file_parameter_name l_systemd_file_parameter_value; do
            l_systemd_file_parameter_name="${l_systemd_file_parameter_name// /}"
            l_systemd_file_parameter_value="${l_systemd_file_parameter_value// /}"
            if grep -Piq "^\h*$l_systemd_parameter_value\b" <<< "$l_systemd_file_parameter_value"; then
               l_output="$l_output\n - \"$l_systemd_parameter_name\" is correctly set to \"$l_systemd_file_parameter_value\" in \"$(printf '%s' "${A_out[@]}")\"\n"
            else
               l_output2="$l_output2\n - \"$l_systemd_parameter_name\" is incorrectly set to \"$l_systemd_file_parameter_value\" in \"$(printf '%s' "${A_out[@]}")\" and should have a value matching: \"$l_systemd_parameter_value\"\n"
            fi
         done < <(grep -Pio -- "^\h*$l_systemd_parameter_name\h*=\h*\H+" "${A_out[@]}")
      else
         l_output2="$l_output2\n - \"$l_systemd_parameter_name\" is not set in an included file\n   ** Note: \"$l_systemd_parameter_name\" May be set in a file that's ignored by load procedure **\n"
      fi
   }
   while IFS="=" read -r l_systemd_parameter_name l_systemd_parameter_value; do # Assess and check parameters
      l_systemd_parameter_name="${l_systemd_parameter_name// /}"
      l_systemd_parameter_value="${l_systemd_parameter_value// /}"
      config_file_parameter_chk
   done < <(printf '%s\n' "${a_parlist[@]}")
   if [ -z "$l_output2" ]; then # Provide output from checks
      echo -e "\n- Audit Result:\n  ** PASS **\n$l_output\n"
   else
      echo -e "\n- Audit Result:\n  ** FAIL **\n - Reason(s) for audit failure:\n$l_output2"
      [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
   fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="6.2.1.1.6 Ensure journald Compress is configured"
echo "$testcase"
detail=""

output=$({
   l_output="" l_output2=""
   a_parlist=("Compress=yes")
   l_systemd_config_file="/etc/systemd/journald.conf" # Main systemd configuration file
   config_file_parameter_chk()
   {
      unset A_out; declare -A A_out # Check config file(s) setting
      while read -r l_out; do
         if [ -n "$l_out" ]; then
            if [[ $l_out =~ ^\s*# ]]; then
               l_file="${l_out//# /}"
            else
               l_systemd_parameter="$(awk -F= '{print $1}' <<< "$l_out" | xargs)"
               grep -Piq -- "^\h*$l_systemd_parameter_name\b" <<< "$l_systemd_parameter" && A_out+=(["$l_systemd_parameter"]="$l_file")
            fi
         fi
      done < <(/usr/bin/systemd-analyze cat-config "$l_systemd_config_file" | grep -Pio '^\h*([^#\n\r]+|#\h*\/[^#\n\r\h]+\.conf\b)')
      if (( ${#A_out[@]} > 0 )); then # Assess output from files and generate output
         while IFS="=" read -r l_systemd_file_parameter_name l_systemd_file_parameter_value; do
            l_systemd_file_parameter_name="${l_systemd_file_parameter_name// /}"
            l_systemd_file_parameter_value="${l_systemd_file_parameter_value// /}"
            if grep -Piq "^\h*$l_systemd_parameter_value\b" <<< "$l_systemd_file_parameter_value"; then
               l_output="$l_output\n - \"$l_systemd_parameter_name\" is correctly set to \"$l_systemd_file_parameter_value\" in \"$(printf '%s' "${A_out[@]}")\"\n"
            else
               l_output2="$l_output2\n - \"$l_systemd_parameter_name\" is incorrectly set to \"$l_systemd_file_parameter_value\" in \"$(printf '%s' "${A_out[@]}")\" and should have a value matching: \"$l_systemd_parameter_value\"\n"
            fi
         done < <(grep -Pio -- "^\h*$l_systemd_parameter_name\h*=\h*\H+" "${A_out[@]}")
      else
         l_output2="$l_output2\n - \"$l_systemd_parameter_name\" is not set in an included file\n   ** Note: \"$l_systemd_parameter_name\" May be set in a file that's ignored by load procedure **\n"
      fi
   }
   while IFS="=" read -r l_systemd_parameter_name l_systemd_parameter_value; do # Assess and check parameters
      l_systemd_parameter_name="${l_systemd_parameter_name// /}"
      l_systemd_parameter_value="${l_systemd_parameter_value// /}"
      config_file_parameter_chk
   done < <(printf '%s\n' "${a_parlist[@]}")
   if [ -z "$l_output2" ]; then # Provide output from checks
      echo -e "\n- Audit Result:\n  ** PASS **\n$l_output\n"
   else
      echo -e "\n- Audit Result:\n  ** FAIL **\n - Reason(s) for audit failure:\n$l_output2"
      [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
   fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

fi

testcase="6.2.1.2.1 Ensure systemd-journal-remote is installed"
echo "$testcase"
detail=""
journalremoteout=""
output=$(/bin/dpkg -s systemd-journal-remote 2>&1 | /bin/grep -E '(Status:|not installed)')
if [[ $output == *"is installed"* ]]; then
   status="PASS"
   journalremoteout="TRUE"
else
   status="FAIL"
   journalremoteout="FALSE"
   detail="Not installed"
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

if [[ $journalremoteout == "TRUE" ]]; then

testcase="6.2.1.2.2 Ensure systemd-journal-remote authentication is configured"
echo "$testcase"
detail=""
output=$(grep -P "^ *URL=|^ *ServerKeyFile=|^ *ServerCertificateFile=|^ *TrustedCertificateFile=" /etc/systemd/journal-upload.conf)
status="Pending"
detail="Verify manually"
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="6.2.1.2.3 Ensure systemd-journal-upload is enabled and active"
echo "$testcase"
detail=""
output1=$(systemctl is-enabled systemd-journal-upload.service)
output2=$(systemctl is-active systemd-journal-upload.service)
if [[ $output1 == "enabled" && $output2 == "active" ]]; then
   status="PASS"
else
   status="FAIL"
   detail="Not installed"
fi
echo -e "$output1\n$output2"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="6.2.1.2.4 Ensure systemd-journal-remote service is not in use"
echo "$testcase"
detail=""
output1=$(systemctl is-enabled systemd-journal-remote.socket systemd-journal-remote.service | grep -P -- '^enabled')
output2=$(systemctl is-enabled systemd-journal-remote.socket systemd-journal-remote.service | grep -P -- '^active')
if [[ -z "$output" && -z "$output" ]]; then status="PASS"; else status="FAIL" detail="Active or Enabled"; fi
echo -e "$output1\n$output2"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

fi

testcase="6.2.2.1 Ensure access to all logfiles has been configured"
echo "$testcase"
detail=""

output=$({
   l_op2="" l_output2=""
   l_uidmin="$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)"
   file_test_chk()
   {
      l_op2=""
      if [ $(( $l_mode & $perm_mask )) -gt 0 ]; then
         l_op2="$l_op2
  - Mode: \"$l_mode\" should be \"$maxperm\" or more restrictive"
      fi
      if [[ ! "$l_user" =~ $l_auser ]]; then
         l_op2="$l_op2
  - Owned by: \"$l_user\" and should be owned by \"${l_auser//|/ or }\""
      fi
      if [[ ! "$l_group" =~ $l_agroup ]]; then
         l_op2="$l_op2
  - Group owned by: \"$l_group\" and should be group owned by \"${l_agroup//|/ or }\""
      fi
      [ -n "$l_op2" ] && l_output2="$l_output2
 - File: \"$l_fname\" is:$l_op2
"
   }
   unset a_file && a_file=() # clear and initialize array
   # Loop to create array with stat of files that could possibly fail one of the audits
   while IFS= read -r -d $'\0' l_file; do
      [ -e "$l_file" ] && a_file+=("$(stat -Lc '%n^%#a^%U^%u^%G^%g' "$l_file")")
   done < <(find -L /var/log -type f \( -perm /0137 -o ! -user root -o ! -group root \) -print0)
   while IFS="^" read -r l_fname l_mode l_user l_uid l_group l_gid; do
      l_bname="$(basename "$l_fname")"
      case "$l_bname" in
         lastlog | lastlog.* | wtmp | wtmp.* | wtmp-* | btmp | btmp.* | btmp-* | README)
            perm_mask='0113'
            maxperm="$( printf '%o' $(( 0777 & ~$perm_mask)) )"
            l_auser="root"
            l_agroup="(root|utmp)"
            file_test_chk
            ;;
         secure | auth.log | syslog | messages)
            perm_mask='0137'
            maxperm="$( printf '%o' $(( 0777 & ~$perm_mask)) )"
            l_auser="(root|syslog)"
            l_agroup="(root|adm)"
            file_test_chk
            ;;
         SSSD | sssd)
            perm_mask='0117'
            maxperm="$( printf '%o' $(( 0777 & ~$perm_mask)) )"
            l_auser="(root|SSSD)"
            l_agroup="(root|SSSD)"
            file_test_chk
            ;;
         gdm | gdm3)
            perm_mask='0117'
            maxperm="$( printf '%o' $(( 0777 & ~$perm_mask)) )"
            l_auser="root"
            l_agroup="(root|gdm|gdm3)"
            file_test_chk
            ;;
         *.journal | *.journal~)
            perm_mask='0137'
            maxperm="$( printf '%o' $(( 0777 & ~$perm_mask)) )"
            l_auser="root"
            l_agroup="(root|systemd-journal)"
            file_test_chk
            ;;
         *)
            perm_mask='0137'
            maxperm="$( printf '%o' $(( 0777 & ~$perm_mask)) )"
            l_auser="(root|syslog)"
            l_agroup="(root|adm)"
            if [ "$l_uid" -lt "$l_uidmin" ] && [ -z "$(awk -v grp="$l_group" -F: '$1==grp {print $4}' /etc/group)" ]; then
               if [[ ! "$l_user" =~ $l_auser ]]; then
                  l_auser="(root|syslog|$l_user)"
               fi
               if [[ ! "$l_group" =~ $l_agroup ]]; then
                  l_tst=""
                  while l_out3="" read -r l_duid; do
                     [ "$l_duid" -ge "$l_uidmin" ] && l_tst=failed
                  done <<< "$(awk -F: '$4=='"$l_gid"' {print $3}' /etc/passwd)"
                  [ "$l_tst" != "failed" ] && l_agroup="(root|adm|$l_group)"
               fi
            fi
            file_test_chk
            ;;
      esac
   done <<< "$(printf '%s
' "${a_file[@]}")"
   unset a_file # Clear array
   # If all files passed, then we pass
   if [ -z "$l_output2" ]; then
      echo -e "
- Audit Results:
 ** Pass **
- All files in \"/var/log/\" have appropriate permissions and ownership
"
   else
      # print the reason why we are failing
      echo -e "
- Audit Results:
 ** Fail **
$l_output2"
   fi
})

if [[ "$output" =~ '** Pass **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="7.1.1 Ensure permissions on /etc/passwd are configured"
echo "$testcase"
detail=""
output=$(stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /etc/passwd)
if [[ $output == "Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)" ]]; then
   status="PASS"
else
   $output=${output:10:3}
   let int=$output
   if [[ $int -le 644 ]]; then status="PASS"; else status="FAIL" detail="Improper privilege"; fi
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="7.1.2 Ensure permissions on /etc/passwd- are configured"
echo "$testcase"
detail=""
output=$(stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /etc/passwd-)
output1=${output:10:3}
let int=$output1
if [[ $int -le 644 && $output == *"Uid: ( 0/ root) Gid: ( 0/ root)"* ]]; then status="PASS"; else status="FAIL" detail="Improper privilege"; fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="7.1.3 Ensure permissions on /etc/group are configured"
echo "$testcase"
detail=""
output=$(stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /etc/group)
output1=${output:10:3}
let int=$output1
if [[ $int -le 644 && $output == *"Uid: ( 0/ root) Gid: ( 0/ root)"* ]]; then status="PASS"; else status="FAIL" detail="Improper privilege"; fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="7.1.4 Ensure permissions on /etc/group- are configured"
echo "$testcase"
detail=""
output=$(stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /etc/group-)
output1=${output:10:3}
let int=$output1
if [[ $int -le 644 && $output == *"Uid: ( 0/ root) Gid: ( 0/ root)"* ]]; then status="PASS"; else status="FAIL" detail="Improper privilege"; fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="7.1.5 Ensure permissions on /etc/shadow are configured"
echo "$testcase"
detail=""
output=$(stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /etc/shadow)
output1=${output:10:3}
let int=$output1
if [[ $int -le 640 ]] && ([[ $output == *"Uid: ( 0/ root) Gid: ( 0/ root)"* ]] || [[ $output == *"Uid: ( 0/ root) Gid: ( 42/ shadow)"* ]]); then status="PASS"; else status="FAIL" detail="Improper privilege"; fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="7.1.6 Ensure permissions on /etc/shadow- are configured"
echo "$testcase"
detail=""
output=$(stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /etc/shadow-)
output1=${output:10:3}
let int=$output1
if [[ $int -le 640 ]] && ([[ $output == *"Uid: ( 0/ root) Gid: ( 0/ root)"* ]] || [[ $output == *"Uid: ( 0/ root) Gid: ( 42/ shadow)"* ]]); then status="PASS"; else status="FAIL" detail="Improper privilege"; fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="7.1.7 Ensure permissions on /etc/gshadow are configured"
echo "$testcase"
detail=""
output=$(stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /etc/gshadow)
output1=${output:10:3}
let int=$output1
if [[ $int -le 640 ]] && ([[ $output == *"Uid: ( 0/ root) Gid: ( 0/ root)"* ]] || [[ $output == *"Uid: ( 0/ root) Gid: ( 42/ shadow)"* ]]); then status="PASS"; else status="FAIL" detail="Improper privilege"; fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="7.1.8 Ensure permissions on /etc/gshadow- are configured"
echo "$testcase"
detail=""
output=$(stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /etc/gshadow-)
output1=${output:10:3}
let int=$output1
if [[ $int -le 640 ]] && ([[ $output == *"Uid: ( 0/ root) Gid: ( 0/ root)"* ]] || [[ $output == *"Uid: ( 0/ root) Gid: ( 42/ shadow)"* ]]); then status="PASS"; else status="FAIL" detail="Improper privilege"; fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="7.1.9 Ensure permissions on /etc/shells are configured"
echo "$testcase"
detail=""
output=$(stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /etc/shells)
output1=${output:10:3}
let int=$output1
if [[ $int -le 644 && $output == *"Uid: ( 0/ root) Gid: ( 0/ root)"* ]]; then status="PASS"; else status="FAIL" detail="Improper privilege"; fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="7.1.10 Ensure permissions on /etc/security/opasswd are configured"
echo "$testcase"
detail=""
output1=$([ -e "/etc/security/opasswd" ] && stat -Lc '%n Access: (%#a/%A) Uid: (%u/ %U) Gid: ( %g/ %G)' /etc/security/opasswd)
output2=$([ -e "/etc/security/opasswd.old" ] && stat -Lc '%n Access: (%#a/%A) Uid: (%u/ %U) Gid: ( %g/ %G)' /etc/security/opasswd.old)
echo "$output1"
echo "$output2"
if [[ $output1 == *"Access: (0600/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)"* &&  $output2 == *"Access: (0600/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)"* ]]; then
   status="PASS"
else
   output1=${output1:32:3}
   output2=${output2:36:3}
   if [[ $output1 =~ ^-?[0-9]+$ ]]; then
      let int1=$output1
   fi
   if [[ $output2 =~ ^-?[0-9]+$ ]]; then
      let int2=$output2
   fi
   if [[ $int1 -le 600 && $int2 -le 600 ]]; then status="PASS"; else status="FAIL" detail="Improper privilege"; fi
fi
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="7.1.11 Ensure world writable files and directories are secured"
echo "$testcase"
detail=""
output=$({
 l_output="" l_output2=""
 l_smask='01000'
 a_file=(); a_dir=() # Initialize arrays
 a_path=(! -path "/run/user/*" -a ! -path "/proc/*" -a ! -path "*/containerd/*" -a ! -path "*/kubelet/pods/*" -a ! -path "*/kubelet/plugins/*" -a ! -path "/sys/*" -a ! -path "/snap/*")
 while IFS= read -r l_mount; do
 while IFS= read -r -d $'\0' l_file; do
 if [ -e "$l_file" ]; then
 [ -f "$l_file" ] && a_file+=("$l_file") # Add WR files
 if [ -d "$l_file" ]; then # Add directories w/o sticky bit
 l_mode="$(stat -Lc '%#a' "$l_file")"
 [ ! $(( $l_mode & $l_smask )) -gt 0 ] && a_dir+=("$l_file")
 fi
 fi
 done < <(find "$l_mount" -xdev \( "${a_path[@]}" \) \( -type f -o -type d \) -perm -0002 -print0 2> /dev/null)
 done < <(findmnt -Dkerno fstype,target | awk '($1 !~ /^\s*(nfs|proc|smb|vfat|iso9660|efivarfs|selinuxfs)/ && $2 !~ /^(\/run\/user\/|\/tmp|\/var\/tmp)/){print $2}')
 if ! (( ${#a_file[@]} > 0 )); then
 l_output="$l_output\n - No world writable files exist on the local filesystem."
 else
 l_output2="$l_output2\n - There are \"$(printf '%s' "${#a_file[@]}")\" World writable files on the system.\n - The following is a list of World writable files:\n$(printf '%s\n' "${a_file[@]}")\n - end of list\n"
 fi
 if ! (( ${#a_dir[@]} > 0 )); then
 l_output="$l_output\n - Sticky bit is set on world writable directories on the local filesystem."
 else
 l_output2="$l_output2\n - There are \"$(printf '%s' "${#a_dir[@]}")\" World writable directories without the sticky bit on the system.\n - The following is a list of World writable directories without the sticky bit:\n$(printf '%s\n' "${a_dir[@]}")\n - end of list\n"
 fi
 unset a_path; unset a_arr; unset a_file; unset a_dir # Remove arrays
 # If l_output2 is empty, we pass
 if [ -z "$l_output2" ]; then
 echo -e "\n- Audit Result:\n ** PASS **\n - * Correctly configured * :\n$l_output\n"
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :\n$l_output2"
 [ -n "$l_output" ] && echo -e "- * Correctly configured * :\n$l_output\n"
 fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="7.1.12 Ensure no files or directories without an owner and a group exist"
echo "$testcase"
detail=""
output=$({
 l_output="" l_output2=""
 a_nouser=(); a_nogroup=() # Initialize arrays
 a_path=(! -path "/run/user/*" -a ! -path "/proc/*" -a ! -path "*/containerd/*" -a ! -path "*/kubelet/pods/*" -a ! -path "*/kubelet/plugins/*" -a ! -path "/sys/fs/cgroup/memory/*" -a ! -path "/var/*/private/*")
 while IFS= read -r l_mount; do
 while IFS= read -r -d $'\0' l_file; do
 if [ -e "$l_file" ]; then
 while IFS=: read -r l_user l_group; do
 [ "$l_user" = "UNKNOWN" ] && a_nouser+=("$l_file")
 [ "$l_group" = "UNKNOWN" ] && a_nogroup+=("$l_file")
 done < <(stat -Lc '%U:%G' "$l_file")
 fi
 done < <(find "$l_mount" -xdev \( "${a_path[@]}" \) \( -type f -o -type d \) \( -nouser -o -nogroup \) -print0 2> /dev/null)
 done < <(findmnt -Dkerno fstype,target | awk '($1 !~ /^\s*(nfs|proc|smb|vfat|iso9660|efivarfs|selinuxfs)/ && $2 !~ /^\/run\/user\//){print $2}')
 if ! (( ${#a_nouser[@]} > 0 )); then
 l_output="$l_output\n - No files or directories without a owner exist on the local filesystem."
 else
 l_output2="$l_output2\n - There are \"$(printf '%s' "${#a_nouser[@]}")\" unowned files or directories on the system.\n - The following is a list of unowned files and/or directories:\n$(printf '%s\n' "${a_nouser[@]}")\n - end of list"
 fi
 if ! (( ${#a_nogroup[@]} > 0 )); then
 l_output="$l_output\n - No files or directories without a group exist on the local filesystem."
 else
 l_output2="$l_output2\n - There are \"$(printf '%s' "${#a_nogroup[@]}")\" ungrouped files or directories on the system.\n - The following is a list of ungrouped files and/or directories:\n$(printf '%s\n' "${a_nogroup[@]}")\n - end of list"
 fi 
 unset a_path; unset a_arr ; unset a_nouser; unset a_nogroup # Remove 
arrays
 if [ -z "$l_output2" ]; then # If l_output2 is empty, we pass
 echo -e "\n- Audit Result:\n ** PASS **\n - * Correctly configured * :\n$l_output\n"
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :\n$l_output2"
 [ -n "$l_output" ] && echo -e "\n- * Correctly configured * :\n$l_output\n"
 fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="7.1.13 Ensure SUID and SGID files are reviewed"
echo "$testcase"
detail=""
output=$({
 l_output="" l_output2=""
 a_suid=()
 a_sgid=()
 while IFS= read -r l_mount_point; do
 if ! grep -Pqs '^\h*/run/usr\b' <<< "$l_mount_point" && ! grep -Pqs -- '\bnoexec\b' <<< "$(findmnt -krn "$l_mount_point")"; then
 while IFS= read -r -d $'\0' l_file; do
 if [ -e "$l_file" ]; then
 l_mode="$(stat -Lc '%#a' "$l_file")"
 [ $(( $l_mode & 04000 )) -gt 0 ] && a_suid+=("$l_file")
 [ $(( $l_mode & 02000 )) -gt 0 ] && a_sgid+=("$l_file")
 fi
 done < <(find "$l_mount_point" -xdev -type f \( -perm -2000 -o -perm -4000 \) -print0 2>/dev/null)
 fi
 done <<< "$(findmnt -Derno target)"
 if ! (( ${#a_suid[@]} > 0 )); then
 l_output="$l_output\n - No executable SUID files exist on the system"
 else
 l_output2="$l_output2\n - List of \"$(printf '%s' "${#a_suid[@]}")\" SUID executable files:\n$(printf '%s\n' "${a_suid[@]}")\n - end of list -\n"
 fi
 if ! (( ${#a_sgid[@]} > 0 )); then
 l_output="$l_output\n - There are no SGID files exist on the system"
 else
 l_output2="$l_output2\n - List of \"$(printf '%s' "${#a_sgid[@]}")\" SGID executable files:\n$(printf '%s\n' "${a_sgid[@]}")\n - end of list -\n"
 fi
 [ -n "$l_output2" ] && l_output2="$l_output2\n- Review the preceding list(s) of SUID and/or SGID files to\n- ensure that no rogue programs have been introduced onto the system.\n" 
 unset a_arr; unset a_suid; unset a_sgid # Remove arrays
 # If l_output2 is empty, Nothing to report
 if [ -z "$l_output2" ]; then
 echo -e "\n- Audit Result:\n$l_output\n"
 else
 echo -e "\n- Audit Result:\n$l_output2\n"
 [ -n "$l_output" ] && echo -e "$l_output\n"
 fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="7.2.1 Ensure accounts in /etc/passwd use shadowed passwords"
echo "$testcase"
detail=""
output=$(awk -F: '($2 != "x" ) { print "User: \"" $1 "\" is not set to shadowed passwords "}' /etc/passwd)
if [[ -z "$output" ]]; then status="PASS"; else status="FAIL" detail="$output"; fi
echo "$output"
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="7.2.2 Ensure /etc/shadow password fields are not empty"
echo "$testcase"
detail=""
output=$(awk -F: '($2 == "" ) { print $1 " does not have a password "}' /etc/shadow)
if [[ -z "$output" ]]; then status="PASS"; else status="FAIL" detail="$output"; fi
detail=$(echo "$detail" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="7.2.3 Ensure all groups in /etc/passwd exist in /etc/group"
echo "$testcase"
detail=""
output=$({
 a_passwd_group_gid=("$(awk -F: '{print $4}' /etc/passwd | sort -u)")
 a_group_gid=("$(awk -F: '{print $3}' /etc/group | sort -u)")
 a_passwd_group_diff=("$(printf '%s\n' "${a_group_gid[@]}" "${a_passwd_group_gid[@]}" | sort | uniq -u)")
 while IFS= read -r l_gid; do
 awk -F: '($4 == '"$l_gid"') {print " - User: \"" $1 "\" has GID: \"" $4 "\" which does not exist in /etc/group" }' /etc/passwd
 done < <(printf '%s\n' "${a_passwd_group_gid[@]}" "${a_passwd_group_diff[@]}" | sort | uniq -D | uniq)
 unset a_passwd_group_gid; unset a_group_gid; unset a_passwd_group_diff
})
if [[ -z "$output" ]]; then status="PASS"; else status="FAIL"; fi
detail=$(echo "$output" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="7.2.4 Ensure shadow group is empty"
echo "$testcase"
detail=""
output1=$(awk -F: '($1=="shadow") {print $NF}' /etc/group)
output2=$(awk -F: '($4 == '"$(getent group shadow | awk -F: '{print $3}' | xargs)"') {print " - user: \"" $1 "\" primary group is the shadow group"}' /etc/passwd)
if [[ -z "$output1" && -z "$output2" ]]; then status="PASS"; else status="FAIL"; fi
detail=$(echo "$output" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="7.2.5 Ensure no duplicate UIDs exist"
echo "$testcase"
detail=""
output=$({
 while read -r l_count l_uid; do
 if [ "$l_count" -gt 1 ]; then
 echo -e "Duplicate UID: \"$l_uid\" Users: \"$(awk -F: '($3 == n) { print $1 }' n=$l_uid /etc/passwd | xargs)\""
 fi
 done < <(cut -f3 -d":" /etc/passwd | sort -n | uniq -c)
})
if [[ -z "$output" ]]; then status="PASS"; else status="FAIL"; fi
detail=$(echo "$output" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="7.2.6 Ensure no duplicate GIDs exist"
echo "$testcase"
detail=""
output=$({
 while read -r l_count l_gid; do
 if [ "$l_count" -gt 1 ]; then
 echo -e "Duplicate GID: \"$l_gid\" Groups: \"$(awk -F: '($3 == n) { print $1 }' n=$l_gid /etc/group | xargs)\""
 fi
 done < <(cut -f3 -d":" /etc/group | sort -n | uniq -c)
})
if [[ -z "$output" ]]; then status="PASS"; else status="FAIL"; fi
detail=$(echo "$output" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="7.2.7 Ensure no duplicate user names exist"
echo "$testcase"
detail=""
output=$({
 while read -r l_count l_user; do
 if [ "$l_count" -gt 1 ]; then
 echo -e "Duplicate User: \"$l_user\" Users: \"$(awk -F: '($1 == n) { print $1 }' n=$l_user /etc/passwd | xargs)\""
 fi
 done < <(cut -f1 -d":" /etc/group | sort -n | uniq -c)
})
if [[ -z "$output" ]]; then status="PASS"; else status="FAIL"; fi
detail=$(echo "$output" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="7.2.8 Ensure no duplicate group names exist"
echo "$testcase"
detail=""
output=$({
 while read -r l_count l_group; do
 if [ "$l_count" -gt 1 ]; then
 echo -e "Duplicate Group: \"$l_group\" Groups: \"$(awk -F: '($1 == n) { print $1 }' n=$l_group /etc/group | xargs)\""
 fi
 done < <(cut -f1 -d":" /etc/group | sort -n | uniq -c)
})
if [[ -z "$output" ]]; then status="PASS"; else status="FAIL"; fi
detail=$(echo "$output" | tr '\n,' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="7.2.9 Ensure local interactive user home directories are configured"
echo "$testcase"
detail=""

output=$({
   l_output="" l_output2="" l_heout2="" l_hoout2="" l_haout2=""
   l_valid_shells="^($( awk -F\/ '$NF != "nologin" {print}' /etc/shells | sed -rn '/^\//{s,/,\\\\/,g;p}' | paste -s -d '|' - ))$"
   unset a_uarr && a_uarr=() # Clear and initialize array
   while read -r l_epu l_eph; do # Populate array with users and user home location
      a_uarr+=("$l_epu $l_eph")
   done <<< "$(awk -v pat="$l_valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' /etc/passwd)"
   l_asize="${#a_uarr[@]}" # Here if we want to look at number of users before proceeding
   [ "$l_asize " -gt "10000" ] && echo -e "
  ** INFO **
  - \"$l_asize\" Local interactive users found on the system
  - This may be a long running check
"
   while read -r l_user l_home; do
      if [ -d "$l_home" ]; then
         l_mask='0027'
         l_max="$( printf '%o' $(( 0777 & ~$l_mask)) )"
         while read -r l_own l_mode; do
            [ "$l_user" != "$l_own" ] && l_hoout2="$l_hoout2
  - User: \"$l_user\" Home \"$l_home\" is owned by: \"$l_own\""
            if [ $(( $l_mode & $l_mask )) -gt 0 ]; then
               l_haout2="$l_haout2
  - User: \"$l_user\" Home \"$l_home\" is mode: \"$l_mode\" should be mode: \"$l_max\" or more restrictive"
            fi
         done <<< "$(stat -Lc '%U %#a' "$l_home")"
      else
         l_heout2="$l_heout2
  - User: \"$l_user\" Home \"$l_home\" Doesn't exist"
      fi
   done <<< "$(printf '%s
' "${a_uarr[@]}")"
   [ -z "$l_heout2" ] && l_output="$l_output
   - home directories exist" || l_output2="$l_output2$l_heout2"
   [ -z "$l_hoout2" ] && l_output="$l_output
   - own their home directory" || l_output2="$l_output2$l_hoout2"
   [ -z "$l_haout2" ] && l_output="$l_output
   - home directories are mode: \"$l_max\" or more restrictive" || l_output2="$l_output2$l_haout2"
   [ -n "$l_output" ] && l_output="  - All local interactive users:$l_output"
   if [ -z "$l_output2" ]; then # If l_output2 is empty, we pass
      echo -e "
- Audit Result:
  ** PASS **
 - * Correctly configured * :
$l_output"
   else
      echo -e "
- Audit Result:
  ** FAIL **
 - * Reasons for audit failure * :
$l_output2"
      [ -n "$l_output" ] && echo -e "
- * Correctly configured * :
$l_output"
   fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="7.2.10 Ensure local interactive user dot files access is configured"
echo "$testcase"
detail=""

output=$({
   l_output="" l_output2="" l_output3=""
   l_bf="" l_df="" l_nf="" l_hf=""
   l_valid_shells="^($( awk -F\/ '$NF != "nologin" {print}' /etc/shells | sed -rn '/^\//{s,/,\\\\/,g;p}' | paste -s -d '|' - ))$"
   unset a_uarr && a_uarr=() # Clear and initialize array
   while read -r l_epu l_eph; do # Populate array with users and user home location
      [[ -n "$l_epu" && -n "$l_eph" ]] && a_uarr+=("$l_epu $l_eph")
   done <<< "$(awk -v pat="$l_valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' /etc/passwd)"
   l_asize="${#a_uarr[@]}" # Here if we want to look at number of users before proceeding
   l_maxsize="1000" # Maximun number of local interactive users before warning (Default 1,000)
   [ "$l_asize " -gt "$l_maxsize" ] && echo -e "
  ** INFO **
  - \"$l_asize\" Local interactive users found on the system
  - This may be a long running check
"
   file_access_chk()
   {
      l_facout2=""
      l_max="$( printf '%o' $(( 0777 & ~$l_mask)) )"
      if [ $(( $l_mode & $l_mask )) -gt 0 ]; then
         l_facout2="$l_facout2
  - File: \"$l_hdfile\" is mode: \"$l_mode\" and should be mode: \"$l_max\" or more restrictive"
      fi
      if [[ ! "$l_owner" =~ ($l_user) ]]; then
         l_facout2="$l_facout2
  - File: \"$l_hdfile\" owned by: \"$l_owner\" and should be owned by \"${l_user//|/ or }\""
      fi
      if [[ ! "$l_gowner" =~ ($l_group) ]]; then
         l_facout2="$l_facout2
  - File: \"$l_hdfile\" group owned by: \"$l_gowner\" and should be group owned by \"${l_group//|/ or }\""
      fi
   }
   while read -r l_user l_home; do
      l_fe="" l_nout2="" l_nout3="" l_dfout2="" l_hdout2="" l_bhout2=""
      if [ -d "$l_home" ]; then
         l_group="$(id -gn "$l_user" | xargs)"
         l_group="${l_group// /|}"
         while IFS= read -r -d $'\0' l_hdfile; do
            while read -r l_mode l_owner l_gowner; do
               file_basename=$(basename "$l_hdfile")

               if [ "$file_basename" = ".forward" ] || [ "$file_basename" = ".rhost" ]; then
                  l_fe="Y" && l_bf="Y"
                  l_dfout2="$l_dfout2
               - File: \"$l_hdfile\" exists"
               elif [ "$file_basename" = ".netrc" ]; then
                  l_mask='0177'
                  file_access_chk
                  if [ -n "$l_facout2" ]; then
                     l_fe="Y" && l_nf="Y"
                     l_nout2="$l_facout2"
                  else
                     l_nout3="   - File: \"$l_hdfile\" exists"
                  fi
               elif [ "$file_basename" = ".bash_history" ]; then
                  l_mask='0177'
                  file_access_chk
                  if [ -n "$l_facout2" ]; then
                     l_fe="Y" && l_hf="Y"
                     l_bhout2="$l_facout2"
                  fi
               else
                  l_mask='0133'
                  file_access_chk
                  if [ -n "$l_facout2" ]; then
                     l_fe="Y" && l_df="Y"
                     l_hdout2="$l_facout2"
                  fi
               fi

            done <<< "$(stat -Lc '%#a %U %G' "$l_hdfile")"
         done < <(find "$l_home" -xdev -type f -name '.*' -print0)
      fi
      if [ "$l_fe" = "Y" ]; then
         l_output2="$l_output2
 - User: \"$l_user\" Home Directory: \"$l_home\""
         [ -n "$l_dfout2" ] && l_output2="$l_output2$l_dfout2"
         [ -n "$l_nout2" ] && l_output2="$l_output2$l_nout2"
         [ -n "$l_bhout2" ] && l_output2="$l_output2$l_bhout2"
         [ -n "$l_hdout2" ] && l_output2="$l_output2$l_hdout2"
      fi
      [ -n "$l_nout3" ] && l_output3="$l_output3
  - User: \"$l_user\" Home Directory: \"$l_home\"
$l_nout3"
   done <<< "$(printf '%s
' "${a_uarr[@]}")"
   unset a_uarr # Remove array
   [ -n "$l_output3" ] && l_output3=" - ** Warning **
 - \".netrc\" files should be removed unless deemed necessary
   and in accordance with local site policy:$l_output3"
   [ -z "$l_bf" ] && l_output="$l_output
   - \".forward\" or \".rhost\" files"
   [ -z "$l_nf" ] && l_output="$l_output
   - \".netrc\" files with incorrect access configured"
   [ -z "$l_hf" ] && l_output="$l_output
   - \".bash_history\" files with incorrect access configured"
   [ -z "$l_df" ] && l_output="$l_output
   - \"dot\" files with incorrect access configured"
   [ -n "$l_output" ] && l_output="  - No local interactive users home directories contain:$l_output"
   if [ -z "$l_output2" ]; then # If l_output2 is empty, we pass
      echo -e "
- Audit Result:
  ** PASS **
 - * Correctly configured * :
$l_output
"
      echo -e "$l_output3
"
   else
      echo -e "
- Audit Result:
  ** FAIL **
 - * Reasons for audit failure * :
$l_output2
"
      echo -e "$l_output3
"
      [ -n "$l_output" ] && echo -e "- * Correctly configured * :
$l_output
"
   fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
searchstring="audit failure:"
rest1=${output#*$searchstring}
ind1=$(( ${#output} - ${#rest1} - ${#searchstring} ))
searchstring="Correctly set:"
rest2=${output#*$searchstring}
ind2=$(( ${#output} - ${#rest2} - ${#searchstring} ))
detail=${output:ind1+14:ind2-ind1-16}
detail=$(echo "$detail" | tr '\n,' ' ')
fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

echo "CIS_Ubuntu_Linux_22.04_LTS_v2.0.0_L1_Server.audit from CIS Ubuntu Linux 22.04 LTS Benchmark v2.0.0"