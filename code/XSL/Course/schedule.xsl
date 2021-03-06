<?xml version="1.0" encoding="utf-8"?>
<!--
 Copyright 2012 Tufts University

 Licensed under the Educational Community License, Version 1.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.opensource.org/licenses/ecl1.php

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
-->
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">

    <xsl:template match="course">
        <h3 class="title">Schedule</h3>
        <xsl:apply-templates select="./schedule"/>
    </xsl:template>

    <xsl:template match="schedule">
        <xsl:if test="descendant::class-meeting">
            <table width="100%">
		<tr><th align="left">Date</th><th align="left">Time</th>
		<th align="left">Faculty</th><th align="left">Title</th></tr>
	        <xsl:for-each select="./class-meeting">
	            <tr>
		        <td><xsl:value-of select="@meeting-date"/></td>
		        <td><xsl:value-of select="@start-time"/> to <xsl:value-of select="@end-time"/></td>
			<td><xsl:for-each select="./class-meeting-user"><xsl:value-of select="@name"/>
				</xsl:for-each>
			</td>
		        <td>
		            <a href="/hsdb45/class/{parent::schedule/parent::course/@school}/{@class-meeting-id}">
				<xsl:choose>
					<xsl:when test="@title!=''">
					    <xsl:value-of select="@title" disable-output-escaping ="yes"/>
					</xsl:when>
					<xsl:otherwise>
					    See Class Information
					</xsl:otherwise>
				</xsl:choose>
			    </a>
			    <xsl:if test="@type!=''">
				    (<xsl:value-of select="@type" disable-output-escaping ="yes"/>)
			    </xsl:if>
		        </td>
		    </tr>
    	        </xsl:for-each>
	    </table>
	</xsl:if>
    </xsl:template>
</xsl:stylesheet>
