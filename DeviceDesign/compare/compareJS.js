$(document).ready(function(){
	$(".compare").delegate(".addButton", "click", addRow)
	$(".compareButton").click(beginCompare)
	$(".compare").delegate(".deleteButton", "click", deleteRow)
	window.onbeforeunload = unloadTips
})

var addRow = function(){
	var newRow = "<div class = \"row\"><form class=\"am-form am-form-horizontal am-g inputRow\" id = \"\">" + $(this).parent().parent().html() + "</form></div>"
	$(this).parent().parent().parent().after(newRow)
	$(".deleteButton").css("display", "inline")
}

var deleteRow = function(){
	$(this).parent().parent().parent().remove()
	if ($(".row").length == 1) {
		$(".deleteButton").hide()
	}
}

var beginCompare = function(){
	$(".inputRow").each(function(){
		if ($(this).attr("id") == ""){
			$(this).attr("id", "compared")
			$(this).after("<p class = \"optID\">Optimal ID:</p>")
		}
	})

	var checked = true

	var bricks = ""
	$(".brickId").each(function(){
		if ($(this).val() == ""){
			checked = false
			$(this).css("border-color", "red")
		}else{
			bricks += $(this).val() + ','
		}
	})
	bricks = bricks.substring(0, bricks.length - 1)

	var functions = ""
	$('.functions').each(function(){
		if ($(this).val() == ""){
			checked = false
			$(this).css("border-color", "red")
			$(".optID").each(function(){
				$(this).text("Optimal ID: Error")
			})
		}else{
			functions += $(this).val() + ','
		}
	})
	functions = functions.substring(0, functions.length - 1)

	if (checked){
		$(".optID").each(function(){
			$(this).text("Optimal ID: Loading")
		})
		$.post("compare.php", {
			brick: bricks,
			funcs: functions
		}, function(data){
			var res = data.split("*")
			var opts = res[1].split("@")
			var num = 0
			$(".score").text("Score: " + res[0])
			$(".score").css("display", "block")
			$(".optID").each(function(){
				$(this).text("Optimal ID: " + opts[num])
				num = num + 1
			})
		})
	}
}
var unloadTips = function(){
	var check = 0
	$(":text").each(function(){
		if ($(this).val() != ""){
			check = 1
		}
	})
	if (check){
		return "The data input will not be maintained."
	}else{
		return
	}
}





