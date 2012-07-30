krbprint
========

Changes CUPS Authentication on a Mac OS X system from requiring a username and password, to using kerberos authentication. 

Installation
========
1. Place edu.pct.krbprint.plist in /Library/LaunchDaemons
2. Change ownership of this file to root:wheel (In terminal: sudo chown root:wheel /Library/LaunchDaemons/edu.pct.krbprint.plist)
3. Place krbprint.sh in /usr/local/bin (If you pick a different location, you need to modify the above PList file)
4. Chance ownership of this file to root:wheel (In terminal: sudo chown root:wheel /usr/local/bin/krbprint.sh)
5. If this is a fresh system, and no /etc/cups/printers.conf file exists, create it before loading the PList (In Terminal: sudo touch /etc/cups/printers.conf)
6. Load the PList into LaunchD (In Terminal: sudo launchctl load /Library/LaunchDaemons/edu.pct.krbprint.plist, or reboot).

Notes
========
This will always remove any entries that need username and password auth, and replace it with negotiation auth (Kerberos). 
At the current time, this script does not allow these options to be mixed. 
If you need both, do not use this script. 

