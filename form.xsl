<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:portal="http://www.enonic.com/cms/xslt/portal"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:stk="http://www.enonic.com/cms/xslt/stk"
	xmlns:bootstrap="http://www.item.no/bootstrap"
    xmlns:json="http://json.org/">

	<xsl:import href="util.xsl"/> 
    <xsl:import href="../json/xml-to-json.xsl" />
	
	<xsl:variable name="default-cols" select="8" />
	<xsl:variable name="default-label-cols" select="4" />
	<xsl:variable name="skip-root" select="true()" />
	
	<xsl:template name="bootstrap:form.createInputField" as="element()">
		<xsl:param name="id" as="xs:string" select="generate-id()" />
		<xsl:param name="name" as="xs:string" required="yes" />
		<xsl:param name="title" />
		<xsl:param name="type" />
		<xsl:param name="placeholder" select="''" />
		<xsl:param name="required" select="false()" />
		<xsl:param name="suffix" />
		<xsl:param name="error" />
		<xsl:param name="label" tunnel="yes"  />
		<xsl:param name="value"  />
		<xsl:param name="cols" as="xs:integer" select="$default-cols" />
	
		<div>
			<xsl:attribute name="class">
				<xsl:value-of select="concat('form-group ', lower-case($label))" />
				<xsl:if test="$error">
					<xsl:attribute name="class" select="' has-error'" />
				</xsl:if>
			</xsl:attribute>
			<xsl:if test="$type = 'hidden'">
				<xsl:attribute name="style" select="'display: none;'" />
			</xsl:if>
		
			<xsl:call-template name="bootstrap:form.renderLabel">
				<xsl:with-param name="id" select="$id" />
				<xsl:with-param name="title" select="$title" />
				<xsl:with-param name="required" select="$required" />
			</xsl:call-template>
			
			<xsl:call-template name="bootstrap:form.renderInputField">
				<xsl:with-param name="id" select="$id" />
				<xsl:with-param name="name" select="$name" />
				<xsl:with-param name="title" select="$title" />
				<xsl:with-param name="type" select="$type" />
				<xsl:with-param name="placeholder" select="$placeholder" />
				<xsl:with-param name="required" select="$required" />
				<xsl:with-param name="suffix" select="$suffix" />
				<xsl:with-param name="value"  select="$value" />
				<xsl:with-param name="cols"  select="$cols" />
				<xsl:with-param name="error" select="$error" />
			</xsl:call-template>
	   </div>
	</xsl:template>
	
	
	<xsl:template name="bootstrap:form.renderInputField" as="element()">
		<xsl:param name="id" as="xs:string" select="generate-id()" />
		<xsl:param name="name" as="xs:string" required="yes" />
		<xsl:param name="title" />
		<xsl:param name="type" select="'text'" />
		<xsl:param name="placeholder" select="''" />
		<xsl:param name="required" select="false()" />
		<xsl:param name="suffix" />
		<xsl:param name="error" />
		<xsl:param name="value"  />
		<xsl:param name="cols" as="xs:integer" select="$default-cols" />
	
	    <div class="col-sm-{$cols}">
	    	<div>
	    		<xsl:if test="normalize-space($suffix) or $error">
		    		<xsl:attribute name="class" select="'input-group'" />
		    	</xsl:if>
		    	
		    	<xsl:if test="$error">
		    		<span class="input-group-addon" title="{$error}">
		    			<i class="fa fa-exclamation-triangle" />
		    		</span>
		    	</xsl:if>
		    	
		    	<input value="{$value}" type="{if(normalize-space($type)) then $type else 'text'}" class="form-control" id="{$id}" title="{$title}" name="{$name}" placeholder="{$placeholder}">
			    	<xsl:if test="$required">
			    		<xsl:attribute name="required" select="''" />
		    		</xsl:if>
		    	</input>
		    	
		    	<!-- subfix of input group -->
		    	<xsl:if test="normalize-space($suffix)">
		    		<span class="input-group-addon"><xsl:value-of select="$suffix" /></span>
		    	</xsl:if>
	    	</div>
	    </div>
	</xsl:template>
	
	
 	<xsl:template name="bootstrap:form.createTextArea" as="element()">
		<xsl:param name="id" as="xs:string" select="generate-id()" />
		<xsl:param name="name" as="xs:string" required="yes" />
		<xsl:param name="label" as="xs:string" required="yes" tunnel="yes" />
		<xsl:param name="title" />
		<xsl:param name="labelClass" select="''" />
		<xsl:param name="type" select="'text'" />
		<xsl:param name="placeholder" select="''" />
		<xsl:param name="required" select="false()" />
		<xsl:param name="cols" as="xs:integer" select="$default-cols" />
		<xsl:param name="error" />
	
		<div class="form-group">
			<xsl:if test="$error">
				<xsl:attribute name="class" select="'form-group has-error'" />
			</xsl:if>
		
		   <xsl:call-template name="bootstrap:form.renderLabel">
				<xsl:with-param name="id" select="$id" />
				<xsl:with-param name="title" select="$title" />
				<xsl:with-param name="required" select="$required" />
			</xsl:call-template>
		    
		    <div class="col-sm-{$cols}">
		    	<textarea class="form-control" id="{$id}" title="{$title}" name="{$name}" placeholder="{$placeholder}" rows="4">
			    	<xsl:if test="$required">
			    		<xsl:attribute name="required" select="''" />
		    		</xsl:if>
		    	</textarea>
		    </div>
	   </div>
	</xsl:template>
	
	<xsl:template name="bootstrap:form.createRadioButtons" as="element()">
		<xsl:param name="id" as="xs:string" select="generate-id()" />
		<xsl:param name="title" />
		<xsl:param name="options" />
		<xsl:param name="cols" as="xs:integer" select="$default-cols" />
		<xsl:param name="error" />
	
		<div class="form-group">
			<xsl:if test="$error">
				<xsl:attribute name="class" select="'form-group has-error'" />
			</xsl:if>
		
	      	<xsl:call-template name="bootstrap:form.renderLabel">
	       		<xsl:with-param name="id" select="$id" />
				<xsl:with-param name="title" select="$title" />
	       	</xsl:call-template>
	       	
	        <div class="col-lg-{$cols}">
	        	<xsl:copy-of select="$options" />
	        </div>
        </div>
	</xsl:template>
	
	<xsl:template name="bootstrap:form.createRadioButton" as="element()">
		<xsl:param name="id" as="xs:string" select="generate-id()" />
		<xsl:param name="name" as="xs:string" required="yes" />
		<xsl:param name="value" as="xs:string" required="yes" />
		<xsl:param name="required" as="xs:boolean" select="false()" />
		<xsl:param name="checked" select="false()" />
		<xsl:param name="type" select="'radio'" />
	
	    <div class="{$type}">
			<label for="{$id}" class="{$type}">
				<input id="{$id}" name="{$name}" type="{$type}" class="radio {if($required) then 'required' else ''}" value="{$value}">
					<xsl:if test="$checked">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
            	</input>
            
            	<xsl:value-of select="$value"/>
			</label>
		</div>
	</xsl:template>

	<xsl:template name="bootstrap:form.createSelect" as="element()">
		<xsl:param name="id" as="xs:string" select="generate-id()" />
		<xsl:param name="name" as="xs:string" required="yes" />
		<xsl:param name="title" />
		<xsl:param name="options" />
		<xsl:param name="required" />
		<xsl:param name="cols" as="xs:integer" select="$default-cols" />
		<xsl:param name="error" />
		<xsl:param name="class" select="''" />
		<xsl:param name="label" tunnel="yes" />
	
		<div>
			<xsl:attribute name="class">
				<xsl:value-of select="concat('form-group ', lower-case($label))" />
				<xsl:value-of select="concat(' ', $class)" />
				<xsl:if test="$error">
					<xsl:value-of select="' has-error'" />
				</xsl:if>
			</xsl:attribute>
		
			<xsl:if test="$label">
				<xsl:call-template name="bootstrap:form.renderLabel">
			       	<xsl:with-param name="id" select="$id" />
			       	<xsl:with-param name="title" select="$title" />
			       	<xsl:with-param name="required" select="$required" />
				</xsl:call-template>
			</xsl:if>
      
	      	<div class="col-lg-{$cols} col-md-{$cols}">
	      		<select id="{$id}" name="{$name}" class="form-control">
	      			<xsl:if test="not($required)">
						<option value="">
							<xsl:value-of select="concat('-- ', portal:localize('bootstrap.form.select'), ' --')"/>
						</option>
					</xsl:if>
		        	<xsl:copy-of select="$options" />
		        </select>
		        
	        </div>
        </div>
	</xsl:template>
	
	<xsl:template name="bootstrap:form.createSelectOption" as="element()">
		<xsl:param name="value" as="xs:string" required="yes" />
		<xsl:param name="display" />
		<xsl:param name="selected" select="false()" />
		
		<option value="{$value}">
			<xsl:if test="$selected">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="if($display) then $display else $value"/>
		</option>		
	</xsl:template>
	
	<!-- 
		Needs datasource
		<datasource name="getCountries">
	        <parameter name="includeRegions">false</parameter>
	    </datasource>
	 -->
	<xsl:template name="bootstrap:form.createCountrySelect" as="element()">
		<xsl:param name="name" as="xs:string" required="yes" />
		<xsl:param name="value" />
		<xsl:param name="required" />
		
		<xsl:variable name="selected-country">
			<xsl:choose>
				<xsl:when test="normalize-space($value)"><xsl:value-of select="$value" /></xsl:when>
				<xsl:otherwise>NO</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:call-template name="bootstrap:form.createSelect">
       		<xsl:with-param name="name" select="$name" />
			<xsl:with-param name="required" select="$required" />
 			<xsl:with-param name="options">
				<xsl:for-each select="/result/countries/country">
					<xsl:value-of select="display-country" />
	         		<xsl:call-template name="bootstrap:form.createSelectOption">
	         			<xsl:with-param name="value" select="@code" />
	         			<xsl:with-param name="display" select="local-name" />
	         			<xsl:with-param name="selected" select="@code = $selected-country" />
	         		</xsl:call-template>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="bootstrap:form.createCheckbox" as="element()">
		<xsl:param name="id" as="xs:string" select="generate-id()" />
		<xsl:param name="name" as="xs:string" required="yes" />
		<xsl:param name="title" />
		<xsl:param name="label" />
		<xsl:param name="required" select="false()" />
		<xsl:param name="cols" as="xs:integer" select="$default-cols" />
		<xsl:param name="error" />
		
		<div class="form-group">
			<xsl:if test="$error">
				<xsl:attribute name="class" select="'form-group has-error'" />
			</xsl:if>
			<div class="checkbox col-lg-{$cols} col-sm-offset-{$default-label-cols}">
				<label for="{$id}" title="{$title}">
					<input name="{$name}" type="checkbox" id="{$id}" />
					
					<xsl:if test="$error">
						<i class="fa fa-fw fa fa-exclamation-triangle" title="{$error}" />
					</xsl:if>
					
					<xsl:value-of select="$label" />
					<xsl:if test="$required"><span style="color: red;"> *</span></xsl:if>
				</label>
			</div>
		</div>
	</xsl:template>
	
	
	<xsl:template name="bootstrap:form.createFileInput" as="element()">
		<xsl:param name="id" as="xs:string" select="generate-id()" />
		<xsl:param name="name" as="xs:string" required="yes" />
		<xsl:param name="title" />
		<xsl:param name="required" as="xs:boolean" select="false()" />
		<xsl:param name="help" />
		<xsl:param name="cols" as="xs:integer" select="$default-cols" />
		<xsl:param name="error" />
	
		<div class="form-group">
			<xsl:if test="$error">
				<xsl:attribute name="class" select="'form-group has-error'" />
			</xsl:if>
			
			<xsl:call-template name="bootstrap:form.renderLabel">
		       	<xsl:with-param name="id" select="$id" />
		       	<xsl:with-param name="title" select="$title" />
		       	<xsl:with-param name="required" select="$required" />
			</xsl:call-template>
		
		  	<div class="col-lg-{$cols}">
		        <input id="{$id}" name="{$name}" type="file" />
		        <p class="help-block"><xsl:copy-of select="$help" /></p>
		     </div>
        </div>    	
	</xsl:template>
	
	<xsl:template name="bootstrap:form.renderLabel" as="element()">
		<xsl:param name="id" as="xs:string"  select="generate-id()" />
		<xsl:param name="required" select="false()" />
		<xsl:param name="title" />
		<xsl:param name="label" as="xs:string" tunnel="yes" required="yes" />
		<xsl:param name="labelClass" as="xs:string" tunnel="yes" select="''" />
		<xsl:param name="label-cols" as="xs:integer" select="$default-label-cols" />
	
	    <label for="{$id}" class="col-lg-{$label-cols} col-md-{$label-cols} control-label {$labelClass}">
		    <xsl:value-of select="$label" />
		    <xsl:if test="$title">
		    	<span class="labelinfo">
		    		<xsl:copy-of select="bootstrap:util.createIcon('fa-info-circle', $title)" />
		    	</span>
		    </xsl:if>
		    <xsl:if test="$required"><span style="color: red;"> *</span></xsl:if>
	    </label>
	</xsl:template>
	
	<xsl:template name="bootstrap:form.seperator" as="element()">
		<xsl:param name="label" />
		<xsl:param name="cols" as="xs:integer" select="$default-label-cols" />
		
		<div class="row">
        	<div class="separator col-lg-{$cols} col-md-{$cols}">
				<xsl:value-of select="$label"/>
			</div>
		</div>
	</xsl:template>
	
	
	<xsl:template name="bootstrap:form.createDate" as="element()">
		<xsl:param name="id" as="xs:string"  select="generate-id()" />
		<xsl:param name="required" select="false()" />
		<xsl:param name="name" as="xs:string" required="yes" />
		<xsl:param name="title" />
		<xsl:param name="placeholder" select="'dd.mm.åååå'" />
		<xsl:param name="value" />
		<xsl:param name="cols" as="xs:integer" select="$default-cols" />
		<xsl:param name="label" as="xs:string" tunnel="yes" required="yes" />
		<xsl:param name="labelClass" as="xs:string" tunnel="yes" select="''" />
		<xsl:param name="label-cols" as="xs:integer" select="$default-label-cols" />
		<xsl:param name="error" />
		<xsl:param name="allowPastDates" as="xs:boolean" select="false()" />
	
	    <div class="form-group ">
	    	<xsl:if test="$error">
				<xsl:attribute name="class" select="'form-group has-error'" />
			</xsl:if>
			
			<xsl:call-template name="bootstrap:form.renderLabel">
		       	<xsl:with-param name="id" select="$id" />
		       	<xsl:with-param name="title" select="$title" />
		       	<xsl:with-param name="required" select="$required" />
			</xsl:call-template>
			
			<div class="col-lg-{$cols} col-md-{$cols}">
			    
			<xsl:variable name="datePickerConf">
				<allowPastDates><xsl:value-of select="$allowPastDates" /></allowPastDates>
				<date><xsl:value-of select="$value" /></date>
			</xsl:variable>
			    
			<script>
				$(function(){
					initDatePicker('<xsl:value-of select="$id" />', <xsl:value-of select="json:generate($datePickerConf)"/>);
				});
			</script>

			<!-- Navn data-initialize="datepicker" -->
			<div class="datepicker" id="{$id}">
			  <div class="input-group">
			    <input value="{$value}" class="form-control" id="{$id}-input" name="{$name}" type="text" placeholder="{$placeholder}">
			    	<xsl:if test="$required">
			    		<xsl:attribute name="required" select="''" />
		    		</xsl:if>
			    </input>
			    
			    <div class="input-group-btn">
			      <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
			        <span class="fa fa-calendar"></span>
			        <span class="sr-only">Vis kalendar</span>
			      </button>
			      
			      <div class="dropdown-menu dropdown-menu-right datepicker-calendar-wrapper" role="menu">
			        <div class="datepicker-calendar">
			          <div class="datepicker-calendar-header">
			            <button type="button" class="prev"><span class="glyphicon glyphicon-chevron-left"></span><span class="sr-only">Forrige måned</span></button>
			            <button type="button" class="next"><span class="glyphicon glyphicon-chevron-right"></span><span class="sr-only">Neste måned</span></button>
			            <button type="button" class="title">
			                <span class="month">
			                  <span data-month="0">Januar</span>
			                  <span data-month="1">Februar</span>
			                  <span data-month="2">Mars</span>
			                  <span data-month="3">April</span>
			                  <span data-month="4">Mai</span>
			                  <span data-month="5">Juni</span>
			                  <span data-month="6">Juli</span>
			                  <span data-month="7">August</span>
			                  <span data-month="8">September</span>
			                  <span data-month="9">Oktober</span>
			                  <span data-month="10">November</span>
			                  <span data-month="11">Desember</span>
			                </span>&#160;<span class="year"></span>
			            </button>
			          </div>
			          <table class="datepicker-calendar-days">
			            <thead>
			            <tr>
			              <th>Sø</th>
			              <th>Ma</th>
			              <th>Ti</th>
			              <th>On</th>
			              <th>To</th>
			              <th>Fr</th>
			              <th>Lø</th>
			            </tr>
			            </thead>
			            <tbody></tbody>
			          </table>
			          <div class="datepicker-calendar-footer">
			            <button type="button" class="datepicker-today">I dag</button>
			          </div>
			        </div>
			        <div class="datepicker-wheels" aria-hidden="true">
			          <div class="datepicker-wheels-month">
			            <h2 class="header">Måned</h2>
			            <ul>
			              <li data-month="0"><button type="button">Jan</button></li>
			              <li data-month="1"><button type="button">Feb</button></li>
			              <li data-month="2"><button type="button">Mar</button></li>
			              <li data-month="3"><button type="button">Apr</button></li>
			              <li data-month="4"><button type="button">Mai</button></li>
			              <li data-month="5"><button type="button">Jun</button></li>
			              <li data-month="6"><button type="button">Jul</button></li>
			              <li data-month="7"><button type="button">Aug</button></li>
			              <li data-month="8"><button type="button">Sep</button></li>
			              <li data-month="9"><button type="button">Okt</button></li>
			              <li data-month="10"><button type="button">Nov</button></li>
			              <li data-month="11"><button type="button">Des</button></li>
			            </ul>
			          </div>
			          <div class="datepicker-wheels-year">
			            <h2 class="header">År</h2>
			            <ul></ul>
			          </div>
			          <div class="datepicker-wheels-footer clearfix">
			            <button type="button" class="btn datepicker-wheels-back"><span class="glyphicon glyphicon-arrow-left"></span><span class="sr-only">Tilbake til kalender</span></button>
			            <button type="button" class="btn datepicker-wheels-select">Velg <span class="sr-only">Måned og år</span></button>
			          </div>
			        </div>
			      </div>
			    </div>
			  </div>
			</div>
		  </div>
	    </div>
	</xsl:template>
</xsl:stylesheet>