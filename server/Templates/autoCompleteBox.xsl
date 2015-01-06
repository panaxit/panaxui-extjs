<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:str="http://exslt.org/str"
	extension-element-prefixes="str"
>
<xsl:output method="text" omit-xml-declaration="yes"/> 
<msxsl:script language="JavaScript" implements-prefix="str">
<![CDATA[
function escapeQuotes(sText){ var sNewText=sText; return sNewText.replace(/\"/gi, '\\"');}
function toUpperCase(sText){ var sNewText=sText; return sNewText.toUpperCase();}
]]>
</msxsl:script>
<xsl:template match="/">
/*while (hasChildNodes()) {
  removeChild(firstChild);
}*/
/*oClone = cloneNode(false);
replaceNode(oClone)*/
options.length=0;
/*for (var j=options.length-1; j>=0; j--)
	{
	remove(j);
	}*/
//with (oClone) {
<!-- <xsl:if test="(string(/options/@allowNulls)='true' or string(/options/@value)='') and string(/options/@searchText)=''">options[length]=new Option("", ""); options[length-1].selected=true;</xsl:if> -->
<!-- options[length]=new Option("- -", ""); options[length-1].className='null systemOption'; options[length-1].selected=true; -->
<xsl:choose>
	<xsl:when test="data">
		alert('data received!')
	</xsl:when>
	<xsl:when test="count(options/option)=0">
		options[length]=new Option("No hay opciones", "NULL"); 
		options[length-1].style.color='red';
	</xsl:when>
	<xsl:otherwise>
		<xsl:for-each select="options/option[string(/options/@enableFiltering)!='true' or contains(str:toUpperCase(string(@text)),str:toUpperCase(string(/options/@searchText)))]">
			<xsl:sort select="@text" order="ascending" />
			<xsl:variable name="texto" select="@text"/>
			options[length]=new Option("<xsl:choose><xsl:when test="@text=''">(Sin texto)</xsl:when><xsl:otherwise><strong><xsl:value-of select="str:escapeQuotes(string(@text))" disable-output-escaping="yes" /></strong></xsl:otherwise>
</xsl:choose>", "<xsl:value-of select="@value" disable-output-escaping="yes" />"); 
			<xsl:if test="@color!=''">options[length-1].style.color='<xsl:value-of select="@color" />';</xsl:if>
			<xsl:if test="@className!=''">options[length-1].className='<xsl:value-of select="@className" />';</xsl:if>
			options[length-1].id='opt_<xsl:value-of select="@value"/>';
			<!-- <xsl:if test="not(preceding-sibling::*[@value!='NULL'] or following-sibling::*[@value!='NULL'])">options[length-1].selected=true;</xsl:if> -->
			<xsl:if test="string(/options/@searchText)!='' and str:toUpperCase(string(@text))=str:toUpperCase(string(/options/@searchText)) or position()=1 or string(/options/@searchText)='' and string(@value)=string(/options/@value) and not(preceding-sibling::*[str:toUpperCase(string(@text))=str:toUpperCase(string(/options/@searchText))])">options[length-1].selected=true;</xsl:if> 
		</xsl:for-each>
		<xsl:for-each select="DEBUG/sqlQuery">
			alert('<xsl:value-of select="."/>')
		</xsl:for-each>
	</xsl:otherwise>
</xsl:choose>
//}
</xsl:template>
</xsl:stylesheet>
