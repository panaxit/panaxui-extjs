<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt">
<xsl:strip-space elements="*"/>

<!-- gridView.table >-->
<xsl:template match="*[@controlType='gridView' or @dataType='table' and @controlType='default']">
	<xsl:apply-templates select="." mode="gridView.Wrapper"/>
</xsl:template>

<!-- <xsl:attribute-set name="gridView.datatable">
	<xsl:attribute name="class"><xsl:value-of select="'dataTable gridView Table_{@Table_Name}'"/></xsl:attribute>
	<xsl:attribute name="mode"><xsl:value-of select="@mode"/></xsl:attribute>
	<xsl:attribute name="id"><xsl:value-of select="@Table_Name"/>_<xsl:value-of select="generate-id(.)"/></xsl:attribute>
	<xsl:attribute name="db_table_name"><xsl:value-of select="@Table_Schema"/>.<xsl:value-of select="@Table_Name"/></xsl:attribute>
	<xsl:attribute name="db_primary_key"><xsl:value-of select="@primaryKey"/></xsl:attribute>
</xsl:attribute-set> -->

<xsl:template match="*[@dataType='table']" mode="gridView.Wrapper">
	<xsl:apply-templates select="." mode="gridView.table.Template"/>
</xsl:template>

<xsl:template match="*[@dataType='table']" mode="gridView.table.Wrapper">
	<xsl:apply-templates select="." mode="gridView.table.thead.Template" />
	<xsl:apply-templates select="." mode="gridView.table.tbody.Wrapper" />
	<xsl:apply-templates select="." mode="gridView.table.tfoot.Template" />
</xsl:template>

<xsl:template match="*[@dataType='table']" mode="gridView.table.thead.Wrapper">
	<xsl:apply-templates select="." mode="gridView.table.thead.columnsHeader.Template"/>
</xsl:template>

<xsl:template match="*[@dataType='table']" mode="gridView.table.tbody.Wrapper">
	<xsl:choose>
 		<xsl:when test="data/dataRow[*/@groupByColumn]">
			<xsl:apply-templates select="data/dataRow[*/@groupByColumn][not(*/@value=preceding-sibling::*[1]/*[@groupByColumn='true']/@value)]" mode="gridView.table.tbody.columnGroup.Template" />
		</xsl:when>
		<xsl:when test="data/dataRow[@headerText]">
			<xsl:apply-templates select="data/dataRow[@headerText][not(@headerText=preceding-sibling::*[1]/@headerText)]" mode="gridView.table.tbody.groupByHeader.Template"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="." mode="gridView.table.tbody.tableGroup.Template"><xsl:with-param name="tableGroup" select="data/dataRow"/></xsl:apply-templates>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="*[@dataType='table']" mode="gridView.table.tfoot.Wrapper">
	<xsl:apply-templates select="." mode="gridView.table.tfoot.footer.Template" />
</xsl:template>

<xsl:template match="*[@dataType='table']" mode="gridView.table.tfoot.footer.Wrapper">
	<xsl:variable name="rowType">footerRow</xsl:variable>
	<xsl:apply-templates select="data/dataRow[1]" mode="gridView.table.row.Wrapper"><xsl:with-param name="rowType" select="$rowType"/></xsl:apply-templates>
</xsl:template>

<xsl:template match="*[@dataType='table']/data/dataRow/*" mode="gridView.table.tfoot.footer.fields.Wrapper">
	<xsl:apply-templates select="." mode="gridView.table.tfoot.footer.fields.field.Template" />
</xsl:template>

<!--< gridView.table -->

<!-- gridView.table.tableGroup >-->
	<!-- gridView.table.tableGroup.Header -->
		<xsl:template match="data/dataRow" mode="gridView.table.tableGroup.Header">
			<xsl:param name="tableGroup"/>
			<xsl:apply-templates select="." mode="gridView.table.tableGroup.Header.Template"><xsl:with-param name="tableGroup" select="$tableGroup"/></xsl:apply-templates>
		</xsl:template>
	<!-- gridView.table.tableGroup.Header -->

<xsl:template match="*[@dataType='table'][@controlType='gridView']" mode="gridView.table.thead.header.Wrapper">
	<xsl:variable name="rowType">headerRow</xsl:variable>
	<xsl:apply-templates select="fields[1]" mode="gridView.table.row.Wrapper"><xsl:with-param name="rowType" select="$rowType"/></xsl:apply-templates>
