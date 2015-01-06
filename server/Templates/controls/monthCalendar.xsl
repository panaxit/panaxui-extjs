<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns:str="http://exslt.org/strings"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    extension-element-prefixes="date msxsl"
	xmlns="http://www.w3.org/TR/xhtml1/strict"
	>
<xsl:strip-space elements="*"/>

<xsl:template match="*[@controlType='monthCalendar']">
	<!-- <strong>Fecha: <xsl:value-of select="@fechaInicio"/>, <xsl:value-of select="@fechaFinal"/></strong> -->
	<TABLE width="100%" class="dataTable monthCalendar Calendario" cellpadding="0" cellspacing="0" border="1">
		<xsl:attribute name="db_table_name"><xsl:value-of select="@Table_Schema"/>.<xsl:value-of select="@Table_Name"/></xsl:attribute>
		<xsl:attribute name="db_identity_key"><xsl:value-of select="@identityKey"/></xsl:attribute>
		<xsl:attribute name="db_primary_key"><xsl:value-of select="@primaryKey"/></xsl:attribute>
		<xsl:attribute name="id">dataTable</xsl:attribute>
		<xsl:call-template name="monthCalendar.month"><xsl:with-param name="date" select="string(@fechaFinal)"/></xsl:call-template><!-- '2010-12-26' -->
	</TABLE>
</xsl:template>

<xsl:template name="days">
<xsl:param name="date" select="date:date()"/>
<xsl:param name="dayLimit" select="$date"/>
<xsl:value-of select="date:formatDate($date, 'dd/MM/yyyy')"/>(<xsl:value-of select="date:dayInWeek($date)"/>)<!-- (<xsl:value-of select="$date"/> vs. <xsl:value-of select="$dayLimit"/>:<xsl:value-of select="number(translate(date:date($dayLimit), '-', ''))-number(translate($date, '-', ''))"/>) -->,
<xsl:if test="number(translate(date:date($dayLimit), '-', ''))-number(translate($date, '-', ''))&gt;0"><xsl:call-template name="days"><xsl:with-param name="date" select="date:date(date:add($date, 'P1D'))"/><xsl:with-param name="dayLimit" select="$dayLimit"/></xsl:call-template></xsl:if>
</xsl:template>

<xsl:template name="monthCalendar.month">
	<xsl:param name="date" select="date:date()"/>
	<xsl:element name="tr">
		<xsl:attribute name="class">MonthHeader</xsl:attribute>
	</xsl:element>
	<xsl:call-template name="monthCalendar.monthHeader"><xsl:with-param name="date" select="$date"/></xsl:call-template>
	<xsl:call-template name="monthCalendar.weeks"><xsl:with-param name="date" select="$date"/></xsl:call-template>
</xsl:template>

<xsl:template name="monthCalendar.monthHeader">
	<xsl:param name="date"/>
	<thead>
	<tr class="tableHeader"><th colspan="8"><strong class="h2"><xsl:value-of select="@headerText"/></strong></th></tr>
	<TR>
		<TH CLASS="MonthHeader" align="center" colspan="8"><img class="imageButton" src="../../../../Images/Controls/Pager/btn_LArrow.png" width="30" enabled="true" oncontextmenu="return false;" id="leftArrow" ><xsl:attribute name="onClick">var dFechaInicio=requestQuerystring(location.href, '@FechaInicio').replace(/'/gi, ''); var sNewURL=location.href; sNewURL=updateURLString(sNewURL, '@FechaInicio', '\''+dateAdd('m', -1, dFechaInicio)+'\''); sNewURL=updateURLString(sNewURL, '@FechaFinal', '\''+dateAdd('d', -1, dFechaInicio)+'\''); location.href=sNewURL</xsl:attribute></img>
