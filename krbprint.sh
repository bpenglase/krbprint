#!/bin/bash
##################
# Kerberos printing script for PCT
# Used in combination with LaunchD to monitor the printers.conf
# and when a user adds a printer, this modifies the auth requirement
# Created By: Brandon Penglase
# Creation Date: 09/17/09
# Modified On: 07/30/12
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
##################
DATE=`date "+%m%d%y-%H%M%S"`

# Check to see if it's set for user
if grep -q "username,password" /etc/cups/printers.conf; then
        launchctl stop org.cups.cupsd
        sed -i bak -e 's/username,password/negotiate/g' /etc/cups/printers.conf 
        launchctl start org.cups.cupsd
        echo ${DATE} "- Modified printers.conf" >> /var/log/krbprint.log
else
	echo ${DATE} "- No Modifications made." >> /var/log/krbprint.log
fi