</xsl:template>

<xsl:template match="data/dataRow" mode="gridView.table.tableGroup.Header.Wrapper">
	<xsl:param name="tableGroup"/>
	<xsl:variable name="rowType">headerRow</xsl:variable>
	<xsl:apply-templates select="*[1]" mode="gridView.table.tableGroup.Header.rowNumber.Template"><xsl:with-param name="tableGroup" select="$tableGroup"/></xsl:apply-templates>
	<xsl:apply-templates select="*[1]" mode="gridView.table.tableGroup.Header.commands.Template"><xsl:with-param name="tableGroup" select="$tableGroup"/></xsl:apply-templates>
	<xsl:apply-templates select="*[1]" mode="gridView.table.tableGroup.Header.fields.Template"><xsl:with-param name="tableGroup" select="$tableGroup"/></xsl:apply-templates>
</xsl:template>

<xsl:template match="*[@dataType='table'][@controlType='gridView']/data/dataRow/*" mode="gridView.table.tableGroup.Header.fields.Content.Default">
	<xsl:param name="tableGroup"/>
	<xsl:choose>
		<xsl:when test="../@headerText"><xsl:value-of select="../@headerText"/></xsl:when>	
		<xsl:when test="$tableGroup/*/@groupByColumn"><xsl:value-of select="$tableGroup/*[@groupByColumn='true']/@text"/></xsl:when>
		<xsl:otherwise><xsl:value-of select="$nbsp"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="*[@dataType='table'][@controlType='gridView']/data/dataRow/*" mode="gridView.table.tableGroup.Header.fields.Content.Template">
	<xsl:param name="tableGroup"/>
	<xsl:apply-templates select="." mode="gridView.table.tableGroup.Header.fields.Content.Default"><xsl:with-param name="tableGroup" select="$tableGroup"/></xsl:apply-templates>
</xsl:template>
 
<xsl:template match="*[@dataType='table'][@controlType='gridView']/data/dataRow/*" mode="gridView.table.tableGroup.Header.fields.Wrapper">
	<xsl:param name="tableGroup"/>
	<xsl:apply-templates select="." mode="gridView.table.tableGroup.Header.fields.Content.Template"><xsl:with-param name="tableGroup" select="$tableGroup"/></xsl:apply-templates>
</xsl:template>

	<!-- gridView.table.tableGroup.Footer -->
	<xsl:template match="data/dataRow" mode="gridView.table.tableGroup.Footer">
		<xsl:param name="tableGroup"/>
		<xsl:apply-templates select="." mode="gridView.table.tableGroup.Footer.Template"><xsl:with-param name="tableGroup" select="$tableGroup"/></xsl:apply-templates>
	</xsl:template>
	<xsl:template match="data/dataRow" mode="gridView.table.tableGroup.Footer.Template">
		<xsl:param name="tableGroup"/>
		<xsl:apply-templates select="." mode="gridView.table.tableGroup.Footer.Default"><xsl:with-param name="tableGroup" select="$tableGroup"/></xsl:apply-templates>
	</xsl:template>

	<xsl:template match="data/dataRow" mode="gridView.table.tableGroup.Footer.Wrapper">
		<xsl:param name="tableGroup"/>
		<xsl:apply-templates select="." mode="gridView.table.tableGroup.Footer.Content.Template"><xsl:with-param name="tableGroup" select="$tableGroup"/></xsl:apply-templates>
	</xsl:template>
	<xsl:template match="data/dataRow" mode="gridView.table.tableGroup.Footer.Content.Template">
		<xsl:param name="tableGroup"/>
		<xsl:apply-templates select="." mode="gridView.table.tableGroup.Footer.Content.Default"><xsl:with-param name="tableGroup" select="$tableGroup"/></xsl:apply-templates>
	</xsl:template>
	<!-- gridView.table.tableGroup.Footer -->

<!--< gridView.table.tableGroup -->

<!-- gridView.table.thead >-->
<xsl:template match="*[@dataType='table'][@controlType='gridView']" mode="gridView.table.thead">
	<xsl:apply-templates select="." mode="gridView.table.thead.Template"/>
</xsl:template>

