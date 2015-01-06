selectBox_stylesheet=load("../Templates/autoCompleteBox.xsl").responseXML
//catalog_stylesheet=load("../Templates/catalog.xsl").responseXML
filters_stylesheet=load("../Templates/filters.xsl").responseXML
var isModalWindow=((typeof self.parent.window.dialogArguments)=='object')

namespace("submit");
submit.onComplete=function() {
if ((typeof self.parent.window.dialogArguments)=='object') 
	{
	self.parent.close();
	}
else
	{
	refreshPage(); 
	}
}

submit.onError=function(html) {
	showModal(html, {minHeight:200,minWidth:600});
}

window.attachEvent("onbeforeprint", unFreezeHeader);
window.attachEvent("onscroll", scrollUnaVez); 

window.attachEvent("onload", initialize)

function namespace(namespaceString) {
    var parts = namespaceString.split('.'),
        parent = window,
        currentPart = '';    

    for(var i = 0, length = parts.length; i < length; i++) {
        currentPart = parts[i];
        parent[currentPart] = parent[currentPart] || {};
        parent = parent[currentPart];
    }

    return parent;
}

function initialize()
{
/*alert('inicializando')
initializeCSS()
alert('termina inicialización')*/
document.body.attachEvent("onkeydown", catchKeys)
var init=window.setTimeout(function() {goToFirstVisibleObject(document.body); window.clearTimeout(init); init=undefined;}, 100);
}

function numberOfFormChanges()
{
	return $(".dataTable:not([mode='filters']) .changed, .dataTable:not([mode='filters']) .delete").length
}

attachEvent("onbeforeunload", warnChanges)
function warnChanges()
{
if (numberOfFormChanges()>0)
	{
	event.returnValue = ('Todavía quedan cambios sin guardar!, desea DESCARTAR los cambios?')
	}
else
	{
	if (window.name=='WorkArea' || window.name=='resultados') showModal('<div style="background-color:white; padding:15;"><img src="../../../../Images/Advise/in_progress.gif" alt="TRABAJANDO..." width="32" height="32" border="0""> <label class="title">PROCESANDO... ESPERE POR FAVOR</label></div>')
	}
/*try { top.frames('buttons').btnRefresh.enabled=false } catch(e) {}
try { top.frames('buttons').btnBack.enabled=false } catch(e) {}
try { top.frames('buttons').btnExcel.enabled=false } catch(e) {}
try { top.frames('buttons').btnPrint.enabled=false } catch(e) {}
try { top.frames('buttons').btnSave.enabled=false } catch(e) {}*/
}

function downloadReferencedFile(sFileReference)
{
//alert(sFile+': '+calcMD5('archivos_proyectos/Resultados Semanales 2010.xls')+' vs '+calcMD5(sFile))
window.open("../Scripts/encrypted_downloader.asp?sid="+calcMD5(Math.random())+"&fId="+sFileReference,"","location=no, height=0, width=0, resizable=yes, toolbar=no, status=yes, scrollbars=yes, menubar=no")
}

function downloadFile(sFile)
{
//alert(sFile+': '+calcMD5('archivos_proyectos/Resultados Semanales 2010.xls')+' vs '+calcMD5(sFile))
window.open("../Scripts/downloader.asp?sid="+calcMD5(Math.random())+"&File="+sFile,"","location=no, height=0, width=0, resizable=yes, toolbar=no, status=yes, scrollbars=yes, menubar=no")
}

