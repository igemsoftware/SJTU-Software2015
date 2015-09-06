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
})

var search = function(){
	var key = $(".keyWord").val()
	var type = $("input:checked").attr("value")
	$.post("search.php", {
		searchKeyWord: key, 
		searchType: type
	},	function(data){
		if (data.length > 0){
			$(".searchResult").html(data)
		}
	})
}