<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:whc="http://www.oxygenxml.com/webhelp/components">
    <xsl:param name="no-images"/>
    <xsl:param name="currentTranstype"/>

    <!-- =========== IMAGE/OBJECT =========== -->
    <xsl:template match="*[contains(@class, ' topic/image ')]" name="topic.image">
        <xsl:message>!!!!! no-images = <xsl:value-of select="$no-images"/> </xsl:message>
        <!--<xsl:choose>
            <xsl:when test="($no-images = 'true') and ($currentTranstype = 'ia-webhelp-responsive-ab')"/>
            <xsl:otherwise>
                <xsl:next-match/>
            </xsl:otherwise>
        </xsl:choose>-->
        <xsl:if test="($no-images != 'true') or ($currentTranstype != 'ia-webhelp-responsive-ab')">
            <xsl:next-match/>
        </xsl:if>


    </xsl:template>

    <xsl:template name="topic-image">
        <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
        <img>
            <xsl:call-template name="commonattributes">
                <xsl:with-param name="default-output-class">
                    <xsl:if test="@placement = 'break'"><!--Align only works for break-->
                        <xsl:choose>
                            <xsl:when test="@align = 'left'">imageleft</xsl:when>
                            <xsl:when test="@align = 'right'">imageright</xsl:when>
                            <xsl:when test="@align = 'center'">imagecenter</xsl:when>
                        </xsl:choose>
                    </xsl:if>
                </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="setid"/>
            <xsl:choose>
                <xsl:when test="*[contains(@class, ' topic/longdescref ')]">
                    <xsl:apply-templates select="*[contains(@class, ' topic/longdescref ')]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="@longdescref"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="@href|@height|@width"/>
            <xsl:apply-templates select="@scale"/>
            <xsl:choose>
                <xsl:when test="*[contains(@class, ' topic/alt ')]">
                    <xsl:variable name="alt-content"><xsl:apply-templates select="*[contains(@class, ' topic/alt ')]" mode="text-only"/></xsl:variable>
                    <xsl:attribute name="alt" select="normalize-space($alt-content)"/>
                </xsl:when>
                <xsl:when test="@alt">
                    <xsl:attribute name="alt" select="@alt"/>
                </xsl:when>
            </xsl:choose>
        </img>
        <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
    </xsl:template>

</xsl:stylesheet>