<?xml version="1.0" encoding="UTF-8"?><!--
    
Oxygen Webhelp plugin
Copyright (c) 1998-2019 Syncro Soft SRL, Romania.  All rights reserved.

--><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:relpath="http://dita2indesign/functions/relpath" xmlns:toc="http://www.oxygenxml.com/ns/webhelp/toc" xmlns:oxygen="http://www.oxygenxml.com/functions" exclude-result-prefixes="#all" version="2.0">
  
  <xsl:import href="dita2webhelpImpl.xsl"/>
  
  <!--
    XSLT extension point for the stylesheet used to produce an HTML file for each DITA topic. 
  -->
  <xsl:import xmlns:dita="http://dita-ot.sourceforge.net" href="../../../com.waters.webhelp.responsive/xsl/dita2webhelp/dita2webhelp.xsl"/>
  
  <!-- WH-1439 com.oxygenxml.webhelp.xsl.dita2webhelp extension point -->
  <xsl:import href="template:xsl/com.oxygenxml.webhelp.xsl.dita2webhelp"/>
</xsl:stylesheet>