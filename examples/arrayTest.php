<?php
/********************
  Add the elements at position i in one array to the element in the same position in the second array
********************/
function array_adder($v1, $v2, $offset=0)
{
   $result = array();
   $size = max(count($v1),count($v2));
   $short = min(count($v1), count($v2));
   if( $offset != 0 ) {
     for( $i=0; $i<$offset; $i++ ) {
       $result[$i] = 0;
     }
   }
   if( $size == $short ) {
     for(  $i=$offset;$i<$size; $i++)
     {
        $result[$i] = $v1[$i] + $v2[$i];
     }
   } else {
     for( $i=$offset;$i<$short; $i++) {
       $result[$i] = $v1[$i] + $v2[$i];
     }
     for( $i=$short; $i<$size; $i++ ) {
       if( count($v1) < count($v2) ) {
         $result[$i] = $v2[$i];
       } else {
         $result[$i] = $v1[$i];
       }
     }
   }
   return $result;
};
 $v1 = array(1,2,3,4,5,6,7,8,9,10);
 $v2 = array(10,10,10,10,10,10,10,10,10,10);
 $v3 = array_adder($v1, $v2);
 var_dump($v3);
 $v4 = array(1,2,3);
 $v5 = array_adder($v1,$v4,3);
 var_dump($v5);
?>
