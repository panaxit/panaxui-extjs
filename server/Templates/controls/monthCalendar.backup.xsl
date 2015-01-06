<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">
<xsl:strip-space elements="*"/>

<xsl:template name="monthCalendar.table" match="*[@controlType='gridView' or @dataType='table' and @controlType='default']">
		<TABLE width="100%" class="dataTable monthCalendar Calendario" cellpadding="0" cellspacing="0" border="1">
		<xsl:attribute name="db_table_name"><xsl:value-of select="@Table_Schema"/>.<xsl:value-of select="@Table_Name"/></xsl:attribute>
		<xsl:attribute name="db_primary_key"><xsl:value-of select="@primaryKey"/></xsl:attribute>
		<xsl:attribute name="id">dataTable</xsl:attribute>
		<TR>
		<TH CLASS="MonthHeader" align="center" colspan="7"><img class="Button" src="\Valtus\Images/btn_LArrow.png" width="20" height="20" alt="VER MES ANTERIOR" enabled="true" oncontextmenu="return false;" onclick="openLinkencodeURI('/valtus/DynamicData/List.asp?requestTable=AgendaSeguimientos&amp;dStartDate=1/1/2010'), false, true)" style="cursor:hand;"/>
<xsl:value-of select="$nbsp"/><select name="mes" onChange="location.replace(updateURLString(location.href, 'dStartDate', '1/'+this.value+'/2010'))">	
	<option value="1" >Enero</option>
	<option value="2" selected="selected">Febrero</option>
	<option value="3" >Marzo</option>
	<option value="4" >Abril</option>
	<option value="5" >Mayo</option>
	<option value="6" >Junio</option>
	<option value="7" >Julio</option>
	<option value="8" >Agosto</option>
	<option value="9" >Septiembre</option>
	<option value="10" >Octubre</option>
	<option value="11" >Noviembre</option>
	<option value="12" >Diciembre</option>
	</select><xsl:value-of select="$nbsp"/>
	<select name="anio" onChange="location.replace(updateURLString(location.href, 'dStartDate', '1/2/'+this.value))">
	<option value="2005" >2005</option>
	<option value="2006" >2006</option>
	<option value="2007" >2007</option>
	<option value="2008" >2008</option>
	<option value="2009" >2009</option>
	<option value="2010" selected="selected">2010</option>
	<option value="2011" >2011</option>
	<option value="2012" >2012</option>
	<option value="2013" >2013</option>
	<option value="2014" >2014</option>
	<option value="2015" >2015</option>
	</select><xsl:value-of select="$nbsp"/><img class="Button" src="\Valtus\Images/btn_RArrow.png" width="20" height="20" alt="VER MES SIGUIENTE" enabled="true" oncontextmenu="return false;" onclick="openLinkencodeURI('/valtus/DynamicData/List.asp?requestTable=AgendaSeguimientos&amp;dStartDate=1/3/2010'), false, true)" style="cursor:hand;"/>