<!-- <xsl:template match="*[@dataType='table'][@controlType='gridView']" mode="gridView.table.thead.header">
	<xsl:apply-templates select="." mode="gridView.table.thead.columnsHeader.Template" />
	<xsl:if test="not(@template) and not(ancestor-or-self::*[@showTableHeaders!='inherit'][1]/@showTableHeaders='false')">
		<xsl:apply-templates select="fields" mode="gridView.row">
			<xsl:with-param name="rowType">headerRow</xsl:with-param>
		</xsl:apply-templates>
	</xsl:if>
</xsl:template> -->

<xsl:template match="*[@dataType='table'][@controlType='gridView']" mode="gridView.table.thead.header.fields">
	<xsl:variable name="rowType">tableHeader</xsl:variable>
	<xsl:apply-templates select="." mode="gridView.rowNumber"><xsl:with-param name="rowType" select="$rowType"/></xsl:apply-templates>
	<xsl:apply-templates select="." mode="gridView.commandButtons"><xsl:with-param name="rowType" select="$rowType"/></xsl:apply-templates>
	<xsl:apply-templates select="*[1]" mode="gridView.table.thead.header.fields.Template" />
</xsl:template>

<xsl:template match="*[not(preceding-sibling::*)]" mode="gridView.table.thead.header.fields.Wrapper">
<xsl:value-of select="@headerText"/>
</xsl:template>
<!--< gridView.table.thead -->


<xsl:template name="gridView.fieldSet.header">
<xsl:param name="fields" select="*[@mode!='hidden' and not(@controlType='tab') and not(@Column_Name=ancestor-or-self::*[@dataType='foreignTable'][1]/@foreignReference)]"/>
<xsl:if test="//@fieldSet"><!--  and ancestor-or-self::*[dataType='table'][1]/@showFieldSetHeader='true' -->
	<xsl:variable name="createFieldSetHeader"><xsl:for-each select="$fields[not(preceding-sibling::*[1][string(@fieldSet)!=string(current()/@fieldSet)])]"><xsl:if test="not(../preceding-sibling::*[1]/*[name(.)=name(current())][string(@fieldSet)=string(current()/@fieldSet)])"><xsl:value-of select="name(../preceding-sibling::*[1]/*[name(.)=name(current()) and string(@fieldSet)=string(current()/@fieldSet)])"/>1</xsl:if></xsl:for-each></xsl:variable>
	<xsl:if test="number($createFieldSetHeader)&gt;0">
		<xsl:apply-templates mode="gridView.fieldSet.headerRow" select="$fields[position()=1 or not(@fieldSet=preceding-sibling::*[@mode!='hidden' and not(@controlType='tab') and not(@Column_Name=ancestor-or-self::*[@dataType='foreignTable'][1]/@foreignReference)][1]/@fieldSet or string(@fieldSet)=string(preceding-sibling::*[@mode!='hidden' and not(@controlType='tab') and not(@Column_Name=ancestor-or-self::*[@dataType='foreignTable'][1]/@foreignReference)][1]/@fieldSet))]"/>

		<!-- ENCABEZADO DE CAMPO POR FIELDSET, SE PUEDE DESCOMENTAR <xsl:call-template name="gridView.fieldSet.fieldHeaderRow"><xsl:with-param name="context" select="$fields"/></xsl:call-template> -->
	</xsl:if>
</xsl:if>
</xsl:template>

<!-- - Header -->
<xsl:template match="*" mode="gridView.fieldSet.headerRow">
	<xsl:apply-templates select="." mode="gridView.fieldSet.headerRow.Template" />
</xsl:template>

<xsl:template match="*" mode="gridView.fieldSet.headerRow.Wrapper">
	<xsl:apply-templates select="." mode="gridView.rowNumber"><xsl:with-param name="rowType">headerRow</xsl:with-param></xsl:apply-templates><xsl:apply-templates select="." mode="gridView.fieldSet.headerRow.header.Template"/>
</xsl:template>

<xsl:template match="data/dataRow/*" mode="gridView.fieldSet.headerRow.header.Wrapper">
	<xsl:apply-templates select="." mode="gridView.fieldSet.headerRow.header.text.Template" />
</xsl:template>


<xsl:template name="gridView.fieldSet.headerText"></xsl:template>

