<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="dataRow" mode="gridView.table.tbody.row.attributes">
	<xsl:attribute name="ondblclick">$(".commandButton[command='edit']", this).click()</xsl:attribute><!-- editPurchaseOrderByRequisition(<xsl:value-of select="@identity"/>, <xsl:value-of select="ancestor::*[@dataType='table']/@idUser"/>) -->
	<xsl:attribute name="title">Double click to view</xsl:attribute>
</xsl:template>

<xsl:attribute-set name="login.logo">
	<xsl:attribute name="src">../../../../Images/Logos/logo_unidos.png</xsl:attribute> 
	<xsl:attribute name="height">80</xsl:attribute> 
</xsl:attribute-set>

<xsl:attribute-set name="commandButtons.insert">
	<xsl:attribute name="src">../../../../Images/Buttons/btn_Insert.gif</xsl:attribute> 
	<xsl:attribute name="height">30</xsl:attribute> 
	<xsl:attribute name="width">30</xsl:attribute> 
</xsl:attribute-set>

<xsl:attribute-set name="commandButtons.edit">
	<xsl:attribute name="src">../../../../Images/Buttons/btn_Edit.gif</xsl:attribute> 
	<xsl:attribute name="height">25</xsl:attribute> 
	<xsl:attribute name="width">25</xsl:attribute> 
</xsl:attribute-set>

<xsl:attribute-set name="commandButtons.delete">
	<xsl:attribute name="src">../../../../Images/Buttons/btn_Delete.gif</xsl:attribute> 
	<xsl:attribute name="height">25</xsl:attribute> 
	<xsl:attribute name="width">25</xsl:attribute> 
</xsl:attribute-set>

</xsl:stylesheet>