<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:css-param="http://www.oxygenxml.com/extensions/publishing/dita/css/params"
                exclude-result-prefixes="#all" >
  <xsl:param name="html5.css.links" />
  
  <!-- Add the links to the CSS files to the HTML head. -->
  <xsl:template name="generateCssLinks">
    <xsl:if test="$html5.css.links">    
      <xsl:text>&#10;</xsl:text>
      <xsl:value-of select="$html5.css.links" disable-output-escaping="yes"/>
    </xsl:if>
  </xsl:template>  
  
  <!-- Add the publication title to the HTML head. -->
  <xsl:template name="generateChapterTitle">
    <title>
     
      <xsl:choose>
        <xsl:when test="@title">
          <xsl:value-of select="@title"/>
        </xsl:when>
        <xsl:when test="*[contains(@class, ' topic/title ')]">
          <xsl:value-of select="*[contains(@class, ' topic/title ')]"/>            
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="*[contains(@class, ' front-page/front-page ')]
                                  /*[contains(@class, ' front-page/front-page-title ')]
                                   /*[contains(@class, ' bookmap/booktitle ')]
                                    /*[contains(@class, ' bookmap/mainbooktitle ')]"/>
        </xsl:otherwise>
      </xsl:choose>
      
    </title>
  </xsl:template>
  
  <!-- Collect the keywords -->
  <xsl:template match="*" mode="gen-keywords-metadata">
    
    <xsl:variable name="keywords-content-at-map-level">
      <xsl:for-each select="descendant::*[contains(@class,' front-page/front-page ')]/*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/keywords ')]/descendant-or-self::*">
          <!-- for each item inside keywords (including nested index terms) -->
          <xsl:if test="position()>2"><xsl:text>, </xsl:text></xsl:if>
          <xsl:value-of select="normalize-space(text()[1])"/>
      </xsl:for-each>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="string-length($keywords-content-at-map-level)">
        
        <!-- Map level keywords, these will be considered as important. -->
        <meta name="DC.subject" content="{$keywords-content-at-map-level}"/>
        <meta name="keywords" content="{$keywords-content-at-map-level}"/>
      
      </xsl:when>
      <xsl:otherwise>
        <!-- Let the default processing, that collects all keywords and indexterms from the content of the topics. -->
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="/*">
    <html>
      <!-- This can be used to solve relative images -->
      <xsl:copy-of select="@xtrf"/>
      <!-- These are additional root attributes -->
      <xsl:copy-of select="@css-param:*"/>
      
      <xsl:call-template name="chapterHead"/>
      <body class="wh_topic_page">
          <div class="wh_content_area">
            <div class="wh_topic_body">
              <div class="wh_topic_content">
                <div>
                  <xsl:call-template name="commonattributes"/>
                  <xsl:apply-templates/>
                </div>
              </div>
            </div>
          </div>
      </body>
    </html>
  </xsl:template>
  
</xsl:stylesheet>