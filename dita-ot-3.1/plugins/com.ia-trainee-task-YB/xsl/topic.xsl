<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        version="2.0"
        xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:yb="https://www.saxonica.com/html/documentation10/xsl-elements/function.html">

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

    <!--Template-->
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
            ""Hello, Yuliia"
            <xsl:value-of select="$using_transtype"/>
        </xsl:message>
    </xsl:template>

    <!--Template for concept-->
    <xsl:template match="conbody">
        <xsl:for-each select="p">
            <xsl:variable name="element-name" select="name()"/>
            <xsl:variable name="position" select="position()"/>
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
        </xsl:for-each>
    </xsl:template>

    <!--Splitting args.input with tokenize-->
    <xsl:template match="*[contains(@class, ' topic/p ')]" priority="7">
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
    </xsl:template>


    <!--
        &lt;!&ndash;Splitting args.input with recursive&ndash;&gt;
        <xsl:template match="*[contains(@class, ' topic/p ')]" priority="8">
            <xsl:next-match/>
            <div>
                <xsl:call-template name="splitstr">
                    <xsl:with-param name="str" select="$using_input"/>
                    <xsl:with-param name="separator" select="' % '"/>
                </xsl:call-template>
            </div>
        </xsl:template>-->

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
    <!--<xsl:template match="*[contains(@class, ' topic/p ')]" priority="9">
        <xsl:next-match/>
        <div>
            <xsl:copy-of select="yb:split($using_input)"/>
        </div>
    </xsl:template>
-->
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