<xsl:template match="fields|data/dataRow" mode="gridView.table.tbody.row.Wrapper">
	<xsl:param name="rowType" select="'dataRow'" />
	<xsl:apply-templates select="." mode="gridView.table.tbody.row.attributes" />
	<xsl:apply-templates select="." mode="gridView.table.row.Wrapper"><xsl:with-param name="rowType" select="$rowType"/></xsl:apply-templates>
</xsl:template>

<xsl:template match="data/dataRow|fields" mode="gridView.table.row.Wrapper">
<xsl:param name="rowType" />
	<xsl:apply-templates select="." mode="gridView.rowNumber"><xsl:with-param name="rowType" select="$rowType"/></xsl:apply-templates>
	<xsl:apply-templates select="." mode="gridView.commandButtons"><xsl:with-param name="rowType" select="$rowType"/></xsl:apply-templates>
	<xsl:apply-templates select="." mode="gridView.hiddenFields"><xsl:with-param name="rowType" select="$rowType"/></xsl:apply-templates>
    <xsl:apply-templates select="*[not(@autoGenerateField='false')]" mode="gridView.dataFields"><xsl:with-param name="rowType" select="$rowType"/></xsl:apply-templates>
</xsl:template>

<xsl:template match="*" mode="gridView.rowNumber">
<xsl:param name="rowType" select="'dataRow'" />
<xsl:if test="string(ancestor-or-self::*[@showRowNumbers!='inherit'][1]/@showRowNumbers)!='false'">
	<xsl:apply-templates select="." mode="gridView.rowNumber.Template"><xsl:with-param name="rowType" select="$rowType"/></xsl:apply-templates>
</xsl:if>
</xsl:template>

<xsl:template match="*" mode="gridView.rowNumber.Wrapper">
<xsl:param name="rowType" />
	<xsl:apply-templates select="." mode="gridView.rowNumber.text.Template"><xsl:with-param name="rowType" select="$rowType"/></xsl:apply-templates>
</xsl:template>

<xsl:template match="*" mode="gridView.commandButtons">
<xsl:param name="rowType" select="'dataRow'" />
<xsl:param name="disableInsert"><xsl:choose>
	<xsl:when test="number(ancestor-or-self::*[@dataType='table'][1]/@disableInsert)=1 or ancestor-or-self::*[@dataType='table'][1]/@disableInsert='true' or ancestor-or-self::*[@dataType='table'][2][@controlType='gridView']">1</xsl:when>	
	<xsl:when test="number(ancestor-or-self::*[@dataType='table'][1]/@supportsInsert)=1">0</xsl:when>	
	<xsl:otherwise>1</xsl:otherwise>
</xsl:choose></xsl:param>
<xsl:param name="disableEdit"><xsl:choose>
	<xsl:when test="number(ancestor-or-self::*[@dataType='table'][1]/@disableEdit)=1 or ancestor-or-self::*[@dataType='table'][1]/@disableEdit='true'">1</xsl:when>	
	<xsl:when test="number(ancestor-or-self::*[@dataType='table'][1]/@supportsUpdate)=1 and not(ancestor-or-self::*[name(.)='dataRow' and @disableEdit!='inherit' or @dataType='table'][1]/@disableEdit='true') and not(../ancestor-or-self::*[@dataType='table'][2])">0</xsl:when>	
	<xsl:otherwise>1</xsl:otherwise>
</xsl:choose></xsl:param>
<xsl:param name="disableDetails"><xsl:choose>
	<xsl:when test="number(ancestor-or-self::*[@dataType='table'][1]/@disableDetails)=1 or ancestor-or-self::*[@dataType='table'][1]/@disableDetails='true'">1</xsl:when>	
	<xsl:when test="$disableEdit=0 or number(ancestor-or-self::*[@dataType='table'][1]/@supportsDetails)=1">0</xsl:when>	
	<xsl:otherwise>1</xsl:otherwise>
</xsl:choose></xsl:param>
<xsl:param name="disableDelete"><xsl:choose>
	<xsl:when test="number(ancestor-or-self::*[@dataType='table'][1]/@disableDelete)=1 or ancestor-or-self::*[@dataType='table'][1]/@disableDelete='true'">1</xsl:when>	
	<xsl:when test="number(ancestor-or-self::*[@dataType='table'][1]/@supportsDelete)=1 and not(ancestor-or-self::*[name(.)='dataRow' and @disableDelete!='inherit' or @dataType='table'][1]/@disableDelete='true')">0</xsl:when>	
	<xsl:otherwise>1</xsl:otherwise>