<xsl:value-of select="$nbsp"/><xsl:call-template name="monthCalendar.monthList"><xsl:with-param name="date" select="string($date)"/></xsl:call-template> de <xsl:value-of select="$nbsp"/><xsl:call-template name="monthCalendar.yearList"><xsl:with-param name="date" select="$date"/><xsl:with-param name="startYear" select="2015"/><xsl:with-param name="stopYear" select="2005"/></xsl:call-template>
	<xsl:value-of select="$nbsp"/><img class="imageButton" src="../../../../Images/Controls/Pager/btn_RArrow.png" width="30" enabled="true" oncontextmenu="return false;" id="rightArrow"><xsl:attribute name="onClick">try { var dFechaInicio=dateAdd('m', 1, firstDayOfMonth(requestQuerystring(location.href, '@FechaFinal').replace(/'/gi, ''))); var sNewURL=location.href; sNewURL=updateURLString(sNewURL, '@FechaInicio', '\''+dFechaInicio+'\''); sNewURL=updateURLString(sNewURL, '@FechaFinal', '\''+lastDayOfMonth(dFechaInicio)+'\''); location.href=sNewURL; } catch(e) {alert('Ocurrió un error, intente de nuevo')}</xsl:attribute></img>
<xsl:value-of select="$nbsp"/><xsl:value-of select="$nbsp"/><xsl:value-of select="$nbsp"/><b style="cursor:'hand';" onClick="var dFechaInicio=firstDayOfMonth('{date:formatDate(string(date:date()), 'dd/MM/yyyy')}'); var sNewURL=location.href; sNewURL=updateURLString(sNewURL, '@FechaInicio', '\''+dFechaInicio+'\''); sNewURL=updateURLString(sNewURL, '@FechaFinal', '\''+lastDayOfMonth(dFechaInicio)+'\''); location.href=sNewURL">HOY</b> </TH>
		</TR>
	<xsl:element name="tr">
		<xsl:variable name="startDate" select="date:date(date:add($date, concat('-P',string(date:dayInWeek($date)-1),'D')))"/>
		<xsl:attribute name="class">MonthHeader</xsl:attribute>
		<xsl:element name="th"><xsl:value-of select="$nbsp"/></xsl:element>
		<xsl:call-template name="monthCalendar.dayHeader"><xsl:with-param name="startDate" select="$startDate"/><xsl:with-param name="stopDate" select="date:date(date:add($startDate,'P6D'))"/></xsl:call-template>
	</xsl:element>
	</thead>
</xsl:template>

<xsl:template name="monthCalendar.yearList">
<xsl:param name="date" select="date:date()"/>
<xsl:param name="startYear" select="date:year($date)"/>
<xsl:param name="stopYear" select="$startYear"/>
<!-- <select name="anio" onChange="location.replace(updateURLString(location.href, 'dStartDate', '1/2/'+this.value))">
<xsl:call-template name="monthCalendar.yearList.years"><xsl:with-param name="date" select="$date"/><xsl:with-param name="year" select="$startYear"/><xsl:with-param name="stopYear" select="$stopYear"/></xsl:call-template>
</select> -->
<label><xsl:value-of select="date:year($date)"/></label>
</xsl:template>

<xsl:template name="monthCalendar.yearList.years">
<xsl:param name="date"/>
<xsl:param name="year"/>
<xsl:param name="stopYear" select="$year"/>
<xsl:variable name="nextYear"><xsl:choose>
	<xsl:when test="$stopYear>$year"><xsl:value-of select="$year+1"/></xsl:when>	
	<xsl:when test="$stopYear=$year"><xsl:value-of select="$year"/></xsl:when>	
	<xsl:otherwise><xsl:value-of select="number($year)-1"/></xsl:otherwise>
</xsl:choose></xsl:variable>
	<xsl:element name="option">
	<xsl:attribute name="value"><xsl:value-of select="$year"/></xsl:attribute>
	<xsl:if test="$year=date:year($date)"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
	<xsl:value-of select="$year"/>
	</xsl:element>
<xsl:if test="$year!=$stopYear"><xsl:call-template name="monthCalendar.yearList.years"><xsl:with-param name="date" select="$date"/><xsl:with-param name="year" select="$nextYear"/><xsl:with-param name="stopYear" select="$stopYear"/></xsl:call-template></xsl:if>
</xsl:template>

<xsl:template name="monthCalendar.monthList">
<xsl:param name="date" select="date:date()"/>
<!-- <select name="mes" onChange="location.replace(updateURLString(location.href, 'dStartDate', '1/'+this.value+'/2010'))">	
<xsl:call-template name="monthCalendar.monthList.months"><xsl:with-param name="date" select="$date"/></xsl:call-template>
</select> -->
<label><xsl:value-of select="date:monthName($date)"/></label>
</xsl:template>

<xsl:template name="monthCalendar.monthList.months">
<xsl:param name="date"/>
<xsl:param name="month" select="1"/>
	<xsl:element name="option">
	<xsl:attribute name="value"><xsl:value-of select="$month"/></xsl:attribute>
	<xsl:if test="$month=date:monthInYear($date)"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
	<xsl:value-of select="date:monthName(concat(date:year($date),'-',str:lPad(string($month),2,'0'),'-01'))"/>
	</xsl:element>
<xsl:if test="($month+1)&lt;13"><xsl:call-template name="monthCalendar.monthList.months"><xsl:with-param name="date" select="$date"/><xsl:with-param name="month" select="$month+1"/></xsl:call-template></xsl:if>
</xsl:template>

<xsl:template name="monthCalendar.dayHeader">
	<xsl:param name="startDate"/>
	<xsl:param name="stopDate" select="$startDate"/>
	<xsl:element name="th">
		<xsl:attribute name="class">DayHeader</xsl:attribute>
		<xsl:value-of select="date:dayAbbreviation($startDate)"/>
	</xsl:element>
	<xsl:if test="string($startDate)!=string($stopDate)"><xsl:call-template name="monthCalendar.dayHeader"><xsl:with-param name="startDate" select="date:date(date:add($startDate,'P1D'))"/><xsl:with-param name="stopDate" select="$stopDate"/></xsl:call-template></xsl:if>
</xsl:template>


<xsl:template name="monthCalendar.weeks">
	<xsl:param name="weekInMonth" select="1"/>
	<xsl:param name="date" select="date:date()"/>
	<xsl:variable name="currentDate"><xsl:choose>
			<xsl:when test="date:weekInMonth($date)!=$weekInMonth"><xsl:value-of select="date:date(date:add($date, concat('-P',string(date:dayInMonth($date)-1),'D')))"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="string($date)"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="nextWeekDay"><xsl:value-of select="date:date(date:add(string($currentDate), concat('P',string(7-date:dayInWeek(string($currentDate))+1),'D')))"/></xsl:variable>
	<xsl:element name="tr">
		<xsl:element name="th">
			<xsl:attribute name="class">weekHeader</xsl:attribute>
			<xsl:value-of select="date:weekInYear(date:date(date:add(string($nextWeekDay), '-P7D')))"/>
		</xsl:element>
		<xsl:call-template name="monthCalendar.days"><xsl:with-param name="date" select="string($currentDate)"/></xsl:call-template>
	</xsl:element>
<!-- 	<TR>
	<td>current: <xsl:value-of select="string($currentDate)"/></td><td>next:<xsl:value-of select="string($nextWeekDay)"/></td>
	</TR> -->
	<xsl:if test="date:monthInYear(string($nextWeekDay))=date:monthInYear(string($currentDate))"><xsl:call-template name="monthCalendar.weeks"><xsl:with-param name="date" select="string($nextWeekDay)"/><xsl:with-param name="weekInMonth" select="date:weekInMonth(string($nextWeekDay))"/></xsl:call-template></xsl:if>
	<!-- <xsl:if test="number($dayOfWeek)+1!=8"><xsl:call-template name="week"><xsl:with-param name="startDay" select="$startDay"/><xsl:with-param name="dayOfWeek" select="number($dayOfWeek)+1"/><xsl:with-param name="date" select="date:date(date:add(string($currentDate), 'P1D'))"/></xsl:call-template></xsl:if> -->
</xsl:template>

<xsl:template name="monthCalendar.days">
	<xsl:param name="startDay" select="1"/>
	<xsl:param name="dayOfWeek" select="1"/>
	<xsl:param name="date" select="date:date()"/>
	<xsl:param name="currentWeekInMonth" select="date:weekInMonth(string($date))"/>
	<xsl:variable name="currentDate"><xsl:choose>
			<xsl:when test="date:dayInWeek($date)!=$dayOfWeek"><xsl:value-of select="date:date(date:add($date, concat('-P',string(date:dayInWeek($date)-1),'D')))"/></xsl:when>	
			<xsl:otherwise><xsl:value-of select="string($date)"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:element name="td">
		<xsl:attribute name="valign">top</xsl:attribute>
		<xsl:attribute name="class">MonthDay<xsl:if test="number($currentWeekInMonth)!=number(date:weekInMonth(string($currentDate)))"> notCurrentMonth</xsl:if> <xsl:if test="date:date($date)=date:date()"> currentDay</xsl:if></xsl:attribute>
		<xsl:call-template name="monthCalendar.day"><xsl:with-param name="date" select="string($currentDate)"/></xsl:call-template>
	</xsl:element>
	<xsl:if test="number($dayOfWeek)+1!=8"><xsl:call-template name="monthCalendar.days"><xsl:with-param name="startDay" select="$startDay"/><xsl:with-param name="dayOfWeek" select="number($dayOfWeek)+1"/><xsl:with-param name="date" select="date:date(date:add(string($currentDate), 'P1D'))"/><xsl:with-param name="currentWeekInMonth" select="$currentWeekInMonth"/></xsl:call-template></xsl:if>
</xsl:template>

<xsl:template name="monthCalendar.day">
	<xsl:param name="date"/>
	<xsl:variable name="formatedDate" select="date:formatDate(string($date), 'dd/MM/yyyy')"/>
	<xsl:element name="table">
		<xsl:attribute name="width">100%</xsl:attribute>
		<xsl:element name="tr">
			<xsl:element name="th">
				<xsl:attribute name="class">DateHeader</xsl:attribute>
				<xsl:attribute name="align">left</xsl:attribute>
				<xsl:value-of select="$formatedDate"/>
			</xsl:element>
		</xsl:element>	
		<xsl:element name="tr">
			<xsl:attribute name="height">150</xsl:attribute>
			<xsl:element name="td">
				<xsl:attribute name="align">center</xsl:attribute>
				<xsl:attribute name="width">150</xsl:attribute>
				<!-- month: <xsl:value-of select="date:monthName(string($date))"/><br/>
				weekInYear: <xsl:value-of select="date:weekInYear(string($date))"/><br/>
				dayInMonth: <xsl:value-of select="date:dayInMonth(string($date))"/><br/>
				dayInWeek: <xsl:value-of select="date:dayInWeek(string($date))"/><br/>
				weekInMonth: <xsl:value-of select="date:weekInMonth(string($date))"/><br/>
				first date of week: <xsl:value-of select="date:date(date:add(string($date), concat('-P',string(date:dayInWeek(string($date))-1),'D')))"/><br/>
				date: <xsl:value-of select="date:dayName(string($date))"/><br/>
				next date: <xsl:value-of select="date:date(date:add(string($date), 'P1D'))"/> -->
				
				<xsl:apply-templates select="/*" mode="monthCalendar.day.data"><xsl:with-param name="formatedDate" select="string($formatedDate)"/></xsl:apply-templates>
			</xsl:element>
		</xsl:element>	
	</xsl:element>
</xsl:template>

<xsl:template match="*[@dataType='table']" mode="monthCalendar.day.data">
	<xsl:param name="formatedDate"/>
	<xsl:variable name="table" select="."/>
	<xsl:for-each select="//dataRow[string(*[@dataType='date'][1]/@value)=string($formatedDate)]">
		<xsl:apply-templates select="." mode="monthCalendar.day.data.record.Template"><xsl:with-param name="formatedDate" select="string($formatedDate)"/></xsl:apply-templates>
	</xsl:for-each>
	<xsl:apply-templates select="." mode="monthCalendar.day.data.newRecord.Template"><xsl:with-param name="formatedDate" select="string($formatedDate)"/></xsl:apply-templates>
</xsl:template>

<xsl:template match="data/dataRow" mode="monthCalendar.day.data.record.Template">
	<xsl:param name="formatedDate"/>
	<xsl:variable name="table" select="ancestor::*[@dataType='table'][1]"/>
<a href="#" class="cita"><span><xsl:attribute name="onclick">openLink('../Templates/request.asp?CatalogName=<xsl:value-of select="$table/@Table_Schema"/>.<xsl:value-of select="$table/@Table_Name"/>&amp;Mode=edit&amp;Filters=<xsl:choose>
	<xsl:when test="string($table/@primaryKey)!=''">[<xsl:value-of select="$table/@primaryKey"/>]=<xsl:value-of select="@primaryValue"/></xsl:when>	
	<xsl:otherwise>[<xsl:value-of select="$table/@identityKey"/>]=<xsl:value-of select="@identity"/></xsl:otherwise>
</xsl:choose>'); return false;</xsl:attribute>
			<xsl:value-of select="*[not(starts-with(@dataType, 'date'))][1]/@text" disable-output-escaping="yes"/><br/>
		</span></a>
</xsl:template>

<xsl:template match="*" mode="monthCalendar.day.data.newRecord.Template">
	<xsl:param name="formatedDate"/>
	<xsl:variable name="table" select="."/>
<a href="#" class="cita nueva"><span onclick="openLink('../Templates/request.asp?CatalogName={$table/@Table_Schema}.{$table/@Table_Name}&amp;Mode=insert&amp;parameters=@%23{$table/fields/*[starts-with(@dataType, 'date')][1]/@Column_Name}=\'{$formatedDate}\''); return false;"><label><xsl:apply-templates select="." mode="monthCalendar.day.data.newRecord.inputHint.Text" /></label></span></a>
</xsl:template>

<xsl:template match="*" mode="monthCalendar.day.data.newRecord.inputHint.Text">
Agregar nuevo evento.
</xsl:template>
<!-- <xsl:template name="monthCalendar.empty" match="*[@controlType='monthCalendar' or @dataType='table' and @controlType='default'][count(data/dataRow)=0]">
	<b class="warning">NO HAY INFORMACIÓN</b>
</xsl:template> -->

</xsl:stylesheet>