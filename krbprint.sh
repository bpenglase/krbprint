#!/bin/bash
##################
# Kerberos printing script for PCT
# Used in combination with LaunchD to monitor the printers.conf
# and when a user adds a printer, this modifies the auth requirement
# Created By: Brandon Penglase
# Creation Date: 09/17/09
# Modified On: 09/12/12
# Modified By: Brandon Penglase
# ChangeLog:
#	0.1: Inital Release
#	0.2: Updated to look for the smb symlink, if it's not there, create it. 
#	0.3: Updated to use sed file inline editing, instead of creating a new file
#		and having to move that file back into place. 
#	0.4: Updated to remove ksmbprintd references, and use Apple's built in
#		method. This involves removing the check for the symlink, and instead
#		of deleting the AuthInfoRequired line, replace it with negotiate.
#		Also change the check from AuthInfoRequired (as it will be needed
#		to username,password, as thats what we need to replace). 
#	0.5: Added support for printers via MCX
#		Code used from http://www.unix.com/302305670-post.html
#   0.6: Corrected Negotiate, should be a lower case n, not capital. 
##################
DATE=`date "+%m%d%y-%H%M%S"`

# Check to see how many MCX printers we have
MCX=`grep -c mcx /etc/cups/printers.conf`

# Check to see if the user added it themselves
if grep -q "username,password" /etc/cups/printers.conf; then
        launchctl stop org.cups.cupsd
        sed -i bak -e 's/username,password/negotiate/g' /etc/cups/printers.conf 
        launchctl start org.cups.cupsd
        echo ${DATE} "- Modified printers.conf" >> /var/log/krbprint.log
	CHANGED=1
fi

if [ ${MCX} -gt 0 ]; then
        launchctl stop org.cups.cupsd
#	for i in $(eval echo {0..`expr $MCX - 1`})
#	do
sed -i bak '
/<Printer mcx_0>/,/<\/PRINTER>/{
	/Info/ { 
		n
		/AuthInfoRequired/ !{
			i\
			AuthInfoRequired negotiate
		}
	}
}' /etc/cups/printers.conf
#	done
	launchctl start org.cups.cupsd
	echo ${DATE} "- Modified MCX printers.conf" >> /var/log/krbprint.log
	CHANGED=1
fi

if [ ! ${CHANGED} == 1 ]; then
	echo ${DATE} "- No Modifications made." >> /var/log/krbprint.log
fi
