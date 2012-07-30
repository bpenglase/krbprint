#!/bin/bash
##################
# Kerberos printing script for PCT
# Used in combination with LaunchD to monitor the printers.conf
# and when a user adds a printer, this removes the auth requirement
# Created By: Brandon Penglase
# Creation Date: 09/17/09
# Modified On: 10/07/10
# Modified By: Brandon Penglase
# ChangeLog:
#	0.1: Inital Release
#	0.2: Updated to look for the smb symlink, if it's not there, create it. 
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
	if [ ! -d /etc/cups/confbaks ]; then
		mkdir /etc/cups/confbaks
	fi
	sed /AuthInfoRequired/d /etc/cups/printers.conf > /tmp/printers.conf
	mv /etc/cups/printers.conf /etc/cups/confbaks/printers.conf-${DATE}
	mv /tmp/printers.conf /etc/cups/printers.conf
	chown root:_lp /etc/cups/printers.conf
	chmod 600 /etc/cups/printers.conf 	
	launchctl stop org.cups.cupsd
	launchctl start org.cups.cupsd
	echo ${DATE} "- Modified printers.conf" >> /var/log/krbprint.log
else
	echo ${DATE} "- No Modifications made." >> /var/log/krbprint.log
fi
