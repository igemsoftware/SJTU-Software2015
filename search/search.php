<?php
	$weight = $_POST['weightType'];
	$keyword = $_POST['searchKeyWord'];
	$type = trim($_POST['searchType']);
	$weightList = $_POST['weightL'];
	if ($weight == 0){
		exec("perl count_v2.pl $keyword $type", $out);
	}else{
		exec("perl hcount.pl $keyword $type $weightList", $out);
	}
	$result = "";
	$number = count($out);
	if ($number <= 3){
		$result = "<tr><td>No Results</td></tr>";
	}else{
		for ($i = 2; $i < $number - 1; ++$i){
			$resArray = explode("|", $out[$i]);
			$color = "white";
			$score = intval($resArray[count($resArray) - 1]);
			if ($score >= 80){
				$color = "#BDF9F2";
			}else if ($score >= 70){
				$color = "#FFF9CA";
			}else if ($score >= 60){
				$color = "#E2E2E2";
			}else{
				$color = "#FFB0C1";
			}
			$result .= "<tr class = \"searchResult\" style = \"background-color:".$color."\">";
			$result .= "<td><a href = \"http://parts.igem.org/Part:".$resArray[0]."\" target=\"_blank\">".$resArray[0]."</a></td>";
			for ($value = 1; $value < count($resArray); ++$value){
				$result .= "<td>".$resArray[$value]."</td>";
			}
			$result .= "</tr>";
		}
	}
	echo $result;
?>