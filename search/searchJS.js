$(document).ready(function(){
	$(".keyWord").keydown(function(e){
		if (e.keyCode == 13){
			search()
		}
	})
	$(".searchButton .button").click(function(){
		$(this).siblings().removeClass("buttonClick")
		$(this).addClass("buttonClick")
	})
	$(".beginSearch").click(function(e){
		e.preventDefault()
		search();
	})
})

var search = function(){
	var key = $(".keyWord").val()
	var type = $(".buttonClick").text()
	if (type == "Part"){
		type = "brick"
	} else if (type == "Device"){
		type = "devic"
	}
	$.post("search.php", {
		searchKeyWord: key, 
		searchType: type
	},	function(data){
		if (data.length > 0){
			$(".searchResult").html(data)
		}
	})
}