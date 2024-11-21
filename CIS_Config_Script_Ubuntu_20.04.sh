
result_file='result2004.csv'
echo 'Hostname,Testcase,Status,Detail' > "$result_file"
thehostname=$(hostname)

testcase="1.1.1.1 Ensure mounting of cramfs filesystems is disabled"
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
 l_output3="$l_output3\n - \"$l_mdir\""
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
 echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
 [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
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
detail=$(echo "$detail" | tr '\n' ' ')
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')

echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.1.2 Ensure mounting of freevxfs filesystems is disabled"
echo "$testcase"
detail=""
output=$({
 l_output="" l_output2="" l_output3="" l_dl="" # Unset output variables
 l_mname="freevxfs" # set module name
 l_mtype="fs" # set module type
 l_searchloc="/lib/modprobe.d/*.conf /usr/local/lib/modprobe.d/*.conf /run/modprobe.d/*.conf 
/etc/modprobe.d/*.conf"
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
 l_output3="$l_output3\n - \"$l_mdir\""
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
 echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
 [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
 fi
}
)

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
detail=$(echo "$detail" | tr '\n' ' ')
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.1.3 Ensure mounting of jffs2 filesystems is disabled"
echo "$testcase"
detail=""

output=$({
 l_output="" l_output2="" l_output3="" l_dl="" # Unset output variables
 l_mname="jffs2" # set module name
 l_mtype="fs" # set module type
 l_searchloc="/lib/modprobe.d/*.conf /usr/local/lib/modprobe.d/*.conf /run/modprobe.d/*.conf 
/etc/modprobe.d/*.conf"
 l_mpath="/lib/modules/**/kernel/$l_mtype"
 l_mpname="$(tr '-' '_' <<< "$l_mname")"
 l_mndir="$(tr '-' '/' <<< "$l_mname")"
 module_loadable_chk()
 {
 # Check if the module is currently loadable
 l_loadable="$(modprobe -n -v "$l_mname")"
 [ "$(wc -l <<< "$l_loadable")" -gt "1" ] && l_loadable="$(grep -P --
"(^\h*install|\b$l_mname)\b" <<< "$l_loadable")"
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
 l_output="$l_output\n - module: \"$l_mname\" is deny listed in: \"$(grep -Pls --
"^\h*blacklist\h+$l_mname\b" $l_searchloc)\""
 else
 l_output2="$l_output2\n - module: \"$l_mname\" is not deny listed"
 fi
 }
 # Check if the module exists on the system
 for l_mdir in $l_mpath; do
 if [ -d "$l_mdir/$l_mndir" ] && [ -n "$(ls -A $l_mdir/$l_mndir)" ]; then
 l_output3="$l_output3\n - \"$l_mdir\""
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
 echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
 [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
 fi
}
)

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
detail=$(echo "$detail" | tr '\n' ' ')
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.1.4 Ensure mounting of hfs filesystems is disabled"
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
 l_output3="$l_output3\n - \"$l_mdir\""
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
 echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
 [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
 fi
}
)

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
detail=$(echo "$detail" | tr '\n' ' ')
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.1.5 Ensure mounting of hfsplus filesystems is disabled"
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
 l_output3="$l_output3\n - \"$l_mdir\""
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
 echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
 [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
 fi
}
)

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
detail=$(echo "$detail" | tr '\n' ' ')
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file



testcase="1.1.2.1 Ensure /tmp is a separate partition"
echo "$testcase"
detail=""
output=$(/bin/findmnt -nk /tmp)
tmpoutput=$(/bin/findmnt -nk /tmp)
if [ -n "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="no separate partition"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >>  $result_file

if [ -n "$tmpoutput" ]; then

testcase="1.1.2.2 Ensure nodev option set on /tmp partition"
echo "$testcase"
detail=""
output=$(/bin/findmnt -kn /tmp | grep -v nodev)
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="nodev is not set on /tmp"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.2.3 Ensure noexec option set on /tmp partition"
echo "$testcase"
detail=""
output=$(/bin/findmnt -kn /tmp | grep -v noexec)
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="noexec is not set on /tmp"; fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.2.4 Ensure nosuid option set on /tmp partition"
echo "$testcase"
detail=""
output=$(/bin/findmnt -kn /tmp | grep -v nosuid)
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="nosuid is not set on /tmp"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

fi

testcase="1.1.3.1 Ensure /var is a separate partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /var)
varoutput=$(findmnt -kn /var)
if [ -n "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="no separate partition"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

if [ -n "$varoutput" ]; then

testcase="1.1.3.2 Ensure nodev option set on /var partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /var | grep -v 'nodev')
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="nodev is not set on /var"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.3.3 Ensure nosuid option set on /var partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /var | grep -v 'nosuid')
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="nosuid is not set on /var"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

fi

testcase="1.1.4.1 Ensure /var/tmp is a separate partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /var/tmp)
vartmpoutput=$(findmnt -kn /var/tmp)
if [ -n "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="no separate partition"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

if [ -n "$vartmpoutput" ]; then

testcase="1.1.4.2 Ensure nodev option set on /var/tmp partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /var/tmp | grep -v nodev)
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="nodev is not set on /var/tmp"; fi
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="1.1.4.3 Ensure noexec option set on /var/tmp partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /var/tmp | grep -v noexec)
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="noexec is not set on /var/tmp"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.4.4 Ensure nosuid option set on /var/tmp partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /var/tmp | grep -v nosuid)
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="nosuid is not set on /var/tmp"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

fi

testcase="1.1.5.1 Ensure /var/log is a separate partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /var/log)
varlogoutput=$(findmnt -kn /var/log)
if [ -n "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="no separate partition"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

if [ -n "$varlogoutput" ]; then

testcase="1.1.5.2 Ensure nodev option set on /var/log partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /var/log | grep -v nodev)
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="nodev is not set on /var/log"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.5.3 Ensure noexec option set on /var/log partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /var/log | grep -v nodexec)
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="noexec is not set on /var/log"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.5.4 Ensure nosuid option set on /var/log partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /var/log | grep -v nodsuid)
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="nosuid is not set on /var/log"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

fi

testcase="1.1.6.1 Ensure /var/log/audit is a separate partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /var/log/audit)
varlogauditoutput=$(findmnt -kn /var/log/audit)
if [ -n "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="no separate partition"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

if [ -n "$varlogauditoutput" ]; then

testcase="1.1.6.2 Ensure nodev option set on /var/log/audit partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /var/log/audit | grep -v nodev)
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="nodev is not set on /var/log/audit"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.6.3 Ensure noexec option set on /var/log/audit partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /var/log/audit | grep -v noexec)
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="noexec is not set on /var/log/audit"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.6.4 Ensure nosuid option set on /var/log/audit partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /var/log/audit | grep -v nosuid)
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="nosuid is not set on /var/log/audit"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

fi

testcase="1.1.7.1 Ensure /home is a separate partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /home)
homeoutput=$(findmnt -kn /home)
if [ -n "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="no separate partition"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

if [ -n "$homeoutput" ]; then

testcase="1.1.7.2 Ensure nodev option set on /home partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /home | grep -v 'nodev')
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="nodev is not set on /home"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.7.3 Ensure nosuid option set on /home partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /home | grep -v 'nosuid')
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="nosuid is not set on /home"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

fi