function refreshPage(oPage)
{
if (oPage==null) oPage=window;
if (!oPage) alert('No se encuentra el elemento que se quiere actualizar')
try
	{
	if (oPage.src) 
		oPage.src=oPage.src
	else
		{
		if (isModalWindow || 1==1)
			{
			oPage.document.location.href=oPage.document.location.href.replace(/\#/, '');
			}
		else
			{
			with (oPage)
				{
				focus()
				document.execCommand('Refresh')
				}
			}
		}
	}
catch(e) {alert('No se pudo actualizar la página: \n'+e.description)}
}

function goBack()
{
if (isModalWindow)
	{
	self.parent.close();
	}
else
	{
	history.go(-1);
	}
}

function goToFirstVisibleObject(oTarget)
{
try 
	{
	$(":input:visible:first", oTarget).filter(function(){ return $(this).closest(".dataTable").get(0)}).focus()
	}
catch(e) {}
/*var oCll=mergeCollections(oTarget.getElementsByTagName('INPUT'), oTarget.getElementsByTagName('TEXTAREA'), oTarget.getElementsByTagName('SELECT'));
for (tC=0; tC<oCll.length; ++tC)
	{
	try
		{
//		alert(oCll[tC].tagName+', '+getVal(oCll[tC]))
		oCll[tC].focus()
		}
	catch(e) {}
	if (document.activeElement==oCll[tC]) return oCll[tC];
	}*/
return undefined
}

function cancelBubble()
{
try { window.event.cancelBubble=true; } catch(e) {}
}

function catchKeys() //captura las teclas y hace otra cosa
{
var externo=0
sKeyCode=event.keyCode;
cancelar_headerFlotante=true;
//codigo para el modulo de consulta detalle expediente
if (sKeyCode==27)
	{
	try
		{
		document.body.detachEvent('onmousemove', escogeOrdenarFiltros)
		document.body.detachEvent('onscroll', tablaOFlotanteFiltros);
		document.all("tabla_ordenar_filtros").removeNode(true)
		document.body.style.cursor='';
		status=""
		event.keyCode=0;
		event.returnValue=false;
		}
	catch(e) {}		
	}
if (sKeyCode==27)
	{	
	try
		{
		document.body.detachEvent('onmousemove', escogeOrdenar)
		document.body.detachEvent('onclick', ordenaColumnas)
		document.body.detachEvent('oncontextmenu', agregaColumnas)
		document.body.detachEvent('onscroll', tablaOFlotante);
		document.all("tabla_ordenar").removeNode(true)
		document.body.style.cursor='';
		ordena=false
		status=""
		event.keyCode=0;
		event.returnValue=false;
		cl_imagen.removeNode(true)
		vista=true		
		}
	catch(e) {}
	}		
if (event.ctrlKey && cl_imagen)
	{
	cl_imagen.src=(cl_imagen.src.search(/_alt/gi)==-1?cl_imagen.src.replace(/.gif/gi,'_alt.gif'):cl_imagen.src.replace(/_alt.gif/gi,'.gif'))
	order_asc=!order_asc
	}
if (event.ctrlKey && (sKeyCode==71 || sKeyCode==83)) // ctrl + [g|s]
	{
	try { event.srcElement.blur() } catch(e) {}
	try { 
//		var oSubmit=(window.document.getElementById('submit_button') || top.frames('WorkArea') /*&& top.frames('WorkArea').document.getElementById('submit_button')*/ || undefined)
		SaveCommand(); 
		} catch(e) {SaveCommand(undefined)/*alert('Error en catchKeys(): '+e.description)*/}
	event.keyCode=0;
	event.returnValue=false;
	cancelBubble()
	}
else if (event.altKey && sKeyCode==187) // alt + "+"
	{
	try	
		{
		if (getParent('TABLE', event.srcElement).all('CommandInsert'))
			{
			oCommand=(getParent('TABLE', event.srcElement).all('CommandInsert').length?getParent('TABLE', event.srcElement).all('CommandInsert')(0):getParent('TABLE', event.srcElement).all('CommandInsert'))
			if (getParent('TABLE', oCommand)==getParent('TABLE', event.srcElement))
				{
				oCommand.fireEvent('onclick')
				}
			}
		}
	catch(e) {alert('No se pudo ejecutar el commando insert')}
	}
else if (event.altKey && sKeyCode==189) // alt + "-"
	{
	try	
		{
		if (getParent('TR', event.srcElement).all('CommandDelete'))
			{
			oCommand=(getParent('TR', event.srcElement).all('CommandDelete').length?getParent('TR', event.srcElement).all('CommandDelete')(0):getParent('TR', event.srcElement).all('CommandDelete'))
			if (getParent('TR', oCommand)==getParent('TR', event.srcElement))
				{
				oCommand.fireEvent('onclick')
				}
			}
		}
	catch(e) {alert('No se pudo ejecutar el commando delete')}
	}
else if (event.ctrlKey && sKeyCode == 13)
	{
	try	
		{
		if (getParent('TR', event.srcElement).all('CommandUpdate'))
			{
			oCommand=(getParent('TR', event.srcElement).all('CommandUpdate').length?getParent('TR', event.srcElement).all('CommandUpdate')(0):getParent('TR', event.srcElement).all('CommandUpdate'))
			if (getParent('TR', oCommand)==getParent('TR', event.srcElement))
				{
				oCommand.fireEvent('onclick')
				}
			}
		}
	catch(e) {alert('No se pudo ejecutar el commando update')}
	}
else if (!(event.ctrlKey) && event.shiftKey && event.altKey && sKeyCode == 37) // ctrl + flecha izquierda
	{
	scrollBy(-20, 0)
	event.keyCode=0;
	event.returnValue=false;
	}
else if (!(event.ctrlKey) && event.shiftKey && event.altKey && sKeyCode == 38) // ctrl + flecha arriba
	{
	scrollBy(0, -20)
	event.keyCode=0;
	event.returnValue=false;
	}
else if (!(event.ctrlKey) && event.shiftKey && event.altKey && sKeyCode == 39) //ctrl + flecha derecha
	{
	scrollBy(20, 0)
	event.keyCode=0;
	event.returnValue=false;
	}
else if (!(event.ctrlKey) && event.shiftKey && event.altKey && sKeyCode == 40) //ctrl + flecha abajo
	{
	scrollBy(0, 20)
	event.keyCode=0;
	event.returnValue=false;
	}
else if (sKeyCode == 27 && isModalWindow) //esc
	{
    window.returnValue=undefined;
    window.close();
	}
else if (sKeyCode == 13 && event.srcElement.type && event.srcElement.type!="textarea") //enter (emula un enter como en excel (se va a la siguiente línea))
	{
	try 
		{
		objeto=event.srcElement
		sKeyCode=0
		if (objeto.tagName=='INPUT' || objeto.tagName=="TEXTAREA" || objeto.tagName=="SELECT")
			{
			celda=getParent('TD', objeto);
			indiceCelda=celda.cellIndex;
			fila=getParent('TR', objeto);
			indiceFila=fila.rowIndex;
			for (i=indiceCelda; i>=0; --i)
				{
				indiceCelda+=fila.cells(i).style.display=='none'?1:0;
				}
			tabla=getParent('TABLE', objeto);
			indiceHijo=getChildIndex(objeto);
			// esto lo hace para que en caso de que haya una celda colapsada se brinque sólo a la siguiente, si hay dos o más, emula un tab
			indiceFilaSig=indiceFila
			if (tabla.rows(indiceFila).cells.length!=tabla.rows(indiceFilaSig+(event.shiftKey?-1:1)).cells.length)
				{
				indiceFilaSig=indiceFila+(event.shiftKey?-1:1)
				}
			if ((event.shiftKey?indiceFila>=0:indiceFila<tabla.rows.length-1) && tabla.rows(indiceFila).cells.length==tabla.rows(indiceFilaSig+(event.shiftKey?-1:1)).cells.length) 
				{
				if (tabla.rows(indiceFila).cells(indiceCelda).children.length==tabla.rows(indiceFilaSig+(event.shiftKey?-1:1)).cells(indiceCelda).children.length && tabla.rows(indiceFila).cells(indiceCelda).children(indiceHijo).tagName==tabla.rows(indiceFilaSig+(event.shiftKey?-1:1)).cells(indiceCelda).children(indiceHijo).tagName)
					{
					chIndex=indiceHijo
					}
				else
					{
					for (ch=0; ch<tabla.rows(indiceFilaSig+(event.shiftKey?-1:1)).cells(indiceCelda).children.length; ++ch)
						{
						hijo=tabla.rows(indiceFilaSig+(event.shiftKey?-1:1)).cells(indiceCelda).children(ch)
						if (hijo.tagName=='INPUT' || hijo.tagName=="TEXTAREA" || hijo.tagName=="SELECT")
							{
							chIndex=ch
							ch=tabla.rows(indiceFilaSig+(event.shiftKey?-1:1)).cells(indiceCelda).children.length
							}
						}
					}
				tabla.rows(indiceFilaSig+(event.shiftKey?-1:1)).cells(indiceCelda).children(chIndex).focus()
				event.keyCode=0;
				event.returnValue=false;
				}
			else
				{
				event.keyCode=9;
				}
			}
		else
			{
			event.keyCode=9;
			}
		} catch(e) {/*alert(e.description); */event.keyCode=9;}
	}
}

function SaveCommand(oTarget)
{
//if (!(oTarget && (oTarget.name=='WorkArea' || oTarget.name=='resultados'))) oTarget=((window.parent.frames)?(window.parent.WorkArea || window.parent.resultados):undefined)
//var oTarget=(oTarget.document || oTarget)
oTarget=(oTarget || document)
if (oTarget && oTarget.frames) oTarget = oTarget.frames.WorkArea || oTarget.frames.resultados || oTarget
oTarget=(oTarget.document || oTarget || document)

if (!oTarget || $(".dataTable:not([mode='filters'])",oTarget).length==0) { alert('EL MÓDULO NO ADMITE CAMBIOS'); return false }
try { oTarget.focus() } catch(e) {alert(e.description)}
/*try
	{*/
	/*if (oTarget) 
		oTarget.Submit();
	else*/
		updateTable(oTarget);//alert('No se pueden guardar cambios')
//	} catch(e) {alert('Error en SaveCommand(): \n'+e.description)}
}

function PrintCommand(oTarget)
{
oTarget=(oTarget || window.parent.WorkArea || window.parent.resultados || window.parent); 
oTarget.focus()
window.print()
}

function toClipboard(oSource, oTarget)
{
oSource=(oSource || window.parent.WorkArea || window.parent.resultados || window.parent); 
oTarget=(oTarget || top.frames.BackgroundFrame || top.frames.transacciones)

try
	{
	oSource==undefined?oSource=(/*top.frames('transacciones') || */window.location):null;
	
//	convertViewLinks()
	
	formatFrame(oSource, oTarget)
	if (hayMoneda(oTarget))
		{
		result=confirm("Desea convertir los datos de tipo moneda a numerico para que pueda manipularlos en excel?. \n\nEste proceso puede tomar algunos segundos más")
	    if (result==true)
			{
			desformateaMoneda(oTarget)
			}
		}		
	oTarget.document.execCommand('SelectAll')
	oTarget.document.execCommand('Copy')
	oTarget.document.execCommand('Unselect')
//	retrieveViewLink()
	alert("El documento ha sido copiado a su portapeles, ahora puede pegarlo en Excel")
	}
catch(e) {alert("Ocurrió un error al momento de intentar pasar a Excel\n\nError: "+e.description)}
}





function addRow(baseRow, insertAt) //Agrega una línea y devuelve la referencia a la línea agregada
{
insertAt==undefined?insertAt=1:null;
indiceFila=baseRow.rowIndex;
var tabla=getParent('TABLE', baseRow);

new_TR=tabla.rows(indiceFila).cloneNode(true);
new_TR.id = document.uniqueID;
$(new_TR).attr("db_identity_value", "NULL")
$(new_TR).attr("db_primary_value", "NULL")
$(new_TR).removeClass('delete')
$(new_TR).toggleClass('alt')
$(new_TR).find(".commandButton").each(function(){this.src=this.src.replace(/([/\\])btn_Cancel\.gif/i, '$1btn_Delete.png')})

tabla.insertRow(indiceFila+insertAt);
tabla.rows(indiceFila+insertAt).replaceNode(new_TR);

obj_input=tabla.rows(indiceFila+insertAt).getElementsByTagName('INPUT');
for (oI=0; oI<(obj_input.length?obj_input.length:1); ++oI)
	{
	hijo=obj_input.length?obj_input(oI):obj_input
	if (hijo.type=="checkbox" || hijo.type=="radio")
		{
		if (hijo.id!='identifier')
			{
			hijo.checked=false;
			}
		else
			{
			hijo.value='';
			}
		}
	else if (hijo.type=="text" || hijo.type=="password" || hijo.type=="hidden" || hijo.type=="viewlink")
		{
		if (hijo.getAttribute('defValue'))
			{
			hijo.defaultValue=hijo.getAttribute('defValue')
			hijo.value=hijo.getAttribute('defValue');
			hijo.fireEvent('onblur');
			}
		else
			{
			hijo.defaultValue=''
			hijo.value=''
			}
		}
	else
		{
		//alert('Elemento no contemplado ('+hijo.type+'), se copiaron los valores')
		}
	}
obj_txt_area=tabla.rows(indiceFila+insertAt).getElementsByTagName('TEXTAREA')
for (oTA=0; oTA<(obj_txt_area.length?obj_txt_area.length:1); ++oTA)
	{
	hijo=obj_txt_area.length?obj_txt_area(oTA):obj_txt_area
	hijo.value='';
	}
/*
obj_slct=tabla.rows(indiceFila+1).getElementsByTagName('SELECT')
for (oS=0; oS<(obj_slct.length && obj_slct(0).tagName!='OPTION'?obj_slct.length:1); ++oS)
	{
	hijo=obj_slct.length && obj_slct(0).tagName!='OPTION'?obj_slct(oS):obj_slct;
	hijo(0).selected=true;
	}*/

return tabla.rows(indiceFila+insertAt)
}

function unFreezeHeader()
{
try 
	{
	$('TABLE.dataTable.gridView THEAD TR, TABLE.grid THEAD TR').css('position','static')
	}
catch (e) {status="Descongelando encabezado... Falló"}	
}

var scrollInterval=undefined;
function scrollUnaVez()
{
if (scrollInterval) {
	window.clearTimeout(scrollInterval); scrollInterval=undefined;
} 

scrollInterval=window.setTimeout("floatHeaders();", .5);
}

function freezeFlotante(oContext)
{
if (scrollInterval) return
var oContext=(oContext||$('.freeze'))
var bodyScrollLeft=document.body.scrollLeft
var bodyMarginLeft=parseInt(jQuery(document.body).css("margin-left"));
$(oContext).each(function(){
	this.style.pixelLeft=bodyScrollLeft-(bodyScrollLeft>0?bodyMarginLeft:0);
})//.css("position", "relative").css("z-index", "998")
/**/
}

var cPageHeaders
var oTable
function floatHeaders(oContext)
{
if (!scrollInterval) return
window.clearTimeout(scrollInterval); scrollInterval=undefined;
var oContext=(oContext||cPageHeaders)
var dataTable=oTable
cancelar_floatHeaders=false;
var bodyMarginTop=parseInt(jQuery(document.body).css("margin-top"));
var bodyScrollTop=document.body.scrollTop
$(oContext).css("z-index", "999"/*function(){return $(this).css("z-index")+900}*/).each(function(){
	this.style.pixelTop=bodyScrollTop-(bodyScrollTop>0?bodyMarginTop:0);
	freezeFlotante($('.rowNumberCell,.freeze', this))
})
try
	{
	primer_row=parseInt(document.body.scrollTop*dataTable.rows.length/dataTable.offsetHeight)
	if (dataTable.clientWidth>document.body.clientWidth || alinear || dataTable.all.tags('SELECT'))
		{
		while ( primer_row>0 && (cPageHeaders.find(dataTable.rows(primer_row)).length>0 || parseFloat(dataTable.rows(primer_row).offsetTop)>parseFloat(document.body.scrollTop)-15 ) )
			{
//			status='primer_row: '+primer_row
			--primer_row
			}
		
		while ( primer_row<dataTable.rows.length && (cPageHeaders.find(dataTable.rows(primer_row)).length>0 || parseFloat(dataTable.rows(primer_row).offsetTop)<parseFloat(document.body.scrollTop)-15 ) )
			{
//			status='primer_row: '+primer_row
			++primer_row
			}
		ultima_row=primer_row 
		while ( ultima_row<dataTable.rows.length && parseFloat(dataTable.rows(ultima_row).offsetTop)<(parseFloat(document.body.scrollTop)+parseFloat(document.body.clientHeight)) )
			{
//			status='ultima_row: '+ultima_row
			if (cancelar_floatHeaders)
				{
				cancelar_floatHeaders=false
				return;
				}
			freezeFlotante($('.freeze', dataTable.rows(ultima_row)));
			cll_select=dataTable.rows(ultima_row).all.tags('SELECT');
			num_reg=(cll_select && cll_select.length>0?(cll_select(0).tagName!='OPTION'?cll_select.length:1):0);
			partes=10;
			num=Math.ceil(num_reg/partes);
			for (S=0; S<num_reg; ++S)
				{
//				if (S%num==0 || S==num_reg-1) status='Modificando Objetos... '+Math.round((S+1)*100/num_reg)+'%';
				obj_select=(cll_select(0).tagName!='OPTION'?cll_select(S):cll_select);
//				alert(ultima_row+': '+(parseFloat(dataTable.rows(ultima_row).offsetTop)+'>'+(parseFloat(header_row.offsetTop)+parseFloat(header_row.clientHeight) ) ) )
				if (parseFloat(dataTable.rows(ultima_row).offsetTop)+15>(parseFloat(header_row.offsetTop)+parseFloat(header_row.clientHeight)) )
					{
					obj_select.style.visibility='visible';
					obj_select.fireEvent('onmouseover')
					}
				else
					{
					obj_select.style.visibility=(getParent('TR', getParent('TABLE', obj_select)).id=="header"?'visible':'hidden')
					}
				}
			++ultima_row
			}
		}
	}
catch(e) {}
}


/*funciones de Fechas -->*/
function getdate()
{
var oDate = new Date()
return dateString(oDate)
}

function firstDayOfMonth(dDate)
{
return dateAdd("d", -Fecha(dDate).getDate()+1, dDate)
}

function lastDayOfMonth(dDate)
{
return dateAdd("d", -1, dateAdd("m", 1, firstDayOfMonth(dDate)))
}
/*<-- funciones de Fechas*/


/*funciones de Login -->*/
function Login()
{
	this.resetData = function() {
		this.result = undefined;
		this.URL="../App_Layout/Login.asp"
		this.height="230"
		this.weight="490"
	};
	
	this.resetFunctions = function() {
  		this.onSuccess = function() { };
		this.onCancel = function() {
			}
  		this.onError = function() { };
		this.onFail = function() { };
	};

	this.reset = function() {
		this.resetFunctions();
		this.resetData();
	};

	this.go = function()
		{
		var myObject = new Object();
		try { var oResult=window.showModalDialog(this.URL+"?sid="+Math.random(), myObject, "help:no; status=yes; resizable:yes; unadorned:yes; center:yes; dialogHeight:"+this.height+"px; dialogWidth:"+this.weight+"px;"); } catch(e) {}
		this.result=oResult
		if (this.result==undefined)
			{
			this.onCancel()
			}
		else
			{
			if (eval(this.result))
				{
				try {this.onSuccess()} catch(e) {alert(e.description)}
				}
			else
				{
				try {this.onFail()} catch(e) {alert(e.description)}
				}
			location.href=location.href
			}
		}

	this.logout = function()
		{
		if (!confirm("Confirma que desea salir del sistema?")) return false
		ajaxRequest("../Scripts/logout.asp", document.body, undefined, false, 'POST')
		this.onLogout()
		//window.close()
		
/*		if (this.result==undefined)
			{
			this.onCancel()
			window.close()
			}
		else
			{
			if (eval(this.result))
				{
				try {this.onSuccess()} catch(e) {alert(e.description)}
				}
			else
				{
				try {this.onFail()} catch(e) {alert(e.description)}
				}
			location.href=location.href
			}*/
		}
		
	this.onLogout = function()
	{
	if ((typeof self.parent.window.dialogArguments)=='object') self.parent.close();
	refreshPage(top.parent);
		//self.parent.close()
	}
	
	this.reset();
}
/*<-- funciones de Login */


function getDBColumnValue(elemento)
{
var sReturnValue=String(( (eval( ( elemento.getAttribute("db_column_value") || '').replace(/this/gm, "elemento"))) || 
(elemento.tagName=='INPUT' && elemento.type=="checkbox" && elemento.id!='identifier' && !(elemento.checked))?'':getVal(elemento))).replace(/'/g, "''");
//if (!esVacio(sReturnValue) && (like(this.className, 'texto, fecha') || (this.className=='' && !isNumber(sReturnValue)) && !(sReturnValue.toUpperCase()=='GETDATE()')) ) sReturnValue="'"+sReturnValue+"'";

if (!esVacio(sReturnValue) && ($(elemento).hasClass("text") || !($(elemento).is(".numero, .porcentaje, .percent, .moneda") || sReturnValue.toUpperCase()=='GETDATE()' || $(elemento).is(".catalog, :select") && !isNumber(sReturnValue) && sReturnValue=='NULL') )) sReturnValue="'"+sReturnValue+"'";
if (elemento.type=="checkbox" && !(elemento.checked)) sReturnValue=elemento.getAttribute("uncheckedValue");//'1/1/1900';
if ($(elemento).hasClass('fecha') && (esVacio(sReturnValue) || sReturnValue=='1/1/1900')) sReturnValue='NULL';//'1/1/1900';
if (isNullOrEmpty(sReturnValue)) sReturnValue='NULL';
////if (sReturnValue=='NULL' && !isNullOrEmpty(elemento.DBDefaultValue)) sReturnValue=elemento.DBDefaultValue;
return sReturnValue;//esVacio(sReturnValue)?'NULL':sReturnValue;
}

function createFilterXML(jTable, oContext)
{
var oContext=(oContext || document)
if (jTable==undefined) jTable=$(".dataTable",oContext)//.not(".dataTable .dataTable")
//jTable.find(".dataTable").css("background-color", "red")

//alert('Tables: '+$("[db_identity_value]", jTable).length)
var sUpdateXML = ""
if (jTable.length==0) return ''
var oTable=jTable.get(0);

/*if (confirm(oTable.db_table_name+' ('+oTable.id+') detener?')) return '';*/
$("[db_identity_value]") //recupera todos los contenedores que tienen la propiedad db_identity_value
.filter(function(){ return $(this).closest(".dataTable").get(0)==oTable} )
.each(function(index,oIdentity){
	var sForeignTable = ''
	var xmlInputCollection = [  ]
	if (!($(this).is(".delete"))) {
		var oChildren=$("[parent_object='"+this.id+"']")
		if (oChildren.length>0) oChildren.each(function(){sForeignTable=trimAll(createFilterXML($(this).find(".dataTable").andSelf().filter(".dataTable"))); if (sForeignTable!=''); xmlInputCollection.push(sForeignTable)})
		var oChildren=$(".dataTable", this)
		if (oChildren.length>0) oChildren.each(function(){sForeignTable=trimAll(createFilterXML($(this).find(".dataTable").andSelf().filter(".dataTable"))); if (sForeignTable!=''); xmlInputCollection.push(sForeignTable)})
	}

	var oInputCollection=$(".dataField", this).filter(function(){return $(this).closest(".dataTable").get(0)==oTable && (
		($(this).closest("TR").find("[name='useFilter']").get(0).checked && $(".changed", oIdentity).length>0) && (
		$(this).is('.required') && $("[isSubmitable='true']",this).filter(function(){return oIdentity.db_identity_value=='NULL' || getDBColumnValue(this)=='NULL'}).length>0 ||
		$("[isSubmitable='true']",this)/*.filter(function(){return $(this).is(".changed, [type='hidden']")}).length>0*/  /*eval(this.isSubmitable)*//* && (eval(this.hasChanged) || $(this).is('.required') && isNullOrEmpty(this) || this.type && this.type=='hidden')*/
		))});
	//oInputCollection.css("background-color", "green")
	if (!(
		$(this).is(".delete") || xmlInputCollection.length>0 || oInputCollection.length>0
	)) return ''; 

	if (!($(this).is(".delete")))
		{
		oInputCollection.each(function(){
			try { 
				var var_column_value=""
				$("[isSubmitable='true']",this).each(function(){var_column_value+=tagElement('dataValue',getDBColumnValue(this))});
				//if (!esVacio(var_column_value) && (like(this.className, 'texto, fecha') || (this.className=='' && !isNumber(var_column_value)) && !(var_column_value.toUpperCase()=='GETDATE()')) ) var_column_value="'"+var_column_value+"'";
				xmlInputCollection.push(tagElement('dataField', tagElement('filterGroup', var_column_value, {"operator":(this.filterOperator||"=")})/*getVal(this)*/, {
					"name":(this.dataField||this.name),
					"hasError":(
						$(this).is('.required') && var_column_value=='NULL'?"true":"false"
						), 
					"filterMode":this.filterMode?this.filterMode:"filter"
					})) 
				} catch(e) {alert(e.description)}
			});
		}
	sUpdateXML+=tagElement('filterGroup', xmlInputCollection.join(' '), {
		"operator":"AND"
		})
	})

var dataTableAttribs = {
		"name":oTable.db_table_name,
		"identityKey":oTable.db_identity_key,
		"primaryKey":oTable.db_primary_key
		}
if (oTable.db_foreign_key) dataTableAttribs["foreignKey"] = oTable.db_foreign_key
//alert(oTable.db_table_name+': '+sUpdateXML)
sUpdateXML=(sUpdateXML!='')?tagElement('dataTable', sUpdateXML, dataTableAttribs):'';

//$(":input", jTable).css("background-color", "");
return sUpdateXML
}

function createUpdateXML(jTable, oContext)
{
var oContext=(oContext || document);
if (jTable==undefined && $(oContext).is(".dataTable")) jTable=$(oContext)//.not(".dataTable .dataTable")
if (jTable==undefined) jTable=$(".dataTable",oContext)//.not(".dataTable .dataTable")
//jTable.find(".dataTable").css("background-color", "red")

//alert('Tables: '+$("[db_identity_value]", jTable).length)
var sUpdateXML = ""
if (jTable.length==0) return ''
var oTable=jTable.get(0);

/*if (confirm(oTable.db_table_name+' ('+oTable.id+') detener?')) return '';*/
$("[db_identity_value]") //recupera todos los contenedores que tienen la propiedad db_identity_value
.filter(function(){ return $(this).closest(".dataTable").get(0)==oTable} )
.each(function(index,oIdentity){
	var sForeignTable = ''
	var xmlInputCollection = [  ]
	if (!($(this).is(".delete"))) {
		var oChildren=$("[parent_object='"+this.id+"']")
		if (oChildren.length>0) oChildren.each(function(){sForeignTable=trimAll(createUpdateXML($(this).find(".dataTable").andSelf().filter(".dataTable"))); if (sForeignTable!=''); xmlInputCollection.push(sForeignTable)})
		var oChildren=$(".dataTable", this)
		if (oChildren.length>0) oChildren.each(function(){sForeignTable=trimAll(createUpdateXML($(this).find(".dataTable").andSelf().filter(".dataTable"))); if (sForeignTable!=''); xmlInputCollection.push(sForeignTable)})
	}

	var oInputCollection=$(".dataField", this).filter(function(){return $(this).closest(".dataTable").get(0)==oTable && (
		$(".changed", oIdentity).length>0 && (
		$(this).is('.required') && $("[isSubmitable='true']",this).filter(function(){return oIdentity.db_identity_value=='NULL' || getDBColumnValue(this)=='NULL'}).length>0 ||
		$("[isSubmitable='true']",this).filter(function(){return oIdentity.db_identity_value=='NULL' || $(this).is(".changed, [type='hidden'], .formula")}).length>0  /*eval(this.isSubmitable)*//* && (eval(this.hasChanged) || $(this).is('.required') && isNullOrEmpty(this) || this.type && this.type=='hidden')*/
		))});
	//oInputCollection.css("background-color", "green")
	if (!(
		$(this).is(".delete") || xmlInputCollection.length>0 || oInputCollection.length>0
	)) return ''; 

	if (!($(this).is(".delete")))
		{
		oInputCollection.each(function(){
			try { 
				/*if (eval(this.isSubmitable) && (eval(this.hasChanged) || this.type && this.type=='hidden'))
					{
					//alert(this.name+': '+this.isSubmitable)*/
					var var_column_value=""
					$("[isSubmitable='true']",this).each(function(){/*alert(this.outerHTML+': '+getDBColumnValue(this)); */var_column_value+=getDBColumnValue(this)});
					//alert(this.get(0).name+': '+var_column_value)
					xmlInputCollection.push(tagElement('dataField', URLEncode(var_column_value)/*getVal(this)*/, {
						"name":(this.dataField||this.name),
						"sourceObjectId":this.id,
						"hasError":(
							$(this).is('.required') && var_column_value=='NULL'?"true":"false"
							)
						})) 
					//}
				} catch(e) {alert(e.description)}
			});
		}
	sUpdateXML+=tagElement($(this).is(".delete")?'deleteRow':'dataRow', xmlInputCollection.join(' '), {
		"identityValue":oIdentity.db_identity_value,
		"primaryValue":oIdentity.db_primary_value,
		"sourceObjectId":oIdentity.id
		})
	})

var dataTableAttribs = {
		"name":oTable.db_table_name,
		"identityKey":oTable.db_identity_key,
		"primaryKey":oTable.db_primary_key
		}
if (oTable.db_foreign_key) dataTableAttribs["foreignKey"] = oTable.db_foreign_key
//alert(oTable.db_table_name+': '+sUpdateXML)
sUpdateXML=(sUpdateXML!='')?tagElement('dataTable', sUpdateXML, dataTableAttribs):'';

//$(":input", jTable).css("background-color", "");
return sUpdateXML
}

function updateTable(oContext)
{
xmlData=createUpdateXML(undefined, oContext);
//alert(xmlData)
updateData(xmlData, oContext);
//var oFile=load("../Templates/updateResults.xsl");
//showModal(xmlData.replace(/</g,'&lt;'));
}

function updateData(xmlData, oContext)
{
if (trimAll(xmlData)=='') 
	{
	showModal("<strong>NO HAY CAMBIOS QUE GUARDAR</strong>")
	return false;
	}
var oXML=LoadXMLString(xmlData);
//alert(oXML.xml)
//showModal(oXML.xml.replace(/</g,'&lt;'))
eval(transformXML(oXML, loadXMLFile("../Templates/validateForm.xsl").responseXML).replace(/</g,'&lt;'))
if (oXML.selectNodes("//*[@hasError='true']").length>0) 
	{
	showModal("<strong>TODAVÍA HAY CAMPOS REQUERIDOS SIN LLENAR</strong>")
	}
else
	{
	//showModal(xmlData.replace(/</g,'&lt;'))
	uploadXMLFile("../Scripts/ajax_updateDB.asp", xmlData, oContext)
	}
}

function xmlDocument()
{
var xmlDoc
if (window.DOMParser)
  {
  parser=new DOMParser();
  }
else // Internet Explorer
  {
  xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
  xmlDoc.async="false";
  }
return xmlDoc;
}

function parseXML(xmlString)
{
if (window.DOMParser)
  {
  parser=new DOMParser();
  xmlDoc=parser.parseFromString(xmlString,"text/xml");
  }
else // Internet Explorer
  {
  xmlDoc=xmlDocument();
  xmlDoc.loadXML(xmlString); 
  }
  //alert('xmlString: '+xmlString)
  //alert('xmlDoc('+xmlDoc.selectNodes("*/*").length+'): '+xmlDoc.xml)
  return xmlDoc 
}

function LoadXMLString(xmlString) 
{   
return parseXML(xmlString)
} 


function transformXML(xml, xsl)
{
var result = undefined
if (window.ActiveXObject)
  	{
	result = xml.transformNode(xsl)
	}
else if (document.implementation && document.implementation.createDocument)
	{
	var xsltProcessor=new XSLTProcessor();
	xsltProcessor.importStylesheet(xsl);
	result = xsltProcessor.transformToFragment(xml,document);
	}
return result
}
/*------> */
/*codigo obtenido de: http://oreilly.com/pub/h/2127*/
function tagElement(name,content,attributes){
    var att_str = ''
    if (attributes) { // tests false if this arg is missing!
        att_str = formatAttributes(attributes)
    }
    var xml
    if (!content){
        xml='<' + name + att_str + '/>'
    }
    else {
        xml='<' + name + att_str + '>' + content + '</'+name+'>'
    }
    return xml
}
var APOS = "'"; QUOTE = '"'
var ESCAPED_QUOTE = {  }
ESCAPED_QUOTE[QUOTE] = '&quot;'
ESCAPED_QUOTE[APOS] = '&apos;'
   
/*
   Format a dictionary of attributes into a string suitable
   for inserting into the start tag of an element.  Be smart
   about escaping embedded quotes in the attribute values.
*/
function formatAttributes(attributes) {
    var att_value
    var apos_pos, quot_pos
    var use_quote, escape, quote_to_escape
    var att_str
    var re
    var result = ''
   
    for (var att in attributes) {
        att_value = attributes[att]
        
        // Find first quote marks if any
        apos_pos = att_value.indexOf(APOS)
        quot_pos = att_value.indexOf(QUOTE)
       
        // Determine which quote type to use around 
        // the attribute value
        if (apos_pos == -1 && quot_pos == -1) {
            att_str = ' ' + att + '="' + att_value +  '"'
            result += att_str
            continue
        }
        
        // Prefer the single quote unless forced to use double
        if (quot_pos != -1 && quot_pos < apos_pos) {
            use_quote = APOS
        }
        else {
            use_quote = QUOTE
        }
   
        // Figure out which kind of quote to escape
        // Use nice dictionary instead of yucky if-else nests
        escape = ESCAPED_QUOTE[use_quote]
        
        // Escape only the right kind of quote
        re = new RegExp(use_quote,'g')
        att_str = ' ' + att + '=' + use_quote + 
            att_value.replace(re, escape) + use_quote
        result += att_str
    }
    return result
}
/*<------ */

function loadContent(oContext)
{
var sXSLFile=""
if ($(oContext).hasClass('selectBox'))
	{
	sXMLFile="../Scripts/xmlCatalogOptions.asp?1=1"
	}
else if ($(oContext).hasClass("catalog"))
	{
	sXMLFile="../Scripts/xmlCatalogOptions.asp?1=1"
	if (oContext.nodeName.toLowerCase()=='select')
		{
		sXSLFile="../Templates/ajaxDropDownList";
		}
	else
		{
		sXSLFile="../Templates/CheckBoxList";
		}
	}
else
	{
	sXMLFile="request.asp?1=1"
	if (oContext.fullPath) sXMLFile+="&fullPath="+oContext.fullPath;
	if (oContext.catalogName) sXMLFile+="&catalogName="+oContext.catalogName;
	if (oContext.pageIndex) sXMLFile+="&pageIndex="+oContext.pageIndex;
	if (oContext.pageSize) sXMLFile+="&pageSize="+oContext.pageSize;
	if (oContext.pageSize) sXMLFile+="&maxRecords="+oContext.pageSize;
	if (oContext.mode) sXMLFile+="&mode="+oContext.mode;
	if (oContext.filter) sXMLFile+="&filters="+oContext.filter;
	if (oContext.parameters) sXMLFile+="&parameters="+oContext.parameters;
	if (oContext.viewMode) sXMLFile+="&viewMode="+oContext.viewMode;
	}

if (oContext.catalogName) 
	{
	sXMLFile+="&catalogName="+oContext.catalogName;
	sXMLFile+="&dataValue="+oContext.dataValue;
	sXMLFile+="&dataText="+oContext.dataText;
	sXMLFile+="&OptNull="+oContext.getAttribute("opt_null");
	sXMLFile+="&OptAll="+oContext.getAttribute("opt_all");
	sXMLFile+="&OptChoose="+oContext.getAttribute("opt_choose");
	if (oContext.filterString) sXMLFile+="&filters="+oContext.filterString;
	//alert(sXMLFile)
	oContext.onCompletion="isUpdated=true;"
	}
/*var sControlType=(oTarget.className || oTarget.nodeName.toLowerCase())
switch (sControlType) {
	case "input": 
	case "textarea":
		break;
	case "catalog": 
		sXMLFile="../Scripts/xmlCatalogOptions.asp?1=1"
		if (oTarget.catalogName) 
			{
			sXMLFile+="&catalogName="+oTarget.catalogName;
			sXMLFile+="&dataValue="+oTarget.dataValue;
			sXMLFile+="&dataText="+oTarget.dataText;
			sXMLFile+="&OptNull="+oTarget.getAttribute("opt_null");
			if (oTarget.filterString) sXMLFile+="&filters="+oTarget.filterString;
			//alert(sXMLFile)
			oTarget.onCompletion="isUpdated=true;"
			}
		break;
	default:
		sXMLFile="request.asp?1=1"
		if (oTarget.fullPath) sXMLFile+="&fullPath="+oTarget.fullPath;
		if (oTarget.catalogName) sXMLFile+="&catalogName="+oTarget.catalogName;
		if (oTarget.pageIndex) sXMLFile+="&pageIndex="+oTarget.pageIndex;
		if (oTarget.pageSize) sXMLFile+="&pageSize="+oTarget.pageSize;
		if (oTarget.pageSize) sXMLFile+="&maxRecords="+oTarget.pageSize;
		if (oTarget.mode) sXMLFile+="&mode="+oTarget.mode;
		if (oTarget.filter) sXMLFile+="&filters="+oTarget.filter;
		if (oTarget.parameters) sXMLFile+="&parameters="+oTarget.parameters;
		if (oTarget.viewMode) sXMLFile+="&viewMode="+oTarget.viewMode;
		break;
	}*/
	loadXMLFile(sXMLFile, sXSLFile, oContext)
/*//WARNING: Cuidado al utilizar el objeto this
sURL=eval(oTarget.getAttribute('ContentURL').replace(/this/gm, "oTarget"));
ajaxRequest(sURL, oTarget, false, false, 'GET', true);*/
}

function DataLoad(params)
{
	if (!params) params = {}
	this.target = (params["target"] || null);
	this.dataSource = (params["dataSource"] || null);
	this.formatSource = (params["formatSource"] || null);
	
}

function contextLoader(oSource, dataSource, settings)
{
	if (!settings) settings = {}
	var oData=new AjaxLoader(dataSource, settings)
	oData.onLoading = function() {
		oSource.insertAdjacentElement("afterEnd", this.advise);
		oSource.AdviseImage=this.advise;
		if (oSource.onLoading) eval(oSource.onLoading)
	}

	oData.onLoaded = function() {
		if (oSource.onLoaded) eval(oSource.onLoaded);
	}

	oData.onCompletion = function() {
		if (oSource.onCompletion) eval(oSource.onCompletion);
	}
	
	oData.onSuccess = function() {
		if (this.XMLDocument)
			{
			oSource.DataContext = this.XMLDocument
			}
		else if (this.script)
			{
			with (oSource)
				{
				eval(this.script)
				}
			}
		else if (this.HTMLDocument && oSource.innerHTML)
			{
			oSource.innerHTML=this.HTMLDocument
			}
	if (oSource.onSuccess) eval(oSource.onSuccess);
	}
	oData.load();
	/*
	var oLoader = new AjaxLoader({
		target:oSource, 
		dataSource:new Load("../Scripts/xmlDataIsland.asp")
	});*/

}

function showModal(sHTML, settings)
{
	if (!settings) settings={maxHeight:400,maxWidth:600}
	/*if (!settings["onClose"]) settings["onClose"]= function (dialog) {
			dialog.data.fadeOut('fast', function () {
				dialog.container.hide('fast', function () {
					dialog.overlay.fadeOut('fast', function () {
						$.modal.close();
					});
				});
			});
		}
	if (!settings["onOpen"]) settings["onOpen"]= function (dialog) {
			dialog.overlay.fadeIn('fast', function () {
				dialog.data.hide();
				dialog.container.fadeIn('fast', function () {
					dialog.data.slideDown('fast');
				});
			});
		}*/
	var oModal=document.createElement('<div class="modalDialog"></div>')
	oModal.innerHTML=sHTML
	$(oModal).modal(settings)
}

function openSimpleModalPage(sLink, settings)
{
return openLink(sLink, true, false, true, settings); 
}

function openModalPage(sLink)
{
return openLink(sLink, true, false); 
}

function openInsertPage()
{
if (!(arguments.length))
	{
	}
else if ((typeof arguments[0])=='object')
	{
	elem_obj=arguments[0];
	total_elem=total_elem+(elem_obj.length?elem_obj.length:1)
	}
else
	{
	sLink=arguments[0]
	}
/*if ( eval("paginaActual().search(/"+sLink.replace('/', '\\').replace('\.', '\\.')+"/g)")!=-1 )
	{
	openLink(sLink, false, true); 
	}
else
	{*/
	registro=openLink(sLink, true, false); 
	if (registro!=undefined && registro.script)
		{
		eval(registro.script);
		}
//	}
}

function openEditPage(sLink)
{
sKeyCode=event.keyCode;
sLink=updateURLString(sLink, "mode", "edit")
if ( eval("paginaActual().search(/"+sLink.replace(/(\\|\/)/g, '\\$&')+"/g)")!=-1 )
	{
	openLink(sLink, false, true); 
	}
else
	{
	registro=openLink(sLink, true, false); 
	if (registro!=undefined && registro.script)
		{
		eval(registro.script);
		}
	}
}

function openLink(sLink, bPopUp, bReplace, bSimple, settings)
{
if (!settings) settings = {}
var bSimple = (bSimple || false)
if (bPopUp == undefined) bPopUp = true;
bReplace==undefined?bReplace=true:null;

if (!bPopUp)
	{
	if (bReplace)
		location.replace(sLink);
	else
		window.location=(sLink);
	}
else
	{
	var myObject = new Object();
	myObject.pageURL = /*(sLink.search(/^http:/gi)!=-1?'':rootFolder)+*/sLink.replace(/^request.asp/i,'../Templates/request.asp')+(sLink.indexOf("?")!=-1?"&sid="+Math.random():"");
	var result=window.showModalDialog((bSimple?"../App_Layout/SimpleModalInterface.asp":"../App_Layout/ModalInterface.asp"), myObject, "help:no; status=yes; resizable:yes; dialogHeight:"+(settings["height"] || String(bSimple?110:(document.body.offsetHeight+30)))+"px; dialogWidth:"+(settings["width"] || String(bSimple?450:(document.body.offsetWidth+6)))+"px; dialogLeft:114px; dialogTop:160px; ");
	if (result!=undefined && !esVacio(result))
		{
		return result;
		}
	else
		{
		return;
		}
	}
}




function isEmpty(string_or_object)
{
var sValue=trimAll(getVal(string_or_object))
return (sValue=='')
}

function isNullOrEmpty(string_or_object)
{
var sValue=trimAll(getVal(string_or_object))
return (sValue=='' || sValue==null || sValue==undefined);
}

function getVal(objeto)
{
if (!objeto) return '';
var valor_objeto='';
if ((typeof objeto)=='object')
	{
	if ($(objeto).is('.texto, .text'))
		{
		valor_objeto=trimAll( objeto.value!=undefined?objeto.value:(objeto.innerText!=undefined?objeto.innerText:objeto) );
		return valor_objeto;
		}
	else if (objeto.length && objeto(0).nodeName.toLowerCase()=='input' && (objeto(0).type=="radio" || objeto(0).type=="checkbox" ))
		{
		for (s=0; s<objeto.length; ++s)
			{
			valor_objeto+=(objeto(s).checked?(valor_objeto!=''?',': '')+(objeto(s).value):'')
			}
		}
	else if (objeto.options && objeto.nodeName.toLowerCase()=='select')
		{
		for (s=0; s<objeto.options.length; ++s)
			{
			valor_objeto+=(objeto.options(s).selected?(valor_objeto!=''?', ': '')+(objeto.className=='catalogo' && (objeto.value.toUpperCase()=='TODOS' || objeto.value.toUpperCase()=='TODAS')?'all':objeto.options(s).value):'')
			}
		}
	else if (objeto.length)
		{
		return objeto
		}
	else if (objeto.nodeName.toLowerCase()=='input' && objeto.type=="checkbox" && objeto.id!='identifier')
		{
		valor_objeto=(objeto.checked || objeto.DefaultIfUnchecked && eval(objeto.DefaultIfUnchecked))?objeto.value:'';
		}
	else
		{
		valor_objeto=trimAll( objeto.value!=undefined?objeto.value:(objeto.innerText!=undefined?objeto.innerText:objeto) );
		}
	}
else
	{
	valor_objeto=objeto
	}
//	alert(findCharPos(trimAll(valor_objeto), ' '))
	if (isDateType(valor_objeto)) valor_objeto=fillDate(valor_objeto);
	if (isNumericOrMoney(valor_objeto) || valor_objeto.isPercent()) valor_objeto=unformat_currency(valor_objeto);
	if (isNumber(valor_objeto) && !esVacio(valor_objeto)) valor_objeto=parseFloat(valor_objeto)
	
return valor_objeto;
}

function isNumericOrMoney(sValue)
{
return (String(sValue).search(sCurrencyPath)!=-1)
}




/* funciones TRIM obtenidos de: http://www.aspdev.org/articles/javascript-trim/*/
function leftTrim(sString) 
{
sString=String(sString)
while (sString.substring(0,1) == ' ')
	{
	sString = sString.substring(1, sString.length);
	}
return sString;
}

function rightTrim(sString) 
{
sString=String(sString)
while (sString.substring(sString.length-1, sString.length) == ' ')
	{
	sString = sString.substring(0,sString.length-1);
	}
return sString;
}

function trimAll(sString) 
{
sString=String(sString)
while (sString.substring(0,1) == ' ')
	{
	sString = sString.substring(1, sString.length);
	}
while (sString.substring(sString.length-1, sString.length) == ' ')
	{
	sString = sString.substring(0,sString.length-1);
	}
return sString;
//return sString.replace(/\s+$/, '').replace(/^\s+/, '')
}


function rtrim(sString) 
{
sString=String(sString)
while (sString.substring(sString.length-1, sString.length) == ' ')
	{
	sString = sString.substring(0,sString.length-1);
	}
return sString;
}


function ltrim(sString) 
{
sString=String(sString)
while (sString.substring(0,1) == ' ')
	{
	sString = sString.substring(1, sString.length);
	}
return sString;
}


function fillCombo(oSelectBox)
{
if (!(oSelectBox.DataContext)) return;
var oInput=oSelectBox.textbox
var oSelect=oSelectBox.dropdownlist
var oXML=oSelectBox.DataContext
oXML.setProperty("SelectionLanguage", "XPath"); 
try { oXML.selectSingleNode('/options').setAttribute('searchText',oInput.value) } catch(e) {}
try { oXML.selectSingleNode('/options').setAttribute('value',getVal(oSelectBox.value)) } catch(e) {}
with (oSelect)
	{
	eval(transformXML(oXML, selectBox_stylesheet))
	}	
//alert(oInput.value+'\n\n'+oXML.selectNodes("//option[starts-with(@text,'"+oInput.value.toUpperCase()+"')]").length+'\n\n'+oInput.xml)

}

function OnPropertyChangeSafe(oElement, oSrcElement)
{
var oSrcElement=(oSrcElement|event.srcElement)
return ( $(oElement).is(':input') && !( oSrcElement==oElement || oSrcElement!=oElement && ((oElement.name || oElement.id || true)!=(oSrcElement.name || oSrcElement.id || true)) )) 
}


function AjaxLoader(file, settings) {
	var element = this
	if (!settings) settings = {}
	this.xmlhttp = null;

	this.resetData = function() {
	
		this.requestedFile = file;
		this.method = (settings["method"] || "POST");
		this.argumentSeparator = (settings["argumentSeparator"] || "&");
		this.URLString = (settings["URLString"] || "");
		this.encodeURIString = (settings["encodeURIString"]!=undefined?settings["encodeURIString"]:true);
		//this.context = (settings["context"] || null);
		this.vars = (settings["vars"] || new Object());
		this.async = (settings["async"]!=undefined?settings["async"]:true);
		this.status = undefined;
		if (this.advise) element.advise.removeNode(true); 
		this.advise = null;
		this.responseStatus = new Array(2);
		
		this.document = undefined;

		this.XMLDocument = undefined;
		this.HTMLDocument = undefined;
		this.script = undefined;
  	};
	
	this.getResultType = function() { return (element.XMLDocument?'xml':	(element.HTMLDocument?'html':	(element.script?'script' : undefined)) ) }
	
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
		
		var originalURL=this.requestedFile
		var urlName=this.requestedFile.match(/(.*?)(?=\?)/);
		if (urlName==null)
			{
			urlName=this.requestedFile
			}
		else
			{
			this.requestedFile=urlName[0]
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
	
	this.load = function(xmlData) {
		if (this.failed) {
			this.onFail();
		} else {
			this.createURLString();
			/*if (this.id) {
				this.context = document.getElementById(this.id);
			}*/
			if (this.xmlhttp) {
				var element = this;
				var url_post
				if (xmlData) {
					url_post=xmlData;
					this.xmlhttp.open("POST", this.requestedFile, this.async);
					this.xmlhttp.setRequestHeader("Content-Type", "text/xml")
				} else if (this.method.toUpperCase() == "POST") {
					url_post=this.URLString;
					//url_post=encodeURI(url_post)
					this.xmlhttp.open("POST", this.requestedFile, this.async);
					this.xmlhttp.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
				} else {
					url_post=null;
					var totalurlstring = this.requestedFile + '?' + this.URLString;
					this.xmlhttp.open(this.method, totalurlstring, this.async);
					/*try {
						this.xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
					} catch (e) { }*/
				}
				
				this.xmlhttp.onreadystatechange = function() {
					switch (element.xmlhttp.readyState) {
					case 1:
						element.status = 'loading';
						if (!(element.advise))
							{
							var oWorking=document.createElement('<img id="img_buscando" src="../../../../Images/Advise/in_progress.gif" alt="TRABAJANDO..." width="16" height="16" border="0" style="position:\'absolute\'" onMouseOver="/*this.removeNode(true);*/">')
							element.advise=oWorking
							}
						element.onLoading();
						break;
					case 2:
						element.status = 'loaded';
						element.onLoaded();
						break;
					case 3:
						element.status = 'interactive';
						element.onInteractive();
						break;
					case 4:
						element.status = 'complete';
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

						if (element.document.toUpperCase().indexOf("<HTML")!=-1)
							{
							element.HTMLDocument=element.document;
							}
						else if (element.document.indexOf("<?xml ")>=0)
							{
							element.XMLDocument=element.responseXML
							}
						else
							{
							element.script=element.document;
							}
					
					if (!(element.document.indexOf("error '")!=-1) && element.responseStatus[0] == "200") {
						element.advise.removeNode(true);
						element.onSuccess();
					} else {
						if (element.advise) element.advise.src='../../../../Images/Advise/vbExclamation.gif'
						element.onError();
					}
					
					element.URLString = "";
					element.onCompletion();
					break;
					}
				};

				if (xmlData || this.method == "POST")
					this.xmlhttp.send(url_post);
				else
					this.xmlhttp.send(this.URLString);
			}
		}
	};
	
	this.eval = function(Context) {
	if (this.script)
		{
		eval(this.script)
		}
	}

	this.reset();
	this.createAJAX();
}

function contextualLoad() {
}

function DBScalarFunction(/*oSource*/)
{
var sSQLQuery = arguments[0];
for (a=1; a<arguments.length; ++a)
	{
	sSQLQuery+= ((a>1?', ':'')+( isObject(arguments[a])?getVal(arguments[a]):(esVacio(arguments[a])?'NULL':(isNumericOrMoney(arguments[a])?arguments[a]:"'"+arguments[a]+"'"))) )
	}
sSQLQuery+=')';
var oTemp = new Object();
oTemp.status = undefined;
var oData=new AjaxLoader("../Scripts/ajax_DBScalarFunction.asp?strSQL="+sSQLQuery, {method:'POST', async:false})
oData.onSuccess = function() {
	this.eval(oTemp);
	if (oTemp.status=='error') showModal(oTemp.statusMessage);
}
oData.load();
return oTemp.value;
}

function DBProcedure(oSource, ajaxSettings)
{
if (ajaxSettings===undefined) ajaxSettings = {}
var sRoutineName = oSource
var ajaxSettings = (ajaxSettings || {method:'POST', async:false})
var sParameters = ''
for (a=2; a<arguments.length; ++a)
	{
	sParameters+= ((a>2?', ':'')+( isObject(arguments[a])?getVal(arguments[a]):(esVacio(arguments[a])?'NULL':(isNumericOrMoney(arguments[a]) || String(arguments[a]).search(/^\s*@/gi)!=-1?arguments[a]:"'"+arguments[a]+"'"))) )
	}
var oTemp = new Object();
oTemp.fields = {}
oTemp.status = undefined;
//alert("../Scripts/ajax_DBProcedure.asp?strSQL="+sSQLQuery, oTemp, undefined, false, 'POST')
	var oData=new AjaxLoader("../Scripts/ajax_DBProcedure.asp?RoutineName="+sRoutineName+"&Parameters="+URLEncode(sParameters), ajaxSettings)
	oData.onSuccess = function() {
		this.eval(oTemp)
		if (oTemp.status=='error') showModal(oTemp.statusMessage);
	}
	oData.load();
//ajaxRequest/*alert*/("../Scripts/ajax_DBProcedure.asp?strSQL="+sSQLQuery, oDestino, undefined, false, 'POST')
return oTemp
}


function load(file, settings) {
var oResult
	if (!settings) settings = {method:'GET'}
	settings["async"]=false
	var xhttp = new sack(file, settings)
	xhttp.onSuccess= function () { oResult=this.document }
	xhttp.runAJAX();
return xhttp
}

function loadXMLFile(sXmlFile, sXslFile, oControl)
{
	var xhttp = new sack(sXmlFile);	
	xhttp.context = oControl
	xhttp.xslFile = sXslFile
	xhttp.method = 'GET'
	xhttp.async = (sXslFile!=undefined);	/*alert(xhttp.async+', '+sXslFile)*/
	xhttp.onError = function(){ 
		showModal('Error al descargar contenido XML '+this.requestFile+':\n\n '+this.document+'\n\n')
		//alert('Error al descargar contenido XML '+this.requestFile+':\n\n '+this.responseStatus[1]+'\n\n')
	};
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

function getFilters(sTableName)
{
var sFilters=(window.showModalDialog('../Templates/request.asp?Mode=filters&CatalogName='+sTableName, null, "help:no; status=yes; resizable:yes; dialogHeight:"+String(document.body.offsetHeight+30)+"px; dialogWidth:"+String(document.body.offsetWidth/2)+"px; dialogLeft:100px; dialogTop:100px; ") || "");
return URLEncode(sFilters);
/*
if (sFilters!=undefined && !esVacio(sFilters))
	{
	return sFilters //encodeURIComponent(sFilters);
	}
else
	{
	return '';
	}*/
}

function getFilterString(xmlData)
{
	var xmlData=createFilterXML()
	//showModal(escapeHTML(xmlData));
	var sRequestFile="../Scripts/ajax_getFilters.asp"
	var xhttp = new sack(sRequestFile);	
	xhttp.async = false;
	xhttp.sendXML(xmlData);
	if ((typeof self.parent.window.dialogArguments)=='object') 
		{
		window.returnValue = xhttp.document;
		self.parent.close();
		}
	else
		{
		alert('filters: '+xhttp.document);
		}
}

function cancelAndClose() {
	if ((typeof self.parent.window.dialogArguments)=='object')  {
		window.returnValue = "cancel()";
		self.parent.close();
	}
}

function uploadXMLFile(sRequestFile, xmlData, oControl)
{
	var xhttp = new AjaxLoader(sRequestFile);	
	xhttp.async = false;
//	xhttp.onError = function(){ alert(this.requestFile+':\n\n '+this.responseStatus[1]+'\n\n') };
	//alert(xmlData.replace(/\&/g, '&amp;'));
	xhttp.load(xmlData);
	var xml = xhttp.responseXML
	var xsl = loadXMLFile("../templates/updateResults.xsl").responseXML
	//CopyToClipboard(decodeHTML(transformXML(xml, xsl)));
	try { eval (decodeHTML(transformXML(xml, xsl))) } catch(e) {alert('Error al evaluar: '+e.description); /*CopyToClipboard(decodeHTML(transformXML(xml, xsl)));*/}
	return xhttp
}

/*<-- Funciones Ajax */


function fix_rowId(baseRow)
{
$(getParent('TABLE', baseRow)).find("TR[db_identity_value]:not(.delete)").each(function(index, oRow){ $(".rowNumber",oRow).get(0).innerText=index+1; })
}


function deleteData(table_name, id_name, id_value, obj_target, restrictions, sinConfirm)
{
if (!obj_target) { alert('No está definido el destino'); return false; }
restrictions=(restrictions==undefined?'':' AND '+restrictions);
sinConfirm==undefined?sinConfirm=false:null;

if (obj_target.tagName=='SELECT')
	{
	if (obj_target.options[obj_target.selectedIndex].value=='' || obj_target.options[obj_target.selectedIndex].value=='all' || obj_target.options[obj_target.selectedIndex].value=='[all]' || obj_target.options[obj_target.selectedIndex].value=='<all>' || obj_target.options[obj_target.selectedIndex].value=='0' || obj_target.options[obj_target.selectedIndex].value=='NULL')
		return false;
	mensaje="Está seguro que desea eliminar el elemento "+obj_target.options[obj_target.selectedIndex].text+"?"
	}
else if (obj_target.tagName=='TR' && (id_value=='[new]' || esVacio(id_value) || id_value=='NULL'))
	{
	oTable=getParent('TABLE', obj_target);
	!(oTable.all(obj_target.id).length && oTable.all(obj_target.id).length>1)?goToFirstVisibleObject(addRow(obj_target)):null; 
	lr=removeRow(obj_target);
	fix_rowId( lr );
	goToFirstVisibleObject(lr)
	return true;
	//oTable.deleteRow(oDestino.rowIndex)
	}
else
	{
	mensaje="Confirma que desea eliminar permanentemente este elemento?"
	}
	
if (sinConfirm || confirm(mensaje)) 
	{	
	//ajaxRequest("../Scripts/ajax_eliminaDatos.asp?table_name="+table_name+"&restrictions="+id_name+"="+id_value+restrictions, obj_target)
	var oTemp = new Object();
	oTemp.sourceObject=obj_target
	ajaxRequest("../Scripts/ajax_eliminaDatos.asp?table_name="+table_name+"&restrictions="+id_name+"="+id_value+restrictions, oTemp, undefined, false, 'POST')
	return oTemp.value
	}
else 
	{
	return false;
	}
}

function autoCheck(sRef)
{
oParent=event.srcElement
//oParent.checked=!(oParent.checked)
//var sParentName=(oParent.id || oParent.name)
//var sParentValue=oParent.value
//alert($("["+sParentName+"="+sParentValue+"]").length)
$("[group_"+sRef+"]").each(
function()
	{
	$(this).addClass("currentElement")
	if (this.checked!=oParent.checked) this.click()
	$(this).removeClass("currentElement")
	//this.checked=oParent.checked
	});
}

function MailMessage()
{
this.to = undefined;
this.from = undefined;
this.subject = undefined;
this.message = undefined;
this.messageURL = undefined
this.prepare = true;
this.send = function(bSendRightAway)
	{
/*	var oForm = new AjaxLoader("../Templates/sendMail.asp?from="+(this.from||'')+"&to="+(this.to||'')+"&subject="+(this.subject||'')+"&message="+(this.message||'')+"&action=", {method:'POST', async:false});
	oForm.onSuccess = function() {
		var win = window.open(); 
		win.document.open(); 
		win.document.write(this.HTMLDocument); 
		var style_node = document.createElement("style");
		style_node.setAttribute("type", "text/css");
		style_node.setAttribute("media", "screen"); 
		win.document.createStyleSheet(style_node);
		for (var ss=0; ss<document.styleSheets.length; ++ss)
			{
			for (var r=0; r<document.styleSheets[ss].rules.length; ++r)
				{
				try {
					if (document.styleSheets[ss].rules[r].style.cssText!='') oPopup.document.styleSheets[0].addRule(document.styleSheets[ss].rules[r].selectorText, document.styleSheets[ss].rules[r].style.cssText)
					} catch(e) {}
				}
			}
		win.document.close();
		//var oModal=document.createElement('<iframe/>')
		document.body.insertAdjacentElement("afterEnd", oModal);
		}
	oForm.load();*/
	openSimpleModalPage("../Templates/sendMail.asp?from="+(this.from||'')+"&to="+(this.to||'')+"&subject="+(this.subject||'')+"&message="+(this.message||'')+"&messageURL="+(this.messageURL||'')+"&action="+((!(this.prepare) || bSendRightAway)?'ENVIAR':''), {height:480, width:900});
return
	}
}

/*
Context Menu script II (By Dheera Venkatraman at dheera@dheera.net)
Submitted to Dynamic Drive to feature script in archive
For full source, usage terms, and 100's more DHTML scripts, visit http://dynamicdrive.com
*/
var isie=0;
if(window.navigator.appName=="Microsoft Internet Explorer"&&window.navigator.appVersion.substring(window.navigator.appVersion.indexOf("MSIE")+5,window.navigator.appVersion.indexOf("MSIE")+8)>=5.5)
	{
	isie=1;
	}
else 
	{
	
	isie=0;
	}





function SetInProgress(oSource)
{
if (oSource.AdviseImage) return
var oWorking=document.createElement('<img id="img_buscando" src="../../../../Images/Advise/in_progress.gif" alt="TRABAJANDO..." width="16" height="16" border="0" style="position:\'absolute\'" onMouseOver="/*this.removeNode(true);*/">')
oSource.insertAdjacentElement("afterEnd", oWorking);
oSource.AdviseImage=oWorking
}

function ClearInProgress(oSource)
{
if (oSource.AdviseImage) { /*oSource.AdviseImage.border=1; alert(oSource.AdviseImage.outerHTML); */oSource.AdviseImage.removeNode(true); /*alert(oSource.AdviseImage);*/ oSource.AdviseImage=undefined; };
}


function escapeHTML(sOriginal)
{
return sOriginal.replace(/</gi, '&lt;')//.replace(/>/gi, '&gt;')
}

function decodeHTML(sHTML)
{
return String(Encoder.htmlDecode(sHTML)).replace(/&apos;/gi, "'");
//return $("<div/>").html(sHTML).text()
}

/*equivalentes a SQL*/
function isnull(sValue, sIsNullValue)
{
return isNullOrEmpty(sValue)?sIsNullValue:sValue
}


function Popup(tag, oSource)
{
	if (!($(event.srcElement).closest('*[class~="dataTable"]').get(0)) || $(event.srcElement).closest('*[disableCustomContextMenu="true"]').get(0)) return
	var oPopup = window.createPopup();
	this.x = 0;
	this.y = 0;
	this.source=oSource;
	this.load = function()
		{
		var oData=new AjaxLoader("../Scripts/contextMenu.asp", {method:'GET', async:false});
		oData.setVar("tag", (tag || "document"));
		oData.onSuccess = function() 
			{
			if(isie)
				{
				var oSubMenu = this.HTMLDocument;
				var oPopupBody = oPopup.document.body;
				oPopupBody.innerHTML = "<div class='contextMenu'>"+oSubMenu+"</div>";
				var oElements=$('.option',oPopupBody);
				fTableSize=(oElements.length)*30;
				fMaxLength=200;
				//var x = (oSource && oSource.offsetLeft-23 || event.x);
				//var y = (oSource && oSource.offsetTop-fTableSize+15 || event.y);
				for (var op=0; op<oElements.length; ++op)
					{
					fCurrentLength=oElements[op].innerText.length*10;
					fMaxLength=fCurrentLength>fMaxLength?fCurrentLength:fMaxLength;
					}
				}
			//if (oSource.onSuccess) eval(oSource.onSuccess);
			}
		oData.load();
		}
	
	this.document = oPopup.document;
		
	this.show = function(x, y, fMaxLength) {
		initStyles();
		window.contextmenu = this;
		var oPopupBody = oPopup.document.body
		var oElements=$('.option',this.document).filter(function(){ return this.style.display!='none'})
		if (!fMaxLength) fMaxLength=200;
		for (var op=0; op<oElements.length; ++op)
			{
			fCurrentLength=oElements[op].innerText.length*10
			fMaxLength=fCurrentLength>fMaxLength?fCurrentLength:fMaxLength;
			}
		oPopup.show(0, 0, 300, 0); //Se "muestra" para poder calcular el tamaño, pero el usuario no lo ve
	    var fRealHeight = oPopupBody.scrollHeight;
    	oPopup.hide(); //se oculta el popup para volverlo a mostrar con el tamaño correcto
		oPopup.show(x, y, fMaxLength, fRealHeight, document.body);
		cancelBubble();
	}
	
	this.hide = function()
	{
		$(".option.mouseover", oPopup.document).removeClass("mouseover");
		oPopup.hide();
	}
	
	function initStyles()
	{
	if (oPopup.document.styleSheets.length==0)
		{
		var style_node = document.createElement("style");
		style_node.setAttribute("type", "text/css");
		style_node.setAttribute("media", "screen"); 
		oPopup.document.createStyleSheet(style_node);
		for (var ss=0; ss<document.styleSheets.length; ++ss)
			{
			for (var r=0; r<document.styleSheets[ss].rules.length; ++r)
				{
				try {
					if (document.styleSheets[ss].rules[r].style.cssText!='') oPopup.document.styleSheets[0].addRule(document.styleSheets[ss].rules[r].selectorText, document.styleSheets[ss].rules[r].style.cssText)
					} catch(e) {}
				}
			}
		}
	}
	
	this.load();
}

if(isie /*&& (window.name=='WorkArea' || window.name=='resultados')*/) 
{
$(document).ready(function()
	{
	cPageHeaders=$("TABLE.dataTable.gridView THEAD TR, TABLE.grid THEAD TR,.pageSelector").filter(function(){ return $(this).css("position")=='relative'} )/*.css("position", "relative")*/
	oTable=$("TABLE.grid").get(0);
	this.oncontextmenu = function() {
		var oContextMenu = new Popup(null, document); 
		if (oContextMenu && oContextMenu.show) {
			oContextMenu.show(event.x, event.y); 
			return false;
			}
		}
	//$(".dataTable:not([mode='filters'])").bind("contextmenu", function() { var oContextMenu = new Popup(null, document); oContextMenu.show(event.x, event.y); return false; } )
	});
}



/**
 * A Javascript object to encode and/or decode html characters
 * @Author R Reid
 * source: http://www.strictly-software.com/htmlencode
 * Licence: GPL
 * 
 * Revision:
 *  2011-07-14, Jacques-Yves Bleau: 
 *       - fixed conversion error with capitalized accentuated characters
 *       + converted arr1 and arr2 to object property to remove redundancy
 */

Encoder = {

	// When encoding do we convert characters into html or numerical entities
	EncodeType : "entity",  // entity OR numerical

	isEmpty : function(val){
		if(val){
			return ((val===null) || val.length==0 || /^\s+$/.test(val));
		}else{
			return true;
		}
	},
	arr1: new Array('&nbsp;','&iexcl;','&cent;','&pound;','&curren;','&yen;','&brvbar;','&sect;','&uml;','&copy;','&ordf;','&laquo;','&not;','&shy;','&reg;','&macr;','&deg;','&plusmn;','&sup2;','&sup3;','&acute;','&micro;','&para;','&middot;','&cedil;','&sup1;','&ordm;','&raquo;','&frac14;','&frac12;','&frac34;','&iquest;','&Agrave;','&Aacute;','&Acirc;','&Atilde;','&Auml;','&Aring;','&Aelig;','&Ccedil;','&Egrave;','&Eacute;','&Ecirc;','&Euml;','&Igrave;','&Iacute;','&Icirc;','&Iuml;','&ETH;','&Ntilde;','&Ograve;','&Oacute;','&Ocirc;','&Otilde;','&Ouml;','&times;','&Oslash;','&Ugrave;','&Uacute;','&Ucirc;','&Uuml;','&Yacute;','&THORN;','&szlig;','&agrave;','&aacute;','&acirc;','&atilde;','&auml;','&aring;','&aelig;','&ccedil;','&egrave;','&eacute;','&ecirc;','&euml;','&igrave;','&iacute;','&icirc;','&iuml;','&eth;','&ntilde;','&ograve;','&oacute;','&ocirc;','&otilde;','&ouml;','&divide;','&Oslash;','&ugrave;','&uacute;','&ucirc;','&uuml;','&yacute;','&thorn;','&yuml;','&quot;','&amp;','&lt;','&gt;','&oelig;','&oelig;','&scaron;','&scaron;','&yuml;','&circ;','&tilde;','&ensp;','&emsp;','&thinsp;','&zwnj;','&zwj;','&lrm;','&rlm;','&ndash;','&mdash;','&lsquo;','&rsquo;','&sbquo;','&ldquo;','&rdquo;','&bdquo;','&dagger;','&dagger;','&permil;','&lsaquo;','&rsaquo;','&euro;','&fnof;','&alpha;','&beta;','&gamma;','&delta;','&epsilon;','&zeta;','&eta;','&theta;','&iota;','&kappa;','&lambda;','&mu;','&nu;','&xi;','&omicron;','&pi;','&rho;','&sigma;','&tau;','&upsilon;','&phi;','&chi;','&psi;','&omega;','&alpha;','&beta;','&gamma;','&delta;','&epsilon;','&zeta;','&eta;','&theta;','&iota;','&kappa;','&lambda;','&mu;','&nu;','&xi;','&omicron;','&pi;','&rho;','&sigmaf;','&sigma;','&tau;','&upsilon;','&phi;','&chi;','&psi;','&omega;','&thetasym;','&upsih;','&piv;','&bull;','&hellip;','&prime;','&prime;','&oline;','&frasl;','&weierp;','&image;','&real;','&trade;','&alefsym;','&larr;','&uarr;','&rarr;','&darr;','&harr;','&crarr;','&larr;','&uarr;','&rarr;','&darr;','&harr;','&forall;','&part;','&exist;','&empty;','&nabla;','&isin;','&notin;','&ni;','&prod;','&sum;','&minus;','&lowast;','&radic;','&prop;','&infin;','&ang;','&and;','&or;','&cap;','&cup;','&int;','&there4;','&sim;','&cong;','&asymp;','&ne;','&equiv;','&le;','&ge;','&sub;','&sup;','&nsub;','&sube;','&supe;','&oplus;','&otimes;','&perp;','&sdot;','&lceil;','&rceil;','&lfloor;','&rfloor;','&lang;','&rang;','&loz;','&spades;','&clubs;','&hearts;','&diams;'),
	arr2: new Array('&#160;','&#161;','&#162;','&#163;','&#164;','&#165;','&#166;','&#167;','&#168;','&#169;','&#170;','&#171;','&#172;','&#173;','&#174;','&#175;','&#176;','&#177;','&#178;','&#179;','&#180;','&#181;','&#182;','&#183;','&#184;','&#185;','&#186;','&#187;','&#188;','&#189;','&#190;','&#191;','&#192;','&#193;','&#194;','&#195;','&#196;','&#197;','&#198;','&#199;','&#200;','&#201;','&#202;','&#203;','&#204;','&#205;','&#206;','&#207;','&#208;','&#209;','&#210;','&#211;','&#212;','&#213;','&#214;','&#215;','&#216;','&#217;','&#218;','&#219;','&#220;','&#221;','&#222;','&#223;','&#224;','&#225;','&#226;','&#227;','&#228;','&#229;','&#230;','&#231;','&#232;','&#233;','&#234;','&#235;','&#236;','&#237;','&#238;','&#239;','&#240;','&#241;','&#242;','&#243;','&#244;','&#245;','&#246;','&#247;','&#248;','&#249;','&#250;','&#251;','&#252;','&#253;','&#254;','&#255;','&#34;','&#38;','&#60;','&#62;','&#338;','&#339;','&#352;','&#353;','&#376;','&#710;','&#732;','&#8194;','&#8195;','&#8201;','&#8204;','&#8205;','&#8206;','&#8207;','&#8211;','&#8212;','&#8216;','&#8217;','&#8218;','&#8220;','&#8221;','&#8222;','&#8224;','&#8225;','&#8240;','&#8249;','&#8250;','&#8364;','&#402;','&#913;','&#914;','&#915;','&#916;','&#917;','&#918;','&#919;','&#920;','&#921;','&#922;','&#923;','&#924;','&#925;','&#926;','&#927;','&#928;','&#929;','&#931;','&#932;','&#933;','&#934;','&#935;','&#936;','&#937;','&#945;','&#946;','&#947;','&#948;','&#949;','&#950;','&#951;','&#952;','&#953;','&#954;','&#955;','&#956;','&#957;','&#958;','&#959;','&#960;','&#961;','&#962;','&#963;','&#964;','&#965;','&#966;','&#967;','&#968;','&#969;','&#977;','&#978;','&#982;','&#8226;','&#8230;','&#8242;','&#8243;','&#8254;','&#8260;','&#8472;','&#8465;','&#8476;','&#8482;','&#8501;','&#8592;','&#8593;','&#8594;','&#8595;','&#8596;','&#8629;','&#8656;','&#8657;','&#8658;','&#8659;','&#8660;','&#8704;','&#8706;','&#8707;','&#8709;','&#8711;','&#8712;','&#8713;','&#8715;','&#8719;','&#8721;','&#8722;','&#8727;','&#8730;','&#8733;','&#8734;','&#8736;','&#8743;','&#8744;','&#8745;','&#8746;','&#8747;','&#8756;','&#8764;','&#8773;','&#8776;','&#8800;','&#8801;','&#8804;','&#8805;','&#8834;','&#8835;','&#8836;','&#8838;','&#8839;','&#8853;','&#8855;','&#8869;','&#8901;','&#8968;','&#8969;','&#8970;','&#8971;','&#9001;','&#9002;','&#9674;','&#9824;','&#9827;','&#9829;','&#9830;'),
		
	// Convert HTML entities into numerical entities
	HTML2Numerical : function(s){
		return this.swapArrayVals(s,this.arr1,this.arr2);
	},	

	// Convert Numerical entities into HTML entities
	NumericalToHTML : function(s){
		return this.swapArrayVals(s,this.arr2,this.arr1);
	},


	// Numerically encodes all unicode characters
	numEncode : function(s){
		
		if(this.isEmpty(s)) return "";

		var e = "";
		for (var i = 0; i < s.length; i++)
		{
			var c = s.charAt(i);
			if (c < " " || c > "~")
			{
				c = "&#" + c.charCodeAt() + ";";
			}
			e += c;
		}
		return e;
	},
	
	// HTML Decode numerical and HTML entities back to original values
	htmlDecode : function(s){

		var c,m,d = s;
		
		if(this.isEmpty(d)) return "";

		// convert HTML entites back to numerical entites first
		d = this.HTML2Numerical(d);
		
		// look for numerical entities &#34;
		arr=d.match(/&#[0-9]{1,5};/g);
		
		// if no matches found in string then skip
		if(arr!=null){
			for(var x=0;x<arr.length;x++){
				m = arr[x];
				c = m.substring(2,m.length-1); //get numeric part which is refernce to unicode character
				// if its a valid number we can decode
				if(c >= -32768 && c <= 65535){
					// decode every single match within string
					d = d.replace(m, String.fromCharCode(c));
				}else{
					d = d.replace(m, ""); //invalid so replace with nada
				}
			}			
		}

		return d;
	},		

	// encode an input string into either numerical or HTML entities
	htmlEncode : function(s,dbl){
			
		if(this.isEmpty(s)) return "";

		// do we allow double encoding? E.g will &amp; be turned into &amp;amp;
		dbl = dbl || false; //default to prevent double encoding
		
		// if allowing double encoding we do ampersands first
		if(dbl){
			if(this.EncodeType=="numerical"){
				s = s.replace(/&/g, "&#38;");
			}else{
				s = s.replace(/&/g, "&amp;");
			}
		}

		// convert the xss chars to numerical entities ' " < >
		s = this.XSSEncode(s,false);
		
		if(this.EncodeType=="numerical" || !dbl){
			// Now call function that will convert any HTML entities to numerical codes
			s = this.HTML2Numerical(s);
		}

		// Now encode all chars above 127 e.g unicode
		s = this.numEncode(s);

		// now we know anything that needs to be encoded has been converted to numerical entities we
		// can encode any ampersands & that are not part of encoded entities
		// to handle the fact that I need to do a negative check and handle multiple ampersands &&&
		// I am going to use a placeholder

		// if we don't want double encoded entities we ignore the & in existing entities
		if(!dbl){
			s = s.replace(/&#/g,"##AMPHASH##");
		
			if(this.EncodeType=="numerical"){
				s = s.replace(/&/g, "&#38;");
			}else{
				s = s.replace(/&/g, "&amp;");
			}

			s = s.replace(/##AMPHASH##/g,"&#");
		}
		
		// replace any malformed entities
		s = s.replace(/&#\d*([^\d;]|$)/g, "$1");

		if(!dbl){
			// safety check to correct any double encoded &amp;
			s = this.correctEncoding(s);
		}

		// now do we need to convert our numerical encoded string into entities
		if(this.EncodeType=="entity"){
			s = this.NumericalToHTML(s);
		}

		return s;					
	},

	// Encodes the basic 4 characters used to malform HTML in XSS hacks
	XSSEncode : function(s,en){
		if(!this.isEmpty(s)){
			en = en || true;
			// do we convert to numerical or html entity?
			if(en){
				s = s.replace(/\'/g,"&#39;"); //no HTML equivalent as &apos is not cross browser supported
				s = s.replace(/\"/g,"&quot;");
				s = s.replace(/</g,"&lt;");
				s = s.replace(/>/g,"&gt;");
			}else{
				s = s.replace(/\'/g,"&#39;"); //no HTML equivalent as &apos is not cross browser supported
				s = s.replace(/\"/g,"&#34;");
				s = s.replace(/</g,"&#60;");
				s = s.replace(/>/g,"&#62;");
			}
			return s;
		}else{
			return "";
		}
	},

	// returns true if a string contains html or numerical encoded entities
	hasEncoded : function(s){
		if(/&#[0-9]{1,5};/g.test(s)){
			return true;
		}else if(/&[A-Z]{2,6};/gi.test(s)){
			return true;
		}else{
			return false;
		}
	},

	// will remove any unicode characters
	stripUnicode : function(s){
		return s.replace(/[^\x20-\x7E]/g,"");
		
	},

	// corrects any double encoded &amp; entities e.g &amp;amp;
	correctEncoding : function(s){
		return s.replace(/(&amp;)(amp;)+/,"$1");
	},


	// Function to loop through an array swaping each item with the value from another array e.g swap HTML entities with Numericals
	swapArrayVals : function(s,arr1,arr2){
		if(this.isEmpty(s)) return "";
		var re;
		if(arr1 && arr2){
			//ShowDebug("in swapArrayVals arr1.length = " + arr1.length + " arr2.length = " + arr2.length)
			// array lengths must match
			if(arr1.length == arr2.length){
				for(var x=0,i=arr1.length;x<i;x++){
					re = new RegExp(arr1[x], 'g');
					s = s.replace(re,arr2[x]); //swap arr1 item with matching item from arr2	
				}
			}
		}
		return s;
	},

	inArray : function( item, arr ) {
		for ( var i = 0, x = arr.length; i < x; i++ ){
			if ( arr[i] === item ){
				return i;
			}
		}
		return -1;
	}

}



/*
//example of using the html encode object

// set the type of encoding to numerical entities e.g & instead of &
Encoder.EncodeType = "numerical";

// or to set it to encode to html entities e.g & instead of &
Encoder.EncodeType = "entity";

// HTML encode text from an input element
// This will prevent double encoding.
var encoded = Encoder.htmlEncode(document.getElementById('input'));

// To encode but to allow double encoding which means any existing entities such as
// &amp; will be converted to &amp;amp;
var dblEncoded = Encoder.htmlEncode(document.getElementById('input'),true);

// Decode the now encoded text
var decoded = Encoder.htmlDecode(encoded);

// Check whether the text still contains HTML/Numerical entities
var containsEncoded = Encoder.hasEncoded(decoded);
*/
// <-- Encoder



function openDataRow(oSource, settings)
{
	if (!settings) settings = {}
	var oDataRow=$(oSource).closest("[db_identity_value]"); 
	settings["identityValue"]=oDataRow.attr("db_identity_value");
	settings["identityKey"]=oDataRow.closest("[db_identity_key]").attr("db_identity_key");
	var response = openModalPage('../Templates/request.asp?CatalogName='+(settings["catalogName"])+'&Mode='+(settings["mode"]||'DEFAULT')+'&filters=['+settings["identityKey"]+']='+settings["identityValue"]+' '+(settings["filters"]||'')+'&parameters='+encodeURIComponent((settings["parameters"]||'DEFAULT')));
	if (response)
		{
		if (response.status=='success')
			{
			var oTableLoader=$(oSource).closest('.tableLoader, .tabPanel').get(0); 
			if (oTableLoader) { 
				oTableLoader.isUpdated=false; 
				} else { 
				location.href=location.href; 
				}
			}
		
		//try { if (response && response.script) eval(response.script) } catch(e) {alert(e.description); showModal(response)}
		}
}


function ShowClipboardContent () {
alert (window.clipboardData.getData ("Text"));
}

function ClearClipboard () {
	window.clipboardData.clearData ("Text");
}

function CopyToClipboard (input) {
//var input = document.getElementById ("toClipboard");
if ((typeof input)=='object')
	{
	var textToClipboard = (input.innerHTML || input.value);
	}
else
	{
	var textToClipboard = (input);
	}
if (!textToClipboard) { alert('No se pudo copiar'); return false; }
var success = true;
if (window.clipboardData) { // Internet Explorer
    window.clipboardData.setData ("Text", textToClipboard);
}
else {
        // create a temporary element for the execCommand method
    var forExecElement = CreateElementForExecCommand (textToClipboard);

            /* Select the contents of the element 
                (the execCommand for 'copy' method works on the selection) */
    SelectContent (forExecElement);

    var supported = true;

        // UniversalXPConnect privilege is required for clipboard access in Firefox
    try {
        if (window.netscape && netscape.security) {
            netscape.security.PrivilegeManager.enablePrivilege ("UniversalXPConnect");
        }

            // Copy the selected content to the clipboard
            // Works in Firefox and in Safari before version 5
        success = document.execCommand ("copy", false, null);
    }
    catch (e) {
        success = false;
    }
    
        // remove the temporary element
    document.body.removeChild (forExecElement);
}

if (success) {
    alert ("The text is on the clipboard, try to paste it!");
}
else {
    alert ("Your browser doesn't allow clipboard access!");
}
}

function CreateElementForExecCommand (textToClipboard) {
var forExecElement = document.createElement ("div");
    // place outside the visible area
forExecElement.style.position = "absolute";
forExecElement.style.left = "-10000px";
forExecElement.style.top = "-10000px";
    // write the necessary text into the element and append to the document
forExecElement.textContent = textToClipboard;
document.body.appendChild (forExecElement);
    // the contentEditable mode is necessary for the  execCommand method in Firefox
forExecElement.contentEditable = true;

return forExecElement;
}

function SelectContent (element) {
    // first create a range
var rangeToSelect = document.createRange ();
rangeToSelect.selectNodeContents (element);

    // select the contents
var selection = window.getSelection ();
selection.removeAllRanges ();
selection.addRange (rangeToSelect);
}

function toggleLanguage()
{
	var ajax = new sack('../Scripts/toggleLanguage.asp?uid='+Math.random(),{async:false}); 
	ajax.runAJAX();
	//top.frames["WorkArea"].location.reload();
	//document.execCommand('Refresh')
}

function CONVERT(sType, value) {
	return value
}