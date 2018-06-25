:
# execute as testloop name1 name2 name3
for i # in "$@"
do
	grep $i $HOME/.phone.list
done
