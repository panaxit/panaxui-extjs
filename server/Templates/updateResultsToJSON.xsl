<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:str="http://exslt.org/str"
	extension-element-prefixes="str msxsl"
>
<xsl:output method="text" omit-xml-declaration="yes"/> 
<msxsl:script language="JavaScript" implements-prefix="str">
<![CDATA[
function escapeQuotes(sText){ var sNewText=sText; return sNewText.replace(/\"|&quot;/gi, '\\"');}
function escapeSingleQuotes(sText){ var sNewText=sText; return sNewText.replace(/\'/gi, "\\'");}
]]>
</msxsl:script>
<xsl:template match="text()" name="insertBreaks"> 
   <xsl:param name="pText" select="."/> 
   <xsl:choose> 
     <xsl:when test="not(contains($pText, '&#xA;'))"> 
       <xsl:copy-of select="$pText"/> 
     </xsl:when> 
     <xsl:otherwise> 
       <xsl:value-of select="substring-before($pText, '&#xA;')"/> \
	   <xsl:call-template name="insertBreaks"> 
         <xsl:with-param name="pText" select= 
           "substring-after($pText, '&#xA;')"/> 
       </xsl:call-template> 
     </xsl:otherwise> 
   </xsl:choose> 
 </xsl:template> 

<xsl:template match="/">
	<xsl:choose>
	<xsl:when test="results"><xsl:apply-templates/></xsl:when>	
	<xsl:otherwise>
    {
    success: false,
    message: "El sistema tuvo problemas para guardar cambios"
    }
  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="results">
  {
  success: <xsl:choose>
    <xsl:when test="not(result) or result[@status='error']">false</xsl:when>
    <xsl:otherwise>true</xsl:otherwise>
  </xsl:choose>,
  message: "<xsl:choose>
    <xsl:when test="count(result)=0">No se reqistraron cambios</xsl:when>
    <xsl:when test="count(result[@status='error'])=0">Todos los cambios fueron realizados exitosamente<xsl:for-each select="result"></xsl:for-each></xsl:when>
    <xsl:otherwise><![CDATA[<strong>Se encontraron los siguientes problemas:</strong><br/><br/><ul>]]><xsl:for-each select="result[@status='error']"><![CDATA[<li>]]><xsl:call-template name="insertBreaks"><xsl:with-param name="pText" select="str:escapeQuotes(string(@statusMessage))" /></xsl:call-template><![CDATA[</li>]]></xsl:for-each><![CDATA[</ul>]]></xsl:otherwise>
  </xsl:choose>",
	results: [<xsl:for-each select="result">{
			objectId: '<xsl:value-of select="@objectId"/>'<xsl:for-each select="@*">, <xsl:value-of select="local-name(.)"/>:'<xsl:value-of select="str:escapeSingleQuotes(string(.))"/>' </xsl:for-each>
		},</xsl:for-each>],
  action: undefined
}
</xsl:template>
</xsl:stylesheet>