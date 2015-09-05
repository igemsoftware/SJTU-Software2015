$(document).ready(function(){
	$(".cleanAllButton").click(clearData)
	$(".RegistryButton").click(upload)
})

var clearData = function(){
	$(".upload :input").each(function(){
		$(this).val("")
	})
}

var upload = function(){
	var checked = true

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