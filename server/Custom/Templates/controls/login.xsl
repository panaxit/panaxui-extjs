<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="../../../../templates/html.xsl" />
<xsl:template match="/">
<div class="login" style="background-color:#6699CC"><br/>
<label class="MainTitle" style="color:white">LOGIN</label>
<table style="background-color:#6699CC">
	<tr>
		<td rowspan="3" padding="25" class="logo"><xsl:element name="img" use-attribute-sets="login.logo"/></td><th><label>Usuario:</label></th><td colspan="2"><span><input type="text" name="username" size="20"  style="background-color:white"/></span></td>
	</tr>
	<tr>
		<th><label>Password:</label></th><td colspan="2"><input type="password" name="password" size="20" style="background-color:white"/></td>
	</tr>
	<tr>
		<td align="center"><button><xsl:attribute name="onclick">doLogin()</xsl:attribute>ENTRAR</button></td>
		<td colspan="2" align="right"><button onClick="cancelLogin();">CANCELAR</button></td>
	</tr>
</table>
</div>

</xsl:template></xsl:stylesheet>