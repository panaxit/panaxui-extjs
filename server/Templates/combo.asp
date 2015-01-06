<html>
<head>
<script>
/* Simple AJAX Code-Kit (SACK) v1.6.1 */
/* ©2005 Gregory Wild-Smith */
/* www.twilightuniverse.com */
/* Software licenced under a modified X11 licence,
   see documentation or authors website for more details */

function sack(file) {
	this.xmlhttp = null;

	this.resetData = function() {
		this.method = "POST";
  		this.queryStringSeparator = "?";
		this.argumentSeparator = "&";
		this.URLString = "";
		this.encodeURIString = true;
  		this.execute = false;
  		this.element = null;
		this.context = null;
		this.requestFile = file;
		this.xslFile = undefined;
		this.vars = new Object();
		this.async = true;
		this.responseStatus = new Array(2);
  	};

	this.resetFunctions = function() {
  		this.onLoading = function() { };
  		this.onLoaded = function() { };
  		this.onInteractive = function() { };
  		this.onCompletion = function() { };
  		this.onError = function() { };
		this.onFail = function() { };
	};

	this.reset = function() {
		this.resetFunctions();
		this.resetData();
	};

	this.createAJAX = function() {
		try {
			this.xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e1) {
			try {
				this.xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e2) {
				this.xmlhttp = null;
			}
		}

		if (! this.xmlhttp) {
			if (typeof XMLHttpRequest != "undefined") {
				this.xmlhttp = new XMLHttpRequest();
			} else {
				this.failed = true;
			}
		}
	};

	this.setVar = function(name, value){
		this.vars[name] = Array(value, false);
	};

	this.encVar = function(name, value, returnvars) {
		if (true == returnvars) {
			return Array(encodeURIComponent(name), encodeURIComponent(value));
		} else {
			this.vars[encodeURIComponent(name)] = Array(encodeURIComponent(value), true);
		}
	}

	this.processURLString = function(string, encode) {
		encoded = encodeURIComponent(this.argumentSeparator);
		regexp = new RegExp(this.argumentSeparator + "|" + encoded);
		varArray = string.split(regexp);
		for (i = 0; i < varArray.length; i++){
			urlVars = varArray[i].split("=");
			if (true == encode){
				this.encVar(urlVars[0], urlVars[1]);
			} else {
				this.setVar(urlVars[0], urlVars[1]);
			}
		}
	}

	this.createURLString = function(urlstring) {
		if (this.encodeURIString && this.URLString.length) {
			this.processURLString(this.URLString, true);
		}

		if (urlstring) {
			if (this.URLString.length) {
				this.URLString += this.argumentSeparator + urlstring;
			} else {
				this.URLString = urlstring;
			}
		}

		// prevents caching of URLString
		this.setVar("rndval", new Date().getTime());

		urlstringtemp = new Array();
		for (key in this.vars) {
			if (false == this.vars[key][1] && true == this.encodeURIString) {
				encoded = this.encVar(key, this.vars[key][0], true);
				delete this.vars[key];
				this.vars[encoded[0]] = Array(encoded[1], true);
				key = encoded[0];
			}

			urlstringtemp[urlstringtemp.length] = key + "=" + this.vars[key][0];
		}
		if (urlstring){
			this.URLString += this.argumentSeparator + urlstringtemp.join(this.argumentSeparator);
		} else {
			this.URLString += urlstringtemp.join(this.argumentSeparator);
		}
	}

	this.runResponse = function() {
		eval(this.response);
	}

	this.runAJAX = function(urlstring) {
		if (this.failed) {
			this.onFail();
		} else {
			this.createURLString(urlstring);
			if (this.element) {
				this.context = document.getElementById(this.element);
			}
			if (this.xmlhttp) {
				var self = this;
				if (this.method == "GET") {
					totalurlstring = this.requestFile + this.queryStringSeparator + this.URLString;
					this.xmlhttp.open(this.method, totalurlstring, this.async);
				} else {
					this.xmlhttp.open(this.method, this.requestFile, this.async);
					try {
						this.xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
					} catch (e) { }
				}

				this.xmlhttp.onreadystatechange = function() {
					switch (self.xmlhttp.readyState) {
						case 1:
							self.onLoading();
							break;
						case 2:
							self.onLoaded();
							break;
						case 3:
							self.onInteractive();
							break;
						case 4:
							if (self.xslFile)
								{
								var xml = self.xmlhttp.responseXML
								var xsl = loadXMLFile(self.xslFile)
								if (window.ActiveXObject)
								  	{
									self.response = xml.transformNode(xsl.responseXML)
									}
								else if (document.implementation && document.implementation.createDocument)
									{
									var xsltProcessor=new XSLTProcessor();
									xsltProcessor.importStylesheet(xsl);
									self.response = xsltProcessor.transformToFragment(xml,document);
									}

								self.responseXML = self.xmlhttp.responseXML;
								}
							else
								{
								self.response = self.xmlhttp.responseText;
								self.responseXML = self.xmlhttp.responseXML;
								}
							
							self.responseStatus[0] = self.xmlhttp.status;
							self.responseStatus[1] = self.xmlhttp.statusText;
							/*

							if (self.execute) {
								self.runResponse();
							}
*/
							if (self.context) {
								if (!(self.context.oWorking))
									{
									oWorking=document.createElement('<img id="img_buscando" src="../../../../Images/Advise/in_progress.gif" alt="TRABAJANDO..." width="16" height="16" border="0" style="position:\'absolute\'" onclick="alert(this.src)" onMouseOver="/*this.removeNode(true);*/">')
									self.context.insertAdjacentElement("afterEnd", oWorking);
									self.context.oAdvise=oWorking
									}
								switch(self.context.nodeName.toLowerCase()) {
									case "input": 
									case "textarea":
										value = eval(self.response);
										break;
									case "select":
										var sCurrentvalue="'opt_"+self.context.value+"';";
										self.response=self.response.replace(sCurrentvalue, sCurrentvalue+" options[length-1].selected=true;").replace(/<\?.*?\?>/gi, '')
									  	with (self.context) 
										  	{ 
											for (var j=length-1; j>=0; j--)
												{
												remove(j);
												}
									  		eval(self.response.replace(sCurrentvalue, sCurrentvalue+" options[length-1].selected=true;").replace(/<\?.*?\?>/gi, '')); 
											}
											
/*										if (window.ActiveXObject) // code for IE
										  	{
										  	document.getElementById("example").innerHTML=self.response;
										  	}
										else if (document.implementation && document.implementation.createDocument) // code for Mozilla, Firefox, Opera, etc.
										  	{
											document.getElementById("example").appendChild(self.response);
											}*/
										break;
									default:
										innerHTML = self.response;
										break;
								}
							}

							if (self.responseStatus[0] == "200") {
								if (self.context && self.context.oAdvise) { self.context.oAdvise.removeNode(true); self.context.oAdvise=null; };
								self.onCompletion();
							} else {
								if (self.context && self.context.oAdvise) self.context.oAdvise.src='../../../../Images/Advise/vbExclamation.gif'
								self.onError();
							}
							
							self.URLString = "";
							break;
					}
				};

				this.xmlhttp.send(this.URLString);
			}
		}
	};

	this.reset();
	this.createAJAX();
}

