<?php
	$bricks = trim($_POST['brick']);
	$funcs = strtolower(trim($_POST['funcs']));
	$weight = trim($_POST['weight']);
	//pass data to the back-end
	exec("perl score.pl $bricks $funcs $weight", $out);
	$effect = $out[0];
	$seq = $out[1];
	$score = $out[2];
	$opt = "";
	for ($i = 3; $i < count($out); ++$i){
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
	}else if ($seq == 0){
		$score = "Wrong Sequence";
	}
	echo $score.'*'.$opt;
?>