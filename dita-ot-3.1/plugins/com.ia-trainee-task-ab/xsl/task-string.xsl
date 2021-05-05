<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:str="http://exslt.org/strings">
    <xsl:param name="myString"/>
    <xsl:param name="currentTranstype"/>

    <xsl:function name="str:split">
        <xsl:param name="string"/>
        <xsl:choose>
            <xsl:when test="starts-with($string, '/')">
                <xsl:sequence select="str:split(substring-after($string, '/'))"/>
            </xsl:when>
            <xsl:when test="contains($string, '/')">
                <span>
                    <xsl:value-of select="substring-before($string, '/')"/>
                </span>
                <span> * </span>
                <xsl:sequence select="str:split(substring-after($string, '/'))"/>
            </xsl:when>
            <xsl:when test="not(contains($string, '/'))">
                <span>
                    <xsl:value-of select="$string"/>
                </span>
                <span> * </span>
            </xsl:when>
        </xsl:choose>
    </xsl:function>

    <xsl:template match="*[contains(@class, ' topic/ul ')]" name="topic.ul">
        <xsl:choose>
            <xsl:when test="$currentTranstype = 'ia-webhelp-responsive-ab'">
                <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
                <xsl:call-template name="setaname"/>
                <ul>
                    <xsl:call-template name="commonattributes"/>
                    <xsl:apply-templates select="@compact"/>
                    <xsl:call-template name="setid"/>
                    <xsl:apply-templates/>
                </ul>
                <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>

                <!-- Tokenize -->
                <xsl:choose>
                    <xsl:when test="starts-with($myString, '/')">
                        <xsl:variable name="newString" select="substring-after($myString, '/')"/>
                        <xsl:for-each select="tokenize($newString, '/')">
                            <span style="color:green">
                                <xsl:value-of select="."/>
                            </span>
                            <span style="color:green"> * </span>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="tokenize($myString, '/')">
                            <span style="color:green">
                                <xsl:value-of select="."/>
                            </span>
                            <span> * </span>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
                <p></p>

                <!-- Named template -->
                <xsl:choose>
                    <xsl:when test="starts-with($myString, '/')">
                        <xsl:variable name="newStrTemp" select="substring-after($myString, '/')"/>
                        <xsl:call-template name="splitString">
                            <xsl:with-param name="input" select="concat($newStrTemp, '/')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="splitString">
                            <xsl:with-param name="input" select="concat($myString, '/')"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
                <p></p>

                <!-- xsl:function -->
                <p style="color:purple">
                    <xsl:sequence select="str:split($myString)"/>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <xsl:next-match/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="splitString">
        <xsl:param name="input" select="$myString"/>
        <xsl:param name="value" select="substring-before($input,'/')"/>
        <xsl:param name="next-string" select="substring-after($input,'/')"/>
        <span style="color:darkblue">
            <xsl:value-of select="$value"/>
        </span>
        <span style="color:darkblue"> * </span>
        <xsl:if test="$next-string">
            <xsl:call-template name="splitString">
                <xsl:with-param name="input" select="$next-string"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>