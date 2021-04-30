<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output indent="yes"/>

    <xsl:template match="/">
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE bookmap PUBLIC &quot;-//OASIS//DTD DITA BookMap//EN&quot; &quot;bookmap.dtd&quot;&gt;</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="@*|node()" priority="-1">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' bookmap/bookmap ')]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="*[following-sibling::*[contains(@class, ' bookmap/part ')]] except *[contains(@class, ' bookmap/part ')]"/>
            <xsl:apply-templates select="*[contains(@class, ' bookmap/part ')][last()]"/>
            <xsl:apply-templates select="*[preceding-sibling::*[contains(@class, ' bookmap/part ')]] except *[contains(@class, ' bookmap/part ')]"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' bookmap/part ')]">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
        <xsl:apply-templates select="preceding-sibling::*[contains(@class, ' bookmap/part ')][1]"/>
    </xsl:template>


<!--    !!!!!!!!    -->

    <!--<xsl:template match="*[contains(@class, ' bookmap/bookmap ')]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="*[following-sibling::*[contains(@class, ' bookmap/part ')]] except *[contains(@class, ' bookmap/part ')]"/>
            <xsl:apply-templates select="*[contains(@class, ' bookmap/part ')][last()]"/>
            <xsl:apply-templates select="*[preceding-sibling::*[contains(@class, ' bookmap/part ')]] except *[contains(@class, ' bookmap/part ')]"/>
            <xsl:for-each select="descendant::*[contains(@class, ' map/topicref ')][@format = 'ditamap']">
                <xsl:apply-templates select="." mode="add-reltable"/>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' bookmap/part ')]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="*[contains(@class, ' map/topicmeta ')]"/>
            <xsl:apply-templates select="*[contains(@class, ' map/topicref ')][last()]"/>
        </xsl:copy>
        <xsl:apply-templates select="preceding-sibling::*[contains(@class, ' bookmap/part ')][1]"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' map/topicref ')][ancestor::*[contains(@class, ' bookmap/part ')]]">
        <xsl:apply-templates select="." mode="revers"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' map/topicref ')][not(ancestor::*[contains(@class, ' bookmap/bookmap ')])]">
        <xsl:apply-templates select="." mode="revers"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' map/topicref ')]" mode="revers">
        <xsl:choose>
            <xsl:when test="@format = 'ditamap'">
                <xsl:variable name="topicref-uri" select="resolve-uri(@href, base-uri())"/>
                <xsl:choose>
                    <xsl:when test="doc-available($topicref-uri)">
                        <xsl:variable name="topicref-doc" select="document($topicref-uri)"/>
                        <xsl:copy>
                            <xsl:apply-templates select="*[contains(@class, ' map/topicmeta ')]"/>
                            <xsl:apply-templates select="$topicref-doc/*/*[contains(@class, ' map/topicref ')][last()]"/>
                        </xsl:copy>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy>
                            <xsl:apply-templates select="@*"/>
                            <xsl:apply-templates select="*[contains(@class, ' map/topicmeta ')]"/>
                            <xsl:apply-templates select="*[contains(@class, ' map/topicref ')][last()]"/>
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates select="*[contains(@class, ' map/topicmeta ')]"/>
                    <xsl:apply-templates select="*[contains(@class, ' map/topicref ')][last()]"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="preceding-sibling::*[contains(@class, ' map/topicref ')][1]"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' map/topicref ')]" mode="add-reltable">
        <xsl:variable name="topicref-uri" select="resolve-uri(@href, base-uri())"/>
        <xsl:if test="doc-available($topicref-uri)">
            <xsl:variable name="topicref-doc" select="document($topicref-uri)"/>
            <xsl:for-each select="$topicref-doc/descendant::*[contains(@class, ' map/topicref ')][@format='ditamap']">
                <xsl:apply-templates select="." mode="add-reltable"/>
            </xsl:for-each>
            <xsl:apply-templates select="$topicref-doc/descendant::*[contains(@class, ' map/reltable ')]"/>
        </xsl:if>
    </xsl:template>-->

</xsl:stylesheet>