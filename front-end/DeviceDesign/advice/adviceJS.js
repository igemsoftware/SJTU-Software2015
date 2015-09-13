var functionInput = $(".functionInput")

var idChoose = "NoResult"
var functionInputText = "NoResult"

var typeDataSource = [
	["Dna", "DNA parts provide functionality to the DNA itself. DNA parts include cloning sites, scars, primer binding sites, spacers, recombination sites, conjugative tranfer elements, transposons, origami, and aptamers."],
	["Termminator", "A terminator is an RNA sequence that usually occurs at the end of a gene or operon mRNA and causes transcription to stop."],
	["Composite", "unknown"],
	["Project", "unknown"],
	["Reporter", "unknown"],
	["Coding", "Protein coding sequences encode the amino acid sequence of a particular protein. Note that some protein coding sequences only encode a protein domain or half a protein. Others encode a full-length protein from start codon to stop codon. Coding sequences for gene expression reporters such as LacZ and GFP are also included here."],
	["Regulatory", "A promoter is a DNA sequence that tends to recruit transcriptional machinery and lead to transcription of the downstream DNA sequence."],
	["Rna", "unknown"],
	["Signalling", "unknown"],
	["Inverter", "unknown"],
	["T7", "Bacteriophage T7 is an obligate lytic phage of E. coli."],
	["Generators", "unknown"],
	["Primer", "A primer is a short single-stranded DNA sequences used as a starting point for PCR amplification or sequencing. Although primers are not actually available via the Registry distribution, we include commonly used primer sequences here."],
	["Protein_Domain", "Protein domains are portions of proteins cloned in frame with other proteins domains to make up a protein coding sequence. Some protein domains might change the protein's location, alter its degradation rate, target the protein for cleavage, or enable it to be readily purified."],
	["Translational_Unit", "Translational units are composed of a ribosome binding site and a protein coding sequence. They begin at the site of translational initiation, the RBS, and end at the site of translational termination, the stop codon."],
	["RBS", "A ribosome binding site (RBS) is an RNA sequence found in mRNA to which ribosomes can bind and initiate translation."],
	["Intermediate", "unknown"],
	["Measurement", "unknown"],
	["Other", "unknown"]
]

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
	$("#idChooseAlert").on("open.modal.amui", beginAdvise)
	$("#idChooseAlert").on("close.modal.amui", completeAdvise)
	$(".evaluation").delegate("input:radio", "change", function(){
		idChoose = $(this).attr("value")
		$("#idChooseAlert .am-modal-footer").fadeIn(200)
	})
	$(".evaButton").click(function(){
		var passData = $(".idHistory").text() + "|" + $(".functionHistory").text()
		$(".passDataURL").attr("href","../compare/compare.html?data=" + passData);
		window.onbeforeunload = function(){
			return
		}
	})

	$(".evaluation").delegate(".functionInput input", "keydown", function(e){
		if (e.keyCode == 13){
			$("#idChooseAlert").modal()
		}
	})

 	window.onbeforeunload = unloadTips

	typeDetailPanel()
	cancelSelected()
})

var beginDrag = function(ev){
	ev.dataTransfer.setData("image", ev.target.id)
	$(".typeDetail").hide()
}

var allowDrop = function(ev){
	ev.preventDefault()
}

var drop = function(ev){
	ev.preventDefault()
	var data = ev.dataTransfer.getData("image")
	var target = $(".inputSection").children()
	var width = target.css("width")
	for (var num = 0; num < target.length; ++num){
		if (target.eq(num).children().length == 0) {
			var image = document.getElementById(data)
			var newImage = image.cloneNode(true)
			target.eq(num).append(image)
			$(image).attr("draggable", "false")
			$(image).removeClass("tableIcon")
			$(image).addClass("selectedIcon")
			$(".iconSection").children().eq(parseInt(data) % 10).children().eq(parseInt(data) > 9).children().append(newImage)
			$(".inputSection .selectedIcon").css({
				"width": width,
				"vertical-align": "middle",
				"margin-top": "50px"
			})

			$(".inputField").eq(num).append(functionInput)
			$(".functionInput").show()
			$(".functionInput").css({
				"display": "table",
			})
			$(".tableIcon").attr("draggable", "false")
			break;
		}
	}
}

