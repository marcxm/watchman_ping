## Watchman - port ping module

This is the first module for monitoring solution called "Watchman". 
It's simple, portable [only using standard bash toolkit + netcat] and uses mutt to send notification mails. 

# How it works:

Watchman ping module allows for simple port monitoring [currently SSH / 22] of the remote host, by using netcat command.
It does it in given interval [min. 1s, but practical value would be 5-60 to decrease system load] and if it detects that port is not available, 
it sends notification e-mail to given mail address. It does so only once [hence it is not trashing the inbox], and if it detects that port is available
again [host is UP AGAIN] it sends notification that host is UP AGAIN, then it continues to log "UP" only locally. 
It uses log files and status files [used as flags]. Log file watchman_ping_history.log logs all the data related to given host uptime history.
$host_down status file is used to mark that given host is currently DOWN, while "mail" file is there to register when last notification mail was sent.

# Configuration:

1. configure mutt in .muttrc
2. copy .muttrc to /root/.muttrc
3. run ./watchman_ping.sh [-i 192.168.0.20] [-n myhost] [-s interval] [-m mail@fqdn.com]
