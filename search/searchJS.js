var weightList = ["7.5", "6.8", "11.9", "7.5","13.7", "6.7", "3.5", "2.7", "5.5", "10", "10.5", "13.7"]
var typeExp = ["Pieces of DNA that form a functional unit (for example promoter, RBS, etc.)", "Collection set of parts with defined function. In simple terms, a set of complementary BioBrick parts put together forms a device."]
var scoreType = ["Part_status: ", "Sample_Status: ", "Part_Results: ", "Star_rating: ", "Uses: ", "DNA_Status: ", "Qualitative_experience: ", "Group_favorite: ", "Del: ", "Confirmed_times: ", "Number_comments: ", "Ave_rating: "]
var score = []
var limitNumber = "45"

$(document).ready(function(){
	$(".keyWord").keydown(function(e){
		if (e.keyCode == 13){
			search()
		}
	})
	$(".beginSearch").click(function(e){
		e.preventDefault()
		search();
	})

	$(".search").delegate(".searchButton label", "mouseover", function(){
		var left = $(this).position().left - 150 + 35
		var id = $(this).attr("id")
		if (id == 0){
			$(".typeExplanation").css("height", "100px")
			$(".typeExplanation").css("width", "250px")
		}else{
			$(".typeExplanation").css("height", "130px")
			$(".typeExplanation").css("width", "320px")
		}
		$(".typeExplanation p").text(typeExp[id])
		$(".typeExplanation").css("left", left)
		$(".typeExplanation").show()
	})
	$(".search").delegate(".searchButton label", "mouseout", function(){
		$(".typeExplanation").hide()
	})

	var width = $("#weightChoose").width()
	$("#weightChoose, #scoreModel").css("margin-left", -1 * (width) / 2)
	$("#weightChoose").on("open.modal.amui", beginWeight)
	$("#weightChoose").on("close.modal.amui", endWeight)
	$(".search").delegate(".weightInput, .limitInput", "input onpropertychange", function(){
		var checked = true
		var len = $(this).val().length
		for (var i = 0; i < len; ++i){
			if (($(this).val()[i] > '9' || $(this).val()[i] < '0') && $(this).val()[i] != '.'){
				checked = false
				break
			}
		}
		if (checked && $(".am-modal-footer").css("display") == "none"){
			$(".am-modal-footer").fadeIn(200)
		}else if (!checked && $(".am-modal-footer").css("display") != "none"){
			$(".am-modal-footer").fadeOut(200)
		}
	})
	$(".search").delegate(".scoreDetail", "click", showScore)
})

var search = function(){
	var finalWeight = []

	var key = $(".keyWord").val()
	var type = $("input:checked").attr("value")
	var total = 0
	for (var i = 0; i < weightList.length; ++i){
		finalWeight.push(weightList[i])
		total += parseFloat(weightList[i])
	}
	for (var i = 0; i < finalWeight.length; ++i){
		var val = parseFloat(finalWeight[i])
		finalWeight[i] = String(val / total * 100)
	}
	finalWeight = finalWeight.join("*")
	$.post("search.php", {
		searchKeyWord: key, 
		searchType: type,
		weightL: finalWeight,
		limit: parseInt(limitNumber)
	},	function(data){
		if (data.length > 0){
			score = []
			var arr = data.split("@")
			$(".searchResult").html(arr[0])
			$(".rowNumber").css("display", "inline")
			$(".rowNumber p").text("Total: " + arr[1])
			for (var i = 2; i < arr.length; ++i){
				score.push(arr[i])
			}
		}
	})
}

var beginWeight = function(){
	$(".weightInput").each(function(){
		$(this).attr("placeholder", "Default: " + weightList[$(this).attr("id")])
		$(this).val(weightList[$(this).attr("id")])
	})
	$(".limitInput").attr("placeholder", "Default: " + limitNumber)
	$(".limitInput").val(limitNumber)
}

var endWeight = function(){
	$(".weightInput").each(function(){
		if ($(this).val() != weightList[$(this).attr("id")] && $(this).val() != ""){
			weightList[$(this).attr("id")] = $(this).val()
		}
	})
	limitNumber = $(".limitInput").val()
}
var showScore = function(){
	var i = 0
	var scoreList = score[$(this).attr("id")]
	var arr = scoreList.split("|")
	$("#scoreModel p").each(function(){
		$(this).text(scoreType[i] + arr[i])
		++i
	})
	$("#scoreModel").modal()
}




