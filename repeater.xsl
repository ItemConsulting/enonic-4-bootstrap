<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
	xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:stk="http://www.enonic.com/cms/xslt/stk"
    xmlns:portal="http://www.enonic.com/cms/xslt/portal"
	xmlns:bootstrap="http://www.item.no/bootstrap">

	<xsl:import href="../library-stk/stk-variables.xsl" />
	<xsl:import href="../library-stk/stk-general.xsl" />
	<xsl:import href="../library-stk/system.xsl" />

	<xsl:output indent="no" media-type="text/html" method="xhtml" omit-xml-declaration="yes"/>

	<xsl:template name="bootstrap:fuelux.repeater">
		<xsl:param name="title" />
		<xsl:param name="filters" />
		<xsl:param name="header-left" />
		
		<xsl:param name="show-search" as="xs:boolean" select="false()" />
		<xsl:param name="id" required="yes" />
	
		<div class="repeater" id="{$id}">
			<!-- HEADER -->
			<div class="repeater-header">
				<div class="repeater-header-left">
					<span class="repeater-title"><xsl:copy-of select="$title" /></span>
					<xsl:copy-of select="$header-left" />
					
					<xsl:if test="$show-search">
						<div class="repeater-search">
							<div class="search input-group">
								<input type="search" class="form-control" placeholder="{portal:localize('bootstrap.search')}" />
								<span class="input-group-btn">
									<button class="btn btn-default" type="button">
										<span class="glyphicon glyphicon-search"></span>
										<span class="sr-only"><xsl:value-of select="portal:localize('bootstrap.search')"/></span>
									</button>
								</span>
							</div>
						</div>
					</xsl:if>
				</div>
				
				<!-- HEADER RIGHT -->
				<div class="repeater-header-right">
					<xsl:if test="$filters">
						<div class="btn-group selectlist repeater-filters" data-resize="auto">
					        <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
					          <span class="selected-label">&#160;</span>
					          <span class="caret"></span>
					          <span class="sr-only">Toggle Filters</span>
					        </button>
					        
					        <ul class="dropdown-menu" role="menu">
					          <li data-value="" data-selected="true"><a href="#">Alle</a></li>
					          
					          <xsl:for-each select="tokenize($filters, ',')">
					          	<li data-value="{.}"><a href="#"><xsl:value-of select="." /></a></li>
					          </xsl:for-each>
					        </ul>
					        
					        <input class="hidden hidden-field" name="filterSelection" readonly="readonly" aria-hidden="true" type="text"/>
					      </div>
				      </xsl:if>
				
					<div class="btn-group repeater-views" data-toggle="buttons">
						<label class="btn btn-default active">
							<input name="repeaterViews" type="radio" value="list" />
							<span class="glyphicon glyphicon-list" />
						</label>
						<label class="btn btn-default">
							<input name="repeaterViews" type="radio" value="thumbnail" />
							<span class="glyphicon glyphicon-th" />
						</label>
					</div>
				</div>
			</div>
			
			<!-- VIEWPORT -->
			<div class="repeater-viewport">
				<div class="repeater-canvas"></div>
				<div class="loader repeater-loader"></div>
			</div>
			
			<!-- FOOTER -->
			<div class="repeater-footer">
				<div class="repeater-footer-left">
					<div class="repeater-itemization">
						<span>
							<span class="repeater-start"></span>
							-
							<span class="repeater-end"></span>
							<xsl:value-of select="concat(' ', portal:localize('bootstrap.form.repeater.of'))"/>
							<span class="repeater-count"></span>
							<xsl:value-of select="concat(' ', portal:localize('bootstrap.form.repeater.answers'))"/>
						</span>
						<div class="btn-group selectlist" data-resize="auto">
							<button type="button" class="btn btn-default dropdown-toggle"
								data-toggle="dropdown">
								<span class="selected-label">&#160;</span>
								<span class="caret"></span>
								<span class="sr-only">Toggle Dropdown</span>
							</button>
							<ul class="dropdown-menu" role="menu">
								<li data-value="5">
									<a href="#">5</a>
								</li>
								<li data-value="10">
									<a href="#">10</a>
								</li>
								<li data-value="20">
									<a href="#">20</a>
								</li>
								<li data-value="50" data-selected="true">
									<a href="#">50</a>
								</li>
								<li data-value="100">
									<a href="#">100</a>
								</li>
							</ul>
							<input class="hidden hidden-field" name="itemsPerPage"
								readonly="readonly" aria-hidden="true" type="text" />
						</div>
						<span><xsl:value-of select="portal:localize('bootstrap.form.repeater.per-page')"/></span>
					</div>
				</div>
				
				<!-- FOOTER RIGHT -->
				<div class="repeater-footer-right">
					<div class="repeater-pagination">
						<button type="button" class="btn btn-default btn-sm repeater-prev">
							<span class="glyphicon glyphicon-chevron-left"></span>
							<span class="sr-only"><xsl:value-of select="portal:localize('bootstrap.form.repeater.previous-page')"/></span>
						</button>
						<label class="page-label" id="myPageLabel"><xsl:value-of select="portal:localize('bootstrap.form.repeater.page')"/></label>
						<div class="repeater-primaryPaging active">
							<div class="input-group input-append dropdown combobox">
								<input type="text" class="form-control" aria-labelledby="myPageLabel" />
								<div class="input-group-btn">
									<button type="button" class="btn btn-default dropdown-toggle"
										data-toggle="dropdown">
										<span class="caret"></span>
										<span class="sr-only">Toggle Dropdown</span>
									</button>
									<ul class="dropdown-menu dropdown-menu-right"></ul>
								</div>
							</div>
						</div>
						<input type="text" class="form-control repeater-secondaryPaging"
							aria-labelledby="myPageLabel" />
						<span>
							<xsl:value-of select="portal:localize('bootstrap.form.repeater.of')"/>
							<span class="repeater-pages"></span>
						</span>
						<button type="button" class="btn btn-default btn-sm repeater-next">
							<span class="glyphicon glyphicon-chevron-right"></span>
							<span class="sr-only"><xsl:value-of select="portal:localize('bootstrap.form.repeater.next-page')"/></span>
						</button>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>