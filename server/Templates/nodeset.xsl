<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:user="http://www.contoso.com"
                version="1.0">
    <xsl:variable name="books">
        <book author="Michael Howard">Writing Secure Code</book>
        <book author="Michael Kay">XSLT Reference</book>
    </xsl:variable>

    <xsl:template match="/">
        <authors>
            <xsl:for-each select="msxsl:node-set($books)/book"> 
                <author><xsl:value-of select="@author"/></author>
            </xsl:for-each>
        </authors>
    </xsl:template>
</xsl:stylesheet>
