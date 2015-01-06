<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns="http://www.w3.org/TR/xhtml1/strict"
	xmlns:px="urn:panax">
  <xsl:strip-space elements="*"/>

<xsl:template name="subGroupTabPanel.private">
	<xsl:param name="groupTabPanel"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'groupTabPanel'"/></xsl:call-template></xsl:param>
	<xsl:apply-templates select=".|following-sibling::*[key('groupTabPanel',concat(generate-id(),'::',$groupTabPanel))][@subGroupTabPanel][count(. | key('subGroupTabPanel', @subGroupTabPanel)[1]) = 1]" mode="formView.subGroupTabPanel.Template">
		<xsl:with-param name="groupTabPanel" select="$groupTabPanel"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template name="portlet.private">
	<xsl:param name="groupTabPanel"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'groupTabPanel'"/></xsl:call-template></xsl:param>
	<xsl:param name="subGroupTabPanel"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'subGroupTabPanel'"/></xsl:call-template></xsl:param>
	<xsl:apply-templates select=".|following-sibling::*[key('groupTabPanel',concat(generate-id(),'::',$groupTabPanel))][key('subGroupTabPanel',concat(generate-id(),'::',$subGroupTabPanel))][@portlet][count(. | key('portlet', @portlet)[1]) = 1]" mode="formView.portlet.Template">
		<xsl:with-param name="groupTabPanel" select="$groupTabPanel"/>
		<xsl:with-param name="subGroupTabPanel" select="$subGroupTabPanel"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template name="tabPanel.private">
	<xsl:param name="groupTabPanel"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'groupTabPanel'"/></xsl:call-template></xsl:param>
	<xsl:param name="subGroupTabPanel"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'subGroupTabPanel'"/></xsl:call-template></xsl:param>
	<xsl:apply-templates select=".|following-sibling::*[key('groupTabPanel',concat(generate-id(),'::',$groupTabPanel))][key('subGroupTabPanel',concat(generate-id(),'::',$subGroupTabPanel))][@tabPanel][count(. | key('tabPanel', @tabPanel)[1]) = 1]" mode="formView.tabPanel.Template">
		<xsl:with-param name="groupTabPanel" select="$groupTabPanel"/>
		<xsl:with-param name="subGroupTabPanel" select="$subGroupTabPanel"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template name="fieldSetGroup.private">
	<xsl:param name="groupTabPanel"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'groupTabPanel'"/></xsl:call-template></xsl:param>
	<xsl:param name="subGroupTabPanel"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'subGroupTabPanel'"/></xsl:call-template></xsl:param>
	<xsl:param name="tabPanel"><xsl:call-template name="getGroupName"><xsl:with-param name="key" select="'tabPanel'"/></xsl:call-template></xsl:param>
	<xsl:apply-templates select=".|following-sibling::*[key('groupTabPanel',concat(generate-id(),'::',$groupTabPanel))][key('subGroupTabPanel',concat(generate-id(),'::',$subGroupTabPanel))][@fieldSet][count(. | key('fieldSet', @fieldSet)[1]) = 1]" mode="formView.fieldSetGroup.Template">
		<xsl:with-param name="groupTabPanel" select="$groupTabPanel"/>
		<xsl:with-param name="subGroupTabPanel" select="$subGroupTabPanel"/>
		<xsl:with-param name="tabPanel" select="$tabPanel"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="*[@dataType='table'][@controlType='formView' or @controlType='detailsView']">
	<xsl:apply-templates select="." mode="formView.Template"/>
</xsl:template>
  
<xsl:template match="*[@dataType='table']" mode="formView.Template">
	<xsl:apply-templates select="." mode="formView.table.Template" />	
</xsl:template>

<xsl:template match="*[@dataType='table']" mode="formView.table.Wrapper">
<!--     <xsl:choose>
<xsl:when test="current()[string(@mode)!='filters']/px:data/px:dataRow/*[@controlType='tab']"> -->
		<xsl:apply-templates select="." mode="formView.table.tabManager.Template" />
<!--     </xsl:when>
    <xsl:otherwise>
    	<xsl:apply-templates select="." mode="formView.table.Default" />
    </xsl:otherwise>
</xsl:choose> -->
</xsl:template>


<xsl:attribute-set name="formView.dataTable.Default" use-attribute-sets="dataTable.Default">
</xsl:attribute-set>
  
<xsl:template match="*[@dataType='table']" mode="formView.table.Default">
    <xsl:param name="mode">
      <xsl:choose>
        <xsl:when test="ancestor-or-self::*[@mode='readonly'][1]">readonly</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="ancestor-or-self::*[@mode!='inherit'][1]/@mode"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>
	
	<xsl:element name="table" use-attribute-sets="formView.dataTable.Default">
		<xsl:attribute name="class">dataTable formView Table_<xsl:value-of select="@Table_Name"/></xsl:attribute>
			<xsl:apply-templates select="." mode="formView.table.thead.Template"/>
			<xsl:apply-templates select="." mode="formView.table.body.Template" />
			<xsl:apply-templates select="." mode="formView.table.tfoot.Template"/>
	</xsl:element>
</xsl:template>

