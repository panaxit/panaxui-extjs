var aColors=new Array('aqua', 'blue', 'fuchsia', 'gray', 'green', 'lime', 'maroon', 'navy', 'olive', 'purple', 'red', 'silver', 'teal', 'white', 'yellow', 'black')
var sCurrencyPath=/^(?:\$)?(?:\-)?\d{1,3}((?:\,)\d{3})*\.?\d*$/
//var rootFolder="http://"+window.location.host+"/"+(window.location.pathname.split('/'))[1]+"/"
var rootFolder=String(window.location).match("(.*)(?=/.*/.*?\.(?:asp|html?))")[0]+'/'
//var rootFolder="http://"+window.location.host+"/"+window.location.pathname.match(/^(.*)[/\\]\w*\./)[1]+"/"
//alert(rootFolder)
var debug_code=false;
var arr_progreso= new Array ('\\', '|', '/', '--')
var cont_progreso=0

function ajaxQuery(url)
{
var oTemp = new Object();
ajaxRequest(url, oTemp, false, false, 'POST')
return oTemp.value
}

function ajaxRequest(url, oDestino, cached, is_async, send_method, warn_errors) 
{
if (warn_errors==undefined) warn_errors=true;
if (!oDestino) { alert('El destino de la consulta no está definido, no se puede continuar. \n\n'+(new Date())); return false;}
oDestino.ajaxObj = creaAjax(); // Creamos el objeto XMLHttpRequest

var src_obj=((oDestino && !(oDestino.length)?oDestino:undefined) || event.srcElement)
try 
	{ 
	if (!(src_obj.nextSibling) || (src_obj.nextSibling && src_obj.nextSibling.id!='img_buscando'))
		{
		var img_buscando=document.createElement('<img id="img_buscando" src="../../../../Images/Advise/in_progress.gif" alt="TRABAJANDO..." width="16" height="16" border="0" style="position:\'absolute\'" onMouseOver="/*this.removeNode(true);*/">')
		src_obj.insertAdjacentElement("afterEnd", img_buscando);
		}
	} catch(e) {/*alert("Error en funcion ajaxRequest(): "+e.description)*/}
document.enProceso=document.enProceso+1;

if (is_async==undefined) is_async=true;
////is_async=true;
////alert(url+'\n\n\n'+URLEncode(url))
//url=URLEncode(url)
if (cached!=true)
	{
//	url=url+(url.indexOf("?")!=-1)? "&"+new Date().getTime() : "?"+new Date().getTime()
	var sId = Math.random()
	if (url.match(/([\?&])(sid=)(.*?)/))
		url.replace(/([\?&])(sid=)(.*?)/, '$1$2'+sId)
	else if (url.match(/\?/))
		url=url+"&sid="+sId
	else
		url=url+"?sid="+sId
	}
send_method=(send_method || "GET")
if (send_method.toUpperCase()=="POST")
	{
	url_post=(url.split('\?'))[1];
	url_post=encodeURI(url_post)
	url_post=url_post.replace(/ /gm, '<space>')
	url_post=url_post.replace(/á/gm, '<a-acento>')
	url_post=url_post.replace(/é/gm, '<e-acento>')
	url_post=url_post.replace(/í/gm, '<i-acento>')
	url_post=url_post.replace(/ó/gm, '<o-acento>')
	url_post=url_post.replace(/ú/gm, '<u-acento>')
	url=(url.split('\?'))[0];
	}
else
	{
	url_post=null;
	}
oDestino.ajaxObj.open(send_method, url, is_async);
oDestino.ajaxObj.onreadystatechange = function()
	{
	src_obj_img=(src_obj.nextSibling && src_obj.nextSibling.id=='img_buscando')?src_obj.nextSibling:img_buscando;
	if (oDestino.ajaxObj.readyState==1) 
		{
		mensajeStatus('Obteniendo Conexion... ')
		}
    if (oDestino.ajaxObj.readyState==4)
		{
		mensajeStatus('Obteniendo Conexion... Completado')
		if (oDestino.ajaxObj.status==200 && oDestino.ajaxObj.responseText.indexOf('invalid')==-1)
			{
			if (oDestino)
				{
				if (oDestino.ajaxObj.responseText.toUpperCase().indexOf("<HTML")==-1)
					{
					with (oDestino)
						{
						eval(oDestino.ajaxObj.responseText);
						}
					}
				else
					{
					try 
						{
						oDestino.innerHTML=oDestino.ajaxObj.responseText
						goToFirstVisibleObject(oDestino)
						}
					catch(e) {alert(e.description+'. It\'s possible that due to an undefined error, innerHTML can\'t be inserted inside anything within a form tag.')}
					}
				}
			}
		else if(oDestino.ajaxObj.status==404)
			{
			alert(oDestino.ajaxObj.responseText)
			try
				{
				src_obj_img.src=rootFolder+'Images/vbExclamation.gif'
				}
			catch(e) {}
			if (warn_errors) alert('Error grave: Página no encontrada o no se pudo establecer la conexión. \n\n'+(new Date()))
			}
		else if(oDestino.ajaxObj)
			{
			alert(oDestino.ajaxObj.responseText)
			try
				{
				src_obj_img.src=rootFolder+'Images/vbExclamation.gif'
				}
			catch(e) {}
			if (warn_errors) alert('Error de ejecución: '+oDestino.ajaxObj.statusText+'. \n\n'+(new Date()));
			}

/*		alert((oDestino.name || oDestino.id)+'(terminando): '+oDestino.ajaxObj)*/
		document.enProceso=document.enProceso-1;
		if (document.enProceso>0)
			window.status="Quedan "+document.enProceso+" operaciones en proceso..."
		else
			{
			try
				{
				cll_img=document.all('img_buscando'); //Elimina las imagenes de procesos que no se borraron
				if (cll_img)
					{
					num_img=(cll_img?(cll_img.length?cll_img.length:1):0)-1
					for (i=num_img; i>=0; --i)
						{
						img_obj=(cll_img.length?cll_img(i):cll_img);
						img_obj.removeNode(true);
						}
					}
				} catch(e) {}
			status="Procesos completados"
			}

		try 
			{ 
			src_obj_img.removeNode(true)
			} catch(e) {/*alert(e.description)*/}
		oDestino.ajaxObj=undefined
		}
	}
oDestino.ajaxObj.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
oDestino.ajaxObj.send(url_post);
}

function creaAjax()
{
var objetoAjax=false;
try 
	{
    /*Para navegadores distintos a internet explorer*/
    objetoAjax = new ActiveXObject("Msxml2.XMLHTTP");
    }
catch (e) 
	{
    try 
		{
        /*Para explorer*/
        objetoAjax = new ActiveXObject("Microsoft.XMLHTTP");
        }
	catch (E) 
		{
        objetoAjax = false;
        }
	}

if (!objetoAjax && typeof XMLHttpRequest!='undefined') 
	{
	objetoAjax = new XMLHttpRequest();
	}
return objetoAjax;
}

document.enProceso==undefined?document.enProceso=0:null;// lo usamos para llevar una cuenta de los procesos activos

//this function was extracted from http://www.dynamicdrive.com/
var loadedobjects=""
var rootdomain="http://"+window.location.hostname

function loadobjs(){
if (!document.getElementById) return
for (i=0; i<arguments.length; i++)
	{
	var file=arguments[i]
	var fileref=""
	if (loadedobjects.indexOf(file)==-1)
		{ //Check to see if this object has not already been added to page before proceeding
		if (file.indexOf(".js")!=-1)
			{ //If object is a js file
			fileref=document.createElement('script')
			fileref.setAttribute("type","text/javascript");
			fileref.setAttribute("src", file);
			}
		else if (file.indexOf(".css")!=-1)
			{ //If object is a css file
			fileref=document.createElement("link")
			fileref.setAttribute("rel", "stylesheet");
			fileref.setAttribute("type", "text/css");
			fileref.setAttribute("href", file);
			}
		}
	if (fileref!="")
		{
		document.getElementsByTagName("head").item(0).appendChild(fileref)
		loadedobjects+=file+" " //Remember this object as being already added to page
		}
	}
}


// Funciones originales de Uriel Gómez Robles (2004)
var hay_cambios=false;
var marcar_cambios=false
var saltar_cambios=false
var adjuntar_cambios=true
var orderBy='';
var orderByStatus='';

function manageAttachBehavior(objFuente, comportamiento)
{
objFuente=event.srcElement;
try
	{
	objFuente.detachEvent("onpropertychange", manageAttachBehavior);
	objFuente.detachEvent("onmouseenter", attachBehavior)
	objFuente.detachEvent("onbeforeactivate", attachBehavior)
	} catch(e) {}
//objFuente.style.backgroundColor='lightblue'
attachBehavior(objFuente, comportamiento)
////alert('se disparó evento')
//objFuente.style.backgroundColor=''
}

function attachBehavior(objFuente, comportamiento)
{
objFuente=event.srcElement;
comportamiento==undefined?comportamiento='marca_cambios.htc':null;
/*objFuente.style.backgroundColor='lightgreen'
//alert(comportamiento+', '+objFuente.behaviorUrns(0))*/
if (like(objFuente.id, 'identifier'))
	{	
	objFuente.style.behavior="url(../Generic_Code/identifier.htc)";
	}
else if (like(objFuente.className, 'catalogo')) //IMPLEMENTADO CON CSS
	{	
//	objFuente.style.behavior="url(../Generic_Code/catalogo.htc) url(../Generic_Code/marca_cambios.htc)";
	}
else if (like(objFuente.tagName, 'INPUT, TEXTAREA, SELECT'))
	{	
	try
		{
		if (objFuente.type.toUpperCase()!="BUTTON") objFuente.style.behavior="url(../Generic_Code/marca_cambios.htc)";
		} catch(e) {alert(objFuente.name+' '+e.description)}
	}
//alert((objFuente.name || objFuente.id)+', '+objFuente.style.behavior)
//objFuente.style.backgroundColor=''

objFuente.detachEvent("onpropertychange", manageAttachBehavior)
objFuente.detachEvent("onmouseenter", attachBehavior)
objFuente.detachEvent("onbeforeactivate", attachBehavior)
//	alert(objFuente.behaviorUrns.length)

//objFuente.detachEvent("onpropertychange", attachBehavior)
}

function adjuntarEventos(objFuente)
{
//alert('Adjuntando Eventos')
try 
	{
	objFuente==undefined?objFuente=formulario.elements:null;
	
	for (i=objFuente.length-1; i>=0; --i)
		{
		if (i%20==0) mensajeStatus('Adjuntando comportamientos... '+arr_progreso[((++cont_progreso)%4)])
//		objFuente(i).style.backgroundColor='lightblue'
		objFuente(i).attachEvent("onmouseenter", attachBehavior);
		objFuente(i).attachEvent("onbeforeactivate", attachBehavior);
		objFuente(i).attachEvent("onpropertychange", manageAttachBehavior)
/*		alert()
		objFuente(i).style.backgroundColor=''*/
//		objFuente(i).attachEvent("onpropertychange", attachBehavior);
		}
	}
	catch(e) {alert('Error al adjuntar comportamientos. '+e.description)}
//alert('Adjuntando Eventos... terminado')
}

function attachBehaviorNew(objFuente, comportamiento)
{
objFuente=event.srcElement;
if (like(objFuente.tagName, 'INPUT, TEXTAREA, SELECT'))
	{	
	objFuente.addBehavior('marca_cambios_new.htc');
	}
objFuente.detachEvent("onmouseenter", attachBehaviorNew)
objFuente.detachEvent("onbeforeactivate", attachBehaviorNew)
}

//attachEvent("onload", proc_inicializar);
function proc_inicializar()
{
try
	{
	if (dataTable.clientWidth>document.body.clientWidth)
		{
		try 
			{
			freezePaneles()
			window.attachEvent("onbeforeprint", unFreezePaneles);
			window.attachEvent("onafterprint", freezePaneles);
			dataTable.all('freezer').style.display='inline';
			} catch (e) {}
		}
	else
		{
		try {dataTable.all('freezer').style.display='none';} catch (e) {}
		}
		habilitaOrderBy();
	}
catch(e) { status='Warning: No existe la dataTable para esta página' }
}

function setReadOnly(obj, poner)
{
(poner==undefined)?poner=true:null;
if (poner)
	{
	obj.tabIndex=-1;
	obj.readOnly=true;
	obj.style.borderWidth='0px';
	}
else
	{
	obj.tabIndex=0;
	obj.readOnly=false;
	obj.style.borderWidth='1px';
	}
}

function limitaValor(cantidad, maximo, minimo)
{
obj_cantidad=unformat_currency(cantidad.value)
//!(obj_cantidad<=maximo && obj_cantidad>=minimo)?alert('La cantidad debe estar entre '+minimo+' y '+maximo):null;
if (obj_cantidad<=maximo && obj_cantidad>=minimo)
	return obj_cantidad
else if (obj_cantidad<=minimo)
	{
	return minimo
	}
else if (obj_cantidad>=maximo)
	return maximo
}

function strReverse(cadena)
{
str_new=''
for (i=(cadena==""?0:cadena.length);i>=0;i--)
	{
	str_new+=cadena.charAt(i)
	}
return str_new	
}

/*INICIO DE FUNCIONES PARA ATACHAR Y MARCAR CAMBIOS EN CUALQUIER PAGINA*/

function atachaCambios(tabla)
{	
try 
	{
	tabla==undefined?tabla=dataTable:null;
	marcar_cambios=true
	cllInput=tabla.all.tags('INPUT')
	partes=20
	num_reg=(cllInput?(cllInput.length?cllInput.length:1):0)
	num=Math.ceil(num_reg/partes)
	for (I=0;I<(cllInput? (cllInput.length?cllInput.length:1):0);I++)
		{
		if (I%num==0 || I==num_reg-1) status='Adjuntando triggers (1/3)... '+Math.round((I+1)*100/num_reg)+'%';
		obj_input=cllInput.length?cllInput(I):cllInput;
		if (obj_input.id!='Id' && obj_input.name!='IdDetalleEtapa')
			{
			if (obj_input.type=="checkbox" || obj_input.type=="radio" || obj_input.type=="text" || obj_input.type=="password")
				{
				obj_input.attachEvent('onchange', marcaCambios)
				}
			else if (!(obj_input.type=="submit" || obj_input.type=="hidden" ))
				status=('Elemento no contemplado ('+obj_input.type+')')
			}
		}	
	}
catch (e) { /*document.body.innerHTML+=(e.description)+'  <- Hacer caso omiso de este mensaje, es sólo para depuración.'*/ }

try 
	{
	cllSelect=tabla.all.tags('SELECT')
	if (cllSelect)
		{
		num_reg=(cllSelect?(cllSelect.length?cllSelect.length:1):0)
		num=Math.ceil(num_reg/partes)
		for (S=0;S<(cllSelect? (cllSelect.length && cllSelect(0).tagName!='OPTION'?cllSelect.length:1):0);S++)
			{
			if (S%num==0 || S==num_reg-1) status='Adjuntando triggers (2/3)... '+Math.round((S+1)*100/num_reg)+'%';
			obj_select=cllSelect.length && cllSelect(0).tagName!='OPTION'?cllSelect(S):cllSelect
			obj_select.attachEvent('onchange', marcaCambios)
			}
		}
	}
catch (e) { /*document.body.innerHTML+=(e.description)+'  <- Hacer caso omiso de este mensaje, es sólo para depuración.'*/}

try 
	{
	cllTextArea=tabla.all.tags('TEXTAREA')
	num_reg=(cllTextArea?(cllTextArea.length?cllTextArea.length:1):0)
	num=Math.ceil(num_reg/partes)
	for (T=0;T<(cllTextArea? (cllTextArea.length?cllTextArea.length:1):0);T++)
		{
		if (T%num==0 || T==num_reg-1) status='Adjuntando triggers (3/3)... '+Math.round((T+1)*100/num_reg)+'%';
		obj_textarea=cllTextArea.length?cllTextArea(T):cllTextArea;
		obj_textarea.attachEvent('onchange', marcaCambios)
		}	
	}
catch (e) { /*document.body.innerHTML+=(e.description)+'  <- Hacer caso omiso de este mensaje, es sólo para depuración.'*/ }
}

function marcaCambios()
{
return false;
try 
	{
	obj_input=event.srcElement
	obj_td=getParent('TD', obj_input)
	i=0;
	do 
		{
		obj_input=getParent('TR',obj_input)
		objIdentifier=(/*obj_input.all('identifier') || */obj_input.all('IdDetalleEtapa'))
		i++		
		}
	while (!objIdentifier && i<30)
	if (objIdentifier.type=='checkbox')
		{
		objIdentifier.checked=true
		getParent('TD', objIdentifier).style.backgroundColor="#B9FFAE"
		getParent('TD', objIdentifier).style.color="black"
		}
	}
catch (e){}	
}
/*FIN DE FUNCIONES PARA ATACHAR Y MARCAR CUALQUIER CAMBIO*/

/* INICIO de funciones para Ordenar*/
function ordenaTabla(tabla, ix_inicio, ix_fin, tipo, sentido)
{
ix_inicio==undefined?ix_inicio=0:null;
ix_fin==undefined?ix_fin=0:null;
sentido==undefined?sentido='ASC':null;
}

//Comprueba si en la los registros hay headers con nombre de campos en la BD y asi habilita el boton de ordenar ASC y DESC
function habilitaOrderBy(habilitar) 
{
(habilitar==undefined)?habilitar=true:null;
try
	{
	if (habilitar)
		{
	 	for (i=0;i<header.length;i++)
	 		{
			cll_elementos=header(i).all
		  	for (j=0;j<cll_elementos.length;j++)
				{
				a=cll_elementos(j).className
				if (a.substring(0,4)=='oby_')
					{
					dataTable.all('ordenar').style.display='inline';
					return
					}
				}  
			}
		}
	else
		{
		dataTable.all('ordenar').style.display='none';
		}
 	}
catch (e) {}
}

function tablaOFlotante()
{
try
	{
	tabla_ordenar.style.left=parseFloat(document.body.clientWidth)-parseFloat(obj_tablaO.clientWidth)-5 + parseFloat(document.body.scrollLeft)
	tabla_ordenar.style.top=parseFloat(document.body.clientHeight)-parseFloat(obj_tablaO.clientHeight) + parseFloat(document.body.scrollTop)
	}
catch (e){}	
}

function tablaOrdenar()
{
if (!document.all("tabla_ordenar"))
	{
	obj_tablaO=document.createElement('<table border=1 id="tabla_ordenar" cellspacing="0">')
	document.body.insertBefore(obj_tablaO)
	obj_tablaO.insertRow(0)
	obj_tablaO.rows(0).insertCell(0)
	obj_tablaO.rows(0).cells(0).style.cssText="background-color:'navy'; color:'white';"
	obj_tablaO.rows(0).cells(0).innerHTML='Ordenar Por:'

	obj_tablaO.rows(0).insertCell(1)
	obj_tablaO.rows(0).cells(1).style.cssText="background-color:'navy'; color:'white';"
	obj_tablaO.rows(0).cells(1).innerHTML='<img src="../../../../Images/cerrar_ord.bmp" alt="Cerrar Tabla" height="12" width="12"  align="right" name="btn_cerrar" id="btn_cerrar" onclick= "teclado(event.keyCode=27)">' 
	obj_tablaO.insertRow(1)
	obj_tablaO.rows(1).insertCell(0)
	obj_tablaO.rows(1).cells(0).colSpan=2
	obj_tablaO.rows(1).cells(0).innerHTML='<select name="ordena_asc_des" id="ordena_asc_des" size="7" style="width:200"></select>'
	
	obj_tablaO.insertRow(2)
	obj_tablaO.rows(2).insertCell(0)
	obj_tablaO.rows(2).cells(0).colSpan=2
	obj_tablaO.rows(2).cells(0).innerHTML='<input type="Button" id="btn_limpiar" onclick="limpiarOdenar()" value="Limpiar"> &nbsp;&nbsp;&nbsp;<input type="Button" value="Ordenar" onclick="ordenaColumnas(true)" name="btn_ordenar">'

	obj_tablaO.style.position='absolute'
	}
tablaOFlotante()
}

function limpiarOdenar()
{
for (i=ordena_asc_des.length-1;i>=0;i--)
	ordena_asc_des.remove(i)
}

function escogeOrdenar()
{
try
	{
	seguirMouse()
	status="Click Derecho para Agregar a la lista/ Click Izquierdo para Ordenar/ Ctrl para Ordenar Descendentemente"
	obj=event.srcElement
	if (obj.tagName!='TH')
		{
		obj=getParent('TH', obj)
		}	
	if (obj.tagName=='TH' && obj.colSpan<2 && getParent('TR', obj).id=="header" && chkColumna()!="")
		{
		ordena=true
		document.body.style.cursor='hand';		
		}
	else
		{
		ordena=false
		document.body.style.cursor='no-drop';
		}
	}
catch(e) {}

}

