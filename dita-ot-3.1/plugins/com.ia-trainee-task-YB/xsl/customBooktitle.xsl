<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        version="2.0"
        xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:toc="http://www.oxygenxml.com/ns/webhelp/toc"
        xmlns:oxygen="http://www.oxygenxml.com/functions"
        xmlns:whc="http://www.oxygenxml.com/webhelp/components">

    <xsl:param name="tocNumbering" select="'true'"/>
    <xsl:param name="using_transtype"/>

    <!--Template for adding Mainbooktitle-->
    <xsl:template match="whc:webhelp_search_input" mode="copy_template">
        <!-- EXM-36737 - Context node used for messages localization -->
        <xsl:param name="i18n_context" tunnel="yes" as="element()*"/>
        <xsl:message>---------- YB <xsl:value-of select="$using_transtype"/>---------</xsl:message>
        <xsl:choose>
        <xsl:when test="$using_transtype = 'ia-webhelp-responsive-YB'">
            <xsl:message>---------- 1 ---------</xsl:message>
            <div>
                <xsl:call-template name="generateComponentClassAttribute">
                    <xsl:with-param name="compClass">wh_search_input</xsl:with-param>
                </xsl:call-template>
                <!-- Copy attributes -->
                <xsl:copy-of select="@* except @class"/>

                <xsl:variable name="localizedSearch">
                    <xsl:choose>
                        <xsl:when test="exists($i18n_context)">
                            <xsl:for-each select="$i18n_context[1]">
                                <xsl:call-template name="getWebhelpString">
                                    <xsl:with-param name="stringName" select="'webhelp.search'"/>
                                </xsl:call-template>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>Search</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="localizedSearchQuery">
                    <xsl:choose>
                        <xsl:when test="exists($i18n_context)">
                            <xsl:for-each select="$i18n_context[1]">
                                <xsl:call-template name="getWebhelpString">
                                    <xsl:with-param name="stringName" select="'search.query'"/>
                                </xsl:call-template>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>Search query</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <div class="custom_mainbooktitle">
                    <!-- mainBookTitle -->
                    <xsl:variable
                            name="mainbooktitle"
                            select="$mapTitle/*[contains(@class, 'mainbooktitle')]"/>
                    <xsl:value-of select="$mainbooktitle"/>
                    <xsl:message>HOHOHO CUSTOM mainbooktitle = '<xsl:value-of select="$mainbooktitle"/>'</xsl:message>
                    <xsl:message>HOHOHO CUSTOM BOOKTITLE = '<xsl:value-of select="$mapTitle"/>'</xsl:message>
                    <xsl:message>COPY CUSTOM BOOKTITLE = '<xsl:copy-of select="$mapTitle"/>'</xsl:message>
                </div>

                <xsl:variable name="search_comp_output">
                    <form id="searchForm"
                          method="get"
                          role="search"
                          action="{concat($PATH2PROJ, 'search', $OUTEXT)}">
                        <div>
                            <input type="search" placeholder="{$localizedSearch} " class="wh_search_textfield"
                                   id="textToSearch" name="searchQuery" aria-label="{$localizedSearchQuery}" required="required"/>
                            <button type="submit" class="wh_search_button" aria-label="{$localizedSearch}"><span><xsl:value-of select="$localizedSearch"/></span></button>
                        </div>
                    </form>
                </xsl:variable>

                <xsl:call-template name="outputComponentContent">
                    <xsl:with-param name="compContent" select="$search_comp_output"/>
                    <xsl:with-param name="compName" select="local-name()"/>
                </xsl:call-template>
            </div>
        </xsl:when>
        <xsl:otherwise>
            <xsl:message>---------- 2 ---------</xsl:message>
            <xsl:next-match/>
        </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!--Template for adding custom footer -->
    <xsl:template match="whc:include_html[@href='footer.xml']" mode="copy_template create-tiles">
        <xsl:message>---------- YB <xsl:value-of select="$using_transtype"/>---------</xsl:message>
        <xsl:choose>
            <xsl:when test="$using_transtype = 'ia-webhelp-responsive-YB'">
                <footer class="navbar navbar-default wh_footer" whc:version="21.0">
                    <div class=" footer-container mx-auto " id="custom_footer">

                        Generated by <a class="oxyFooter" href="https://intelliarts.com/" target="_blank">
                        Yuliia Bondarenko
                    </a>
                    </div>
                </footer>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>---------- 2 ---------</xsl:message>
                <xsl:next-match/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!--Template for creating TOC -->
    <xsl:template name="createTOCContent">
        <xsl:param name="cTopic" select="."/>
        <xsl:param name="title"/>
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
                        <xsl:value-of select="$cTopic/descendant::toc:topic[(string-length(@href) ne 0) and (@href ne 'javascript:void(0)')][1]/@href"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$cTopic/@href"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:message>
                tocNumbering = <xsl:value-of select="$tocNumbering"/>
            </xsl:message>

            <xsl:choose>
                <xsl:when test="$hrefLink">

                    <xsl:element name="a" namespace="{$namespace}">
                        <xsl:attribute name="href"><xsl:value-of select="concat($PATH2PROJ, $hrefLink)"/></xsl:attribute>
                        <xsl:if test="$cTopic/@scope = 'external'">
                            <xsl:attribute name="target">_blank</xsl:attribute>
                        </xsl:if>
                        <xsl:for-each select="$cTopic/@*[starts-with(name(), 'data-')]">
                            <xsl:copy/>
                        </xsl:for-each>
                        <xsl:if test="$tocNumbering='true'">
                            <xsl:number level="multiple" format="1.1 "/>
                        </xsl:if>
                        <xsl:copy-of select="$title"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="$title"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>


</xsl:stylesheet>