<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:px="urn:panax">

<xsl:template match="px:fields/Telefono|px:fields/TelefonoCasa|px:fields/TelefonoOficina|px:fields/TelefonoPadre|px:fields/TelefonoMadre|px:fields/TelefonoCasaContactoEmergencia|px:fields/OtroTelefonoContactoEmergencia|px:fields/Celular|px:fields/CelularPadre|px:fields/CelularMadre|px:fields/CP|px:fields/CelularContactoEmergencia" mode="field.config">
hideTrigger:true, emptyText:''
</xsl:template>

<xsl:template match="px:fields/*[@fieldContainer='Teléfono de Casa' or @fieldContainer='Teléfono de Oficina']" mode="field.config">
emptyText:"<xsl:apply-templates select="." mode="headerText"/>"
</xsl:template>

<xsl:template match="px:fieldContainer[@name='Email' or @name='Facebook' or @name='Twitter']" mode="container.items.defaultConfig">
hideLabel: true
</xsl:template>

<xsl:template mode="dataField" match="
px:fields/Dominio |
px:fields/DominioOtroCorreo |
px:fields/DominioEmailPadre |
px:fields/DominioEmailMadre |
px:fields/Twitter"><xsl:if test="position()&gt;1">,</xsl:if>
{xtype:"displayfield", value:"@"},<xsl:call-template name="dataField"/>
</xsl:template>

<xsl:template mode="control.config.insertEnabled" match="
*[not(@mode!='filters' or @mode!='fieldselector')]/px:fields/Dominio/*|px:fields/Religion/*">true</xsl:template>

<xsl:template match="px:fields/*/@fieldContainer[.='TieneOtroCorreo']" mode="container.items.defaultConfig">
hideLabel: true, layout: 'hbox'
</xsl:template>

<xsl:template match="
px:fields/Facebook" mode="dataField"><xsl:if test="position()&gt;1">,</xsl:if>
{xtype:"displayfield", value:"www.facebook.com/"},<xsl:call-template name="dataField"/>
</xsl:template>
<!-- 
<xsl:template mode="dataField" match="px:fields/NoTengoFacebook">
{xtype:'facebook', user:'_unidos_', lang:'es'},<xsl:call-template name="dataField"/>
</xsl:template> -->

<xsl:template match="px:fields/Twitter" mode="container.config">layout: 'vbox', hideLabel:false
</xsl:template>

<xsl:template match="px:fields/Twitter" mode="dataField"><xsl:if test="position()&gt;1">,</xsl:if>
{
xtype: "fieldcontainer", layout: "hbox", defaults:{hideLabel:true}, items:[
{xtype:"displayfield", value:"@"},<xsl:call-template name="dataField"/>,<xsl:apply-templates mode="dataField" select="../NoTengoTwitter"/>]
},{xtype:'twitter', user:'_unidos_', lang:'es'}
</xsl:template>

<xsl:template match="px:fields/CorreoElectronico|px:fields/EmailPadre|px:fields/EmailMadre" mode="field.config">width: 200</xsl:template>

<!-- <xsl:template match="px:fields/FechaNacimiento" mode="field.config">xtype:'iphonedatepicker',settings: {dayField: {name:'dayField'},monthField: {name:'monthField'},yearField: {name:'yearField'}}</xsl:template> -->

<xsl:template match="px:fields/MesNacimiento" mode="field.config">
maxLength: undefined
</xsl:template>

<xsl:template match="px:fields/LadaCasa|px:fields/LadaOficina" mode="field.config">
width: 40
</xsl:template>

<xsl:template match="px:fields/DiaNacimiento" mode="field.config">
minValue: 1,
maxValue: 31
</xsl:template>

<xsl:template mode="field.config" match="px:fields/AnioNacimiento">
minValue: 1900,
maxValue: new Date().getFullYear()
</xsl:template>			

<xsl:template mode="field.config" match="px:fields/AnioIntegracion">
endYear: 1987
</xsl:template>			
		<!-- 	
<xsl:template match="px:fields/MedicamentoPeriodico" mode="fieldContainer">
<xsl:call-template name="fieldContainer.checkBoxToggle"/>
</xsl:template> -->

<xsl:template mode="field.config" match="px:fields/AnioNacimiento">
endYear: 1920
, startYear: new Date().getFullYear()
, forceSelection: false
, width: 80
</xsl:template>	

<xsl:template match="px:fields/*/@fieldContainer[.='OtroContacto']" mode="container.config">
layout: 'vbox', hideEmptyLabel: false, fieldLabel: '', id: 'OtroContacto', hidden: true
</xsl:template>
<!-- 
<xsl:template match="px:fields/*/@fieldContainer[.='OtroContacto']" mode="container.items.defaultConfig">
hideLabel: false, labelAlign: 'left'
</xsl:template> -->

<xsl:template match="px:fields/*/@fieldContainer[.='Teléfono de Casa' or .='Teléfono de Oficina' or .='Celular']" mode="container.items.defaultConfig">
hideLabel: true
</xsl:template>


