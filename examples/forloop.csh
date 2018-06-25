#! /bin/csh
# execute as testloop name1 name2 name3
foreach i  ($argv)
	grep $i $HOME/.phone.list
end
