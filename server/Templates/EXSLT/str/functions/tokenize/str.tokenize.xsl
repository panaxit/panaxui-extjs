<?xml version="1.0" encoding="utf-8"?>
<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:func="http://exslt.org/functions" xmlns:str="http://exslt.org/strings" version="1.0" extension-element-prefixes="str" str:doc="http://www.exslt.org/str">
   <xsl:import href="str.tokenize.function.xsl"/>
   <xsl:import href="str.tokenize.template.xsl"/>
   <func:script language="exslt:javascript" implements-prefix="str" src="str.tokenize.js"/>
   <func:script language="exslt:msxsl" implements-prefix="str" src="str.tokenize.msxsl.xsl"/>
</stylesheet>