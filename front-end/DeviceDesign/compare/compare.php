<?php
	$bricks = trim($_POST['brick']);
	$funcs = strtolower(trim($_POST['funcs']));
	$weight = trim($_POST['weight']);
	//pass data to the back-end
	exec("perl score.pl $bricks $funcs $weight", $out);
	$effect = $out[0];
	$score = $out[1];
	$opt = "";
	for ($i = 2; $i < count($out); ++$i){
		$array = explode("\t", $out[$i]);
		//whether having optimal id
		if (count($array) > 1){
			$opt .= $array[1];
		}else{
			$opt .= "no result";
		}
		$opt .= "@";
	}
	$opt = substr($opt, 0, count($opt) - 2);
	if ($effect == 0){
		$score = "Uncomplete";
	}
	echo $score.'*'.$opt;
?>