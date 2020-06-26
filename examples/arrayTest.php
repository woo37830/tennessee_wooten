<?php
 function array_adder($v1, $v2)
 {
    $result = array();
    for(  $i=0;$i<min(count($v1),count($v2)); $i++)
    {
       $result[$i] = $v1[$i] + $v2[$i];
    }
    return $result;
 }
 $v1 = array(1,2,3,4,5,6,7,8,9,10);
 $v2 = array(10,10,10,10,10,10,10,10,10,10);
 $v3 = array_adder($v1, $v2);
 var_dump($v3);
?>
