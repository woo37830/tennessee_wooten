#!/bin/sh -


#########################
# Weekly tidy-up script #
#########################


host=$(hostname -s)
echo "Subject: $host - local weekly run output"


# list the subdirectories to be considered, in this case
#   /var/log/httpd and /var/log/named
for logtype in httpd named
do


  echo ""
  echo -n "Rotating type $logtype log files:"


  if [ -d /var/log/$logtype ]; then
    cd /var/log/$logtype
    for log in *.log
    do
      echo -n " $log"
      if [ -f "${log}.3.gz" ]; then mv -f "${log}.3.gz" "${log}.4.gz"; fi
      if [ -f "${log}.2.gz" ]; then mv -f "${log}.2.gz" "${log}.3.gz"; fi
      if [ -f "${log}.1.gz" ]; then mv -f "${log}.1.gz" "${log}.2.gz"; fi
      if [ -f "${log}.0.gz" ]; then mv -f "${log}.0.gz" "${log}.1.gz"; fi


      if [ -f "${log}" ]; then
        mv -f "${log}" "${log}.0"
        /usr/bin/gzip -9 "${log}.0"
      fi
      touch "$log"
    done


    case $logtype in
      httpd) apachectl graceful;;
      named) ndc restart;;
      *);;
    esac


  fi


done


echo ""
echo "Complete"