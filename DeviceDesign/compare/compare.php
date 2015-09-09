<?php
	$bricks = trim($_POST['brick']);
	$funcs = strtolower(trim($_POST['funcs']));
	exec("perl score.pl $bricks $funcs", $out);	
	$score = $out[0];
	$opt = "";
	for ($i = 1; $i < count($out); ++$i){
		$array = explode("\t", $out[$i]);
		if (count($array) > 1){
			$opt .= $array[1];
		}else{
			$opt .= "no result";
		}
		$opt .= "@";
	}
	$opt = substr($opt, 0, count($opt) - 2);
	echo $score.'*'.$opt;
?>