<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:px="urn:panax">

<xsl:template mode="container.config" match="PersonaConDiscapacidad/px:fields/PoblacionNacimiento|PersonaConDiscapacidad/px:fields/PoblacionResidencia">
hideLabel:true
</xsl:template>
<xsl:template mode="field.items.defaultConfig" match="PersonaConDiscapacidad/px:fields/PoblacionNacimiento|PersonaConDiscapacidad/px:fields/PoblacionResidencia">
hideLabel:false
</xsl:template>

<xsl:template mode="field.config" match="PersonaConDiscapacidad/px:fields/OtroProporcionanteDatos">
hidden:true
</xsl:template>

<xsl:template match="PersonaConDiscapacidad/px:fields/ProporcionanteDatos/*|PersonaConDiscapacidad/px:fields/Escuela//Instituto
" mode="control.onchange">function(combo, records, eOptions) { 
	var oNextChild = Ext.ComponentQuery.query("#<xsl:apply-templates select="../following-sibling::*[1]" mode="field_id"/>")[0]
	if ((combo.value || {text:''}).text.toUpperCase()=='OTRO') {
		oNextChild.show(true); 
		oNextChild.setRequired(true)
	} else {
		oNextChild.hide(true); 
		oNextChild.setRequired(false)
	}
	return true;
	}
</xsl:template>

<xsl:template mode="control.onchange" match="PersonaConDiscapacidad/px:fields/PoblacionNacimiento//Pais[1]">function(combo, records, eOptions) { 
	if (!(combo.value)) return false;
	if (combo.value.id=='') {
		combo.select(combo.findRecordByDisplay('México'));
		return false;
	}
	if (combo.value.text=='Otro') {
		Ext.ComponentQuery.query('#<xsl:apply-templates select="ancestor::px:fields[1]/OtroPaisNacimiento" mode="field_id"/>')[0].show(true);
	} else {
		Ext.ComponentQuery.query('#<xsl:apply-templates select="ancestor::px:fields[1]/OtroPaisNacimiento" mode="field_id"/>')[0].hide(true);
	} 

	if (combo.value.text!='México') {
		Ext.ComponentQuery.query('#<xsl:apply-templates select=".." mode="field_id"/>')[0].hide(true);
		Ext.ComponentQuery.query('#<xsl:apply-templates select="../.." mode="field_id"/>')[0].hide(true);
		Ext.ComponentQuery.query('#<xsl:apply-templates select="../../.." mode="field_id"/>')[0].hide(true);
		Ext.ComponentQuery.query('#<xsl:apply-templates select="ancestor::px:fields[1]/EstadoNacimiento" mode="field_id"/>')[0].show(true);
		Ext.ComponentQuery.query('#<xsl:apply-templates select="ancestor::px:fields[1]/MunicipioNacimiento" mode="field_id"/>')[0].show(true);
		Ext.ComponentQuery.query('#<xsl:apply-templates select="ancestor::px:fields[1]/OtraPoblacionNacimiento" mode="field_id"/>')[0].show(true);
	} else {
		Ext.ComponentQuery.query('#<xsl:apply-templates select=".." mode="field_id"/>')[0].show(true);
		Ext.ComponentQuery.query('#<xsl:apply-templates select="../.." mode="field_id"/>')[0].show(true);
		Ext.ComponentQuery.query('#<xsl:apply-templates select="../../.." mode="field_id"/>')[0].show(true);
		Ext.ComponentQuery.query('#<xsl:apply-templates select="ancestor::px:fields[1]/EstadoNacimiento" mode="field_id"/>')[0].hide(true);
		Ext.ComponentQuery.query('#<xsl:apply-templates select="ancestor::px:fields[1]/MunicipioNacimiento" mode="field_id"/>')[0].hide(true);
		Ext.ComponentQuery.query('#<xsl:apply-templates select="ancestor::px:fields[1]/OtraPoblacionNacimiento" mode="field_id"/>')[0].hide(true);
	}
	var oPaisResidencia = Ext.ComponentQuery.query('#<xsl:apply-templates select="ancestor::px:fields[1]/PoblacionResidencia//Pais[1]" mode="field_id"/>')[0];
	
	oPaisResidencia.setValue(combo.value)
}
</xsl:template>

