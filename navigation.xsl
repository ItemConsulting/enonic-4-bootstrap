<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:portal="http://www.enonic.com/cms/xslt/portal"
    xmlns:stk="http://www.enonic.com/cms/xslt/stk"
    xmlns:bootstrap="http://www.item.no/bootstrap">
    
    <xsl:import href="../library-stk/stk-variables.xsl"/>    
    <xsl:import href="../library-stk/stk-general.xsl" />
    <xsl:import href="../library-stk/system.xsl"/>    
    <xsl:import href="util.xsl" />

    <xsl:variable name="user" as="element()?" select="/result/context/user"/>

    <!-- To make multilevel menus, use css from: http://codepen.io/ajaypatelaj/pen/prHjD -->

    <!-- Displays menu item name -->
    <xsl:function name="bootstrap:navigation.get-menuitem-name" as="xs:string">
        <xsl:param name="menuitem" as="element()?"/>
        <xsl:value-of select="if (normalize-space($menuitem/menu-name)) then $menuitem/menu-name else $menuitem/display-name"/>
    </xsl:function>

	<xsl:template name="bootstrap:navigation.create-menu">
        <xsl:param name="menuitems" as="element()*" select="/result/menus/menu/menuitems/menuitem"/>
        
        <xsl:param name="levels" as="xs:integer" select="99"/>
        <xsl:param name="current-level" as="xs:integer" select="1"/>
        <xsl:param name="class" as="xs:string?"/>
        <xsl:param name="navbar-class" as="xs:string" select="'navbar-default'"/>
        <xsl:param name="id" as="xs:string?" select="'bootstrap-nav'" />
        <xsl:param name="brand" as="document-node()?" />
        <xsl:param name="container-element" as="xs:string?" select="'nav'"/>          
        <xsl:param name="attr" as="xs:string*"/>
        
        <xsl:if test="$menuitems">
        	<!-- Wrapps menuitems -->
            <xsl:variable name="wrapped-menuitems" as="element()">
                <xsl:choose>
                    <xsl:when test="count($menuitems) = 1 and local-name($menuitems) = 'menuitems'">
                        <xsl:sequence select="$menuitems"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="menuitems" xmlns="">
                            <xsl:sequence select="$menuitems"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            
            <!-- Renders menuitems -->
            <xsl:variable name="rendered-menuitems" as="element()*">
            	<div>
		        	<xsl:attribute name="class" select="'navbar-collapse collapse'" />
		        	
		        	<xsl:if test="normalize-space($id)">
	                    <xsl:attribute name="id">
	                        <xsl:value-of select="$id" />
	                    </xsl:attribute>
	                </xsl:if>
	                <xsl:apply-templates select="$wrapped-menuitems" mode="bootstrap:navigation.create-menu">
	                    <xsl:with-param name="current-level" select="$current-level"/>
	                    <xsl:with-param name="levels" select="$levels" tunnel="yes"/>
	                    <xsl:with-param name="class" select="concat('nav navbar-nav ', $class)"/>                            
	                    <xsl:with-param name="id" select="$id"/>
	                </xsl:apply-templates>
                </div>
                
            </xsl:variable>   
            
            <xsl:choose>
                <xsl:when test="normalize-space($container-element)">
                    <xsl:element name="{$container-element}">
                        <xsl:attribute name="role" select="'navigation'"/>
                        <xsl:attribute name="class" select="concat('navbar ', $navbar-class)"/>
                        <xsl:call-template name="stk:general.add-attributes">
                            <xsl:with-param name="attr" select="$attr"/>
                        </xsl:call-template>
                        
                        <xsl:call-template name="navbar-header">
                            <xsl:with-param name="id" select="$id"/>
                            <xsl:with-param name="brand" select="$brand"/>
                        </xsl:call-template>

                        <xsl:sequence select="$rendered-menuitems"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="$rendered-menuitems"/>
                </xsl:otherwise>
            </xsl:choose> 
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="menuitems" mode="bootstrap:navigation.create-menu">
        <xsl:param name="levels" as="xs:integer" tunnel="yes"/>
        <xsl:param name="current-level" as="xs:integer"/>        
        <xsl:param name="class" as="xs:string?"/>
        <xsl:param name="id" as="xs:string?"/>
        <xsl:if test="$current-level le $levels">
            <ul role="menu">
                <xsl:attribute name="class">
                    <xsl:value-of select="concat('menu-level-', $current-level)"/>
                    <xsl:if test="normalize-space($class)">
                        <xsl:value-of select="concat(' ', $class)" />                        
                    </xsl:if>
                    <xsl:if test="$current-level > 1">
						<xsl:value-of select="' dropdown-menu'" />
                    </xsl:if>
                </xsl:attribute>
                <xsl:apply-templates select="menuitem" mode="bootstrap:navigation.create-menu">
                    <xsl:with-param name="current-level" select="$current-level"/>
                </xsl:apply-templates>
            </ul>
        </xsl:if>        
    </xsl:template>  
    
    <xsl:template match="menuitem" mode="bootstrap:navigation.create-menu">
        <xsl:param name="levels" as="xs:integer" tunnel="yes"/>
        <xsl:param name="current-level" as="xs:integer"/>
        <xsl:param name="icon" select="parameters/parameter[@name = 'icon']" />
        
        <xsl:if test="((@type != 'label') or (@type = 'label' and menuitems)) and not(parameters/parameter[@name='hideFromMenu'] = 'true') and (@type != 'section')">
            <li role="menuitem">
                <xsl:variable name="classes" as="text()*">
                    <xsl:if test="@path = 'true'">
                        <xsl:text>path</xsl:text>
                    </xsl:if>
                    <xsl:if test="@active = 'true'">
                        <xsl:text>active</xsl:text>
                    </xsl:if>
                    <xsl:if test="menuitems/menuitem">
                        <xsl:text>parent dropdown</xsl:text>

                        <xsl:if test="$current-level > 1">
                            <xsl:text>dropdown-submenu</xsl:text>
                        </xsl:if>
                    </xsl:if>                         
                    <xsl:if test="parameters/parameter[@name = 'class']">
                        <xsl:value-of select="parameters/parameter[@name = 'class']"/>
                    </xsl:if>
                </xsl:variable>
                
                <xsl:if test="$classes">
                    <xsl:attribute name="class">
                        <xsl:for-each select="$classes">
                            <xsl:value-of select="."/>
                            <xsl:if test="position() != last()">
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:for-each>    
                    </xsl:attribute>
                </xsl:if>                
                <xsl:if test="@active = 'true'">
                    <xsl:attribute name="aria-selected" select="'true'"/>
                </xsl:if>  
                
                
                <xsl:choose>
                    <xsl:when test="@type = 'label'">
                        <span class="label">                            
                            <xsl:value-of select="bootstrap:navigation.get-menuitem-name(.)"/>
                        </span>
                    </xsl:when>
                    
                    <!-- Toggle dropdown -->
                    <xsl:when test="menuitems/menuitem">
                    	<a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    		<xsl:if test="normalize-space($icon)">
                    			<xsl:copy-of select="bootstrap:icon($icon)" />
                    		</xsl:if>
                    		<xsl:value-of select="bootstrap:navigation.get-menuitem-name(.)"/>
                    		<span class="caret"></span>
                    	</a>
                    </xsl:when>
                    
                    <!-- Go to normal page -->
                    <xsl:otherwise>
                        <a href="{portal:createPageUrl(@key, ())}">
                            <xsl:if test="url/@newwindow = 'yes'">
                                <xsl:attribute name="target" select="'_blank'"/>
                            </xsl:if>
                            
                            <xsl:if test="normalize-space($icon)">
                            	<xsl:copy-of select="bootstrap:icon($icon)" />
                           	</xsl:if>
                            <xsl:value-of select="bootstrap:navigation.get-menuitem-name(.)"/>
                        </a>
                    </xsl:otherwise>
                </xsl:choose>
                
                
                <xsl:apply-templates select="menuitems[menuitem]" mode="bootstrap:navigation.create-menu">
                    <xsl:with-param name="current-level" select="$current-level + 1"/>
                </xsl:apply-templates>
            </li>
        </xsl:if>
    </xsl:template>
	
	<!-- Creates header for navbar with collapsebutton for mobile -->
    <xsl:template name="navbar-header">
    	<xsl:param name="id" as="xs:string?" select="'bootstrap-nav'" />
        <xsl:param name="brand" as="document-node()?" />

    	<div class="navbar-header">
		      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#{$id}">
		        <span class="sr-only">Toggle navigation</span>
		        <span class="icon-bar"></span>
		        <span class="icon-bar"></span>
		        <span class="icon-bar"></span>
		      </button>
	      
	      <a class="navbar-brand visible-xs-inline-block visible-sm-inline-block" href="{portal:createPageUrl($stk:front-page,())}">
              <xsl:copy-of select="$brand" />
          </a>
	    </div>
    </xsl:template>
</xsl:stylesheet>