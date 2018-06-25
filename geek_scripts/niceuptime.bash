uptime | awk '{printf "up : " $3 " " $4 " " $5 " " }'
top -l 1 | awk '/PhysMem/ {printf "RAM : " $8 ", "}' 
top -l 2 | awk '/CPU usage/ && NR > 5 {print $6, $7, $8, $9="user", $10, $11="sys", $12, $13}'
echo
