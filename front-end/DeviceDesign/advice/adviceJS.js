var functionInput = $(".functionInput")

var advisedID = []
var advisedFunc = []

var advisedList = []
var currAdvise = 0

var idChoose = "NoResult"
var functionInputText = "NoResult"

var typeDataSource = [
	["Dna", "DNA parts provide functionality to the DNA itself. DNA parts include cloning sites, scars, primer binding sites, spacers, recombination sites, conjugative tranfer elements, transposons, origami, and aptamers."],
	["Terminator", "A terminator is an RNA sequence that usually occurs at the end of a gene or operon mRNA and causes transcription to stop."],
	["Composite", "unknown"],
	["Project", "unknown"],
	["Reporter", "All of our reporter genes encode for fluorescent proteins (FP's). These fluorescent proteins are derived from two different families of proteins: the Aeqoria Victoria jellyfish, which produces a wild-type GFP, and the Discosoma corals, which (after heavy modification) produces a monomeric RFP (mRFP)."],
	["Coding", "Protein coding sequences encode the amino acid sequence of a particular protein. Note that some protein coding sequences only encode a protein domain or half a protein. Others encode a full-length protein from start codon to stop codon. Coding sequences for gene expression reporters such as LacZ and GFP are also included here."],
	["Regulatory", "A promoter is a DNA sequence that tends to recruit transcriptional machinery and lead to transcription of the downstream DNA sequence."],
	["Rna", "These parts code for RNA segments with novel structures or functions, such as stem-loop riboregulators. All of these contain promoter regions regulating RNA production."],
	["Signalling", "This category signifies parts which allow cells to send extracellular messages to other cells."],
	["Inverter", "Classically, a genetic inverter receives as input the concentration of repressor A and, via gene expression, sends as output the concentration of repressor B."],
	["T7", "Bacteriophage T7 is an obligate lytic phage of E. coli."],
	["Generator", "Protein Generator is a composite-type part based on the combination of a Protein Coding region with one or more other parts. Protein Generators enable expression of the mRNA encoded by the CDS. "],
	["Primer", "A primer is a short single-stranded DNA sequences used as a starting point for PCR amplification or sequencing. Although primers are not actually available via the Registry distribution, we include commonly used primer sequences here."],
	["Protein_Domain", "Protein domains are portions of proteins cloned in frame with other proteins domains to make up a protein coding sequence. Some protein domains might change the protein's location, alter its degradation rate, target the protein for cleavage, or enable it to be readily purified."],
	["Translational_Unit", "Translational units are composed of a ribosome binding site and a protein coding sequence. They begin at the site of translational initiation, the RBS, and end at the site of translational termination, the stop codon."],
	["RBS", "A ribosome binding site (RBS) is an RNA sequence found in mRNA to which ribosomes can bind and initiate translation."],
	["Intermediate", "unknown"],
	["Measurement", "These systems allow measurement of the relative strength of a promoter when it is not being repressed. They all require external validation of the operating conditions such as plasmid copy number and cell metabolism."],
	["Other", "Other"]
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
	//begin and end advise
	$(".evaluation").delegate(".functionInput button", "click", function(){
		currAdvise = parseInt($(this).parent().parent().parent().attr("id"))
	})
	$("#idChooseAlert").on("open.modal.amui", beginAdvise)
	$("#idChooseAlert").on("close.modal.amui", completeAdvise)
	//id choice
	$(".evaluation").delegate("input:radio", "change", function(){
		idChoose = $(this).attr("value")
		if (idChoose == "other"){
			$(".userBrickForm").fadeIn(200)
			$("#idChooseAlert .am-modal-footer").fadeOut(200)
		}else{
			$(".userBrickForm").fadeOut(200)
			$("#idChooseAlert .am-modal-footer").fadeIn(200)
		}
	})
	//to next part - evaluate
	$(".evaButton").click(function(){
		var idres = ""
		for (var i = 0; i < advisedList.length; ++i){
			if (advisedList[i] == true){
				idres += advisedID[i] + '*'
			}
		}
		var passData = "History id:" + idres + "|" + $(".functionHistory").text()
		$(".passDataURL").attr("href","../compare/compare.html?data=" + passData);
		window.onbeforeunload = function(){
			return
		}
	})
	//key down event: id choose
	$(".evaluation").delegate(".functionInput input", "keydown", function(e){
		if (e.keyCode == 13){
			$("#idChooseAlert").modal()
		}
	})

	$(".evaluation").delegate(".userBrickButton", "click", checkWhetherInDatabase)
	$(".evaluation").delegate("#userBrick", "input onpropertychange", function(){
		$("#idChooseAlert .am-modal-footer").fadeOut(200)
	})

 	window.onbeforeunload = unloadTips

	typeDetailPanel()
	hoverEvent()
})
//drag icon
var beginDrag = function(ev){
	ev.dataTransfer.setData("Text", ev.target.id)
	$(".typeDetail").hide()
}

var allowDrop = function(ev){
	ev.preventDefault()
}

