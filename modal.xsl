<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"   
    xmlns:portal="http://www.enonic.com/cms/xslt/portal"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:stk="http://www.enonic.com/cms/xslt/stk"
	xmlns:bootstrap="http://www.item.no/bootstrap">

	<xsl:import href="../library-stk/system.xsl" />

	<xsl:template name="bootstrap:modal.create-modal">
		<xsl:param name="id" as="xs:string" />
		<xsl:param name="title" as="xs:string" />
		<xsl:param name="icon" as="xs:string" select="''" />
		<xsl:param name="body" />
		<xsl:param name="footer" />
		
		<div class="modal fade" id="{$id}" tabindex="-1" role="dialog" aria-labelledby="{$id}Label" aria-hidden="true">

			<div class="modal-dialog">
				<div class="modal-content">
				
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">
							<span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title" id="${id}Label">
							<i class="fa fa-fw {$icon}">&#160;</i>
							<xsl:value-of select="$title" />
						</h4>
					</div>
					
					<div class="modal-body">
						<xsl:copy-of select="$body" />
					</div>
					
					<xsl:if test="$footer" >
						<div class="modal-footer">
							<xsl:copy-of select="$footer" />
						</div>
					</xsl:if>
				</div>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>								