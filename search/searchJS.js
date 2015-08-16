$(document).ready(function(){
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
	if (type == "Basic"){
		type = "brick"
	} else if (type == "Composite"){
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