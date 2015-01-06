<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">
  <xsl:strip-space elements="*"/>

<xsl:template match="*[@dataType='table'][@controlType='detailsView']">
	<xsl:apply-templates select="." mode="detailsView.Template"/>
</xsl:template>
  
<xsl:template match="*[@dataType='table']" mode="detailsView.Template">
	<xsl:apply-templates select="." mode="detailsView.Default" />	
</xsl:template>

<xsl:template match="*[@dataType='table']" mode="detailsView.Default">
	<xsl:choose>
      <xsl:when test="current()[string(@mode)!='filters']/data/dataRow/*[@controlType='tab']">
        <div>
          <xsl:attribute name="catalogName">
            <xsl:value-of select="name(.)"/>
          </xsl:attribute>
          <xsl:attribute name="pageIndex">DEFAULT</xsl:attribute>
          <xsl:attribute name="pageSize">DEFAULT</xsl:attribute>
          <xsl:attribute name="viewMode">DEFAULT</xsl:attribute>
          <xsl:attribute name="mode">DEFAULT</xsl:attribute>
          <ul id="tabs" class="tabSelector" oncontextmenu="return false;">
            <li class="tab selected">
              <xsl:attribute name="tabId">
                <xsl:value-of select="concat(name(.), '_', generate-id(.))"/>
              </xsl:attribute>
              <a href="#">
                <span>
                	<xsl:apply-templates select="." mode="headerText"/>
                </span>
              </a>
            </li>
            <xsl:for-each select="data/dataRow/*[@controlType='tab']">
              <li class="tab" oncontextmenu="this.isUpdated=false;">
                <xsl:attribute name="tabId">
                  <xsl:value-of select="concat('field_', name(.), '_', generate-id(.))"/>
                </xsl:attribute>
                <a href="#">
                  <span>
                    <xsl:apply-templates select="." mode="headerText"/>
                  </span>
                </a>
              </li>
            </xsl:for-each>
          </ul>

          <div class="tabManager" enableFloating="false">
            <!--  ondblclick="document.all('console').innerText=this.outerHTML" onPageChanged="alert('La página ha cambiado')" onPageChanging="alert('La página está cambiando de '+element.prevPageIndex+' a '+element.newPageIndex);" -->
            <div class="tabPanel">
              <!--  onContextMenu="refreshData(this); return false;" -->
              <xsl:attribute name="isUpdated">true</xsl:attribute>
              <xsl:attribute name="tabId">
                <xsl:value-of select="concat(name(.), '_', generate-id(.))"/>
              </xsl:attribute>
              <xsl:apply-templates select="." mode="detailsView.table.Default" />
            </div>
            <xsl:for-each select="data/dataRow/*[@controlType='tab']">
              <div class="tabPanel" style="display:none;" parent_object="db_{ancestor::*[@dataType='table'][1]/@Table_Name}_dataRow_{generate-id(ancestor::dataRow[1])}">
                <xsl:variable name="table" select="ancestor-or-self::*[@dataType='table']"/>
                <xsl:attribute name="fullPath"><xsl:value-of select="$table/@fullPath"/>[<xsl:value-of select="name($table)"/>][<xsl:value-of select="name(.)"/>](<xsl:value-of select="$table/@controlType"/>:<xsl:value-of select="$table/@mode"/>)</xsl:attribute>
                <xsl:attribute name="tabId">
                  <xsl:value-of select="concat('field_', name(.), '_', generate-id(.))"/>
                </xsl:attribute>
                <xsl:attribute name="catalogName">
                  <xsl:value-of select="@foreignSchema"/>.<xsl:value-of select="@foreignTable"/>
                </xsl:attribute>
                <xsl:attribute name="pageIndex">DEFAULT</xsl:attribute>
                <xsl:attribute name="pageSize">DEFAULT</xsl:attribute>
                <xsl:attribute name="viewMode">gridView</xsl:attribute>
                <xsl:attribute name="mode">readonly</xsl:attribute>
                <!--<xsl:value-of select="ancestor-or-self::*[@mode!='inherit'][1]/@mode"/>-->
				
				<xsl:if test="@foreignReference!=''"><xsl:attribute name="db_foreign_key"><xsl:value-of select="@foreignReference"/></xsl:attribute></xsl:if>
                <xsl:attribute name="filter">{<xsl:value-of select="@foreignReference"/>}=<xsl:choose>
                    <xsl:when test="ancestor-or-self::dataRow/@identity!=''"><xsl:value-of select="ancestor-or-self::dataRow/@identity"/></xsl:when>
                    <xsl:otherwise>NULL</xsl:otherwise>
                  </xsl:choose></xsl:attribute>
                <xsl:attribute name="parameters">@#<xsl:value-of select="@foreignReference"/>=<xsl:choose>
                    <xsl:when test="ancestor-or-self::dataRow/@identity!=''"><xsl:value-of select="ancestor-or-self::dataRow/@identity"/></xsl:when>
                    <xsl:otherwise>NULL</xsl:otherwise>
                  </xsl:choose></xsl:attribute>
                <b>Cargando... </b>
              </div>
            </xsl:for-each>
          </div>
          <!-- <div id="console" oncontextmenu="alert(decHTMLifEnc(this.innerHTML)); return false;">Consola</div> -->
          <!-- <xsl:call-template name="pageTabs" /> -->
        </div>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="detailsView.table.Default" />
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>


