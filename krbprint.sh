#!/bin/bash
##################
# Kerberos printing script for PCT
# Used in combination with LaunchD to monitor the printers.conf
# and when a user adds a printer, this removes the auth requirement
# Created By: Brandon Penglase
# Creation Date: 09/17/09
# Modified On: 10/19/10
# Modified By: Brandon Penglase
# ChangeLog:
#	0.1: Inital Release
#	0.2: Updated to look for the smb symlink, if it's not there, create it. 
#	0.3: Updated to use sed file inline editing, instead of creating a new file
#		and having to move that file back into place. 
##################
DATE=`date "+%m%d%y-%H%M%S"`

# Check to see if /usr/libexec/cups/backend/smb is a symlink, if not, correct it.
if [ ! -L /usr/libexec/cups/backend/smb ]; then
	# It isn't, so fix that
	echo ${DATE} "- Fixed SMB Symlink" >> /var/log/krbprint.log
	mv /usr/libexec/cups/backend/smb /usr/libexec/cups/backend/smb-orig
	ln -s /usr/local/bin/ksmbprintspool /usr/libexec/cups/backend/smb
fi

if grep -q "AuthInfoRequired" /etc/cups/printers.conf; then
        launchctl stop org.cups.cupsd
        sed -i bak -e '/AuthInfoRequired/d' /etc/cups/printers.conf 
        launchctl start org.cups.cupsd
        echo ${DATE} "- Modified printers.conf" >> /var/log/krbprint.log
else
	echo ${DATE} "- No Modifications made." >> /var/log/krbprint.log
fi
