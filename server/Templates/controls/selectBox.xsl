<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict"
	xmlns:px="urn:panax"
>

<xsl:strip-space elements="*"/>

<xsl:template match="*[not(@dataType) and (@controlType='selectBox' or @controlType='default' and ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='default' or ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='selectBox')]" mode="fieldFilters" priority="-1">1=0</xsl:template>

<xsl:template name="selectBox" match="*[not(@dataType) and (@controlType='selectBox' or @controlType='default' and ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='default' or ancestor-or-self::*[@dataType='foreignKey'][1]/@controlType='selectBox')]">
<xsl:param name="name"><xsl:choose>
	<xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when>
	<xsl:when test="../@foreignKey and @primaryKey"><xsl:value-of select="@Column_Name"/></xsl:when>
	<xsl:otherwise><xsl:value-of select="../@Column_Name"/></xsl:otherwise>
</xsl:choose></xsl:param>
<xsl:param name="id" select="concat('field_', ancestor::*[@dataType='foreignKey'][1]/@Column_Name, '_', generate-id(.))"/>
<xsl:param name="required"><xsl:choose>
	<xsl:when test="number(ancestor-or-self::*[@isNullable!='inherit'][1]/@isNullable)=0">1</xsl:when>	
	<xsl:otherwise>0</xsl:otherwise>
</xsl:choose></xsl:param>
<xsl:param name="mode" select="'readonly'"/>
<xsl:param name="cssClass"/>
<xsl:param name="text" select="@text"/>
<xsl:param name="value" select="@value"/>
<xsl:param name="width" select="ancestor::*[@dataType='foreignKey'][1]/@width"/>
<xsl:variable name="isSubmitable"><xsl:choose>
	<xsl:when test="ancestor::*[@dataType='table' and string(@mode)!='inherit'][1][@mode='insert']">true</xsl:when>	<!-- <xsl:value-of select="../@isSubmitable"/> -->
	<xsl:when test="../@isSubmitable"><xsl:value-of select="../@isSubmitable"/></xsl:when>
	<xsl:when test="ancestor-or-self::*[@mode='readonly'][1]">true</xsl:when>	<!-- <xsl:value-of select="../@isSubmitable"/> -->
	<xsl:when test="../@dataType='foreignKey'">true</xsl:when>	<!-- <xsl:value-of select="../@isSubmitable"/> -->
	<xsl:otherwise>false</xsl:otherwise>
</xsl:choose></xsl:variable>
  
xtype: 'combobox',
name: '<xsl:value-of select="$name"/>',
value: '<xsl:if test="@dataType!='date'"><xsl:value-of select="@controlType"/>/<xsl:value-of select="@dataType"/> (<xsl:value-of select="@length"/>): </xsl:if><xsl:value-of select="@text"/>',
queryMode: 'local',
valueField: 'id',
displayField: 'text',
typeAhead: true,
emptyText: '- -',
//width: 400,
forceSelection: true,
store: Ext.create('Ext.data.Store', {
	autoLoad: true,
	fields: ['id', 'text'],
	<xsl:choose>
		<xsl:when test="px:data">
		data:[
			<xsl:for-each select="px:data/*">
			{id:'<xsl:value-of select="@value"/>', text:'<xsl:value-of select="@text"/>'},
			</xsl:for-each>
			]	
		</xsl:when>
		<xsl:otherwise>
		proxy: {
			type: 'ajax',
			url: '../Scripts/xmlCatalogOptions.asp',
			reader: {
				type: 'json',
				root: 'data',
				successProperty: 'success',
				messageProperty: 'message',
				totalProperty: 'total',
				idProperty: '<xsl:value-of select="@identityKey"/>'
			},
			pageParam: 'pageIndex',
			limitParam: 'pageSize',
			sortParam: 'sorters',
			extraParams: {
				catalogName: "<xsl:value-of select="@Table_Schema" />.<xsl:value-of select="@Table_Name" />",
				filters: "<xsl:apply-templates mode="fieldFilters" select="."/>",
				dataValue: "<xsl:value-of select="@dataValue" />",
				dataText: "<xsl:value-of select="@dataText" />",
				output: 'json',
			},
			listeners: {
				select: function(combo, records, eOptions) { 
					alert()
				},
				exception: function(proxy, response, operation){
					var message = operation.getError();
					message = Ext.isObject(message)?message["error"]:message;
					Ext.MessageBox.show({
						title: 'ERROR!',
						msg: message,
						icon: Ext.MessageBox.ERROR,
						buttons: Ext.Msg.OK
					});
				}
			},
		},
		</xsl:otherwise>
	</xsl:choose>
}),
<xsl:choose>
	<xsl:when test="$mode='readonly'">
	readOnly: true,
	</xsl:when>
	<xsl:otherwise>

