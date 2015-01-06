<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">
<xsl:strip-space elements="*"/>

<xsl:template name="null" match="*[not(@value!='' or @text!='')][(not(@controlType) and not(@dataType))][not(*)]"><!-- ancestor-or-self::*[@mode!='inherit'][1]/@mode='readonly' or  -->
	--<xsl:value-of select="$nbsp"/>
</xsl:template>
</xsl:stylesheet>
