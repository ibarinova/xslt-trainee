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

    <xsl:template match="*" mode="process.note.common-processing">
        <xsl:param name="type" select="@type"/>
        <xsl:param name="title">
            <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="concat(upper-case(substring($type, 1, 1)), substring($type, 2))"/>
            </xsl:call-template>
        </xsl:param>
        <xsl:message>---------- YB <xsl:value-of select="$using_transtype"/>---------
        </xsl:message>
        <xsl:choose>
            <xsl:when test="$using_transtype = 'ia-webhelp-responsive-YB'">
                <xsl:message>---------- 1 ---------</xsl:message>

                <div>
                    <xsl:call-template name="commonattributes">
                        <xsl:with-param name="default-output-class"
                                        select="string-join(($type, concat('create_note_', $type)), ' ')"/>
                    </xsl:call-template>
                    <xsl:call-template name="setidaname"/>
                    <!-- Normal flags go before the generated title; revision flags only go on the content. -->
                    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/prop"
                                         mode="ditaval-outputflag"/>
                    <span class="create_note__title">
                        <xsl:copy-of select="$title"/>
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="'ColonSymbol'"/>
                        </xsl:call-template>
                    </span>
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/revprop"
                                         mode="ditaval-outputflag"/>
                    <xsl:apply-templates/>
                    <!-- Normal end flags and revision end flags both go out after the content. -->
                    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>---------- 2 ---------</xsl:message>
                <xsl:next-match/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <!--Template for concept-->
    <xsl:template match="conbody/p">
            <xsl:variable name="element-name" select="name()"/>
            <xsl:variable name="position" select="count(preceding-sibling::p)+1"/>
            <xsl:element name="{$element-name}">
                <xsl:attribute name="class">
                    <xsl:choose>
                        <xsl:when test="$position mod 2 = 0">
                            <xsl:value-of select="'even_p'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'odd_p'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:if test="@id">
                    <xsl:attribute name="id" select="@id"/> <!--applying id (in <p>)-->
                </xsl:if>
                <xsl:value-of select="concat('Current &lt;', $element-name,'&gt; #',$position, ' ')"/>
                <xsl:apply-templates select="node()"/> <!--applying all content after conversation 'Current...'-->
            </xsl:element>
    </xsl:template>
</xsl:stylesheet>