function agregaColumnas()
{
col_bd=chkColumna()
if (col_bd[0]==undefined || col_bd[1]==undefined)
	return false

orden=" _ASC"
if (!order_asc)
	orden=" _DESC"

col_bd[0]=col_bd[0]+orden
texto=col_bd[1]
valor=col_bd[0]
for (i=0;i<ordena_asc_des.length;i++)
	{
	indice_g=ordena_asc_des.options[i].value.indexOf("_")
	indice_h=col_bd[0].indexOf("_")
	select_bd=col_bd[0].substring(0,indice_h)
	select_cad=ordena_asc_des.options[i].value.substring(0,indice_g)		
	if (select_cad==select_bd)
	 	btn_limpiar.fireEvent('onclick')
	}
var selOpcion=new Option(texto.replace(/[\n|\r]/gm, ' ') + orden.replace(/_/gm,''), valor);
ordena_asc_des.options[ordena_asc_des.length]=selOpcion;
return false //sirve para deshabilitar el menu contextual de windows	
}

function ordenaColumnas(isClick_btn)
{
try 
	{
	tablaOrdenar();
	if ((ordena || isClick_btn) && document.all("tabla_ordenar"))
		{
		obj=event.srcElement
		
		agregaColumnas()
//		cadena_ord=ordena_asc_des.options[0].value.replace(/_/gm,'')
		OrderBy=''
		for (i=0;i<ordena_asc_des.length;i++)
			{			
OrderBy+=ordena_asc_des.options[i].value.replace(/_/gm,'')+(i==ordena_asc_des.length-1?'':', ')
			
			}
//		btn_ordenar.fireEvent('onclick')
		currPage=location.href
		if (cl_imagen.tagName=='B')
			{
			location.replace(currPage +'&EXTRA=' + OrderBy)	
			//location.replace(currPage.substr(0, 	currPage.search(/&strEXTRA=/gi)!=-1?currPage.search(/&strEXTRA=/gi):currPage.length)+'&strEXTRA='+strEXTRA)	
			}
		else
			location.replace(currPage.substr(0, 	currPage.search(/&OrderBy=/gi)!=-1?currPage.search(/&OrderBy=/gi):currPage.length)+'&OrderBy='+OrderBy)
		btn_cerrar.fireEvent('onclick')
		}
	}	
catch (e) {}
}

function chkColumna()
{
try
	{
	clase_col= new Array
	if (event.srcElement.tagName!='TH')
		obj_th=getParent('TH', event.srcElement)
	else
		obj_th=event.srcElement
		
	cll_hijos=obj_th.children
	for (i=0;i<cll_hijos.length;i++)
		{				
		 if (cll_hijos(i).className.search(/oby_/gi)!=-1)
		 	{
			clase_col[0]=(cll_hijos(i).className).substring(4,cll_hijos(i).length)
			clase_col[1]=cll_hijos(i).innerText
			}
		}
	return clase_col;
	}
catch(e){}	
}

/*FINAL DE FUNCIONES PARA ORDENAR*/
/*--------------------------------*/
/*--------------------------------*/

function botonFlotante()
{
try
	{
	with (top.frames('resultados'))
		{
		enviar=document.all('enviar')
		if (enviar)
			{
			if (!enviar.length && enviar.id!='estatico')
				{
				enviar.style.visibility='visible'
				enviar.style.display='inline'
				enviar.style.position='absolute'
				enviar.style.zIndex=1002;
				enviar.style.left=parseInt(document.body.scrollLeft)+5+5
				enviar.style.top=parseInt(document.body.scrollTop)+parseInt(document.body.clientHeight)-enviar.clientHeight-10
				}
			}
		}
	} catch (e) {}
try {botonesFlotantes()} catch(e) {} //Esta funcion debe estar en cada página, es para los botones extras que se quieran tener flotantes
}

function flotar(elemento)
{
if (eval(elemento.getAttribute('turnOn', false)))
	{
	with(elemento)
		{
		style.position='absolute'
		style.zIndex=1002;
		style.left=parseInt(document.body.scrollLeft)+eval(getAttribute('offset_left', false))
		style.top=parseInt(document.body.scrollTop)+eval(getAttribute('offset_top', false))
		}
	}
}

/* INICIO 
funciones nuevas para el modulo de Modulo de Consulta Detalle Expediente
---------------------------------------------------------------------------
---------------------------------------------------------------------------
*/

//funcion para ocultar columnas mediante el ojo, muestra un progress bar
function ocultarColumnas(obj_ori)
{
obj_th=getParent('TH',obj_ori)
obj_tr=getParent('TR',obj_ori)
obj_tabla=getParent('TABLE',obj_ori)
inicio_ocultar=0

for (i=obj_th.cellIndex-1;i>=0;i--)
	{
	 inicio_ocultar+=parseFloat(obj_tabla.rows(obj_tr.rowIndex).cells(i).colSpan)
	}	
final_ocultar=inicio_ocultar + parseFloat(obj_tabla.rows(obj_tr.rowIndex).cells(obj_th.cellIndex).colSpan)
status='Ocultando Columnas';
num_reg=obj_tabla.rows.length	
partes=10
num=Math.ceil(num_reg/partes)
longitud_tabla=obj_tabla.rows.length
for (i=0;i<longitud_tabla;i++)
	{	
	for (j=inicio_ocultar;j<final_ocultar;j++)
		{
		if (obj_tabla.rows(i).cells(inicio_ocultar)!=null)
			{
			obj_tabla.rows(i).cells(inicio_ocultar).removeNode(true)
			}
		}
	if (i%num==0 || i==num_reg-1) 
	status='Ocultando Columnas... '+Math.round((i+1)*100/num_reg)+'%';	
	}
obj_tabla.rows(obj_tr.rowIndex).cells(obj_th.cellIndex).removeNode(true)
status=''
headerFlotante(true)	
}

//funcion para que la tabla siga en posicion original
function tablaOFlotanteFiltros()
{
try
	{
	tabla_ordenar_filtros.style.left=parseFloat(document.body.clientWidth)-parseFloat(obj_tablaO.clientWidth)-5 + parseFloat(document.body.scrollLeft)
	tabla_ordenar_filtros.style.top=parseFloat(document.body.clientHeight)-parseFloat(obj_tablaO.clientHeight) + parseFloat(document.body.scrollTop)
	}
catch (e){}	
}

//funcion para crear la tabla para ordenar por filtros
function tablaOrdenarFiltros()
{
if (!document.all("tabla_ordenar_filtros"))
	{
	obj_tablaO=document.createElement('<table border=1 id="tabla_ordenar_filtros" cellspacing="0">')
	document.body.insertBefore(obj_tablaO)
	obj_tablaO.insertRow(0)
	obj_tablaO.rows(0).insertCell(0)
	obj_tablaO.rows(0).cells(0).style.cssText="background-color:'navy'; color:'white';"
	obj_tablaO.rows(0).cells(0).innerHTML='Filtrar Por:'

	obj_tablaO.rows(0).insertCell(1)
	obj_tablaO.rows(0).cells(1).style.cssText="background-color:'navy'; color:'white';"
	obj_tablaO.rows(0).cells(1).innerHTML='<img src="../../../../Images/cerrar_ord.bmp" alt="Cerrar Tabla" height="12" width="12"  align="right" name="btn_cerrar" id="btn_cerrar" onclick= "teclado(event.keyCode=27)">' 
	obj_tablaO.insertRow(1)
	obj_tablaO.rows(1).insertCell(0)
	obj_tablaO.rows(1).cells(0).colSpan=2
	obj_tablaO.rows(1).cells(0).innerHTML='<select name="ordena_asc_des_filtros" id="ordena_asc_des_filtros" size="5" style="width:200"></select>'
	
	obj_tablaO.insertRow(2)
	obj_tablaO.rows(2).insertCell(0)
	obj_tablaO.rows(2).cells(0).colSpan=2
	obj_tablaO.rows(2).cells(0).innerHTML='<input type="Button" id="btn_limpiar" onclick="limpiarOdenarFiltros()" value="Limpiar"> &nbsp;&nbsp;&nbsp;<input type="Button" value="Filtrar" onclick="if (ordena_asc_des_filtros.length==0){return false};ordenaColumnasFiltros(true)" name="btn_ordenar">'

	obj_tablaO.style.position='absolute'
	}
tablaOFlotanteFiltros()
}

//funcion para limpiar el objeto select de ordenar por filtros
function limpiarOdenarFiltros()
{
for (var i=ordena_asc_des_filtros.length-1;i>=0;i--)
	ordena_asc_des_filtros.remove(i)
}

//funcion para eligir solo las columnas que esten en la base de datos en ordenar filtros
function escogeOrdenarFiltros()
{
try
	{
	status="Click Derecho para Agregar a la lista/ Click Izquierdo para Filtrar"
	obj=event.srcElement
	if (obj.tagName!='TH')
		{
		obj=getParent('TH', obj)
		}	
	if (obj.tagName=='TH' && obj.colSpan<2 && getParent('TR', obj).id=="header" && chkColumnaFiltros()!="")
		{
		ordena=true
		document.body.style.cursor='hand';		
		}
	else
		{
		ordena=false
		document.body.style.cursor='no-drop';
		}
	}
catch(e) {}
}

//function para agregar columnas al select de ordenar filtros, regresa 2 valores, uno con el texto y otro con el value
function agregaColumnasFiltros()
{
col_bd=chkColumnaFiltros()
if (col_bd[0]==undefined || col_bd[1]==undefined)
	return false


col_bd[0]=col_bd[0]
texto=col_bd[1]
valor=col_bd[0]
for (i=0;i<ordena_asc_des_filtros.length;i++)
	{	
	select_bd=col_bd[0]
	select_cad=ordena_asc_des_filtros.options[i].value		
	if (select_cad==select_bd)
	 	btn_limpiar.fireEvent('onclick')		
	}
id_requisito=valor.substr(valor.length-2,valor.length)
var selOpcion=new Option(texto.replace(/[\n|\r]/gm, ' ') + " "+id_requisito, valor);
ordena_asc_des_filtros.options[ordena_asc_des_filtros.length]=selOpcion;
return false //sirve para deshabilitar el menu contextual de windows	
}

//ordena las columnas por el filtro seleccionado, envia paramentos en el url
cont=0;
function ordenaColumnasFiltros(isClick_btn)
{
try 
	{
	cont++
	if (cont>3)
		{
		return false
		}
	if ((ordena || isClick_btn) && document.all("tabla_ordenar_filtros"))
		{
		obj=event.srcElement
		agregaColumnasFiltros()
		filtro=''
		for (i=0;i<ordena_asc_des_filtros.length;i++)
			{
filtro+=ordena_asc_des_filtros.options[i].value +(i==ordena_asc_des_filtros.length-1?'':', ') 
			}
		currPage=location.href
		indice1=currPage.indexOf("&filtro")
		otro_variable=''
		if (indice1!=-1)
			{
			separado=currPage.substr(indice1+1, currPage.length)
			otro_variable=separado.indexOf("&")!=-1?separado.substr(separado.search(/&/gi)):'';
			}
			
			location.replace(currPage.substr(0, 	currPage.search(/&filtro/gi)!=-1?currPage.search(/&filtro/gi):currPage.length)+'&filtro='+filtro+ otro_variable)
		btn_cerrar.fireEvent('onclick')
		}
	}	
catch (e) {}
}

//checa si el objeto que tiene el mouseover tiene la clase de oby(columna en base de datos) y regresa 2 valores en un arreglo, uno con la clase y otro con el innerText
function chkColumnaFiltros()
{
try
	{
	clase_col= new Array
	if (event.srcElement.tagName!='TH')
		obj_th=getParent('TH', event.srcElement)
	else
		obj_th=event.srcElement
		
	cll_hijos=obj_th.children
	for (i=0;i<cll_hijos.length;i++)
		{				
		 if (cll_hijos(i).className.search(/oby_/gi)!=-1)
		 	{
			clase_col[0]=(cll_hijos(i).className).substring(4,cll_hijos(i).length)
			clase_col[1]=cll_hijos(i).innerText
			}
			
		}
	return clase_col;
	}
catch(e){}	
}

/* ---------------------------------------------------------------------------
------------------------------------------------------------------------------
FINAL
funciones nuevas para el modulo de Modulo de Consulta Detalle Expediente
*/

var vista=true
var cl_imagen
function seguirMouse()
{
if (vista)
	{
	cl_imagen = event.srcElement.cloneNode(true);
	document.body.insertBefore(cl_imagen);
	vista=false
	}
else
	{	
	cl_imagen.style.position='absolute'
	cl_imagen.width="15"
	cl_imagen.height="15"
	cl_imagen.style.left=parseFloat(document.body.scrollLeft)+ parseFloat(event.clientX)+12
	cl_imagen.style.top=parseFloat(document.body.scrollTop)+ parseFloat(event.clientY)+8 
	cl_imagen.style.zIndex=1001
	}
}

var congela=false
function escogeColumnas()
{
try
	{
	seguirMouse()
	obj=event.srcElement
	if (obj.tagName!='TH')
		{
		obj=getParent('TH', obj)
		}
	if (obj.tagName=='TH' && obj.colSpan<2 && (getParent('TR', obj).id=="header" || getParent('TR', obj).className=="header"))
		{
		document.body.style.cursor='hand';
		}
	else
		{
		document.body.style.cursor='no-drop';
		}
	}
catch(e) {}
congela=true
}


function congelaColumnas()
{
try
	{
	if (congela)
		{
		document.body.detachEvent('onmousemove', escogeColumnas)
		document.body.detachEvent('onclick', congelaColumnas)
		cl_imagen.removeNode(true)
		vista=true
		congela=false
		obj=event.srcElement
		if (obj.tagName!='TH')
			{
			obj=getParent('TH', obj)
			}
		if (obj.tagName=='TH' && obj.colSpan<2 && getParent('TR', obj).id=="header")
			{
			marcaCongelables(obj);
			}
		}
	}
catch(e) {}
document.body.style.cursor='';
}


function desmarcaCongelables(celda)
{
try
	{
	status='Desmarcando congelables...';
	indiceCelda=celda.cellIndex;
	fila=getParent('TR', celda);
	indiceFila=fila.rowIndex;
	tabla=getParent('TABLE', celda);
	for (f=indiceFila; f<tabla.rows.length; ++f)
		{
		if (tabla.rows(f).cells('freeze'))
			{
			cll_celdas=tabla.rows(f).cells('freeze')
			for (c=cll_celdas.length-1; c>=indiceCelda+1; --c)
				{
//				if (cll_celdas(c).tagName=='TH') alert(cll_celdas(c).innerText)
				cll_celdas(c).id='';
				cll_celdas(c).style.borderColor='';
				cll_celdas(c).style.borderStyle='';
				cll_celdas(c).style.borderWidth='';
				cll_celdas(c).style.backgroundColor='';
				cll_celdas(c).style.color='';
				cll_celdas(c).style.zIndex=1;
				cll_celdas(c).style.position='static';
				}
			}
		}
	status='Desmarcando congelables... Completado';
	}
catch (e) {status='Desmarcando congelables... Falló';}
}


function marcaCongelables(celda)
{
try
	{
	desmarcaCongelables(celda)
	status='Marcando congelables...';
	indiceCelda=celda.cellIndex;
	fila=getParent('TR', celda);
	indiceFila=fila.rowIndex;
	tabla=getParent('TABLE', celda);
	
	for (f=indiceFila; f<tabla.rows.length; ++f)
		{
		cll_celdas=tabla.rows(f).cells
		for (c=1; c<=(cll_celdas.length-1<indiceCelda?cll_celdas.length-1:indiceCelda); ++c)
			{
			cll_celdas(c).id=(cll_celdas(c).colSpan<=1?'freeze':'');
			}
		}
	status='Marcando congelables... Completado';
	freezePaneles()
	}
catch (e) {status='Marcando congelables... Falló (Reportelo al administrador del sistema)';}
}

function freezeHeader()
{
try 
	{
//	$("#header").css("position", "relative")
//	$("#dataTable thead:first *[id='header']").css("position", "relative")
//	$(".pageSelector:first#header").css("position", "relative")

//	status="Congelando encabezado..."
	num_reg=(header?(header.length?header.length:1):0);
	partes=10;
	num=Math.ceil(num_reg/partes);
	for (h=0; h<num_reg; ++h)
		{
		if (h%num==0 || h==num_reg) status='Congelando encabezado... '+Math.round((h+1)*100/num_reg)+'%';
		header_row=header.length?header(h):header;
		//header_row.style.position='relative';
		header_row.style.zIndex=1000
		}
//	status="Congelando encabezado... Completado"
	}
catch(e) { status='Congelando encabezado... Falló'; /*alert(e.description);*/ }
}


function unFreezeHeader()
{
try 
	{
	status="Descongelando encabezado..."
	num_reg=(header?(header.length?header.length:1):0);
	partes=10;
	num=Math.ceil(num_reg/partes);
	for (h=0; h<num_reg; ++h)
		{
		if (h%num==0 || h==num_reg) status='Congelando encabezado... '+Math.round((h+1)*100/num_reg)+'%';
		header_row=header.length?header(h):header;
		header_row.style.position='static';
		}
	status="Descongelando encabezado... Completado"
	}
catch (e) {status="Descongelando encabezado... Falló"}	
}


function unFreezePaneles()
{
try 
	{
	status="Descongelando paneles..."
	num_reg=(freeze?(freeze.length?freeze.length:1):0);
	partes=10;
	num=Math.ceil(num_reg/partes);
	for (f=0; f<num_reg; ++f)
		{
		if (f%num==0 || f==num_reg) status='Descongelando paneles... '+Math.round((f+1)*100/num_reg)+'%';
		freeze_obj=freeze.length?freeze(f):freeze;
		freeze_obj.style.position='static';
		}
	status="Descongelando paneles... Completado"
	}
catch (e) {status="Descongelando paneles... Falló"}
}


function unFreezeObjetos(objeto)
{
status="Descongelando objetos..."
num_reg=(objeto?(objeto.length?objeto.length:1):0);
partes=10;
num=Math.ceil(num_reg/partes);
for (o=0; o<num_reg; ++o)
	{
	if (o%num==0 || o==num_reg) status='Descongelando objetos... '+Math.round((o+1)*100/num_reg)+'%';
	objeto_row=objeto.length?objeto(o):objeto;
	objeto_row.style.position='static';
	}
status="Descongelando objetos... Completado"
}


function addRows(baseRow, numRows)
{
(numRows==undefined)? numRows='':null;
isNaN(numRows)? r=0: r=numRows;
(!esVacio(numRows) && isNaN(numRows))? promptText=numRows:promptText='Escriba el número de líneas a añadir';

while (isNaN(r) || /*!r || */r==0)
	{
    r = (prompt(promptText, ""))
	}

nl=baseRow
for (l=0; l<r; ++l)
	{
	nl=addRow(nl)
	}
}


function copyProperty(obj_source, obj_target, property_name)
{
property_name==undefined?property_name=event.propertyName:null;

if (obj_target.getAttribute(property_name)==obj_source.getAttribute(property_name)) return false

obj_target.setAttribute(property_name, obj_source.getAttribute(property_name))
}


function removeRowByElement(btn_rmv) //Elimina la línea indicada con confirmación
{
tbl_row=getParent('TABLE', btn_rmv).all(btn_rmv.id)
if (tbl_row.length && tbl_row.length-1!=0) 
	{
	if (confirm('Confirma que desea eliminar esta linea?'))
		 removeRow(getParent('TR', btn_rmv)) ; 
	else
		return false;
	} 
else 
	{
	alert('La tabla no se puede quedar sin elementos')
	return false
	}
return true;
}


function removeRow(baseRow) //Elimina la línea indicada
{
id_original=baseRow.id
indiceFila=baseRow.rowIndex;
tabla=getParent('TABLE', baseRow);
var row_elements=tabla.rows(baseRow.rowIndex)
for (rE=row_elements.length-1; rE>=0; --rE)
	{
	try
		{
		row_elements(rE).innerText?row_elements(rE).innerText='':(row_elements(rE).value?row_elements(rE).value='':null)
		if (row_elements(rE).hasChanged && eval(row_elements(rE).hasChanged)) row_elements(rE).hasChanged=false;
		} catch(e) {}
	}
tabla.deleteRow(baseRow.rowIndex)
nr=tabla.rows(indiceFila-1)
if (nr.id!=id_original) nr=tabla.rows(indiceFila)
return nr
}


function removeCells(baseCell, NumCells)
{
NumCells==undefined?NumCells=1:null;
baseRow=getParent('TR', baseCell);
indiceFila=baseRow.rowIndex;
indiceCelda=baseCell.cellIndex;
for (c=(indiceCelda+NumCells-1); c>=indiceCelda; --c) 
	{ 
	baseRow.deleteCell(c);
	}
}