<xsl:template match="px:fieldContainer[@name='FechaNacimiento']" mode="headerText">Fecha de Nacimiento</xsl:template>

<xsl:template match="px:fieldContainer[@name='MedicamentoPeriodico']" mode="headerText">¿Tomas algún medicamento periódicamente?</xsl:template>

<xsl:template match="px:fields/MedicamentoPeriodico" mode="headerText">¿Cuál?</xsl:template>

<xsl:template match="px:fields/*/@fieldContainer[.='ServicioSocial']" mode="headerText"><xsl:apply-templates select=".." mode="headerText"/></xsl:template>

<xsl:template match="px:fields/Sexo" mode="field.config">columns: 3, width: 400</xsl:template>

<xsl:template match="px:fields/*[name(.)='ServicioSocial']" mode="field.config">insertEnabled:true</xsl:template>

<xsl:template match="px:fields/*[name(.)='EstadoCivilPadres' or name(.)='Religion' or name(.)='ContactoDeEmergencia' or name(.)='TipoSangre' or name(.)='MedioCaptacion']" mode="field.config">insertEnabled:false</xsl:template>

<xsl:template match="px:fields/*[name(.)='AnioIntegracion']/*" mode="control.config">sortDirection: "DESC"</xsl:template>

<xsl:template match="px:fields/Calle" mode="field.config">height: 27</xsl:template>

<xsl:template match="px:fields/Sexo/px:data/*[@value='-Vacio-']" mode="checkboxGroup.option">/*opción "<xsl:value-of select="@value"/>" fue quitada*/</xsl:template>

<xsl:template match="
px:fields/ServicioSocial/*|px:fields/MedioCaptacion/*|px:fields/Religion/*
" mode="control.onchange">function(combo, records, eOptions) { 
	var oNextChild = Ext.ComponentQuery.query("#<xsl:apply-templates select="../following-sibling::*[1]" mode="field_id"/>")[0]
	if ((combo.value || {text:''}).text.toUpperCase()=='OTRO')
		oNextChild.show(true); 
	else
		oNextChild.hide(true); 
	return true;
	}
</xsl:template>

<xsl:template match="
px:fields/OtroServicioSocial|px:fields/OtroMedioCaptacion|px:fields/OtraReligion" mode="field.config">
hidden: true
</xsl:template>

<xsl:template match="px:fields/ContactoDeEmergencia/*" mode="control.onchange">function(combo, records, eOptions) { 
<xsl:text disable-output-escaping="yes"><![CDATA[ 	if (combo.value && combo.value.id=='3') //Otro ]]></xsl:text>/*<xsl:value-of select="name(../following-sibling::*[1])"/>*/
		Ext.ComponentQuery.query("#<xsl:apply-templates select="../following-sibling::*[1]" mode="container_id"/>")[0].show(true); 
	else
		Ext.ComponentQuery.query("#<xsl:apply-templates select="../following-sibling::*[1]" mode="container_id"/>")[0].hide(true); 
	return true;
	}
</xsl:template>

<xsl:template mode="field.config" match="
px:fields/NoTengoTelefono |
px:fields/NoTengoCelular |
px:fields/NoTengoFacebook |
px:fields/NoTengoTwitter |
px:fields/NoTengoAlergias">
boxLabel: '<xsl:apply-templates select="." mode="headerText"/>'
</xsl:template>

<xsl:template mode="onChange" match="px:fields/NoTengoTelefono">function(newValue, oldValue) { 
	var txtLada = Ext.ComponentQuery.query("#<xsl:apply-templates select="../LadaCasa" mode="field_id"/>")[0];
	txtLada.setDisabled(newValue);
	var txtTelefono = Ext.ComponentQuery.query("#<xsl:apply-templates select="../TelefonoCasa" mode="field_id"/>")[0];
	txtTelefono.setDisabled(newValue);
}
</xsl:template>
<xsl:template mode="onChange" match="px:fields/NoTengoCelular">function(newValue, oldValue) { 
	var txtBox = Ext.ComponentQuery.query("#<xsl:apply-templates select="../Celular" mode="field_id"/>")[0];
	txtBox.setDisabled(newValue);
}
</xsl:template>
<xsl:template mode="onChange" match="px:fields/NoTengoFacebook">function(newValue, oldValue) { 
	var txtBox = Ext.ComponentQuery.query("#<xsl:apply-templates select="../Facebook" mode="field_id"/>")[0];
	txtBox.setDisabled(newValue);
}
</xsl:template>
<xsl:template mode="onChange" match="px:fields/NoTengoTwitter">function(newValue, oldValue) { 
	var txtBox = Ext.ComponentQuery.query("#<xsl:apply-templates select="../Twitter" mode="field_id"/>")[0];
	txtBox.setDisabled(newValue);
}
</xsl:template>
<xsl:template mode="onChange" match="px:fields/NoTengoAlergias">function(newValue, oldValue) { 
	var txtBox = Ext.ComponentQuery.query("#<xsl:apply-templates select="../Alergias" mode="field_id"/>")[0];
	txtBox.setDisabled(newValue);
}
</xsl:template>

