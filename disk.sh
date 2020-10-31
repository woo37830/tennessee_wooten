if [ "$HOSTNAME" == "woo-pro.local" ]; then
  df | awk '/dev\/disk1s2/ && NF > 1 {print $5}' | sed 's/\%//'
else
  df | awk '/dev\/disk1s1/ && NF > 1 {print $5}' | sed 's/\%//'
fi