testcase="1.1.8.0 Ensure /dev/shm is a separate partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /dev/shm)
shmoutput=$(findmnt -kn /dev/shm)
if [ -n "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="no separate partition"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

if [ -n "$shmoutput" ]; then

testcase="1.1.8.1 Ensure nodev option set on /dev/shm partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /dev/shm | grep -v 'nodev')
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="nodev is not set on /dev/shm"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="1.1.8.2 Ensure noexec option set on /dev/shm partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /dev/shm | grep -v 'noexec')
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="noexec is not set on /dev/shm"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.8.3 Ensure nosuid option set on /dev/shm partition"
echo "$testcase"
detail=""
output=$(findmnt -kn /dev/shm | grep -v 'nosuid')
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="nosuid is not set on /dev/shm"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
echo "$thehostname,$testcase,$status,$detail" >> $result_file

fi

testcase="1.1.9 Disable Automounting"
echo "$testcase"
detail=""
output=$(dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' autofs)
if [[ "$output" =~ 'no packages' ]]; then
status='PASS';
echo $status
else
output2=$(systemctl is-enabled autofs 2>/dev/null | grep 'enabled')
if [[ -z "$output" ]]; then
status='PASS';
echo $status
else
status='FAIL';
echo $status
detail="Mounting enabled"
fi
fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.1.10 Disable USB Storage"
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
l_output3="$l_output3\n - \"$l_mdir\""
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
echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
else
echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
[ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
fi
})
if [[ $output =~ "** PASS **" ]]; then status="PASS" detail=""; else status="FAIL" detail="$output"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="1.2.1 Ensure AIDE is installed"
echo "$testcase"
detail=""
output=$(dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' aide aide-common)
aideout=""

if [[ $output == *"aide install ok installed installed"* && $output == *"aide-common install ok installed installed"* ]]; then
   status="PASS"
   aideout="TRUE"
else
   status="FAIL"
   detail="Aide or Aide-common not installed"
   aideout="FALSE"
fi

detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

if [[ "$aideout" == "TRUE" ]]; then

testcase="1.2.2 Ensure filesystem integrity is regularly checked"
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
      
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

fi

testcase="1.3.1 Ensure updates patches and additional security software are installed"
echo "$testcase"
detail=""
#output=$(apt-get -s upgrade | /bin/grep -Ev '(Reading|Building|Calculating)')
output="apt upgrade command. Not to be run on the server."
status="Pending"
detail="Check manually"
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.3.2 Ensure package manager repositories are configured"
echo "$testcase"
detail=""
output=$(apt-cache policy)
#output="apt cache-policy command"
status="Pending"
detail="Check manually"
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.3.3 Ensure GPG keys are configured"
echo "$testcase"
detail=""
output=$(apt-key list)
status="Pending"
detail="Check manually"
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="1.4.1 Ensure bootloader password is set"
echo "$testcase"
detail=""
output1=$(grep "^set superusers" /boot/grub/grub.cfg)
output2=$(grep "^password" /boot/grub/grub.cfg)
output="$output1"$'\n'"$output2"
if [[ -n "$ouput1" && -n "$output2" ]]; then status="PASS" detail=""; else status="FAIL" output="$output1$output2" detail="Password protection not enabled"; fi
output=$(echo "$output" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.4.2 Ensure permissions on bootloader config are configured"
echo "$testcase"
detail=""
output=$(stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /boot/grub/grub.cfg)
if [[ $output == *"(0600/-rw-------) Uid: ( 0/ root) Gid: ( 0/ root)"* ]]; then
   status="PASS"
else
	if [[ $output =~ ^Access:\s+\(\([0-7]{3}\)/-rw-------\)\ Uid:\ \(\ 0/\ root\)\ Gid:\ \(\ 0/\ root\)$  && "$int" -le 600 ]]; then
	   status="PASS"
	else
	   status="FAIL"
	   detail="Configurations not properly set"$'\n'"$output"
	fi
fi
output=$(echo "$output" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.4.3 Ensure authentication required for single user mode"
echo "$testcase"
detail=""
output=$(grep -Eq '^root:\$[0-9]' /etc/shadow || echo "root is locked")
if [ -z $output ]; then
   status="PASS"
else
   status="FAIL"
   detail="Root password is not set"
fi
output=$(grep -E '^root:\$[0-9]' /etc/shadow || echo "root is locked")
output=$(echo "$output" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="1.5.1 Ensure prelink is not installed"
echo "$testcase"
detail=""
output=$(dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' prelink 2>&1)
if [[ $output == *"prelink unknown ok not-installed not-installed"* || $output == *"no packages found"* ]]; then status="PASS" detail=""; else status="FAIL" detail="Prelink is installed"; fi
output=$(echo "$output" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="1.5.2 Ensure address space layout randomization (ASLR) is enabled"

echo "$testcase"
detail=""

output=$({
 l_output="" l_output2=""
 a_parlist=(kernel.randomize_va_space=2)
 l_ufwscf="$([ -f /etc/default/ufw ] && awk -F= '/^\s*IPT_SYSCTL=/ {print $2}' /etc/default/ufw)"
 kernel_parameter_chk()
 { 
 l_krp="$(sysctl "$l_kpname" | awk -F= '{print $2}' | xargs)" # Check running configuration
 if [ "$l_krp" = "$l_kpvalue" ]; then
 l_output="$l_output\n - \"$l_kpname\" is correctly set to \"$l_krp\" in the running 
configuration"
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
detail=$(echo "$detail" | tr '\n' ' ')
fi
output=$(echo "$output" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.5.3 Ensure ptrace_scope is restricted"
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
 l_output="$l_output\n - \"$l_kpname\" is correctly set to \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\"\n"
 else
 l_output2="$l_output2\n - \"$l_kpname\" is incorrectly set to \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\" and should have a value of: \"$l_kpvalue\"\n"
 fi
 done < <(grep -Po -- "^\h*$l_kpname\h*=\h*\H+" "${A_out[@]}")
 else
 l_output2="$l_output2\n - \"$l_kpname\" is not set in an included file\n ** Note: 
\"$l_kpname\" May be set in a file that's ignored by load procedure **\n"
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
detail=$(echo "$detail" | tr '\n' ' ')
fi

output=$(echo "$output" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="1.5.4 Ensure Automatic Error Reporting is not enabled"
echo "$testcase"
detail=""
output1=$(dpkg-query -s apport &> /dev/null && grep -Psi -- '^\h*enabled\h*=\h*[^0]\b' /etc/default/apport)
output2=$(systemctl is-active apport.service | grep '^active')
if [[ -z $output1 && -z $output2 ]]; then status="PASS" detail=""; else status="FAIL" detail="Automatic error reporting enabled or active"; fi
output="$output1$output2"
output=$(echo "$output" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="1.5.5 Ensure core dumps are restricted"
echo "$testcase"
detail=""

output=$(grep -Es '^(\*|\s).*hard.*core.*(\s+#.*)?$' /etc/security/limits.conf /etc/security/limits.d/*)
echo "$output"
output=$(systemctl is-enabled coredump.service)
echo "$output"

output=$({
 l_output="" l_output2=""
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
detail=$(echo "$detail" | tr '\n' ' ')
fi
output=$(echo "$output" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file



testcase="1.6.1.1 Ensure AppArmor is installed"
echo "$testcase"
detail=""
apparmorout=""
output1=$(/bin/dpkg -s apparmor-utils 2>&1 | /bin/grep -E '(Status:|not installed)')
output2=$(/bin/dpkg -s apparmor 2>&1 | /bin/grep -E '(Status:|not installed)')
if [[ $output2 == *"apparmor"*  && $output1 == *"apparmor-utils"* ]]; then
   status="PASS"
   detail=""
   apparmorout="TRUE"
else
	status="FAIL"
    detail="apparmor and apparmor-utils are not enabled"
    apparmorout="FALSE"
fi
output="$output1$output2"
output=$(echo "$output" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

if [[ $apparmorout == "TRUE" ]]; then

testcase="1.6.1.2 Ensure AppArmor is enabled in the bootloader configuration"
echo "$testcase"
detail=""
output=$(grep "^\s*linux" /boot/grub/grub.cfg | grep -v "apparmor=1"
grep "^\s*linux" /boot/grub/grub.cfg | grep -v "security=apparmor")
if [ -z "$output" ]; then status="PASS" detail=""; else status="FAIL" detail="Overwritten by bootloader boot parameters"; fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.6.1.3 Ensure all AppArmor Profiles are in enforce or complain mode"
echo "$testcase"
detail=""
output=$(apparmor_status | grep profiles
apparmor_status | grep processes)
#output=$(echo "$output" | tr '\n' ' ')
echo "$output"
status="Pending"
detail="Verify the output manually"

detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

fi

testcase="1.7.1 Ensure message of the day is configured properly"
echo "$testcase"
detail=""
output=$(grep -Eis "(\\\v|\\\r|\\\m|\\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g'))" /etc/motd)
if [ -z "$output" ]; then
    status="PASS"
else
    status="FAIL"
    detail="Not configured properly. OS information being displayed."
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.7.2 Ensure local login warning banner is configured properly"

echo "$testcase"
detail=""
output=$(grep -E -i "(\\\v|\\\r|\\\m|\\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g'))" /etc/issue)
if [ -z "$output" ]; then
    status="PASS"
else
    status="FAIL"
    detail="Not configured properly. OS information being displayed."
fi
echo "$output"
output1=$(cat "/etc/issue")
echo "etc issue content -> $output1"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.7.3 Ensure remote login warning banner is configured properly"
echo "$testcase"
detail=""
output=$(grep -E -i "(\\\v|\\\r|\\\m|\\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g'))" /etc/issue.net)
if [ -z "$output" ]; then
    status="PASS"
else
    status="FAIL"
    detail="Not configured properly. OS information being displayed."
fi
output1=$(cat "/etc/issue.net")
echo "etc issue.net content -> $output1"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.7.4 Ensure permissions on /etc/motd are configured"
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
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.7.5 Ensure permissions on /etc/issue are configured"
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
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.7.6 Ensure permissions on /etc/issue.net are configured"
echo "$testcase"
detail=""
output=$(stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /etc/issue.net)
if [[ $output == *"(0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)"* ]]; then
   detail=""
   status="PASS"
else
   status="FAIL"
   detail=$output
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="Ensure GDM is not installed"
echo "$testcase"
output=$(dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' gdm3)
if [[ "$output" =~ "gdm3 unknown ok not-installed not-installed" ]]; then
	gdmstatus="PASS"
else
	gdmstatus="FAIL" detail="GDM is installed"
fi
echo "$output"


if [[ $gdmstatus == "FAIL" ]]; then

testcase="1.8.2 Ensure GDM login banner is configured"

echo "$testcase"
detail=""
output=$({
 l_pkgoutput=""
 if command -v dpkg-query > /dev/null 2>&1; then
 l_pq="dpkg-query -W"
 elif command -v rpm > /dev/null 2>&1; then
 l_pq="rpm -q"
 fi
 l_pcl="gdm gdm3" # Space seporated list of packages to check
 for l_pn in $l_pcl; do
 $l_pq "$l_pn" > /dev/null 2>&1 && l_pkgoutput="$l_pkgoutput\n - Package: \"$l_pn\" exists on the system\n - checking configuration"
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
 l_output="$l_output\n - The \"banner-message-text\" option is set in \"$l_gdmfile\"\n - banner-message-text is set to:\n - \"$l_lsbt\""
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
 echo -e "\n\n - GNOME Desktop Manager isn't installed\n - Recommendation is Not Applicable\n- Audit result:\n *** PASS ***\n"
 fi
 # Report results. If no failures output in l_output2, we pass
 if [ -z "$l_output2" ]; then
 echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
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
detail=$(echo "$detail" | tr '\n' ' ')
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.8.3 Ensure GDM disable-user-list option is enabled"

resoutput=$({
 l_pkgoutput=""
 if command -v dpkg-query > /dev/null 2>&1; then
 l_pq="dpkg-query -W"
 elif command -v rpm > /dev/null 2>&1; then
 l_pq="rpm -q"
 fi
 l_pcl="gdm gdm3" # Space seporated list of packages to check
 for l_pn in $l_pcl; do
 $l_pq "$l_pn" > /dev/null 2>&1 && l_pkgoutput="$l_pkgoutput\n -Package: \"$l_pn\" exists on the system\n - checking configuration"
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
 echo -e "$l_pkgoutput\n- Audit result:\n *** PASS: ***\n$output\n"
 else
 echo -e "$l_pkgoutput\n- Audit Result:\n *** FAIL: ***\n$output2\n"
 [ -n "$output" ] && echo -e "$output\n"
 fi
 else
 echo -e "\n\n - GNOME Desktop Manager isn't installed\n -Recommendation is Not Applicable\n- Audit result:\n *** PASS ***\n"
 fi
}
)

if [[ "$resoutput" =~ '*** PASS ***' ]]; then
status='PASS';
else
status='FAIL';
detail=$output
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.8.4 Ensure GDM screen locks when the user is idle"
echo "$testcase"
detail=""
output=$({
 # Check if GNMOE Desktop Manager is installed. If package isn't 
installed, recommendation is Not Applicable\n
 # determine system's package manager
 l_pkgoutput=""
 if command -v dpkg-query > /dev/null 2>&1; then
 l_pq="dpkg-query -W"
 elif command -v rpm > /dev/null 2>&1; then
 l_pq="rpm -q"
 fi
 # Check if GDM is installed
 l_pcl="gdm gdm3" # Space seporated list of packages to check
 for l_pn in $l_pcl; do
 $l_pq "$l_pn" > /dev/null 2>&1 && l_pkgoutput="$l_pkgoutput\n -
Package: \"$l_pn\" exists on the system\n - checking configuration"
 done
 # Check configuration (If applicable)
 if [ -n "$l_pkgoutput" ]; then
 l_output="" l_output2=""
 l_idmv="900" # Set for max value for idle-delay in seconds
 l_ldmv="5" # Set for max value for lock-delay in seconds
 # Look for idle-delay to determine profile in use, needed for remaining 
tests
 l_kfile="$(grep -Psril '^\h*idle-delay\h*=\h*uint32\h+\d+\b' 
/etc/dconf/db/*/)" # Determine file containing idle-delay key
 if [ -n "$l_kfile" ]; then
 # set profile name (This is the name of a dconf database)
 l_profile="$(awk -F'/' '{split($(NF-1),a,".");print a[1]}' <<< 
"$l_kfile")" #Set the key profile name
 l_pdbdir="/etc/dconf/db/$l_profile.d" # Set the key file dconf db 
directory
 # Confirm that idle-delay exists, includes unit32, and value is 
between 1 and max value for idle-delay
 l_idv="$(awk -F 'uint32' '/idle-delay/{print $2}' "$l_kfile" | 
xargs)"
 if [ -n "$l_idv" ]; then
 [ "$l_idv" -gt "0" -a "$l_idv" -le "$l_idmv" ] && 
l_output="$l_output\n - The \"idle-delay\" option is set to \"$l_idv\" 
seconds in \"$l_kfile\""
 [ "$l_idv" = "0" ] && l_output2="$l_output2\n - The \"idledelay\" option is set to \"$l_idv\" (disabled) in \"$l_kfile\""
 [ "$l_idv" -gt "$l_idmv" ] && l_output2="$l_output2\n - The 
\"idle-delay\" option is set to \"$l_idv\" seconds (greater than $l_idmv) in 
\"$l_kfile\""
 else
 l_output2="$l_output2\n - The \"idle-delay\" option is not set in 
\"$l_kfile\""
 fi
 # Confirm that lock-delay exists, includes unit32, and value is 
between 0 and max value for lock-delay
 l_ldv="$(awk -F 'uint32' '/lock-delay/{print $2}' "$l_kfile" | 
xargs)"
 if [ -n "$l_ldv" ]; then
 [ "$l_ldv" -ge "0" -a "$l_ldv" -le "$l_ldmv" ] && 
l_output="$l_output\n - The \"lock-delay\" option is set to \"$l_ldv\" 
Page 201
seconds in \"$l_kfile\""
 [ "$l_ldv" -gt "$l_ldmv" ] && l_output2="$l_output2\n - The 
\"lock-delay\" option is set to \"$l_ldv\" seconds (greater than $l_ldmv) in 
\"$l_kfile\""
 else
 l_output2="$l_output2\n - The \"lock-delay\" option is not set in 
\"$l_kfile\""
 fi
 # Confirm that dconf profile exists
 if grep -Psq "^\h*system-db:$l_profile" /etc/dconf/profile/*; then
 l_output="$l_output\n - The \"$l_profile\" profile exists"
 else
 l_output2="$l_output2\n - The \"$l_profile\" doesn't exist"
 fi
 # Confirm that dconf profile database file exists
 if [ -f "/etc/dconf/db/$l_profile" ]; then
 l_output="$l_output\n - The \"$l_profile\" profile exists in the 
dconf database"
 else
 l_output2="$l_output2\n - The \"$l_profile\" profile doesn't 
exist in the dconf database"
 fi
 else
 l_output2="$l_output2\n - The \"idle-delay\" option doesn't exist, 
remaining tests skipped"
 fi
 else
 l_output="$l_output\n - GNOME Desktop Manager package is not installed 
on the system\n - Recommendation is not applicable"
 fi
 # Report results. If no failures output in l_output2, we pass
 [ -n "$l_pkgoutput" ] && echo -e "\n$l_pkgoutput"
 if [ -z "$l_output2" ]; then
 echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit 
failure:\n$l_output2\n"
 [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
 fi
})

if [[ "$output" =~ '** PASS **' ]]; then
status='PASS';
else
status='FAIL';
detail=$output
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.8.5 Ensure GDM screen locks cannot be overridden"

echo "$testcase"
detail=""
output=$({
 # Check if GNOME Desktop Manager is installed. If package isn't installed, recommendation is 
Not Applicable\n
 # determine system's package manager
 l_pkgoutput=""
 if command -v dpkg-query > /dev/null 2>&1; then
 l_pq="dpkg-query -W"
 elif command -v rpm > /dev/null 2>&1; then
 l_pq="rpm -q"
 fi
 # Check if GDM is installed
 l_pcl="gdm gdm3" # Space seporated list of packages to check
 for l_pn in $l_pcl; do
 $l_pq "$l_pn" > /dev/null 2>&1 && l_pkgoutput="$l_pkgoutput\n - Package: \"$l_pn\" exists 
on the system\n - checking configuration"
 done
 # Check configuration (If applicable)
 if [ -n "$l_pkgoutput" ]; then
 l_output="" l_output2=""
 # Look for idle-delay to determine profile in use, needed for remaining tests
 l_kfd="/etc/dconf/db/$(grep -Psril '^\h*idle-delay\h*=\h*uint32\h+\d+\b' /etc/dconf/db/*/ | 
awk -F'/' '{split($(NF-1),a,".");print a[1]}').d" #set directory of key file to be locked
 l_kfd2="/etc/dconf/db/$(grep -Psril '^\h*lock-delay\h*=\h*uint32\h+\d+\b' /etc/dconf/db/*/ 
| awk -F'/' '{split($(NF-1),a,".");print a[1]}').d" #set directory of key file to be locked
 if [ -d "$l_kfd" ]; then # If key file directory doesn't exist, options can't be locked
 if grep -Prilq '\/org\/gnome\/desktop\/session\/idle-delay\b' "$l_kfd"; then
 l_output="$l_output\n - \"idle-delay\" is locked in \"$(grep -Pril 
'\/org\/gnome\/desktop\/session\/idle-delay\b' "$l_kfd")\""
 else
 l_output2="$l_output2\n - \"idle-delay\" is not locked"
 fi
 else
 l_output2="$l_output2\n - \"idle-delay\" is not set so it can not be locked"
 fi
 if [ -d "$l_kfd2" ]; then # If key file directory doesn't exist, options can't be locked
 if grep -Prilq '\/org\/gnome\/desktop\/screensaver\/lock-delay\b' "$l_kfd2"; then
 l_output="$l_output\n - \"lock-delay\" is locked in \"$(grep -Pril 
'\/org\/gnome\/desktop\/screensaver\/lock-delay\b' "$l_kfd2")\""
 else
 l_output2="$l_output2\n - \"lock-delay\" is not locked"
 fi
 else
 l_output2="$l_output2\n - \"lock-delay\" is not set so it can not be locked"
 fi
 else
 l_output="$l_output\n - GNOME Desktop Manager package is not installed on the system\n -
Recommendation is not applicable"
 fi
 # Report results. If no failures output in l_output2, we pass
[ -n "$l_pkgoutput" ] && echo -e "\n$l_pkgoutput"
 if [ -z "$l_output2" ]; then
 echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
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
detail=$(echo "$detail" | tr '\n' ' ')
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.8.6 Ensure GDM automatic mounting of removable media is disabled"

echo "$testcase"
detail=""
output=$({
 l_pkgoutput="" l_output="" l_output2=""
 # Check if GNOME Desktop Manager is installed. If package isn't 
installed, recommendation is Not Applicable\n
 # determine system's package manager
 if command -v dpkg-query > /dev/null 2>&1; then
 l_pq="dpkg-query -W"
 elif command -v rpm > /dev/null 2>&1; then
 l_pq="rpm -q"
 fi
 # Check if GDM is installed
 l_pcl="gdm gdm3" # Space seporated list of packages to check
 for l_pn in $l_pcl; do
 $l_pq "$l_pn" > /dev/null 2>&1 && l_pkgoutput="$l_pkgoutput\n -
Package: \"$l_pn\" exists on the system\n - checking configuration"
 done
 # Check configuration (If applicable)
 if [ -n "$l_pkgoutput" ]; then
 echo -e "$l_pkgoutput"
 # Look for existing settings and set variables if they exist
 l_kfile="$(grep -Prils -- '^\h*automount\b' /etc/dconf/db/*.d)"
 l_kfile2="$(grep -Prils -- '^\h*automount-open\b' /etc/dconf/db/*.d)"
 # Set profile name based on dconf db directory ({PROFILE_NAME}.d)
 if [ -f "$l_kfile" ]; then
 l_gpname="$(awk -F\/ '{split($(NF-1),a,".");print a[1]}' <<< 
"$l_kfile")"
 elif [ -f "$l_kfile2" ]; then
 l_gpname="$(awk -F\/ '{split($(NF-1),a,".");print a[1]}' <<< 
"$l_kfile2")"
 fi
 # If the profile name exist, continue checks
 if [ -n "$l_gpname" ]; then
 l_gpdir="/etc/dconf/db/$l_gpname.d"
 # Check if profile file exists
 if grep -Pq -- "^\h*system-db:$l_gpname\b" /etc/dconf/profile/*; 
then
 l_output="$l_output\n - dconf database profile file \"$(grep -Pl 
-- "^\h*system-db:$l_gpname\b" /etc/dconf/profile/*)\" exists"
 else
 l_output2="$l_output2\n - dconf database profile isn't set"
 fi
 # Check if the dconf database file exists
 if [ -f "/etc/dconf/db/$l_gpname" ]; then
 l_output="$l_output\n - The dconf database \"$l_gpname\" exists"
 else
 l_output2="$l_output2\n - The dconf database \"$l_gpname\" 
doesn't exist"
 fi
 # check if the dconf database directory exists
 if [ -d "$l_gpdir" ]; then
 l_output="$l_output\n - The dconf directory \"$l_gpdir\" exitst"
 else
 l_output2="$l_output2\n - The dconf directory \"$l_gpdir\" 
doesn't exist"
 fi
Page 210
 # check automount setting
 if grep -Pqrs -- '^\h*automount\h*=\h*false\b' "$l_kfile"; then
 l_output="$l_output\n - \"automount\" is set to false in: 
\"$l_kfile\""
 else
 l_output2="$l_output2\n - \"automount\" is not set correctly"
 fi
 # check automount-open setting
 if grep -Pqs -- '^\h*automount-open\h*=\h*false\b' "$l_kfile2"; then
 l_output="$l_output\n - \"automount-open\" is set to false in: 
\"$l_kfile2\""
 else
 l_output2="$l_output2\n - \"automount-open\" is not set 
correctly"
 fi
 else
 # Setings don't exist. Nothing further to check
 l_output2="$l_output2\n - neither \"automount\" or \"automountopen\" is set"
 fi
 else
 l_output="$l_output\n - GNOME Desktop Manager package is not installed 
on the system\n - Recommendation is not applicable"
 fi
 # Report results. If no failures output in l_output2, we pass
 if [ -z "$l_output2" ]; then
 echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit 
failure:\n$l_output2\n"
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
detail=$(echo "$detail" | tr '\n' ' ')
fi

detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file
echo "$output"
testcase="1.8.7 Ensure GDM disabling automatic mounting of removable media is not overridden"

echo "$testcase"
detail=""
output=$({
 # Check if GNOME Desktop Manager is installed. If package isn't installed, recommendation is 
Not Applicable\n
 # determine system's package manager
 l_pkgoutput=""
 if command -v dpkg-query > /dev/null 2>&1; then
 l_pq="dpkg-query -W"
 elif command -v rpm > /dev/null 2>&1; then
 l_pq="rpm -q"
 fi
 # Check if GDM is installed
 l_pcl="gdm gdm3" # Space seporated list of packages to check
 for l_pn in $l_pcl; do
 $l_pq "$l_pn" > /dev/null 2>&1 && l_pkgoutput="$l_pkgoutput\n - Package: \"$l_pn\" exists 
on the system\n - checking configuration"
 done
 # Check configuration (If applicable)
 if [ -n "$l_pkgoutput" ]; then
 l_output="" l_output2=""
 # Look for idle-delay to determine profile in use, needed for remaining tests
 l_kfd="/etc/dconf/db/$(grep -Psril '^\h*automount\b' /etc/dconf/db/*/ | awk -F'/' 
'{split($(NF-1),a,".");print a[1]}').d" #set directory of key file to be locked
 l_kfd2="/etc/dconf/db/$(grep -Psril '^\h*automount-open\b' /etc/dconf/db/*/ | awk -F'/' 
'{split($(NF-1),a,".");print a[1]}').d" #set directory of key file to be locked
 if [ -d "$l_kfd" ]; then # If key file directory doesn't exist, options can't be locked
 if grep -Piq '^\h*\/org/gnome\/desktop\/media-handling\/automount\b' "$l_kfd"; then
 l_output="$l_output\n - \"automount\" is locked in \"$(grep -Pil 
'^\h*\/org/gnome\/desktop\/media-handling\/automount\b' "$l_kfd")\""
 else
 l_output2="$l_output2\n - \"automount\" is not locked"
 fi
 else
 l_output2="$l_output2\n - \"automount\" is not set so it can not be locked"
 fi
 if [ -d "$l_kfd2" ]; then # If key file directory doesn't exist, options can't be locked
 if grep -Piq '^\h*\/org/gnome\/desktop\/media-handling\/automount-open\b' "$l_kfd2"; 
then
 l_output="$l_output\n - \"lautomount-open\" is locked in \"$(grep -Pril 
'^\h*\/org/gnome\/desktop\/media-handling\/automount-open\b' "$l_kfd2")\""
 else
 l_output2="$l_output2\n - \"automount-open\" is not locked"
 fi
 else
 l_output2="$l_output2\n - \"automount-open\" is not set so it can not be locked"
 fi
 else
 l_output="$l_output\n - GNOME Desktop Manager package is not installed on the system\n -
Recommendation is not applicable"
 fi
 # Report results. If no failures output in l_output2, we pass
[ -n "$l_pkgoutput" ] && echo -e "\n$l_pkgoutput"
 if [ -z "$l_output2" ]; then
 echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
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
detail=$(echo "$detail" | tr '\n' ' ')
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.8.8 Ensure GDM autorun-never is enabled"

echo "$testcase"
detail=""
output=$({
 l_pkgoutput="" l_output="" l_output2=""
 # Check if GNOME Desktop Manager is installed. If package isn't 
installed, recommendation is Not Applicable\n
 # determine system's package manager
 if command -v dpkg-query > /dev/null 2>&1; then
 l_pq="dpkg-query -W"
 elif command -v rpm > /dev/null 2>&1; then
 l_pq="rpm -q"
 fi
 # Check if GDM is installed
 l_pcl="gdm gdm3" # Space separated list of packages to check
 for l_pn in $l_pcl; do
 $l_pq "$l_pn" > /dev/null 2>&1 && l_pkgoutput="$l_pkgoutput\n -
Package: \"$l_pn\" exists on the system\n - checking configuration"
 echo -e "$l_pkgoutput"
 done
 # Check configuration (If applicable)
 if [ -n "$l_pkgoutput" ]; then
 echo -e "$l_pkgoutput"
 # Look for existing settings and set variables if they exist
 l_kfile="$(grep -Prils -- '^\h*autorun-never\b' /etc/dconf/db/*.d)"
 # Set profile name based on dconf db directory ({PROFILE_NAME}.d)
 if [ -f "$l_kfile" ]; then
 l_gpname="$(awk -F\/ '{split($(NF-1),a,".");print a[1]}' <<< 
"$l_kfile")"
 fi
 # If the profile name exist, continue checks
 if [ -n "$l_gpname" ]; then
 l_gpdir="/etc/dconf/db/$l_gpname.d"
 # Check if profile file exists
 if grep -Pq -- "^\h*system-db:$l_gpname\b" /etc/dconf/profile/*; 
then
 l_output="$l_output\n - dconf database profile file \"$(grep -Pl 
-- "^\h*system-db:$l_gpname\b" /etc/dconf/profile/*)\" exists"
 else
 l_output2="$l_output2\n - dconf database profile isn't set"
 fi
 # Check if the dconf database file exists
 if [ -f "/etc/dconf/db/$l_gpname" ]; then
 l_output="$l_output\n - The dconf database \"$l_gpname\" exists"
 else
 l_output2="$l_output2\n - The dconf database \"$l_gpname\" 
doesn't exist"
 fi
 # check if the dconf database directory exists
 if [ -d "$l_gpdir" ]; then
 l_output="$l_output\n - The dconf directory \"$l_gpdir\" exitst"
 else
 l_output2="$l_output2\n - The dconf directory \"$l_gpdir\" 
doesn't exist"
 fi
 # check autorun-never setting
 if grep -Pqrs -- '^\h*autorun-never\h*=\h*true\b' "$l_kfile"; then
 l_output="$l_output\n - \"autorun-never\" is set to true in: 
Page 220
\"$l_kfile\""
 else
 l_output2="$l_output2\n - \"autorun-never\" is not set correctly"
 fi
 else
 # Settings don't exist. Nothing further to check
 l_output2="$l_output2\n - \"autorun-never\" is not set"
 fi
 else
 l_output="$l_output\n - GNOME Desktop Manager package is not installed 
on the system\n - Recommendation is not applicable"
 fi
 # Report results. If no failures output in l_output2, we pass
 if [ -z "$l_output2" ]; then
 echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit 
failure:\n$l_output2\n"
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
detail=$(echo "$detail" | tr '\n' ' ')
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.8.9 Ensure GDM autorun-never is not overridden"

echo "$testcase"
detail=""
output=$({
 # Check if GNOME Desktop Manager is installed. If package isn't 
installed, recommendation is Not Applicable\n
 # determine system's package manager
 l_pkgoutput=""
 if command -v dpkg-query > /dev/null 2>&1; then
 l_pq="dpkg-query -W"
 elif command -v rpm > /dev/null 2>&1; then
 l_pq="rpm -q"
 fi
 # Check if GDM is installed
 l_pcl="gdm gdm3" # Space separated list of packages to check
 for l_pn in $l_pcl; do
 $l_pq "$l_pn" > /dev/null 2>&1 && l_pkgoutput="$l_pkgoutput\n -Package: \"$l_pn\" exists on the system\n - checking configuration"
 done
 # Check configuration (If applicable)
 if [ -n "$l_pkgoutput" ]; then
 l_output="" l_output2=""
 # Look for idle-delay to determine profile in use, needed for remaining tests
 l_kfd="/etc/dconf/db/$(grep -Psril '^\h*autorun-never\b' /etc/dconf/db/*/ | awk -F'/' '{split($(NF-1),a,".");print a[1]}').d" #set directory of key file to be locked
 if [ -d "$l_kfd" ]; then # If key file directory doesn't exist, options can't be locked
 if grep -Prisq '^\h*\/org/gnome\/desktop\/media-handling\/autorun-never\b' "$l_kfd"; then
 l_output="$l_output\n - \"autorun-never\" is locked in \"$(grep -Pril '^\h*\/org/gnome\/desktop\/media-handling\/autorun-never\b' "$l_kfd")\""
 else
 l_output2="$l_output2\n - \"autorun-never\" is not locked"
 fi
 else
 l_output2="$l_output2\n - \"autorun-never\" is not set so it can not be locked"
 fi
 else
 l_output="$l_output\n - GNOME Desktop Manager package is not installed on the system\n - Recommendation is not applicable"
 fi
 # Report results. If no failures output in l_output2, we pass
[ -n "$l_pkgoutput" ] && echo -e "\n$l_pkgoutput"
 if [ -z "$l_output2" ]; then
 echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
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
detail=$(echo "$detail" | tr '\n' ' ')
fi

echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="1.8.10 Ensure XDCMP is not enabled"
echo "$testcase"
detail=""
output=$(grep -Eis '^\s*Enable\s*=\s*true' /etc/gdm3/custom.conf)
if [[ -z "$output" ]]; then
   status="PASS"
else
   status="FAIL"
   detail="XDCMP is enabled"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

fi   #ending of if condition to check for gdm

testcase="2.1.1.1 Ensure a single time synchronization daemon is in use"
echo "$testcase"
detail=""

output=$({
 output="" l_tsd="" l_sdtd="" chrony="" l_ntp=""
 dpkg-query -W chrony > /dev/null 2>&1 && l_chrony="y"
 dpkg-query -W ntp > /dev/null 2>&1 && l_ntp="y" || l_ntp=""
 systemctl list-units --all --type=service | grep -q 'systemd-timesyncd.service' && systemctl is-enabled systemd-timesyncd.service | grep -
q 'enabled' && l_sdtd="y"
 if [[ "$l_chrony" = "y" && "$l_ntp" != "y" && "$l_sdtd" != "y" ]]; then
 l_tsd="chrony"
 output="$output\n- chrony is in use on the system"
 elif [[ "$l_chrony" != "y" && "$l_ntp" = "y" && "$l_sdtd" != "y" ]]; then
 l_tsd="ntp"
 output="$output\n- ntp is in use on the system"
 elif [[ "$l_chrony" != "y" && "$l_ntp" != "y" ]]; then
 if systemctl list-units --all --type=service | grep -q 'systemd-timesyncd.service' && systemctl is-enabled systemd-timesyncd.service | grep -
Eq '(enabled|disabled|masked)'; then
 l_tsd="sdtd"
 output="$output\n- systemd-timesyncd is in use on the system"
 fi
 else
 [[ "$l_chrony" = "y" && "$l_ntp" = "y" ]] && output="$output\n- both 
chrony and ntp are in use on the system"
 [[ "$l_chrony" = "y" && "$l_sdtd" = "y" ]] && output="$output\n- both 
chrony and systemd-timesyncd are in use on the system"
 [[ "$l_ntp" = "y" && "$l_sdtd" = "y" ]] && output="$output\n- both ntp 
and systemd-timesyncd are in use on the system"
 fi
 if [ -n "$l_tsd" ]; then
 echo -e "\n- ** PASS **:\n$output\n"
 else
 echo -e "\n- ** FAIL **:\n$output\n"
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
detail=$(echo "$detail" | tr '\n' ' ')
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

chronyset=""
if [[ "$output" == *"chrony is in use on the system"* ]];then
	chronyset="TRUE"
fi

if [[ $chronyset == "TRUE" ]]; then


testcase="2.1.2.1 Ensure chrony is configured with authorized timeserver"
echo "$testcase"
detail=""

output=$(grep -Pr --include=*.{sources,conf} '^\h*(server|pool)\h+\H+' /etc/chrony/)
status="Pending"
detail="Verify manually from output"
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.1.2.2 Ensure chrony is running as user _chrony"
echo "$testcase"
detail=""

output=$(ps -ef | awk '(/[c]hronyd/ && $1!="_chrony") { print $1 }')
if [[ -z "$output" ]]; then status="PASS"; else status="FAIL" detail="not running as _chrony user"; fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.1.2.3 Ensure chrony is enabled and running"
echo "$testcase"
detail=""
echo "check if chrony is enabled"
output1=$(/bin/systemctl is-enabled chrony)
echo "check if chrony is active"
output2=$(/bin/systemctl is-active chrony)
if [[ $output1 == "enabled" && $output2 == "active" ]]; then status="PASS"; else status="FAIL" detail="not active or not enabled"; fi
output="$output1"$'\n'"$output2"
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

fi #if condition to check for chrony

echo "\nChecking for systemd-timesyncd\n"

testcase="2.1.3.1 Ensure systemd-timesyncd configured with authorized timeserver"
echo "$testcase"
detail=""
output=$(grep -Ph '^\h*(NTP|FallbackNTP)=\H+' /etc/systemd/timesyncd.conf)

status="Pending"
detail="Verify manully by the output"
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.1.3.2 Ensure systemd-timesyncd is enabled and running"
echo "$testcase"
detail=""

output1=$(systemctl is-enabled systemd-timesyncd.service)
output2=$(systemctl is-active systemd-timesyncd.service)
if [[ $output1 == "enabled" && $output2 == "active" ]]; then status="PASS"; else status="FAIL" detail="$output1$output2"; fi
echo "is-enabled -> $output1"
echo "is-active -> $output2"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

echo "\nChecking for ntp\n"

testcase="2.1.4.1 Ensure ntp access control is configured"
echo "$testcase"
detail=""
output=$(grep -P -- '^\h*restrict\h+((-4\h+)?|-6\h+)default\h+(?:[^#\n\r]+\h+)*(?!(?:\2|\3|\4|\5))(\h*\bkod\b\h*|\h*\bnomodify\b\h*|\h*\bnotrap\b\h*|\h*\bnopeer\b\h*|\h*\bnoquery\b\h*)\h+(?:[^#\n\r]+\h+)*(?!(?:\1|\3|\4|\5))(\h*\bkod\b\h*|\h*\bnomodify\b\h*|\h*\bnotrap\b\h*|\h*\bnopeer\b\h*|\h*\bnoquery\b\h*)\h+(?:[^#\n\r]+\h+)*(?!(?:\1|\2|\4|\5))(\h*\bkod\b\h*|\h*\bnomodify\b\h*|\h*\bnotrap\b\h*|\h*\bnopeer\b\h*|\h*\bnoquery\b\h*)\h+(?:[^#\n\r]+\h+)*(?!(?:\1|\2|\3|\5))(\h*\bkod\b\h*|\h*\bnomodify\b\h*|\h*\bnotrap\b\h*|\h*\bnopeer\b\h*|\h*\bnoquery\b\h*)\h+(?:[^#\n\r]+\h+)*(?!(?:\1|\2|\3|\4))(\h*\bkod\b\h*|\h*\bnomodify\b\h*|\h*\bnotrap\b\h*|\h*\bnopeer\b\h*|\h*\bnoquery\b\h*)\h*(?:\h+\H+\h*)*(?:\h+#.*)?$' /etc/ntp.conf)
status="Pending"
detail="Verify manually from the output"
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.1.4.2 Ensure ntp is configured with authorized timeserver"
echo "$testcase"
detail=""
output=$(grep -P -- '^\h*(server|pool)\h+\H+' /etc/ntp.conf)
status="Pending"
detail="Verify manually from the output"
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.1.4.3 Ensure ntp is configured with authorized timeserver"
echo "$testcase"
detail=""
output1=$(ps -ef | awk '(/[n]tpd/ && $1!="ntp") { print $1 }')
output2=$(grep -P -- '^\h*RUNASUSER=' /usr/lib/ntp/ntp-systemd-wrapper 2>&1)
if [ -z "$output" && $output2 == *"RUNASUSER=ntp"* ]; then status="PASS"; else status="FAIL" detail="Ntp improperly configured"; fi
output="$output1$output2"
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.1.4.4 Ensure ntp is enabled and running"
echo "$testcase"
detail=""
output1=$(systemctl is-enabled ntp.service 2>&1)
output2=$(systemctl is-active ntp.service 2>&1)
if [[ $output1 == "enabled" && $output2 == "active" ]]; then status="PASS"; else status="FAIL" detail="Ntp not enabled or running"; fi
output="$output1"$'\n'"$output2"
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file



testcase="2.2.2 Ensure Avahi Server is not installed"
output=$(/bin/dpkg -s avahi-daemon 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ $output == *"not installed"* ]]; then status="PASS"; else status="FAIL" detail="avahi server is installed"; fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.2.3 Ensure CUPS is not installed"
output=$(/bin/dpkg -s cups 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ $output == *"not installed"* ]]; then status="PASS"; else status="FAIL" detail="CUPS is installed"; fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.2.4 Ensure DHCP Server is not installed"
output=$(/bin/dpkg -s isc-dhcp-server 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ $output == *"not installed"* ]]; then status="PASS"; else status="FAIL" detail="DHCP server is installed"; fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.2.5 Ensure LDAP Server is not installed"
output=$(/bin/dpkg -s slapd 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ $output == *"not installed"* ]]; then status="PASS"; else status="FAIL" detail="LDAP server is installed"; fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.2.6 Ensure NFS is not installed"
output=$(/bin/dpkg -s nfs-kernel-server 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ $output == *"not installed"* ]]; then status="PASS"; else status="FAIL" detail="NFS is installed"; fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.2.7 Ensure DNS Server is not installed"
output=$(/bin/dpkg -s bind9 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ $output == *"not installed"* ]]; then status="PASS"; else status="FAIL" detail="DNS server is installed"; fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.2.8 Ensure FTP Server is not installed"
output=$(/bin/dpkg -s vsftpd 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ $output == *"not installed"* ]]; then status="PASS"; else status="FAIL" detail="FTP server is installed"; fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.2.9 Ensure HTTP Server is not installed"
output=$(/bin/dpkg -s apache2 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ $output == *"not installed"* ]]; then status="PASS"; else status="FAIL" detail="HTTP server is installed"; fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.2.10 Ensure IMAP and POP3 server are not installed"
output1=$(/bin/dpkg -s dovecot-pop3d 2>&1 | /bin/grep -E '(^Status:|not installed)')
output2=$(/bin/dpkg -s dovecot-imapd 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ $output1 == *"not installed"* && $output2 == *"not installed"* ]]; then status="PASS"; else status="FAIL" detail="IMAP or POP3 server is installed"; fi
echo "$output1\n$output2"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.2.11 Ensure Samba is not installed"
output=$(/bin/dpkg -s samba 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ $output == *"not installed"* ]]; then status="PASS"; else status="FAIL" detail="Samba is installed"; fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.2.12 Ensure HTTP Proxy Server is not installed"
output=$(/bin/dpkg -s squid 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ $output == *"not installed"* ]]; then status="PASS"; else status="FAIL" detail="HTTP Proxy server is installed"; fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.2.13 Ensure SNMP Server is not installed"
output=$(/bin/dpkg -s snmpd 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ $output == *"not installed"* ]]; then status="PASS"; else status="FAIL" detail="SNMP server is installed"; fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.2.14 Ensure NIS Server is not installed"
output=$(/bin/dpkg -s nis 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ $output == *"not installed"* ]]; then status="PASS"; else status="FAIL" detail="NIS server is installed"; fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.2.15 Ensure dnsmasq is not installed"
output=$(/bin/dpkg -s dnsmasq 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ $output == *"not installed"* ]]; then status="PASS"; else status="FAIL" detail="dnsmasq is installed"; fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.2.16 Ensure mail transfer agent is configured for local-only mode"
output=$(ss -lntu | grep -P ':25\b' | grep -Pv '\h+(127\.0\.0\.1|\[?::1\]?):25\b')
if [[ -z "$output" ]]; then status="PASS"; else status="FAIL" detail="Mail transfer agent not properly configured"; fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.2.17 Ensure rsync service is either not installed or is masked"
output1=$(/bin/dpkg -s rsync 2>&1 | /bin/grep -E '(^Status:|not installed)')
echo "$output1"
if [[ $output1 == *"not installed"* ]]; then
status="PASS";
else
output2=$(/bin/systemctl is-enabled rsync)
echo "$output2"
output3=$(/bin/systemctl is-active rsync)
echo "$output3"
if [[ $output2 == "inactive" && $output3 == "masked" ]]; then
status="PASS";
else
status="FAIL";
detail="rsync is installed and also active or unmasked";
fi
fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file




