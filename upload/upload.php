<?php
	$data = trim($_POST['data']);
	$type = $_POST['type'];
	exec("perl upload.pl $data $type", $out);
	if ($out[0] == "OK"){
		echo "Success";
	}else{
		echo "Failed";
	}
?>