<?php
	$type = $_POST['type'];
	$function = strtolower(trim($_POST['userFunction']));
	$id = $_POST['id'];
	//pass data to back-end
	if ($id == ""){
		exec("perl advice_v4.pl \"$id\" $function $type", $out);
	}else{
		exec("perl advice_v4.pl $id $function $type", $out);
	}
	$result = "";
	$number = count($out);

	if ($number == 1){
		$result = "No results";
	}else{
		$out = array_slice($out, 0, $number - 1);
		$dictionary = array();
		//radio html data
		$result = "<div class = \"idRadio\">";
		for ($i = 0; $i < $number - 1; ++$i){
			$each = explode("|", $out[$i]);
			$dictionary[$each[0]] = $each[1];
		}
		//sort the data according to the score
		arsort($dictionary);
		$dictionary = array_slice($dictionary, 0, 5);
		foreach ($dictionary as $key => $value) {
			$result .= "<label class=\"am-radio\"><input type=\"radio\" name=\"radio1\" value=\"".$key."\" data-am-ucheck>".$key."&nbsp".$value."</label>";
		}
		$result .= "<label class=\"am-radio\"><input type=\"radio\" name=\"radio1\" value=\"other\" data-am-ucheck>other</label>";
		$result .= "</div>";
	}
	echo $result;
?>