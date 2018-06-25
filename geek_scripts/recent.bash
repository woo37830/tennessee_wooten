#!/bin/bash
touch -t `date +%m%d0000` ~/Documents/Scripts/GeekTool/today.txt
find / -type f -newer ~/Documents/Scripts/GeekTool/today.txt > ~/Documents/Scripts/GeekTool/recent_files.txt
cat ~/Documents/Scripts/GeekTool/recent_files.txt | grep Documents
cat ~/Documents/Scripts/GeekTool/recent_files.txt | grep -v Documents