</xsl:choose></xsl:param>
<!-- <xsl:if test="not(ancestor-or-self::*[@dataType='table'][2][@controlType='gridView']) and (number($disableDetails)=0 or number($disableDelete)=0 or number($disableInsert)=0)"> -->
	<xsl:choose>
		<xsl:when test="$rowType='footerRow'">
			<xsl:apply-templates select="." mode="gridView.table.footer.commandButtons.Template" />
		</xsl:when>	
		<xsl:when test="$rowType='headerRow'">
			<xsl:apply-templates select="." mode="gridView.table.header.commandButtons.Template"><xsl:with-param name="disableInsert" select="$disableInsert"/><xsl:with-param name="disableDetails" select="$disableDetails"/><xsl:with-param name="disableDelete" select="$disableDelete"/></xsl:apply-templates>
		</xsl:when>	
		<xsl:otherwise>
			<xsl:apply-templates select="." mode="gridView.table.body.commandButtons.Template"><xsl:with-param name="disableInsert" select="$disableInsert"/><xsl:with-param name="disableDetails" select="$disableDetails"/><xsl:with-param name="disableDelete" select="$disableDelete"/></xsl:apply-templates>
		</xsl:otherwise>
	</xsl:choose>
<!-- </xsl:if> -->
</xsl:template>

<xsl:template match="fields|data/dataRow/*" mode="fieldHeaderText">
	<xsl:choose>
		<xsl:when test="@headerText"><xsl:value-of select="@headerText"/></xsl:when>
		<xsl:otherwise><xsl:value-of select="name(.)"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- <xsl:template name="dataField">
	<xsl:param name="context" select="." />
	<xsl:param name="rowType" select="'dataRow'" />
	<xsl:choose>
		<xsl:when test="$rowType='headerRow'">
			<xsl:call-template name="headerText">
				<xsl:with-param name="dataField">
					<xsl:value-of select="$context"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="$context" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template> -->

<xsl:template match="*[not(@Column_Name=ancestor::*[@dataType='table'][1]/@identityKey) and not(@mode='hidden' or @controlType='hiddenField') and not(@controlType='tab') and not(@Column_Name=ancestor-or-self::*[@dataType='foreignTable' or @foreignReference][1]/@foreignReference)]" mode="gridView.dataFields">
	<xsl:param name="rowType" select="'dataRow'" />
<!--   <xsl:for-each select="$dataFields[not(@mode='hidden' or @controlType='hiddenField')]"> -->
<!-- 		<xsl:variable name="current" select="."></xsl:variable> -->
		<xsl:choose>
			<xsl:when test="$rowType='headerRow'">
				<xsl:apply-templates select="." mode="gridView.table.thead.header.fields.Template" />
			</xsl:when>
			<xsl:when test="$rowType='footerRow'">
				<xsl:apply-templates select="." mode="gridView.table.tfoot.footer.fields.Template" />
			</xsl:when>
			<xsl:when test="string(@rowSpanBy)!=''">
				<xsl:if test="not(../preceding-sibling::*[1]/*[name(.)=name(current())][string(@rowSpanBy)=string(current()/@rowSpanBy)])">
					<xsl:variable name="referenceNode" select="." />
					<xsl:variable name="rowspanGroup"><xsl:call-template name="gridView.rowSpanGroup"/></xsl:variable>
					<xsl:variable name="rowspan" select="count(msxsl:node-set($rowspanGroup)/*)" />

					<!-- <xsl:variable name="rowspan"><xsl:call-template name="gridView.rowSpan"/></xsl:variable> -->
					<!-- <xsl:variable name="currentGlobalPosition" select="count(../preceding-sibling::*)"/>
				<xsl:variable name="rowspan" select="count((.|../following-sibling::*[count(preceding-sibling::*[position()&lt;=last()-number($currentGlobalPosition)][*[name(.)=name(current())][string(@rowSpanBy)!=string(current()/@rowSpanBy)]])=0])[*[name(.)=name(current())]])"/> -->
					<!-- <xsl:variable name="rowspanGroup"><xsl:call-template name="gridView.rowSpanGroup"/></xsl:variable> -->
					<td rowspan="{$rowspan}" class="FieldContainer_{@Column_Name}">
						<!-- <xsl:attribute name="title"><xsl:value-of select="*[@text]/@text"/></xsl:attribute> -->
						<xsl:apply-templates select="." mode="dataField" />
					</td>
				</xsl:if>
			</xsl:when>
			<xsl:when test="@autoRowSpan='true'">
				<xsl:variable name="rowspan">
					<xsl:call-template name="autoRowspan">
						<xsl:with-param name="referenceNodeName" select="@autoSpanReferenceField"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="$rowspan!=0">
				<td class="FieldContainer_{@Column_Name}">
 					<xsl:attribute name="rowspan">
						<xsl:value-of select="$rowspan" />
					</xsl:attribute>
					<xsl:apply-templates select="." mode="dataField" />
				</td>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="gridView.table.tbody.row.fields.Template" />
			</xsl:otherwise>
		</xsl:choose>
