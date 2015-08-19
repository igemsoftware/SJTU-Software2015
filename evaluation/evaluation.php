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
	if ($number == 1){
		$result = "No results";
	}else{
		$result = "<div class = \"idRadio\">";
		for ($i = 0; $i < $number - 1; ++$i){
			if ($i == 0){
				$result .= "<label class=\"am-radio\"><input type=\"radio\" name=\"radio1\" value=\"\" data-am-ucheck checked>".$out[$i]."</label>";
			}else{
				$result .= "<label class=\"am-radio\"><input type=\"radio\" name=\"radio1\" value=\"\" data-am-ucheck>".$out[$i]."</label>";
			}
		}
	}
	echo $result;
?>