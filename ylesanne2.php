<?php

$array = array();
for ($i = 1; $i <= 30; $i++) {
    $array[$i] = ($i%3 == 0 ? 'foo' : '') . ($i%5 == 0 ? 'bar' : '');
    $array[$i] = $array[$i] == '' ? $i : $array[$i];
}

foreach( $array as $key => $value ) {
    echo $key."\t=>\t".$value."\n";
}