<!-- 	</xsl:for-each> -->
</xsl:template>

<xsl:template name="autoRowspan">
	<xsl:param name="count" select="1" />
	<xsl:param name="referenceNodeName" select="name(.)" />
	
	<xsl:param name="lastReferenceNode" select="((../preceding-sibling::*/*[name(.)=$referenceNodeName])[$referenceNodeName] | (../preceding-sibling::*/*[name(.)=name(current())])[not($referenceNodeName)])[last()]" />
	<xsl:variable name="lastNode" 		select="(../preceding-sibling::*/*[name(.)=name(current())])[last()]" />
	<xsl:variable name="nextNodes" 		select="(../following-sibling::*/*[name(.)=name(current())])" />
	<xsl:variable name="referenceNodes" select="((../following-sibling::* | ..)/*[name(.)=$referenceNodeName])[$referenceNodeName] | ((../following-sibling::* | ..)/*[name(.)=name(current())])[not($referenceNodeName)]" />
<!-- 	<xsl:value-of select="$lastNode/@value" /> vs <xsl:value-of select="$currentNode/@value" /> vs <xsl:value-of select="$currentNode/@value" /> : <br /><xsl:if test="$referenceNodes"><xsl:value-of select="$lastReferenceNode/@value" /> - <xsl:value-of select="$referenceNodes[1]/@value" /> - <xsl:value-of select="$referenceNodes[$count]/@value" /> <br /></xsl:if>-->	
 	<xsl:choose>
		<xsl:when test="not((current()/@value=$lastNode/@value or not(current()/@value) and not($lastNode/@value)) and $referenceNodes[1]/@value=$lastReferenceNode/@value)">
			<xsl:choose>
				<xsl:when test="(current()/@value=$nextNodes[$count]/@value or not(current()/@value) and not($nextNodes[$count]/@value)) and $referenceNodes[1]/@value=$referenceNodes[$count+1]/@value">
		  		<xsl:call-template name="autoRowspan">
			    	<xsl:with-param name="count" select="$count + 1"/>
			    	<xsl:with-param name="referenceNodeName" select="$referenceNodeName"/>
			    </xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$count" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="0" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="dataRow" mode="contiguousSiblings">
	<xsl:param name="referenceNode" select="current()" />
	<xsl:param name="referenceAttribute" />
	<xsl:param name="direction" select="'ascending'"/>
	<xsl:choose>
	<xsl:when test="$direction='ascending'"><xsl:variable name="nextDifferentNode" select="$referenceNode/following-sibling::*[string(@*[name(.)=$referenceAttribute])!=string($referenceNode/@*[name(.)=$referenceAttribute])][1]"/>
	<xsl:value-of select="count($referenceNode|$referenceNode/following-sibling::*)-count($nextDifferentNode|$nextDifferentNode/following-sibling::*)"/></xsl:when>	
	<xsl:otherwise><xsl:variable name="nextDifferentNode" select="$referenceNode/preceding-sibling::*[string(@*[name(.)=$referenceAttribute])!=string($referenceNode/@*[name(.)=$referenceAttribute])][1]"/>
	<xsl:value-of select="count($referenceNode|$referenceNode/preceding-sibling::*)-count($nextDifferentNode|$nextDifferentNode/preceding-sibling::*)"/></xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="dataRow/*" mode="contiguousSiblings">
	<xsl:param name="referenceNode" select="current()" />
	<xsl:param name="referenceAttribute" />
	<xsl:param name="direction" select="'ascending'"/>
	<xsl:choose>
	<xsl:when test="$direction='ascending'"><xsl:variable name="nextDifferentNode" select="$referenceNode/../following-sibling::*[string(*[name(.)=name($referenceNode)]/@*[name(.)=$referenceAttribute])!=string($referenceNode/@*[name(.)=$referenceAttribute])][1]"/>
	<xsl:value-of select="count($referenceNode/..|$referenceNode/../following-sibling::*)-count($nextDifferentNode|$nextDifferentNode/following-sibling::*)"/></xsl:when>	
	<xsl:otherwise><xsl:variable name="nextDifferentNode" select="$referenceNode/../preceding-sibling::*[string(*[name(.)=name($referenceNode)]/@*[name(.)=$referenceAttribute])!=string($referenceNode/@*[name(.)=$referenceAttribute])][1]"/>
	<xsl:value-of select="count($referenceNode/..|$referenceNode/../preceding-sibling::*)-count($nextDifferentNode|$nextDifferentNode/preceding-sibling::*)"/></xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="dataRow" mode="gridView.tableGroup">
	<xsl:param name="referenceNode" select="current()" />
	<xsl:param name="position" select="'first'" />
	<xsl:choose>
		<xsl:when test="$position='first'">
			<xsl:variable name="contiguousSiblings"><xsl:apply-templates select="$referenceNode" mode="contiguousSiblings"><xsl:with-param name="referenceAttribute" select="'headerText'"/></xsl:apply-templates></xsl:variable>
			<xsl:copy-of select="$referenceNode|$referenceNode/following-sibling::*[position()&lt;$contiguousSiblings]" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="contiguousSiblings"><xsl:apply-templates select="$referenceNode" mode="contiguousSiblings"><xsl:with-param name="referenceAttribute" select="'headerText'"/><xsl:with-param name="direction" select="'desc'"/></xsl:apply-templates></xsl:variable>
			<xsl:copy-of select="$referenceNode|$referenceNode/preceding-sibling::*[position()&lt;$contiguousSiblings]" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="dataRow/*" mode="gridView.tableGroup">
	<xsl:param name="referenceNode" select="current()" />
	<xsl:param name="position" select="'first'" />
	<xsl:choose>
		<xsl:when test="$position='first'">
			<xsl:variable name="contiguousSiblings"><xsl:apply-templates select="$referenceNode" mode="contiguousSiblings"><xsl:with-param name="referenceAttribute" select="'value'"/></xsl:apply-templates></xsl:variable>
			<xsl:copy-of select="$referenceNode/..|$referenceNode/../following-sibling::*[position()&lt;$contiguousSiblings]" />
 			<!-- <xsl:variable name="nextNodesCount" select="count(../preceding-sibling::*)" />
			<xsl:copy-of select="..|../following-sibling::*[count((self::node()|preceding-sibling::*[position()&lt;last()-$nextNodesCount])[string(*[name(.)=name($referenceNode)]/@rowSpanBy)!=string($referenceNode/@rowSpanBy)])=0]" /> --> 
		</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="contiguousSiblings"><xsl:apply-templates select="$referenceNode" mode="contiguousSiblings"><xsl:with-param name="referenceAttribute" select="'value'"/><xsl:with-param name="direction" select="'desc'"/></xsl:apply-templates></xsl:variable>
			<xsl:copy-of select="$referenceNode/..|$referenceNode/../preceding-sibling::*[position()&lt;$contiguousSiblings]" />
