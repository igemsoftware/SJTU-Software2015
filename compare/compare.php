<?php
	$bricks = trim($_POST['brick']);
	$funcs = trim($_POST['funcs']);
	exec("perl score.pl $bricks $funcs", $out);
	echo $out[0];
	//for ($i = 0; $i < count($out); ++$i){
	//	echo $out[$i];
	//}
?>