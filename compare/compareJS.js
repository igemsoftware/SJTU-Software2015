$(document).ready(function(){
	$(".compare").delegate(".addButton", "click", addRow)
	$(".compareButton").click(beginCompare)
})

var addRow = function(){
	var newRow = "<form class=\"am-form am-form-horizontal am-g inputRow\" id = \"\">" + $(this).parent().parent().html() + "</form>"
	$(".row").append(newRow)
	$(this).css("display", "none")
}

var beginCompare = function(){
	$(".inputRow").each(function(){
		if ($(this).attr("id") == ""){
			$(this).attr("id", "compared")
			$(this).after("<p>Optimal ID:</p>")
		}
	})
}