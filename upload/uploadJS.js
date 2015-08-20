$(document).ready(function(){
	$(".cleanAllButton").click(clearData)
})

var clearData = function(){
	$(".upload :input").each(function(){
		$(this).val("")
	})
}