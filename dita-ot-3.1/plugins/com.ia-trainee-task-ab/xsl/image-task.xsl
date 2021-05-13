<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes" method="text"/>

    <xsl:template match="/">
        <xsl:variable name="images-list">
            <body>
                <xsl:for-each select="descendant::*[contains(@class, ' map/topicref ')]">
                    <xsl:variable name="topicref-uri" select="resolve-uri(@href, base-uri())"/>
                    <xsl:if test="doc-available(substring-after($topicref-uri, 'file:'))">
                        <xsl:variable name="topicref-doc" select="document($topicref-uri)"/>
                        <xsl:for-each select="$topicref-doc/descendant::*[contains(@class, ' map/topicref ')][@format='ditamap']">
                            <xsl:apply-templates select="."/>
                        </xsl:for-each>
                        <xsl:apply-templates select="$topicref-doc/descendant::*[contains(@class, ' topic/image ')]"/>
                    </xsl:if>
                </xsl:for-each>
            </body>
        </xsl:variable>
        <!--        <xsl:for-each select="$images-list/descendant::img[not(.=preceding::*)]">-->
        <xsl:for-each select="$images-list/descendant::img">
            <xsl:value-of select="."/>
            <xsl:text>&#10;</xsl:text>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/image ')]">
        <xsl:variable name="file-path" select="substring-after(resolve-uri(base-uri()), 'file:')"/>
        <xsl:variable name="file-name" select="tokenize($file-path, '/')[last()]"/>
        <xsl:variable name="topic-name" select="document($file-path)/child::*/child::*[contains(@class, ' topic/title ')]"/>
        <img>
            <xsl:choose>
                <xsl:when test="preceding::*[contains(@class, ' topic/image ')]">
                    <xsl:value-of select="concat(substring-before($file-path, $file-name), @href, ';',
                        lower-case(translate($topic-name, ' ', '_')), '_', count(preceding::*[contains(@class, ' topic/image ')])+1,
                        '.', substring-after(normalize-space(@href), '.'))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat(substring-before($file-path, $file-name), @href, ';',
                        lower-case(translate($topic-name, ' ', '_')), '_1',
                        '.', substring-after(@href, '.'))"/>
                </xsl:otherwise>
            </xsl:choose>
        </img>
    </xsl:template>

</xsl:stylesheet>