function loadXMLFile(sXmlFile, sXslFile, oControl)
{
	var xhttp = new sack();	
	xhttp.requestFile = sXmlFile
	xhttp.context = oControl
	xhttp.xslFile = sXslFile
	xhttp.method = 'GET'
	xhttp.async = false
	xhttp.onError = function(){ alert('File not found '+sXmlFile) };
	xhttp.runAJAX();
//	alert(sXmlFile+' '+sXslFile+':\n'+xhttp.response)
	return xhttp
/*if (window.XMLHttpRequest)
  {
  xhttp=new XMLHttpRequest();
  }
else
  {
  xhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }
xhttp.open("GET",dname,false);
xhttp.send("");
return xhttp.responseXML;*/
}

function refreshData(oControl)
{
loadXMLFile("xmlDataForCombo.asp", "ajaxCombo.xsl", oControl)
/*
ex=loadXMLFile("xmlData.asp", "ajaxCombo.xsl", oControl).response;
// code for IE
if (window.ActiveXObject)
  	{
	var sCurrentvalue="'opt_"+oControl.value+"';";
	ex=ex.replace(sCurrentvalue, sCurrentvalue+" options[length-1].selected=true;")

  	with (oControl) 
	  	{ 
		for (var j=length-1; j>=0; j--)
			{
			remove(j);
			}
  		eval(ex.replace(/<\?.*?\?>/gi, '')); 
		}
  	document.getElementById("example").innerHTML=ex;
  	}
// code for Mozilla, Firefox, Opera, etc.
else if (document.implementation && document.implementation.createDocument)
  {
  xsltProcessor=new XSLTProcessor();
  xsltProcessor.importStylesheet(xsl);
  resultDocument = xsltProcessor.transformToFragment(xml,document);
  document.getElementById("example").appendChild(resultDocument);
  }
 */
}
</script>
</head>
<body>
<select id="combo" onContextMenu="refreshData(this); return false;">
</select>
<div id="example" />
</body>
</html>