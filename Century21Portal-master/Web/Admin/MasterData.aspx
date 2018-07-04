<%@ Page Language="C#" AutoEventWireup="false" MasterPageFile="~/App_MasterPages/layout.Master" CodeBehind="MasterData.aspx.cs" Inherits="mojoPortal.Web.AdminUI.MasterData" %>

<asp:Content ContentPlaceHolderID="leftContent" ID="MPLeftPane" runat="server" />
<asp:Content ContentPlaceHolderID="mainContent" ID="MPContent" runat="server">
    <style type="text/css">
        .hideGridColumn
        {
            display: none;
        }
    </style>
<portal:AdminCrumbContainer ID="pnlAdminCrumbs" runat="server" CssClass="breadcrumbs">
<asp:HyperLink ID="lnkAdminMenu" runat="server" NavigateUrl="~/Admin/AdminMenu.aspx" /><portal:AdminCrumbSeparator id="litLinkSeparator1" runat="server" Text="&nbsp;&gt;" EnableViewState="false" />
<asp:HyperLink ID="lnkMasterDataManager" runat="server" />
</portal:AdminCrumbContainer>
<portal:OuterWrapperPanel ID="pnlOuterWrap" runat="server">
<mp:CornerRounderTop id="ctop1" runat="server" />
<portal:InnerWrapperPanel ID="pnlInnerWrap" runat="server" CssClass="panelwrapper admin contentcatalog">
<portal:HeadingControl ID="heading" runat="server" />
<portal:OuterBodyPanel ID="pnlOuterBody" runat="server">
<portal:InnerBodyPanel ID="pnlInnerBody" runat="server" CssClass="modulecontent">
    <asp:Label ID="ddlLo" Text="Master Data Type" runat="server"> </asp:Label>
    <asp:DropDownList ID="ddModuleType" runat="server" AutoPostBack="True"  DataValueField="ModuleDefID" DataTextField="FeatureName" OnSelectedIndexChanged="ddModuleType_SelectedIndexChanged">
        </asp:DropDownList>
            <portal:mojoButton ID="btnCreateNewContent" runat="server" ValidationGroup="contentcatalog" />
        <asp:Panel ID="pnlNewContent" runat="server" CssClass="settingrow" DefaultButton="btnCreateNewContent" Visible="false">
        
            <br />
            <asp:Label ID="lblTitle" Text="Title" runat="server"> </asp:Label>
        <asp:TextBox ID="txtModuleTitle" runat="server" Columns="40" Text="" CssClass="mediumtextbox" EnableViewState="false"></asp:TextBox>
        
        <asp:RequiredFieldValidator ID="reqModuleTitle" runat="server" ControlToValidate="txtModuleTitle" ValidationGroup="contentcatalog" />
            
        <asp:CompareValidator ID="cvModuleTitle" runat="server" Operator="NotEqual" ControlToValidate="txtModuleTitle" ValidationGroup="contentcatalog" />
            <div class="settingrow">
        <portal:mojoButton runat="server" ID="btnSave" ClientIDMode="Static" Text="Save" OnClick="btnSave_Click" />
        <portal:mojoButton runat="server" ID="btnCancel" ClientIDMode="Static" Text="Cancel" OnClick="btnCancel_Click" />
    </div>    
    </asp:Panel>
    <div id="mster">

       
<%--        <asp:UpdatePanel ID="updHx" UpdateMode="Conditional" runat="server">
            <Triggers>
            <asp:PostBackTrigger ControlID="grdContent" />
            </Triggers>
            <ContentTemplate>--%>
                <asp:Panel ID="pnlContent" runat="server" >
                    <div class="settingrow">
                        <asp:HiddenField ID="masterDataId" runat="server" />
                    <mp:mojoGridView ID="grdContent" runat="server" AllowPaging="false" AllowSorting="true" AutoGenerateColumns="false"
                     EnableViewState="true" CellPadding="3" DataKeyNames="Id" UseAccessibleHeader="true" >
                     <Columns>
                         <%--<asp:TemplateField SortExpression="FeatureName">
                            <ItemTemplate>
                            </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField SortExpression="ModuleTitle">
                                <ItemTemplate>
                                    <%# Eval("Title").ToString().Coalesce(Resources.Resource.ContentNoTitle)%>
                                </ItemTemplate>
                            </asp:TemplateField>--%>

<%--                            <asp:TemplateField >

                                <ItemTemplate>
                                    
                                   <asp:LinkButton runat="server" ID="btnEdit" Text="Edit" CommandName="EditMasterData" EnableViewState="false" CommandArgument='<%# Eval("Id") %>'  /> &#47;
                                   <asp:LinkButton runat="server" ID="btnDelete" Text="Delete" CommandName="DeleteMasterData"  CommandArgument='<%# Eval("Id") %>' OnClientClick="return confirm('Are you sure you want to delete?')" />
                           <%--         <asp:Button ID="btnEditMetaLink" runat="server" CommandName="Edit" Text='<%# Resources.BlogResources.ContentMetaGridEditButton %>' CommandArgument='<%# Eval("Id") %>' />
                                    <asp:Button ID="btnDelete" runat="server" CommandName="Delete" CommandArgument='<%# Eval("Id") %>'
                                                            Visible="true" Text='<%# Resources.BlogResources.DeleteHistoryButton %>' />--%>
                               <%-- </ItemTemplate>
                        </asp:TemplateField>--%>
                                     <asp:BoundField DataField="Id" HeaderText="Id" ItemStyle-Width="90" ItemStyle-CssClass="hideGridColumn" />
            <asp:BoundField DataField="Title" HeaderText="Title" ItemStyle-Width="120" />
                 <asp:ButtonField CommandName="EditMasterData" Text="Edit" ButtonType="Link" />
                         <asp:ButtonField CommandName="DeleteMasterData" Text ="Delete" ButtonType="Link" />
                         </Columns>
                         <EmptyDataTemplate>
                                <p class="nodata"><asp:Literal id="litempty" runat="server" Text="<%$ Resources:Resource, GridViewNoData %>" /></p>
                        </EmptyDataTemplate>
                    </mp:mojoGridView>
       
                </div>
                            </asp:Panel>
                    <%--</ContentTemplate>
                </asp:UpdatePanel>--%>

    </div>
     <portal:mojoCutePager ID="pgrContent" runat="server" />
</portal:InnerBodyPanel>	
	</portal:OuterBodyPanel>
	<portal:EmptyPanel id="divCleared" runat="server" CssClass="cleared" SkinID="cleared"></portal:EmptyPanel>
</portal:InnerWrapperPanel>
<mp:CornerRounderBottom id="cbottom1" runat="server" />
</portal:OuterWrapperPanel>
</asp:Content>
<asp:Content ContentPlaceHolderID="rightContent" ID="MPRightPane" runat="server" >
</asp:Content>
<asp:Content ContentPlaceHolderID="pageEditContent" ID="MPPageEdit" runat="server" >
</asp:Content>