<xsl:attribute-set name="detailsView.dataTable.Default" use-attribute-sets="dataTable.Default">
</xsl:attribute-set>
  
<xsl:template match="*[@dataType='table']" mode="detailsView.table.Default">
    <xsl:param name="mode">
      <xsl:choose>
        <xsl:when test="ancestor-or-self::*[@mode='readonly'][1]">readonly</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="ancestor-or-self::*[@mode!='inherit'][1]/@mode"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>
	
    <xsl:element name="table" use-attribute-sets="detailsView.dataTable.Default">
		<xsl:attribute name="class">dataTable detailsView Table_<xsl:value-of select="@Table_Name"/></xsl:attribute>
		   <!-- <xsl:attribute name="ondblclick">
		     <xsl:choose>
		       <xsl:when test="$mode='filters'">showModal(escapeHTML(createFilterXML()));</xsl:when>
		       <xsl:otherwise>showModal(escapeHTML(createUpdateXML()));</xsl:otherwise>
		     </xsl:choose>
		   </xsl:attribute> -->
		   <tbody id="db_{@Table_Name}_dataRow_{generate-id(data/dataRow[1])}">
		     <xsl:attribute name="db_identity_value"><xsl:choose><xsl:when test="data/dataRow/@identity!=''"><xsl:value-of select="data/dataRow/@identity"/></xsl:when><xsl:otherwise>NULL</xsl:otherwise></xsl:choose></xsl:attribute>
			<xsl:attribute name="db_primary_value"><xsl:choose><xsl:when test="data/dataRow/@primaryValue!=''"><xsl:value-of select="data/dataRow/@primaryValue"/></xsl:when><xsl:otherwise>NULL</xsl:otherwise></xsl:choose></xsl:attribute>
		     <xsl:attribute name="class">
		       Group_<xsl:value-of select="*[@groupByColumn]/@value"/>
		     </xsl:attribute>
		     <xsl:apply-templates select="data/dataRow[1]" mode="detailsView.table.dataRow" />
		     <!-- 			<tr>
			<td colspan="100"><input type="button" class="button" value="Guardar Datos" onClick="updateTable();" /></td>
		</tr> -->
		   </tbody>
	</xsl:element>
  </xsl:template>

  <xsl:template match="*[@controlType='detailsView']/data/dataRow" mode="detailsView.table.dataRow">
    <tr>
      <th colspan="2" style="height:10px">
        <!-- <xsl:call-template name="identifier" /> -->
        <xsl:for-each select="ancestor-or-self::dataRow/*[@controlType='hiddenField']">
          <xsl:apply-templates select="." mode="dataField" />
        </xsl:for-each>
      </th>
    </tr>
    <xsl:for-each select="*[not(@autoGenerateField='false')][not(@controlType='tab') and not(@mode='hidden' or @mode='none' or @controlType='hiddenField') and not(name(.)='CommandButtons')]">
      <tr>
        <xsl:attribute name="class">
          dataRow <xsl:choose>
            <xsl:when test="position() mod 2 = 1"> alt</xsl:when>
            <xsl:otherwise></xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <th nowrap="nowrap">
          <xsl:apply-templates select="." mode="headerText"/>
        </th>
        <td>
          <xsl:apply-templates select="." mode="dataField" />
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="detailsView.empty" match="*[@controlType='detailsView'][count(data/dataRow)=0]">
    <b class="warning">NO SE PUDO RECUPERAR LA INFORMACIÓN, EL REGISTRO PUDO HABER SIDO BORRADO O ALGÚN FILTRO ESTÁ IMPIDIENDO RECUPERAR EL REGISTRO. SI EL PROBLEMA PERSISTE CONSULTE AL ADMINISTRADOR DEL SISTEMA.</b>
  </xsl:template>

  <xsl:template name="detailsView.deny" match="*[@controlType='detailsView'][@mode='deny'][count(data/dataRow)=0]">
    <b class="warning">USTED NO TIENE PERMISOS PARA VER ESTE MÓDULO, CONSULTE CON SU ADMINISTRADOR DEL SISTEMA</b>
  </xsl:template>

</xsl:stylesheet>