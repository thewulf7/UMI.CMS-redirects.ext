<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "ulang://common" [
        <!ENTITY seo-redirects-status 'Статус'>
        <!ENTITY seo-redirects-from        'Старое назначение'>
        <!ENTITY seo-redirects-to    'Новое назначение'>
        <!ENTITY seo-redirects-remove    'Удалить'>
        ]>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/result[@method = 'redirects']/data[@type = 'list' and @action = 'modify']">
        <form action="" method="post">
            <table class="tableContent">
                <thead>
                    <tr>
                        <th>
                            <span>
                                <xsl:text>&seo-redirects-from;</xsl:text>
                            </span>
                        </th>
                        <th>
                            <span>
                                <xsl:text>&seo-redirects-to;</xsl:text>
                            </span>
                        </th>
                        <th>
                            <span>
                                <xsl:text>&seo-redirects-status;</xsl:text>
                            </span>
                        </th>
                        <th>
                            <span>
                                <xsl:text>&seo-redirects-remove;</xsl:text>
                            </span>
                        </th>
                    </tr>
                </thead>

                <tbody>
                    <xsl:apply-templates select="links/link" mode="list-modify">
                        <xsl:with-param name="statuses" select="statuses"/>
                    </xsl:apply-templates>

                    <xsl:call-template name="newline" mode="list-modify">
                        <xsl:with-param name="loop" select="new"/>
                        <xsl:with-param name="statuses" select="statuses"/>
                    </xsl:call-template>
                </tbody>
            </table>
            <xsl:call-template name="std-save-button"/>
        </form>
    </xsl:template>


    <xsl:template match="link" mode="list-modify">
        <xsl:param name="statuses"/>
        <tr>
            <td>
                <input type="text" name="data[old][{@id}][source]" value="{source}"/>
            </td>

            <td>
                <input type="text" name="data[old][{@id}][target]" value="{target}"/>
            </td>

            <td align="center" width="52">
                <select name="data[old][{@id}][status]">
                    <xsl:apply-templates select="$statuses/status" mode="list-modify">
                        <xsl:with-param name="active" select="@status"/>
                    </xsl:apply-templates>
                </select>
            </td>

            <td align="center" width="52">
                <input type="checkbox" name="data[dels][]" value="{@id}" class="check"/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="status" mode="list-modify">
        <xsl:param name="active"/>
        <option value="{node()}">
            <xsl:if test="$active=node()">
                <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>
            <xsl:value-of select="node()"/>
        </option>
    </xsl:template>

    <xsl:template name="newline" mode="list-modify">
        <xsl:param name="loop"/>
        <xsl:param name="statuses"/>
        <xsl:for-each select="$loop/item">
            <tr>
                <td>
                    <input type="text" name="data[new][{position()}][source]"/>
                </td>

                <td>
                    <input type="text" name="data[new][{position()}][target]"/>
                </td>

                <td align="center" width="52">
                    <select name="data[new][{position()}][status]">
                        <xsl:apply-templates select="$statuses/status" mode="list-modify">
                            <xsl:with-param name="active">301</xsl:with-param>
                        </xsl:apply-templates>
                    </select>
                </td>

                <td colspan="1" width="52"/>
            </tr>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>