<xsl:template mode="dockedItems" match="px:fields/Hermanos/*">
</xsl:template>

<xsl:template mode="control.onchange" match="px:fields/NumeroDeHermanos">function(control, newValue, oldValue, eOptions) { 
var grid = Ext.ComponentQuery.query("#Hermanos");
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


<xsl:template mode="container.config" match="px:fields/PoblacionResidencia">hideLabel:true</xsl:template>
<xsl:template match="px:fields/OtroPaisResidencia" mode="field.config">hideEmptyLabel: false</xsl:template>
<xsl:template mode="field.items.defaultConfig" match="px:fields/PoblacionResidencia">hideLabel:false</xsl:template>

<xsl:template mode="control.onchange" match="px:fields/PoblacionResidencia//Pais[1]">function(combo, records, eOptions) { 
if (!(combo.value)) return false;
if (combo.value.id=='') {
	combo.select(combo.findRecordByDisplay('MEXICO'));
	return false;
}
if (combo.value.text=='Otro') {
	Ext.ComponentQuery.query('#<xsl:apply-templates select="ancestor::px:fields[1]/OtroPaisResidencia" mode="field_id"/>')[0].show(true);
	} else {
	Ext.ComponentQuery.query('#<xsl:apply-templates select="ancestor::px:fields[1]/OtroPaisResidencia" mode="field_id"/>')[0].hide(true);
	} 

if (combo.value.text!='MEXICO') 
	{
	Ext.ComponentQuery.query('#<xsl:apply-templates select=".." mode="field_id"/>')[0].hide(true);
	Ext.ComponentQuery.query('#<xsl:apply-templates select="../.." mode="field_id"/>')[0].hide(true);
	Ext.ComponentQuery.query('#<xsl:apply-templates select="../../.." mode="field_id"/>')[0].hide(true);
	Ext.ComponentQuery.query('#<xsl:apply-templates select="ancestor::px:fields[1]/EstadoResidencia" mode="field_id"/>')[0].show(true);
	Ext.ComponentQuery.query('#<xsl:apply-templates select="ancestor::px:fields[1]/MunicipioResidencia" mode="field_id"/>')[0].show(true);
	Ext.ComponentQuery.query('#<xsl:apply-templates select="ancestor::px:fields[1]/OtraPoblacionResidencia" mode="field_id"/>')[0].show(true);
	}
else
	{
	Ext.ComponentQuery.query('#<xsl:apply-templates select=".." mode="field_id"/>')[0].show(true);
	Ext.ComponentQuery.query('#<xsl:apply-templates select="../.." mode="field_id"/>')[0].show(true);
	Ext.ComponentQuery.query('#<xsl:apply-templates select="../../.." mode="field_id"/>')[0].show(true);
	Ext.ComponentQuery.query('#<xsl:apply-templates select="ancestor::px:fields[1]/EstadoResidencia" mode="field_id"/>')[0].hide(true);
	Ext.ComponentQuery.query('#<xsl:apply-templates select="ancestor::px:fields[1]/MunicipioResidencia" mode="field_id"/>')[0].hide(true);
	Ext.ComponentQuery.query('#<xsl:apply-templates select="ancestor::px:fields[1]/OtraPoblacionResidencia" mode="field_id"/>')[0].hide(true);
	}
}
</xsl:template>


<xsl:template mode="control.onchange" match="PersonaConDiscapacidad/px:fields/EstatusHabitacion/*">function(combo, records, eOptions) { 
if (!(combo.value)) return false;
if (combo.value.text.indexOf('Casa hogar')!=-1) {
	Ext.ComponentQuery.query('#<xsl:apply-templates select="ancestor::px:fields[1]/TipoVivienda" mode="container_id"/>')[0].hide(true);
	<!-- Ext.ComponentQuery.query('#<xsl:apply-templates select="ancestor::px:fields[1]/..//px:layout//px:fieldSet[@name='CuantosTiene']" mode="container_id"/>')[0].hide(true); -->
	Ext.ComponentQuery.query('#<xsl:apply-templates select="ancestor::px:fields[1]/ServiciosDomicilio" mode="container_id"/>')[0].hide(true);
	}
else
	{
	Ext.ComponentQuery.query('#<xsl:apply-templates select="ancestor::px:fields[1]/TipoVivienda" mode="container_id"/>')[0].show(true);
	<!-- Ext.ComponentQuery.query('#<xsl:apply-templates select="ancestor::px:fields[1]/..//px:layout//px:fieldSet[@name='CuantosTiene']" mode="container_id"/>')[0].show(true); -->
	Ext.ComponentQuery.query('#<xsl:apply-templates select="ancestor::px:fields[1]/ServiciosDomicilio" mode="container_id"/>')[0].show(true);
	}
}
</xsl:template>

<xsl:template mode="field.config" match="
HorariosDisponibilidad/px:fields/De|HorariosDisponibilidad/px:fields/A">
minValue: 08
, maxValue: 23
, increment: 60
</xsl:template>


</xsl:stylesheet>