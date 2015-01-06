<!--#include file="../Scripts/IncludesAll.asp"-->
<html>
<header>
<!--#include file="../Scripts/librerias_js.asp"-->
<!--#include file="../Scripts/estilos.asp"-->
<script language="JavaScript">
function createXML()
{
var dataRow=$(event.srcElement).closest('tr');
$("*[required='true']", dataRow).removeClass('requiredEmpty')
$("*[required='true']", dataRow).each(function(){
	if (esVacio(getVal(this))) $(this).addClass('requiredEmpty')
	})
//document.all("284516").email.value='probando'
//document.all("284516").profesion.value='Ing'
}
</script>
</header>
<body>
<h2>Grid View:</h2>
<table border="1" dataTable="clientes">
<tbody >
<tr id="284516" ondblclick="createXML()">
<td>
Name: <input dataField="name" name="name" type="text" size="30" value="Uriel Mauricio Gómez Robles" required="true" /><br />
Email: <input dataField="email" name="email" type="text" size="30" required="true" /><br />
Date of birth: <input dataField="bday" name="bday" type="text" size="10" /><br />
Sex: <br>
<span dataField="sex" required="true">
<input type="radio" name="284516_sex" id="284516_sex_M" value="M" Title="Masculino" /><label FOR="284516_sex_M">Masculino</label>
<input type="radio" name="284516_sex" id="284516_sex_F" value="F" ContentEditable="FALSE" Title="Femenino" /><label FOR="284516_sex_F">Femenino</label>
<input type="radio" name="284516_sex" id="284516_sex_I" value="I" ContentEditable="FALSE" Title="Indefinido" /><label FOR="284516_sex_I">Indistinto</label>
</span><br>
Preferencias:<br>
<span dataField="preferencias" required="true">
<input type="checkbox" name="284516_preferencias" id="284516_preferencias_M" value="M" Title="Masculino" /><label FOR="284516_preferencias_M">Masculino</label>
<input type="checkbox" name="284516_preferencias" id="284516_preferencias_F" value="F" ContentEditable="FALSE" Title="Femenino" /><label FOR="284516_preferencias_F">Femenino</label>
<input type="checkbox" name="284516_preferencias" id="284516_preferencias_I" value="I" ContentEditable="FALSE" Title="Indefinido" /><label FOR="284516_preferencias_I">Indistinto</label>
</span>
<br />
Profesion: 
<select dataField="profesion" name="profesion" value="Ing" required="true">
	<option value="Lic" selected>Licenciado</option>
	<option value="Ing">Ingeniero</option>
	<option value="CP">Contador</option>
</select><br>
Calificacion:
<span dataField="calificacion" required="true" class="rangeSelector" value="2">
<img width="22" height="20" src="../../../../Images/FilledStar.png" class="imageButton" alt="1" value="1">
<img width="22" height="20" src="../../../../Images/FilledStar.png" class="imageButton" alt="2" value="2">
<img width="22" height="20" src="../../../../Images/FilledStar.png" class="imageButton" alt="3" value="3">
<img width="22" height="20" src="../../../../Images/FilledStar.png" class="imageButton" alt="4" value="4">
<img width="22" height="20" src="../../../../Images/FilledStar.png" class="imageButton" alt="5" value="5">
<label>3</label>
</span>
</td>
</tr>
<tr id="284517" ondblclick="createXML()">
<td>
Name: <input dataField="name" name="name" type="text" size="30" value="Lilia Rosalinda Guerrero Valdés" required="true" /><br />
Email: <input dataField="email" name="email" type="text" size="30" required="true" /><br />
Date of birth: <input dataField="bday" name="bday" type="text" size="10" /><br />
Sex: <input type="radio" dataField="sex" name="sex_284517" value="M" Title="Masculino" /><input type="radio" dataField="sex" name="sex_284517" value="F" ContentEditable="FALSE" Title="Femenino" /><br />
<br />
</td>
</tr>
</tbody>
</table>
<button onClick="embedded.style.display='inline'"></button>
<div id="embedded" class="URLLoader" ContentURL="'Form.asp'" style="display:'none'" >Dynamic Content</div>