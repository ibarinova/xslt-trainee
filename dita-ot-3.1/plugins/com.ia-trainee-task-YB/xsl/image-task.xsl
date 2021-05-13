<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes" method="text"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <xsl:variable name="images_list">
            <all_images>
                <xsl:for-each select="descendant::topicref[@href]">
                    <xsl:variable name="base_uri_dir" select="base-uri(@href)"/> <!--шлях до дітамапи-->
                    <xsl:variable name="map_name" select="tokenize($base_uri_dir, '/')[last()]"/>  <!--розділяємо по слешу і беремо останній елемент-->
                    <xsl:variable name="input_dir" select="substring-before($base_uri_dir, $map_name)"/> <!--обрізаємо по останньому елементу-->
                    <xsl:variable name="current_path" select="concat(substring-after($input_dir, 'file:'), @href)"/> <!--прописуємо шлях до папки без 'file:'-->
                    <xsl:variable name="current_doc" select="document($current_path)"/> <!--заходимо в папку-->
                    <xsl:for-each select="$current_doc/descendant::image[@href]"> <!--проходимось по топіку, в якого є нащадок image з @href-->
                        <image>
                            <xsl:value-of select="substring-after($input_dir, 'file:')"/>
                            <xsl:value-of select="@href"/>
                        </image>
                    </xsl:for-each>
                </xsl:for-each>
            </all_images>
        </xsl:variable>
        <xsl:for-each select="$images_list/descendant::image">
            <xsl:variable name="current_img" select="."/>
            <xsl:message> <xsl:value-of select="$current_img"/> </xsl:message>
            <xsl:if test="not(preceding-sibling::image=$current_img)">
                <xsl:value-of select="$current_img"/>
                <xsl:text>&#xA;</xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>