testcase="2.3.1 Ensure NIS Client is not installed"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s nis 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ $output == *"not installed"* ]]; then status="PASS"; else status="FAIL" detail="nis client installed"; fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.3.2 Ensure rsh client is not installed"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s rsh-client 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ $output == *"not installed"* ]]; then status="PASS"; else status="FAIL" detail="rsh client installed"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.3.3 Ensure talk client is not installed"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s talk 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ $output == *"not installed"* ]]; then status="PASS"; else status="FAIL" detail="talk client installed"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.3.4 Ensure telnet client is not installed"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s telnet 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ $output == *"not installed"* ]]; then status="PASS"; else status="FAIL" detail="telnet client installed"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.3.5 Ensure ldap client is not installed"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s ldap-utils 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ $output == *"not installed"* ]]; then status="PASS"; else status="FAIL" detail="ldap client installed"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.3.6 Ensure RPC is not installed"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s rpcbind 2>&1 | /bin/grep -E '(^Status:|not installed)')
if [[ $output == *"not installed"* ]]; then status="PASS"; else status="FAIL" detail="RPC is installed"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="2.4 Ensure nonessential services are removed or masked"
echo "$testcase"
detail=""
output=$(ss -plntu)
status="Pending"
detail="Verify manually with the output"
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="3.1.1 Ensure IPv6 status is identified"
echo "$testcase"
detail=""
output=$(grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable && echo -e "\n -IPv6 is enabled\n" || echo -e "\n - IPv6 is not enabled\n")
status="Pending"
detail="Verify manually with output"
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
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
 if grep -Pq -- '^\h*install \/bin\/(true|false)' <<< "$l_loadable"; 
then
 l_output="$l_output\n - module: \"$l_mname\" is not loadable: 
\"$l_loadable\""
 else
 l_output2="$l_output2\n - module: \"$l_mname\" is loadable: 
\"$l_loadable\""
 fi
 # Check is the module currently loaded
 if ! lsmod | grep "$l_mname" > /dev/null 2>&1; then
 l_output="$l_output\n - module: \"$l_mname\" is not loaded"
 else
 l_output2="$l_output2\n - module: \"$l_mname\" is loaded"
 fi
 # Check if the module is deny listed
 if modprobe --showconfig | grep -Pq -- "^\h*blacklist\h+$l_mname\b"; 
then
 l_output="$l_output\n - module: \"$l_mname\" is deny listed in: 
