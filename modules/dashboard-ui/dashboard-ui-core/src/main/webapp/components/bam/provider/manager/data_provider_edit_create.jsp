<%--

    Copyright (C) 2012 JBoss Inc

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

          http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

--%>
<%@ page import="org.jboss.dashboard.LocaleManager" %>
<%@ page import="org.jboss.dashboard.ui.components.DataProviderHandler" %>
<%@ page import="java.util.Locale" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page import="java.util.Map" %>
<%@ taglib prefix="factory" uri="factory.tld" %>
<%@ taglib prefix="panel" uri="bui_taglib.tld" %>
<%@ taglib uri="resources.tld" prefix="resource" %>
<%@ taglib prefix="mvc" uri="mvc_taglib.tld"%>
<%@ taglib uri="http://dashboard.jboss.org/taglibs/i18n-1.0" prefix="i18n" %>
<i18n:bundle id="bundle" baseName="org.jboss.dashboard.displayer.messages"
             locale="<%=LocaleManager.currentLocale()%>"/>

<mvc:formatter name="org.jboss.dashboard.ui.formatters.DataProviderFormatter">
    <mvc:fragment name="outputStart">
      <form style="margin:0px;" action="<factory:formUrl friendly="false"/>" method="post" id="<factory:encode name="createDataProviderForm"/>">
      <factory:handler bean="org.jboss.dashboard.ui.components.DataProviderHandler" action="editCreateNewDataProvider"/>
      <table border="0" style="margin:0px;" cellspacing="0" width="650px">
    </mvc:fragment>

    <mvc:fragment name="outputCreateTitle">
        <tr>
            <td width="800px">
                <table align="center" width="800px" cellspacing="1" cellpadding="4" border="0">
                    <tr style="display:table-row; width:12px;">
                        <td class="skn-table_border" colspan="2">
                            <div style="vertical-align:middle; text-align:left;">
                                <i18n:message key='<%=DataProviderHandler.I18N_PREFFIX + "creatingDataProvider"%>'>!!!Crear nuevo</i18n:message>
                            </div>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </mvc:fragment>

    <mvc:fragment name="outputEditTitle">
        <mvc:fragmentValue name="providerName" id="providerName">
        <tr>
            <td nowrap="nowrap">
               <div style="vertical-align:middle; text-align:left;" class="skn-title3">
                   <i18n:message key='<%=DataProviderHandler.I18N_PREFFIX + "editingProvider"%>' args="<%=new Object[] {providerName}%>">!!!Editar</i18n:message><br><br>
               </div>
            </td>
        </tr>
        </mvc:fragmentValue>
    </mvc:fragment>

	<mvc:fragment name="outputError">
		<mvc:fragmentValue name="message" id="message">
			<tr>
				<td>
					<div style="vertical-align:middle; text-align:left;" class="skn-title3">
						<fieldset style="padding: 10px;">
							<legend class="skn-error">
								<i18n:message key='<%=DataProviderHandler.I18N_PREFFIX + "error"%>'>!!!Error</i18n:message>
							</legend>
							<p class="skn-error"><%= message %></p>
						</fieldset>
						<br>
					</div>
				</td>
			</tr>
		</mvc:fragmentValue>
	</mvc:fragment>

    <mvc:fragment name="outputTableStart">
        <tr>
            <td>
                <table width="100%" cellpadding="4" cellspacing="0" border="0">
    </mvc:fragment>

    <mvc:fragment name="outputDataProviderTypes">
        <tr>
            <td width="10%">
                <i18n:message key='<%=DataProviderHandler.I18N_PREFFIX + "selectProviderType"%>'>!!!Seleccione tipo </i18n:message>:
            </td>
            <td colspan="2" width="90%">
                <mvc:include page="data_provider_types.jsp"/>
            </td>
        </tr>
    </mvc:fragment>

    <mvc:fragment name="outputCancelButtonNoTypeSelected">
        <tr>
            <td colspan="2" style="padding-left:60px">
                <input class="skn-button_alt" type="button" value="<i18n:message key='<%=DataProviderHandler.I18N_PREFFIX + "cancel"%>'>!!!Cancelar</i18n:message>"
                                onclick="submitAjaxForm(document.getElementById('<factory:encode name="goToShowPageForm"/>'))"/>
            </td>
        </tr>
    </mvc:fragment>

    <mvc:fragment name="outputProviderName">
		<mvc:fragmentValue name="value" id="value">
        <mvc:fragmentValue name="error" id="error">
        <tr>
            <%
                String strClass = "";
                if (error != null && ((Boolean)error).booleanValue()) strClass = "skn-error";
            %>
            <td width="15%"><span class="<%=strClass%>"><i18n:message key='<%=DataProviderHandler.I18N_PREFFIX + "providerName"%>'>!!!Nombre del proveedor de datos</i18n:message>:&nbsp;</span></td>
            <td width="64%">
				<%
            String[] langs = LocaleManager.lookup().getPlatformAvailableLangs();
            for (int i = 0; i < langs.length; i++) {
                String lang = langs[i];
                String descr = (String)((Map) value).get(new Locale(lang));
				%>
				<input id="<factory:encode name="providerNameId"/><%= "_" + lang%>"
					   name="<%=DataProviderHandler.PARAM_PROVIDER_NAME + "/" + lang%>"
             value="<%= StringUtils.defaultString(descr, "") %>"
					   style='<%="width:250px;"+ (lang.equals(LocaleManager.currentLang()) ? "display:inline;" : "display:none;")%>'
					   class="skn-input"
					   size="65" >
				<% } %>
            </td>
            <td width="26%">
				<select class="skn-input" onchange="
					var elements = this.form.elements;
					var selectedOption = this.options[this.selectedIndex];
					for( i =0 ; i<elements.length; i++ ){
						var element = elements[i];
						if ( element.tagName.toUpperCase() == 'INPUT' && element.type.toUpperCase()=='TEXT' ) {
							if ( element.id.substring(0,element.id.lastIndexOf('_')) == '<factory:encode name="providerNameId"/>' ) {
								if( element.id == '<factory:encode name="providerNameId"/>' + '_' + selectedOption.value ){
									element.style.display= 'inline';
								} else {
									element.style.display= 'none';
								}
							}
						}
					}">

					<%
						for (int i = 0; i < langs.length; i++) {
                String lang = langs[i];
					%>
					<option <%= lang.equals(LocaleManager.currentLang()) ? "selected" : ""%> value="<%=lang%>">
						<%=StringUtils.capitalize(LocaleManager.lookup().getLangDisplayName(lang))%>
					</option>
					<% } %>
                </select>
            </td>
        </tr>
		</mvc:fragmentValue>
        </mvc:fragmentValue>
    </mvc:fragment>

    <mvc:fragment name="outputEditProviderPage">
        <mvc:fragmentValue name="component" id="component">
        <tr>
            <td colspan="3" style="background-color:#ededed;">
                <br><div style="padding: 15px;"> <factory:useComponent bean="<%= component %>"/> </div><br>
            </td>
        </tr>
        </mvc:fragmentValue>
    </mvc:fragment>

    <mvc:fragment name="outputButtons">
        <tr>
            <td width="100%" align="center" style="padding-top: 10px;" colspan="3">
                <input class="skn-button" type="button" value="<i18n:message key='<%=DataProviderHandler.I18N_PREFFIX + "save"%>'>!!!Guardar</i18n:message>"
                       onclick="document.getElementById('<factory:encode name="editCreateFormSubmitted"/>').value='true';
                                submitAjaxForm(this.form);">&nbsp;
               <input class="skn-button_alt" type="button" value="<i18n:message key='<%=DataProviderHandler.I18N_PREFFIX + "cancel"%>'>!!!Cancelar</i18n:message>"
                                onclick="submitAjaxForm(document.getElementById('<factory:encode name="goToShowPageForm"/>'))"/>
               <input id="<factory:encode name="editCreateFormSubmitted"/>" type="hidden" value="false" name="<factory:bean property="saveButtonPressed" bean="org.jboss.dashboard.ui.components.DataProviderHandler"/>">
            </td>
        </tr>
    </mvc:fragment>

    <mvc:fragment name="outputTableEnd">
        </table>
        </td>
        </tr>
    </mvc:fragment>

    <mvc:fragment name="outputEnd">
        </table>
        </form>
        <script defer>
            setAjax('<factory:encode name="createDataProviderForm"/>');
        </script>
        <form action="<factory:formUrl friendly="false"/>" method="post" id="<factory:encode name="goToShowPageForm"/>">
            <factory:handler bean="org.jboss.dashboard.ui.components.DataProviderHandler" action="cancel"/>
        </form>
        <script defer>
            setAjax('<factory:encode name="goToShowPageForm"/>');
        </script>
    </mvc:fragment>


</mvc:formatter>