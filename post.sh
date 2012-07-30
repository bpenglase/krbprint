#!/bin/bash
# If /etc/cups/printers.conf does not exist, create it and give it 
# proper permissions/ownership
if [ ! -e /etc/cups/printers.conf ]; then
	touch /etc/cups/printers.conf
	chown root:_lp /etc/cups/printers.conf
	chmod 600 /etc/cups/printers.conf
fi

# If krbprint.sh exists, make sure ownership and permissions are correct
if [ -e /usr/local/bin/krbprint.sh ]; then
	chown root:wheel /usr/local/bin/krbprint.sh
	chmod 666 /usr/local/bin/krbprint.sh
fi

# If the LaunchD plist exists, make sure the ownership is correct
# as LaunchD is perticular about it, then load it
if [ -e /Library/LaunchDaemons/edu.pct.krbprint.plist ]; then
	chown root:wheel /Library/LaunchDaemons/edu.pct.krbprint.plist
	/bin/launchctl load /Library/LaunchDaemons/edu.pct.krbprint.plist
fi
	
