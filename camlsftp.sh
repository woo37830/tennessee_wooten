#!/usr/local/bin/expect
#
# ssh to camlsftp
#
spawn sftp -oPort=53950 camlsftp@camlsftp.eastus2.cloudapp.azure.com
expect "password:"
send "bUwSMTvBY9HJ5VfwWpgu\n";
interact
