<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">

<xsl:import href="../attributeSets.xsl" />
<xsl:import href="../html.xsl" />
<xsl:include href="../../custom/templates/layout/buttons.xsl" /> 

<xsl:template match="/">
	<xsl:apply-templates select="*" />
</xsl:template>

<xsl:template match="buttons" priority="-1">
<span class="systemButtons">
<span>
<xsl:element name="img" use-attribute-sets="buttons.button">
	<xsl:attribute name="id">btnRefresh</xsl:attribute>
	<xsl:attribute name="src">../../../../Images/Buttons/btn_Refresh.png</xsl:attribute>
	<xsl:attribute name="alt">Actualizar Area de Trabajo</xsl:attribute>
	<xsl:attribute name="action">window.parent.WorkArea.refreshPage();</xsl:attribute>
</xsl:element>
</span>
<span>
<xsl:element name="img" use-attribute-sets="buttons.button">
	<xsl:attribute name="id">btnExcel</xsl:attribute>
	<xsl:attribute name="src">../../../../Images/Buttons/btn_Excel.png</xsl:attribute>
	<xsl:attribute name="alt">Copiar al portapapeles</xsl:attribute>
	<xsl:attribute name="action">toClipboard(top.frames('WorkArea'), top.frames('BackgroundFrame'))</xsl:attribute>
</xsl:element>
</span>
<span>
<xsl:element name="img" use-attribute-sets="buttons.button">
	<xsl:attribute name="id">btnSave</xsl:attribute>
	<xsl:attribute name="src">../../../../Images/Buttons/btn_Save.png</xsl:attribute>
	<xsl:attribute name="alt">Guardar cambios</xsl:attribute>
	<xsl:attribute name="action">try { window.parent.WorkArea.SaveCommand(); } catch(e) { alert('No se pueden guardar datos') } </xsl:attribute>
</xsl:element>
</span>
<span>
<xsl:element name="img" use-attribute-sets="buttons.button">
	<xsl:attribute name="id">btnBack</xsl:attribute>
	<xsl:attribute name="src">../../../../Images/Buttons/btn_LArrow.png</xsl:attribute>
	<xsl:attribute name="alt">Regresar a la página anterior</xsl:attribute>
	<xsl:attribute name="action">window.parent.WorkArea.goBack();</xsl:attribute>
</xsl:element>
</span>
<span>
<xsl:element name="img" use-attribute-sets="buttons.button">
	<xsl:attribute name="id">btnPrint</xsl:attribute>
	<xsl:attribute name="src">../../../../Images/Buttons/btn_Print.png</xsl:attribute>
	<xsl:attribute name="alt">Imprimir</xsl:attribute>
	<xsl:attribute name="action">PrintCommand(top.frames('WorkArea'))</xsl:attribute>
</xsl:element>
</span>
<span>
<xsl:apply-templates select="." mode="empty" />
</span>
</span>
</xsl:template>

<xsl:template match="buttons" priority="-1" mode="empty">
<xsl:element name="img" use-attribute-sets="buttons.button">
	<xsl:attribute name="src">../../../../Images/Buttons/btn_Empty.png</xsl:attribute>
	<xsl:attribute name="alt"></xsl:attribute>
</xsl:element>
</xsl:template>

</xsl:stylesheet>
