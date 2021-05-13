<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes"/>
    <xsl:param name="imagesList"/>


    <xsl:template match="/">
        <xsl:text disable-output-escaping="yes">
            &lt;!DOCTYPE map PUBLIC &quot;-//OASIS//DTD DITA Map//EN&quot; &quot;technicalContent/dtd/map.dtd&quot; []&gt;
        </xsl:text>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="@*|node()" priority="-1">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' map/topicref ')]">
        <xsl:copy-of select="."></xsl:copy-of>
        <xsl:variable name="topicref-uri" select="resolve-uri(@href, base-uri())"/>
        <xsl:result-document method="xml" href="{@href}">
            <xsl:text disable-output-escaping="yes">
                &lt;!DOCTYPE concept PUBLIC &quot;-//OASIS//DTD DITA Concept//EN&quot; &quot;technicalContent/dtd/concept.dtd&quot; []&gt;
            </xsl:text>
            <xsl:apply-templates select="document($topicref-uri)"/>
        </xsl:result-document>
    </xsl:template>

    <xsl:variable name="imageListNormalized">
        <images>
            <xsl:for-each select="tokenize($imagesList, '&#10;')">
                <xsl:variable name="imagePath" select="substring-before(., ';')"/>
                <xsl:variable name="newImageName" select="substring-after(., ';')"/>
                <xsl:variable name="imageName" select="tokenize($imagePath, '/')[last()]"/>
                <image href-original="{$imageName}" new-href="{$newImageName}"/>
            </xsl:for-each>
        </images>
    </xsl:variable>

    <xsl:template match="*[contains(@class, ' topic/image ')]/@href">
        <xsl:variable name="currentImageHref" select="."/>
        <xsl:choose>
            <xsl:when test="$imageListNormalized/descendant::image[@href-original=$currentImageHref]">
                <xsl:variable name="reusableImage" select="$imageListNormalized/descendant::image[@href-original=$currentImageHref][1]"/>
                <xsl:attribute name="href" select="$reusableImage/@new-href"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>