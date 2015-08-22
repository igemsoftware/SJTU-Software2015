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

	var checked = true

	var bricks = ""
	$(".brickId").each(function(){
		if ($(this).val() == ""){
			checked = false
			$(this).css("border-color", "red")
		}else{
			bricks += $(this).val() + '|'
		}
	})
	bricks = bricks.substring(0, bricks.length - 1)

	var functions = ""
	$('.functions').each(function(){
		if ($(this).val() == ""){
			checked = false
			$(this).css("border-color", "red")
		}else{
			functions += $(this).val() + '|'
		}
	})
	functions = functions.substring(0, functions.length - 1)

	if (checked){
		$.post("compare.php", {
			brick: bricks,
			funcs: functions
		}, function(data){
			console.log(213)
		})
	}

}