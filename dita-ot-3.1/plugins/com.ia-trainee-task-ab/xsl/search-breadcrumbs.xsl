<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:whc="http://www.oxygenxml.com/webhelp/components">
    <xsl:param name="currentTranstype"/>

    <xsl:template match="whc:webhelp_search_results" mode="copy_template">

        <nav class="wh_tools d-print-none">
            <div class=" wh_breadcrumb ">
                <ol class="d-print-none">
                    <li>
                        <span class="home">
                            <a href="index.html"><span>Home</span></a>
                        </span>
                    </li>
                    <li class="active">
                        <span class="title">
                            <a href="#">Search</a>
                        </span>
                    </li>
                </ol>
            </div>
            <div class="wh_right_tools">
                <div class=" wh_print_link print d-none d-md-inline-block ">
                    <button onclick="window.print()" title="Print this page" aria-label="Print this page"
                            class="oxy-icon oxy-icon-print"></button>
                </div>
            </div>
        </nav>

        <xsl:variable name="webhelp_search_results">
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

    <xsl:template name="generateSearchPreloader">
        <div class="searchPreload">
            <ul>
                <xsl:for-each select="1 to 3">
                    <li>
                        <div class="fakeResult">
                            <div class="fakeTitle"><!-- --></div>
                            <div class="fakeText"><!-- --></div>
                            <div class="fakeText"><!-- --></div>
                            <div class="fakeText"><!-- --></div>
                        </div>
                    </li>
                </xsl:for-each>
            </ul>
        </div>
    </xsl:template>

</xsl:stylesheet>