<xsl:template match="*[@dataType='table']" mode="formView.table.body.Template">
	<tbody id="db_{@Table_Name}_dataRow_{generate-id(px:data/px:dataRow[1])}">
     <xsl:attribute name="db_identity_value"><xsl:choose><xsl:when test="px:data/px:dataRow/@identity!=''"><xsl:value-of select="px:data/px:dataRow/@identity"/></xsl:when><xsl:otherwise>NULL</xsl:otherwise></xsl:choose></xsl:attribute>
	<xsl:attribute name="db_primary_value"><xsl:choose><xsl:when test="px:data/px:dataRow/@primaryValue!=''"><xsl:value-of select="px:data/px:dataRow/@primaryValue"/></xsl:when><xsl:otherwise>NULL</xsl:otherwise></xsl:choose></xsl:attribute>
     <xsl:attribute name="class">
       Group_<xsl:value-of select="*[@groupByColumn]/@value"/>
     </xsl:attribute>
	<xsl:apply-templates select="px:data/px:dataRow" mode="formView.table.dataRow.Wrapper" />
	</tbody>
</xsl:template>

<xsl:template match="*[@dataType='table']/px:data/px:dataRow" mode="formView.table.dataRow.Wrapper">
	<tr><td>
		<table>
		<xsl:apply-templates select="." mode="formView.table.dataRow.head.Template"/>
		<xsl:apply-templates select="." mode="formView.table.dataRow.body.Template"/>
		<xsl:apply-templates select="." mode="formView.table.dataRow.foot.Template"/>
		</table>
	</td></tr>
</xsl:template>

<xsl:template match="*[@dataType='table']/px:data/px:dataRow" mode="formView.table.dataRow.body.Template">
	<tbody id="db_{@Table_Name}_dataRow_{generate-id(.)}">
     <xsl:attribute name="db_identity_value"><xsl:choose><xsl:when test="@identity!=''"><xsl:value-of select="@identity"/></xsl:when><xsl:otherwise>NULL</xsl:otherwise></xsl:choose></xsl:attribute>
	<xsl:attribute name="db_primary_value"><xsl:choose><xsl:when test="@primaryValue!=''"><xsl:value-of select="@primaryValue"/></xsl:when><xsl:otherwise>NULL</xsl:otherwise></xsl:choose></xsl:attribute>
    <xsl:attribute name="class">
       Group_<xsl:value-of select="*[@groupByColumn]/@value"/>
    </xsl:attribute>
	
	<xsl:apply-templates select="." mode="formView.hiddenFields"><xsl:with-param name="rowType" select="'dataRow'"/></xsl:apply-templates>
	<xsl:apply-templates select="*[1]" mode="fieldSetGroup" />
	</tbody>
</xsl:template>

<xsl:template match="*[@dataType='table']/px:data/px:dataRow/*/@fieldSet" mode="fieldSetGroup.legend.text"> 
<xsl:choose>
	<xsl:when test="."><xsl:value-of select="."/></xsl:when>	
	<xsl:otherwise>Generales</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 
<xsl:template match="*[@dataType='table']/px:data/px:dataRow/*|*[@dataType='table']/px:fields/*" mode="fieldSetGroup">
<xsl:variable name="contiguousFields"><xsl:call-template name="formView.fieldSetGroup"><xsl:with-param name="referenceNode" select="."/></xsl:call-template></xsl:variable>/*contiguousFields (<xsl:value-of select="@fieldSet"/>): <xsl:value-of select="count(msxsl:node-set($contiguousFields)/*)"/>*/
	<xsl:apply-templates select="." mode="fieldSetGroup.Template"><xsl:with-param name="contiguousFields" select="$contiguousFields"/></xsl:apply-templates>
	<xsl:apply-templates select="following-sibling::*[key('visibleFields',@fieldId)][count(msxsl:node-set($contiguousFields)/*)]" mode="fieldSetGroup" />
</xsl:template> -->

<xsl:template name="formView.fieldSetGroup">
	<xsl:param name="referenceNode" select="." />
	<xsl:param name="position" select="'first'" />
	<xsl:choose>
		<xsl:when test="$position='first'">
			<xsl:variable name="contiguousFields"><xsl:apply-templates select="$referenceNode" mode="contiguousFields"><xsl:with-param name="referenceAttribute" select="'fieldSet'"/></xsl:apply-templates></xsl:variable>
			<xsl:copy-of select="$referenceNode|$referenceNode/following-sibling::*[key('visibleFields',@fieldId)][position()&lt;$contiguousFields]" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="contiguousFields"><xsl:apply-templates select="$referenceNode" mode="contiguousFields"><xsl:with-param name="referenceAttribute" select="'fieldSet'"/><xsl:with-param name="direction" select="'desc'"/></xsl:apply-templates></xsl:variable>
			<xsl:copy-of select="$referenceNode|$referenceNode/preceding-sibling::*[key('visibleFields',@fieldId)][position()&lt;$contiguousFields]" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>



<xsl:template name="formView.empty" match="*[@controlType='formView'][count(px:data/px:dataRow)=0]">
    <b class="warning">NO SE PUDO RECUPERAR LA INFORMACIÓN, EL REGISTRO PUDO HABER SIDO BORRADO O ALGÚN FILTRO ESTÁ IMPIDIENDO RECUPERAR EL REGISTRO. SI EL PROBLEMA PERSISTE CONSULTE AL ADMINISTRADOR DEL SISTEMA.</b>
  </xsl:template>

  <xsl:template name="formView.deny" match="*[@controlType='formView'][@mode='deny'][count(px:data/px:dataRow)=0]">
    <b class="warning">USTED NO TIENE PERMISOS PARA VER ESTE MÓDULO, CONSULTE CON SU ADMINISTRADOR DEL SISTEMA</b>
  </xsl:template>

</xsl:stylesheet>