\"$(grep -Pl -- "^\h*blacklist\h+$l_mname\b" /etc/modprobe.d/*)\""
 else
 l_output2="$l_output2\n - module: \"$l_mname\" is not deny listed"
 fi
 }
 if [ -n "$(find /sys/class/net/*/ -type d -name wireless)" ]; then
 l_dname=$(for driverdir in $(find /sys/class/net/*/ -type d -name 
wireless | xargs -0 dirname); do basename "$(readlink -f 
"$driverdir"/device/driver/module)";done | sort -u)
 for l_mname in $l_dname; do
 module_chk
 done
 fi
 # Report results. If no failures output in l_output2, we pass
 if [ -z "$l_output2" ]; then
 echo -e "\n- Audit Result:\n ** PASS **"
 if [ -z "$l_output" ]; then
 echo -e "\n - System has no wireless NICs installed"
 else
 echo -e "\n$l_output\n"
 fi
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit 
failure:\n$l_output2\n"
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
detail=$(echo "$detail" | tr '\n' ' ')
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.1.3 Ensure bluetooth is disabled"
echo "$testcase"
detail=""
output1=$(/bin/systemctl is-active bluetooth.service | /bin/grep '^enabled')
output2=$(/bin/systemctl is-enabled bluetooth.service | /bin/grep '^active')
if [[ -z "$output1" && -z "$output2" ]]; then
	status="PASS"
else
if [[ $output1 == *"No such file or directory"* && $output2 == *"No such file or directory"* ]]; then
status="PASS";
else
status="FAIL";
detail="bluetooth is not disabled or is active";
fi
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="3.2.1 Ensure packet redirect sending is disabled"
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
 done < <(/usr/lib/systemd/systemd-sysctl --cat-config | grep -Po 
'^\h*([^#\n\r]+|#\h*\/[^#\n\r\h]+\.conf\b)')
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
detail=$(echo "$detail" | tr '\n' ' ')
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="3.2.2 Ensure ip forwarding is disabled"
echo "$testcase"
detail=""

output=$(#!/usr/bin/env bash
{
 l_output="" l_output2=""
 a_parlist=("net.ipv4.ip_forward=0" "net.ipv6.conf.all.forwarding=0")
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
 fi
}
)

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
detail=$(echo "$detail" | tr '\n' ' ')
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file




testcase="3.3.1 Ensure source routed packets are not accepted"
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
 fi
}
)

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
detail=$(echo "$detail" | tr '\n' ' ')
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="3.3.2 Ensure icmp redirects are not accepted"
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
 fi
}
)

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
detail=$(echo "$detail" | tr '\n' ' ')
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.3.3 Ensure secure icmp redirects are not accepted"
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
 fi
}
)

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
detail=$(echo "$detail" | tr '\n' ' ')
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="3.3.4 Ensure suspicious packets are logged"
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
 fi
}
)

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
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
fi

detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="3.3.5 Ensure broadcast icmp requests are ignored"
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
 done < <(/usr/lib/systemd/systemd-sysctl --cat-config | grep -Po 
'^\h*([^#\n\r]+|#\h*\/[^#\n\r\h]+\.conf\b)')
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
 fi
}
)

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
detail=$(echo "$detail" | tr '\n' ' ')
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.3.6 Ensure bogus icmp responses are ignored"
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
 done < <(/usr/lib/systemd/systemd-sysctl --cat-config | grep -Po 
'^\h*([^#\n\r]+|#\h*\/[^#\n\r\h]+\.conf\b)')
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
 fi
}
)

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
detail=$(echo "$detail" | tr '\n' ' ')
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
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
 l_output="$l_output\n - \"$l_kpname\" is correctly set to \"$l_fkpvalue\" in 
\"$(printf '%s' "${A_out[@]}")\"\n"
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
 fi
}
)

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
detail=$(echo "$detail" | tr '\n' ' ')
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="3.3.8 Ensure tcp syn cookies is enabled"
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
 fi
}
)

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
detail=$(echo "$detail" | tr '\n' ' ')
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.3.9 Ensure ipv6 router advertisements are not accepted"
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
 fi
}
)

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
detail=$(echo "$detail" | tr '\n' ' ')
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file





echo "Check if ufw is installed"

testcase="3.4.1.1 Ensure ufw is installed"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s ufw 2>&1 | /bin/grep -E '(Status:|not installed)')
if [[ $output == *"install ok"* ]]; then status="PASS"; else status="FAIL" detail="Not installed"; fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.4.1.2 Ensure iptables-persistent is not installed with ufw"
echo "$testcase"
detail=""
output1=$(/bin/dpkg -s iptables-persistent 2>&1 | /bin/grep -E '(^Status:|not installed)')
echo "iptables persistent - $output1"
output2=$(/bin/dpkg -s ufw 2>&1 | /bin/grep -E '(Status:|not installed)')
echo "ufw - $output2"
if [[ $output1 == *"not installed"* ]]; then
status="PASS";
else
if [[ $output2 == *"install ok"* ]]; then
status="FAIL";
detail="Both ufw and iptables-persistent are installed";
else
status="PASS";
fi
fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.4.1.3 Ensure ufw service is enabled"
echo "$testcase"
detail=""
output=$(systemctl is-enabled ufw.service)
if [[ $output == "enabled" ]]; then
   output2=$(systemctl is-active ufw)
   if [[ $output2 == "active" ]]; then
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
echo "$output\n$output2\n$output3"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.4.1.4 Ensure ufw loopback traffic is configured"
echo "$testcase"
detail=""
output=$(ufw status verbose)
status="Pending"
detail="Verify manually with output"
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.4.1.5 Ensure ufw outbound connections are configured"
echo "$testcase"
detail=""
output=$(/sbin/ufw status numbered)
status="Pending"
detail="Verify manually with output"
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="3.4.1.6 Ensure ufw firewall rules exist for all open ports"
echo "$testcase"
detail=""
output=$({
 unset a_ufwout;unset a_openports
 while read -r l_ufwport; do
 [ -n "$l_ufwport" ] && a_ufwout+=("$l_ufwport")
 done < <(ufw status verbose | grep -Po '^\h*\d+\b' | sort -u)
 while read -r l_openport; do
 [ -n "$l_openport" ] && a_openports+=("$l_openport")
 done < <(ss -tuln | awk '($5!~/%lo:/ && $5!~/127.0.0.1:/ && 
$5!~/\[?::1\]?:/) {split($5, a, ":"); print a[2]}' | sort -u)
 a_diff=("$(printf '%s\n' "${a_openports[@]}" "${a_ufwout[@]}" 
"${a_ufwout[@]}" | sort | uniq -u)")
 if [[ -n "${a_diff[*]}" ]]; then
 echo -e "\n- Audit Result:\n ** FAIL **\n- The following port(s) don't 
have a rule in UFW: $(printf '%s\n' \\n"${a_diff[*]}")\n- End List"
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
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.4.1.7 Ensure ufw default deny firewall policy"
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
output=$(/sbin/ufw status verbose)
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

echo "Check if nftables is installed"

testcase="3.4.2.1 Ensure nftables is installed"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s nftables 2>&1 | /bin/grep -E '(Status:|not installed)' 2>&1)
nftables=""
if [[ $output == *"ok installed"* ]]; then
   status="PASS"
   nftables="on"
else
   status="FAIL"
   detail="nftables not installed"
   nftables="off"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="3.4.2.2 Ensure ufw is uninstalled or disabled with nftables"
output=$(/bin/dpkg -s ufw 2>&1 | /bin/grep -E '(Status:|not installed)')
if [[ $nftables == "on" ]]; then
   if [[ $output == *"ok installed"* ]]; then
      ufwstatus=$(ufw status)
      if [[ $ufwstatus == *"inactive"* ]]; then
         status="PASS"
      else
         status="FAIL"
         detail="ufw is active"
      fi
   else
      status="PASS"
   fi
else
   status="NA"
   detail="nftables is not installed"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.4.2.3 Ensure iptables are flushed with nftables"
echo "$testcase"
detail=""
output=$(iptables -L
ip6tables -L)
status="Pending"
detail="Verify manually with output"
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.4.2.4 Ensure a nftables table exists"
echo "$testcase"
detail=""
output=$(/sbin/nft list tables | /bin/awk '{print} END {if (NR != 0) print "PASS" ; else print "FAIL"}')
if [[ $output == "PASS" ]]; then status="PASS"; else status="FAIL" detail="nftables tables are not present"; fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.4.2.5 Ensure nftables base chains exist"
echo "$testcase"
detail=""
output1=$(nft list ruleset | grep 'hook input' 2>&1)
output2=$(nft list ruleset | grep 'hook forward' 2>&1)
output3=$(nft list ruleset | grep 'hook output' 2>&1)

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
echo "$output1"$'\n'"$output2"$'\n'"$output3"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.4.2.6 Ensure nftables loopback traffic is configured"
echo "$testcase"
detail=""

echo "iif lo accept"
output1=$(/sbin/nft list ruleset | /bin/awk '/hook input/,/}/' | /bin/grep 'iif "lo" accept' 2>&1)
echo "ip saddr"
output2=$(/sbin/nft list ruleset | /bin/awk '/hook input/,/}/' | /bin/grep 'ip saddr' 2>&1)
echo "ip6 saddr"
output3=$(/sbin/nft list ruleset | /bin/awk '/hook input/,/}/' | /bin/grep 'ip6 saddr' 2>&1)

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
echo "$output1"$'\n'"$output2"$'\n'"$output3"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.4.2.7 Ensure nftables outbound and established connections are configured"
echo "$testcase"
detail=""

echo "nft list ruleset - ct state"
output1=$(/sbin/nft list ruleset | /bin/awk '/hook output/,/}/' | /bin/grep -E 'ip protocol (tcp|udp|icmp) ct state' 2>&1)
echo "$output1"
echo "nft list ruleset - ct state"
output2=$(/sbin/nft list ruleset | /bin/awk '/hook input/,/}/' | /bin/grep -E 'ip protocol (tcp|udp|icmp) ct state' 2>&1)
echo "$output2"
status="Pending"
detail="Verify manually with output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.4.2.8 Ensure nftables default deny firewall policy"
echo "$testcase"
detail=""
echo "input"
output1=$(/sbin/nft list ruleset | /bin/grep 'hook input' 2>&1)
echo "output"
output2=$(/sbin/nft list ruleset | /bin/grep 'hook output' 2>&1)
echo "forward"
output3=$(/sbin/nft list ruleset | /bin/grep 'hook forward' 2>&1)

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
echo "$output1"$'\n'"$output2"$'\n'"$output3"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.4.2.9 Ensure nftables service is enabled"
echo "$testcase"
detail=""
output=$(/bin/systemctl is-enabled nftables 2>&1)
if [[ $output == "enabled" ]]; then
   status="PASS"
else
   status="FAIL"
   detail="nftables service not enabled"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.4.2.10 Ensure nftables rules are permanent"
echo "$testcase"
detail=""
output=$([ -n "$(grep -E '^\s*include' /etc/nftables.conf)" ] && awk '/hook input/,/}/' $(awk '$1 ~ /^\s*include/ { gsub("\"","",$2);print $2 }' /etc/nftables.conf))
if [[ -n "$output" ]]; then status="PASS"; else status="FAIL" detail="nftables rules are not present"; fi
echo "$output"
status="Pending"
detail="Verify manually with the output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.4.3.1.1 Ensure iptables packages are installed"
echo "$testcase"
detail=""
output=$(apt list iptables iptables-persistent | grep installed)
if [[ $output == *"iptables-persistent"* ]]; then
status="PASS"
else
status="FAIL"
detail="iptables packages not installed"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.4.3.1.2 Ensure nftables is not installed with iptables"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s nftables 2>&1 | /bin/grep -E '(Status:|not installed)')
output2=$(apt list iptables | grep installed)
output3=$(apt list iptables-persistent | grep installed)
if [[ $output2 == *"iptables"* && $output == "nftables is installed" ]]; then
   status="FAIL"
   detail="both iptables and nftables are installed"
else
   if [[ $output3 == *"iptables-persistent"* && $output == "nftables is installed" ]]; then
      status="FAIL"
      detail="both iptables-persistent and nftables are installed"
   else
      status="PASS"
   fi
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.4.3.1.3 Ensure ufw is uninstalled or disabled with iptables"
echo "$testcase"
detail=""
output=$(/bin/dpkg -s ufw 2>&1 | /bin/grep -E '(^Status:|not installed)')

output2=$(/bin/dpkg -s iptables-persistent 2>&1 | /bin/grep -E '(Status:|not installed)')
output3=$(ufw status)
if [[ $output2 == *"is installed"* && $output == *"is installed"* && $output3 == *"active"* ]]; then
   status="FAIL"
   detail="Both iptables persistent and ufw are installed"
else
   status="PASS"
fi
echo "ufw installed - $output"
echo "iptables-persistent - $output2"
echo "ufw status - $output3"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file



testcase="3.4.3.2.1 Ensure iptables default deny firewall policy"
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
echo "$output1"$'\n'"$output2"$'\n'"$output3"
detail=$(echo "$output" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.4.3.2.2 Ensure iptables loopback traffic is configured"
echo "$testcase"
detail=""

echo "iptables OUTPUT"
output1=$(/sbin/iptables -L OUTPUT -v -n)
echo "$output1"
echo "iptables INPUT"
output2=$(/sbin/iptables -L INPUT -v -n)
echo "$output2"
status="Pending"
detail="Verify manually with the output"

detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.4.3.2.3 Ensure iptables outbound and established connections are configured"
echo "$testcase"
detail=""
output=$(/sbin/iptables -L -v -n)
echo "$output"
status="Pending"
detail="Verify manually with the output"

detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.4.3.2.4 Ensure iptables firewall rules exist for all open ports"
echo "$testcase"
detail=""
output=$(/bin/ss -4tuln)
echo -e "open ports - \n$output"
output=$(/sbin/iptables -L INPUT -v -n)
echo -e "firewall rules - \n$output"
status="Pending"
detail="Verify manually with output"

detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.4.3.3.1 Ensure ip6tables default deny firewall policy"
echo "$testcase"
detail=""
output=$(ip6tables -L -n)
output1=$(ip6tables -L | /bin/grep 'Chain INPUT')
output2=$(ip6tables -L | /bin/grep 'Chain FORWARD')
output3=$(ip6tables -L | /bin/grep 'Chain OUTPUT')

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

output=$(/bin/grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable && /bin/echo 'IPv6 is enabled' || /bin/echo 'IPv6 is not enabled')
if [[ $status == "FAIL" && $output == "IPv6 is not enabled" ]]; then
   status="PASS"
fi
echo -e "$output1\n$output2\n$output3"
echo "IPv6 enabled? - $output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.4.3.3.2 Ensure ip6tables loopback traffic is configured"
echo "$testcase"
detail=""

echo "ip6tables output"
output1=$(/sbin/ip6tables -L OUTPUT -v -n)
echo "$output1"
if [[ $output1 == "pass" ]]; then status="PASS"; else status="FAIL"; fi
echo "ip6tables input"
output2=$(/sbin/ip6tables -L INPUT -v -n)
echo "$output2"
if [[ $output2 == "pass" ]]; then status="PASS"; else status="FAIL"; fi
output=$(/bin/grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable && /bin/echo 'IPv6 is enabled' || /bin/echo 'IPv6 is not enabled')
if [[ $status == "FAIL" && $output == "IPv6 is not enabled" ]]; then
   status="PASS"
fi

echo "IPv6 enabled? - $output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.4.3.3.3 Ensure ip6tables outbound and established connections are configured"
echo "$testcase"
detail=""
output=$(/sbin/ip6tables -L -v -n)
echo "$output"
output=$({
if grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable; then
echo -e " - IPv6 is enabled on the system"
else
echo -e " - IPv6 is not enabled on the system"
fi
})
echo "$output"
status="Pending"
detail="Verify manually with output"
echo "$output"

detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="3.4.3.3.4 Ensure ip6tables firewall rules exist for all open ports"
echo "$testcase"
detail=""
output1=$(/bin/ss -6tuln)
echo "open ports - \n$output1"
output2=$(/sbin/ip6tables -L INPUT -v -n)
echo "firewall rules - \n$output2"
status="Pending"
detail="Verify manually with output"
output=$({
 if grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable; then
 echo -e " - IPv6 is enabled on the system"
 else
 echo -e " - IPv6 is not enabled on the system"
 fi
})
echo "IPv6 enabled ? - \n$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="4.1.1 Ensure cron daemon is enabled and active"
echo "$testcase"
detail=""
cronoutput1=$(systemctl is-enabled cron)
cronoutput2=$(systemctl is-active cron)
if [[ $cronoutput1 == "enabled" && $cronoutput2 == "active" ]]; then status="PASS"; else status="FAIL" detail="not enabled or not active"; fi

echo -e "$cronoutput1\n$cronoutput2"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.1.2 Ensure permissions on /etc/crontab are configured"
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
echo "Cron - $cronoutput1, $cronoutput2"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.1.3 Ensure permissions on /etc/cron.hourly are configured"
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
echo "Cron - $cronoutput1, $cronoutput2"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.1.4 Ensure permissions on /etc/cron.daily are configured"
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
echo "Cron - $cronoutput1, $cronoutput2"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.1.5 Ensure permissions on /etc/cron.weekly are configured"
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
echo "Cron - $cronoutput1, $cronoutput2"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.1.6 Ensure permissions on /etc/cron.monthly are configured"
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
echo "Cron - $cronoutput1, $cronoutput2"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.1.7 Ensure permissions on /etc/cron.d are configured"
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
echo "Cron - $cronoutput1, $cronoutput2"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.1.8 Ensure crontab is restricted to authorized users"
echo "$testcase"
detail=""
output=$({
 l_output="" l_output2=""
 if dpkg-query -W cron > /dev/null 2>&1; then
 l_file="/etc/cron.allow"
 [ -e /etc/cron.deny ] && l_output2="$l_output2\n - cron.deny exists"
 if [ ! -e /etc/cron.allow ]; then 
 l_output2="$l_output2\n - cron.allow doesn't exist"
 else
 l_mask='0137'
 l_maxperm="$( printf '%o' $(( 0777 & ~$l_mask)) )"
 while read l_mode l_fown l_fgroup; do 
 if [ $(( $l_mode & $l_mask )) -gt 0 ]; then
 l_output2="$l_output2\n - \"$l_file\" is mode: \"$l_mode\" (should be mode: \"$l_maxperm\" or more restrictive)"
 else
 l_output="$l_output\n - \"$l_file\" is correctly set to mode: \"$l_mode\""
 fi
 if [ "$l_fown" != "root" ]; then
 l_output2="$l_output2\n - \"$l_file\" is owned by user \"$l_fown\" (should be owned by \"root\")"
 else
 l_output="$l_output\n - \"$l_file\" is correctly owned by user: \"$l_fown\""
 fi
 if [ "$l_fgroup" != "crontab" && "$l_fgroup" != "root" ]; then
 l_output2="$l_output2\n - \"$l_file\" is owned by group: \"$l_fgroup\" (should be owned by group: \"crontab\")"
 else
 l_output="$l_output\n - \"$l_file\" is correctly owned by group: \"$l_fgroup\""
 fi
 done < <(stat -Lc '%#a %U %G' "$l_file")
 fi
 else
 l_output="$l_output\n - cron is not installed on the system"
 fi
 if [ -z "$l_output2" ]; then
 echo -e "\n- Audit Result:\n ** PASS **$l_output\n"
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:$l_output2\n"
 fi
}
)

if [[ $output == *"** PASS **"* ]]; then
   status="PASS"
else
    status="FAIL"
    detail="$output"
fi
echo "Cron - $cronoutput1, $cronoutput2"
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.1.9 Ensure at is restricted to authorized users"
echo "$testcase"
detail=""
output=$({
 l_output="" l_output2=""
 if dpkg-query -W at > /dev/null 2>&1; then
 l_file="/etc/at.allow"
 [ -e /etc/at.deny ] && l_output2="$l_output2\n - at.deny exists"
 if [ ! -e /etc/at.allow ]; then 
 l_output2="$l_output2\n - at.allow doesn't exist"
 else
 l_mask='0137'
 l_maxperm="$( printf '%o' $(( 0777 & ~$l_mask)) )"
 while read l_mode l_fown l_fgroup; do
 if [ $(( $l_mode & $l_mask )) -gt 0 ]; then
 l_output2="$l_output2\n - \"$l_file\" is mode: \"$l_mode\" (should be mode: \"$l_maxperm\" or more restrictive)"
 else
 l_output="$l_output\n - \"$l_file\" is correctly set to mode: \"$l_mode\""
 fi
 if [ "$l_fown" != "root" ]; then
 l_output2="$l_output2\n - \"$l_file\" is owned by user \"$l_fown\" (should be owned by \"root\")"
 else
 l_output="$l_output\n - \"$l_file\" is correctly owned by user: \"$l_fown\""
 fi
 if [ "$l_fgroup" != "root" ]; then
 l_output2="$l_output2\n - \"$l_file\" is owned by group: \"$l_fgroup\" (should be owned by group: \"root\")"
 else
 l_output="$l_output\n - \"$l_file\" is correctly owned by group: \"$l_fgroup\""
 fi
 done < <(stat -Lc '%#a %U %G' "$l_file")
 fi
 else
 l_output="$l_output\n - at is not installed on the system"
 fi
 if [ -z "$l_output2" ]; then
 echo -e "\n- Audit Result:\n ** PASS **$l_output\n"
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:$l_output2\n"
 fi
}
)

if [[ $output == *"** PASS **"* ]]; then
   status="PASS"
else
    status="FAIL"
    detail="$output"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file




testcase="4.2.1 Ensure permissions on /etc/ssh/sshd_config are configured"
echo "$testcase"
detail=""

output=$({
 l_output="" l_output2=""
 unset a_sshdfiles && a_sshdfiles=()
 [ -e "/etc/ssh/sshd_config" ] && a_sshdfiles+=("$(stat -Lc '%n^%#a^%U^%G' "/etc/ssh/sshd_config")")
 while IFS= read -r -d $'\0' l_file; do
 [ -e "$l_file" ] && a_sshdfiles+=("$(stat -Lc '%n^%#a^%U^%G' "$l_file")")
 done < <(find /etc/ssh/sshd_config.d -type f \( -perm /077 -o ! -user root -o ! -group root \) -print0)
 if (( ${#a_sshdfiles[@]} != 0 )); then
 perm_mask='0177'
 maxperm="$( printf '%o' $(( 0777 & ~$perm_mask)) )"
 while IFS="^" read -r l_file l_mode l_user l_group; do
 l_out2=""
 [ $(( $l_mode & $perm_mask )) -gt 0 ] && l_out2="$l_out2\n - Is mode: \"$l_mode\" should be: \"$maxperm\" or more restrictive"
 [ "$l_user" != "root" ] && l_out2="$l_out2\n - Is owned by \"$l_user\" should be owned by \"root\""
 [ "$l_group" != "root" ] && l_out2="$l_out2\n - Is group owned by \"$l_user\" should be group owned by \"root\""
 if [ -n "$l_out2" ]; then
 l_output2="$l_output2\n - File: \"$l_file\":$l_out2"
 else
 l_output="$l_output\n - File: \"$l_file\":\n - Correct: mode ($l_mode), owner ($l_user), and group owner ($l_group) configured"
 fi
 done <<< "$(printf '%s\n' "${a_sshdfiles[@]}")"
 fi
 unset a_sshdfiles
 # If l_output2 is empty, we pass
 if [ -z "$l_output2" ]; then
 echo -e "\n- Audit Result:\n *** PASS ***\n- * Correctly set * :\n$l_output\n"
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :\n$l_output2\n"
 [ -n "$l_output" ] && echo -e " - * Correctly set * :\n$l_output\n"
 fi
}
)

if [[ $output == *"** PASS **"* ]]; then
   status="PASS"
else
    status="FAIL"
    detail="$output"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="4.2.2 Ensure permissions on SSH private host key files are configured"
echo "$testcase"
detail=""

output=$({
 l_output="" l_output2=""
 l_skgn="ssh_keys" # Group designated to own openSSH keys
 l_skgid="$(awk -F: '($1 == "'"$l_skgn"'"){print $3}' /etc/group)" # Get gid of 
group
 [ -n "$l_skgid" ] && l_agroup="(root|$l_skgn)" || l_agroup="root"
 unset a_skarr && a_skarr=() # Clear and initialize array
 while IFS= read -r -d $'\0' l_file; do # Loop to populate array
 if grep -Pq ':\h+OpenSSH\h+private\h+key\b' <<< "$(file "$l_file")"; then
 a_skarr+=("$(stat -Lc '%n^%#a^%U^%G^%g' "$l_file")")
 fi
 done < <(find -L /etc/ssh -xdev -type f -print0)
 while IFS="^" read -r l_file l_mode l_owner l_group l_gid; do
 echo "File: \"$l_file\" Mode: \"$l_mode\" Owner: \"$l_owner\" Group: \"$l_group\" GID: \"$l_gid\""
 l_out2=""
 [ "$l_gid" = "$l_skgid" ] && l_pmask="0137" || l_pmask="0177"
 l_maxperm="$( printf '%o' $(( 0777 & ~$l_pmask )) )"
 if [ $(( $l_mode & $l_pmask )) -gt 0 ]; then
 l_out2="$l_out2\n - Mode: \"$l_mode\" should be mode: \"$l_maxperm\" or more restrictive"
 fi
 if [ "$l_owner" != "root" ]; then
 l_out2="$l_out2\n - Owned by: \"$l_owner\" should be owned by \"root\""
 fi
 if [[ ! "$l_group" =~ $l_agroup ]]; then
 l_out2="$l_out2\n - Owned by group \"$l_group\" should be group owned by: \"${l_agroup//|/ or }\""
 fi
 if [ -n "$l_out2" ]; then
 l_output2="$l_output2\n - File: \"$l_file\"$l_out2"
 else
 l_output="$l_output\n - File: \"$l_file\"\n - Correct: mode ($l_mode), owner ($l_owner), and group owner ($l_group) configured"
 fi
 done <<< "$(printf '%s\n' "${a_skarr[@]}")"
 unset a_skarr
 if [ -z "$l_output2" ]; then
 echo -e "\n- Audit Result:\n ** PASS **\n- * Correctly set * :\n$l_output\n"
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :\n$l_output2\n"
 [ -n "$l_output" ] && echo -e " - * Correctly set * :\n$l_output\n"
 fi
}
)

if [[ $output == *"** PASS **"* ]]; then
   status="PASS"
else
    status="FAIL"
    detail="$output"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="4.2.3 Ensure permissions on SSH public host key files are configured"
echo "$testcase"
detail=""

output=$({
 l_output="" l_output2=""
 l_pmask="0133" 
 awk '{print}' <<< "$(find -L /etc/ssh -xdev -type f -exec stat -Lc "%n %#a %U %G" {} +)" | (while read -r l_file l_mode l_owner l_group; do
 if file "$l_file" | grep -Pq ':\h+OpenSSH\h+(\H+\h+)?public\h+key\b'; 
then
 l_maxperm="$( printf '%o' $(( 0777 & ~$l_pmask )) )"
 if [ $(( $l_mode & $l_pmask )) -gt 0 ]; then
 l_output2="$l_output2\n - Public key file: \"$l_file\" is mode \"$l_mode\" should be mode: \"$l_maxperm\" or more restrictive"
 else
 l_output="$l_output\n - Public key file: \"$l_file\" is mode \"$l_mode\" should be mode: \"$l_maxperm\" or more restrictive"
 fi
 if [ "$l_owner" != "root" ]; then
 l_output2="$l_output2\n - Public key file: \"$l_file\" is owned by: \"$l_owner\" should be owned by \"root\""
 else
 l_output="$l_output\n - Public key file: \"$l_file\" is owned by: \"$l_owner\" should be owned by \"root\""
 fi
 if [ "$l_group" != "root" ]; then
 l_output2="$l_output2\n - Public key file: \"$l_file\" is owned by group \"$l_group\" should belong to group \"root\"\n"
 else
 l_output="$l_output\n - Public key file: \"$l_file\" is owned by group \"$l_group\" should belong to group \"root\"\n"
 fi
 fi
 done
 if [ -z "$l_output2" ]; then
 echo -e "\n- Audit Result:\n *** PASS ***\n$l_output"
 else
 echo -e "\n- Audit Result:\n *** FAIL ***\n$l_output2\n\n - Correctly set:\n$l_output"
 fi
 )
}
)

if [[ $output == *"** PASS **"* ]]; then
   status="PASS"
else
    status="FAIL"
    detail="$output"
fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="4.2.4 Ensure SSH access is limited"
echo "$testcase"
detail=""

output1=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -Pi '^\h*(allow|deny)(users|groups)\h+\H+(\h+.*)?$')
output2=$(grep -Pis '^\h*(allow|deny)(users|groups)\h+\H+(\h+.*)?$' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf)

if [[ $output1 == *"allowusers "* || $output1 == *"allowgroups "* || $output1 == *"denyusers "* || $output1 == *"denygroups "* ]]; then
    if [[ $output2 == *"allowusers "* || $output2 == *"allowgroups "* || $output2 == *"denyusers "* || $output2 == *"denygroups "* ]]; then
        status="PASS";
    else
        status="FAIL";
        detail="Access issue in /etc/ssh/sshd_config"
    fi
else
    status="FAIL"
    detail="Access issue for sshd /etc/hosts"
fi
echo -e "$output1"$'\n'"$output2"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.2.5 Ensure SSH LogLevel is appropriate"
echo "$testcase"
detail=""

output1=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep loglevel)
output2=$(grep -Pis '^\h*loglevel\h+' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf | grep -Pvi '(VERBOSE|INFO)')

if [[ $output1 == *"loglevel VERBOSE"* || $output1 == *"loglevel INFO"* ]]; then
    if [[ -z "$output2" ]]; then
        status="PASS";
    else
        status="FAIL";
        detail="Output2 failed"
    fi
else
    status="FAIL"
    detail="Output1 failed"
fi
echo -e "$output1\n$output2"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.2.6 Ensure SSH PAM is enabled"
echo "$testcase"
detail=""

output1=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i usepam)
output2=$(grep -Pis '^\h*UsePAM\h+"?no"?\b' /etc/ssh/sshd_config /etc/ssh/ssh_config.d/*.conf)

if [[ $output1 == *"usepam yes"* ]]; then
    if [[ -z "$output2" ]]; then
        status="PASS";
    else
        status="FAIL";
        detail="Output2 failed"
    fi
else
    status="FAIL"
    detail="Output1 failed"
fi
echo -e "$output1\n$output2"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.2.7 Ensure SSH root login is disabled"
echo "$testcase"
detail=""

output1=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep permitrootlogin)
output2=$(grep -Pis '^\h*PermitRootLogin\h+"?(yes|prohibit-password|forced-commands-only)"?\b' /etc/ssh/sshd_config /etc/ssh/ssh_config.d/*.conf)

if [[ $output1 == *"permitrootlogin no"* ]]; then
    if [[ -z "$output2" ]]; then
        status="PASS";
    else
        status="FAIL";
        detail="Output2 failed"
    fi
else
    status="FAIL"
    detail="Output1 failed"
fi
echo -e "$output1\n$output2"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.2.8 Ensure SSH HostbasedAuthentication is disabled"
echo "$testcase"
detail=""

output1=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep hostbasedauthentication)
output2=$(grep -Pis '^\h*HostbasedAuthentication\h+"?yes"?\b' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf)

if [[ $output1 == *"hostbasedauthentication no"* ]]; then
    if [[ -z "$output2" ]]; then
        status="PASS";
    else
        status="FAIL";
        detail="Output2 failed"
    fi
else
    status="FAIL"
    detail="Output1 failed"
fi
echo -e "$output1\n$output2"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.2.9 Ensure SSH PermitEmptyPasswords is disabled"
echo "$testcase"
detail=""

output1=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep permitemptypasswords)
output2=$(grep -Pis '^\h*PermitEmptyPasswords\h+"?yes\b' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf)

if [[ $output1 == *"permitemptypasswords no"* ]]; then
    if [[ -z "$output2" ]]; then
        status="PASS";
    else
        status="FAIL";
        detail="Output2 failed"
    fi
else
    status="FAIL"
    detail="Output1 failed"
fi
echo -e "$output1\n$output2"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.2.10 Ensure SSH PermitUserEnvironment is disabled"
echo "$testcase"
detail=""

output1=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep permituserenvironment)
output2=$(grep -Pis '^\h*PermitUserEnvironment\h+"?yes"?\b' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf)

if [[ $output1 == *"permituserenvironment no"* ]]; then
    if [[ -z "$output2" ]]; then
        status="PASS";
    else
        status="FAIL";
        detail="Output2 failed"
    fi
else
    status="FAIL"
    detail="Output1 failed"
fi
echo -e "$output1\n$output2"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.2.11 Ensure SSH IgnoreRhosts is enabled"
echo "$testcase"
detail=""

output1=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep ignorerhosts)
output2=$(grep -Pis '^\h*ignorerhosts\h+"?no"?\b' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf)

if [[ $output1 == *"ignorerhosts yes"* ]]; then
    if [[ -z "$output2" ]]; then
        status="PASS";
    else
        status="FAIL";
        detail="Output2 failed"
    fi
else
    status="FAIL"
    detail="Output1 failed"
fi
echo -e "$output1\n$output2"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.2.12 Ensure SSH X11 forwarding is disabled"
echo "$testcase"
detail=""

output1=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i x11forwarding)
output2=$(grep -Pis '^\h*x11forwarding\h+"?yes"?\b' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf)

if [[ $output1 == *"x11forwarding no"* ]]; then
    if [[ -z "$output2" ]]; then
        status="PASS";
    else
        status="FAIL";
        detail="Output2 failed"
    fi
else
    status="FAIL"
    detail="Output1 failed"
fi
echo -e "$output1\n$output2"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.2.13 Ensure only strong Ciphers are used"
echo "$testcase"
detail=""

output1=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep ciphers)

if [[ $output1 == *"3des-cbc"* || $output1 == *"aes128-cbc"* || $output1 == *"aes192-cbc"* || $output1 == *"aes256-cbc"* || $output1 == *"rijndael-cbc@lysator.liu.se"* ]]; then
    status="FAIL";
    detail="Weak ciphers - $output1"
else
    status="PASS";
fi
echo "$output1"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.2.14 Ensure only strong HMAC algorithms are used"
echo "$testcase"
detail=""

output1=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i "MACs")

if [[ $output1 == *"hmac-md5"* || $output1 == *"hmac-md5-96"* || $output1 == *"hmac-ripemd160"* || $output1 == *"hmac-sha1"* || $output1 == *"hmac-sha1-96"* || $output1 == *"umac-64@openssh.com"* || $output1 == *"hmac-md5-etm@openssh.com"* || $output1 == *"hmac-md5-96-etm@openssh.com"* || $output1 == *"hmac-ripemd160-etm@openssh.com"* || $output1 == *"hmac-sha1-etm@openssh.com"* || $output1 == *"hmac-sha1-96-etm@openssh.com"* || $output1 == *"umac-64-etm@openssh.com"* ]]; then
    status="FAIL";
    detail="Weak HMAC algorithms - $output1"
else
    status="PASS";
fi
echo "$output1"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.2.15 Ensure only strong Key Exchange algorithms are used"
echo "$testcase"
detail=""

output1=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep kexalgorithms)

if [[ $output1 == *"diffie-hellman-group1-sha1"* || $output1 == *"diffie-hellman-group14-sha1"* || $output1 == *"diffie-hellman-group-exchange-sha1"* ]]; then
    status="FAIL";
    detail="Weak key exchange algorithms - $output1"
else
    status="PASS";
fi
echo "$output1"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.2.16 Ensure SSH AllowTcpForwarding is disabled"
echo "$testcase"
detail=""

output1=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i allowtcpforwarding)
output2=$(grep -Pis '^\h*AllowTcpForwarding\h+"?yes\b' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf)

if [[ $output1 == *"allowtcpforwarding no"* ]]; then
    if [[ -z "$output2" ]]; then
        status="PASS";
    else
        status="FAIL";
        detail="Output2 failed"
    fi
else
    status="FAIL"
    detail="Output1 failed"
fi
echo -e "$output1\n$output2"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.2.17 Ensure SSH warning banner is configured"
echo "$testcase"
detail=""

output1=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep banner)

if [[ $output1 == *"banner /etc/issue.net"* ]]; then
    status="PASS";
else
    status="FAIL";
    detail="$output1"
fi
echo "$output1"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.2.18 Ensure SSH MaxAuthTries is set to 4 or less"
echo "$testcase"
detail=""

output1=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep maxauthtries)
output2=$(grep -Pis '^\h*maxauthtries\h+"?([5-9]|[1-9][0-9]+)\b' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf)

if [[ $output1 =~ maxauthtries[[:space:]]+[0-4] ]]; then
    if [[ -z "$output2" ]]; then
        status="PASS";
    else
        status="FAIL";
        detail="Error in /etc/ssh/sshd_config"
    fi
else
    status="FAIL"
    detail="Error in MaxAuthTries value"
fi
output="$output1"$'\n'"$output2"
echo "$output"
detail=$(echo "$output" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.2.19 Ensure SSH MaxStartups is configured"
echo "$testcase"
detail=""

output1=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i maxstartups)
output2=$(grep -Pis '^\h*maxstartups\h+"?(((1[1-9]|[1-9][0-9][0-9]+):([0-9]+):([0-9]+))|(([0-9]+):(3[1-9]|[4-9][0-9]|[1-9][0-9][0-9]+):([0-9]+))|(([0-9]+):([0-9]+):(6[1-9]|[7-9][0-9]|[1-9][0-9][0-9]+)))\b' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf)

if [[ $output1 =~ maxstartups[[:space:]]+[0-10]+:[0-30]+:[0-60]+ ]]; then
    if [[ -z "$output2" ]]; then
        status="PASS";
    else
        status="FAIL";
        detail="Error in /etc/ssh/sshd_config"
    fi
else
    status="FAIL"
    detail="Error in MaxStartups value"
fi
echo -e "$output1\n$output2"

detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.2.20 Ensure SSH LoginGraceTime is set to one minute or less"
echo "$testcase"
detail=""

output1=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep logingracetime)
output2=$(grep -Pis '^\h*LoginGraceTime\h+"?(0|6[1-9]|[7-9][0-9]|[1-9][0-9][0-9]+|[^1]m)\b' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf)

if [[ $output1 =~ logingracetime[[:space:]]+[1-60]+ ]]; then
    if [[ -z "$output2" ]]; then
        status="PASS";
    else
        status="FAIL";
        detail="Error in /etc/ssh/sshd_config"
    fi
else
    status="FAIL"
    detail="Error in LoginGraceTime value"
fi
echo -e "$output1\n$output2"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.2.21 Ensure SSH MaxSessions is set to 10 or less"
echo "$testcase"
detail=""

output1=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i maxsessions)
output2=$(grep -Pis '^\h*MaxSessions\h+"?(1[1-9]|[2-9][0-9]|[1-9][0-9][0-9]+)\b' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf)

if [[ $output1 =~ maxsessions[[:space:]]+[0-10]+ ]]; then
    if [[ -z "$output2" ]]; then
        status="PASS";
    else
        status="FAIL";
        detail="Error in /etc/ssh/sshd_config"
    fi
else
    status="FAIL"
    detail="Error in SSH maxsessions value"
fi
echo -e "$output1\n$output2"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.2.22 Ensure SSH Idle Timeout Interval is configured"
echo "$testcase"
detail=""

output1=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep clientaliveinterval)
output2=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep clientalivecountmax)
output3=$(grep -Pis '^\h*ClientAliveCountMax\h+"?0\b' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf)

if [[ $output1 =~ clientaliveinterval[[:space:]]+[1-9][0-9]* ]]; then
    if [[ $output2 =~ clientalivecountmax[[:space:]]+[1-9][0-9]* ]]; then
        if [[ -z "$output3" ]]; then
            status="PASS";
        else
            status="FAIL";
            detail="Error in /etc/ssh/sshd_config"
        fi
    else
        status="FAIL";
        detail="Error in ClientAliveCountMax value"
    fi
else
    status="FAIL"
    detail="Error in clientaliveinterval value"
fi
echo -e "$output1\n$output2\n$output3"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file




testcase="4.3.1 Ensure sudo is installed"
echo "$testcase"
detail=""
output=$(dpkg-query -W sudo sudo-ldap > /dev/null 2>&1 && dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' sudo sudo-ldap | awk '($4=="installed" && $NF=="installed") {print "\n""PASS:""\n""Package ""\""$1"\""" is installed""\n"}' || echo -e "\nFAIL:\nneither \"sudo\" or \"sudo-ldap\" package is installed\n")
if [[ $output == *"neither"* ]]; then status="FAIL" detail="$output"; else status="PASS"; fi
if [[ $output == *"PASS"* ]]; then status="PASS" detail="$output"; else status="FAIL" detail="$output"; fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.3.2 Ensure sudo commands use pty"
echo "$testcase"
detail=""

output=$(/bin/grep -rPi -- '^\h*Defaults\h+([^#\n\r]+,)?use_pty(,\h*\h+\h*)*\h*(#.*)?$' /etc/sudoers*)
if [[ $output == "/etc/sudoers:Defaults        use_pty" ]]; then
   status="PASS"
else
   status="FAIL";
   detail="$output";
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.3.3 Ensure sudo log file exists"
echo "$testcase"
detail=""

output=$(grep -rPsi "^\h*Defaults\h+([^#]+,\h*)?logfile\h*=\h*(\"|\')?\H+(\"|\')?(,\h*\H+\h*)*\h*(#.*)?$" /etc/sudoers*)
if [[ $output == "Defaults logfile=\"/var/log/sudo.log\"" ]]; then
   status="PASS"
else
   status="FAIL";
   detail="$output";
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.3.4 Ensure users must provide password for privilege escalation"
echo "$testcase"
detail=""

output=$(grep -r "^[^#].*NOPASSWD" /etc/sudoers*)
if [[ -z "$output" ]]; then
   status="PASS"
else
   status="FAIL";
   detail="$output";
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.3.5 Ensure re-authentication for privilege escalation is not disabled globally"
echo "$testcase"
detail=""
output=$(grep -r "^[^#].*\!authenticate" /etc/sudoers*)
if [[ -z $output ]]; then status="PASS"; else status="FAIL" detail="!authenticate tag found"; fi

echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.3.6 Ensure sudo authentication timeout is configured correctly"
echo "$testcase"
detail=""
output=$(grep -roP "timestamp_timeout=\K[0-9]*" /etc/sudoers*)
if [[ -z $output ]]; then
	echo "Not set. Check for default config"
	output1=$(sudo -V | grep "Authentication timestamp timeout:")
	if [[ -z $output1 ]]; then
		status="FAIL"
		detail="Not set"
	else
		status="Pending"
		detail="Check manually from output"
		echo "$output1"
	fi
else
   output=${output:18}
   let int=$output
   if [ "$int" -le 15 ]; then
      status="PASS"
   else
      status="FAIL"
      detail="Large timeout"
   fi
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.3.7 Ensure access to the su command is restricted"
echo "$testcase"
detail=""
output=$(grep -Pi '^\h*auth\h+(?:required|requisite)\h+pam_wheel\.so\h+(?:[^#\n\r]+\h+)?((?!\2)(use_uid\b|group=\H+\b))\h+(?:[^#\n\r]+\h+)?((?!\1)(use_uid\b|group=\H+\b))(\h+.*)?$' /etc/pam.d/su)
if [[ $output == *"auth	required			pam_wheel.so use_uid group="* ]]; then
	detail="Output matches the format"
	echo "$output"
	output1=${output:41}
	echo "$output1"
	output2=$(grep $output1 /etc/group)
	echo "$output2"
	if [[ -z "$output2" ]]; then
    	status="PASS";
	else
	    status="FAIL"
	    detail="$output2"
	fi
else
	detail="Output does not match the format"
	status="FAIL"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.4.1 Ensure password creation requirements are configured"
echo "$testcase"
detail=""
output1=$(grep '^\s*minlen\s*' /etc/security/pwquality.conf 2>&1)
output2=$(grep '^\s*minclass\s*' /etc/security/pwquality.conf 2>&1)
output3=$(grep -P '^\h*password\h+[^#\n\r]+\h+pam_pwquality\.so\b' /etc/pam.d/common-password 2>&1)

if [[ $output1 == *"No such file or directory"* ]]; then
	status="FAIL"
	detail="$output1"
else
if [[ $output1 == *"minlen = 14"* ]]; then
    if [[ $output2 == *"minclass = 4"* ]]; then
        if [[ $output3 == *"retry=3"* ]]; then
            status="PASS";
        else
            status="FAIL";
            detail="pam pwquality not enabled";
        fi
    else
        status="FAIL";
        detail="minclass value does not match";
    fi
else
    status="FAIL"
    detail="minlen value does not match";
fi
fi
echo -e "$output1\n$output2\n$output3"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.4.2 Ensure lockout for failed password attempts is configured"
echo "$testcase"
detail=""
output1=$(grep 'pam_tally2' /etc/pam.d/common-auth)
output2=$(grep -E 'pam_(tally2|deny)\.so' /etc/pam.d/common-account)

if [[ $output1 == *"deny="* ]]; then
    deny_value=$(echo "$output1" | grep -oP 'deny=\K\d+')
    let int=$deny_value
    if [[ $int -le 5 ]]; then
        if [[ $output2 == *"pam_deny.so"* && $output2 == *"pam_tally2.so"* ]]; then
            status="PASS"
        else
            status="FAIL";
            detail="Not included in correct path"
        fi
    else
        status="FAIL";
        detail="Value not less than equal to 5";
    fi
else
    status="FAIL";
    detail="deny= does not exist";
fi
echo -e "verify pam tally - \n $output1"
echo -e "verify pam deny and tally - \n $output2"

detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.4.3 Ensure password reuse is limited"
echo "$testcase"
detail=""
output=$(grep -P -- '^\h*password\h+([^#\n\r]+\h+)?(pam_pwhistory\.so|pam_unix\.so)\b' /etc/pam.d/common-password)
status="Pending"
detail="Verify manually from output"
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.4.4 Ensure strong password hashing algorithm is configured"
echo "$testcase"
detail=""
output1=$(grep -Pi -- '^\h*password\h+[^#\n\r]+\h+pam_unix.so([^#\n\r]+\h+)?(sha512|yescrypt)\b' /etc/pam.d/common-password)
output2=$(grep -Pi -- '^\h*ENCRYPT_METHOD\h+"?(sha512|yescrypt)\b' /etc/login.defs)
if [[ $output1 == *"sha512"* ]]; then
    if [[ $output2 == *"SHA512"* ]]; then
        status="PASS"
    else
        status="FAIL"
        detail="encrypt method not set to sha512"
    fi
else
    status="FAIL"
    detail="sha512 not present in pam_unix so"
fi
echo "pam.d - common-password -> $output1"
echo "etc login.defs -> $output2"
detail=$(echo "$detail" | tr '\n' ' ')
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.4.5 Ensure all current passwords uses the configured hashing algorithm"
echo "$testcase"
detail=""
output=$(
 declare -A HASH_MAP=( ["y"]="yescrypt" ["1"]="md5" ["2"]="blowfish" ["5"]="SHA256" ["6"]="SHA512" ["g"]="gost-yescrypt" )

 CONFIGURED_HASH=$(sed -n "s/^\s*ENCRYPT_METHOD\s*\(.*\)\s*$/\1/p" /etc/login.defs)
 for MY_USER in $(sed -n "s/^\(.*\):\\$.*/\1/p" /etc/shadow)
 do
 CURRENT_HASH=$(sed -n "s/${MY_USER}:\\$\(.\).*/\1/p" /etc/shadow)
 if [[ "${HASH_MAP["${CURRENT_HASH}"]^^}" != "${CONFIGURED_HASH^^}" ]]; 
then 
 echo "The password for '${MY_USER}' is using '${HASH_MAP["${CURRENT_HASH}"]}' instead of the configured '${CONFIGURED_HASH}'."
 fi
 done
)
if [[ -z "$output" ]]; then
    status="PASS"
else
    status="FAIL"
    detail="$output"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.5.1.1 Ensure minimum days between password changes is configured"
echo "$testcase"
detail=""
output=$(grep PASS_MIN_DAYS /etc/login.defs)
if [[ $output =~ PASS_MIN_DAYS[[:space:]]+[1-9][0-9]* ]]; then
    status="Pending"
    detail="Verify manually. Minimum days for every user should be 1"
    output1=$(awk -F : '(/^[^:]+:[^!*]/ && $4 < 1){print $1 " " $4}' /etc/shadow)
    echo "$output1"
else
    status="FAIL"
    detail="Improper minimum days -> $output"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.5.1.2 Ensure password expiration is 365 days or less"
echo "$testcase"
detail=""
output=$(grep PASS_MAX_DAYS /etc/login.defs)
if [[ $output =~ PASS_MAX_DAYS[[:space:]]+[1-365]+ ]]; then
    status="Pending"
    detail="Verify manually. Maximum days for every user should be 365 -> $output"
    output1=$(awk -F: '(/^[^:]+:[^!*]/ && ($5>365 || $5~/([0-1]|-1|\s*)/)){print $1 " " $5}' /etc/shadow)
    echo "$output1"
else
    status="FAIL"
    detail="Improper maximum days -> $output"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.5.1.3 Ensure password expiration warning days is 7 or more"
echo "$testcase"
detail=""
output=$(grep PASS_WARN_AGE /etc/login.defs)
if [[ $output =~ PASS_WARN_AGE[[:space:]]+[7-9][0-9]* ]]; then
    status="Pending"
    detail="Verify manually. Expiration warning days for every user should be 7 or more -> $output"
    output1=$(awk -F: '(/^[^:]+:[^!*]/ && $6<7){print $1 " " $6}' /etc/shadow)
    echo "$output1"
else
    status="FAIL"
    detail="Improper warning days"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.5.1.4 Ensure inactive password lock is 30 days or less"
echo "$testcase"
detail=""
output=$(useradd -D | grep INACTIVE)
output1=${output:9}
let int="$output1"
if [[ $output == *"INACTIVE="* && $int -le 30 ]]; then
    status="Pending"
    detail="Verify manually. Expiration warning days for every user should be no more than 30 -> $output"
    output1=$(awk -F: '(/^[^:]+:[^!*]/ && ($7~/(\s*|-1)/ || $7>30)){print $1 " " $7}' /etc/shadow)
    echo "$output1"
else
    status="FAIL"
    detail="Improper maximum days. Verify manually"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.5.1.5 Ensure all users last password change date is in the past"
echo "$testcase"
detail=""
output=$({
 l_output2=""
 while read -r l_user; do
 l_change="$(chage --list $l_user | awk -F: '($1 ~ /^\s*Last\s+password\s+change/ && $2 !~ /never/){print $2}' | xargs)"
 if [[ "$(date -d "$l_change" +%s)" -gt "$(date +%s)" ]]; then
 l_output2="$l_output2\n - User: \"$l_user\" last password change is in the future \"$l_change\""
 fi
 done < <(awk -F: '($2 ~ /^[^*!xX\n\r][^\n\r]+/){print $1}' /etc/shadow)
 if [ -z "$l_output2" ]; then # If l_output2 is empty, we pass
 echo -e "\n- Audit Result:\n ** PASS **\n - All user password changes are in the past \n"
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :$l_output2\n"
 fi
})
if [[ $output == *"** PASS **"* ]]; then status="PASS"; else status="FAIL"; fi
detail=$output
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="4.5.1.6 Ensure the number of changed characters in a new password is configured"
echo "$testcase"
detail=""
output=$(grep -P '^\h*difok\h*=\h*([2-9]|[1-9][0-9]+)\b' /etc/security/pwquality.conf 2>&1)
echo "$output"
if [[ $output == *"No such file or directory"* ]]; then
	status="FAIL"
	detail="pwquality.conf not present"
else
output1=${output:8}
let int="$output1"
if [[ $int -ge 2 ]]; then status="PASS"; else status="FAIL"; fi
fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.5.1.7 Ensure preventing the use of dictionary words for passwords is configured"
echo "$testcase"
detail=""
output=$(grep -Pi '^\h*dictcheck\h*=\h*[^0]' /etc/security/pwquality.conf 2>&1)
echo "$output"
if [[ $output == *"No such file or directory"* ]]; then
	status="FAIL"
	detail="pwquality.conf not present"
else
output1=${output:12}
let int="$output1"
if [[ $int -ne 0 ]]; then status="PASS"; else status="FAIL"; fi
fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.5.2 Ensure system accounts are secured"
echo "$testcase"
detail=""
output=$({
 l_output="" l_output2=""
 l_valid_shells="^($( awk -F\/ '$NF != "nologin" {print}' /etc/shells | sed -rn '/^\//{s,/,\\\\/,g;p}' | paste -s -d '|' - ))$"
 a_users=(); a_ulock=() # initialize arrays
 while read -r l_user; do # Populate array with system accounts that have a valid login shell
 a_users+=("$l_user")
 done < <(awk -v pat="$l_valid_shells" -F: '($1!~/(root|sync|shutdown|halt|^\+)/ && $3<'"$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)"' && $(NF) ~ pat) { print $1 }' /etc/passwd)
 while read -r l_ulock; do # Populate array with system accounts that aren't locked
 a_ulock+=("$l_ulock")
 done < <(awk -v pat="$l_valid_shells" -F: '($1!~/(root|^\+)/ && $2!~/LK?/ && $3<'"$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)"' && $(NF) ~ pat) { print $1 }' /etc/passwd)
 if ! (( ${#a_users[@]} > 0 )); then
 l_output="$l_output\n - local system accounts login is disabled"
 else
 l_output2="$l_output2\n - There are \"$(printf '%s' "${#a_users[@]}")\" system accounts with login enabled\n - List of accounts:\n$(printf '%s\n' "${a_users[@]:0:$l_limit}")\n - end of list\n"
 fi
 if ! (( ${#a_ulock[@]} > 0 )); then
 l_output="$l_output\n - local system accounts are locked"
 else
 l_output2="$l_output2\n - There are \"$(printf '%s' "${#a_ulock[@]}")\" system accounts that are not locked\n - List of accounts:\n$(printf '%s\n' "${a_ulock[@]:0:$l_limit}")\n - end of list\n"
 fi
 unset a_users; unset a_ulock # Remove arrays
 if [ -z "$l_output2" ]; then
 echo -e "\n- Audit Result:\n ** PASS **\n - * Correctly configured * :\n$l_output\n"
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :\n$l_output2"
 [ -n "$l_output" ] && echo -e "- * Correctly configured * :\n$l_output\n"
 fi
}
)
echo "$output"
if [[ $output == *"** PASS **"* ]]; then
    status="PASS";
else
    status="FAIL";
    detail="$output";
fi
detail=$(echo "$detail" | tr '\n' ' ')
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.5.3 Ensure default group for the root account is GID 0"
echo "$testcase"
detail=""
output=$(grep "^root:" /etc/passwd | cut -f4 -d:)
let int=$output
if [[ $int == 0 ]]; then
    status="PASS";
else
    status="FAIL";
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.5.4 Ensure default user umask is 027 or more restrictive"
echo "$testcase"
detail=""
output1=$(passing=""
grep -Eiq '^\s*UMASK\s+(0[0-7][2-7]7|[0-7][2-7]7)\b' /etc/login.defs && grep -Eqi '^\s*USERGROUPS_ENAB\s*"?no"?\b' /etc/login.defs && grep -Eq '^\s*session\s+(optional|requisite|required)\s+pam_umask\.so\b' /etc/pam.d/common-session && passing=true
grep -REiq '^\s*UMASK\s+\s*(0[0-7][2-7]7|[0-7][2-7]7|u=(r?|w?|x?)(r?|w?|x?)(r?|w?|x?),g=(r?x?|x?r?),o=)\b' /etc/profile* /etc/bash.bashrc* && passing=true
[ "$passing" = true ] && echo "Default user umask is set")
output2=$(grep -RPi '(^|^[^#]*)\s*umask\s+([0-7][0-7][01][0-7]\b|[0-7][0-7][0-7][0-6]\b|[0-7][01][0-7]\b|[0-7][0-7][0-6]\b|(u=[rwx]{0,3},)?(g=[rwx]{0,3},)?o=[rwx]+\b|(u=[rwx]{1,3},)?g=[^rx]{1,3}(,o=[rwx]{0,3})?\b)' /etc/login.defs /etc/profile* /etc/bash.bashrc*)

if [[ $output1 == "Default user umask is set" && -z "$output2" ]]; then 
    status="PASS";
else
    status="FAIL";
fi
output=$(grep -Eiq '^\s*UMASK\s+(0[0-7][2-7]7|[0-7][2-7]7)\b' /etc/login.defs
grep -Ei '^\s*USERGROUPS_ENAB\s*"?no"?\b' /etc/login.defs
grep -E '^\s*session\s+(optional|requisite|required)\s+pam_umask\.so\b' /etc/pam.d/common-session
grep -REi '^\s*UMASK\s+\s*(0[0-7][2-7]7|[0-7][2-7]7|u=(r?|w?|x?)(r?|w?|x?)(r?|w?|x?),g=(r?x?|x?r?),o=)\b' /etc/profile* /etc/bash.bashrc*
grep -RPi '(^|^[^#]*)\s*umask\s+([0-7][0-7][01][0-7]\b|[0-7][0-7][0-7][0-6]\b|[0-7][01][0-7]\b|[0-7][0-7][0-6]\b|(u=[rwx]{0,3},)?(g=[rwx]{0,3},)?o=[rwx]+\b|(u=[rwx]{1,3},)?g=[^rx]{1,3}(,o=[rwx]{0,3})?\b)' /etc/login.defs /etc/profile* /etc/bash.bashrc*)

echo "$output"
detail="$output1"$'\n'"$output2"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="4.5.5 Ensure default user shell timeout is configured"
echo "$testcase"
detail=""
output=$({
 l_output="" l_output2=""
 l_tmv_max="900"
 l_searchloc="/etc/bashrc /etc/bash.bashrc /etc/profile /etc/profile.d/*.sh"
 a_tmofile=()
 while read -r l_file; do
 [ -e "$l_file" ] && a_tmofile+=("$(readlink -f $l_file)")
 done < <(grep -PRils '^\h*([^#\n\r]+\h+)?TMOUT=\d+\b' $l_searchloc)
 if ! (( ${#a_tmofile[@]} > 0 )); then
 l_output2="$l_output2\n - TMOUT is not set"
 elif (( ${#a_tmofile[@]} > 1 )); then
 l_output2="$l_output2\n - TMOUT is set in multiple locations.\n - List of files where TMOUT is set:\n$(printf '%s\n' "${a_tmofile[@]}")\n - end of list\n"
 else
 for l_file in ${a_tmofile[@]}; do
 if (( "$(grep -Pci '^\h*([^#\n\r]+\h+)?TMOUT=\d+' "$l_file")" > 1 )); then
 l_output2="$l_output2\n - TMOUT is set multiple times in \"$l_file\""
 else
 l_tmv="$(grep -Pi '^\h*([^#\n\r]+\h+)?TMOUT=\d+' "$l_file" | grep -Po '\d+')"
 if (( "$l_tmv" > "$l_tmv_max" )); then
 l_output2="$l_output\n - TMOUT is \"$l_tmv\" in \"$l_file\"\n - Should be \"$l_tmv_max\" or less and not \"0\""
 else
 l_output="$l_output\n- TMOUT is correctly set to \"$l_tmv\" in \"$l_file\""
 if grep -Piq '^\h*([^#\n\r]+\h+)?readonly\h+TMOUT\b' "$l_file"; then
 l_output="$l_output\n- TMOUT is correctly set to \"readonly\" in \"$l_file\""
 else
 l_output2="$l_output2\n- TMOUT is not set to \"readonly\""
 fi
 if grep -Piq '^(\h*|\h*[^#\n\r]+\h*;\h*)export\h+TMOUT\b' "$l_file"; then
 l_output="$l_output\n- TMOUT is correctly set to \"export\" in \"$l_file\""
 else
 l_output2="$l_output2\n- TMOUT is not set to \"export\""
 fi
 fi
 fi
 done
 fi
 unset a_tmofile # Remove array
 if [ -z "$l_output2" ]; then
 echo -e "\n- Audit Result:\n ** PASS **\n - * Correctly configured * :\n$l_output\n"
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :\n$l_output2"
 [ -n "$l_output" ] && echo -e "- * Correctly configured * :\n$l_output\n"
 fi
}
)
if [[ $output == *"** PASS **"* ]]; then
    status="PASS"
else
    status="FAIL"
    detail="$output"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="4.5.7 Ensure maximum number of same consecutive characters in a password is configured"
echo "$testcase"
detail=""
output=$(grep -Pi '^\h*maxrepeat\h*=\h*[1-3]\b' /etc/security/pwquality.conf)
echo "$output"
output=${output:12}
let int=$output
if [[ $int -le 3 ]]; then status="PASS"; else status="FAIL"; fi
detail=$(echo "$detail" | tr '\n' ' ')
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file



echo "Check if it is intended that the system uses journald for logging"

testcase="5.1.1.1.1 Ensure systemd-journal-remote is installed"
echo "$testcase"
detail=""
journaldout=""
output=$(/bin/dpkg -s systemd-journal-remote 2>&1 | /bin/grep -E '(Status:|not installed)')
if [[ $output == *"is installed"* ]]; then
   status="PASS"
   journaldout="TRUE"
else
   status="FAIL"
   detail="Not installed"
   journaldout="FALSE"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

if [[ $journaldout == "TRUE" ]]; then

testcase="5.1.1.1.2 Ensure systemd-journal-remote is installed"
echo "$testcase"
detail=""
output=$(grep -P "^ *URL=|^ *ServerKeyFile=|^ *ServerCertificateFile=|^*TrustedCertificateFile=" /etc/systemd/journal-upload.conf)
status="Pending"
detail="Verify manually"
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.1.1.3 Ensure systemd-journal-remote is installed"
echo "$testcase"
detail=""
output=$(systemctl is-enabled systemd-journal-upload.service)
status="Pending"
detail="Verify manually"
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.1.1.4 Ensure systemd-journal-remote is installed"
echo "$testcase"
detail=""
output=$(systemctl is-enabled systemd-journal-remote.socket)
status="Pending"
detail="Verify manually"
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="5.1.1.2 Ensure systemd-journal-remote is installed"
echo "$testcase"
detail=""
output=$(systemctl is-enabled systemd-journald.service)
status="Pending"
detail="Verify manually"
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.1.3 Ensure systemd-journal-remote is installed"
echo "$testcase"
detail=""
output=$(grep -Psi '^\h*Compress\h*=\h*yes\b' /etc/systemd/journald.conf /etc/systemd/journald.conf.d/*)
status="Pending"
detail="Verify manually"
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.1.4 Ensure journald is configured to write logfiles to persistent disk"
echo "$testcase"
detail=""
output=$(grep -Psi '^\h*Storage\h*=\h*persistent\b' /etc/systemd/journald.conf /etc/systemd/journald.conf.d/*)
status="Pending"
detail="Verify manually"
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.1.5 Ensure journald is not configured to send logs to rsyslog"
echo "$testcase"
detail=""
output=$(grep -Psi '^\h*ForwardToSyslog\h*=\h*yes\b' /etc/systemd/journald.conf /etc/systemd/journald.conf.d/*)
status="Pending"
detail="Verify manually"
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.1.6 Ensure systemd-journal-remote is installed"
echo "$testcase"
detail=""
output=$(cat /etc/systemd/journald.conf)
status="Pending"
detail="Verify manually"
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.1.7 Ensure systemd-journal-remote is installed"
echo "$testcase"
detail=""
output=$(ls -l /etc/tmpfiles.d/systemd.conf
ls -l /usr/lib/tmpfiles.d/systemd.conf)
status="Pending"
detail="Verify manually"
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

fi


echo "Checking rsyslog"

testcase="5.1.2.1 Ensure rsyslog is installed"
echo "$testcase"
detail=""
rsyslogout=""
output=$(dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' rsyslog)
if [[ $output == *"ok installed"* ]]; then
   status="PASS"
   rsyslogout="TRUE"
else
   status="FAIL"
   detail="Not installed"
   rsyslogout="FALSE"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

if [[ $rsyslogout == "TRUE" ]]; then

testcase="5.1.2.2 Ensure rsyslog service is enabled"
echo "$testcase"
detail=""
output=$(systemctl is-enabled rsyslog)
if [[ $output == *"enabled"* ]]; then
   status="PASS"
else
   status="FAIL"
   detail="Not installed"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.2.3 Ensure journald is configured to send logs to rsyslog"
echo "$testcase"
detail=""
output=$(grep ^\s*ForwardToSyslog /etc/systemd/journald.conf)
if [[ $output == *"ForwardToSyslog=yes"* ]]; then
   status="PASS"
else
   status="FAIL"
   detail="Not installed"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.2.4 Ensure rsyslog default file permissions are configured"
echo "$testcase"
detail=""
output=$(grep ^\$FileCreateMode /etc/rsyslog.conf /etc/rsyslog.d/*.conf)
if [[ $output == *"FileCreateMode 0640"* ]]; then
   status="PASS"
else
   status="FAIL"
   detail="Not installed"
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.2.5 Ensure logging is configured"
echo "$testcase"
detail=""
output1=$(cat /etc/rsyslog.conf)
echo "$output1"
output2=$(for file in /etc/rsyslog.d/*.conf; do echo $file; cat $file; done)
echo "$output2"
output3=$(ls -l /var/log/)
echo "$output3"
status="Pending"
detail="Verify manually"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.2.6 Ensure rsyslog is configured to send logs to a remote log host"
echo "$testcase"
detail=""
output1=$(grep "^*.*[^I][^I]*@" /etc/rsyslog.conf /etc/rsyslog.d/*.conf)
output2=$(grep -E '^\s*([^#]+\s+)?action\(([^#]+\s+)?\btarget=\"?[^#"]+\"?\b' /etc/rsyslog.conf /etc/rsyslog.d/*.conf)
status="Pending"
detail="Verify manually"
echo "Old format -> $output1"
echo "New format -> $output2"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.2.7 Ensure rsyslog is not configured to receive logs from a remote client"
echo "$testcase"
detail=""
output1=$(grep '$ModLoad imtcp' /etc/rsyslog.conf /etc/rsyslog.d/*.conf
grep '$InputTCPServerRun' /etc/rsyslog.conf /etc/rsyslog.d/*.conf)
output2=$(grep -P -- '^\h*module\(load="imtcp"\)' /etc/rsyslog.conf /etc/rsyslog.d/*.conf
grep -P -- '^\h*input\(type="imtcp" port="514"\)' /etc/rsyslog.conf /etc/rsyslog.d/*.conf)
status="Pending"
detail="Verify manually"
echo "Old format -> $output1"
echo "New format -> $output2"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="5.1.3 Ensure all logfiles have appropriate access configured"
echo "$testcase"
detail=""
output=$(
{
l_op2="" l_output2=""
l_uidmin="$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)"
file_test_chk()
{
	l_op2=""
	if [ $(( $l_mode & $perm_mask )) -gt 0 ]; then
		l_op2="$l_op2\n - Mode: \"$l_mode\" should be \"$maxperm\" or more restrictive"
	fi
	if [[ ! "$l_user" =~ $l_auser ]]; then
		l_op2="$l_op2\n - Owned by: \"$l_user\" and should be owned by \"${l_auser//|/ or }\""
	fi
	if [[ ! "$l_group" =~ $l_agroup ]]; then
		l_op2="$l_op2\n - Group owned by: \"$l_group\" and should be group owned by \"${l_agroup//|/ or }\""
	fi
	[ -n "$l_op2" ] && l_output2="$l_output2\n - File: \"$l_fname\" is:$l_op2\n"
}
unset a_file && a_file=() # clear and initialize array
# Loop to create array with stat of files that could possibly fail one of the audits
while IFS= read -r -d $'\0' l_file; do
	[ -e "$l_file" ] && a_file+=("$(stat -Lc '%n^%#a^%U^%u^%G^%g' "$l_file")")
done < <(find -L /var/log -type f \( -perm /0137 -o ! -user root -o ! - group root \) -print0)
while IFS="^" read -r l_fname l_mode l_user l_uid l_group l_gid; do
	l_bname="$(basename "$l_fname")"
	case "$l_bname" in
	lastlog | lastlog.* | wtmp | wtmp.* | wtmp-* | btmp | btmp.* | btmp- * | README)
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
done <<< "$(printf '%s\n' "${a_file[@]}")"
unset a_file # Clear array
# If all files passed, then we pass
if [ -z "$l_output2" ]; then
	echo -e "\n- Audit Results:\n ** Pass **\n- All files in \"/var/log/\" have appropriate permissions and ownership\n"
else
# print the reason why we are failing
	echo -e "\n- Audit Results:\n ** Fail **\n$l_output2"
fi
})
status="Pending"
detail="Verify manually"
echo "Old format -> $output1"
echo "New format -> $output2"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

fi   #ending the if condition for presence of rsyslog


testcase="5.2.4.11 Ensure cryptographic mechanisms are used to protect the integrity of audit tools"
echo "$testcase"
detail=""
output=$(grep -Ps -- '(\/sbin\/(audit|au)\H*\b)' /etc/aide.conf /etc/aide/aide.conf /etc/aide.conf.d/*.conf /etc/aide/aide.conf.d/*)
status="Pending"
detail="Verify manually"
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="6.1.1 Ensure permissions on /etc/passwd are configured"
echo "$testcase"
detail=""
output=$(stat -Lc "%n %a %u/%U %g/%G" /etc/passwd)
echo "$output"
if [[ $output == "/etc/passwd 644 0/root 0/root" ]]; then
   status="PASS"
else
   $output=${output:12:3}
   let int=$output
   if [[ $int -le 644 ]]; then status="PASS"; else status="FAIL" detail="Improper privilege"; fi
fi

detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="6.1.2 Ensure permissions on /etc/passwd- are configured"
echo "$testcase"
detail=""
output=$(stat -Lc "%n %a %u/%U %g/%G" /etc/passwd-)
output1=${output:13:3}
if [[ $output == "/etc/passwd- 644 0/root 0/root" ]]; then
	status="PASS"
else
	let int=$output1
	if [[ $int -le 644 ]]; then status="PASS"; else status="FAIL" detail="Improper privilege"; fi
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="6.1.3 Ensure permissions on /etc/group are configured"
echo "$testcase"
detail=""
output=$(stat -Lc "%n %a %u/%U %g/%G" /etc/group)
output1=${output:11:3}
if [[ $output == "/etc/group 644 0/root 0/root" ]]; then
	status="PASS"
else
	let int=$output1
	if [[ $int -le 644 ]]; then status="PASS"; else status="FAIL" detail="Improper privilege"; fi
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="6.1.4 Ensure permissions on /etc/group- are configured"
echo "$testcase"
detail=""
output=$(stat -Lc "%n %a %u/%U %g/%G" /etc/group-)
output1=${output:12:3}
if [[ $output == "/etc/group- 644 0/root 0/root" ]]; then
	status="PASS"
else
	let int=$output1
	if [[ $int -le 644 ]]; then status="PASS"; else status="FAIL" detail="Improper privilege"; fi
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="6.1.5 Ensure permissions on /etc/shadow are configured"
echo "$testcase"
detail=""
output=$(stat -Lc "%n %a %u/%U %g/%G" /etc/shadow)
output1=${output:12:3}
if [[ $output == "/etc/shadow 640 0/root 0/root" ]]; then
	status="PASS"
else
	let int=$output1
	if [[ $int -le 640 ]]; then status="PASS"; else status="FAIL" detail="Improper privilege"; fi
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="6.1.6 Ensure permissions on /etc/shadow- are configured"
echo "$testcase"
detail=""
output=$(stat -Lc "%n %a %u/%U %g/%G" /etc/shadow-)
output1=${output:13:3}
if [[ $output == "/etc/shadow- 640 0/root 0/root" ]]; then
	status="PASS"
else
	let int=$output1
	if [[ $int -le 640 ]]; then status="PASS"; else status="FAIL" detail="Improper privilege"; fi
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="6.1.7 Ensure permissions on /etc/gshadow are configured"
echo "$testcase"
detail=""
output=$(stat -Lc "%n %a %u/%U %g/%G" /etc/gshadow)
output1=${output:13:3}
if [[ $output == "/etc/gshadow 640 0/root 0/root" ]]; then
	status="PASS"
else
	let int=$output1
	if [[ $int -le 640 ]]; then status="PASS"; else status="FAIL" detail="Improper privilege"; fi
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="6.1.8 Ensure permissions on /etc/gshadow- are configured"
echo "$testcase"
detail=""
output=$(stat -Lc "%n %a %u/%U %g/%G" /etc/gshadow-)
output1=${output:14:3}
if [[ $output == "/etc/gshadow- 640 0/root 0/root" ]]; then
	status="PASS"
else
	let int=$output1
	if [[ $int -le 640 ]]; then status="PASS"; else status="FAIL" detail="Improper privilege"; fi
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="6.1.9 Ensure permissions on /etc/shells are configured"
echo "$testcase"
detail=""
output=$(stat -Lc "%n %a %u/%U %g/%G" /etc/shells)
output1=${output:12:3}
if [[ $output == "/etc/shells 644 0/root 0/root" ]]; then
	status="PASS"
else
	let int=$output1
	if [[ $int -le 644 ]]; then status="PASS"; else status="FAIL" detail="Improper privilege"; fi
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="6.1.10 Ensure permissions on /etc/security/opasswd are configured"
echo "$testcase"
detail=""
output1=$([ -e "/etc/security/opasswd" ] && stat -Lc "%n %a %u/%U %g/%G" /etc/security/opasswd)
output2=$([ -e "/etc/security/opasswd.old" ] && stat -Lc "%n %a %u/%U %g/%G" /etc/security/opasswd.old)
echo "$output1"
echo "$output2"
if [[ $output1 == "/etc/security/opasswd 600 0/root 0/root" &&  $output2 == "/etc/security/opasswd.old 600 0/root 0/root" ]]; then
   status="PASS"
else
   output1=${output1:22:3}
   output2=${output2:26:3}
   if [[ $output1 =~ ^-?[0-9]+$ ]]; then
      let int1=$output1
   fi
   if [[ $output2 =~ ^-?[0-9]+$ ]]; then
      let int2=$output2
   fi
   if [[ $int1 -le 600 && $int2 -le 600 ]]; then status="PASS"; else status="FAIL" detail="Improper privilege"; fi
fi

detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="6.1.11 Ensure world writable files and directories are secured"
echo "$testcase"
detail=""
output=$({
l_output="" l_output2=""
l_smask='01000'
a_path=(); a_arr=(); a_file=(); a_dir=() # Initialize arrays
a_path=(! -path "/run/user/*" -a ! -path "/proc/*" -a ! -path "*/containerd/*" -a ! -path "*/kubelet/pods/*" -a ! -path "/sys/kernel/security/apparmor/*" -a ! -path "/snap/*" -a ! -path "/sys/fs/cgroup/memory/*")
while read -r l_bfs; do
	a_path+=( -a ! -path ""$l_bfs"/*")
done < <(findmnt -Dkerno fstype,target | awk '$1 ~ /^\s*(nfs|proc|smb)/ {print $2}')
# Populate array with files that will possibly fail one of the audits
while IFS= read -r -d $'\0' l_file; do
	[ -e "$l_file" ] && a_arr+=("$(stat -Lc '%n^%#a' "$l_file")")
done < <(find / \( "${a_path[@]}" \) \( -type f -o -type d \) -perm -0002 -print0 2>/dev/null)
while IFS="^" read -r l_fname l_mode; do # Test files in the array
	[ -f "$l_fname" ] && a_file+=("$l_fname") # Add WR files
	if [ -d "$l_fname" ]; then # Add directories w/o sticky bit
		[ ! $(( $l_mode & $l_smask )) -gt 0 ] && a_dir+=("$l_fname")
	fi
done < <(printf '%s\n' "${a_arr[@]}")
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
detail=$(echo "$detail" | tr '\n' ' ')
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="6.1.12 Ensure no files or directories without an owner and a group exist"
echo "$testcase"
detail=""
output=$({
l_output="" l_output2=""
a_path=(); a_arr=(); a_nouser=(); a_nogroup=() # Initialize arrays
a_path=(! -path "/run/user/*" -a ! -path "/proc/*" -a ! -path "*/containerd/*" -a ! -path "*/kubelet/pods/*")
while read -r l_bfs; do
	a_path+=( -a ! -path ""$l_bfs"/*")
done < <(findmnt -Dkerno fstype,target | awk '$1 ~ /^\s*(nfs|proc|smb)/ {print $2}')
while IFS= read -r -d $'\0' l_file; do
	[ -e "$l_file" ] && a_arr+=("$(stat -Lc '%n^%U^%G' "$l_file")") && echo "Adding: $l_file"
done < <(find / \( "${a_path[@]}" \) \( -type f -o -type d \) \( -nouser -o -nogroup \) - print0 2> /dev/null)
while IFS="^" read -r l_fname l_user l_group; do # Test files in the array
	[ "$l_user" = "UNKNOWN" ] && a_nouser+=("$l_fname")
	[ "$l_group" = "UNKNOWN" ] && a_nogroup+=("$l_fname")
done <<< "$(printf '%s\n' "${a_arr[@]}")"
if ! (( ${#a_nouser[@]} > 0 )); then
	l_output="$l_output\n - No unowned files or directories exist on the local filesystem."
else
	l_output2="$l_output2\n - There are \"$(printf '%s' "${#a_nouser[@]}")\" unowned files or directories on the system.\n - The following is a list of unowned files and/or directories:\n$(printf '%s\n' "${a_nouser[@]}")\n - end of list"
fi
if ! (( ${#a_nogroup[@]} > 0 )); then
	l_output="$l_output\n - No ungrouped files or directories exist on the local filesystem."
else
	l_output2="$l_output2\n - There are \"$(printf '%s' "${#a_nogroup[@]}")\" ungrouped files or directories on the system.\n - The following is a list of ungrouped files and/or directories:\n$(printf '%s\n' "${a_nogroup[@]}")\n - end of list"
fi
unset a_path; unset a_arr ; unset a_nouser; unset a_nogroup # Remove arrays
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
detail=$(echo "$detail" | tr '\n' ' ')
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="6.1.13 Ensure SUID and SGID files are reviewed"
echo "$testcase"
detail=""
output=$({
l_output="" l_output2=""
a_arr=(); a_suid=(); a_sgid=() # initialize arrays
# Populate array with files that will possibly fail one of the audits
while read -r l_mpname; do
	while IFS= read -r -d $'\0' l_file; do
		[ -e "$l_file" ] && a_arr+=("$(stat -Lc '%n^%#a' "$l_file")")
	done < <(find "$l_mpname" -xdev -not -path "/run/user/*" -type f \( - perm -2000 -o -perm -4000 \) -print0)
done <<< "$(findmnt -Derno target)"
# Test files in the array
while IFS="^" read -r l_fname l_mode; do
	if [ -f "$l_fname" ]; then
		l_suid_mask="04000"; l_sgid_mask="02000"
		[ $(( $l_mode & $l_suid_mask )) -gt 0 ] && a_suid+=("$l_fname")
		[ $(( $l_mode & $l_sgid_mask )) -gt 0 ] && a_sgid+=("$l_fname")
	fi
done <<< "$(printf '%s\n' "${a_arr[@]}")"
if ! (( ${#a_suid[@]} > 0 )); then
	l_output="$l_output\n - There are no SUID files exist on the system"
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
detail=$(echo "$detail" | tr '\n' ' ')
fi
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="6.2.1 Ensure accounts in /etc/passwd use shadowed passwords"
echo "$testcase"
detail=""
output=$(awk -F: '($2 != "x" ) { print $1 " is not set to shadowed passwords "}' /etc/passwd)
if [[ -z "$output" ]]; then status="PASS"; else status="FAIL" detail="$output"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="6.2.2 Ensure /etc/shadow password fields are not empty"
echo "$testcase"
detail=""
output=$(awk -F: '($2 == "" ) { print $1 " does not have a password "}' /etc/shadow)
if [[ -z "$output" ]]; then status="PASS"; else status="FAIL" detail="$output"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="6.2.3 Ensure all groups in /etc/passwd exist in /etc/group"
echo "$testcase"
detail=""
output=$({
for i in $(cut -s -d: -f4 /etc/passwd | sort -u ); do
	grep -q -P "^.*?:[^:]*:$i:" /etc/group
	if [ $? -ne 0 ]; then
		echo "Group $i is referenced by /etc/passwd but does not exist in /etc/group"
	fi
done
})
if [[ -z "$output" ]]; then status="PASS"; else status="FAIL" detail="$output"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="6.2.4 Ensure shadow group is empty"
echo "$testcase"
detail=""
output1=$(awk -F: '($1=="shadow") {print $NF}' /etc/group)
output2=$(awk -F: -v GID="$(awk -F: '($1=="shadow") {print $3}' /etc/group)" '($4==GID) {print $1}' /etc/passwd)
output="$output1\n$output2"
if [[ -z "$output1" && -z "$output2" ]]; then status="PASS"; else status="FAIL" detail="$output"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="6.2.5 Ensure no duplicate UIDs exist"
echo "$testcase"
detail=""
output=$({
cut -f3 -d":" /etc/passwd | sort -n | uniq -c | while read x ; do
[ -z "$x" ] && break
set - $x
if [ $1 -gt 1 ]; then
	users=$(awk -F: '($3 == n) { print $1 }' n=$2 /etc/passwd | xargs)
	echo "Duplicate UID ($2): $users"
fi
done
})
if [[ -z "$output" ]]; then status="PASS"; else status="FAIL" detail="$output"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="6.2.6 Ensure no duplicate GIDs exist"
echo "$testcase"
detail=""
output=$({
cut -d: -f3 /etc/group | sort | uniq -d | while read x ; do
	echo "Duplicate GID ($x) in /etc/group"
done
})
if [[ -z "$output" ]]; then status="PASS"; else status="FAIL" detail="$output"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="6.2.7 Ensure no duplicate user names exist"
echo "$testcase"
detail=""
output=$({
cut -d: -f1 /etc/passwd | sort | uniq -d | while read -r x; do
	echo "Duplicate login name $x in /etc/passwd"
done
})
if [[ -z "$output" ]]; then status="PASS"; else status="FAIL" detail="$output"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="6.2.8 Ensure no duplicate group names exist"
echo "$testcase"
detail=""
output=$({
cut -d: -f1 /etc/group | sort | uniq -d | while read -r x; do
	echo "Duplicate group name $x in /etc/group"
done
})
if [[ -z "$output" ]]; then status="PASS"; else status="FAIL" detail="$output"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="6.2.9 Ensure root PATH Integrity"
echo "$testcase"
detail=""

output=$({
	RPCV="$(sudo -Hiu root env | grep '^PATH' | cut -d= -f2)"
	echo "$RPCV" | grep -q "::" && echo "root's path contains a empty directory (::)"
	echo "$RPCV" | grep -q ":$" && echo "root's path contains a trailing (:)"
	for x in $(echo "$RPCV" | tr ":" " "); do
	if [ -d "$x" ]; then
		ls -ldH "$x" | awk '$9 == "." {print "PATH contains current working directory (.)"}
		$3 != "root" {print $9, "is not owned by root"}
		substr($1,6,1) != "-" {print $9, "is group writable"}
		substr($1,9,1) != "-" {print $9, "is world writable"}'
	else
		echo "$x is not a directory"
	fi
	done
})

if [[ -z "$output" ]]; then status="PASS"; else status="FAIL" detail="$output"; fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="6.2.10 Ensure root is the only UID 0 account"
echo "$testcase"
detail=""

output=$({
	awk -F: '($3 == 0) { print $1 }' /etc/passwd
})
if [[ $output == "root" ]]; then status="PASS"; else status="FAIL" detail="$output"; fi

detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file


testcase="6.2.11 Ensure local interactive user home directories are configured"
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
[ "$l_asize " -gt "10000" ] && echo -e "\n ** INFO **\n - \"$l_asize\" Local interactive users found on the system\n - This may be a long running check\n"
while read -r l_user l_home; do
	if [ -d "$l_home" ]; then
		l_mask='0027'
		l_max="$( printf '%o' $(( 0777 & ~$l_mask)) )"
		while read -r l_own l_mode; do
			[ "$l_user" != "$l_own" ] && l_hoout2="$l_hoout2\n - User: \"$l_user\" Home \"$l_home\" is owned by: \"$l_own\""
			if [ $(( $l_mode & $l_mask )) -gt 0 ]; then
				l_haout2="$l_haout2\n - User: \"$l_user\" Home \"$l_home\" is mode: \"$l_mode\" should be mode: \"$l_max\" or more restrictive"
			fi
		done <<< "$(stat -Lc '%U %#a' "$l_home")"
	else
		l_heout2="$l_heout2\n - User: \"$l_user\" Home \"$l_home\" Doesn't exist"
	fi
done <<< "$(printf '%s\n' "${a_uarr[@]}")"
[ -z "$l_heout2" ] && l_output="$l_output\n - home directories exist" || l_output2="$l_output2$l_heout2"
[ -z "$l_hoout2" ] && l_output="$l_output\n - own their home directory" || l_output2="$l_output2$l_hoout2"
[ -z "$l_haout2" ] && l_output="$l_output\n - home directories are mode: \"$l_max\" or more restrictive" || l_output2="$l_output2$l_haout2"
[ -n "$l_output" ] && l_output=" - All local interactive users:$l_output"
if [ -z "$l_output2" ]; then # If l_output2 is empty, we pass
	echo -e "\n- Audit Result:\n ** PASS **\n - * Correctly configured * :\n$l_output"
else
	echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :\n$l_output2"
	[ -n "$l_output" ] && echo -e "\n- * Correctly configured * :\n$l_output"
fi
})
if [[ "$output" =~ '** PASS **' ]]; then
	status="PASS"
else
	status="FAIL"
	detail="$output"
fi
detail=$(echo "$detail" | tr '\n' ' ')
echo "$output"
detail=$(echo "$detail" | tr '\n' ' ')
echo "$thehostname,$testcase,$status,$detail" >> $result_file

testcase="6.2.12 Ensure local interactive user dot files access is configured"
echo "$testcase"
detail=""

output=$({
l_output="" l_output2="" l_output3="" l_output4=""
l_bf="" l_df="" l_nf="" l_hf=""
l_valid_shells="^($( awk -F\/ '$NF != "nologin" {print}' /etc/shells | sed -rn '/^\//{s,/,\\\\/,g;p}' | paste -s -d '|' - ))$"
unset a_uarr && a_uarr=() # Clear and initialize array
while read -r l_epu l_eph; do # Populate array with users and user home location
	[[ -n "$l_epu" && -n "$l_eph" ]] && a_uarr+=("$l_epu $l_eph")
done <<< "$(awk -v pat="$l_valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' /etc/passwd)"
l_asize="${#a_uarr[@]}" # Here if we want to look at number of users before proceeding
l_maxsize="1000" # Maximun number of local interactive users before warning (Default 1,000)
[ "$l_asize " -gt "$l_maxsize" ] && echo -e "\n ** INFO **\n - \"$l_asize\" Local interactive users found on the system\n - This may be a long running check\n"
file_access_chk()
{
	l_facout2=""
	l_max="$( printf '%o' $(( 0777 & ~$l_mask)) )"
	if [ $(( $l_mode & $l_mask )) -gt 0 ]; then
		l_facout2="$l_facout2\n - File: \"$l_hdfile\" is mode: \"$l_mode\" and should be mode: \"$l_max\" or more restrictive"
	fi
	if [[ ! "$l_owner" =~ ($l_user) ]]; then
		l_facout2="$l_facout2\n - File: \"$l_hdfile\" owned by: \"$l_owner\" and should be owned by \"${l_user//|/ or }\""
	fi
	if [[ ! "$l_gowner" =~ ($l_group) ]]; then
		l_facout2="$l_facout2\n - File: \"$l_hdfile\" group owned by: \"$l_gowner\" and should be group owned by \"${l_group//|/ or }\""
	fi
}
while read -r l_user l_home; do
	l_fe="" l_nout2="" l_nout3="" l_dfout2="" l_hdout2="" l_bhout2=""
	if [ -d "$l_home" ]; then
		l_group="$(id -gn "$l_user" | xargs)"
		l_group="${l_group// /|}"
		while IFS= read -r -d $'\0' l_hdfile; do
			while read -r l_mode l_owner l_gowner; do
				case "$(basename "$l_hdfile")" in
				.forward | .rhost )
					l_fe="Y" && l_bf="Y"
					l_dfout2="$l_dfout2\n - File: \"$l_hdfile\" exists" ;;
				.netrc )
					l_mask='0177'
					file_access_chk
					if [ -n "$l_facout2" ]; then
					l_fe="Y" && l_nf="Y"
					l_nout2="$l_facout2"
					else
					l_nout3=" - File: \"$l_hdfile\" exists"
					fi ;;
				.bash_history )
					l_mask='0177'
					file_access_chk
					if [ -n "$l_facout2" ]; then
					l_fe="Y" && l_hf="Y"
					l_bhout2="$l_facout2"
					fi ;;
				* )
					l_mask='0133'
					file_access_chk
					if [ -n "$l_facout2" ]; then
					l_fe="Y" && l_df="Y"
					l_hdout2="$l_facout2"
					fi ;;
				esac
			done <<< "$(stat -Lc '%#a %U %G' "$l_hdfile")"
		done < <(find "$l_home" -xdev -type f -name '.*' -print0)
	fi
	if [ "$l_fe" = "Y" ]; then
		l_output2="$l_output2\n - User: \"$l_user\" Home Directory: \"$l_home\""
		[ -n "$l_dfout2" ] && l_output2="$l_output2$l_dfout2"
		[ -n "$l_nout2" ] && l_output2="$l_output2$l_nout2"
		[ -n "$l_bhout2" ] && l_output2="$l_output2$l_bhout2"
		[ -n "$l_hdout2" ] && l_output2="$l_output2$l_hdout2"
	fi
	[ -n "$l_nout3" ] && l_output3="$l_output3\n - User: \"$l_user\" Home Directory: \"$l_home\"\n$l_nout3"
done <<< "$(printf '%s\n' "${a_uarr[@]}")"
unset a_uarr # Remove array
[ -n "$l_output3" ] && l_output3=" - ** Warning **\n - \".netrc\" files should be removed unless deemed necessary\n and in accordance with local site policy:$l_output3"
[ -z "$l_bf" ] && l_output="$l_output\n - \".forward\" or \".rhost\" files"
[ -z "$l_nf" ] && l_output="$l_output\n - \".netrc\" files with incorrect access configured"
[ -z "$l_hf" ] && l_output="$l_output\n - \".bash_history\" files with incorrect access configured"
[ -z "$l_df" ] && l_output="$l_output\n - \"dot\" files with incorrect access configured"
[ -n "$l_output" ] && l_output=" - No local interactive users home directories contain:$l_output"
echo -e "$l_output4"
if [ -z "$l_output2" ]; then # If l_output2 is empty, we pass
	echo -e "\n- Audit Result:\n ** PASS **\n - * Correctly configured * :\n$l_output\n"
	echo -e "$l_output3\n"
else
	echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :\n$l_output2\n"
	echo -e "$l_output3\n"
	[ -n "$l_output" ] && echo -e "- * Correctly configured * :\n$l_output\n"
fi
})




echo "CIS_Ubuntu_Linux_20.04_LTS_v2.0.1_L1_Server.audit from CIS Ubuntu Linux 20.04 LTS Benchmark v2.0.1"