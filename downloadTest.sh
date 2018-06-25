# UNIX timestamp concatenated with nanoseconds
T="$(date +%s)"

# Do some work here
BYTES=1499244
sftp -b download.cmds woo@jwooten37830.com 

# Time interval in nanoseconds
T="$(($(date +%s)-T))"
# Seconds
S="$((T/1000000000))"
# Milliseconds
M="$((T/1000000))"

echo "Time : ${T} to download $BYTES bytes"
printf "Pretty format: %02d:%02d:%02d:%02d.%03d\n" "$((S/86400))" "$((S/3600%24))" "$((S/60%60))" "$((S%60))" "${M}"
echo "Download speed: $((BYTES/T)) bytes/sec"

echo 'All Done'

