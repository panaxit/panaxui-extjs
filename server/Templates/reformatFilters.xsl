<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:str="http://exslt.org/str"
	extension-element-prefixes="str msxsl"
>
<xsl:output method="xml" omit-xml-declaration="yes"/> 

<xsl:template match="/">
	<xsl:apply-templates mode="reformatFilters"/>
</xsl:template>

<xsl:template match="dataField" mode="reformatFilters">
	<dataField>
		<xsl:copy-of select="@*"/>
		<!-- <filterGroup operator="LIKE"> -->
		<filterGroup operator="=">
			<dataValue><xsl:value-of select="."/></dataValue>
		</filterGroup>
	</dataField>
</xsl:template>

<xsl:template match="dataField[text()='NULL' or text()='null']" mode="reformatFilters"></xsl:template>

<xsl:template match="dataRow" mode="reformatFilters">
	<filterGroup operator="AND">
		<xsl:apply-templates mode="reformatFilters"/>
	</filterGroup>
</xsl:template>

<xsl:template match="dataTable" mode="reformatFilters">
	<xsl:copy>
		<xsl:copy-of select="@*"/>
		<xsl:apply-templates mode="reformatFilters"/>
	</xsl:copy>
</xsl:template>

</xsl:stylesheet>