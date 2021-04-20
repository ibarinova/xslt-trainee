<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:param name="currentTranstype"/>
    <!--  Notes  -->
    <xsl:template match="*" mode="process.note.common-processing">
        <xsl:param name="type" select="@type"/>
        <xsl:param name="title">
            <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="concat(upper-case(substring($type, 1, 1)), substring($type, 2))"/>
            </xsl:call-template>
        </xsl:param>
        <xsl:choose>
            <xsl:when test="$currentTranstype = 'ia-webhelp-responsive-ab'">
                <div>
                    <xsl:call-template name="commonattributes">
                        <xsl:with-param name="default-output-class" select="string-join(( concat('my', $type) , concat('mynote_', $type)), ' ')"/>
                    </xsl:call-template>
                    <xsl:call-template name="setidaname"/>
                    <!-- Normal flags go before the generated title; revision flags only go on the content. -->
                    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/prop" mode="ditaval-outputflag"/>
                    <span class="mynote__title">
                        <xsl:copy-of select="$title"/>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="'ColonSymbol'"/>
                        </xsl:call-template>
                    </span>
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/revprop" mode="ditaval-outputflag"/>
                    <xsl:apply-templates/>
                    <!-- Normal end flags and revision end flags both go out after the content. -->
                    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <xsl:next-match/>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:message>
            ======= Current Transtype <xsl:value-of select="$currentTranstype"/> =======
        </xsl:message>
    </xsl:template>

</xsl:stylesheet>