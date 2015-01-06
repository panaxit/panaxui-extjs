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
if (oExpander.style.display!='inline') { 
	oExpander.style.display='inline'; oSource.src=oSource.src.replace(/([/\\])expand\.jpg/i, '$1collapse.jpg'); oSource.collapsed=false;
	} else {
	oExpander.style.display='none';  oSource.src=oSource.src.replace(/([/\\])collapse\.jpg/i, '$1expand.jpg'); oSource.collapsed=true;
	}
}

function Expander_oncontextmenu()
{
oSource=event.srcElement
var oExpander = document.all[oSource.sourceIndex+1]; 
oExpander.isUpdated=false; 
oSource.fireEvent('onclick'); 
return false;
}