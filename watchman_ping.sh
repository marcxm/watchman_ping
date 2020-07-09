# Watchman - port ping module
# by marc_smith@gmx.com | github.com/marcxm

#!/bin/bash

usage() { echo "Usage: $0 [-i 192.168.0.20] [-n myhost] [-s interval] [-m mail@fqdn.com]" 1>&2; exit 1; }

while getopts ":i:n:s:m:" o; do
    case "${o}" in
        i)
            i=${OPTARG}
            ;;
        n)
            n=${OPTARG}
            ;;
        s)                                                                                                                                                     
            s=${OPTARG}                                                                                                                                        
            ;;
        m)                                                                                                                                                     
            m=${OPTARG}                                                                                                                                        
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${i}" ] || [ -z "${n}" ] || [ -z "${s}" ] || [ -z "${m}" ]; then
    usage
fi

#echo $i " " $n " " $s " " $m " "

while [ true ]; do
  sleep $s
  fping -r 1 $i > /dev/null
  if [ $? -eq 1 ]; then
    printf "`date`: $n with IP: $i is DOWN.\n" >> /root/watchman_ping_history.log                                                                           
      if test -f /root/$n"_down"; then
        echo "not sending another mail."
      else
        echo `date` > mail
        echo "$i - $n is DOWN!" | mutt -s "date - $i - $n is DOWN!" $m
        touch /root/$n"_down"
      fi                                                                                                          
    else
      if test -f /root/$n"_down"; then
        rm /root/$n"_down"                                                                                                                             
        printf "`date`: $n with IP: $i is UP AGAIN.\n" >> /root/watchman_ping_history.log
        echo "$i - $n is UP AGAIN!" | mutt -s "date - $i - $n is UP AGAIN!" $m
      else                                                                                                                              
      printf "`date`: $n with IP: $i is UP.\n" >> /root/watchman_ping_history.log                                                                             
      fi
  fi
done
