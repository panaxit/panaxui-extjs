function Checkdate_Checkbox_click(obj_txt)
{
obj_chk=event.srcElement
obj_txt==undefined?obj_txt=document.all[obj_chk.sourceIndex+1]:null;
sValue=obj_chk.value

if (!(obj_chk.checked))
	{
	obj_txt.value='';
	}
else
	{
	var sFunction=null
	var sRegEx=/(.+?)\(.*?\)/
	if (sValue.match(sRegEx) && eval(sValue.replace(sRegEx, '$1')))
		{
		obj_txt.value=eval(sValue);
		}
	else
		{
		obj_txt.value=sValue;
		}
	}
//obj_txt.fireEvent('onblur');
}

function Expander_onkeydown()
{
oSource=event.srcElement
key_pressed=event.keyCode; 
if (key_pressed==32) 
	{
	oSource.fireEvent('onclick'); 
	event.keyCode=0; 
	event.returnValue=false; 
	}
}

function Expander_onclick()
{
oSource=event.srcElement
var oExpander = document.all[oSource.sourceIndex+1]; 
if (oExpander.style.display!='inline') 
	{ 
	oExpander.style.display='inline'; 
	oSource.src=oSource.src.replace(/([/\\])expand\.jpg/i, '$1collapse.jpg');
	} 
else 
	{
	oExpander.style.display='none';  
	oSource.src=oSource.src.replace(/([/\\])collapse\.jpg/i, '$1expand.jpg');
	}
}

function Expander_oncontextmenu()
{
oSource=event.srcElement
var oExpander = document.all[oSource.sourceIndex+1]; 
oExpander.isUpdated=false; 
oSource.fireEvent('onclick'); 
}

/*dock -->*/
// ================================================================
//                   ------ dock menu -------
// script by Gerard Ferrandez - Ge-1-doot - February 2006
// http://www.dhteumeuleu.com
// ================================================================
$(document).ready(function(){
	$('.dock').each(function () {
		/* ---- private vars ---- */
		var xm = xmb = ov = 0;
		var M = true;
		var icons = this.getElementsByTagName('img');
		var N = icons.length;
		var s = sMin = $(this).attr("minSize");
		var sMax = $(this).attr("maxSize");
		var ovk = 0;
		var addEvent = function (o, e, f) {
			if (window.addEventListener) o.addEventListener(e, f, false);
			else if (window.attachEvent) r = o.attachEvent('on' + e, f);
		}
		var pxLeft = function(o) {
			for(var x=-document.documentElement.scrollLeft; o != null; o = o.offsetParent) x+=o.offsetLeft;
			return x;
		}
		for(var i=0;i<N;i++) {
			var o = icons[i];
			o.style.width = sMin+"px";
			o.style.height = sMin+"px";
			$(o).addClass("dockicon");
		}
		var run = function() {
			for(var i=0;i<N;i++) {
				var o = icons[i];
				var W = parseInt(o.style.width);
				if(ov && $(ov).hasClass("dockicon")) {
					if(ov!=ovk){
						ovk=ov;
						//document.getElementById("legend").innerHTML = ov.lang;
					}
					if(M) W = Math.max((s*Math.cos(((pxLeft(o)+W/2)-xm)/sMax)),sMin);
					s = Math.min(sMax,s+.5);
				} else {
					s = Math.max(s-.5,sMin);
					W = Math.max(W-N,sMin);
				}
				o.style.width = W+"px";
				o.style.height = W+"px";
			}
			if(s >= sMax) M = false;
		}
		addEvent(this, 'mousemove', function (e) {
			if(window.event) e=window.event;
			xm = (e.x || e.clientX);
			if(xm!=xmb){
				M = true;
				xmb = xm;
			}
			ov = (e.target)?e.target:((e.srcElement)?e.srcElement:null);
		});
		setInterval(run, 16);
	});
});
/*<-- dock */


