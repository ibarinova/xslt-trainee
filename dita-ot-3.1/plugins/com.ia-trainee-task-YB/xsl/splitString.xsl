<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        version="2.0"
        xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:yb="https://www.saxonica.com/html/documentation10/xsl-elements/function.html"
        xmlns:fo="http://www.w3.org/1999/XSL/Format"
        xmlns:opentopic="http://www.idiominc.com/opentopic"
        exclude-result-prefixes="opentopic">

    <xsl:param name="using_transtype"/>
    <xsl:param name="using_input"/>

    <!--Splitting args.input with tokenize-->
    <xsl:template match="*[contains(@class, ' topic/p ')]" priority="7">
        <xsl:choose>
            <xsl:when test="$using_transtype = 'ia-webhelp-responsive-YB'">

                <xsl:next-match/>
                <xsl:variable name="str" select="$using_input"/>
                <xsl:variable name="tokenizedList" select="tokenize($str, '/')"/>
                <xsl:variable name="separator" select="' * '"/>

                <xsl:for-each select="$tokenizedList">
                    <span style="color:blue">
                        <xsl:value-of select="concat(., $separator)"/>
                    </span>
                </xsl:for-each>
                <div>
                    <xsl:call-template name="splitstr">
                        <xsl:with-param name="str" select="$using_input"/>
                        <xsl:with-param name="separator" select="' % '"/>
                    </xsl:call-template>
                </div>
                <div style="color:pink">
                    <xsl:copy-of select="yb:split($using_input)"/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <xsl:next-match/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!--Splitting args.input with recursive-->
    <xsl:template name="splitstr">
        <xsl:param name="str" select="$using_input"/>
        <xsl:param name="separator" select="' % '"/>
        <xsl:choose>
            <xsl:when test="not(contains($str, '/'))">
                <span style="color:red">
                    <xsl:value-of select="$str"/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span style="color:red">
                    <xsl:value-of select="substring-before($str, '/')"/>
                    <xsl:value-of select="$separator"/>
                </span>
                <xsl:call-template name="splitstr">
                    <xsl:with-param name="str" select="substring-after($str, '/')"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:message>
            "IT IS YOUR INPUT with recursive"
            <xsl:value-of select="$str"/>
        </xsl:message>
    </xsl:template>

    <!--Splitting args.input with xsl:function -->
    <xsl:function name="yb:split">
        <xsl:param name="str"/>
        <xsl:variable name="separator" select="' § '"/>
        <xsl:choose>
            <xsl:when test="not(contains($str, '/'))">
                <span style="color:pink">
                    <xsl:value-of select="$str"/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span>
                    <xsl:value-of select="substring-before($str, '/')"/>
                    <xsl:value-of select="$separator"/>
                </span>
                <xsl:value-of select="yb:split(substring-after($str, '/'))"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:message>
            "IT IS YOUR INPUT with xsl:function"
            <xsl:value-of select="$str"/>
        </xsl:message>
    </xsl:function>

</xsl:stylesheet>