:
# execute as testloop name1 name2 name3
while test $1 
do
	grep $1 $HOME/.phone.list
	shift
done
