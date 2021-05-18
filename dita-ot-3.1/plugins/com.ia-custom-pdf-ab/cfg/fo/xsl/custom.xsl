<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
                version="2.0">

    <xsl:template match="*[contains(@class, ' bookmap/booktitlealt ')]" priority="2">
        <fo:block xsl:use-attribute-sets="__frontmatter__subtitle title.new.color">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' bookmap/booktitle ')]" priority="2">
        <fo:block xsl:use-attribute-sets="__frontmatter__booklibrary">
            <xsl:apply-templates select="*[contains(@class, ' bookmap/booklibrary ')]"/>
        </fo:block>
        <fo:block xsl:use-attribute-sets="__frontmatter__mainbooktitle" axf:color="#ff6800">
            <xsl:apply-templates select="*[contains(@class,' bookmap/mainbooktitle ')]"/>
        </fo:block>
    </xsl:template>

    <!--<xsl:template match="*" mode="processTopicChapterInsideFlow">
        <fo:block xsl:use-attribute-sets="topic">
            <xsl:call-template name="commonattributes"/>
            <xsl:variable name="level" as="xs:integer">
                <xsl:apply-templates select="." mode="get-topic-level"/>
            </xsl:variable>
            <xsl:if test="$level eq 1">
                <fo:marker marker-class-name="current-topic-number">
                    <xsl:variable name="topicref" select="key('map-id', ancestor-or-self::*[contains(@class, ' topic/topic ')][1]/@id)"/>
                    <xsl:for-each select="$topicref">
                        <xsl:apply-templates select="." mode="topicTitleNumber"/>
                    </xsl:for-each>
                </fo:marker>
                <xsl:apply-templates select="." mode="insertTopicHeaderMarker"/>
            </xsl:if>
            <xsl:apply-templates select="." mode="customTopicMarker"/>

            <xsl:apply-templates select="*[contains(@class,' topic/prolog ')]"/>

            <xsl:apply-templates select="." mode="insertChapterFirstpageStaticContent">
                <xsl:with-param name="type" select="'chapter'"/>
            </xsl:apply-templates>

            <fo:block xsl:use-attribute-sets="topic.title title.new.color">
                <xsl:apply-templates select="." mode="customTopicAnchor"/>
                <xsl:call-template name="pullPrologIndexTerms"/>
                <xsl:for-each select="*[contains(@class,' topic/title ')]">
                    <xsl:apply-templates select="." mode="getTitle"/>
                </xsl:for-each>
            </fo:block>

            <xsl:choose>
                <xsl:when test="$chapterLayout='BASIC'">
                    <xsl:apply-templates select="*[not(contains(@class, ' topic/topic ') or contains(@class, ' topic/title ') or
                                                     contains(@class, ' topic/prolog '))]"/>
                    &lt;!&ndash;xsl:apply-templates select="." mode="buildRelationships"/&ndash;&gt;
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="." mode="createMiniToc"/>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:apply-templates select="*[contains(@class,' topic/topic ')]"/>
            <xsl:call-template name="pullPrologIndexTerms.end-range"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*" mode="processTopicPartInsideFlow">
        <fo:block xsl:use-attribute-sets="topic">
            <xsl:call-template name="commonattributes"/>
            <xsl:if test="empty(ancestor::*[contains(@class, ' topic/topic ')])">
                <fo:marker marker-class-name="current-topic-number">
                    <xsl:variable name="topicref" select="key('map-id', ancestor-or-self::*[contains(@class, ' topic/topic ')][1]/@id)"/>
                    <xsl:for-each select="$topicref">
                        <xsl:apply-templates select="." mode="topicTitleNumber"/>
                    </xsl:for-each>
                </fo:marker>
                <xsl:apply-templates select="." mode="insertTopicHeaderMarker"/>
            </xsl:if>
            <xsl:apply-templates select="." mode="customTopicMarker"/>

            <xsl:apply-templates select="*[contains(@class,' topic/prolog ')]"/>

            <xsl:apply-templates select="." mode="insertChapterFirstpageStaticContent">
                <xsl:with-param name="type" select="'part'"/>
            </xsl:apply-templates>

            <fo:block xsl:use-attribute-sets="topic.title title.new.color">
                <xsl:apply-templates select="." mode="customTopicAnchor"/>
                <xsl:call-template name="pullPrologIndexTerms"/>
                <xsl:for-each select="*[contains(@class,' topic/title ')]">
                    <xsl:apply-templates select="." mode="getTitle"/>
                </xsl:for-each>
            </fo:block>

            <xsl:choose>
                <xsl:when test="$partLayout='BASIC'">
                    <xsl:apply-templates select="*[not(contains(@class, ' topic/topic ') or contains(@class, ' topic/title ') or
                                                     contains(@class, ' topic/prolog '))]"/>
                    &lt;!&ndash;xsl:apply-templates select="." mode="buildRelationships"/&ndash;&gt;
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="." mode="createMiniToc"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:for-each select="*[contains(@class,' topic/topic ')]">
                <xsl:variable name="topicType" as="xs:string">
                    <xsl:call-template name="determineTopicType"/>
                </xsl:variable>
                <xsl:if test="$topicType = 'topicSimple'">
                    <xsl:apply-templates select="."/>
                </xsl:if>
            </xsl:for-each>
            <xsl:call-template name="pullPrologIndexTerms.end-range"/>
        </fo:block>
    </xsl:template>-->

    <xsl:attribute-set name="title.new.color">
        <xsl:attribute name="color">#ff6800</xsl:attribute>
    </xsl:attribute-set>


    <!-- kolontytul -->
    <xsl:template name="insertFrontMatterLastHeader">
        <fo:static-content flow-name="last-frontmatter-header"/>
    </xsl:template>

    <xsl:template name="insertFrontMatterOddHeader">
        <fo:static-content flow-name="odd-frontmatter-header"/>
    </xsl:template>

    <xsl:template name="insertTocEvenHeader">
        <fo:static-content flow-name="even-toc-header"/>
    </xsl:template>

    <xsl:template name="insertTocOddHeader">
        <fo:static-content flow-name="odd-toc-header"/>
    </xsl:template>

    <xsl:template name="insertPrefaceFirstHeader">
        <fo:static-content flow-name="first-body-header"/>
    </xsl:template>

    <xsl:template name="insertBodyOddHeader">
        <fo:static-content flow-name="odd-body-header"/>
    </xsl:template>

    <xsl:template name="insertBodyLastHeader">
        <fo:static-content flow-name="last-body-header"/>
    </xsl:template>

    <xsl:template name="insertPrefaceLastHeader">
        <fo:static-content flow-name="last-body-header"/>
    </xsl:template>

    <xsl:template name="insertIndexOddHeader">
        <fo:static-content flow-name="odd-index-header"/>
    </xsl:template>

    <xsl:template name="insertGlossaryOddHeader">
        <fo:static-content flow-name="odd-glossary-header"/>
    </xsl:template>

</xsl:stylesheet>