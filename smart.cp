find src -exec find dest -newer {} -type f -print \; | sort | uniq |\
while read file; do [ -f dest/`basename $file` ] && cp $file dest; done

