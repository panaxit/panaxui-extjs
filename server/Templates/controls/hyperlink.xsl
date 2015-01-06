<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">
<xsl:strip-space elements="*"/>

<!-- <xsl:template name="hyperlink" match="*[not(@dataType='foreignKey') and (@controlType='hyperlink' or not(@controlType) or @controlType='default' and ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='hyperlink')]">
	<xsl:choose>
	<xsl:when test="@navigateURL"><label class="link"><xsl:attribute name="onclick">openLink("<xsl:value-of select="@navigateURL"/>")</xsl:attribute><xsl:value-of select="@text"/></label></xsl:when>	
	<xsl:when test="ancestor::*[@dataType='foreignKey']"><label class="link" onclick="openEditPage('../Templates/request.asp?catalogName={@Table_Schema}.{@Table_Name}&amp;mode=edit&amp;filters=[{@primaryKey}]=\'{@value}\'');"><xsl:value-of select="@text"/></label></xsl:when>	
	<xsl:otherwise>
	items: [
	<xsl:for-each select="*">
	<xsl:if test="position()&gt;1">,</xsl:if>{
		xtype:'box',
		isFormField: true,
		id: "prospectStageLink",
		style: "padding: 3px",
		autoEl:{
			tag: 'a',
			href: '#',
			cn: '<xsl:value-of select="@text"/>'
		},
		listeners: {
			render: function(component) {
				component.getEl().on('click', function(e) {
					alert("../Templates/request.asp?catalogName=<xsl:value-of select="@Table_Schema"/>.<xsl:value-of select="@Table_Name"/>&amp;mode=edit&amp;Filters=''");
				});    
			}
		}
	}
	</xsl:for-each>
	]
	</xsl:otherwise>
</xsl:choose>
</xsl:template> -->
</xsl:stylesheet>
