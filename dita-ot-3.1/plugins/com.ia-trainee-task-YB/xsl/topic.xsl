<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        version="2.0"
        xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:param name="create"/>

    <xsl:template match="*" mode="process.note.common-processing" priority="100">
        <xsl:param name="type" select="@type"/>
        <xsl:param name="title">
            <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="concat(upper-case(substring($type, 1, 1)), substring($type, 2))"/>
            </xsl:call-template>
        </xsl:param>
        <xsl:message>---------- YB ---------</xsl:message>
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

    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/p ')]" name="topic.p">
        <!-- To ensure XHTML validity, need to determine whether the DITA kids are block elements.
             If so, use div_class="p" instead of p -->
        <xsl:choose>
            <xsl:when test="descendant::*[dita-ot:is-block(.)]">
                <div class="p">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:call-template name="setid"/>
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <xsl:call-template name="commonattributes"/>
                    <xsl:call-template name="setid"/>
                    <xsl:apply-templates/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:message>
            ""Hello, Yuliia" <xsl:value-of select="$create"/>
        </xsl:message>
    </xsl:template>

    <!--<xsl:template match="conbody/p">
    <xsl:param name="type" select="@type"/>
    <xsl:param name="title">
        <xsl:call-template name="getVariable">
        <xsl:with-param name="default-output-class"
                        select="substring-join(($type, concat('Current', $type)), ' ')"/>
    </xsl:call-template>
    </xsl:param>
    </xsl:template>-->

    <xsl:template match="conbody">
    <xsl:for-each select="p">
            <xsl:variable name="element-name" select ="name()"/>
            <xsl:variable name="position" select="position()"/>
            <xsl:element name ="{$element-name}">
                <xsl:attribute name="class">
                    <xsl:choose>
                        <xsl:when test="$position mod 2 = 0">
                            <xsl:value-of select ="'even_p'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select ="'odd_p'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:if test="@id">
                    <xsl:attribute name="id" select="@id"/> <!--applying id (in <p>)-->
                </xsl:if>
                <xsl:value-of select="concat('Current &lt;', $element-name,'&gt; #',$position, ' ')"/>
                <xsl:apply-templates select="node()"/> <!--applying all content after conversation 'Current...'-->
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>