function orderRow(tr_obj, obj_orderBy, position)
{ 
position=(position || 'bottom');
tabla=getParent('TABLE', tr_obj);
ix_original=tr_obj.rowIndex
ix_destino=ix_original
/*next_value=nextValue(obj_orderBy, -1)if (next_value!=undefined)
	{
	diferencia=difFechas(getVal(obj_orderBy), (!esVacio(next_value)?next_value:'1/1/1900') );
	esVacio(diferencia)?diferencia=-1:null;
	while ( next_value!=undefined && tr_obj.rowIndex>0 && (diferencia>0 || (diferencia==0 && position=='top') ) )
		{
		slideRow(tr_obj, -1);
		next_value=nextValue(obj_orderBy, -1)
		if (next_value) diferencia=difFechas(getVal(obj_orderBy), next_value);
		}
	}
next_value=nextValue(obj_orderBy)
if (next_value!=undefined)
	{
	diferencia=difFechas(getVal(obj_orderBy), (!esVacio(next_value)?next_value:'1/1/1900') );
	esVacio(diferencia)?diferencia=1:null;
	while ( next_value!=undefined && tr_obj.rowIndex<tabla.rows.length && (diferencia<0 || (diferencia==0 && position=='bottom') ) )
		{
		slideRow(tr_obj, 1);
		next_value=nextValue(obj_orderBy)
		if (next_value) diferencia=difFechas(getVal(obj_orderBy), next_value);
//		alert(tr_obj.rowIndex+' - '+getVal(obj_orderBy), next_value, diferencia)
		}
	}*/
str_Obj_Buscar=(obj_orderBy.id || obj_orderBy.name)
while (ix_destino>0 && tabla.rows(ix_destino-1).all(str_Obj_Buscar) && ((difference(getVal(obj_orderBy), (!esVacio(getVal(tabla.rows(ix_destino-1).all(str_Obj_Buscar)))?getVal(tabla.rows(ix_destino-1).all(str_Obj_Buscar)):(tabla.rows(ix_destino-1).all(str_Obj_Buscar).className=='fecha'?'1/1/1900':-999999999)) )>0) || ((difference(getVal(obj_orderBy), (!esVacio(getVal(tabla.rows(ix_destino-1).all(str_Obj_Buscar)))?getVal(tabla.rows(ix_destino-1).all(str_Obj_Buscar)):(tabla.rows(ix_destino-1).all(str_Obj_Buscar).className=='fecha'?'1/1/1900':-999999999)) )==0) && position=='top')) )
	{
	--ix_destino
	}
	
while (ix_destino<tabla.rows.length && tabla.rows(ix_destino+1) && tabla.rows(ix_destino+1).all(str_Obj_Buscar) && ((difference(getVal(obj_orderBy), (!esVacio(getVal(tabla.rows(ix_destino+1).all(str_Obj_Buscar)))?getVal(tabla.rows(ix_destino+1).all(str_Obj_Buscar)):(tabla.rows(ix_destino+1).all(str_Obj_Buscar).className=='fecha'?'1/1/2050':999999999)) )<0) || ((difference(getVal(obj_orderBy), (!esVacio(getVal(tabla.rows(ix_destino+1).all(str_Obj_Buscar)))?getVal(tabla.rows(ix_destino+1).all(str_Obj_Buscar)):(tabla.rows(ix_destino+1).all(str_Obj_Buscar).className=='fecha'?'1/1/2050':999999999)) )==0) && position=='bottom')) )
	{
	++ix_destino
	}
if (ix_destino!=ix_original) 
{
tabla.rows(ix_destino).insertAdjacentElement((ix_destino>ix_original?'afterEnd':'beforeBegin'), tabla.rows(ix_original))
obj_orderBy.hasChanged=obj_orderBy.hasChanged;
if (!esVacio(getVal(tabla.rows(ix_original).all('row_id')))) fix_rowId(tabla.rows(ix_original));
fix_rowId(tabla.rows(ix_destino));
}
return ix_destino;
}


function difference(value1, value2)
{
if (isDateType(String(value1)))
	{
	return_value=difFechas(value1, value2);
	}
else if (isNumber(value1))
	{
	return_value=value2-value1;
//	alert(value1+', '+value2+'='+return_value)
	}
else
	{
	alert('No se reconoce el tipo para '+value1)
	}
return return_value;
}


function slideRow(tr_obj, steps)
{
tabla=getParent('TABLE', tr_obj)
steps=(steps || 1)
if (tr_obj.rowIndex<tabla.rows.length)
	{
	nr_obj=nextRow(tr_obj, steps)
	tr_obj.swapNode(nr_obj)
	if (!esVacio(getVal(nr_obj.all('row_id')))) fix_rowId(nr_obj.rowIndex<tr_obj.rowIndex?nr_obj:tr_obj);
	return nr_obj;
	}
return tr_obj;
}


function cambiaPaloma(oFuente)
{
if (oFuente.style.visibility!='hidden' && oFuente.style.display!='none')
	{
	oTextNode = eval("document.createTextNode('X')");
	oFuente.replaceNode(oTextNode);
	}
}


//Quita de un string las funciones, i.e. suma(document.all('CierresAnio')) quedaría document.all('CierresAnio'), pero object.suma(document.all('CierresAnio')) no se vería afectado, no soporta doble formula anidada. La utilidad de esta fuunción es para cuando se quiere recuperar el objeto dentro de la función a partir de un string
function removeFunctionsFromString(var_str) 
{
return var_str.replace(/^(\w*\()(.*)(\))$/gi, '$2')
}



function URLEncode(url) 
{
var SAFECHARS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_.!~*'()?&=";
var HEX = "0123456789ABCDEF";
var encoded = "";
for (var i=0; i<url.length; i++) 
	{
	var ch = url.charAt(i);
	if (ch == " ") 
		{
		encoded += "%20";
		}
	else if (ch=="&")
		{
		encoded += "%26"
		}
	else 
		{
		if (SAFECHARS.indexOf(ch) != -1) 
			{
			encoded += ch;
			}
		else
			{
			var charCode = ch.charCodeAt(0);
			if (charCode > 255) 
				{
				encoded += "+";
				} 
			else 
				{
				encoded += "%";
				encoded += HEX.charAt((charCode >> 4) & 0xF);
				encoded += HEX.charAt(charCode & 0xF);
				}
			}
		}
	}
return encoded;
}

function URLDecode(str)
{ 
return decodeURIComponent((str+'').replace(/\+/g, '%20'));
}

function changeHrefParamenter(link_string, parametro, valor) /*Descontinuada*/
{
link_string=trimAll(link_string);
if (link_string.search(/\&/)==-1) 
	{
	link_string=link_string+'&'
	}
if (link_string=='about:blank') return link_string;
if (link_string.search(/\?/)==-1) link_string=link_string+'?'
param_ix=(link_string.replace(/\?/, '&')).search(eval('/\&'+parametro+'=/'))
if (param_ix<0) param_ix=link_string.length-1
prev_string=(param_ix<0?link_string:link_string.substring(0, param_ix+1))

temp_string=link_string.substring(param_ix+1);
temp_ix=temp_string.search(/\&/)
temp_string=temp_string.substring(temp_ix, temp_string.search(/\&$/)==-1?temp_string.length:temp_string.length-1);
//alert('funcion changeHrefParameter: '+link_string+'\n\n'+(prev_string+parametro+'='+valor+temp_string))
return (prev_string+parametro+'='+valor+temp_string)
}


function requestQuerystring(strQueryString, variable)
{
if (strQueryString.search(eval('/[\&\?]'+variable+'\=/gi'))==-1) return undefined;
//alert(strQueryString+'\n\n'+strQueryString.replace(eval('/^.*?([\&\?]'+variable+'\=)(.+?)(?=\&.+?\=|$).*?$/gi'), "$1  $2"))
var value=strQueryString.replace(eval('/^.*?([\&\?]'+variable+'\=)(.+?)(?=\&.+?\=|$).*?$/gi'), "$2")
return value;
}