var drop = function(ev){
	ev.preventDefault()
	advisedList.push(false)
	advisedID.push("")
	var data = ev.dataTransfer.getData("Text")
	var target = $(".inputSection").children()
	var width = target.css("width")
	for (var num = 0; num < target.length; ++num){
		//find the first empty field
		if (target.eq(num).children().length == 0) {
			var image = document.getElementById(data)
			var newImage = image.cloneNode(true)
			//drop
			target.eq(num).append(image)
			$(image).attr("draggable", "false")
			$(image).removeClass("tableIcon")
			$(image).addClass("selectedIcon")
			//a new photo is placed at the original place
			$(".iconSection").children().eq(parseInt(data) % 10).children().eq(parseInt(data) > 9).children().append(newImage)
			$(".inputSection .selectedIcon").css({
				"width": width,
				"vertical-align": "middle",
				"margin-top": "50px"
			})
			break;
		}
	}
}

var beginAdvise = function(){
	var field = $(".inputField").eq(currAdvise)
	var id = field.children(".selectedIcon").attr("id")
	//get icon type
	var type = typeDataSource[id][0]
	//get function
	var func = field.children(".functionInput").children("input").val()
	//get history id
	var history = $(".idHistory").text().substr(12)
	history = history.substring(0, history.length - 1)
	if (history == ""){
		history == "--"
	}
	//get history functuon
	functionInputText = $(".functionInput input").val()
	advisedFunc[currAdvise] = functionInputText
	$(".functionInput").remove()
	$(".tableIcon").attr("draggable", "true")
	$("#idChooseAlert .am-modal-hd").html("Waiting")	
	$("#idChooseAlert .am-modal-bd").html("Loading Data...")
	$("#idChooseAlert .am-modal-footer").css("display", "none")
	//pass data to back-end
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
		$("#idChooseAlert .am-modal-bd").html(data + "<div class = \"userBrickForm am-g\"><form class=\"am-form am-u-sm-9 am-u-md-9 am-u-lg-9\"><div class=\"am-form-group\"><input type=\"text\" class=\"\" id=\"userBrick\" placeholder=\"You can input a brick id as you like.\"></div></form><button type=\"button\" class=\"am-btn am-u-sm-3 am-u-md-3 am-u-lg-3 userBrickButton\">Check</button></div>")
	})
}

//update the history id and function
var completeAdvise = function(){
	advisedList[currAdvise] = true
	advisedID[currAdvise] = idChoose
	$(".idHistory").append(idChoose + "*")
	$(".functionHistory").append(functionInputText + "*")
	idChoose = "NoResult"
	functionInputText = "NoResult"
}

//remove the selected icon
var hoverEvent = function(){
	var target = $(".cancelButton")
	$(".evaluation").delegate(".cancelButton", "click", function(){
		var field = $(this).parent()
		var id = parseInt(field.attr("id"))
		advisedList[id] = false
		field.children().remove()
		//remove all the icons after the specific icon we have chosen
		for (var i = id; field.siblings().eq(i).children().length != 0; ++i){
			field.siblings().eq(i).children().remove()
		}	
		//update the history field
		var resID = "History id:"
		var resFunc = "History Function:"
		for (var i = 0; i < id; ++i){
			if (advisedList[i] == true){
				resID += advisedID[i] + "*"
				resFunc += advisedFunc[i] + "*"
			}
		}
		$(".idHistory").text(resID)
		$(".functionHistory").text(resFunc)
		$(".tableIcon").attr("draggable", "true")	
	})
	//show the 'remove' button
	$(".evaluation").delegate(".inputField", "mouseover", function(){
		if ($(this).children().length > 0){
			$(this).prepend(target)
			target.show()
			if (advisedList[$(this).attr("id")] == false){
				$(this).append(functionInput)
				$(".functionInput").show()
				$(".functionInput").css({
					"display": "table",
				})
			}
		}

	})
	//hide the 'remove' button
	$(".evaluation").delegate(".inputField", "mouseout", function(){
		target.hide()
		$(".functionInput").hide()
	})
}
//show the detail panel of each type icon
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

//check whether the id user input exists in the database
var checkWhetherInDatabase = function(){
	var field = $(".inputField").eq(currAdvise)
	var iconid = field.children(".selectedIcon").attr("id")
	var id = $("#userBrick").val()
	var type = typeDataSource[iconid][0]
	console.log(type)
	console.log(id)
	$.post("judge.php", {
		usertype: type,
		userid: id
	}, function(data){
		if (data == "Yes"){
			$("#idChooseAlert .am-modal-footer").fadeIn(200)
			$("#userBrick").css("border-color", "#ccc")
			idChoose = id
		}else{
			$("#userBrick").css("border-color", "red")
		}
	})
}

//set the layout
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

	var buttonMarginTop = $(window).height() + $(document).scrollTop()
	$(".evaButtonSection").css({
		"margin-top": buttonMarginTop - $(".evaButtonSection").height() - $(".showArea").offset().top - 80,
	})
}
//if you want to leave the web when there are some icons in the field, you will get a tip.
var unloadTips = function(){
	if ($(".inputField").children().length == 0){
		return
	}
	return "The data input will not be maintained."
}






