<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict"
	>
<xsl:import href="functions.xsl" /> 

<xsl:import href="keys.xsl" />
<xsl:import href="attributeSets.xsl" />

<xsl:output method="html" omit-xml-declaration="yes" doctype-public="html"/>
<xsl:include href="html/global_variables.xsl" />
<xsl:include href="extjs/list.controls.xsl" />
<xsl:include href="customStylesheets.xsl" />

<xsl:template name="none" match="*[@mode='none']"><!-- ancestor-or-self::*[@mode!='inherit'][1]/@mode='readonly' or  -->
	<xsl:value-of select="$nbsp"/>
</xsl:template>

<xsl:template name="pageManager" match="/">
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="google" content="notranslate" />

    <title>Px ExtJS</title>

    <link rel="apple-touch-icon" href="resources/images/apple-touch-icon.png"/>
    <link rel="stylesheet" type="text/css" href="resources/Sencha-Examples/style.css"/>
	<link rel="stylesheet" type="text/css" href="resources/ux/statusbar/css/statusbar.css" />
	<style type="text/css">
	.x-status-error-list {
		z-index: 19999 !important;
	}
	.x-status-error-list li {
		cursor: 'hand' !important;
	}
	</style>
	<script type="text/javascript" src="ext-all-debug.js"></script>
    <!-- The line below must be kept intact for Sencha Command to build your application -->
    <script type="text/javascript"><xsl:text disable-output-escaping="yes">
		Ext.ns("application")
		application["name"]="Px"
		Ext.Loader.setPath({
			'Ext.ux': 'resources/ux'
//			,'Ext.app': '../../../../resources/extjs/ext-5.0.1/examples/portal/classes'
			, 'Px': 'app'
		});
// 		Ext.require([ 
// //		,'Ext.ux.GroupTabPanel'
// 		]);
    
        var Ext = Ext || {};
        Ext.repoDevMode = true;
        Ext.beforeLoad = function(tags){
            var theme = location.href.match(/theme=([\w-]+)/),
                locale = location.href.match(/locale=([\w-]+)/);

            theme  = (theme &amp;&amp; theme[1]) || (tags.desktop ? 'neptune' : 'neptune-touch');
            locale = (locale &amp;&amp; locale[1]) || 'en';

            Ext.manifest = theme + "-" + locale;
            Ext.microloaderTags = tags;
        };
    </xsl:text></script>
	<script type="text/javascript" src="scripts/md5.js"></script>
	<script type="text/javascript" src="components.js"></script>
	<script type="text/javascript" src="overrides.js"></script>
    <script type="text/javascript" src="bootstrap.js" id="microloader"></script>
</head>
<body>
<script language="javascript"><![CDATA[
Ext.onReady(function(){
	var container = Ext.create('Ext.Viewport', {
]]>
        title: "<xsl:apply-templates select="." mode="headerText"/>",
<![CDATA[
        layout: 'fit',
		closable: true
    }).show();
	
]]>
	<xsl:if test="*/*"><xsl:apply-templates select="*" /></xsl:if>
	var content = Ext.create('Cache.app.<xsl:value-of select="*/@dbId"/>.<xsl:value-of select="*/@xml:lang"/>.<xsl:value-of select="*/@Table_Schema"/>.<xsl:value-of select="*/@Table_Name"/>.<xsl:value-of select="*/@mode"/>.<xsl:value-of select="*/@controlType"/>', {});
<![CDATA[
	container.add(content);
//	try { content.loadRecord(null); } catch(e){}
});
]]></script>
</body>
</html>
</xsl:template>
</xsl:stylesheet>