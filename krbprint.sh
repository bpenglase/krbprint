#!/bin/bash
##################
# Kerberos printing script for PCT
# Used in combination with LaunchD to monitor the printers.conf
# and when a user adds a printer, this removes the auth requirement
# Created By: Brandon Penglase
# Creation Date: 09/17/09
# Modified On:
# Modified By:
# ChangeLog:
#	0.1: Inital Release
##################
DATE=`date "+%m%d%y-%H%M%S"`

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
