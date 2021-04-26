<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:whc="http://www.oxygenxml.com/webhelp/components"
                xmlns:toc="http://www.oxygenxml.com/ns/webhelp/toc">

    <xsl:param name="myString"/>
    <!--
            Expand the 'webhelp_search_input' place holder.
        -->
    <xsl:template match="whc:webhelp_search_input" mode="copy_template">
        <!-- EXM-36737 - Context node used for messages localization -->
        <xsl:param name="i18n_context" tunnel="yes" as="element()*"/>

        <xsl:variable name="mapTitle" as="item()*">
            <xsl:choose>
                <xsl:when test="exists($toc/toc:title) or exists($toc/@title)">
                    <xsl:choose>
                        <xsl:when test="$toc/toc:title">
                            <xsl:apply-templates select="$toc/toc:title/node()" mode="copy-xhtml-without-links"/>
                        </xsl:when>
                        <xsl:when test="$toc/@title">
                            <xsl:value-of select="$toc/@title"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>*** Unable to determine the map title</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:message>
            mapTitle value: <xsl:value-of select="$mapTitle"/>
            mapTitle copy: <xsl:copy-of select="$mapTitle"/>
            mainbook: <xsl:value-of select="$mapTitle/*[@class='ph mainbooktitle']"/>
        </xsl:message>

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

            <xsl:variable name="search_comp_output">
                <form id="searchForm"
                      method="get"
                      role="search"
                      action="{concat($PATH2PROJ, 'search', $OUTEXT)}">
                    <div>
                        <h1>
                            <xsl:value-of select="$mapTitle/*[contains(@class, 'mainbooktitle')]"/>
                        </h1>
                    </div>
                    <div>
                        <input type="search" placeholder="{$localizedSearch} " class="wh_search_textfield"
                               id="textToSearch" name="searchQuery" aria-label="{$localizedSearchQuery}"
                               required="required"/>
                        <button type="submit" class="wh_search_button" aria-label="{$localizedSearch}">
                            <span>
                                <xsl:value-of select="$localizedSearch"/>
                            </span>
                        </button>
                    </div>
                </form>
            </xsl:variable>

            <xsl:call-template name="outputComponentContent">
                <xsl:with-param name="compContent" select="$search_comp_output"/>
                <xsl:with-param name="compName" select="local-name()"/>
            </xsl:call-template>
        </div>


    </xsl:template>

    <!--
        Template used to emit the component content.
        It is aware if the a place holder is set for its content, whc:component_content.
    -->
    <xsl:template name="outputComponentContent">
        <xsl:param name="compContent"/>
        <xsl:param name="compName"/>

        <xsl:choose>
            <xsl:when test="count(*) = 0">
                <!-- The component has no children. Output its content -->
                <xsl:copy-of select="$compContent"/>
            </xsl:when>
            <xsl:when test="descendant::whc:component_content[ancestor::whc:*[1][local-name() = $compName]]">
                <!-- The component has set a place holder where to emit the content -->
                <xsl:apply-templates mode="#current">
                    <xsl:with-param name="compContent" select="$compContent" tunnel="yes"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <!--
                    There is no place holder for the content content. So, emit it here
                -->
                <xsl:copy-of select="$compContent"/>
                <xsl:apply-templates mode="#current"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Generate the class attribute for a WH component. -->
    <xsl:template name="generateComponentClassAttribute">
        <xsl:param name="compClass"/>
        <xsl:choose>
            <xsl:when test="@class">
                <xsl:variable name="classFromTemplate" as="attribute()*">
                    <xsl:apply-templates select="@class" mode="copy_template"/>
                </xsl:variable>
                <xsl:attribute name="class" select="concat(' ', $compClass, ' ', string($classFromTemplate), ' ')"/>

                <xsl:apply-templates select="@* except @class" mode="#current"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="class" select="concat(' ', $compClass, ' ')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>