<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:toc="http://www.oxygenxml.com/ns/webhelp/toc"
                xmlns:index="http://www.oxygenxml.com/ns/webhelp/index"
                xmlns:oxygen="http://www.oxygenxml.com/functions" xmlns:d="http://docbook.org/ns/docbook"
                xmlns:whc="http://www.oxygenxml.com/webhelp/components"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:html="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="#all" version="2.0">

    <xsl:template match="whc:webhelp_search_results" mode="copy_template">
        <xsl:variable name="webhelp_search_results">
            <nav class="wh_tools d-print-none">
                <div class=" wh_breadcrumb ">
                    <ol class="d-print-none">
                        <li>
                            <span>
                                <a href="index.html">
                                    <span>Home</span>
                                </a>
                            </span>
                        </li>
                        <li class="active">
                            <span class="topicref" data-id="alternative-authoring-formats">
                                <span class="title">
                                    <a href="#">Search</a>
                                </span>
                            </span>
                        </li>
                    </ol>
                </div>
            </nav>
            <xsl:choose>
                <xsl:when
                        test="string-length($WEBHELP_SEARCH_SCRIPT) > 0 and string-length($WEBHELP_SEARCH_RESULT) > 0">
                    <xsl:copy-of select="doc($WEBHELP_SEARCH_RESULT)"/>
                </xsl:when>
                <xsl:when test="string-length($WEBHELP_SEARCH_SCRIPT) > 0">
                    <div class="gcse-searchresults-only" data-autoSearchOnLoad="true"
                         data-queryParameterName="searchQuery"></div>
                </xsl:when>
                <xsl:otherwise>
                    <div>
                        <xsl:call-template name="generateComponentClassAttribute">
                            <xsl:with-param name="compClass">wh_search_results</xsl:with-param>
                        </xsl:call-template>
                        <xsl:copy-of select="@* except @class"/>
                        <xsl:call-template name="generateSearchPreloader"/>
                    </div>
                </xsl:otherwise>
            </xsl:choose>

        </xsl:variable>

        <xsl:call-template name="outputComponentContent">
            <xsl:with-param name="compContent" select="$webhelp_search_results"/>
            <xsl:with-param name="compName" select="local-name()"/>
        </xsl:call-template>
    </xsl:template>

</xsl:stylesheet>