$(document).ready(function(){
	$('.commandButton').live("click", function(){
		/*var sPrimaryKey = $(this).closest('[primaryKey]').attr("primaryKey")
		var sIdentityValue = $(this).closest('[identityValue]').attr("identityValue")*/
		if ($(this).attr("command")=='delete')
			{
			var oParentTR=$(this).parents("TR")[0]
			var sIdValue=$(oParentTR).attr("db_primary_value")
			if ($(oParentTR).is('.delete'))
				{
				this.src=this.src.replace(/([/\\])btn_Cancel\.gif/i, '$1btn_Delete.png')
				$(oParentTR).removeClass('delete')
				}
			else
				{
				if (sIdValue!='NULL')
					{
					this.src=this.src.replace(/([/\\])btn_Delete\.png/i, '$1btn_Cancel.gif')
					$(oParentTR).addClass('delete')
				}
				else
					{
					var bDataDeleted=deleteData($(this).attr("catalogName"), $(this).attr("primaryKey"), sIdValue, oParentTR)
					if (bDataDeleted && oParentTR)
						{
						////var oTable=getParent('TABLE', oParentTR);
						////!(oTable.all(oParentTR.id).length && oTable.all(oParentTR.id).length>1)?goToFirstVisibleObject(addRow(oParentTR)):null; 
						//lr=removeRow(oParentTR);
						////fix_rowId( lr );
						////goToFirstVisibleObject(lr)
						if (sIdValue!='NULL')
							{
							oTableLoader=$(this).closest('.tableLoader, .tabPanel').get(0); if (oTableLoader) { oTableLoader.isUpdated=false; } else { location.href=location.href;}
							}
						}
					}
				}
			}
		else
			{
			var jRows=$(this).closest('.dataTable').find("[db_primary_value]")
			if ($(this).attr("command")=='insert' && jRows.length>0 && $(this).parents('.dataTable').length>1 && $(":input:not(:hidden)", jRows.get(0)).length>0) 
				{ 
				nr=addRow(jRows.get(0), 0);
				fix_rowId( nr ); 
				goToFirstVisibleObject(nr)
				} 
			else 
				{
				var oForeignKey=$(this).closest('[parent_object]')
				if (oForeignKey.length>0)
					{
					var sForeignKey=oForeignKey.attr("db_foreign_key")
					var sForeignKeyValue=$("#"+oForeignKey.attr('parent_object')).attr("db_primary_value")
					this.parameters=(this.parameters||'')
					if (!(this.parameters) || this.parameters && this.parameters.indexOf("@#"+sForeignKey+'=\''+sForeignKeyValue+'\'')==-1)
						this.parameters+=(isEmpty(this.parameters)?"":",")+"@#"+sForeignKey+'=\''+sForeignKeyValue+'\'';
					}

				var response=openModalPage('../Templates/request.asp?CatalogName='+$(this).attr("catalogName")+'&Mode='+$(this).attr("command")+($(this).attr("command")!='insert'?'&filters='+$(this).attr("filter")/*sPrimaryKey+'='+sIdentityValue*/:'')+'&parameters='+encodeURIComponent($(this).attr("parameters")||''));
				}
			try { if (response && response.script) eval(response.script) } catch(e) {alert(e.description); showModal(response)}
			}
		//try { $('.formula').each(function () { this.calculaFormula() }) } catch(e) {}
		
		/*oIdentifier=getParent('TR', this).all('identifier'); 
		oIdentifier=oIdentifier.length?oIdentifier(0):oIdentifier; 
		openLinkrootFolder+'DynamicData/Update.asp?requestTable=Prospecto&'+getDBColumnName(oIdentifier)+'='+getDBColumnValue(oIdentifier), false, false)*/
	});
});

$(document).ready(function(){
	$('.autoRefresh').each(function(){var oSource=this; doRefresh(oSource); setInterval(function(){doRefresh(oSource)}, ($(this).attr('refreshInterval') || 5)*1000);})
})

function doRefresh(oSource)
{
	eval($(oSource).attr('action').replace(/this/ig, 'oSource'))
}