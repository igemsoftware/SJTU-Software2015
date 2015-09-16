<?php
	$type = $_POST['usertype'];
	$id = $_POST['userid'];
	exec("perl judge.pl $id $type", $out);
	echo $out[0]
?>