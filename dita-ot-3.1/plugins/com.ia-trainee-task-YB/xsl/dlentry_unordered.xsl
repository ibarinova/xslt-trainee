<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        version="2.0"
        xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:whc="http://www.oxygenxml.com/webhelp/components">

    <!-- =========== DEFINITION LIST =========== -->

    <!-- DL -->
    <xsl:template match="*[contains(@class,' topic/dl ')][empty(*[contains(@class,' topic/dlentry ')])]" priority="10"/>

    <xsl:template match="*[contains(@class, ' topic/dl ')]" name="topic.dl">
        <xsl:call-template name="setaname"/>
        <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
        <ul>
            <!--<dl>-->
            <!-- handle DL compacting - default=yes -->
            <xsl:if test="@compact = 'no'">
                <xsl:attribute name="class">dlexpand</xsl:attribute>
            </xsl:if>
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates select="@compact"/>
            <xsl:call-template name="setid"/>
            <xsl:apply-templates/>
            <!--</dl>-->
        </ul>
        <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
    </xsl:template>

    <!-- DL entry -->
    <xsl:template match="*[contains(@class, ' topic/dlentry ')]" name="topic.dlentry">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

    <!-- SF Patch 2185423: condensed code so that dt processing is not repeated for keyref or when $dtcount!=1
         Code could be reduced further by compressing the flagging templates. -->
    <xsl:template match="*[contains(@class, ' topic/dt ')]" mode="output-dt">
        <xsl:variable name="is-first-dt" select="empty(preceding-sibling::*[contains(@class, ' topic/dt ')])"/>
        <xsl:variable name="dt-class">
            <xsl:choose>
                <!-- handle non-compact list items -->
                <xsl:when test="$is-first-dt and ../../@compact = 'no'">dltermexpand</xsl:when>
                <xsl:otherwise>dlterm</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <b>
            <!--<dt>-->
            <!-- Get xml:lang and ditaval styling from DLENTRY, then override with local -->
            <xsl:apply-templates select="../@xml:lang"/>
            <xsl:apply-templates select="../*[contains(@class, ' ditaot-d/ditaval-startprop ')]/@outputclass"
                                 mode="add-ditaval-style"/>
            <xsl:for-each select="..">
                <xsl:call-template name="commonattributes"/>
            </xsl:for-each>
            <xsl:call-template name="commonattributes">
                <xsl:with-param name="default-output-class" select="$dt-class"/>
            </xsl:call-template>
            <!-- handle ID on a DLENTRY -->
            <xsl:choose>
                <xsl:when test="$is-first-dt and exists(../@id) and exists(@id)">
                    <xsl:call-template name="setidaname"/>
                    <a id="{dita-ot:get-prefixed-id(.., ../@id)}"/>
                </xsl:when>
                <xsl:when test="$is-first-dt and exists(../@id) and empty(@id)">
                    <xsl:for-each select="..">
                        <xsl:call-template name="setidaname"/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="setidaname"/>
                </xsl:otherwise>
            </xsl:choose>
            <!-- Use flags from parent dlentry, if present -->
            <xsl:apply-templates select="../*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
                                 mode="out-of-line"/>
            <xsl:apply-templates/>
            <xsl:apply-templates select="../*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
            <!--</dt>-->
        </b>
    </xsl:template>

    <!-- DL description -->
    <xsl:template match="*[contains(@class, ' topic/dd ')]" name="topic.dd">
        <xsl:variable name="is-first-dd" select="empty(preceding-sibling::*[contains(@class, ' topic/dd ')])"/>
        <p>
            <!--<dd>-->
            <xsl:for-each select="..">
                <xsl:call-template name="commonattributes"/>
            </xsl:for-each>
            <xsl:call-template name="commonattributes">
                <xsl:with-param name="default-output-class">
                    <xsl:if test="not($is-first-dd)">  <!-- para space before 2 thru N -->
                        <xsl:text>ddexpand</xsl:text>
                    </xsl:if>
                </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="setidaname"/>
            <xsl:apply-templates select="../*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
                                 mode="out-of-line"/>
            <xsl:apply-templates/>
            <xsl:apply-templates select="../*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
            <!--</dd>-->
        </p>
    </xsl:template>

</xsl:stylesheet>
