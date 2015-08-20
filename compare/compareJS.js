$(document).ready(function(){
	$(".compare").delegate(".addButton", "click", addRow)
})

var addRow = function(){
	var newRow = "<form class=\"am-form am-form-horizontal am-g inputRow\">" + $(this).parent().parent().html() + "</form>"
	$(".compare").append(newRow)
	$(this).css("display", "none")
}