<xsl:template mode="field.config" match="
PersonaConDiscapacidad/px:fields/NoTieneTelefono |
PersonaConDiscapacidad/px:fields/NoTieneCelular |
PersonaConDiscapacidad/px:fields/NoTieneFacebook |
PersonaConDiscapacidad/px:fields/NoTieneCorreo |
PersonaConDiscapacidad/px:fields/NoTieneTwitter |
PersonaConDiscapacidad/px:fields/NoTieneAlergias">
boxLabel: '<xsl:apply-templates select="." mode="headerText"/>'
</xsl:template>

<xsl:template mode="onChange" match="px:fields/NoTieneTelefono">function(newValue, oldValue) { 
	var txtLada = Ext.ComponentQuery.query("#<xsl:apply-templates select="../LadaCasa" mode="field_id"/>")[0];
	txtLada.setDisabled(newValue);
	var txtTelefono = Ext.ComponentQuery.query("#<xsl:apply-templates select="../TelefonoCasa" mode="field_id"/>")[0];
	txtTelefono.setDisabled(newValue);
}
</xsl:template>
<xsl:template mode="onChange" match="px:fields/NoTieneCelular">function(newValue, oldValue) { 
	var txtBox = Ext.ComponentQuery.query("#<xsl:apply-templates select="../Celular" mode="field_id"/>")[0];
	txtBox.setDisabled(newValue);
}
</xsl:template>
<xsl:template mode="onChange" match="px:fields/NoTieneFacebook">function(newValue, oldValue) { 
	var txtBox = Ext.ComponentQuery.query("#<xsl:apply-templates select="../Facebook" mode="field_id"/>")[0];
	txtBox.setDisabled(newValue);
}
</xsl:template>
<xsl:template mode="onChange" match="px:fields/NoTieneTwitter">function(newValue, oldValue) { 
	var txtBox = Ext.ComponentQuery.query("#<xsl:apply-templates select="../Twitter" mode="field_id"/>")[0];
	txtBox.setDisabled(newValue);
}
</xsl:template>
<xsl:template mode="onChange" match="px:fields/NoTieneCorreo">function(newValue, oldValue) { 
	var txtBox = Ext.ComponentQuery.query("#<xsl:apply-templates select="../CorreoElectronico" mode="field_id"/>")[0];
	txtBox.setDisabled(newValue);
	var txtBox = Ext.ComponentQuery.query("#<xsl:apply-templates select="../Dominio" mode="field_id"/>")[0];
	txtBox.setDisabled(newValue);
}
</xsl:template>

<xsl:template mode="dataField" match="
PersonaConDiscapacidad/px:fields/LadaTrabajoPadre|PersonaConDiscapacidad/px:fields/LadaTrabajoMadre">{
xtype: "fieldcontainer", layout: "hbox", defaults:{hideLabel:true, flex:0, anchor:'none'}, fieldLabel:'<xsl:apply-templates select="." mode="headerText"/>', items:[<xsl:call-template name="dataField"/>,<xsl:apply-templates select="following-sibling::*[1]" mode="dataField"/>, {xtype:"displayfield", flex:1}]}</xsl:template>

<xsl:template mode="quickTip" match="px:fieldSet[@name='PersonasAutorizadas']">Llenar los campos de las personas que estarán autorizadas. SI PUEDE ser más de una persona.</xsl:template>

<xsl:template mode="dockedItems" match="PersonaConDiscapacidad/px:fields/Ingresos/*">
</xsl:template>

<xsl:template mode="control.onchange" match="PersonaConDiscapacidad/px:fields/NumeroSueldos">function(control, newValue, oldValue, eOptions) { 
var grid = Ext.ComponentQuery.query("#Ingresos");
if (Ext.isArray(grid)) grid=grid[0];
<xsl:text disable-output-escaping="yes"><![CDATA[ 
	for (var i=grid.store.data.length; i<(newValue||0); ++i) {	
		grid.onAddClick()
		}
	for (var i=grid.store.data.length; i>(newValue||0); --i) {
		grid.store.removeAt(i-1);
	}]]></xsl:text>
	
}
</xsl:template>

<xsl:template mode="control.onCheckEvent" match="PersonaConDiscapacidad/px:fields/Enfermedades" priority="-1">function(control, rowIndex, checked, eOpts){
	var grid = control.up('grid');
	var selectedText = grid.getStore().data.get(rowIndex).get("Enfermedades.Enfermedad").text
}</xsl:template>

