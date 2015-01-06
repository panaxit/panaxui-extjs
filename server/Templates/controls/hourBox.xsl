<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">
<xsl:strip-space elements="*"/>

<xsl:template name="hourBox" match="*[
@dataType='hour'
]">
	<xsl:call-template name="textBox">
		<xsl:with-param name="size">6</xsl:with-param>
	</xsl:call-template> Hrs.
</xsl:template>
</xsl:stylesheet>
