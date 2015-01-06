<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="logo[not(@dataType)]">
<xsl:element name="img" use-attribute-sets="login.logo">
	<xsl:copy-of select="@*" />
</xsl:element>
</xsl:template>

</xsl:stylesheet>