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
  nc -w 4 -vz $i 22 > /dev/null
  if [ $? -eq 1 ]; then
    printf "`date`: $n IP: $i is DOWN.\n" >> ./watchman_ping_history.log                                                                           
      if test -f ./$n"_down"; then
        echo "not sending another mail."
      else
        echo `date` > mail
        echo "$i is DOWN!" | mutt -s "$i is DOWN!" $m
        touch ./$n"_down"
      fi                                                                                                          
    else
      if test -f ./$n"_down"; then
        rm ./$n"_down"                                                                                                                             
        printf "`date`: $n with IP: $i is UP AGAIN.\n" >> ./watchman_ping_history.log
        echo "$i is DOWN!" | mutt -s "$i is UP AGAIN!" $m
      else                                                                                                                              
      printf "`date`: $n with IP: $i is UP.\n" >> ./watchman_ping_history.log                                                                             
      fi
  fi
done
