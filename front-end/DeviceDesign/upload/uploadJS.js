$(document).ready(function(){
	$(".cleanAllButton").click(clearData)
	$(".RegistryButton").click(upload)
	//change the type
	$(".singleSelected").change(function(){
		if ($(this).val() == "devic"){
			//add a row if it is device
			$(this).parent().parent().after("<div class=\"am-form-group partId\"><label for=\"doc-ipt-pwd-2\" class=\"am-u-sm-2 am-form-label formGroupLabel\">*Part ID:</label><div class=\"am-u-sm-10 formGroupInput\"><input type=\"text\" id=\"\" class = \"required\" placeholder = \"This text field is required.\"></div></div>")
		}else{
			$(".partId").remove()
		}
	})
	prepareData()
	window.onbeforeunload = unloadTips
})
//clear all the data we have input
var clearData = function(){
	$(".upload :input").each(function(){
		$(this).val("")
	})
}

var upload = function(){
	var checked = true
	//we can not upload data if some required fields are not completed
	$(".required").each(function(){
		if ($(this).val() == ""){
			$(this).css("border-color", "red")
			checked = false
		}else{
			$(this).css("border-color", "#ccc")
		}
	})
	if (checked){
		var result = ""
		$(".upload :text").each(function(){
			if ($(this).val() == ""){
				result += "--*"
			}else{
				result += $(this).val().toLocaleLowerCase() + "*"
			}
		})
		result += $(".des").val()
		var type = $(".singleSelected").val()

		$("#submitAlert .am-modal-footer").css("display", "none")
		//pass data to the back-end
		$.post("upload.php", {
			data: result,
			type: type,
		}, function(data){
			$("#submitAlert .am-modal-hd").text("Notice")
			$("#submitAlert .am-modal-bd").text(data)
			$("#submitAlert .am-modal-footer").fadeIn(200)
		})
	}else{
		$("#submitAlert .am-modal-hd").text("Error")
		$("#submitAlert .am-modal-bd").text("You must complete the required field.")
		$("#submitAlert .am-modal-footer").fadeIn(200)
	}
}
//if you want to leave the web when there are some icons in the field, you will get a tip.
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
//if this page comes from 'evaluate', we should prepare some data.
var prepareData = function(){
	var data = window.location.search
	if (data != ""){
		var pos = data.indexOf("=")
		data = data.substring(pos + 1)
		var arr = data.split("|")
		$(".singleSelected").val("devic");
		$(".singleSelected").parent().parent().after("<div class=\"am-form-group partId\"><label for=\"doc-ipt-pwd-2\" class=\"am-u-sm-2 am-form-label formGroupLabel\">*Part ID:</label><div class=\"am-u-sm-10 formGroupInput\"><input type=\"text\" id=\"\" class = \"required\" placeholder = \"This text field is required.\"></div></div>")
		$(".required").eq(1).val(arr[0])
		$(".des").val(arr[1])

	}
}

