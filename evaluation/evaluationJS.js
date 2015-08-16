var liNumber = 0

$(document).ready(function(){
	setUpMargin()
	window.onresize = setUpMargin
	$(".tableIcon").attr({
		"draggable": "true",
		"ondragstart": "beginDrag(event)",
	})
	$(".inputSection").attr({
		"ondragover": "allowDrop(event)",
		"ondrop": "drop(event)"
	})
})

var beginDrag = function(ev){
	ev.dataTransfer.setData("image", ev.target.id)
}

var allowDrop = function(ev){
	ev.preventDefault()
}

var drop = function(ev){
	ev.preventDefault()
	var data = ev.dataTransfer.getData("image")
	var target = $(".inputSection").children().eq(liNumber)
	var width = target.css("width")
	if (liNumber < 8) {
		var image = document.getElementById(data)
		var newImage = image.cloneNode(true)
		target.append(image)
		$(".iconSection").children().eq(parseInt(data) % 18).children().eq(parseInt(data) > 17).children().append(newImage)
		$(".inputSection .tableIcon").css({
			"width": width,
			"vertical-align": "middle",
			"margin-top": "30px"
		})
		liNumber = liNumber + 1
	}
}



var setUpMargin = function(){
	var leftMargin = $(".mainNav").css("margin-left")
	var width = $(".mainNavItem").innerWidth()
	$("table").css({
		"width": width * 2 / 3
	})
	$(".upperTable").css({
		"width": width * 2 / 3,
		"margin-left": leftMargin
	})

	var iconWidth = $(".evaluation table td").innerWidth()
	var iconHeight = $(".evaluation table td").innerHeight()
	$(".tableIcon").css({
		"width": iconWidth,
		"height": iconHeight,
	})

	$(".showArea").css({
		"height": $(".evaluation table").innerHeight()
	})

	var buttonMarginTop = $(".evaluation table").innerHeight() - $(".evaButtonSection").innerHeight()
	$(".evaButtonSection").css({
		"margin-top": buttonMarginTop,
	})
}