<xsl:template mode="control.onchange" match="PersonaConDiscapacidad/px:fields/Sexo" priority="-1">function(control, newValue, oldValue, eOpts) {
	var groupCuidadoEspecialPeriodo = Ext.ComponentQuery.query("#<xsl:apply-templates mode="container_id" select="key('table',@fieldId)/px:layout//px:fieldContainer[@name='CuidadoEspecialPeriodo']"/>")[0]
	if (String(newValue[control.name]).toLowerCase()=='femenino') {
		groupCuidadoEspecialPeriodo.show(true)
	} else {
		groupCuidadoEspecialPeriodo.hide(true)
	}
}</xsl:template>

<xsl:template mode="itemWidth" match="PersonaConDiscapacidad/px:fields/Medicamentos/*">900</xsl:template>

<xsl:template mode="itemWidth" match="PersonaConDiscapacidad/px:fields/Alergias/*">750</xsl:template>

<xsl:template mode="itemWidth" match="PersonaConDiscapacidad/px:fields/ActividadesPeriodicas">1000</xsl:template>

<xsl:template mode="itemHeight" match="PersonaConDiscapacidad/px:fields/HorariosLibresActividades">180</xsl:template>
<xsl:template mode="itemWidth" match="PersonaConDiscapacidad/px:fields/HorariosLibresActividades">300</xsl:template>

<xsl:template mode="itemHeight" match="PersonaConDiscapacidad/px:fields/Discapacidades">300</xsl:template>

<xsl:template mode="control.onchange" match="PersonaConDiscapacidad/px:fields/ContactoDeEmergencia/*">function(control, newValue, oldValue, eOptions) { 
	var aFields = []
	aFields.push(Ext.ComponentQuery.query("#<xsl:apply-templates mode="field_id" select="../../NombreContactoEmergencia"/>")[0])
	aFields.push(Ext.ComponentQuery.query("#<xsl:apply-templates mode="field_id" select="../../TelefonoCasaContactoEmergencia"/>")[0])
	aFields.push(Ext.ComponentQuery.query("#<xsl:apply-templates mode="field_id" select="../../CelularContactoEmergencia"/>")[0])
	aFields.push(Ext.ComponentQuery.query("#<xsl:apply-templates mode="field_id" select="../../OtroTelefonoContacto"/>")[0])
	var oValue=control.getValue();

	Ext.Array.forEach(aFields, function(item, i) {
		item.setRequired(oValue.text=="Otro")
	});

	var oContainer = Ext.ComponentQuery.query("#<xsl:apply-templates select="../following-sibling::*[1]" mode="container_id"/>")[0]
	if (oValue.text=="Otro") {
		oContainer.show(true); 
	} else {
		oContainer.hide(true); 
	}
}
</xsl:template>

<xsl:template mode="control.onchange" match="PersonaConDiscapacidad/px:fields/NumeroDeHermanos">function(control, newValue, oldValue, eOptions) { 
var oMantieneBuenaRelacionConHermanos = Ext.ComponentQuery.query("#<xsl:apply-templates mode="container_id" select="key('table',@fieldId)/px:layout//px:field[@fieldName='MantieneBuenaRelacionConHermanos']"/>")[0]

<xsl:text disable-output-escaping="yes"><![CDATA[ 
if ((newValue||0)>0) {
		oMantieneBuenaRelacionConHermanos.show(true)
		}
	else {
		oMantieneBuenaRelacionConHermanos.hide(true)
		//oMantieneBuenaRelacionConHermanos.setValue(false)
	}
]]></xsl:text>
}
</xsl:template>

<xsl:template mode="control.onchange" match="PersonaConDiscapacidad/px:fields/AnioNacimiento">function(combo, records, eOptions) { /*Revisar día y mes también*/
	var oPuedeSalirConAmigosDeNoche = Ext.ComponentQuery.query("#<xsl:apply-templates mode="container_id" select="../PuedeSalirConAmigosDeNoche"/>")[0]
<xsl:text disable-output-escaping="yes"><![CDATA[ 
	if (new Date().getFullYear()-parseInt((combo.value || new Date().getFullYear()).text)>=18) {
		oPuedeSalirConAmigosDeNoche.show(true)
		}
	else {
		oPuedeSalirConAmigosDeNoche.hide(true)
	}
]]></xsl:text>
}
</xsl:template>

</xsl:stylesheet>