<xsl:value-of select="$nbsp"/><xsl:value-of select="$nbsp"/><xsl:value-of select="$nbsp"/><b style="cursor:'hand';" onClick="location.replace(updateURLString(location.href, 'dStartDate', '03/01/2011'))">HOY</b> </TH>
		</TR>
		<TR>
			<TH CLASS="MonthHeader" align="center"> Dom </TH>
			<TH CLASS="MonthHeader" align="center"> Lun </TH>
			<TH CLASS="MonthHeader" align="center"> Mar </TH>
			<TH CLASS="MonthHeader" align="center"> Mie </TH>
			<TH CLASS="MonthHeader" align="center"> Jue </TH>
			<TH CLASS="MonthHeader" align="center"> Vie </TH>
			<TH CLASS="MonthHeader" align="center"> Sáb </TH>
		</TR>
			<TR>
				<TD valign="top" style="background:'silver'; color:'gray';"><TABLE class="MonthDay" dia="31/01/2010" width="100%">
	<TR><TH style="background:'gray';" CLASS="MonthDayHeader" align="left" width="14.286%">31</TH></TR>
			<TR><TD align="center" width="150"  style="color:'gray';"><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
				<TD valign="top" style=""><TABLE class="MonthDay" dia="01/02/2010" width="100%">
	<TR><TH style="" CLASS="MonthDayHeader" align="left" width="14.286%">1</TH></TR>
			<TR><TD align="center" width="150" ><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
				<TD valign="top" style=""><TABLE class="MonthDay" dia="02/02/2010" width="100%">
	<TR><TH style="" CLASS="MonthDayHeader" align="left" width="14.286%">2</TH></TR>
			<TR><TD align="center" width="150" ><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
				<TD valign="top" style=""><TABLE class="MonthDay" dia="03/02/2010" width="100%">
	<TR><TH style="" CLASS="MonthDayHeader" align="left" width="14.286%">3</TH></TR>
			<TR><TD align="center" width="150" ><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
				<TD valign="top" style=""><TABLE class="MonthDay" dia="04/02/2010" width="100%">
	<TR><TH style="" CLASS="MonthDayHeader" align="left" width="14.286%">4</TH></TR>
			<TR><TD align="center" width="150" ><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
				<TD valign="top" style=""><TABLE class="MonthDay" dia="05/02/2010" width="100%">
	<TR><TH style="" CLASS="MonthDayHeader" align="left" width="14.286%">5</TH></TR>
			<TR><TD align="center" width="150" ><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
				<TD valign="top" style=""><TABLE class="MonthDay" dia="06/02/2010" width="100%">
	<TR><TH style="" CLASS="MonthDayHeader" align="left" width="14.286%">6</TH></TR>
			<TR><TD align="center" width="150" ><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
			</TR>
			<TR>
				<TD valign="top" style=""><TABLE class="MonthDay" dia="07/02/2010" width="100%">
	<TR><TH style="" CLASS="MonthDayHeader" align="left" width="14.286%">7</TH></TR>
			<TR><TD align="center" width="150" ><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
				<TD valign="top" style=""><TABLE class="MonthDay" dia="08/02/2010" width="100%">
	<TR><TH style="" CLASS="MonthDayHeader" align="left" width="14.286%">8</TH></TR>
			<TR><TD align="center" width="150" ><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
				<TD valign="top" style=""><TABLE class="MonthDay" dia="09/02/2010" width="100%">
	<TR><TH style="" CLASS="MonthDayHeader" align="left" width="14.286%">9</TH></TR>
			<TR><TD align="center" width="150" ><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
				<TD valign="top" style=""><TABLE class="MonthDay" dia="10/02/2010" width="100%">
	<TR><TH style="" CLASS="MonthDayHeader" align="left" width="14.286%">10</TH></TR>
			<TR><TD align="left" width="150"  nowrap="nowrap"><b>1. </b><b>LIDIA CANTU</b><br/>YA CONOCIO LAS CASAS DE COMONFORT, CORONEL ROMERO Y BELLAS LOMAS, ESPERAREMOS A VER SI ACEPTAN LAS PROPUESTAS DE COMPRA.            10/02/10 LE ENVIE LOS SIMULADOES DE BANCO Y LE PROPUSE IR PREAUTORIZANDO SU CREDITO ESTAMOS EN ESPERA DE LA RESPUESTA DE LOS DUEÑOS DE LAS CASAS.</TD></TR>
	
			<TR><TD align="center" width="150" ><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
				<TD valign="top" style=""><TABLE class="MonthDay" dia="11/02/2010" width="100%">
	<TR><TH style="" CLASS="MonthDayHeader" align="left" width="14.286%">11</TH></TR>
			<TR><TD align="left" width="150"  nowrap="nowrap"><b>1. </b><b>ROSA  MARGARITA PUENTE MARTINEZ</b><br/>QUEDAMOS DE IR AVER LAS CASA DE FRACC. VILLA RICA E HIMNO NAL.</TD></TR>
	
			<TR><TD align="left" width="150"  nowrap="nowrap"><b>2. </b><b>FRANCISCO JAVIER SANTOYO</b><br/>SOLO ESTAMOS EN ESPERA DE QUE AUTORICEN LA FIRMA</TD></TR>
	
			<TR><TD align="center" width="150" ><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
				<TD valign="top" style=""><TABLE class="MonthDay" dia="12/02/2010" width="100%">
	<TR><TH style="" CLASS="MonthDayHeader" align="left" width="14.286%">12</TH></TR>
			<TR><TD align="left" width="150"  nowrap="nowrap"><b>1. </b><b>ROSA ESTELA VELAZQUEZ</b><br/>MARCARLE APROXIMADAMENTE EN UNOS 15 DIAS PARA DARLE LA INFORMACION DE LOS TERRENOS</TD></TR>
	
			<TR><TD align="left" width="150"  nowrap="nowrap"><b>2. </b><b>LAURA OLIVIA FLORES</b><br/>YA FIRMO SOLO ESTAMOS EN ESPERA A ENTREGA DE CASA</TD></TR>
	
			<TR><TD align="center" width="150" ><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
				<TD valign="top" style=""><TABLE class="MonthDay" dia="13/02/2010" width="100%">
	<TR><TH style="" CLASS="MonthDayHeader" align="left" width="14.286%">13</TH></TR>
			<TR><TD align="center" width="150" ><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
			</TR>
			<TR>
				<TD valign="top" style=""><TABLE class="MonthDay" dia="14/02/2010" width="100%">
	<TR><TH style="" CLASS="MonthDayHeader" align="left" width="14.286%">14</TH></TR>
			<TR><TD align="center" width="150" ><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
				<TD valign="top" style=""><TABLE class="MonthDay" dia="15/02/2010" width="100%">
	<TR><TH style="" CLASS="MonthDayHeader" align="left" width="14.286%">15</TH></TR>
			<TR><TD align="center" width="150" ><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
				<TD valign="top" style=""><TABLE class="MonthDay" dia="16/02/2010" width="100%">
	<TR><TH style="" CLASS="MonthDayHeader" align="left" width="14.286%">16</TH></TR>
			<TR><TD align="center" width="150" ><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
				<TD valign="top" style=""><TABLE class="MonthDay" dia="17/02/2010" width="100%">
	<TR><TH style="" CLASS="MonthDayHeader" align="left" width="14.286%">17</TH></TR>
			<TR><TD align="center" width="150" ><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
				<TD valign="top" style=""><TABLE class="MonthDay" dia="18/02/2010" width="100%">
	<TR><TH style="" CLASS="MonthDayHeader" align="left" width="14.286%">18</TH></TR>
			<TR><TD align="center" width="150" ><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
				<TD valign="top" style=""><TABLE class="MonthDay" dia="19/02/2010" width="100%">
	<TR><TH style="" CLASS="MonthDayHeader" align="left" width="14.286%">19</TH></TR>
			<TR><TD align="left" width="150"  nowrap="nowrap"><b>1. </b><b>NANCY ARRIAGA</b><br/>MARCO LA SEÑORA HABLO CON EL ARQUITECTO PROPONIENDOLE CONSEGUIR EL FALTANTE PARA CUBRIR LA ULTIMA OFERTA DE COMPRA</TD></TR>
	
			<TR><TD align="center" width="150" ><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
				<TD valign="top" style=""><TABLE class="MonthDay" dia="20/02/2010" width="100%">
	<TR><TH style="" CLASS="MonthDayHeader" align="left" width="14.286%">20</TH></TR>
			<TR><TD align="center" width="150" ><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
			</TR>
			<TR>
				<TD valign="top" style=""><TABLE class="MonthDay" dia="21/02/2010" width="100%">
	<TR><TH style="" CLASS="MonthDayHeader" align="left" width="14.286%">21</TH></TR>
			<TR><TD align="center" width="150" ><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
				<TD valign="top" style=""><TABLE class="MonthDay" dia="22/02/2010" width="100%">
	<TR><TH style="" CLASS="MonthDayHeader" align="left" width="14.286%">22</TH></TR>
			<TR><TD align="center" width="150" ><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
				<TD valign="top" style=""><TABLE class="MonthDay" dia="23/02/2010" width="100%">
	<TR><TH style="" CLASS="MonthDayHeader" align="left" width="14.286%">23</TH></TR>
			<TR><TD align="left" width="150"  nowrap="nowrap"><b>1. </b><b>ELOY ARMANDO CRISOSTOMO CORTES</b><br/>LE INTERESA UNA CASA DE EL MONTO DE SU INFONAVIT TRADICIONAL</TD></TR>
	
			<TR><TD align="center" width="150" ><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
				<TD valign="top" style=""><TABLE class="MonthDay" dia="24/02/2010" width="100%">
	<TR><TH style="" CLASS="MonthDayHeader" align="left" width="14.286%">24</TH></TR>
			<TR><TD align="center" width="150" ><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
				<TD valign="top" style=""><TABLE class="MonthDay" dia="25/02/2010" width="100%">
	<TR><TH style="" CLASS="MonthDayHeader" align="left" width="14.286%">25</TH></TR>
			<TR><TD align="center" width="150" ><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
				<TD valign="top" style=""><TABLE class="MonthDay" dia="26/02/2010" width="100%">
	<TR><TH style="" CLASS="MonthDayHeader" align="left" width="14.286%">26</TH></TR>
			<TR><TD align="center" width="150" ><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
				<TD valign="top" style=""><TABLE class="MonthDay" dia="27/02/2010" width="100%">
	<TR><TH style="" CLASS="MonthDayHeader" align="left" width="14.286%">27</TH></TR>
			<TR><TD align="center" width="150" ><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
			</TR>
			<TR>
				<TD valign="top" style=""><TABLE class="MonthDay" dia="28/02/2010" width="100%">
	<TR><TH style="" CLASS="MonthDayHeader" align="left" width="14.286%">28</TH></TR>
			<TR><TD align="center" width="150" ><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
				<TD valign="top" style="background:'silver'; color:'gray';"><TABLE class="MonthDay" dia="01/03/2010" width="100%">
	<TR><TH style="background:'gray';" CLASS="MonthDayHeader" align="left" width="14.286%">1</TH></TR>
			<TR><TD align="left" width="150"  style="color:'gray';" nowrap="nowrap"><b>1. </b><b>ROSA ESTELA VELAZQUEZ</b><br/>SOLICITA QUE SE LE BUSQUE ALGUN TERRENO MEJOR UBICADO O CASA DE MENOS DE 450,000</TD></TR>
	
			<TR><TD align="center" width="150"  style="color:'gray';"><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
				<TD valign="top" style="background:'silver'; color:'gray';"><TABLE class="MonthDay" dia="02/03/2010" width="100%">
	<TR><TH style="background:'gray';" CLASS="MonthDayHeader" align="left" width="14.286%">2</TH></TR>
			<TR><TD align="center" width="150"  style="color:'gray';"><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
				<TD valign="top" style="background:'silver'; color:'gray';"><TABLE class="MonthDay" dia="03/03/2010" width="100%">
	<TR><TH style="background:'gray';" CLASS="MonthDayHeader" align="left" width="14.286%">3</TH></TR>
			<TR><TD align="left" width="150"  style="color:'gray';" nowrap="nowrap"><b>1. </b><b>JASMIN ESTRADA------CONTRERAS</b><br/>SE LE MARCARA EL DIA VIERNES</TD></TR>
	
			<TR><TD align="center" width="150"  style="color:'gray';"><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
				<TD valign="top" style="background:'silver'; color:'gray';"><TABLE class="MonthDay" dia="04/03/2010" width="100%">
	<TR><TH style="background:'gray';" CLASS="MonthDayHeader" align="left" width="14.286%">4</TH></TR>
			<TR><TD align="center" width="150"  style="color:'gray';"><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
				<TD valign="top" style="background:'silver'; color:'gray';"><TABLE class="MonthDay" dia="05/03/2010" width="100%">
	<TR><TH style="background:'gray';" CLASS="MonthDayHeader" align="left" width="14.286%">5</TH></TR>
			<TR><TD align="left" width="150"  style="color:'gray';" nowrap="nowrap"><b>1. </b><b>ALBERTO SAVALA</b><br/>LE MARQUE E ODIA LUNES QUE LE MERQUE EL VIERNES</TD></TR>
	
			<TR><TD align="left" width="150"  style="color:'gray';" nowrap="nowrap"><b>2. </b><b>LIDIA CANTU</b><br/>VISITARA LAS OFINAS</TD></TR>
	
			<TR><TD align="center" width="150"  style="color:'gray';"><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
				<TD valign="top" style="background:'silver'; color:'gray';"><TABLE class="MonthDay" dia="06/03/2010" width="100%">
	<TR><TH style="background:'gray';" CLASS="MonthDayHeader" align="left" width="14.286%">6</TH></TR>
			<TR><TD align="center" width="150"  style="color:'gray';"><br/><br/><br/><br/></TD></TR>
	
				
				</TABLE></TD>
			</TR>
			<TR>
			</TR>
	</TABLE>
</xsl:template>

<xsl:template name="monthCalendar.row">

</xsl:template>

<xsl:template name="monthCalendar.empty" match="*[@controlType='monthCalendar' or @dataType='table' and @controlType='default'][count(dataRow)=0]">
	<b class="warning">NO HAY INFORMACIÓN</b>
</xsl:template>

</xsl:stylesheet>