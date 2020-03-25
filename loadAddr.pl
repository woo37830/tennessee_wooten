#!/usr/bin/perl

open(ADDR,"/Users/woo/.addressbook") || die("Can't open .addressbook\n");
open(NEW,">/Users/woo/Library/Addresses/Example.addresses/AddressBook.table") || die("Can't create Addressbook.table\n");

print NEW "\"Date Last Modified\" = \"Nov 11 12:10\";\n";
print NEW "\"Address Book Shelf\" = \"Example.addresses\\000Wooten, John\";\n";
print NEW "\"Address Book Height\" = 454;\n";
print NEW "\"Address Book Columns\' = 2;\n";
print NEW "\"Sort Method\" = \"Groups Last\";\n";
print NEW "Contents = {\n";
while(<ADDR>)	{
	chop;
	@fields = split(/\s/);
	$nick = $fields[0];
	$email = $fields[$#fields];
	$name = $fields[1] . " " . $fields[2];
	$name .= " " . $fields[3] if $#fields > 3;
	print NEW "$nick = {\n";
	print NEW "   \"Full Name\" = \"$name\";\n";
	print NEW "   EMail = \"$email\";\n";
	print NEW "};\n";
	}
	
	print NEW "};\n";
print "\nAll Done\n";
close (ADDR,NEW);
