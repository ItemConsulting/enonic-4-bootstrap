<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:portal="http://www.enonic.com/cms/xslt/portal"
    xmlns:stk="http://www.enonic.com/cms/xslt/stk"
    xmlns:bootstrap="http://www.item.no/bootstrap">
    
    <xsl:import href="util.xsl"/> 
    <xsl:import href="../library-stk/stk-variables.xsl"/>    
    <xsl:import href="../library-stk/stk-general.xsl" />
    <xsl:import href="../library-stk/system.xsl"/>

    <xsl:param name="title"/>
    <xsl:param name="title-icon"/>
    <xsl:param name="footer-text"/>
    <xsl:param name="footer-link">
        <type>page</type>
    </xsl:param>
    <xsl:param name="class"/>
    <xsl:param name="body">
        <type>content</type>
    </xsl:param>

    <xsl:variable name="allowedSymbols" select="'abcdefghijklmnopqrstuvwxyz-'"/>

    <xsl:template match="/">
        <xsl:call-template name="bootstrap:panel.create-panel">
            <xsl:with-param name="icon" select="$title-icon" />
            <xsl:with-param name="title" select="$title" />
            <xsl:with-param name="class" select="$class" />
            <xsl:with-param name="body">
                <xsl:value-of select="$body" disable-output-escaping="yes"/>
            </xsl:with-param>
            <xsl:with-param name="footer">
                <xsl:if test="$footer-text">
                    <a href="{portal:createPageUrl($footer-link,())}">
                        <i class="fa fa-link">&#160;</i>
                        <xsl:value-of select="$footer-text" />
                    </a>
                </xsl:if>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

	<xsl:template name="bootstrap:panel.create-panel">
		<xsl:param name="id" select="generate-id()" />
		<xsl:param name="body" />
		<xsl:param name="title" />
		<xsl:param name="icon" />
        <xsl:param name="heading" />
        <xsl:param name="footer" />
        <xsl:param name="class" select="'panel-default'" />
        <xsl:param name="heading-class" select="''" />
        <xsl:param name="type" select="'section'" />
        <xsl:param name="itemId" select="bootstrap:stripSpecial($id)" />
        
        <!-- collapsable needs id to be set -->
        <xsl:param name="collapsable" as="xs:boolean" select="false()" />
        <xsl:param name="expanded" as="xs:boolean" select="false()" />

		<xsl:element name="{$type}">
			<xsl:attribute name="class" select="concat('panel ', $class)" />
			
			<xsl:if test="normalize-space($heading) or normalize-space($title)">
				<div class="panel-heading {$heading-class}">
					<h4 class="panel-title">
						<!-- Icon -->
                        <xsl:if test="$icon" >
                            <xsl:copy-of select="bootstrap:icon($icon)" />
                        </xsl:if>

				       	<xsl:choose>
				       		<!-- Toggle link -->
				       		<xsl:when test="$collapsable=true()">
					       		<a data-toggle="collapse" data-parent="#accordion" href="#{$itemId}">
	        						<xsl:value-of select="$title" />
	        					</a>
				       		</xsl:when>
				       		
				       		<!-- Title as text -->
				       		<xsl:otherwise>
				       			<xsl:value-of select="$title" disable-output-escaping="yes"  />
				       		</xsl:otherwise>
				       	</xsl:choose>

						<!-- Ekstra heading -->
				       	<xsl:copy-of select="$heading" />
					</h4>
				</div>
			</xsl:if>
			
			<div id="{$itemId}">
				<xsl:attribute name="class">
					<xsl:if test="$collapsable=true()">panel-collapse collapse</xsl:if>
					<xsl:if test="$expanded=true()"> in</xsl:if>
				</xsl:attribute>
				
				<div class="panel-body">
					<xsl:apply-templates select="$body" mode="bootstrap:panel.renderBody"/>
				</div>
			</div>
			
			<xsl:if test="normalize-space($footer)">
				<div class="panel-footer">
					<xsl:copy-of select="$footer" />
				</div>
			</xsl:if>
		</xsl:element>		
	</xsl:template>

    <xsl:function name="bootstrap:stripSpecial">
        <xsl:param name="input-string" as="xs:string" />
        <xsl:variable name="str" select="lower-case(translate($input-string, ' ', '-'))" />
        <xsl:variable name="str" select="translate(translate(translate($str, 'ø', 'o'), 'æ', 'ae'), 'å', 'a')" />

        <xsl:variable name="illegal-characters" select="translate($str, $allowedSymbols, '')" />
        <xsl:value-of select="translate($str, $illegal-characters, '')"/>
    </xsl:function>
	
	<xsl:template match="element()" mode="bootstrap:panel.renderBody">
		<xsl:copy-of select="." />
	</xsl:template>
	
	<xsl:template match="text()" mode="bootstrap:panel.renderBody">
		<xsl:value-of select="." disable-output-escaping="yes"/>
	</xsl:template>
</xsl:stylesheet>