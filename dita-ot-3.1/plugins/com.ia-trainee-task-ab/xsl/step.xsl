<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="*[contains(@class,' task/step ')]" mode="steps">
        <xsl:param name="step_expand"/>
        <xsl:variable name="elName" select="name()"/>
        <xsl:variable name="elNumber" select="position()"/>
        <xsl:variable name="substr" select="concat('Current &lt;', $elName, '&gt; #', $elNumber, ' - ')"/>
        <li>
            <xsl:call-template name="commonattributes">
                <xsl:with-param name="default-output-class"><xsl:if test="$step_expand='yes'">stepexpand</xsl:if></xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="setidaname"/>
            <span class="my_substr"><xsl:value-of select="$substr"/></span>
            <xsl:apply-templates select="." mode="add-step-importance-flag"/>
            <xsl:apply-templates><xsl:with-param name="step_expand" select="$step_expand"/></xsl:apply-templates>
        </li>
    </xsl:template>

</xsl:stylesheet>