<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:str="http://exslt.org/str"
	extension-element-prefixes="str msxsl"
>
<xsl:output method="html" omit-xml-declaration="yes"/> 
<msxsl:script language="JavaScript" implements-prefix="str">
<![CDATA[
function escapeQuotes(sText){ var sNewText=sText; return sNewText.replace(/\"|&quot;/gi, '\\"');}
]]>
</msxsl:script>
<xsl:template match="/">
	<xsl:choose>
	<xsl:when test="results"><xsl:apply-templates/></xsl:when>	
	<xsl:otherwise>alert('No se registraron cambios');</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="results">
function saveCommandResults()
{
this.onComplete=function() {
if ((typeof self.parent.window.dialogArguments)=='object') 
	{
	self.parent.close();
	}
else
	{
	refreshPage(); 
	}
}

this.onError=submit.onError
<xsl:for-each select="result[@status='success']">
	var oTable=$("#<xsl:value-of select="@sourceObjectId"/>").closest(".dataTable").get(0);
	$("#<xsl:value-of select="@sourceObjectId"/>").removeClass("delete").find(".changed").filter(function(){ return $(this).closest(".dataTable").get(0)==oTable} ).removeClass("changed");
</xsl:for-each>

<xsl:choose>
	<xsl:when test="count(result)=0">
	alert('No se reqistraron cambios');
	</xsl:when>	
	<xsl:when test="count(result[@status='error'])=0">
		<xsl:for-each select="result">
		try {
			if (<xsl:value-of select="@dataTable"/> &amp;&amp; <xsl:value-of select="@dataTable"/>.submit) { 
<xsl:value-of select="@dataTable"/>.submit.dataRow={};
var oDataRow = new Object();<xsl:if test="@sourceObjectId!='' and @identityValue!=''">document.all("<xsl:value-of select="@sourceObjectId"/>").db_identity_value=<xsl:choose>
	<xsl:when test="@identityValue='NULL'">null</xsl:when>
	<xsl:otherwise>"<xsl:value-of select="@identityValue"/>"</xsl:otherwise>
</xsl:choose>; document.all("<xsl:value-of select="@sourceObjectId"/>").db_primary_value=<xsl:choose>
	<xsl:when test="@primaryValue='NULL'">null</xsl:when>
	<xsl:otherwise>"<xsl:value-of select="@primaryValue"/>"</xsl:otherwise>
</xsl:choose>; <xsl:for-each select="@*"><xsl:value-of select="../@dataTable"/>.submit.dataRow.<xsl:value-of select="name(.)"/>="<xsl:value-of select="."/>";</xsl:for-each> <xsl:for-each select="@*">oDataRow.<xsl:value-of select="name(.)"/>="<xsl:value-of select="."/>";</xsl:for-each>
		<xsl:if test="@dataTable">
				<xsl:value-of select="@dataTable"/>.submit.status='success';
				if (<xsl:value-of select="@dataTable"/>.submit.onSuccess) oDataRow=<xsl:value-of select="@dataTable"/>.submit.onSuccess(oDataRow); 
				if (<xsl:value-of select="@dataTable"/>.submit.onComplete) this.onComplete=<xsl:value-of select="@dataTable"/>.submit.onComplete; 
		</xsl:if> 
			}
		} catch(e) {}
		 
	</xsl:if></xsl:for-each>
	
		if ((typeof self.parent.window.dialogArguments)=='object') 
			{
			var oResults = new Object();
			oResults.status="success";
			oResults.script = " \
				try { \
					var oSrcElement=event.srcElement; \
					if ($(oSrcElement).is('.commandButton')) { \
						var oTableLoader=$(oSrcElement).closest('.tableLoader, .tabPanel').get(0); \
						if (oTableLoader) { \
							oTableLoader.isUpdated=false; \
						} else { \
							location.href=location.href; \
						} \
					} else { \
						<xsl:if test="count(result[@status='success'])=1"> \
						for (c=0; c&lt;(oSrcElement.length &amp;&amp; oSrcElement(0).tagName!='OPTION'?oSrcElement.length:1); ++c) { \
							var oSrcElement_item=(oSrcElement.length &amp;&amp; oSrcElement(0).tagName!='OPTION'?oSrcElement(c):oSrcElement); \
							oSrcElement_item.options[oSrcElement_item.length]=new Option(\'Ultimo registro ingresado\', \'<xsl:value-of select="result/@identityValue"/>\'); \
							if (oSrcElement_item==oSrcElement) { \
								oSrcElement_item[oSrcElement_item.length-1].selected=true; \
								try { \
									oSrcElement_item.cargarCatalogoForzado() \
								} catch(e){ \
									oSrcElement_item.fireEvent('onchange'); \
								} \
							} \
						} \
						</xsl:if>\
					(oSrcElement.type=='select-one' &amp;&amp; ( $(oSrcElement).is('.catalog')))?oSrcElement.isUpdated=false:null; \
					} \
			} catch(e) {}; ";
			
		    window.returnValue = oResults;
			} 
		else { 
			if ($(".dataTable").attr("db_table_name")=="dbo.PagosCliente" &amp;&amp; $(".dataTable").attr("mode")=="insert" &amp;&amp; confirm("Ver recibo?")) openLink('../Templates/request.asp?CatalogName=Recibos&amp;Mode=readonly&amp;Filters=IdPago='+document.all("<xsl:value-of select="result/@sourceObjectId"/>").db_identity_value);
		}
		this.onComplete();
	</xsl:when>	
	<xsl:when test="contains(result/@statusMessage, 'LOGIN')">login.onCancel = function() { }; login.onSuccess = function() {SaveCommand()}; login.go(); </xsl:when>
	<xsl:otherwise>
	<xsl:for-each select="result[@status='error']">
	
	try 
	{
		if (<xsl:value-of select="@dataTable"/> &amp;&amp; <xsl:value-of select="@dataTable"/>.submit) { 
			<xsl:if test="@dataTable"><xsl:for-each select="@*"><xsl:value-of select="../@dataTable"/>.submit.<xsl:value-of select="name(.)"/>="<xsl:value-of select="str:escapeQuotes(string(.))" disable-output-escaping="yes"/>";</xsl:for-each>
			<xsl:value-of select="@dataTable"/>.submit.status='error';
			<xsl:value-of select="@dataTable"/>.submit.statusMessage="<xsl:value-of select="str:escapeQuotes(string(@statusMessage))" disable-output-escaping="yes" />";		
			if (<xsl:value-of select="@dataTable"/>.submit.onError) this.onError=<xsl:value-of select="@dataTable"/>.submit.onError; 
		}
	} catch(e) {}
	</xsl:if>
	</xsl:for-each>
	this.onError("<strong>Se encontraron los siguientes problemas:</strong><br/><br/><ul><xsl:for-each select="result[@status='error']"><li><xsl:value-of select="str:escapeQuotes(string(@statusMessage))" disable-output-escaping="yes" /></li></xsl:for-each></ul>");
	
	</xsl:otherwise>
</xsl:choose>
}
saveCommandResults();
</xsl:template>
</xsl:stylesheet>