function updateURLString(strQueryString, variable, valor)
{
//eval('var new_string=strQueryString.replace(/([&\?]'+variable+'\b\s*\=)(.)/gi, "$1'+valor+'")')
if (strQueryString.search(/\?/g)==-1) return strQueryString+'?'+variable+'='+valor;
strQueryString=eval("strQueryString.search(/([?&]"+variable+"\\b)=([^\&]+)/)==-1?strQueryString+'&'+variable+'='+valor:strQueryString.replace(/([?&]"+variable+"\\b)=([^\&]+)/, '$1="+String(valor).replace(/'/gi,"\\'")+"')")
return strQueryString
/*
new_string=strQueryString.replace(/\?/, '&')
variable_buscar='&'+variable+'='
pos_variable=new_string.search(eval('/'+variable_buscar+'/gi'))
var left_string='';
var right_string='';
if (pos_variable>-1)
	{
	left_string=strQueryString.substring(0, pos_variable+variable_buscar.length) + valor
	strPartial=strQueryString.substring(pos_variable+variable_buscar.length)
	pos_partial=strPartial.search(/\&/)
	if (pos_partial>-1)
		right_string=strPartial.substring(pos_partial)
	}
else
	{
	return strQueryString;
	left_string=strQueryString + variable_buscar + valor
	right_string=''
	}
new_string=left_string+right_string

return new_string*/
}


function abrirElementoCatalogo(parametro, valor)
{
location.replace(changeHrefParamenter(location.href, parametro, valor))
}


order_asc=true
cancelar_headerFlotante=false
function teclado()
{
}


function setCSS(aElements)
{
var _StopWatch = new StopWatch();
_StopWatch.start()
//if (aElements && aElements.length) alert(aElements.length+': '+ aElements[0].className)
for (sPI=0; sPI<aElements.length; ++sPI)
	{
	oElement=aElements[sPI]
	if (oElement.className=='Button') oElement.className='buttons'
	}
_StopWatch.stop()
alert(_StopWatch.duration()+' segundos cambiando estilos ');
}

function initializeCSS()
{
return false;
changeCSSOption("img.Button", "behavior", "url('../Generic_Code/button.htc');")
changeCSSOption("#identifier", "behavior", "url('../Generic_Code/identifier.htc')")
changeCSSOption("INPUT", "behavior", "url(../Generic_Code/marca_cambios.htc)")
changeCSSOption("SELECT", "behavior", "url(../Generic_Code/marca_cambios.htc)")
changeCSSOption(".catalogo", "behavior", "url('../Generic_Code/catalogo.htc') url('../Generic_Code/marca_cambios.htc')")
}

function setParentIdentifiers(aElements) //en desuso
{
//alert(aElements.length)
var sPI, oElement, oIdentifier
var _StopWatch = new StopWatch();
_StopWatch.start()
for (sPI=0; sPI<aElements.length; ++sPI)
	{
	oElement=aElements[sPI]
	try { oElement.style.backgroundColor='yellow'; oIdentifier=oElement.parentIdentifier; oElement.style.backgroundColor='green';  } catch(e) { oElement.style.backgroundColor='red'/*alert(oElement.name+' no se pudo conectar')*/}
	}
_StopWatch.stop()
alert(_StopWatch.duration()+' segundos definiendo padres ');
}

function AttachBehaviors(oTarget)
{
adjuntarEventos(oTarget)
}





function ajaxOperations(oDestino) 
{

}


function paginaActual()
{
var liga=String(location.href)
var pagina=''
for (var l=0; l<liga.length; l++)
    {
	if (liga.charAt(l)=="\?")
		{
		return pagina
		}
	else
		{
		pagina=pagina+liga.charAt(l)
		}
	}
return pagina
}

function nextPage()
{
//alert(location.href)
arr_buscar=location.href.split('&')
nueva_pagina=''
for (b=0;b<arr_buscar.length-1; ++b)
	{
	nueva_pagina+=arr_buscar[b]
	alert(arr_buscar[b])
/*	if ( eval("cadena.search(/"+trimAll(arr_buscar[b])+"/g)!=-1") )
		{
		return true
		}*/
	}
nueva_pagina=arr_buscar.join('&')
alert(nueva_pagina)
return false;

//location.replace(
}

function operacionCajas(operacion, cll_txt_numeros)
{
num_cajas=0
elementos=new Array 
for (i=0; i<(cll_txt_numeros?(cll_txt_numeros.length?(cll_txt_numeros.length):1):0); i++)
	{
	txt_numero=cll_txt_numeros.length?(cll_txt_numeros(i)):cll_txt_numeros;
	elementos[i]=txt_numero.value;
	++num_cajas;
	}
if (operacion=='SUMA')
	return redondea( (suma(elementos)), 2);
else if(operacion=='PROM')
	return redondea( (suma(elementos)/num_cajas), 2);
else if(operacion=='MAX')
	return (maximo(cll_txt_numeros));
else if(operacion=='MIN')
	return (minimo(elementos));
}



function promedio()
{
total_elem=0;
for (var s=0; s<arguments.length; ++s)
	{
	if ((typeof arguments[s])=='object')
		{
		elem_obj=arguments[s];
		total_elem=total_elem+(elem_obj.length?elem_obj.length:1)
		}
	else
		{
		++total_elem
		}
	}
return suma(arguments)/total_elem
}


function suma()
{
total_suma=0;
for (var s=0; s<arguments.length; ++s)
	{
	if ((typeof arguments[s])=='object')
		{
		elem_obj=arguments[s];
		for (e=0; e<(elem_obj.length?elem_obj.length:1); ++e)
			{
			elemento=elem_obj.length?elem_obj[e]:elem_obj;
			valor=(elemento.tagName!=undefined)?(elemento.tagName=='INPUT' && elemento.type=="checkbox"?unformat_currency(elemento.value):getVal(elemento)):elemento	
			total_suma+=suma(valor);
			}
		}
	else
		{
		if (!esVacio(arguments[s]) && isNumber(arguments[s]))
			total_suma+=parseFloat(unformat_currency(arguments[s]));
		}
	}
return total_suma;
}


function acumulado(src_obj)
{
try
	{
	if (!src_obj) return 0;
	byId=(src_obj.id && !(src_obj.getAttribute('collectByName') && eval(src_obj.getAttribute('collectByName'))));
	cll_obj=getParent('TABLE', src_obj).all(byId?src_obj.id:src_obj.name)
	indice=getIndex(src_obj)
	if (!(cll_obj.length) || indice<=0)
		{
		return getVal(src_obj)
		}
	else
		{
		return suma(getVal(src_obj), acumulado(cll_obj(indice-1)));
		}
	} catch(e) {alert('Error en función "acumulado": \n'+e.description)}
}


function calculate_payment(PV, IR, NP) 
{
var PMT = IR>0?((PV * IR) / (1 - Math.pow(1 + IR, -NP))):PV/NP;
return redondea(PMT, 2)
}


function findObjectsInFormula(str_formula)
{
var str=str_formula
//var path=/((\w+(\([^\/\+\-\*]*\))*\.)+((all\(.*?\))|\w+)|\[\w+\])/g
var path=/\s*[\/\+\-\*]?\s*(\w+\(([^\/\+\-\*])*\)(?!\.))/g
// test=suma(getParent('TBODY',oSource).all('MontoTope')) + getParent('TBODY',oSource).all('MontoTope2')
return str.match(path);
}


function ultimo(elem_obj)
{
return getVal(elem_obj.length?elem_obj[elem_obj.length-1]:elem_obj);
}


function findValueIn(search_value, cll_obj)
{
cuenta_valores=0;
for (var s=1; s<arguments.length; ++s)
	{
	if ((typeof arguments[s])=='object')
		{
		elem_obj=arguments[s];
		for (e=0; e<(elem_obj.length?elem_obj.length:1); ++e)
			{
			elemento=elem_obj.length?elem_obj[e]:elem_obj;
			valor=(elemento.tagName!=undefined)?getVal(elemento):elemento	
			if (valor==search_value) ++cuenta_valores;
			}
		}
	else
		{
		alert('Parámetro no válido en función findValueIn')
		}
	}
return cuenta_valores;
}



function maximo()
{
valor_maximo=arguments[0]
for (var m=((typeof valor_maximo)=='object'?0:1);m<arguments.length; ++m)
	{
	if ((typeof valor_maximo)=='object' || (typeof arguments[m])=='object')
		{
		elem_obj=arguments[m]
		for (var e=0; e<(elem_obj.length?elem_obj.length:1); ++e)
			{
			elemento=elem_obj.length?elem_obj[e]:elem_obj;
			valor=(elemento.tagName!=undefined)?getVal(elemento):elemento
			if ((typeof valor_maximo)=='object')
				{
				valor_maximo=valor;
				}
			else
				{
				valor_maximo=maximo(valor_maximo, valor)
				}
			}
		}
	else
		{
		if (esVacio(valor_maximo)) //comprobacion si el iniciado no esta vacio
			{
			valor_maximo=arguments[m] // si esta vacio el argumento siguiente toma su lugar
			}
		else if (isDateType(String(arguments[m])))
			{
			if (Fecha(arguments[m])>Fecha(valor_maximo))
				valor_maximo=String(arguments[m])
			}
		else if (isNumber(arguments[m]))
			{
			argumento=parseFloat(unformat_currency(arguments[m]));
			valor_maximo=parseFloat(unformat_currency( (argumento>parseFloat(unformat_currency(valor_maximo)) )?argumento:valor_maximo) );
			}	
		}
	}
return valor_maximo;
}


function minimo()
{
valor_minimo=arguments[0]
for (var m=((typeof valor_minimo)=='object'?0:1);m<arguments.length; ++m)
	{
	if ((typeof valor_minimo)=='object' || (typeof arguments[m])=='object')
		{
		elem_obj=arguments[m]
		for (var e=0; e<(elem_obj.length?elem_obj.length:1); ++e)
			{
			elemento=elem_obj.length?elem_obj[e]:elem_obj;
			valor=(elemento.tagName!=undefined)?getVal(elemento):elemento
			if ((typeof valor_minimo)=='object')
				{
				valor_minimo=valor;
				}
			else
				{
				valor_minimo=minimo(valor_minimo, valor)
				}
			}
		}
	else
		{
		if (esVacio(valor_minimo)) //comprobacion si el iniciado no esta vacio
			{
			valor_minimo=arguments[m] // si esta vacio el argumento siguiente toma su lugar
			}
		else if (isDateType(String(arguments[m])))
			{
			if (Fecha(arguments[m])<Fecha(valor_minimo))
				valor_minimo=String(arguments[m])
			}
		else if (isNumber(arguments[m]))
			{
			argumento=parseFloat(unformat_currency(arguments[m]));
			valor_minimo=parseFloat(unformat_currency( (argumento<parseFloat(unformat_currency(valor_minimo)) )?argumento:valor_minimo) );
			}	
		}
	}
return valor_minimo;
}



function collectionToString(cll)
{
new_string='';
for (c=0; c<(cll?(cll.length?cll.length:1):0); ++c)
	{
	cll_element=cll.length?cll[c].value:cll.value;
	cll_element_value=getVal(cll_element);
	new_string=new_string+(new_string!=''?', ':'')+String(cll_element_value);
	}
return new_string;
}



function collectionToSQLFilterString(cll)
{
new_string='';
for (var c=0; c<(cll?(cll.length?cll.length:1):0); ++c)
	{
	cll_element=cll.length?cll[c]:cll;
	try 
		{
		if (cll_element.id!='identifier' && eval( cll_element.getAttribute('isSubmitable') ))
			{
			cll_element_value=getVal(cll_element);
			new_string=new_string+(/*new_string!=''?*/' AND '/*:''*/)+getDBColumnName(cll_element)+((like(cll_element.className, 'fecha')/* || (cll_element.className=='' && !isNumber(cll_element_value))*/ )?(eval(cll_element.getAttribute('valuePrefix'))?eval(cll_element.getAttribute('valuePrefix')):'=')+"'"+cll_element_value+"'":(cll_element.tagName.toUpperCase()=='SELECT' || like(cll_element.className, 'numero, moneda, porcentaje')?((eval(cll_element.getAttribute('valuePrefix'))?eval(cll_element.getAttribute('valuePrefix')):'=')+String(( isNumericOrMoney(cll_element_value)?cll_element_value:"'"+cll_element_value+"'"))):(' LIKE \'%'+String(cll_element_value)+'%\'')))+(eval(cll_element.getAttribute('valueSufix'))?eval(cll_element.getAttribute('valueSufix')):'');
			}
		} catch(e) {/*alert('Error en collectionToSQLFilterString: '+e.description)*/}
	}
return new_string;
}

function redondea(cantidad, decimales)
{
	cantidad=unformat_currency(cantidad)
	if (decimales==undefined)
		decimales=0
	multiplicador=Math.pow(10, decimales)
	cantidad*=multiplicador
	cantidad=Math.round(cantidad)
	cantidad/=multiplicador
	return cantidad;
}


function getIndex(src_obj, cll_obj) //busca un elemento en una coleccion
{
try 
	{
	if (cll_obj==undefined)
		{
		byId=(src_obj.id && !(src_obj.getAttribute('collectByName') && eval(src_obj.getAttribute('collectByName'))));
		cll_obj=getParent('TABLE', src_obj).all(byId?src_obj.id:src_obj.name)
		}
	for (ix=0; ix<(cll_obj.length?cll_obj.length:1); ++ix)
		{
		src_obj_col=cll_obj.length?cll_obj(ix):cll_obj;
		if (src_obj_col==src_obj)
			{
			return ix;
			}
		}
	} catch(e) {alert('Error en función "getIndex": \n'+e.description)}
}

function nextElement(src_obj, steps)
{
if (!(src_obj.name || src_obj.id)) alert('Either id nor name are defined!!!!')
steps=(steps || 1)
cll_obj=getParent('TABLE', src_obj).all(src_obj.name || src_obj.id)
if (!cll_obj) return undefined;
indice=getIndex(src_obj, cll_obj)+steps; 
if (cll_obj.length && indice<cll_obj.length && indice>=0)
	return cll_obj(indice)
else
	return undefined
}

function nextRow(src_tr, steps)
{
steps=(steps || 1)
tabla=getParent('TABLE', src_tr)
indice=src_tr.rowIndex+steps
if (tabla.rows.length && indice<tabla.rows.length && indice>=0)
	return tabla.rows(indice)
else
	return undefined
}

function nextVerticalCell(td_src, steps)
{
steps=(steps || 1)
nextCell=getParent('TABLE', td_src).rows(getParent('TR', td_src).rowIndex+steps).cells(td_src.cellIndex)
return nextCell
}


function nextValue(src_obj, steps)
{
steps=(steps || 1)
var next_element=nextElement(src_obj, steps)
if (!next_element) return undefined;
valor=(next_element?getVal( next_element ):(isNumber(getVal( src_obj ))?0:''));
isNumber(valor)?valor=parseFloat(unformat_currency(valor)):null;
return valor;
}




function esTelefono(campo)
{
validos="0123456789-() ";
var HayError="";
valor=campo.value;
for (var i=0;i<valor.length;i++)
    {
    if (validos.indexOf(valor.charAt(i))==-1)
		{
		HayError="SI";
		}
    }
if (HayError=="SI")
	{
	alert("Escriba un valor numérico.");
	campo.value="";
	campo.focus();
	}
}


function esNumero(campo, valor_default)
{
valor_default==undefined?valor_default=0:null;
var valor_campo=unformat_currency(campo.value);
if (valor_campo=="" || isNaN(valor_campo))
	{
	campo.value=valor_default;
	return false;
	}
campo.value=valor_campo;
return true;
}



function isNumber(a) 
{
!(isDateType(String(a))) && isCurrency(a)?a=unformat_currency(a):null;
if (esVacio(a) || isNaN(a) || isDateType(String(a)))
	return false;
else
	return true;
}


function isCurrency(a)
{
return (String(a).search(sCurrencyPath)!=-1)
}



function isObject(a) 
{
    return (a && typeof a == 'object') || isFunction(a);
}


function isArray(obj) 
{
   return (obj==undefined || obj.constructor.toString().indexOf("Array") == -1)?false:true;
}

function existsInArray(oSearch, aObject) 
{
if (!isArray(aObject)) return false;
var eiA;
//oSearch.style.backgroundColor='lightgreen'
for (var eiA = 0, loopCnt = aObject.length; eiA < loopCnt; eiA++) 
	{
//	aObject[eiA].style.backgroundColor='lightblue'
	if (aObject[eiA] === oSearch) 
		{
		return true;
		}
//	alert('analizando')
//	aObject[eiA].style.backgroundColor=''
	}
//oSearch.style.backgroundColor=''
return false;
};

function findInArray(oSearch, aObject) 
{
var fiA;
for (var fiA = 0, loopCnt = aObject.length; fiA < loopCnt; fiA++) 
	{
	if (aObject[fiA] === oSearch) 
		{
		return fiA;
		}
	}
return false;
};

/*Object.prototype.clone = function() 
{
var newObj = (this instanceof Array) ? [] : {};
for (i in this) 
	{
    if (i == 'clone') continue;
    if (this[i] && typeof this[i] == "object") 
		{
      	newObj[i] = this[i].clone();
    	}
	else newObj[i] = this[i]
  	}
return newObj;
};*/
/*
Array.prototype.contains = function(value) 
{
	var i;
	for (var i = 0, loopCnt = this.length; i < loopCnt; i++) {
	if (this === value) 
		{
		return true;
		}
}

return false;

};
*/
function isFunction(a) 
{
    return typeof a == 'function';
}


function esVacio(valor)
{
if (typeof valor=='object') return ;
valor=String(valor)
for (var v=0;v<valor.length;v++)
    {
    if (valor.charAt(v)!=' ')
		{
		return false;
		}
	}
return true;
}


function formatObject(obj)
{
var valor_objeto=getVal(obj)
if (esVacio(valor_objeto)) return false;
var sClassName
if (obj.getAttribute('formato'))
	{
	sClassName=obj.getAttribute('formato')
	}
else if ($(obj).hasClass("moneda"))
	{
	sClassName="moneda"
	}
else if ($(obj).hasClass("numero"))
	{
	sClassName="numero"
	}
else if ($(obj).hasClass("porcentaje") || $(obj).hasClass("percent"))
	{
	sClassName="porcentaje"
	}
else if ($(obj).hasClass("fecha") || $(obj).hasClass("date"))
	{
	sClassName="fecha"
	}

var formated_value=formatValue(obj.value?obj.value:obj.innerText, sClassName, obj.getAttribute('decimalPositions'))
var current_value=(obj.value?obj.value:obj.innerText)
if (current_value==formated_value) return false;
/*if (like(sClassName, 'numero, moneda, porcentaje, percent')) 
	{
	obj.style.color=getVal(obj)<0?'orange':'';
	}*/
//if (debug_code) alert(obj.name+': '+current_value+', '+formated_value)
obj.value?obj.value=formated_value:(obj.innerText?obj.innerText=formated_value:null);
return true; 
}


function format_currency(cant, digitos_decimales)
{
var digitos_decimales=(digitos_decimales || 2);
cant=!esVacio(cant)?parseFloat(unformat_currency(String(cant))):'';
var temp, temp1, temp2, strng, decimales, inic
if (cant<0)
	{
	inic='$-'
	cant=cant*-1
	}
else
	{
	inic='$'
	}

strng=''
var multiplicador=Math.pow(10, digitos_decimales)
cant=String( (Math.round(cant*multiplicador))/multiplicador )
decimales=obtenerDecimales(cant, digitos_decimales);
cant=Math.floor(cant)

while (cant>=1000)
	{
	temp=cant/1000
	temp1=Math.floor(temp)
	temp2=temp-temp1
	cant=Math.floor(cant/1000)
	temp2=Math.round(temp2*1000)
	if (temp2<10)
		{
		temp2='0'+'0'+String(temp2)
		}
	else if (temp2<100)
		{
		temp2='0'+String(temp2)
		}
	else
		{
		temp2=String(temp2)
		}
	strng=','+temp2+strng
	}
strng=inic+cant+strng+'.'+decimales
return strng;
}



function unformat_currency(valor)
{
strng=String(valor);
validos="0123456789-(.";
var strng_new=''
for (var s=0; s<strng.length; s++)
    {
     if (!(validos.indexOf(strng.charAt(s))==-1))
		{
		// lo siguiente es necesario porque hay algunos sistemas operativos que ponen parentesis para las cantidades negativas
		if (strng.charAt(s)=='(')
			{
			strng_new=strng_new+'-'
			}
		else
			{
			strng_new=strng_new+String(strng.charAt(s))
			}
		}
    }
return strng_new;
}



function Numero_Letras(cant)
{
var temp=0, temp1=0, temp2=0, strng, decimales
strng=''
var multiplicador=Math.pow(10, 2)
cant=String( (Math.round(cant*multiplicador))/multiplicador )
decimales=obtenerDecimales(cant, 2);
cant=Math.floor(cant)

strng=(cant!=1?fncLetra(cant)+'PESOS '+decimales+'/100':fncLetra(cant)+'PESO '+decimales+'/100')
return strng;
}


function Fecha_Letra(str_fecha)
{
Arr_mes= new Array("Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre", "Octubre", "Noviembre","Diciembre");

var datePat = /^(\d{1,2})(\/|-)(\d{1,2})\2(\d{2,4})$/;
F=str_fecha.match(datePat);
F[3]=Arr_mes[F[3]-1]
F[0]=F[1]+' de '+F[3]+' de '+F[4]
return F
}


function obtenerDecimales(cantidad, digitos_decimales)
{
var pos_char=findCharPos(cantidad, '.');
pos_char=(pos_char==-1?cantidad.length:pos_char);
digitos_decimales=(digitos_decimales || String(cantidad).length-pos_char-1);
multiplicador=Math.pow(10, digitos_decimales)
decimales=String( parseInt(Math.round((cantidad % 1) * Math.pow(10, digitos_decimales))) );
digitos_faltantes=(digitos_decimales-String(decimales).length)
for (d=0; d<digitos_faltantes; ++d)
	{
	decimales='0'+String(decimales)
	}
return decimales;
}


function findCharPos(cantidad, regExp)
{
str=String(cantidad)
for (pos=0; pos<str.length; pos++)
	{
	if (str.charAt(pos)==regExp) return pos;
	}
return -1;
}


String.prototype.exist = function()
{
for(var a=0; a<arguments.length; ++a)
{
	if (this==arguments[a]) return true
}
return false
}

String.prototype.busca = function(str_buscar)
{
return eval("this.search(/"+str_buscar+"/gi)");
}

String.prototype.esCorreoValido = function(correo)
{
return (this.busca('@')<=0)
}

function getChildIndex(objeto)
{
hermanos=objeto.parentNode.children
for(h=0; h<hermanos.length; h++)
	{
    if (hermanos(h)==objeto) 
		{
		return h;
		}
	}
}

function watchParents(oSource)
{
	oSource.style.backgroundColor='green'
	padre=oSource
	do 
		{ 
		$(padre).removeClass('Parent')
		padre=padre.parentNode
		$(padre).addClass('Parent')
		}
	while (padre && !confirm("Padre actual: "+padre.tagName))
	$(padre).removeClass('Parent')
	oSource.style.backgroundColor=''
}

function getParent(nombreTag, objeto)
{
try
	{
	p=0
	padre=objeto
	do 
		{ 
		padre=padre.parentNode
		++p
		}
	while (padre.tagName.replace(/TH/gm, 'TD')!=nombreTag.replace(/TH/gm, 'TD') && padre.tagName!='BODY' && p<30)
	return padre;
	}
catch (e) { return padre=undefined }
}

function translateFormula(sFormula)
{
var sPath=/[{\[](.*?)[}\]]/g
var sNewFormula='"'+sFormula/*.replace('"', '\"')*/+'"'
var ObjectsArray=sFormula.match(sPath);
if (ObjectsArray == null) return false;

for (i=0; i<=ObjectsArray.length-1; ++i)
	{
	if (eval(getObject(ObjectsArray[i])))
		{
		sNewFormula=sNewFormula.replace(ObjectsArray[i], '"+getVal(getObject("'+ObjectsArray[i]+'"))+"')
		}
	}
return sNewFormula
}

function getObject(sObjectName)
{
var element=event.srcElement
if (sObjectName.search(/^\[(.*?)\]$/g)>=0)
	{
	var str_objeto=sObjectName.replace(/^\[(.*?)\]$/g, "(((!like(element.tagName.toUpperCase(), 'TD, TH') && getParent('TD', element).all('$1')) || getParent('TR', element).all('$1') || getParent('TBODY', element).all('$1') || getParent('TABLE', element).all('$1') || document.all('$1') || [$1] || 0))")
	}
else
	{
	var str_objeto=sObjectName.replace(/[{}]/g, ' ')
/*	str_objeto=str_objeto.replace(/document\./g, "element.document.")
	str_objeto=str_objeto.replace(/element.document.document\./g, "element.document.")*/
	}
/*oClosest.style.backgroundColor='green'
alert(oClosest)
oClosest.style.backgroundColor=''*/
return eval(str_objeto)
}

function getClosest(oElement, cCollection)
{
if (cCollection.length)
	{
	var i=cCollection.length
	do
		{
		--i
		var oClosest=cCollection[i]
		} while (cCollection[i].sourceIndex>oElement.sourceIndex)
	}
else
	{
	var oClosest=cCollection
	}
oClosest.style.backgroundColor=''
return oClosest;
}

function findObjectsByString(str_object, src_object) /*no implementado, checar*/
{
src_object==undefined?src_object=event.srcElement:null;
campo_buscar=str_object.replace(/[\[\]]/g, "")
//campo_buscar=campo_buscar.replace(/document\./g, "element.document.")
if (campo_buscar.search(/["']/)!=-1)
	strNuevoCampo=campo_buscar.replace(/"/g, "'")
else
	strNuevoCampo="((!like(element.tagName.toUpperCase(), 'TD, TH') && getParent('TD', element).all('"+(campo_buscar.replace(/'/g, "\\$&"))+"')) || getParent('TR', element).all('"+(campo_buscar.replace(/'/g, "\\$&"))+"') || getParent('TABLE', element).all('"+(campo_buscar.replace(/'/g, "\\$&"))+"') || element.document.all('"+(campo_buscar.replace(/'/g, "\\$&"))+"') || "+campo_buscar+" || 0)"
return eval(removeFunctionsFromString(strNuevoCampo))
}


function findIdentifier(oSource)
{
/*oParent=oSource.parentNode
var $identifier = $(oParent).children().find("#identifier").css("backgroundColor", "red")
$identifier.css("backgroundColor", "red")
alert()
$identifier.css("backgroundColor", "")
*/
/*oParent=oSource
do
	{
	oParent=oParent.parentNode
	oIdentifier=((!like(oParent.tagName.toUpperCase(), 'TD, TH') && getParent('TD', oParent).all('identifier')) || getParent('TR', oParent).all('identifier') || getParent('TABLE', oParent).all('identifier') || document.all('identifier') || identifier || undefined)
	if (oParent!=undefined)
		{
		oParent.style.backgroundColor='red'
		alert(oParent.tagName)
		oParent.style.backgroundColor=''
		}
	} while (oParent && oSource.sourceIndex>=oParent.sourceIndex)*/
}

function getIdentifier(oSource, new_element, sIdentificador)
{
//if (document.readyState=='complete') alert((oSource.id || oSource.name || oSource.tagName))
sIdentificador==undefined?sIdentificador='identifier':null;
if (oSource.id==sIdentificador && !eval(oSource.getAttribute('checkParent'))) return undefined;

if (new_element==undefined) new_element=oSource;
//try {alert(new_element.tagName+', '+new_element.type)} catch(e) {}
oIdentifier=undefined;
oParent=new_element.parentNode;
temp_cll=oParent.all(sIdentificador);

oI=(temp_cll?(temp_cll.length?temp_cll.length:1):0)-1;
while (!oIdentifier && oI>=0)
	{
	oIdentifier=temp_cll.length?temp_cll(oI):temp_cll;
	//alert(oSource.name+', '+oIdentifier.name+'= '+(getParent('TABLE', oIdentifier).sourceIndex)+', '+(getParent('TABLE', new_element).sourceIndex) )
	if ( oIdentifier.sourceIndex>=new_element.sourceIndex || ((getParent('TABLE', oIdentifier).sourceIndex)>(getParent('TABLE', new_element).sourceIndex)) || ( oIdentifier.name==oSource.name && getParent('TABLE', oIdentifier)==(getParent('TABLE', oSource)) ) )
		{
		oIdentifier=undefined;
		}
	--oI;
	}
if (!oIdentifier && oParent.tagName!=undefined) oIdentifier=getIdentifier(oSource, oParent, sIdentificador);

return oIdentifier;
}


function getElementsByIdentifier(src_Identifier)
{
return src_Identifier.Dependants
var _StopWatch = new StopWatch();
_StopWatch.start()
elementos_formulario=new Array 
cll_elements=getParent('TABLE', src_Identifier);

cll_elementos=mergeCollections(cll_elements.getElementsByTagName('INPUT'), cll_elements.getElementsByTagName('TEXTAREA'), cll_elements.getElementsByTagName('SELECT'));

for (tC=0; tC<cll_elementos.length; ++tC)
	{
//	alert(cll_elementos[tC].name+'('+tC+'), ['+(getIdentifier(cll_elementos[tC])?getIdentifier(cll_elementos[tC]).name:'')+', '+src_Identifier.name+']='+(getIdentifier(cll_elementos[tC])==src_Identifier))
	if ((cll_elementos[tC].id=='identifier' || eval( cll_elementos[tC].getAttribute('isSubmitable') )) && cll_elementos[tC].parentIdentifier==src_Identifier)
		{
//		alert(cll_elementos[tC].name+'('+tC+'), '+cll_elementos.length)
		elementos_formulario[elementos_formulario.length]=cll_elementos[tC];
		}
	}
//_StopWatch.stop()
//alert(_StopWatch.duration()+' seconds ');
return elementos_formulario;
}


function elementChanged(elemento)
{
return ( (elemento.id=='identifier' && elemento.checked) || eval(elemento.getAttribute('hasChanged')) && eval(elemento.getAttribute("isSubmitable")) )
}


function elementSubmitable(elemento)
{
return ( elemento.id=='identifier' || eval(elemento.getAttribute('isSubmitable')) || eval(elemento.getAttribute('isAlwaysSubmitable')) )
}

function getSubmitableElementsByIdentifier(src_Identifier, only_changed)
{
only_changed==undefined?only_changed=false:null;
elementos_formulario=new Array 
cll_elements=getParent('TABLE', src_Identifier);

cll_elementos=mergeCollections(cll_elements.getElementsByTagName('INPUT'), cll_elements.getElementsByTagName('TEXTAREA'), cll_elements.getElementsByTagName('SELECT'));
for (tC=0; tC<cll_elementos.length; ++tC)
	{
	if ((!only_changed && ( eval(cll_elementos[tC].getAttribute('isAlwaysSubmitable'))) || elementChanged(cll_elementos[tC]) ) && getIdentifier(cll_elementos[tC], undefined, src_Identifier.id!='identifier'?src_Identifier.name:src_Identifier.id)==src_Identifier) 		
		elementos_formulario[elementos_formulario.length]=cll_elementos[tC];
	}
return elementos_formulario;
}



function getChildrenIdentifiersByIdentifier(src_Identifier, only_changed)
{
only_changed==undefined?only_changed=true:null;
elementos_formulario=new Array 
cll_elementos=document.all('identifier');
for (tC=0; tC<cll_elementos.length; ++tC)
	{
	if ((!only_changed || (only_changed && cll_elementos(tC).checked)) && getIdentifier(cll_elementos(tC), undefined, src_Identifier.id!='identifier'?src_Identifier.name:src_Identifier.id)==src_Identifier) 		
		elementos_formulario[elementos_formulario.length]=cll_elementos(tC);
	}
return elementos_formulario;
}




//attachEvent("onbeforeunload", warning_cambios)
function warning_cambios()
{
var resultado;
try
	{
	if (!saltar_cambios && (document.all('IdDetalleEtapa') || document.all('identifier')) && document.formulario && document.formulario.target=='transacciones')
		{
		cll_Ids=(document.all('IdDetalleEtapa') || document.all('identifier'))
		if (marcar_cambios)
			{
			for (c=(cll_Ids?(cll_Ids.length?cll_Ids.length-1:0):-1); c>=0; --c)
				{
				obj_Id=cll_Ids.length?cll_Ids(c):cll_Ids;
				if ( !(obj_Id.style.display=='none' || obj_Id.style.visibility=='hidden') )
					{
					hay_cambios=false
					c=-1;
					}
				else if (obj_Id.checked) 
					{
					hay_cambios=true;
					c=-1;
					}
				}
			}
		}
	
	if (hay_cambios)
		{
		event.returnValue = ('Los cambios no han sido guardados!, desea descartar los cambios?');
		}
	}
catch(e) {}
}






function mergeCollections()
{ // Regresa un array, no una colección
var new_array=[]
for (var c=0; c<arguments.length; ++c)
	{
	coll_obj=arguments[c]
	for(e=0; e<coll_obj.length; ++e)
		{
		new_array[new_array.length]=coll_obj(e)
		}
	}
return new_array;
}

/*document.attachEvent('onpropertychange', manageDocument)
function manageDocument()
{
alert(document.enProceso)
//if (event.propertyName=="uncommitedChanges") alert(event.propertyName+', '+document.getAttribute(event.propertyName))
}*/

function submitIdentifiers(cll_id)
{
if (!(document.submitButton)) {alert('El módulo no permite guardar')}
oSubmitButton=document.submitButton; 
if (oSubmitButton.submitting==true) { alert('El sistema ya se encuentra guardando'); return false; }
if (oSubmitButton.uncommitedChanges<=0) { alert('No se encontraron cambios'); return false; }

//if (oSubmitButton!=undefined) oSubmitButton.setAttribute('submitting', true);
document.submitButton.requiredFields=0;
cll_id=(cll_id || document.all('identifier'))
if (!cll_id) { alert('No se pueden guardar los datos'); return false;}
for (cI=0; cI<(cll_id?(cll_id.length?cll_id.length:1):0); ++cI)
	{
	try
		{
		curr_id=(cll_id.length?cll_id(cI):cll_id);
		}
	catch(e) { curr_id=(cll_id.length?cll_id[cI]:cll_id); }
//	curr_id.style.backgroundColor='lightblue'
	if ( curr_id && curr_id.checked )
		{
		parent_identifier=curr_id.parentIdentifier;
		if (!(parent_identifier && (parent_identifier.value=='[new]' || parent_identifier.value=='<new>' || parent_identifier.value=='' || parent_identifier.value==0)) )
			{
//			curr_id.style.backgroundColor='green'
			submitCollectionByIdentifier(curr_id);
//			curr_id.style.backgroundColor=''
			}
		}
//	curr_id.style.backgroundColor=''
	}

//if (oSubmitButton!=undefined) oSubmitButton.setAttribute('submitting', false);

if (document.submitButton.requiredFields>0) 
	{
//	oSubmitButton.setAttribute('submitting', false);
	alert('Hay '+document.submitButton.requiredFields+' campos requeridos sin llenar, los cuales han \nsido marcados color naranja para su fácil identificación.')
	return false;
	}
}


function getDBTableName(elemento)
{
return ( elemento.getAttribute("db_table_name") || getParent('TD', elemento).getAttribute("db_table_name") || getParent('TR', elemento).getAttribute("db_table_name") || getParent('TABLE', elemento).getAttribute("db_table_name") || '')
}

function getDBColumnName(elemento)
{
return ( elemento.getAttribute("db_column_name") || elemento.name || undefined);
}

function submitCollectionByIdentifier(obj_Identifier)
{
try
	{
/*	submit_restrictions=((obj_Identifier.getAttribute("submit_restrictions") || '').replace(/this/gm, "obj_Identifier") || true);
	if (!eval(submit_restrictions)) { alert('No se cumplieron las condiciones para enviar formulario ('+submit_restrictions+')'); return false; }*/
	
	cll_formulario=getElementsByIdentifier(obj_Identifier);
	
	obj_Identifier.style.backgroundColor='green'
//	alert(cll_formulario.length)
	if ( !checkRequired(cll_formulario) ) return false;
	obj_Identifier.style.backgroundColor=''

	var_table_name=getDBTableName(obj_Identifier)
	if (esVacio(var_table_name)) { alert('No está definida la tabla de la base de datos'); return false; }
	
	var_id_name=getDBColumnName(obj_Identifier)
	var_id_value=getDBColumnValue(obj_Identifier)
	var_query_operation=(esVacio(var_id_value) || String(var_id_value)==String(0) || String(var_id_value)=='[new]' || String(var_id_value)=='NULL')?'INSERT':'UPDATE';
	var_conditions=(var_id_value=='[new]' || esVacio(var_id_value) || String(var_id_value)==String(0))?'':(var_id_name+"="+var_id_value);
	var_columns='';
	var_column_values='';
	for (f=0; f<cll_formulario.length; ++f)
		{
//		watchAttributes(cll_formulario[f]);
	//	if (!confirm("Continuar ("+f+")?")) return false;
	//	alert(cll_formulario[f].id+', '+cll_formulario[f].name)
		try
			{
			if (cll_formulario[f].id!='identifier' && (eval(cll_formulario[f].getAttribute("isSubmitable")) || false) /*&& !(cll_formulario[f].readOnly)*/ )
				{
				var_column_name=getDBColumnName(cll_formulario[f]);
				if (!var_column_name) continue;
				var_column_value=getDBColumnValue(cll_formulario[f]);
	
				if (cll_formulario[f].className=='fecha' && (esVacio(var_column_value) || var_column_value=='1/1/1900')) var_column_value='NULL';//'1/1/1900';
				if (esVacio(var_column_value)) var_column_value='NULL';
	//			if (like(cll_formulario[f].className, 'numero, moneda, porcentaje, percent') && esVacio(var_column_value)) var_column_value='NULL';
				if (like(cll_formulario[f].className, 'texto, fecha') || (cll_formulario[f].className=='' && !isNumber(var_column_value)) && !(var_column_value.toUpperCase()=='GETDATE()') ) var_column_value="'"+var_column_value+"'";
				if (like(var_column_value, "NULL, 'NULL'")) var_column_value=cll_formulario[f].DBDefaultValue;
				var_column_values+=((!esVacio(var_column_values)?',':'')+(var_column_name+'='+var_column_value));
	//			if (cll_formulario[f].hasChanged && eval(cll_formulario[f].hasChanged)) alert(var_column_value)
	//			alert(cll_formulario[f].name+', '+var_column_name+', '+var_column_value+': '+var_column_values) 
				if (var_query_operation=='INSERT')
					{
					var_columns+=((!esVacio(var_columns)?',':'')+var_column_name);
	//				var_column_values+=((!esVacio(var_column_values)?',':'')+var_column_value);
					}
	/*			else
					{
					var_columns+=((!esVacio(var_columns)?',':'')+(var_column_name+'='+var_column_value));
					var_column_values='';
					}*/
				}
			} catch(e) { alert('Se encontró el siguiente error para el objeto '+(cll_formulario[f].tagName || typeof cll_formulario[f])+' en la función submitCollectionByIdentifier:\n\n '+e.description)}
		}
		var other_fields=eval(obj_Identifier.getAttribute("otherFields").replace(/this/gm, "obj_Identifier"))
		if (!esVacio(other_fields))
			{
			/*alert(other_fields)*/
			var arr_fields=other_fields.split(',');
			for (aF=0; aF<arr_fields.length; aF++)
				{
				var_column_values+=((!esVacio(var_column_values)?',':'')+((arr_fields[aF].split('=')[0])+'='+(arr_fields[aF].split('=')[1])));
				if (var_query_operation=='INSERT')
					{
					var_columns+=((!esVacio(var_columns)?',':'')+(arr_fields[aF].split('=')[0]));
					}
/*				else
					{
					var_columns+=((!esVacio(var_columns)?',':'')+arr_fields[aF]);
					var_column_values='';
					}*/
				}
			}
ajaxRequest("../Scripts/ajax_guardarDatos.asp?query_operation="+var_query_operation+"&table_name="+var_table_name+"&columns="+var_columns+"&column_values="+var_column_values+"&conditions="+var_conditions, obj_Identifier, undefined, false, 'POST')
	
/*	for (f=(cll_formulario.length-1); f>=0; --f)
		{
		if (cll_formulario[f].hasChanged && eval(cll_formulario[f].hasChanged)) cll_formulario[f].hasChanged=false
//		if (cll_formulario[f].id=='identifier' )
//			{
//			submitCollectionByIdentifier(cll_formulario[f]);
//			}
		}*/
	} catch(e) {obj_Identifier.hasError=true; alert('Se encontró el siguiente error en la función submitCollectionByIdentifier:\n\n '+e.description); /*watchAttributes(obj_Identifier);*/}
}


function watchAttributes(obj)
{
var atributos='\n\n'; 
for (a=0; a<obj.attributes.length; ++a) 
	{ 
	atributos+=(obj.attributes(a).specified?obj.attributes(a).nodeName + '=' + obj.attributes(a).nodeValue+'\n':'')
	}
alert((obj.name || obj.id)+':'+atributos)
}

function changeCSSOption(css_name, style_name, new_val)
{
if (!(css_name && style_name))
	{
	alert('Faltan parametros')
	return false;
	}
for (s=document.styleSheets.length-1; s>=0; --s)
	{
	for (r=document.styleSheets(s).rules.length-1; r>=0; --r)
		{
		if (document.styleSheets(s).rules(r).selectorText.toUpperCase()==css_name.toUpperCase())
			{
			if (!new_val)
				{
				switch(style_name)
					{
					case 'display':
						{
						new_val=(eval("document.styleSheets(s).rules(r).style."+style_name)=='none'?'inline':'none')
						break;
						}
					case 'visibility':
						{
						new_val=(eval("document.styleSheets(s).rules(r).style."+style_name)=='hidden'?'visible':'hidden')
						break;
						}
					}
				}
			eval("document.styleSheets(s).rules(r).style."+style_name+"=new_val")
			return true;
			}
		}
	}
alert('estilo '+css_name+' no encontrado')
return false;
}

function retrieveCSSValue(css_name, style_name, stylesheets_cll)
{
if (!(css_name && style_name))
	{
//	alert('Faltan parametros')
	return false;
	}
stylesheets_cll==undefined?stylesheets_cll=document.styleSheets:null;
for (s=stylesheets_cll.length-1; s>=0; --s)
	{
	for (r=stylesheets_cll(s).rules.length-1; r>=0; --r)
		{
		//alert(stylesheets_cll(s).rules(r).selectorText)
		if (stylesheets_cll(s).rules(r).selectorText=='.'+css_name || stylesheets_cll(s).rules(r).selectorText=='#'+css_name)
			{
			return eval("stylesheets_cll(s).rules(r).style."+style_name);
			}
		}
	}
return false;
}

//funcion para el NUEVO SINCO con IFRAMES
function CreaIFrame(loadingIFrame)
{
new_iframe=document.all('machote_trabajo').cloneNode(true)
with(new_iframe)
	{
	id='iframe_'+loadingIFrame
	name='iframe_'+loadingIFrame
	style.display='inline'	
	}
document.body.insertBefore(new_iframe);
}

function sniffChanges(obj_Identifier, cll_formulario)
{
is_complete=false;

for (var c=1; c<arguments.length; ++c)
	{
	coll_obj=arguments[c]
	for(e=0; e<coll_obj.length; ++e)
		{
		if ( eval(coll_obj[e].getAttribute('hasChanged') ) && obj_Identifier==getIdentifier(coll_obj[e]) )
			{
			is_complete=true;
			}
		}
	}
return is_complete;
}

function colorUpElement(oElement, sBackgroundColor)
{
if (oElement.type=='select-one')
	{
	for (o=0; o<oElement.options.length; ++o)
		{
		oElement.options(o).style.backgroundColor='';
		}
	if (oElement.selectedIndex>=0) oElement(oElement.selectedIndex).style.backgroundColor=sBackgroundColor;
	}
else
	{
	oElement.style.backgroundColor=sBackgroundColor;
	}
}

function checkRequired()
{
var is_required_complete=true;
try
	{
	for (var c=0; c<arguments.length; ++c)
		{
		coll_obj=arguments[c]
		for(e=0; e<(coll_obj && coll_obj.length>0?(coll_obj.length && coll_obj.type!='select-one'?coll_obj.length:1):0); ++e)
			{
			window.status=('Revisando campos requeridos... '+arr_progreso[((++cont_progreso)%4)])
			elemento=coll_obj.length && coll_obj.type!='select-one'?coll_obj[e]:coll_obj;
//			elemento.style.backgroundColor='orange'
	//		alert( elemento.name+': '+elemento.type+', '+elemento.getAttribute('notAllowedValue') )
	notAllowedValue=isNumber(elemento.getAttribute('notAllowedValue')) || eval(elemento.getAttribute('notAllowedValue'))?eval(elemento.getAttribute('notAllowedValue')):((like(elemento.className, 'numero, porcentaje, percent, moneda') || elemento.type=='select-one')?0:'');
//		alert(elemento.name+': '+getDBColumnValue(elemento)+' --> '+eval(elemento.getAttribute('notAllowedValue'))+' --> '+notAllowedValue)
			
			if (elemento.getAttribute('isRequired') && eval(elemento.getAttribute('isRequired').toLowerCase())==true && getDBColumnValue(elemento)==notAllowedValue)
				{
				is_required_complete=false;
				elemento.setAttribute('isRequired', 'true');
				document.submitButton.requiredFields=document.submitButton.requiredFields+1
				}
//			elemento.style.backgroundColor=''
			}
		}
	} catch(e) { is_required_complete=false; alert('Se encontró el siguiente error al checar requeridos:\n\n '+e.description);}
return is_required_complete;
}

function like(cadena, cadenaBuscar)
{
cadena=String(cadena);
arr_buscar=cadenaBuscar.split(',')
for (b=0;b<arr_buscar.length; ++b)
	{
	if ( eval("cadena.search(/"+trimAll(arr_buscar[b])+"/g)!=-1") )
		{
		return true;
		}
	}
return false;
}

Date.Mexico = function(strFecha) 
{   
var datePat = /^(\d{1,2})(\/|-)(\d{1,2})\2(\d{2,4})$/;
var A = strFecha.match(datePat);
A = [A[3],A[1],A[4]];
return new Date(Date.parse(A.join('/'))); 
} 

function Fecha(strFecha)
{
var datePat = /^(\d{1,2})(\/|-)(\d{1,2})\2(\d{2,4})$/;
var A = strFecha.match(datePat);
if (A[4].length==2)
	{
	if (A[4]<30)
		{
		A[4]='20'+A[4]
		}
	else
		{
		A[4]='19'+A[4]
		}
	}
nvaFecha=new Date(A[4], A[3]-1, A[1]); 
return new Date(nvaFecha); 
}


/* probar este codigo para liberarlo 
var gsMonthNames = new Array(
'Enero',
'Febrero',
'Marzo',
'Abril',
'Mayo',
'Junio',
'Julio',
'Augosto',
'Septiembre',
'Octubre',
'Noviembre',
'Diciembre'
);

var gsDayNames = new Array(
'Domingo',
'Lunes',
'Martes',
'Miércoles',
'Jueves',
'Viernes',
'Sabado'
);

Date.prototype.format = function(f)
{
    if (!this.valueOf())
        return '&nbsp;';

    var d = this;

    return f.replace(/(yyyy|mmmm|mmm|mm|dddd|ddd|dd|hh|nn|ss|a\/p)/gi,
        function($1)
        {
            switch ($1.toLowerCase())
            {
            case 'yyyy': return d.getFullYear();
            case 'mmmm': return gsMonthNames[d.getMonth()];
            case 'mmm':  return gsMonthNames[d.getMonth()].substr(0, 3);
            case 'mm':   return (d.getMonth() + 1).zf(2);
            case 'dddd': return gsDayNames[d.getDay()];
            case 'ddd':  return gsDayNames[d.getDay()].substr(0, 3);
            case 'dd':   return d.getDate().zf(2);
            case 'hh':   return ((h = d.getHours() % 12) ? h : 12).zf(2);
            case 'nn':   return d.getMinutes().zf(2);
            case 'ss':   return d.getSeconds().zf(2);
            case 'a/p':  return d.getHours() < 12 ? 'a' : 'p';
            }
        }
    );
}
*/


function dateAdd(p_Interval, p_Number, p_Date)
{
	if(!p_Date.is_Date()){return "invalid date: '" + p_Date + "'";}
	if(isNaN(p_Number)){return "invalid number: '" + p_Number + "'";}

	p_Number = new Number(p_Number);
	p_Date=Fecha(p_Date)
	var dt = new Date(p_Date);
	switch(p_Interval.toLowerCase()){
		case "yyyy": {// year
			dt.setFullYear(dt.getFullYear() + p_Number);
			break;
		}
		case "q": {		// quarter
			dt.setMonth(dt.getMonth() + (p_Number*3));
			if (dt.getDate() < p_Date.getDate())
				{
			    dt.setDate(0);
			  	}
			break;
		}
		case "m": {		// month
			dt.setMonth(dt.getMonth() + p_Number);
			if (dt.getDate() < p_Date.getDate())
				{
			    dt.setDate(0);
			  	}
			break;
			break;
		}
		case "y":		// day of year
		case "d":		// day
		case "w": {		// weekday
			dt.setDate(dt.getDate() + p_Number);
			break;
		}
		case "ww": {	// week of year
			dt.setDate(dt.getDate() + (p_Number*7));
			break;
		}
		case "h": {		// hour
			dt.setHours(dt.getHours() + p_Number);
			break;
		}
		case "n": {		// minute
			dt.setMinutes(dt.getMinutes() + p_Number);
			break;
		}
		case "s": {		// second
			dt.setSeconds(dt.getSeconds() + p_Number);
			break;
		}
		case "ms": {		// second
			dt.setMilliseconds(dt.getMilliseconds() + p_Number);
			break;
		}
		default: {
			return "invalid interval: '" + p_Interval + "'";
		}
	}
	return dateString(dt);
}


function addDays(fecha, dias)
{
if (!esVacio(fecha))
	{
	fecha=Fecha(fecha)
	nvaFecha=new Date(fecha.valueOf()+(dias*(24*60*60*1000)+(60*60*1000))) //se le suma una hora más, tenía un error con algunas fechas
	return (nvaFecha.getDate()+"/"+(parseInt(nvaFecha.getMonth())+1)+"/"+nvaFecha.getYear())
	}
else
	{
	return ''
	}
}

function dateString(date_time)
{
	return (date_time.getDate()+"/"+(parseInt(date_time.getMonth())+1)+"/"+date_time.getYear())
}

function minDate(strFechaF, strFechaI)
{
if ( !esVacio(strFechaI) && !esVacio(strFechaF) )
	{
	return Fecha(strFechaI)<Fecha(strFechaF)?strFechaI:strFechaF;
	}
else if (!esVacio(strFechaI))
	{
	return strFechaI
	}
else if (!esVacio(strFechaF))
	{
	return strFechaF
	}
else
	{
	return ''
	}
}

function maxDate(strFechaF, strFechaI)
{
if ( !esVacio(strFechaI) && !esVacio(strFechaF) )
	{
	return Fecha(strFechaI)>Fecha(strFechaF)?strFechaI:strFechaF;
	}
else if (!esVacio(strFechaI))
	{
	return strFechaI
	}
else if (!esVacio(strFechaF))
	{
	return strFechaF
	}
else
	{
	return ''
	}
}

function esFechaMayor(strFechaF, strFechaI, mensaje)
{
mensaje= (mensaje!=undefined)?mensaje:'';

if (!esVacio(strFechaI) && !esVacio(strFechaF) )
	{
	fechaI=Fecha(strFechaI)
	fechaF=Fecha(strFechaF)
//	alert(fechaI + ', ' + fechaF)
	if (fechaF<fechaI)
		{
		if (event.srcElement.value==strFechaI || event.srcElement.innerText==strFechaI)
			{
			if (!esVacio(mensaje))
				alert(mensaje)
			else
				alert("La fecha no puede exceder la fecha "+strFechaF+"" )
			}
		else if (event.srcElement.value==strFechaF || event.srcElement.innerText==strFechaF)
			{
			alert("La fecha no puede ser menor que "+strFechaI+"" )
			}
		else
			{
			alert(strFechaI+" es mayor que "+strFechaF+"" )
			}
		return true;
		}
	else
		{
		return false;
		}
	}
else
	{
	return false;
	}
}


function difFechas(strFechaI, strFechaF)
{
if (strFechaI!='' && strFechaF!='')
	{
	fechaI=Fecha(strFechaI);
	FechaF=Fecha(strFechaF);
	return Math.round((FechaF-fechaI)/(24*60*60*1000));
	}
else
	{
	return '';
	}
}

function setClass(obj_txt)
{
if (obj_txt.value.isPercent())
	obj_txt.className='porcentaje';
else if (isCurrency(obj_txt.value))
	obj_txt.className='moneda';
else if (isNumber(obj_txt.value))
	obj_txt.className='numero';
else if (isDateType(obj_txt.value))
	obj_txt.className='fecha';
}


function allowNegNumbers(obj_txt, allowNegative)
{
allowNegative==undefined?allowNegative=true:null;
if (esVacio(obj_txt))
	{
	return
	}
esNumero(obj_txt); 
(obj_txt.value<0 && !allowNegative)?obj_txt.value=obj_txt.value*-1:null; 
}

 

function formateaCaja(cll_txt, clase, doResize, doReformat)
{
cll_txt==undefined?cll_txt=event.srcElement:null;
doResize==undefined?doResize=true:null;
doReformat==undefined?doReformat=true:null;
for(t=0; t<=(cll_txt.length?cll_txt.length-1:1); ++t)
	{
	obj_txt=cll_txt.length?cll_txt(t):cll_txt;
	(clase!=undefined && clase!=obj_txt.className)?obj_txt.className=clase:null;
	switch (obj_txt.className)
		{
		case 'fecha':
			completaFecha(obj_txt);
//			isNumber(obj_txt.value)?obj_txt.value='':null;
			if ((!(isDateType(formatDate(obj_txt).value)) || obj_txt.value=='01/01/1900') && !esVacio(obj_txt.value))
				{
				alert(obj_txt.value+' no es una fecha válida')
				obj_txt.value='';
				}
			if (doResize)
				{
				obj_txt.size=8;
				obj_txt.maxLength=10;
				}
			break;
		case 'moneda':
			isDateType(obj_txt.value)?obj_txt.value='':null;
			if (doReformat)
				{
				obj_txt.style.color=unformat_currency(obj_txt.value)<0?'red':'';
				}
			obj_txt.value=format_currency(unformat_currency(obj_txt.value));
			if (doResize)
				{
				obj_txt.size=(obj_txt.value.length<=11?11:obj_txt.value.length);
				obj_txt.maxLength=(obj_txt.value.length<=12?12:obj_txt.value.length);
				}
			break;
		case 'numero':
			esNumero(obj_txt, '');
			if (doResize)
				{
				obj_txt.size=10;
				obj_txt.maxLength=12;
				}
			break;
		case 'percent':
		case 'porcentaje':
			val_txt=unformat_currency(obj_txt.value);
			val_txt=redondea(obj_txt.value, (obj_txt.getAttribute('decimalPositions') || 2));
			obj_txt.value=(isNumber(val_txt)?val_txt+'%':'');
			if (doResize)
				{
				obj_txt.size=8;
				obj_txt.maxLength=7;
				}
			break;
		}
	}
}


function formatValue(val, data_type, decimal_positions)
{ 
decimal_positions=(decimal_positions || 2);
switch (data_type)
	{
	case 'fecha':
		val=fillDate(val);
		if ((!(isDateType(val)) || val=='01/01/1900') && !esVacio(val))
			{
			alert(val+' no es una fecha válida')
			val=''
			return val='';
			}
		break;
	case 'moneda':
		isDateType(val)?val='':null;
		val=format_currency(unformat_currency(val), decimal_positions);
		//val=redondea(val, decimal_positions);
		break;
	case 'numero':
		var_value=unformat_currency(val);
		var_value=redondea(val, decimal_positions);
		if (isNaN(var_value)) 
			{
			alert(val+' no es un número valido')
			val=''
			return val='';
			}
		val=var_value;
		break;
	case 'numero-texto':
		var_value=unformat_currency(val);
		val=var_value;
		break;
	case 'percent':
	case 'porcentaje':
		var_value=unformat_currency(val);
		var_value=redondea(val, decimal_positions);
		val=(isNumber(var_value)?var_value+'%':'');
	}
return val;
}


function chk_mouseover(obj_chk, img_paloma)
{
//alert('chk_mouseover')
img_paloma==undefined?img_paloma=document.all[obj_chk.sourceIndex+1]:null;
img_paloma.style.display=obj_chk.style.display=='none'?'inline':'none';
//obj_chk.fireEvent('onClick');
}


function fechas_chk_mouseover(obj_chk, obj_txt, img_paloma)
{
//if (confirm('fechas_chk_mouseover')) return false;
obj_txt==undefined?obj_txt=document.all[obj_chk.sourceIndex+2]:null;
img_paloma==undefined?img_paloma=document.all[obj_chk.sourceIndex+1]:null;
obj_txt.value=obj_chk.checked?(obj_txt.className=='moneda'?format_currency(obj_chk.value):obj_chk.value):'';
obj_chk.style.display=(obj_chk.style.visibility=='hidden' || obj_txt.readOnly)?'none':'inline';
img_paloma.style.display=obj_txt.readOnly && obj_chk.style.visibility!='hidden'?'inline':'none';
img_paloma.style.visibility=obj_chk.checked?'visible':'hidden';
obj_txt.style.visibility=(obj_chk.style.visibility=='hidden' || obj_chk.checked)?'visible':'hidden';
//if (confirm('fechas_chk_mouseover... terminando')) return false;

obj_txt.fireEvent('onmouseover');
//if (confirm('fechas_chk_mouseover... TERMINADO')) return false;
}


function fechas_chk_click(obj_chk, obj_txt)
{
//if (confirm('fechas_chk_click')) return false;
obj_txt==undefined?obj_txt=document.all[obj_chk.sourceIndex+2]:null;
obj_txt.value=obj_chk.checked?obj_chk.value:'';
//if (confirm('fechas_chk_click... terminando')) return false;
obj_txt.fireEvent('onblur');
//if (confirm('fechas_chk_click... TERMINADO')) return false;
}


function fechas_txt_blur(obj_txt, str_FechaLimite, str_FechaMin, obj_chk)
{
//if (confirm('fechas_txt_blur')) return false;
obj_chk==undefined?obj_chk=document.all[obj_txt.sourceIndex-2]:null;
formateaCaja(obj_txt);

if (obj_txt.className=='fecha')
	{
	if (str_FechaLimite!=undefined && !esVacio(str_FechaLimite))
		{
		esFechaMayor(str_FechaLimite, obj_txt.value)?obj_txt.value='':null;
		}
	else if (str_FechaMin!=undefined && !esVacio(str_FechaMin))
		{
		esFechaMayor(obj_txt.value, str_FechaMin)?obj_txt.value='':null;
		}
	else
		{
		str_FechaLimite='';
		}
	}
obj_chk.value=esVacio(obj_txt.value)?str_FechaLimite:(obj_txt.className=='moneda'?unformat_currency(obj_txt.value):obj_txt.value);
obj_chk.checked=!esVacio(obj_txt.value);
obj_chk.fireEvent('onmouseover');
obj_txt.fireEvent('onmouseover');
}



function fechas_cal_mouseover(obj_img, obj_txt)
{
//if (confirm('fechas_cal_mouseover')) return false;
obj_txt==undefined?obj_txt=document.all[obj_img.sourceIndex-1]:null;

obj_img.style.display=(obj_txt.className!='fecha' || obj_txt.style.display=='none' || obj_txt.readOnly || obj_txt.disabled)?'none':'inline';

obj_img.style.visibility=(obj_txt.className!='fecha' || obj_txt.readOnly || obj_txt.disabled || obj_txt.style.display=='none' || obj_txt.style.visibility=='hidden')?'hidden':'visible';
//if (confirm('fechas_cal_mouseover... TERMINADO')) return false;
}


function fechas_cal_click(obj_img, obj_txt)
{
//if (confirm('fechas_cal_click')) return false;
obj_txt==undefined?obj_txt=document.all[obj_img.sourceIndex-1]:null;
FechaCalendario(obj_txt);
//if (confirm('fechas_cal_click... terminando')) return false;
obj_txt.fireEvent('onchange');
obj_txt.focus();
//if (confirm('fechas_cal_click... TERMINADO')) return false;
}

function fnc_fechas_onblur(txt_obj)
{
formatObject(txt_obj); 
!checkLimits(txt_obj.value, !(txt_obj.maxValue)?'':(isDateType(txt_obj.maxValue)?txt_obj.maxValue:getVal(eval(txt_obj.maxValue.replace(/this/gm, 'event.srcElement')))), !(txt_obj.minValue)?'':(isDateType(txt_obj.minValue)?txt_obj.minValue:getVal(eval(txt_obj.minValue.replace(/this/gm, 'event.srcElement')))) )?txt_obj.value=txt_obj.defaultValue:null; 
obj_chk=document.all[txt_obj.sourceIndex-1]; 
if (obj_chk.value && !esVacio(txt_obj.value) && obj_chk.value!=getVal(txt_obj)) 
	{
	obj_chk.value=getVal(txt_obj);
	} 
obj_chk.checked=(!esVacio(getVal(txt_obj))); 
}
function fnc_fechas_onpropertychange(txt_obj, var_propertyName)
{
if (!(var_propertyName!='value' || var_propertyName=='value' && txt_obj!=document.activeElement)) return false

if (document.readyState=='complete' && like(var_propertyName, 'style.visibility, style.display')) 
	{
	eval('txt_obj.parentNode.'+event.propertyName+'=txt_obj.'+event.propertyName);
	return true;
	} 
	
if (document.readyState=='complete' && document.activeElement!=txt_obj && var_propertyName=='value') 
	{ 
	txt_obj.fireEvent('onblur'); 
	return true; 
	}
}
/*vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv*/
function checaLimite(obj_txt, str_limite_sup, str_limite_inf, str_advertencia)
{
str_limite_sup==undefined?str_limite_sup='':null
str_limite_inf==undefined?str_limite_inf='':null

if (obj_txt.className=='fecha')
	{
	if ((!esVacio(str_limite_sup) && difFechas(obj_txt.value, str_limite_sup)<0 ) || (!esVacio(str_limite_inf) && difFechas(str_limite_inf, obj_txt.value)<0) ) 
		{
		alert("La fecha debe ser: \n"+(!esVacio(str_limite_inf)?("-Mayor o igual que "+str_limite_inf+"\n"):"" )+(!esVacio(str_limite_sup)?("-Menor o igual que "+str_limite_sup+"\n"):"" ))
		return false;
		}
	}
else if (like(obj_txt.className, 'moneda, porcentaje, percent, numero'))
	{
	if ((!esVacio(str_limite_sup) && getVal(obj_txt.value)>getVal(str_limite_sup) ) || (!esVacio(str_limite_inf) && getVal(obj_txt.value)<getVal(str_limite_inf)) ) 
		{
		alert(str_advertencia!=undefined?str_advertencia:"La cantidad debe ser: \n"+(!esVacio(str_limite_inf)?("-Mayor o igual que "+str_limite_inf+"\n"):"" )+(!esVacio(str_limite_sup)?("-Menor o igual que "+str_limite_sup+"\n"):"" ))
		return false;
		}
	}
return true;
//obj_txt.value=esVacio(obj_txt.value)?str_limite_sup:(obj_txt.className=='moneda'?unformat_currency(obj_txt.value):obj_txt.value);
}


function checkLimits(str_valor, str_limite_sup, str_limite_inf, str_advertencia)
{
str_limite_sup==undefined?str_limite_sup='':null
str_limite_inf==undefined?str_limite_inf='':null
if (isDateType(str_valor))
	{
	if ((!esVacio(str_limite_sup) && difFechas(str_valor, str_limite_sup)<0 ) || (!esVacio(str_limite_inf) && difFechas(str_limite_inf, str_valor)<0) ) 
		{
//		if (debug_code) alert('valor: '+str_valor+', str_limite_sup: '+str_limite_sup+', str_limite_inf: '+str_limite_inf)
		alert("La fecha debe ser: \n"+(!esVacio(str_limite_inf)?("-Mayor o igual que "+str_limite_inf+"\n"):"" )+(!esVacio(str_limite_sup)?("-Menor o igual que "+str_limite_sup+"\n"):"" ))
		return false;
		}
	}
else if (isNumber(getVal(str_valor)))
	{
//if (debug_code)	alert(getVal(str_valor)+', '+getVal(str_limite_sup)+', '+getVal(str_limite_inf)+': '+(str_valor>str_limite_sup)+', '+(str_valor<getVal(str_limite_inf)))
	if ((!esVacio(str_limite_sup) && (getVal(str_valor)>getVal(str_limite_sup)) ) || (!esVacio(str_limite_inf) && (getVal(str_valor)<getVal(str_limite_inf)) ) ) 
		{
		alert(str_advertencia!=undefined?str_advertencia:"La cantidad debe ser: \n"+(!esVacio(str_limite_inf)?("-Mayor o igual que "+str_limite_inf+"\n"):"" )+(!esVacio(str_limite_sup)?("-Menor o igual que "+str_limite_sup+"\n"):"" ))
		return false;
		}
	}
	
return true;
//obj_txt.value=esVacio(obj_txt.value)?str_limite_sup:(obj_txt.className=='moneda'?unformat_currency(obj_txt.value):obj_txt.value);
}


function objFechas_inicializaCalendario(obj_img, obj_txt)
{
obj_img.style.visibility=(obj_txt.className!='fecha' || obj_txt.readOnly || obj_txt.disabled || obj_txt.style.display=='none' || obj_txt.style.visibility=='hidden')?'hidden':'visible'; 
}
/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*/

function completaFecha(campo, limite)
{
var fecha_completa=fillDate(campo.value, limite)
campo.value!=fecha_completa?campo.value=fecha_completa:null;
}


function fillDate(val, limite)
{
limite=(limite==undefined?0:limite)
var datePat = /^(\d{1,2})(\/|-)(\d{1,2})$/;
var matchArray = val.match(datePat);

var datePat = /^(\d{1,2})(\/|-)(\d{1,2})\2(\d{2,4})$/;
var matchFullArray = val.match(datePat);
var hoy=new Date()
var year=hoy.getYear()

if (parseInt(year)<100)
	{
	year=(parseInt(year)>30?"19":"20")+String(year)
	}

if (matchArray != null)
	{
	val=String( val+"/"+year )
	day = matchArray[1];
	month = matchArray[3];
	}
else if (!isNaN(val) && parseInt(val)>0 && parseInt(val)<=31 )
	{
	day = parseInt(val);
	month = (parseInt(hoy.getMonth())+1);
	}
else if (!isNaN(val) && parseInt(val)>1900)
	{
	if (limite==1)
		{
		day = 31;
		month = 12;
		}
	else
		{
		day = 1;
		month = 1;
		}
	year = parseInt(val);
	}
else if (matchFullArray != null)
	{
	day = matchFullArray[1];
	month = matchFullArray[3];
	year = matchFullArray[4];
	year = (year.length==4?year/*.substr(2)*/:(parseInt(year)>30?"19":"20")+String(year))
	}
var val=fillWith(String(day), "0", 2, "left")+"/"+fillWith(String(month), "0", 2, "left")+"/"+year;
return val;
}

function fillWith(sValue, sFill, iLength, sPosition)
{
var sNewString=''
sPosition==undefined?sPosition='right':null;
var iCurrentLength=sValue.length;
var sFilled=replicate(sFill, iLength-iCurrentLength)
sNewString= (sPosition=='left'?sFilled:'')+sValue+(sPosition=='right'?sFilled:'')
return sNewString
}

function replicate(sString, iTimes)
{
var sNewString='';
while(iTimes) 
	{
	if(iTimes&1) {sNewString+=sString;}
	sString+=sString;
	iTimes>>=1;
	}
return sNewString;
}

function checa_fecha(campo, limite)
{
//'limite' sirve para poder poner solamente el año y que automaticamente agregue el limite inferior o superior del año i.e. 1/1/05 o 31/12/05
limite=(limite==undefined?0:limite)
completaFecha(campo, limite)
//alert(''
if (!isDateType(formatDate(campo).value) && !esVacio(campo.value))
	{
	alert ("No es una fecha valida");
	campo.focus();
	}
}


function recuperaFecha(valor) // esta función agarra la fecha del string del status
{
tamanio=valor.length
descuento=strReverse(valor).indexOf("/")+1+5
fecha=valor.substr(parseFloat(valor.length)-parseFloat(descuento));
fecha=fecha.substr(0,fecha.length-1);
return (fecha);
}



/*String.prototype.isPercent = function() 
{
if (esVacio(this)) return false;
return ( this.search(/\%/g)!=-1 );
}
*/
String.prototype.isPercent = function() 
{
//var datePat = /^((\d*)(\.?\d+)?)(%)$/;
return (this.search(/(\d?(\.?\d+)?)(%)$/)!=-1)
}

String.prototype.isDate = function() 
{
return false;
//return !isNaN(new Date(this));		// <<--- this needs checking
if (esVacio(this)) return false;
var datePat = /^(\d{1,2})(\/|-)(\d{1,2})\2(\d{2,4})$/;
var matchArray = this.match(datePat);
if (matchArray == null) return false;
month = matchArray[3];
day = matchArray[1];
year = matchArray[4];
if (month < 1 || month > 12) return false;
if (day < 1 || day > 31) return false;
if ((month==4 || month==6 || month==9 || month==11) && day==31) return false;
if (month == 2)
	{
	var isleap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
	if (day>29 || (day==29 && !isleap)) return false;
	}
return true;
}

String.prototype.is_Date = function() 
{
return !isNaN(new Date(this));		// <<--- this needs checking
}


function isDateType(str_fecha) 
{
//return !isNaN(new Date(str_fecha));		// <<--- this needs checking
if (esVacio(str_fecha)) return false;
var datePat = /^(\d{1,2})(\/|-)(\d{1,2})\2(\d{2,4})$/;
var matchArray = String(str_fecha).match(datePat);
if (matchArray == null) return false;
month = matchArray[3];
day = matchArray[1];
year = matchArray[4];
if (month < 1 || month > 12) return false;
if (day < 1 || day > 31) return false;
if ((month==4 || month==6 || month==9 || month==11) && day==31) return false;
if (month == 2)
	{
	var isleap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
	if (day>29 || (day==29 && !isleap)) return false;
	}
return true;
}


function formatDate(campo)
{
var datePat = /^(\d{1,2})(\/|-)(\d{1,2})\2(\d{2,4})$/;
var matchArray = campo.value.match(datePat);
if (matchArray == null) { if (!esVacio(campo.value)) alert('La fecha debe estar en formato dd/mm/aaaa'); campo.value=''; return campo;}
month = matchArray[3];
day = matchArray[1];
year = matchArray[4];
diastr=""+day;
if(diastr.length==1) diastr="0"+diastr;
messtr=""+month;
if(messtr.length==1) messtr="0"+messtr;
var fecha_completa=diastr+"/"+messtr+"/"+(year.length==4?year/*.substr(2)*/:(parseInt(year)>30?"19":"20")+String(year))
campo.value!=fecha_completa?campo.value=fecha_completa:null;
return campo;
}


function esFecha(campo)
{
var dateStr=campo.value;
if(isDateType(dateStr))
	{
	var datePat = /^(\d{1,2})(\/|-)(\d{1,2})\2(\d{2,4})$/;
	var matchArray = dateStr.match(datePat);
	if (matchArray == null) return false;

	month = matchArray[3];
	day = matchArray[1];
	year = matchArray[4];
	if (month < 1 || month > 12) return false;
	if (day < 1 || day > 31) return false;
	if ((month==4 || month==6 || month==9 || month==11) && day==31) return false;
	if (month == 2)
		{
		var isleap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
		if (day>29 || (day==29 && !isleap)) return false;
		}
	objfec=campo;
	diastr=""+day;
	if(diastr.length==1) diastr="0"+diastr;
	messtr=""+month;
	if(messtr.length==1) messtr="0"+messtr;
	objfec.value=diastr+"/"+messtr+"/"+year;
	}
return true;
}


/*function esFecha(campo)
{
var dateStr=campo.value;
if(dateStr)
	{
	var datePat = /^(\d{1,2})(\/|-)(\d{1,2})\2(\d{2,4})$/;
	var matchArray = dateStr.match(datePat);
	if (matchArray == null) return false;

	month = matchArray[3];
	day = matchArray[1];
	year = matchArray[4];
	if (month < 1 || month > 12) return false;
	if (day < 1 || day > 31) return false;
	if ((month==4 || month==6 || month==9 || month==11) && day==31) return false;
	if (month == 2)
		{
		var isleap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
		if (day>29 || (day==29 && !isleap)) return false;
		}
	objfec=campo;
	diastr=""+day;
	if(diastr.length==1) diastr="0"+diastr;
	messtr=""+month;
	if(messtr.length==1) messtr="0"+messtr;
	objfec.value=diastr+"/"+messtr+"/"+year;
	}
return true;
}*/


/* Author: Badrinath Chebbi		Date: 01-04-2002
Traducción y adaptación para múltiples objetos:
Uriel Gomez R.					Fecha: 04/09/04 */

var aMonthNames = new Array
(
'JANUARY', 'FEBRUARY', 'MARCH', 
'APRIL', 'MAY', 'JUNE', 
'JULY',	'AUGUST', 'SEPTEMBER', 
'OCTOBER', 'NOVEMBER', 'DECEMBER'
);

var aMonthDisplay = new Array
(
'01', '02', '03', 
'04', '05', '06', 
'07', '08', '09', 
'10', '11', '12'
);	

var aMonthDays = new Array
(
/* ENE */ 31, /* FEB */ 28, /* MAR */ 31, /* ABR */ 30, 
/* MAY */ 31, /* JUN */ 30, /* JUL */ 31, /* AGO */ 31, 
/* SEP */ 30, /* OCT */ 31, /* NOV */ 30, /* DIC */ 31 
);

var days = new Array(42);

/* Esta funcion llama al calendario y le manda el campo en el que lo tiene que devolver */
function FechaCalendario(txt_fecha)
{
str_fecha=showModalDialog(rootFolder+"calendario.html", "", "dialogWidth:20; dialogHeight:26; help:no; scroll:no; status:no; unadorned:yes")
if (str_fecha!=undefined && !esVacio(str_fecha))
	{
	txt_fecha.value=str_fecha
	}
txt_fecha.focus()
}
	
/* Esta funcion llena la tabla con las fechas para un mes específico de un año específico */
function daylayerdisplay(b,a,c)
{
/*Comment3 starts
  b es el año en el formato de aaaa
  a es el mes en formato numerico: 0=enero,1=febrero etc
  c es el dia en formato numerico
  Comment3 ends
*/
monthreduction=a;
monthincrease=a;
if (b%4 == 0 || b%100 ==0)
	{
	aMonthDays[1]=29;
	}
else
	{
	aMonthDays[1]=28;
	}
var oDateNow = new Date();
var oDate = new Date(aMonthNames[a] +  1 + "," + b);
dayofweek=oDate.getDay();

//Pone los numeros en las casillas
var count=0;
var count1;
var 
end=aMonthDays[a]+(dayofweek);
for (s=1;s<=42;s++)
	{
	document.getElementById("day"+s).childNodes[0].innerHTML="";
	}

for (s=(dayofweek+1);s<=end;s++)
	{
	count=count+1;
	if (oDateNow.getDate()==count)
		{
		document.getElementById("day"+s).childNodes[0].innerHTML="<b>"+count+"</b>";
		}
	else
		{
		document.getElementById("day"+s).childNodes[0].innerHTML=count;
		}

	if (count<=9)
		{
		count1=0+""+count;
		}
	else
		{
		count1=count;
		}
	document.getElementById("day"+s).childNodes[0].id=count1;
	}
}
	
/* Regresa la fecha*/
function sendvalue(y,m,d)
{
if (y == 1)
	{
	todayobj= new Date();
	year=todayobj.getYear();
	if (todayobj.getDate() <= 9)
		{
		var todayday=0+""+todayobj.getDate();
		}
	else
		{
		var todayday=todayobj.getDate();
		}
	return (todayday + "/" + aMonthDisplay[todayobj.getMonth()] + "/" + year);
	}
else
	{
	return (d+"/"+aMonthDisplay[m]+"/"+y);
	}
}

/* Quita uno al mes cada que el botón de anterior se presiona*/
function reducemonths()
{ 
monthreduction= +monthreduction - 1;
if (monthreduction==-1)
	{
	monthreduction=11;
	document.calendarform.year.value=parseFloat(document.calendarform.year.value)-1;
	}
document.calendarform.month[monthreduction].selected = "1";
daylayerdisplay(document.calendarform.year.value,monthreduction,101);
}

/* Incrementa 1 al mes cada que el botón de siguiente se presiona*/
function increasemonths()
{ 
monthincrease= +monthincrease + 1;
if (monthincrease==12)
	{
 	monthincrease=0;
	document.calendarform.year.value=parseFloat(document.calendarform.year.value)+1;
	}
document.calendarform.month[monthincrease].selected = "1";
daylayerdisplay(document.calendarform.year.value,monthincrease,101);
}





function textboxSelect(oTextbox)
{ 
(oTextbox==undefined?oTextbox=event.srcElement:null)
if (!oTextbox.readOnly)
	{
	var oRange = oTextbox.createTextRange();
	oRange.moveStart("character", 0);
	oRange.moveEnd("character", oTextbox.value.length-1);
	oRange.select();         
	}
}


function imprimeTodo(NombreEmpresa, Cad)
{
document.body.style.marginRight = '33px';
document.body.style.marginLeft = '33px';
document.body.style.marginTop = '33px';
document.body.style.marginBotton = '40px';
window.print()
//doPrint(NombreEmpresa, Cad)
}


function convertViewLinks(cll_body)
{
cont_view=0
for (kk=0; kk<(cll_body.all.tags('INPUT').length?cll_body.all.tags('INPUT').length:1); kk++)
	{
	cll_inputs=(cll_body.all.tags('INPUT').length?cll_body.all.tags('INPUT')(kk):cll_body.all.tags('INPUT'))
	if (cll_inputs.type=='viewlink')
		{
		//id para identificar a la coleccion label
		lbl_view=top.frames('resultados').document.createElement('<label id="lbl_viewLink"></label>') 
		
		lbl_view.innerText=getVal(cll_inputs) //paso value de viewLink a Label			
		array_viewLink[cont_view]=cll_inputs
		cll_inputs.replaceNode(lbl_view)		
		cont_view++		
		}
	}
}

function formatFrame(oSourceFrame, oBackgroundFrame)
{
try 
	{
	if (oSourceFrame.dataTable)
		oBackgroundFrame.document.body.innerHTML=oSourceFrame.dataTable.outerHTML.replace(/&nbsp;/gm, ' ')
	else
		oBackgroundFrame.document.body.innerHTML=oSourceFrame.document.body.outerHTML.replace(/&nbsp;/gm, ' ')
	}
catch (e) {}

var celdasTH = oBackgroundFrame.document.body.all.tags("TH");
var celdasTD = oBackgroundFrame.document.body.all.tags("TD");
var TipoInput = oBackgroundFrame.document.body.all.tags("INPUT");
var TipoLabel = oBackgroundFrame.document.body.all.tags("LABEL");
var TipoScript = oBackgroundFrame.document.body.all.tags("SCRIPT");
var TipoTextArea = oBackgroundFrame.document.body.all.tags("TEXTAREA");
var imagenes = oBackgroundFrame.document.body.all.tags("IMG");
var stylesheets_cll = oBackgroundFrame.document.styleSheets;

var j=0
try
	{
	oBackgroundFrame.headerTable.removeNode(true);
	} catch (e) {}

tamanio=celdasTH.length
for (i=tamanio-1; i>=0; --i)
	{
	status='Formateando (1 de 9): '+(tamanio-i)+' de '+parseFloat(tamanio)
	if (!(celdasTH[i].style.visibility!='hidden' && celdasTH[i].style.display!='none'))
		{
		celdasTH[i].removeNode(true);
		}
	else
		{
		cll_content=celdasTH[i].all;
		for (c=cll_content.length-1; c>=0; --c)
			{
			if (!(cll_content[c].style.visibility!='hidden' && cll_content[c].style.display!='none'))
				{
				cll_content[c].removeNode(true);
				}
			}
		}
	}

tamanio=celdasTD.length
for (i=celdasTD.length-1; i>=0; --i)
	{
	status='Formateando (2 de 9): '+(tamanio-i)+' de '+parseFloat(tamanio)
//	if (debug_code && confirm('Valor: '+celdasTD[i].innerText)) return false;
//	if (debug_code && celdasTD[i].className=='texto') alert('Valor: '+celdasTD[i].innerText);
	if (!(celdasTD[i].style.visibility!='hidden' && celdasTD[i].style.display!='none'))
		{
		celdasTD[i].removeNode(true);
		}
	else
		{
		cll_content=celdasTD[i].all;
		for (c=cll_content.length-1; c>=0; --c)
			{
/*			if (debug_code && cll_content.length>1)
				{
				if (confirm(cll_content.length+', '+celdasTH[i].style+' cancelar?')) return false;
				}*/
//			if (debug_code &&  confirm(cll_content[c].className+', visibility: ('+cll_content[c].style.visibility+' - '+retrieveCSSValue((cll_content[c].className || cll_content[c].id), 'visibility', stylesheets_cll)+'), display: ('+cll_content[c].style.display+' - '+retrieveCSSValue((cll_content[c].className || cll_content[c].id), 'display', stylesheets_cll)+'), Valor: '+cll_content[c].innerText)) return false;
			
			if (!(cll_content[c].style.visibility!='hidden' && cll_content[c].style.display!='none') || ((cll_content[c].style.visibility=='' && cll_content[c].style.display=='') && !(retrieveCSSValue((cll_content[c].className || cll_content[c].id), 'visibility', stylesheets_cll)!='hidden' && retrieveCSSValue((cll_content[c].className || cll_content[c].id), 'display', stylesheets_cll)!='none') ))
				{
				cll_content[c].removeNode(true);
				}
			}
		}
	celdasTD[i].style.color='black';
	}

var oTextNode;
// Cambia todos los Input
if (TipoInput.length)
	{
	tamanio=TipoInput.length	
	for (i=TipoInput.length-1; i>=0; --i)
		{
		status='Formateando (3 de 9): '+(tamanio-i)+' de '+parseFloat(tamanio)
		if (TipoInput[i].style.visibility!='hidden' && TipoInput[i].style.display!='none')
			{
			if (TipoInput[i].type=="text" || TipoInput[i].type=="viewlink")
				{
		  		oTextNode = eval("oBackgroundFrame.document.createTextNode(\""+getVal(TipoInput[i])+"\")");
				TipoInput[i].replaceNode(oTextNode);
				}
			else if (TipoInput[i].type=="checkbox" || TipoInput[i].type=="radio" )
				{
				if (TipoInput[i].checked==true)
					{
		  			valor='X'
					}
				else
					{
					valor=''
					}
				oTextNode = eval("oBackgroundFrame.document.createTextNode(\""+valor+"\")");
				TipoInput[i].replaceNode(oTextNode);
				}
			else
				{
				TipoInput[i].removeNode(true);
				}
			}
		else
			{
			TipoInput[i].removeNode(true);
			}
		}
	}

var oTextNode;
if (TipoLabel.length)
	{
	tamanio=TipoLabel.length
	for (i=TipoLabel.length-1; i>=0; --i)
		{
		status='Formateando (4 de 9): '+(tamanio-i)+' de '+parseFloat(tamanio)
		if (TipoLabel[i].style.visibility!='hidden' && TipoLabel[i].style.display!='none')
			{
			try 
				{
		  		oTextNode = eval("oBackgroundFrame.document.createTextNode(\""+TipoLabel[i].innerText+"\")");
				TipoLabel[i].replaceNode(oTextNode);
				}
			catch(e) {status+=' Error';}
			}
		else
			{
			TipoLabel[i].removeNode(true);
			}
		}
	}

// Quita todos los scripts
if (TipoScript.length)
	{
	tamanio=TipoScript.length
	for (i=TipoScript.length-1; i>=0; --i)
		{
		status='Formateando (5 de 9): '+(tamanio-i)+' de '+parseFloat(tamanio)
		TipoScript[i].removeNode(true);
		}
	}

// Cambia todos los TextAreas
if (TipoTextArea.length)
	{
	tamanio=TipoTextArea.length
	for (i=TipoTextArea.length-1; i>=0; --i)
		{
		status='Formateando (6 de 9): '+(tamanio-i)+' de '+parseFloat(tamanio)
		if (TipoTextArea[i].style.visibility!='hidden' && TipoTextArea[i].style.display!='none')
			{
			oTextNode = eval("oBackgroundFrame.document.createTextNode(\""+TipoTextArea[i].innerText.replace(/[\n|\r]/gm, "\t")+"\")");
			TipoTextArea[i].replaceNode(oTextNode);
			}
		}
	}

// Cambia todos los selects
var TipoSelect = oBackgroundFrame.document.body.all.tags("SELECT");
if (TipoSelect.length)
	{
	tamanio=TipoSelect.length
	for (i=TipoSelect.length-1; i>=0; --i)
		{
		status='Formateando (7 de 9): '+(tamanio-i)+' de '+parseFloat(tamanio)
		if (TipoSelect[i].style.visibility!='hidden' && TipoSelect[i].style.display!='none')
			{
			oTextNode = eval("oBackgroundFrame.document.createTextNode(\""+TipoSelect[i].options[TipoSelect[i].selectedIndex].text+"\")");
			TipoSelect[i].replaceNode(oTextNode);
			}
		}
	}

// Cambia todos los vinculos
var vinculos = oBackgroundFrame.document.body.all.tags("A");
if (vinculos.length)
	{
	tamanio=vinculos.length
	for (i=vinculos.length-1; i>=0; --i)
		{
		status='Formateando (8 de 9): '+(tamanio-i)+' de '+parseFloat(tamanio)
		if (vinculos[i].style.visibility!='hidden' && vinculos[i].style.display!='none')
			{
			oTextNode = eval("oBackgroundFrame.document.createTextNode(\""+vinculos[i].innerText.replace(/[\n|\r]/gm, "\t")+"\")");
			vinculos[i].replaceNode(oTextNode);
			}
		}
	}

// Cambia todas las imagenes
if (imagenes.length)
	{
	tamanio=vinculos.length
	for (i=imagenes.length-1; i>=0; --i)
		{
		status='Formateando (9 de 9): '+(tamanio-i)+' de '+parseFloat(tamanio)
		if (imagenes[i].style.visibility!='hidden' && imagenes[i].style.display!='none' && imagenes[i].src.search(/check.gif/gi)!=-1)
			{
			oTextNode = eval("oBackgroundFrame.document.createTextNode('X')");
			imagenes[i].replaceNode(oTextNode);
			}
		else
			{
			imagenes[i].removeNode(true);
			}
		}
	}

mensajeStatus('Formateando completado')
}

var array_viewLink= new Array() //Arreglo para guardar los viewLink que encuentre en Excel y remplazar por labels
function cuantosObjetos(cll_body)
{
cll_body==undefined?cll_body=top.frames('resultados').document.body:null;
cont_view=0
for (kk=0; kk<(cll_body.all.tags('INPUT').length?cll_body.all.tags('INPUT').length:1); kk++)
	{
	cll_objetotes=(cll_body.all.tags('INPUT').length?cll_body.all.tags('INPUT')(kk):cll_body.all.tags('INPUT'))
	if (cll_objetotes.type=='viewlink')
		{
		//id para identificar a la coleccion label
		lbl_view=top.frames('resultados').document.createElement('<label id="lbl_viewLink"></label>') 
		
		lbl_view.innerText=getVal(cll_objetotes) //paso value de viewLink a Label			
		array_viewLink[cont_view]=cll_objetotes
		cll_objetotes.replaceNode(lbl_view)		
		cont_view++		
		}
	}
}

function retrieveViewLink()
{
cll_body=top.frames('resultados').document.body
cont_view=0
for (kk=0; kk<(cll_body.all.tags('LABEL').length?cll_body.all.tags('LABEL').length:1); kk++)
	{
	cll_objetotes=(cll_body.all.tags('LABEL').length?cll_body.all.tags('LABEL')(kk):cll_body.all.tags('LABEL'))	
	if (cll_objetotes.id=='lbl_viewLink')
		{		
		cll_objetotes.replaceNode(array_viewLink[cont_view])
		cont_view++		
		}
	}
}
 
function darFormato(objFrame)
{

try 
	{
	if (top.frames('resultados').dataTable)
		{
		
		top.frames('transacciones').document.body.innerHTML=top.frames('resultados').dataTable.outerHTML
		}
	else
		top.frames('transacciones').document.body.innerHTML=top.frames('resultados').document.body.outerHTML
	}
catch (e) {}

var celdasTH = objFrame.document.body.all.tags("TH");
var celdasTD = objFrame.document.body.all.tags("TD");
var TipoInput = objFrame.document.body.all.tags("INPUT");
var TipoLabel = objFrame.document.body.all.tags("LABEL");
var TipoScript = objFrame.document.body.all.tags("SCRIPT");
var TipoTextArea = objFrame.document.body.all.tags("TEXTAREA");
var imagenes = objFrame.document.body.all.tags("IMG");
var stylesheets_cll = top.frames('resultados').document.styleSheets;

var j=0
try
	{
	objFrame.headerTable.removeNode(true);
	} catch (e) {}

tamanio=celdasTH.length
for (i=tamanio-1; i>=0; --i)
	{
	status='Formateando (1 de 9): '+(tamanio-i)+' de '+parseFloat(tamanio)
	if (!(celdasTH[i].style.visibility!='hidden' && celdasTH[i].style.display!='none'))
		{
		celdasTH[i].removeNode(true);
		}
	else
		{
		cll_content=celdasTH[i].all;
		for (c=cll_content.length-1; c>=0; --c)
			{
			if (!(cll_content[c].style.visibility!='hidden' && cll_content[c].style.display!='none'))
				{
				cll_content[c].removeNode(true);
				}
			}
		}
	}

tamanio=celdasTD.length
for (i=celdasTD.length-1; i>=0; --i)
	{
	status='Formateando (2 de 9): '+(tamanio-i)+' de '+parseFloat(tamanio)
//	if (debug_code && confirm('Valor: '+celdasTD[i].innerText)) return false;
//	if (debug_code && celdasTD[i].className=='texto') alert('Valor: '+celdasTD[i].innerText);
	if (!(celdasTD[i].style.visibility!='hidden' && celdasTD[i].style.display!='none'))
		{
		celdasTD[i].removeNode(true);
		}
	else
		{
		cll_content=celdasTD[i].all;
		for (c=cll_content.length-1; c>=0; --c)
			{
/*			if (debug_code && cll_content.length>1)
				{
				if (confirm(cll_content.length+', '+celdasTH[i].style+' cancelar?')) return false;
				}*/
//			if (debug_code &&  confirm(cll_content[c].className+', visibility: ('+cll_content[c].style.visibility+' - '+retrieveCSSValue((cll_content[c].className || cll_content[c].id), 'visibility', stylesheets_cll)+'), display: ('+cll_content[c].style.display+' - '+retrieveCSSValue((cll_content[c].className || cll_content[c].id), 'display', stylesheets_cll)+'), Valor: '+cll_content[c].innerText)) return false;
			
			if (!(cll_content[c].style.visibility!='hidden' && cll_content[c].style.display!='none') || ((cll_content[c].style.visibility=='' && cll_content[c].style.display=='') && !(retrieveCSSValue((cll_content[c].className || cll_content[c].id), 'visibility', stylesheets_cll)!='hidden' && retrieveCSSValue((cll_content[c].className || cll_content[c].id), 'display', stylesheets_cll)!='none') ))
				{
				cll_content[c].removeNode(true);
				}
			}
		}
	celdasTD[i].style.color='black';
	}

var oTextNode;
// Cambia todos los Input
if (TipoInput.length)
	{
	tamanio=TipoInput.length	
	for (i=TipoInput.length-1; i>=0; --i)
		{
		status='Formateando (3 de 9): '+(tamanio-i)+' de '+parseFloat(tamanio)
		if (TipoInput[i].style.visibility!='hidden' && TipoInput[i].style.display!='none')
			{
			if (TipoInput[i].type=="text" || TipoInput[i].type=="viewlink")
				{
		  		oTextNode = eval("objFrame.document.createTextNode(\""+getVal(TipoInput[i])+"\")");
				TipoInput[i].replaceNode(oTextNode);
				}
			else if (TipoInput[i].type=="checkbox" || TipoInput[i].type=="radio" )
				{
				if (TipoInput[i].checked==true)
					{
		  			valor='X'
					}
				else
					{
					valor=''
					}
				oTextNode = eval("objFrame.document.createTextNode(\""+valor+"\")");
				TipoInput[i].replaceNode(oTextNode);
				}
			else
				{
				TipoInput[i].removeNode(true);
				}
			}
		else
			{
			TipoInput[i].removeNode(true);
			}
		}
	}

var oTextNode;
if (TipoLabel.length)
	{
	tamanio=TipoLabel.length
	for (i=TipoLabel.length-1; i>=0; --i)
		{
		status='Formateando (4 de 9): '+(tamanio-i)+' de '+parseFloat(tamanio)
		if (TipoLabel[i].style.visibility!='hidden' && TipoLabel[i].style.display!='none')
			{
			try 
				{
		  		oTextNode = eval("objFrame.document.createTextNode(\""+TipoLabel[i].innerText+"\")");
				TipoLabel[i].replaceNode(oTextNode);
				}
			catch(e) {status+=' Error';}
			}
		else
			{
			TipoLabel[i].removeNode(true);
			}
		}
	}

// Quita todos los scripts
if (TipoScript.length)
	{
	tamanio=TipoScript.length
	for (i=TipoScript.length-1; i>=0; --i)
		{
		status='Formateando (5 de 9): '+(tamanio-i)+' de '+parseFloat(tamanio)
		TipoScript[i].removeNode(true);
		}
	}

// Cambia todos los TextAreas
if (TipoTextArea.length)
	{
	tamanio=TipoTextArea.length
	for (i=TipoTextArea.length-1; i>=0; --i)
		{
		status='Formateando (6 de 9): '+(tamanio-i)+' de '+parseFloat(tamanio)
		if (TipoTextArea[i].style.visibility!='hidden' && TipoTextArea[i].style.display!='none')
			{
			oTextNode = eval("objFrame.document.createTextNode(\""+TipoTextArea[i].innerText.replace(/[\n|\r]/gm, "\t").replace(/"/gm, "\\\"")+"\")");
			TipoTextArea[i].replaceNode(oTextNode);
			}
		}
	}

// Cambia todos los selects
var TipoSelect = objFrame.document.body.all.tags("SELECT");
if (TipoSelect.length)
	{
	tamanio=TipoSelect.length
	for (i=TipoSelect.length-1; i>=0; --i)
		{
		status='Formateando (7 de 9): '+(tamanio-i)+' de '+parseFloat(tamanio)
		if (TipoSelect[i].style.visibility!='hidden' && TipoSelect[i].style.display!='none')
			{
			oTextNode = eval("objFrame.document.createTextNode(\""+TipoSelect[i].options[TipoSelect[i].selectedIndex].text+"\")");
			TipoSelect[i].replaceNode(oTextNode);
			}
		}
	}

// Cambia todos los vinculos
var vinculos = objFrame.document.body.all.tags("A");
if (vinculos.length)
	{
	tamanio=vinculos.length
	for (i=vinculos.length-1; i>=0; --i)
		{
		status='Formateando (8 de 9): '+(tamanio-i)+' de '+parseFloat(tamanio)
		if (vinculos[i].style.visibility!='hidden' && vinculos[i].style.display!='none')
			{
			oTextNode = eval("objFrame.document.createTextNode(\""+vinculos[i].innerText.replace(/[\n|\r]/gm, "\t")+"\")");
			vinculos[i].replaceNode(oTextNode);
			}
		}
	}

// Cambia todas las imagenes
if (imagenes.length)
	{
	tamanio=vinculos.length
	for (i=imagenes.length-1; i>=0; --i)
		{
		status='Formateando (9 de 9): '+(tamanio-i)+' de '+parseFloat(tamanio)
		if (imagenes[i].style.visibility!='hidden' && imagenes[i].style.display!='none' && imagenes[i].src.search(/check.gif/gi)!=-1)
			{
			oTextNode = eval("objFrame.document.createTextNode('X')");
			imagenes[i].replaceNode(oTextNode);
			}
		else
			{
			imagenes[i].removeNode(true);
			}
		}
	}

mensajeStatus('Formateando completado')
}

function mensajeStatus(mensaje)
{
status=mensaje
IntervaloProgBar=window.setInterval("status=''; window.clearInterval(IntervaloProgBar)",1000);
}

function hayMoneda(objFrame) //esta funcion tiene dos funciones: encuentra si hay un signo de pesos, si existe regresa true, para ver si es necesario correr la función de desformatear moneda; la otra función que tiene es hacer un trim a los datos
{
var objetos = objFrame.document.body.all;
var cont=0
var siHayMoneda=0
if ((objFrame.document.body.outerText.search(/\$/g))!=-1)
	{
	siHayMoneda=1
	}

if (objetos.length)
	{
	for (i=objetos.length-1; i>=0; --i)
		{
		if ( (objetos[i].tagName=='B' || objetos[i].tagName=='TD' || objetos[i].tagName=='TH') && objetos[i].style.visibility!='hidden' && objetos[i].style.display!='none' && !isNaN(objetos[i].innerText) && !esVacio(objetos[i].innerText) )
			{
			objetos[i].innerText=parseFloat(objetos[i].innerText)
			}
//			alert("Elemento: "+objetos[i].innerText+", isNaN: "+isNaN(objetos[i].innerText))
		}
	}

if (siHayMoneda==1)
	{
	return true;
	}
else
	{
	return false;
	}
}

function desformateaMoneda(objFrame)
{
var objetos = objFrame.document.body.all;
var cont=0
if (objetos.length)
	{
	for (i=objetos.length-1; i>=0; --i)
		{
		if (objetos[i].tagName=='B' || objetos[i].tagName=='TD' || objetos[i].tagName=='TH')
			{
			if (objetos[i].className!="texto" && (objetos[i].innerText.search(/^\s*\$?\s*(\d{1,3}(?:,\d{3})*(?:\.\d+)?)\s*$/g))!=-1)
				{
				objetos[i].innerText=unformat_currency(objetos[i].innerText)
				}
			}				
		}
	}
}

function traslateField(sField)
{
var sPath=/\[(.*?)\]/g
sField=sField.replace(sPath, "(((!like(element.tagName.toUpperCase(), 'TD, TH') && getParent('TD', element).all('$1')) || getParent('TR', element).all('$1') || getParent('TBODY', element).all('$1') || getParent('TABLE', element).all('$1') || element.document.all('$1') || $1 || 0))")
sField=sField.replace(/document\./g, "element.document.")
sField=sField.replace(/element.document.document\./g, "element.document.")

return sField
}

function traslateFields(sFormula) //For behaviors
{
var sPath=/\[(.*?)\]/g
var aObjects = new Array
var ObjectsArray=sFormula.match(sPath);
if (ObjectsArray == null) return false;

for (i=0; i<=ObjectsArray.length-1; ++i)
	{
	str_objeto=traslateField(ObjectsArray[i])
	
	try
		{
		var campo=eval(str_objeto)
		
		if (!isNaN(campo)) continue;
		aObjects[aObjects.length] = eval(str_objeto)

		if (!(campo.length))
			{
			sFormula=sFormula.replace(sPath, "getVal("+str_objeto+")")
			}
		else
			{
			sFormula=sFormula.replace(sPath, str_objeto)
			}
		}
	catch(e) {alert('Error: '+ObjectsArray[i]+'\n\n '+e.description+'\n\n'+str_objeto)}
	}
sFormula=sFormula.replace(/\[{0,1}dbo\]{0,1}\.\[{0,1}(?:\w|\s|_)+\]{0,1}\(/g, 'DBScalarFunction(element, \'$&\',')

return aObjects
}


function AbrirPagina(pagina, titulo, parametros, externo, reemplazar)
{
if (externo == undefined) externo = "1";
reemplazar==undefined?reemplazar=true:null;

var myObject = new Object();

myObject.externo = externo;
myObject.liga = pagina+"?Titulo="+titulo+parametros+"&LinkExterno="+externo+"";

if (externo!="1")
	{
	if (reemplazar)
		location.replace(myObject.liga);
	else
		window.location=(myObject.liga);
	}
else
	{
	var resultados=window.showModalDialog(rootFolder+"ventanas.asp?Titulo="+titulo, myObject, "help:no; status=yes; resizable:yes; dialogHeight:"+String(document.body.offsetHeight+30)+"px; dialogWidth:"+String(document.body.offsetWidth+6)+"px; dialogLeft:114px; dialogTop:160px; ");
	if (resultados!=undefined && !esVacio(resultados))
		{
		return resultados;
		}
	else
		{
		return '';
		}
	}
}

function SaveCommand(oTarget)
{
try
	{
	if (oTarget) 
		oTarget.Submit();
	else
		updateTable();//alert('No se pueden guardar cambios')
	} catch(e) {alert('Error en SaveCommand(): \n'+e.description)}
}


function testPage(sTableName)
{
alert(sTableName)
}

function passwordComparison(oPassword, oPasswordConfirm)
{
val_Password=getVal(oPassword)
val_PasswordConfirm=getVal(oPasswordConfirm)
if (esVacio(val_Password) && !esVacio(val_PasswordConfirm)) oPasswordConfirm.value=''
else if (!esVacio(val_Password) && !esVacio(val_PasswordConfirm) && val_Password!=val_PasswordConfirm)
	{
	alert('Las contraseñas no coinciden, vuelva a escribirlas')
	oPassword.value=''
	oPasswordConfirm.value=''
	oPassword.focus()
	}
}

function checar_errores()
{
try
	{
	if (document.enProceso>0)
		{
		//alert("Hay "+document.enProceso+" operaciones en proceso. Inténtelo de nuevo en unos segundos. \n\nGracias")
		event.returnValue=false;
		return false;
		}
	status=""
	try
		{
		if (document.formulario.target=='_self' || document.formulario.target=='transacciones')
			{
			if (document.formulario.enviar.length)
				{
				for (env=0; env<document.formulario.enviar.length; ++env)
					{
					document.formulario.enviar(env).style.visibility='hidden'
					}
				}
			else
				{
				document.formulario.enviar.style.visibility='hidden'
				}
			}
		}
	catch (iE) {alert('checar_errores() Error: '+iE.description)}
	errores=revisarErrores()
	
	if (errores==0)
		{
		status='Enviando informacion al servidor'
	//	hay_cambios=false
		event.returnValue=true;
		return true;
		}
	else
		{
		status+='Listo (con '+errores+' errores)'
		alert("Hay "+errores+" dato(s) requerido(s) sin contestar, deberá llenarlos para continuar,\n estos se marcarán en color naranja para su fácil identificación.")
		try
			{
			if (document.formulario.enviar.length)
				{
				for (env=0; env<document.formulario.enviar.length; ++env)
					{
					document.formulario.enviar[env].style.visibility='visible'
					}
				}
			else
				{
				document.formulario.enviar.style.visibility='visible'
				}
			}
	catch (iE) {alert('checar_errores() Error: '+iE.description)}
		event.returnValue=false;
		return false;
		status=''
		}
	}
catch(e) 
	{
	alert('checar_errores(): Ocurrió el siguiente error y no se puede continuar:\n\n'+e.description)
	event.returnValue=false;
	return false;
	}
}

function revisarErrores()
{
var errores=0;
checados = new Array;

var objChecar = document.all('checar_vacio');
if (objChecar)
	{
	status="Verificando "+(objChecar.length?objChecar.length:'1')+" objetos... "
	var anterior=""
	var contestado=0;
	var elementos=0;
	if (objChecar.length && objChecar.type!='select-one')
		{
		for (oC=0; oC<objChecar.length; ++oC)
			{
			existe=0
			for (j in checados)
				{
				if (String(checados[j])==String(objChecar[oC].name))
					{
					existe=1
					}
				}
			//alert(objChecar[oC].tagName+' '+objChecar[oC].name)
			if (existe==0)
				{
				checados.push(objChecar[oC].name)
				errores=marcar_errores(objChecar[oC].name, errores)
				}
			}
		}
	else
		{
		errores=marcar_errores(objChecar.name, errores)
		}
	}
var objChecarMultiple = formulario.checar_vacio_multiple
if (objChecarMultiple)
	{
	status+=" verificando "+(objChecarMultiple.length?objChecarMultiple.length:'1')+" objetos... "
	var anterior=""
	var contestado=0;
	var elementos=0;

	if (objChecarMultiple.length)
		{
		for (oCM=0; oCM<objChecarMultiple.length; ++oCM)
			{
			existe=0
			for (j in checados)
				{
				if (String(checados[j])==String(objChecarMultiple[oCM].name))
					{
					existe=1
					}
				}
	
			if (existe==0)
				{
				checados.push(objChecarMultiple[oCM].name)
				errores=marcar_errores(objChecarMultiple[oCM].name, errores)
				}
			}
		}
	else
		{
		errores=marcar_errores(objChecarMultiple.name, errores)
		}
	}

var objChecarMultipleText = formulario.checar_vacio_multiple_text
if (objChecarMultipleText)
	{
	status+=" verificando "+(objChecarMultipleText.length?objChecarMultipleText.length:'1')+" objetos... "
	var anterior=""
	var contestado=0;
	var elementos=0;

	if (objChecarMultipleText.length)
		{
		for (oCMT=0; oCMT<objChecarMultipleText.length; ++oCMT)
			{
			existe=0
			for (j in checados)
				{
				if (String(checados[j])==String(objChecarMultipleText[oCMT].name))
					{
					existe=1
					}
				}
	
			if (existe==0)
				{
				checados.push(objChecarMultipleText[oCMT].name)
				errores=marcar_errores(objChecarMultipleText[oCMT].name, errores)
				}
			}
		}
	else
		{
		errores=marcar_errores(objChecarMultipleText.name, errores)
		}
	}

var objChecarTexto = formulario.checar_vacio_text
if (objChecarTexto)
	{
	status+=" verificando "+(objChecarTexto.length?objChecarTexto.length:'1')+" objetos... "
	var anterior=""
	var contestado=0;
	var elementos=0;

	if (objChecarTexto.length)
		{
		for (oCT=0; oCT<objChecarTexto.length; ++oCT)
			{
			existe=0
			for (j in checados)
				{
				if (String(checados[j])==String(objChecarTexto[oCT].name))
					{
					existe=1
					}
				}
	
			if (existe==0)
				{
				checados.push(objChecarTexto[oCT].name)
				errores=marcar_errores(objChecarTexto[oCT].name, errores)
				}
			}
		}
	else
		{
		errores=marcar_errores(objChecarTexto.name, errores)
		}
	}
return errores

/*
var TipoInput = document.body.all.tags("INPUT");
if (TipoInput.length)
	{
	var anterior=""
	var contestado=0;
	var elementos=0;

	for (i=0; i<TipoInput.length; ++i)
		{
		existe=0
		for (j in checados)
			{
			if (String(checados[j])==String(TipoInput[i].name))
				{
				existe=1
				}
			}

		if (existe==0)
			{
			checados.push(TipoInput[i].name)
			errores=marcar_errores(TipoInput[i].name, errores)
			}
		}
	}

var TipoTextArea = document.body.all.tags("TEXTAREA");
if (TipoTextArea.length)
	{
	for (i=0; i<TipoTextArea.length; ++i)
		{
		if (TipoTextArea[i].id=="checar_vacio" && (TipoTextArea[i].value=='' || TipoTextArea[i].value=='0'))
			{
			errores=errores+1
	  		TipoTextArea[i].style.backgroundColor='#FFB76F'
			}
		else
			{
	  		TipoTextArea[i].style.backgroundColor=''
			}
		}
	}

var TipoSelect = document.body.all.tags("SELECT");
if (TipoSelect.length)
	{
	for (i=0; i<TipoSelect.length; ++i)
		{
		if (TipoSelect[i].id=="checar_vacio" && (TipoSelect[i].options[TipoSelect[i].selectedIndex].value=="0" || esVacio(TipoSelect[i].options[TipoSelect[i].selectedIndex].value)))
			{
			errores=errores+1
	  		TipoSelect[i].style.backgroundColor='#FFB76F'
			}
		else
			{
	  		TipoSelect[i].style.backgroundColor=''
			}
		}
	}
*/

}


function marcar_errores(nombre_objeto, errores)
{
if (!esVacio(nombre_objeto))
	{
	var objeto=eval("document.formulario."+nombre_objeto)
	
//	alert(nombre_objeto+', ' +objeto.type+', ' +objeto.id+', '+objeto.length)
	
	var contestado, noChecar;
	contestado=0;
	noChecar=0;
	if (objeto)
		{
		obj_actual=(objeto.length && objeto.type!='select-one')?objeto[0]:objeto;
//		alert(nombre_objeto+', ' +obj_actual.type+', ' +obj_actual.id+', '+obj_actual.length)
		if (obj_actual.id=="checar_vacio" || obj_actual.id=="checar_vacio_text" || obj_actual.id=="checar_vacio_multiple" || obj_actual.id=="checar_vacio_multiple_text")
			{
			for (o=0; o<((objeto.length && objeto.type!='select-one')?objeto.length:1); ++o)
				{
				obj_actual=(objeto.length && objeto.type!='select-one')?objeto[o]:objeto;
				valor_actual=obj_actual.type=="select-one"?obj_actual.options[obj_actual.selectedIndex].value:obj_actual.value;
				if (obj_actual.type=="checkbox" || obj_actual.type=="radio")
					{
					if (obj_actual.checked==true)
						{
						contestado=1
						}
					}
/*					else if (obj_actual.type=="select-one")
					{
					if (!((objeto.id=="checar_vacio" && (esVacio(valor_actual) || parseFloat(unformat_currency(valor_actual))==0)) || (objeto.id=="checar_vacio_text" && (esVacio(valor_actual)))) && objeto.id!="checar_vacio_multiple" && objeto.id!="checar_vacio_multiple_text")
					if ( !(obj_actual.id=="checar_vacio" && (obj_actual.options[obj_actual.selectedIndex].value=="0" || esVacio(obj_actual.options[obj_actual.selectedIndex].value))) )
						{
						contestado=1
						}
					}*/
				else if (obj_actual.type=="text" || obj_actual.type=="password" || obj_actual.type=="select-one")
					{
					if (!(((obj_actual.id=="checar_vacio") && (esVacio(valor_actual) || parseFloat(unformat_currency(valor_actual))==0)) || (obj_actual.id=="checar_vacio_text" && (esVacio(valor_actual)))) && obj_actual.id!="checar_vacio_multiple" && obj_actual.id!="checar_vacio_multiple_text")
						{
						contestado=1
						}
					}
				else if (obj_actual.type=="textarea")
					{
					if (!(((obj_actual.id=="checar_vacio") && (esVacio(valor_actual) || parseFloat(unformat_currency(valor_actual))==0)) || (obj_actual.id=="checar_vacio_text" && (esVacio(valor_actual)))) && obj_actual.id!="checar_vacio_multiple" && obj_actual.id!="checar_vacio_multiple_text")
						{
						contestado=1
						}
					}
				else if (obj_actual.type=="file")
					{
					if (!(((obj_actual.id=="checar_vacio") && (esVacio(valor_actual) || parseFloat(unformat_currency(valor_actual))==0)) || (obj_actual.id=="checar_vacio_text" && (esVacio(valor_actual)))) && obj_actual.id!="checar_vacio_multiple" && obj_actual.id!="checar_vacio_multiple_text")
						{
						contestado=1
						}
					}
				else
					{
					alert("Elemento no contemplado (collección): "+obj_actual.name+", del tipo: "+obj_actual.type+', '+obj_actual.length)
					}
				}
			}
		else
			{
			noChecar=1		
			}

		if (noChecar==0)
			{
			error_contado=0
			for (o=0; o<((objeto.length && objeto.type!='select-one')?objeto.length:1); ++o)
				{
				obj_actual=(objeto.length && objeto.type!='select-one')?objeto[o]:objeto;

				if (contestado==1 || (obj_actual.id=="checar_vacio_multiple" && !(esVacio(obj_actual.value) || parseFloat(unformat_currency(obj_actual.value))==0)) || (obj_actual.id=="checar_vacio_multiple_text" && !(esVacio(obj_actual.value) || parseFloat(unformat_currency(objeto.value))==0 )) )
					{
					obj_actual.style.backgroundColor='transparent'
					}
				else
					{
					if (error_contado==0 || (obj_actual.id=="checar_vacio_multiple" && (esVacio(obj_actual.value) || parseFloat(unformat_currency(obj_actual.value))==0)) || (obj_actual.id=="checar_vacio_multiple_text" && (esVacio(obj_actual.value) )) )
						{
						errores=errores+1
						error_contado=1
						}
/*						obj_actual.style.display='inline'
					obj_actual.style.visibility='visible'*/
					obj_actual.style.backgroundColor='#FFB76F'
					}
				}
			}
		}
	}
return errores;
}






function StopWatch() //Codigo recuperado de: http://www.codeproject.com/KB/scripting/JavaScriptStopwatch.aspx
{
var startTime = null;
var stopTime = null;
var running = false;

this.start = function()
	{
    if (running == true)
        return;
    else if (startTime != null)
        stopTime = null;
    
    running = true;    
    startTime = getTime();
	}

this.stop = function()
	{
    if (running == false) return;    
    stopTime = getTime();
    running = false;
	}

this.duration = function()
	{
    if (startTime == null || stopTime == null)
        return 'Undefined';
    else
        return (stopTime - startTime) / 1000;
	}

this.isRunning = function() { return running; }

function getTime()
	{
    var day = new Date();
    return day.getTime();
	}
}

function ZeroIfInvalid(sInput)
{
	if (!isNumber(sInput))
		return 0
	else
		return sInput
}

function repaintGridView(oObject)
{
$(oObject).closest('.GridView').get(0).init()
}

function testFormula()
{
oSource=event.srcElement
//alert(acumulado(nextRow(getParent('TR', oSource), -1).all('MontoTope'))-acumulado(nextElement(oSource, -1)))
//alert(suma($(oSource).parents("TR").prevAll().find("label[id='subtotal']")))
//alert(suma($(oSource).parents("TR").prevAll().find("[name='MontoTope']")))
//$(oSource).parents("TR").prevAll().find("[name='MontoTope'][value=''],label[id='subtotal']").css("background", "red")
//return (acumulado(nextRow(getParent('TR', oSource), -1).all('MontoTope'))-acumulado(nextElement(oSource, -1)))
//var path=/(\w*(\(([^\/\+\-\*])*\)(?!\.)))/g
return suma(getParent('TBODY', oSource).all('MontoTope'))
//acumulado(document.all('MontoTope'))   with(getParent('TR', this)) { acumulado(all('Interes'))-acumulado(nextElement(this, -1)); }
}
/************************** Regular Expressions **************************************/
// HTML TAG				</?\w+( (\s+\w+(\s*=\s*(?:".*?"|'.*?'|[^'">\s]+))?)+\s*|\s*)/?>
// Simple HTML TAG con TAG de cierre <([A-Z][A-Z0-9]*)\b[^>]*>.*?</\1>
// Email				\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b
// Fecha 				dd/mm/yyyy	(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](19|20)\d\d
// Fecha yyyy/mm/dd 	(19|20)\d\d([- /.])(0[1-9]|1[012])\2(0[1-9]|[12][0-9]|3[01])

//			

/*CLASSES!!*/
function $Identifier(oObject)
{
	this.object=oObject
}

$Identifier.prototype.name = function() 
{ 
return this.object.name 
}

$Identifier.prototype.getClosest = function()
{
return this.parentNode
}

function nextPage(oPageManager, steps)
{
oPageManager.pageIndex=parseInt(oPageManager.pageIndex)+steps
}

function jumpToPage(oPageManager, iPageIndex)
{
oPageManager.pageIndex=iPageIndex
/*oSrcElement=event.srcElement
oDataTable=$(oSrcElement).closest("[dataTable]").get(0)
alert(oDataTable.pageIndex+' '+oDataTable.pageSize)
*/
}

function newPanel(iPageIndex)
{
oSrcElement=event.srcElement
var oPanel=document.createElement("<div></div>"); 
$(oSrcElement).parent().get(0).insertAdjacentElement("beforeBegin", oPanel); 
oPanel.innerHTML="Pagina_"+iPageIndex; 
oPanel.id="Pagina_"+iPageIndex; 
oPanel.onclick=function () {refreshData(this);}
}


function isEncHTML(str) {
  if(str.search(/&amp;/g) != -1 || str.search(/&lt;/g) != -1 || str.search(/&gt;/g) != -1)
    return true;
  else
    return false;
};
 
function decHTMLifEnc(str){
    if(isEncHTML(str))
      return str.replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(/&gt;/g, '>');
    return str;
}




/*var sUpdateXML = ""
function createUpdateXML(oTable)
{
if (oTable==undefined) oTable=$(".dataTable")//.not(".dataTable .dataTable")
//oTable.find(".dataTable").css("background-color", "red")
oInputCollection=oTable.find(":input").filter(function(index){
	return $(this).closest(".dataTable").get(0)==oTable.get(0)
})
oInputCollection.each(function(index){
	sUpdateXML+=' '+this.name+' '
})
alert(sUpdateXML)
alert(oInputCollection.css("background-color", "red").length)
oInputCollection.css("background-color", "")
var oChildren=$(".dataTable", oTable)
if (oChildren.length>0) createUpdateXML(oChildren)
}*/


