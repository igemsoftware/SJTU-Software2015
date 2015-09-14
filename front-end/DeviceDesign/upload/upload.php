<?php
	$data = trim($_POST['data']);
	$type = $_POST['type'];
	//pass data to the back-end
	exec("perl upload.pl $data $type", $out);
	if ($out[0] == "OK"){
		echo "Success";
	}else{
		echo "Failed";
	}
?>