var beginAdvise = function(){
	var field = $(".inputField").has(".functionInput")
	var id = field.children(".selectedIcon").attr("id")
	var type = typeDataSource[id][0]

	var func = field.children(".functionInput").children("input").val()

	var history = $(".idHistory").text().substr(12)
	history = history.substring(0, history.length - 1)
	if (history == ""){
		history == "--"
	}

	functionInputText = $(".functionInput input").val()
	$(".functionInput").remove()
	$(".tableIcon").attr("draggable", "true")
	$("#idChooseAlert .am-modal-hd").html("Waiting")	
	$("#idChooseAlert .am-modal-bd").html("Loading Data...")
	$("#idChooseAlert .am-modal-footer").css("display", "none")

	$.post("advice.php", {
		type: type,
		userFunction: func,
		id: history
	}, function(data){
		if (data != "No results"){
			$("#idChooseAlert .am-modal-hd").html("Advised ID, please choose one: ")
		}else{
			$("#idChooseAlert .am-modal-hd").html("Warning")
			$("#idChooseAlert .am-modal-footer").fadeIn(200)
		}
		$("#idChooseAlert .am-modal-bd").html(data)
	})
}
var completeAdvise = function(){
	$(".idHistory").append(idChoose + "*")
	$(".functionHistory").append(functionInputText + "*")
	idChoose = "NoResult"
	functionInputText = "NoResult"
}


var cancelSelected = function(){
	var target = $(".cancelButton")
	$(".evaluation").delegate(".cancelButton", "click", function(){
		var field = $(this).parent()
		var id = parseInt(field.attr("id"))
		field.children().remove()
		for (var i = id; field.siblings().eq(i).children().length != 0; ++i){
			field.siblings().eq(i).children().remove()
		}	
		var index = 0
		var funcIndex = 0
		var originText = $(".idHistory").text()
		var originFunctionText = $(".functionHistory").text()
		for (var i = 0; i < id; ++i){
			index = originText.indexOf('*', index + 1)
			funcIndex = originFunctionText.indexOf('*', funcIndex + 1)
		}
		if (id == 0){
			$(".idHistory").text("History id:")
			$(".functionHistory").text("History Function:")
		}else{
			$(".idHistory").text(originText.substring(0, index + 1))
			$(".functionHistory").text(originFunctionText.substring(0, funcIndex + 1))
		}
		$(".tableIcon").attr("draggable", "true")	
	})

	$(".evaluation").delegate(".inputField", "mouseover", function(){
		if ($(this).children().length > 0){
			$(this).prepend(target)
			target.show()
		}
	})

	$(".evaluation").delegate(".inputField", "mouseout", function(){
		target.hide()
	})
}

var typeDetailPanel = function(){
	var target = $(".typeDetail")
	$(".evaluation").delegate(".tableIcon", "mouseover", function(){
		var id = $(this).attr("id")
		var top = ((id % 10) + 1) * $(".iconSection td").outerHeight()
		var width = $(".iconSection td").outerWidth() * 3
		
		$(".typeDetail .am-panel-title").text(typeDataSource[id][0])
		$(".typeDetail .am-panel-bd").text(typeDataSource[id][1])
		target.css({
			"margin-top": top,
			"width": width,
			"margin-left": -1 * (id <= 9) * width / 3,
			"z-index": 1000
		})
		target.show()
	})

	$(".evaluation").delegate(".tableIcon", "mouseout", function(){
		target.hide()
	})
}

var setUpMargin = function(){
	var leftMargin = $(".mainNav").css("margin-left")
	var width = $(".mainNav .mainNavItem").innerWidth()
	$("table").css({
		"width": width / 2
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

var unloadTips = function(){
	if ($(".inputField").children().length == 0){
		return
	}
	return "The data input will not be maintained."
}






