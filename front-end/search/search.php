<?php
	$keyword = $_POST['searchKeyWord'];
	$type = trim($_POST['searchType']);
	$weightList = $_POST['weightL'];
	$limit = $_POST['limit'];
	//execute the back-end
	exec("perl hcount_v1.pl $keyword $type $weightList $limit", $out);
	$result = "";
	$scoreDetail = "";
	$number = count($out);
	//no result
	if ($number <= 3){
		$result = "<tr><td>No Results</td></tr>";
	}else{
		for ($i = 2; $i < $number - 1; $i = $i + 2){
			$resArray = explode("|", $out[$i]);
			//change the row color according to the score
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
			//row html code
			$result .= "<tr class = \"searchResult\" style = \"background-color:".$color."\">";
			$result .= "<td><a href = \"http://parts.igem.org/Part:".$resArray[0]."\" target=\"_blank\">".$resArray[0]."</a></td>";
			for ($value = 1; $value < count($resArray) - 1; ++$value){
				$result .= "<td>".$resArray[$value]."</td>";
			}
			$result .= "<td><a href = \"javascript:void(0)\" id = \"".(($i - 2) / 2)."\" class = \"scoreDetail\">".$resArray[count($resArray) - 1]."</a></td>";
			$result .= "</tr>";
		}
		for ($i = 3; $i < $number - 1; $i = $i + 2){
			$scoreDetail = $scoreDetail.'^'.$out[$i];

		}
	}
	echo $result."^".(($number - 3) / 2).$scoreDetail;
?>