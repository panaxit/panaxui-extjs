<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">

<xsl:import href="../attributeSets.xsl" />
<xsl:import href="../html.xsl" />
<xsl:include href="../../custom/templates/layout/logo.xsl" /> 

<xsl:template match="logo[not(@dataType)]" priority="-1">
	<xsl:element name="img" use-attribute-sets="login.logo"/>
</xsl:template>
</xsl:stylesheet>
