<?xml version="1.0" encoding="UTF-8"?>
<!--  This file is part of the DITA Open Toolkit project. See the accompanying LICENSE file for applicable license.  -->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml"
              indent="no"
              doctype-public="-//OASIS//DTD DITA Reference//EN"
              doctype-system="reference.dtd"/>

  <xsl:template match="/">
    <xsl:comment>
     This file is part of the DITA Open Toolkit project. 
     See the accompanying LICENSE file for applicable license.
    </xsl:comment>
    <xsl:comment>
     This file is generated based on the message information shipped
     in the DITA-OT, as defined in the file
     DITA-OT/resources/messages.xml
     To regenerate this topic, run the following command:
     DITA-OT/docsrc/ant -f build.xml generate-msg-topic

     Alternatively, you may use that same build file to
     create a PDF, HTML5, or HTML Help version of the User Guide, which
     will update the topic as part of the build. To rebuild PDF and HTML5,
     just run the command
     DITA-OT/docsrc/ant -f build.xml

     To build only one output format, run that same build command, followed
     by either "html", "pdf", or "htmlhelp". For example,
     this command will rebuild the HTML documentation (including the updated
     messages topic):
     DITA-OT/docsrc/ant -f build.xml build-html
    </xsl:comment>
    <!-- The title, shortdesc, and overview section in this topic will all
         be overwritten with "conref push", as long as it is built
         with the full userguide.ditamap. The text here is provided as
         a default in case the topic is generated on its own. -->
    <reference id="msgs">
      <title id="title" outputclass="generated">Error messages</title>
      <shortdesc id="shortdesc">This topic defines all error messages generated by the DITA-OT.</shortdesc>
      <refbody>
        <section id="overview"><p>Plug-ins may be used to add additional error messages into the toolkit;
          for more information, see the DITA-OT <cite>Developer Reference</cite>.</p></section>
        <simpletable>
          <xsl:attribute name="relcolwidth">1.5* 1.5* 3* 4*</xsl:attribute>
          <sthead>
              <stentry>Message&#xA0;ID</stentry>
              <stentry>Severity</stentry>
              <stentry>Message text</stentry>
              <stentry>Additional details</stentry>
          </sthead>
          <xsl:for-each select="/*/message">
            <xsl:sort select="@id"/>
            <strow id="{@id}">
              <stentry><msgnum><xsl:value-of select="@id"/></msgnum></stentry>
              <stentry>
                <xsl:choose>
                  <xsl:when test="@type='INFO'">Info</xsl:when>
                  <xsl:when test="@type='WARN'">Warning</xsl:when>
                  <xsl:when test="@type='ERROR'">Error</xsl:when>
                  <xsl:when test="@type='FATAL'">Fatal</xsl:when>
                  <xsl:otherwise><xsl:value-of select="@type"/></xsl:otherwise>
                </xsl:choose>
              </stentry>
              <stentry>
                <xsl:call-template name="format-message">
                  <xsl:with-param name="text" select="string(reason)"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                <xsl:call-template name="format-message">
                  <xsl:with-param name="text" select="string(response)"/>
                </xsl:call-template>
              </stentry>
              <stentry id="{@id}-extra">&#xA0;</stentry>
            </strow>
          </xsl:for-each>
        </simpletable>
      </refbody>
    </reference>
  </xsl:template>

  <xsl:template name="format-message">
    <xsl:param name="text"/>
    <xsl:choose>
      <xsl:when test="contains($text, '%') and not(number(substring(substring-after($text, '%'), 1, 1)) = number('NaN'))">
        <xsl:value-of select="substring-before($text, '%')"/>
        <varname>
          <xsl:text>%</xsl:text>
          <xsl:value-of select="substring(substring-after($text, '%'), 1, 1)"/>
        </varname>
        <xsl:call-template name="format-message">
          <xsl:with-param name="text" select="substring(substring-after($text, '%'), 2)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- To create each as a nested topic -->
  <!--
      <xsl:for-each select="/*/message">
        <reference id="{@id}">
          <title><xsl:value-of select="@id"/></title>
          <shortdesc><xsl:value-of select="reason"/></shortdesc>
          <refbody>
            <section><title>User response</title><p><xsl:value-of select="response"/></p></section>
          </refbody>
        </reference>
      </xsl:for-each>
  -->

</xsl:stylesheet>
