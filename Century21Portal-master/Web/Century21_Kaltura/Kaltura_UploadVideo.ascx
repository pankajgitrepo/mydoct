<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Kaltura_UploadVideo.ascx.cs" Inherits="mojoPortal.Web.Century21_Kaltura.Kaltura_UploadVideo" %>
<portal:OuterWrapperPanel ID="pnlOuterWrap" runat="server">
    <mp:CornerRounderTop ID="ctop1" runat="server" EnableViewState="false" />
    <portal:InnerWrapperPanel ID="pnlInnerWrap" runat="server" CssClass="panelwrapper linksmodule">
<%--        <asp:ScriptManager ID="ScriptManager1" runat="server">
</asp:ScriptManager>--%>
<asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
<ProgressTemplate>
    <div class="modal">
        <div class="center">
            <img src='<%= Page.ResolveUrl("~/Data/SiteImages/indicators/indicator1.gif") %>' alt=' ' />
        </div>
    </div>
</ProgressTemplate>
</asp:UpdateProgress>
        <%-- <portal:ModuleTitleControl ID="Title1" runat="server" EnableViewState="false" />
        <portal:OuterBodyPanel ID="pnlOuterBody" runat="server">--%>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <Triggers>
   <asp:PostBackTrigger ControlID="btnUpload" />
</Triggers>
<ContentTemplate>

        <portal:InnerBodyPanel ID="pnlInnerBody" runat="server" CssClass="modulecontent">
            <div id="kaltura_media_all_categories">
        <label></label>       
<%--        <asp:FileUpLoad id="FileUpLoad1" AlternateText="You cannot upload files" runat="server" />
        <asp:Button id="btnUpload1" Text="Upload" OnClick="btnUpload_Click" runat="server" />--%>
                <asp:Label ID="lblmsg" runat="server"></asp:Label>  
         <div class="settingrow">
            <mp:SiteLabel id="lblFileNameLabel" runat="server" ForControl="txtFriendlyName" CssClass="settinglabel" ConfigKey="VideoFileTitleLabel" ResourceFile="Resource"></mp:SiteLabel>
            <asp:TextBox id="txtFriendlyName" runat="server"  Columns="45" maxlength="255" CssClass="forminput widetextbox"></asp:TextBox>
        </div>
                        <div class="settingrow">
            <mp:SiteLabel id="SiteLabel7" runat="server" CssClass="settinglabel" ConfigKey="FileDescription" ResourceFile="SharedFileResources" UseLabelTag="false"></mp:SiteLabel>
        </div>
                        <div class="settingrow">
            <mpe:EditorControl ID="edDescription" runat="server"></mpe:EditorControl>
        </div>
                            <%--<portal:jQueryFileUpload ID="uploader" runat="server" CssClass="forminput" /> --%>
                <asp:FileUpLoad id="uploader" AlternateText="You cannot upload files" runat="server" CssClass="forminput" />
		    <portal:mojoButton id="btnUpload" runat="server" Text="Upload" OnClick="btnUpload_Click" />  
        <asp:Label id="Label1" runat="server" />    
                   

              <div id="ErrorMessage" class="alert alert-danger" style="display: none"></div>
                </div>
        </portal:InnerBodyPanel>

        </ContentTemplate>
</asp:UpdatePanel>
        <%--   </portal:OuterBodyPanel>--%>
    </portal:InnerWrapperPanel>
    <mp:CornerRounderBottom ID="cbottom1" runat="server" EnableViewState="false" />

    
     
</portal:OuterWrapperPanel>