<!-- 			<xsl:variable name="nextNodesCount" select="count(../following-sibling::*)" />
			<xsl:copy-of select="..|../preceding-sibling::*[count((self::node()|following-sibling::*[position()&lt;last()-$nextNodesCount])[string(*[name(.)=name($referenceNode)]/@rowSpanBy)!=string($referenceNode/@rowSpanBy)])=0]" /> -->
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="gridView.fieldSetGroup">
	<xsl:param name="referenceNode" select="." />
	<xsl:param name="position" select="'first'" />
	<xsl:choose>
		<xsl:when test="$position='first'">
			<xsl:variable name="contiguousSiblings"><xsl:apply-templates select="$referenceNode" mode="contiguousSiblings"><xsl:with-param name="referenceAttribute" select="'fieldSet'"/></xsl:apply-templates></xsl:variable>
			<xsl:copy-of select="..|../following-sibling::*[position()&lt;$contiguousSiblings]" />
 			<!-- <xsl:variable name="nextNodesCount" select="count(../preceding-sibling::*)" />
			<xsl:copy-of select="..|../following-sibling::*[count((self::node()|preceding-sibling::*[position()&lt;last()-$nextNodesCount])[string(*[name(.)=name($referenceNode)]/@rowSpanBy)!=string($referenceNode/@rowSpanBy)])=0]" /> --> 
		</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="contiguousSiblings"><xsl:apply-templates select="$referenceNode" mode="contiguousSiblings"><xsl:with-param name="referenceAttribute" select="'fieldSet'"/><xsl:with-param name="direction" select="'desc'"/></xsl:apply-templates></xsl:variable>
			<xsl:copy-of select="..|../preceding-sibling::*[position()&lt;$contiguousSiblings]" />
