<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"   
    xmlns:portal="http://www.enonic.com/cms/xslt/portal"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:stk="http://www.enonic.com/cms/xslt/stk"
	xmlns:bootstrap="http://www.item.no/bootstrap">
	
	<xsl:function name="bootstrap:icon">
 		<xsl:param name="icon" as="xs:string" />
		<xsl:copy-of select="bootstrap:util.createIcon($icon, '')" />		
	</xsl:function>
	
	<xsl:function name="bootstrap:util.createIcon">
 		<xsl:param name="icon" as="xs:string" />
		<xsl:copy-of select="bootstrap:util.createIcon($icon, '')" />		
	</xsl:function>

 	<xsl:function name="bootstrap:util.createIcon">
 		<xsl:param name="icon" as="xs:string" />
	 	<xsl:param name="title" as="xs:string" />
		
		<i class="fa fa-fw {$icon}" title="{$title}">&#160;</i>
	</xsl:function>
</xsl:stylesheet>