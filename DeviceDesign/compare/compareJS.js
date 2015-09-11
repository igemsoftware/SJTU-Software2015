$(document).ready(function(){
	$(".compare").delegate(".addButton", "click", addRow)
	$(".compareButton").click(beginCompare)
	$(".compare").delegate(".deleteButton", "click", deleteRow)
	window.onbeforeunload = unloadTips
	prepareData()
})

var addRow = function(){
	var newRow = "<div class = \"row\"><form class=\"am-form am-form-horizontal am-g inputRow\" id = \"\">" + $(this).parent().parent().html() + "</form></div>"
	$(this).parent().parent().parent().after(newRow)
	$(".compare .deleteButton").css("display", "inline")
}

var deleteRow = function(){
	$(this).parent().parent().parent().remove()
	if ($(".compare .row").length == 1) {
		$(".compare .deleteButton").hide()
	}
}

var beginCompare = function(){
	$(".compare .inputRow").each(function(){
		if ($(this).attr("id") == ""){
			$(this).attr("id", "compared")
			$(this).after("<p class = \"optID\">Optimal ID:</p>")
		}
	})

	var checked = true

	var bricks = ""
	$(".compare .brickId").each(function(){
		if ($(this).val() == ""){
			checked = false
			$(this).css("border-color", "red")
			$(".compare .optID").each(function(){
				$(this).text("Optimal ID: Error")
			})
		}else{
			bricks += $(this).val() + ','
		}
	})
	bricks = bricks.substring(0, bricks.length - 1)

	var functions = ""
	$('.compare .functions').each(function(){
		functions += $(this).val() + ','
	})
	functions = functions.substring(0, functions.length - 1)

	if (checked){
		$(".compare .brickId").each(function(){
			$(this).css("border-color", "#CCC")
		})
		$(".compare .optID").each(function(){
			$(this).text("Optimal ID: Loading")
		})
		$.post("compare.php", {
			brick: bricks,
			funcs: functions
		}, function(data){
			var res = data.split("*")
			var opts = res[1].split("@")
			var num = 0
			$(".compare .score").text("Score: " + res[0])
			$(".compare .score").css("display", "block")
			$(".compare .optID").each(function(){
				$(this).text("Optimal ID: " + opts[num])
				num = num + 1
			})
		})
	}
}
var unloadTips = function(){
	var check = 0
	$(".compare :text").each(function(){
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

var prepareData = function(){
	var data = window.location.search
	var arr = data.split("|")
	var posID = arr[0].indexOf(":")
	var posFunc = arr[1].indexOf(":")
	arr[0] = arr[0].substring(posID + 1)
	arr[1] = arr[1].substring(posFunc + 1)
	var arrID = arr[0].split("*")
	var arrFunc = arr[1].split("*")
	var count = arrID.length - 1
	if (count >= 2){
		for (var i = 0; i < count - 1; ++i){
			var newRow = "<div class = \"row\"><form class=\"am-form am-form-horizontal am-g inputRow\" id = \"\">" + $(".addButton").eq(0).parent().parent().html() + "</form></div>"
			$(".row").eq(0).after(newRow)
			$(".compare .deleteButton").css("display", "inline")
		}
		var i = 0
		$(".brickId").each(function(){
			if (arrID[i] != "NoResult"){
				$(this).val(arrID[i])
			}
			++i
		})
		i = 0
		$(".functions").each(function(){
			$(this).val(arrFunc[i])
			++i
		})
	}else if (count == 1){
		if (arrID[0] != "NoResult"){
			$(".brickId").val(arrID[0])
		}
		$(".functions").val(arrFunc[0])
	}
}






