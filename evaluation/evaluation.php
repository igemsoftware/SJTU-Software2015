<?php
	$type = $_POST['type'];
	$function = $_POST['userFunction'];
	$id = $_POST['id'];
	if ($id == ""){
		exec("perl advice_v2.pl \"$id\" $function $type", $out);
	}else{
		exec("perl advice_v2.pl $id $function $type", $out);
	}
	$result = "";
	$number = count($out);
	//echo $out[0];	
	for ($i = 0; $i < $number; ++$i){
		echo $out[$i];
	}
	//echo count($out);
?>