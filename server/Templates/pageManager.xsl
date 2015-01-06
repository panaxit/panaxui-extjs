<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">

<xsl:strip-space elements="*"/>

<xsl:template name="pageSelector">
	<xsl:param name="for" />
	<div class="pageSelector" id="header" style="z-index:10000; background-color:white; width=120%;">
		<xsl:if test="$for"><xsl:attribute name="for"></xsl:attribute></xsl:if>
		<img class="imageButton" src="..\..\..\..\Images\Controls\Pager\btn_LArrow.png" width="20" enabled="true" oncontextmenu="return false;" id="leftArrow" />
		<xsl:value-of select="$nbsp"/>
			<strong>
			Página: 
			<xsl:variable name="totalPages"><xsl:value-of select="ceiling(number(*/@totalRecords) div number(*/@pageSize))"/></xsl:variable>
			<span class="selectBox">
				<input id="pageIndex" size="1" class="selectBoxInput">
					<xsl:attribute name="value"><xsl:value-of select="*/@pageIndex"/></xsl:attribute>
				</input>
				<img src="..\..\..\..\imagenes\Controls\EditableSelect\select_arrow.gif" oncontextmenu="return false;" class="selectBoxArrow" />
					<select size="10" class="catalog selectBoxOptionContainer" tabIndex="-1" enableFiltering="false">
			        <xsl:call-template name="pageSelectorElements">
			          <xsl:with-param name="count" select="$totalPages"/>
			          <xsl:with-param name="selectedIndex" select="*/@pageIndex"/>
			        </xsl:call-template>
					</select>
			</span>
			<!-- <select id="pageIndex">
		        <xsl:call-template name="pageSelectorElements">
		          <xsl:with-param name="count" select="$totalPages"/>
		          <xsl:with-param name="selectedIndex" select="72"/>
		        </xsl:call-template>
			</select> -->
			 / <span id="totalPages"><xsl:value-of select="$totalPages"/></span>
		 	</strong>
		 <xsl:value-of select="$nbsp"/>
		 <img class="imageButton" src="..\..\..\..\imagenes\Controls\Pager\btn_RArrow.png" width="20" enabled="true" oncontextmenu="return false;" id="rightArrow" />
	</div>
</xsl:template>

<xsl:template name="pageSelectorElements">
      <xsl:param name="start" select="1"/>
      <xsl:param name="count" select="0"/>
      <xsl:param name="selectedIndex" select="1"/>
      <xsl:if test="$count >= $start">
        <option>
			<xsl:if test="$start=$selectedIndex"><xsl:attribute name="selected">true</xsl:attribute></xsl:if>
			<xsl:attribute name="value"><xsl:value-of select="$start"/></xsl:attribute>
			<xsl:value-of select="$start"/>
		</option>
        <xsl:call-template name="pageSelectorElements">
          <xsl:with-param name="start" select="$start + 1"/>
          <xsl:with-param name="count" select="$count"/>
	      <xsl:with-param name="selectedIndex" select="$selectedIndex"/>
        </xsl:call-template>
      </xsl:if>
 </xsl:template>

<xsl:template name="pageTabs">
	<xsl:param name="for" />
	<div class="pageTabs">
		<xsl:if test="$for"><xsl:attribute name="for"></xsl:attribute></xsl:if>
		<ul id="tabs" style="text-decoration:none;">
			<li commandArguments="Prospectos" value="1" onclick="top.frames('WorkArea').location.href='Menus.asp?IdCategory='+this.getAttribute('value')" style="text-decoration:underline; cursor:hand;">
				<a href="#"><span>Prospectos</span></a>
			</li>
			<li commandArguments="Catalogos" value="2" onclick="top.frames('WorkArea').location.href='Menus.asp?IdCategory='+this.getAttribute('value')" style="text-decoration:underline; cursor:hand;">
				<a href="#"><span>Catalogos</span></a>
			</li>
			<li commandArguments="Administracion" value="4" onclick="top.frames('WorkArea').location.href='Menus.asp?IdCategory='+this.getAttribute('value')" style="text-decoration:underline; cursor:hand;">
				<a href="#"><span>Administracion</span></a>
			</li>
			<li commandArguments="Configuración" value="3" onclick="top.frames('WorkArea').location.href='Menus.asp?IdCategory='+this.getAttribute('value')" style="text-decoration:underline; cursor:hand;">
				<a href="#"><span>Configuración</span></a>
			</li>
		</ul>
	</div>
</xsl:template>

</xsl:stylesheet>