<?php
// Create connection
$dbname = 'askjane_users_db';
$link = new mysqli('jwooten37830.com','woo','random1', $dbname) or die('can not connect');

/* check connection */
if ($link->connect_errno) {
    printf("Connect failed: %s\n", $link->connect_error);
    exit();
}


$query = "select poc_email, name_poc from $dbname.leads WHERE ip_address != '127.0.0.1' ";
$result = $link->query($query);
if( !$result) {
    die('Invalid query: ' . mysql_error());
    }
if( $result !== false ) {
   printf("Select returned %d rows.\n", $result->num_rows);
   $result->data_seek(0);
while($row=$result->fetch_assoc())
    {
            $email=$row["poc_email"];
            $to = $email;
            $name = $row["name_poc"];
            #$to = 'jwooten@shoulderscorp.com';
            #$name = 'John Wooten';
            $subject = "ICD10 special offer";
            $body = "Hello $name,\n\n\tJust returned from HIMSS in Orlando\n"
            . "\twhere everyone was complaining about how hard it is to get the correct\n"
            . "\tICD10 codes!  DmeHelp has been reorganized and improved, \n"
            . "\toffering quick access to ICD10 billable codes,  using natural language, the ICD9 codes, \n"
            . "\tenterals, and natural language access to DME regulations.\n"
            . "\n\tWe have moved to new and faster servers, lowering our costs\n"
            . "\talong the way and are able to offer you a fantastic value of\n"
            . "\t" . '\$' . "9.95 per month because of this!\n"
            . "\tYou can see our site at http://dmehelp.com, and sign up there also.\n"
            . "\n\tIf you have questions call 423-263-0434\n"
            . "\n\tLooking forward to hearing from you,\n"
            . "\n\tJohn Wooten, CEO AreteQ Inc.,\n"
            . "\tProviding DMEHELP.com for DME suppliers\n";
            $headers = 'From: cwilson@areteq.com' . "\r\n" ;
            $headers .= 'Reply-To: cwilson@areteq.com' . "\r\n";
            #mail($to, $subject, $body, $headers);
            $cmd = "echo \"$body\" | /usr/bin/mail -s \"$subject\" $to";
            shell_exec($cmd);
            echo "To=$to, name= $name\n";
    }
} else {
    echo "Error: " . mysql_error();
    die;
    }
/* free result set */
mysqli_free_result($result);

/* close connection */
mysqli_close($link);
?>
