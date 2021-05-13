<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:toc="http://www.oxygenxml.com/ns/webhelp/toc"
                xmlns:oxygen="http://www.oxygenxml.com/functions">
    <xsl:param name="toc-numbering" select="'true'"/>
    <xsl:param name="currentTranstype"/>

    <xsl:template name="createTOCContent">
        <xsl:param name="cTopic" select="."/>
        <xsl:param name="title"/>
        <xsl:message>my transtype 'custom-toc' =
            <xsl:value-of select="$currentTranstype"/>
        </xsl:message>

        <xsl:element name="span" namespace="{$namespace}">
            <xsl:attribute name="class">topicref</xsl:attribute>
            <xsl:if test="$cTopic/@outputclass">
                <xsl:attribute name="class">
                    <xsl:value-of select="@outputclass"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:variable name="hrefLink">
                <xsl:choose>
                    <xsl:when test="(string-length($cTopic/@href) eq 0) or ($cTopic/@href eq 'javascript:void(0)') ">
                        <!-- EXM-38925 Select the href of the first descendant topic ref -->
                        <xsl:value-of
                                select="$cTopic/descendant::toc:topic[(string-length(@href) ne 0) and (@href ne 'javascript:void(0)')][1]/@href"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$cTopic/@href"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:choose>
                <xsl:when test="$hrefLink">
                    <xsl:if test="$toc-numbering='true'">
                        <xsl:number level="multiple" format="1.1 "/>
                    </xsl:if>
                    <xsl:element name="a" namespace="{$namespace}">
                        <xsl:attribute name="href">
                            <xsl:value-of select="concat($PATH2PROJ, $hrefLink)"/>
                        </xsl:attribute>
                        <xsl:if test="$cTopic/@scope = 'external'">
                            <xsl:attribute name="target">_blank</xsl:attribute>
                        </xsl:if>
                        <xsl:for-each select="$cTopic/@*[starts-with(name(), 'data-')]">
                            <xsl:copy/>
                        </xsl:for-each>
                        <xsl:copy-of select="$title"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="$title"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>

    </xsl:template>

    <!-- Inghibit output of text in the navigation tree. -->
    <xsl:template match="text()" mode="create-main-page-toc"/>

    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
        <xd:desc>
            Used to output a TOC entry for each topic.
        </xd:desc>
    </xd:doc>
    <xsl:template match="toc:topic" mode="create-main-page-toc">
        <xsl:param name="applyRecursion" select="false()"/>
        <xsl:choose>
            <xsl:when test="$currentTranstype = 'ia-webhelp-responsive-ab'">
                <xsl:variable name="title" select="oxygen:getTopicTitle(.)"/>
                <xsl:variable name="hasChildTopics" select="count(toc:topic) > 0"/>

                <xsl:choose>
                    <xsl:when test="$applyRecursion and $hasChildTopics">
                        <xsl:variable name="headingID" select="concat(@wh-toc-id, '-heading')"/>
                        <xsl:variable name="entriesID" select="concat(@wh-toc-id, '-entries')"/>
                        <div class=" wh_main_page_toc_accordion_header ">
                            <span role="heading" aria-level="1" id="{$headingID}">
                                <span role="button" aria-expanded="false" class="header-button"
                                      aria-controls="{$entriesID}" tabindex="0">
                                    <xsl:call-template name="createTOCContent">
                                        <xsl:with-param name="cTopic" select="."/>
                                        <xsl:with-param name="title" select="$title"/>
                                    </xsl:call-template>
                                </span>
                            </span>
                            <xsl:call-template name="generateTopicShortDesc">
                                <xsl:with-param name="cTopic" select="."/>
                                <xsl:with-param name="class" select="'wh_toc_shortdesc'"/>
                            </xsl:call-template>
                        </div>
                        <div class=" wh_main_page_toc_accordion_entries " id="{$entriesID}" role="region"
                             aria-labelledby="{$headingID}">
                            <xsl:apply-templates mode="#current"/>
                        </div>
                    </xsl:when>
                    <xsl:otherwise>
                        <div class=" wh_main_page_toc_entry ">
                            <xsl:call-template name="createTOCContent">
                                <xsl:with-param name="cTopic" select="."/>
                                <xsl:with-param name="title" select="$title"/>
                            </xsl:call-template>

                            <xsl:call-template name="generateTopicShortDesc">
                                <xsl:with-param name="cTopic" select="."/>
                                <xsl:with-param name="class" select="'wh_toc_shortdesc'"/>
                            </xsl:call-template>
                        </div>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:next-match/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
    Generate short description for a topic
  -->
    <xsl:template name="generateTopicShortDesc">
        <xsl:param name="cTopic"/>
        <xsl:param name="class" select="'wh_tile_shortdesc'"/>
        <xsl:if test="$cTopic/toc:shortdesc">
            <div>
                <xsl:call-template name="generateComponentClassAttribute">
                    <xsl:with-param name="compClass" select="$class"></xsl:with-param>
                </xsl:call-template>
                <xsl:copy-of select="@* except (@class | @wh-toc-id)"/>
                <xsl:apply-templates select="$cTopic/toc:shortdesc"/>
            </div>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>