<!-- 			<xsl:variable name="nextNodesCount" select="count(../following-sibling::*)" />
			<xsl:copy-of select="..|../preceding-sibling::*[count((self::node()|following-sibling::*[position()&lt;last()-$nextNodesCount])[string(*[name(.)=name($referenceNode)]/@rowSpanBy)!=string($referenceNode/@rowSpanBy)])=0]" /> -->
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="gridView.rowSpanGroup">
	<xsl:param name="referenceNode" select="." />
	<xsl:param name="position" select="'first'" />
	<xsl:choose>
		<xsl:when test="$position='first'">
			<xsl:variable name="contiguousSiblings"><xsl:apply-templates select="." mode="contiguousSiblings"><xsl:with-param name="referenceAttribute" select="'rowSpanBy'"/></xsl:apply-templates></xsl:variable>
			<xsl:copy-of select="..|../following-sibling::*[position()&lt;$contiguousSiblings]" />
 			<!-- <xsl:variable name="nextNodesCount" select="count(../preceding-sibling::*)" />
			<xsl:copy-of select="..|../following-sibling::*[count((self::node()|preceding-sibling::*[position()&lt;last()-$nextNodesCount])[string(*[name(.)=name($referenceNode)]/@rowSpanBy)!=string($referenceNode/@rowSpanBy)])=0]" /> --> 
		</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="contiguousSiblings"><xsl:apply-templates select="." mode="contiguousSiblings"><xsl:with-param name="referenceAttribute" select="'rowSpanBy'"/><xsl:with-param name="direction" select="'desc'"/></xsl:apply-templates></xsl:variable>
			<xsl:copy-of select="..|../preceding-sibling::*[position()&lt;$contiguousSiblings]" />
<!-- 			<xsl:variable name="nextNodesCount" select="count(../following-sibling::*)" />
			<xsl:copy-of select="..|../preceding-sibling::*[count((self::node()|following-sibling::*[position()&lt;last()-$nextNodesCount])[string(*[name(.)=name($referenceNode)]/@rowSpanBy)!=string($referenceNode/@rowSpanBy)])=0]" /> -->
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<!-- <xsl:copy-of select="..|../preceding-sibling::*[count(self::node()[string(*[name(.)=name($referenceNode)]/@fieldSet)!=string($referenceNode/@fieldSet)]|following-sibling::*[position()&lt;count(following-sibling::*)-count($nextNodes)][string(*[name(.)=name($referenceNode)]/@fieldSet)!=string($referenceNode/@fieldSet)])=0]" /> -->

<!-- <xsl:template name="gridView.fieldSetGroup">
	<xsl:param name="referenceNode" select="." />
	<xsl:variable name="nextNodes" select="../following-sibling::*" />
	<xsl:variable name="fieldSetGroup" select="..|../preceding-sibling::*[count(self::node()[string(*[name(.)=name($referenceNode)]/@fieldSet)!=string($referenceNode/@fieldSet)]|following-sibling::*[position()&lt;count(following-sibling::*)-count($nextNodes)][string(*[name(.)=name($referenceNode)]/@fieldSet)!=string($referenceNode/@fieldSet)])=0]" />
	<xsl:copy-of select="$fieldSetGroup" />
</xsl:template> -->



<!--<xsl:template name="gridView.empty" match="*[@dataType='table'][count(data/dataRow)=0]">
	<b class="warning">NO HAY INFORMACIÓN</b>
</xsl:template>-->

</xsl:stylesheet>