/*Funciones Ajax --> */
/* Simple AJAX Code-Kit (SACK) v1.6.1 */
/* ©2005 Gregory Wild-Smith */
/* www.twilightuniverse.com */
/* Software licenced under a modified X11 licence,
   see documentation or authors website for more details */
/* Modified by Uriel M. Gomez Robles */

/*for (var setting in settings) {
	setting_value = settings[setting]
	alert(setting+'= '+setting_value)
    }*/

function sack(file, settings) {
	if (!settings) settings = {}
	this.xmlhttp = null;

	this.resetData = function() {
	
		this.requestFile = file;
		this.method = (settings["method"] || "POST");
		this.argumentSeparator = (settings["argumentSeparator"] || "&");
		this.URLString = (settings["URLString"] || "");
		this.encodeURIString = (settings["encodeURIString"]!=undefined?settings["encodeURIString"]:true);
  		this.id = (settings["id"] || null);
		this.context = (settings["context"] || null);
		this.xslFile = (settings["xslFile"] || undefined);
		this.vars = (settings["vars"] || new Object());
		this.async = (settings["async"]!=undefined?settings["async"]:true);

		this.responseStatus = new Array(2);
		this.document = undefined;
  	};

	this.resetFunctions = function() {
  		this.onLoading = function() { };
  		this.onLoaded = function() { };
  		this.onInteractive = function() { };
  		this.onCompletion = function() { };
		this.onSuccess = function() { };
  		this.onError = function() {
  			showModal(this.responseStatus[1]);
		};
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
		
		var originalURL=this.requestFile
		var urlName=this.requestFile.match(/(.*?)(?=\?)/);
		if (urlName==null)
			{
			urlName=this.requestFile
			}
		else
			{
			this.requestFile=urlName[0]
			}

		if (urlstring) {
			if (this.URLString.length) {
				this.URLString += this.argumentSeparator + urlstring;
			} else {
				this.URLString = urlstring;
			}
		}

	  	var m = (originalURL+"&").match(/(?:[&\?])(\w+)=(.*?)(?=&)/g);
	  	if (m == null) {
	    	//alert("No match");
	  	} else {
		    var s = "Match at position " + m.index + ":\n";
		    for (i = 0; i < m.length; i++) {
				var varName = (m[i]+"&").replace(/(?:[&\?])(\w+)=(.*?)[\&\?]/g, '$1');
				var varValue = (m[i]+"&").replace(/(?:[&\?])(\w+)=(.*?)[\&\?]/g, '$2');
				// alert(m[i]+'\n'+varName+'\n'+varValue)
				this.setVar(varName, varValue);
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
		// alert(this.URLString)
	}

	this.runResponse = function() {
		eval(this.response);
	}

	this.sendXML = function(xmlData) {
		if (this.failed) {
			this.onFail();
		} else {
			if (this.xmlhttp) {
				var element = this;
				this.xmlhttp.open("POST", this.requestFile, this.async);
				this.xmlhttp.setRequestHeader("Content-Type", "text/xml")
				this.xmlhttp.onreadystatechange = function() {
					switch (element.xmlhttp.readyState) {
					case 1:
						element.onLoading();
						break;
					case 2:
						element.onLoaded();
						break;
					case 3:
						element.onInteractive();
						break;
					case 4:
						element.responseStatus[0] = element.xmlhttp.status;
						element.responseStatus[1] = element.xmlhttp.statusText;

						element.responseXML = element.xmlhttp.responseXML;
						element.document = element.xmlhttp.responseText;
						//alert(element.context+': '+element.document)

						if (element.responseStatus[0]==404)
							{
							alert('No se encontró la página: '+element.xslFile)
							}
						else if (element.document.indexOf("error '")!=-1)
							{
							element.responseStatus[1] = element.document
							}
						else if (element.context) {
						
						}
						if (element.context && element.context.Ajax) element.context.Ajax=undefined;
						
						if (!(element.document.indexOf("error '")!=-1) && element.responseStatus[0] == "200") {
							if (element.context && element.context.AdviseImage) { element.context.AdviseImage.removeNode(true); element.context.AdviseImage=undefined; /*alert('terminó satisfactoriamente.');*/ };
							element.onSuccess();
						} else {
							if (element.context && element.context.AdviseImage) element.context.AdviseImage.src='../../../../Images/Advise/vbExclamation.gif'
							element.onError();
							return false;
						}

						element.URLString = "";
						element.onCompletion();
						break;
					}
				}
			this.xmlhttp.send(xmlData);
			};
		}
	}
	
	this.runAJAX = function(urlstring) {
		if (this.failed) {
			this.onFail();
		} else {
			this.createURLString(urlstring);
			if (this.id) {
				this.context = document.getElementById(this.id);
			}
			if (this.xmlhttp) {
				var element = this;
				if (this.method == "GET") {
					totalurlstring = this.requestFile + '?' + this.URLString;
					this.xmlhttp.open(this.method, totalurlstring, this.async);
				} else {
					this.xmlhttp.open(this.method, this.requestFile, this.async);
					try {
						this.xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
					} catch (e) { }
				}
				if (element.context) element.context.Ajax=(this.xmlhttp==null?undefined:this.xmlhttp);
				if (element.context && element.context.onLoading) element.onLoading=function () {eval(element.context.onLoading)}
				if (element.context && element.context.onLoaded) element.onLoaded=function () {eval(element.context.onLoaded)}
				if (element.context && element.context.onCompletion) element.onCompletion=function () {with (element.context) { eval(element.context.onCompletion) };}
				if (element.context && element.context.onSuccess) element.onSuccess=function () {with (element.context) { eval(element.context.onSuccess) };}
				
				if (element.context && !(element.context.oWorking))
					{
					oWorking=document.createElement('<img id="img_buscando" src="../../../../Images/Advise/in_progress.gif" alt="TRABAJANDO..." width="16" height="16" border="0" style="position:\'absolute\'" onMouseOver="/*this.removeNode(true);*/">')
					element.context.insertAdjacentElement("afterEnd", oWorking);
					element.context.AdviseImage=oWorking
					}
					
				this.xmlhttp.onreadystatechange = function() {
					switch (element.xmlhttp.readyState) {
						case 1:
							element.onLoading();
							break;
						case 2:
							element.onLoaded();
							break;
						case 3:
							element.onInteractive();
							break;
						case 4:
							element.responseStatus[0] = element.xmlhttp.status;
							element.responseStatus[1] = element.xmlhttp.statusText;

							element.responseXML = element.xmlhttp.responseXML;
							element.document = element.xmlhttp.responseText;
							//alert(element.requestFile+' - '+ element.context+': '+element.document)

							if (element.responseStatus[0]==404)
								{
								alert('No se encontró la página: '+element.xslFile)
								}
							else if (element.document.indexOf("error '")!=-1)
								{
								element.responseStatus[1] = element.document
								}
							else if (element.context) {
								//if (!(element.xslFile)/* && $(element.context).hasClass('selectBox')==false*/) element.xslFile=getContextSchema(element.context)
								if (element.document.indexOf("<?xml ")>=0)
									{
									element.context.DataContext=element.responseXML
									}
									
								if (element.xslFile)
									{
									var xml = element.responseXML
									var xsl = loadXMLFile(element.xslFile+".xsl").responseXML
									if (window.ActiveXObject)
									  	{
										element.document = xml.transformNode(xsl)
										//alert(element.document)
										}
									else if (document.implementation && document.implementation.createDocument)
										{
										var xsltProcessor=new XSLTProcessor();
										xsltProcessor.importStylesheet(xsl);
										element.document = xsltProcessor.transformToFragment(xml,document);
										}
									}
								switch(element.context.nodeName.toLowerCase()) {
								case "input": 
								case "textarea":
										element.context.value = eval(element.document);
									break;
								default:
									//alert(element.xslFile+': \n\n'+ element.document)
									if (element.document.toUpperCase().indexOf("<HTML")!=-1)
										{
										try 
											{
											element.context.innerHTML=element.document
											goToFirstVisibleObject(element.context)
											}
										catch(e) {alert(e.description+'. It\'s possible that due to an undefined error, innerHTML can\'t be inserted inside anything within a form tag.')}
										}
									else
										{
										if ($(element.context).is('.catalog,.selectBox'))
											{
											//element.context.dataSource=element.document
											}
										else
											{
											with (element.context)
												{
												eval(element.document);
												}
											}
										}
									break;
								}
							}
						else
							{
							if (element.xslFile==undefined)
								{
								try
									{
									eval(element.document)
									}
								catch(e) {'Error al evaluar el código. \n\n'+e.description}
								}
							}
						if (element.context && element.context.Ajax) element.context.Ajax=undefined;
						
						if (!(element.document.indexOf("error '")!=-1) && element.responseStatus[0] == "200") {
							if (element.context && element.context.AdviseImage) { element.context.AdviseImage.removeNode(true); element.context.AdviseImage=undefined; /*alert('terminó satisfactoriamente.');*/ };
							element.onSuccess();

						} else {
							if (element.context && element.context.AdviseImage) element.context.AdviseImage.src='../../../../Images/Advise/vbExclamation.gif'
							element.onError();
						}
						
						element.URLString = "";
						element.onCompletion();
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