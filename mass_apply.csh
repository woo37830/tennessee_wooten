#! /bin/csh
# execute as testloop name1 name2 name3
cd /home/apply
foreach i  ($argv)
	activate $i
end
cd
