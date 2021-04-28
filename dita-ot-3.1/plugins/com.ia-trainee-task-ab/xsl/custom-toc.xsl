<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:toc="http://www.oxygenxml.com/ns/webhelp/toc">
    <xsl:param name="toc-numbering" select="'true'"/>
    <xsl:param name="currentTranstype"/>

    <xsl:template name="createTOCContent">
        <xsl:param name="cTopic" select="."/>
        <xsl:param name="title"/>

        <xsl:choose>
            <xsl:when test="$currentTranstype = 'ia-webhelp-responsive-ab'">
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
            </xsl:when>
            <xsl:otherwise>
                <xsl:next-match/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>