<!-- 		<span class="selectBox {$cssClass}" isSubmitable="true" onMouseOver="/*alert(this.value+': '+($(this).hasClass('changed')))*/">
			<xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
			<xsl:attribute name="value"><xsl:value-of select="$value" /></xsl:attribute>
			<input id="{$name}" size="50" class="selectBoxInput" value="{$text}" isSubmitable="false">
				<xsl:if test="$width"><xsl:attribute name="size"><xsl:value-of select="$width"/></xsl:attribute></xsl:if>
			</input>
			<img src="..\..\..\..\Images\Controls\EditableSelect\select_arrow.gif" oncontextmenu="return false;" class="selectBoxArrow" tabIndex="-1" />
			<select size="10" turnOn="true" class="catalog selectBoxOptionContainer" tabIndex="-1" opt_null="true" isSubmitable="false">
			<xsl:attribute name="opt_new"><xsl:choose><xsl:when test="not(ancestor::*[@mode='filters'] or contains(@filters, '[#primaryTable].')) and string(@disableInsert)!='true'">true</xsl:when>
	<xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
			<xsl:if test="ancestor::*[@dataType='foreignKey'][1]/data"><xsl:attribute name="isUpdated">true</xsl:attribute></xsl:if>
        <xsl:if test="*">
          <xsl:attribute name="parentObject">
            <xsl:value-of select="concat('field_', ancestor::*[@dataType='foreignKey'][1]/@Column_Name, '_', generate-id(*))"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="@filters!=''">
          <xsl:attribute name="filters">'<xsl:value-of select="@filters"/>'</xsl:attribute>
        </xsl:if>
        <xsl:if test="../@foreignKey and @primaryKey">
          <xsl:attribute name="isSubmitable">false</xsl:attribute>
        </xsl:if>
        <xsl:if test="@isSubmitable">
			<xsl:attribute name="isSubmitable"><xsl:value-of select="@isSubmitable"/></xsl:attribute>
        </xsl:if>
        <xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
				<xsl:attribute name="catalogName"><xsl:if test="@Table_Schema"><xsl:value-of select="@Table_Schema"/>.</xsl:if><xsl:value-of select="name(.)"/></xsl:attribute>
				<xsl:attribute name="dataValue"><xsl:choose><xsl:when test="@dataValue"><xsl:value-of select="@dataValue" /></xsl:when><xsl:otherwise><xsl:value-of select="@primaryKey" /></xsl:otherwise>
			</xsl:choose></xsl:attribute>
				<xsl:attribute name="dataText"><xsl:value-of select="@dataText" /></xsl:attribute>
				<xsl:choose>
				<xsl:when test="ancestor::*[@dataType='foreignKey'][1]/data">	
						<xsl:if test="ancestor::*[@dataType='foreignKey'][1]"></xsl:if>
						<xsl:for-each select="ancestor::*[@dataType='foreignKey'][1]/data/*"><xsl:sort select="@text"/>
							<option value="{@value}"><xsl:if test="string(@value)=string(ancestor::*[@dataType='foreignKey'][1]/@value)"><xsl:attribute name="selected">true</xsl:attribute></xsl:if><xsl:value-of select="@text"/></option>
						</xsl:for-each>
						<xsl:if test="not(ancestor::*[@mode='filters'] or contains(@filters, '[#primaryTable].')) and string(@disableInsert)!='true'"><OPTION id="opt_&lt;new&gt;" class="new systemOption" value="&lt;new&gt;">[New]</OPTION></xsl:if>
					</xsl:when>	
					<xsl:otherwise><option selected="true">
					<xsl:choose>
						<xsl:when test="not(@required='true') and not($value!='')">
						<xsl:attribute name="value"><xsl:value-of select="'NULL'" /></xsl:attribute>
							<xsl:value-of select="''"/>- -</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="value"><xsl:value-of select="$value" /></xsl:attribute>
							<xsl:value-of select="$text"/>
						</xsl:otherwise>
					</xsl:choose>			
					</option></xsl:otherwise>
				</xsl:choose>
			</select>
		</span> -->
	</xsl:otherwise>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
