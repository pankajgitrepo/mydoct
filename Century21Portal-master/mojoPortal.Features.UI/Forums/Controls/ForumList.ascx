<%@ Control Language="C#" AutoEventWireup="false" CodeBehind="ForumList.ascx.cs" Inherits="mojoPortal.Web.ForumUI.ForumList" %>
<script src="../../Scripts/jquery.tablesorter.min.js"></script>
<style>
    th.header { 
    background-image: url(/Data/Sites/1/skins/Theme_C21/images/bg.gif); 
    cursor: pointer; 
    font-weight: bold; 
    background-repeat: no-repeat; 
    background-position: center right; 
    padding-left: 20px; 
    border-right: 1px solid #dad9c7; 
    margin-left: -1px; 
}
    th.headerSortUp { 
    background-image: url(/Data/Sites/1/skins/Theme_C21/images/asc.gif); 
    background-color: #3399FF; 
}
    th.headerSortDown { 
    background-image: url(/Data/Sites/1/skins/Theme_C21/images/desc.gif); 
    background-color: #3399FF; 
} 
    #forumListTable tbody tr:nth-child(odd) {
   background-color: #e3e4e6;   
}
</style>
<asp:Panel ID="pnlForumList" runat="server" CssClass="forumlist">
    <div id="divForum_list" runat="server">

            <asp:Repeater ID="rptForums" runat="server">
                <HeaderTemplate>
                            <table summary='<%# Resources.ForumResources.ForumsTableSummary %>' id="forumListTable" cellpadding="0" cellspacing="1" border="0" width="100%">
            <thead>
                
                <tr class="forumTitle">
                    <%--Remove Subscribe? Column--%>
                   <%-- <th id="tdSubscribedHead" runat="server" enableviewstate="false" class="fsubscribe">
                        <mp:sitelabel id="lblSubscribed" runat="server" configkey="ForumModuleSubscribedLabel" resourcefile="ForumResources" uselabeltag="false" />
                    </th>--%>
                    
                    <th id='t2' class="ftitle">
                        <mp:sitelabel id="lblForumName" runat="server" configkey="ForumModuleForumLabel" resourcefile="ForumResources" uselabeltag="false" />
                    </th>
                    <th id='t3' class="fthreadcount">
                        <mp:sitelabel id="lblThreadCount" runat="server" configkey="ForumModuleThreadCountLabel" resourcefile="ForumResources" uselabeltag="false" />
                    </th>
                    <th id='t4' class="fpostcount">
                        <mp:sitelabel id="lblPostCount" runat="server" configkey="ForumModulePostCountLabel" resourcefile="ForumResources" uselabeltag="false" />
                    </th>
                    <th id='t5' class="fpostdate">
                        <mp:sitelabel id="lblLastPost" runat="server" configkey="ForumModulePostLastPostLabel" resourcefile="ForumResources" uselabeltag="false" />
                    </th>
                </tr>
            </thead>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr class="modulerow">
                    <%--Remove Subscribe? Column--%>
                        <%--<td headers='<%# tdSubscribedHead.ClientID %>' id="tdSubscribed" runat="server" enableviewstate='<%# ShowSubscribeCheckboxes %>' class="txtmed padded fsubscribe" visible='<%# Request.IsAuthenticated %>'>
                            <div id="divSbubcriberCount" runat="server" enableviewstate="false" visible='<%# (Config.ShowSubscriberCount &&(!IsEditable)) %>'>
                                <asp:Literal ID="litSubCount" runat="server" EnableViewState="false" Text='<%# FormatSubscriberCount(Convert.ToInt32(Eval("SubscriberCount")))%>' />
                            </div>
                            <div id="divEditor" runat="server" visible='<%# IsEditable %>' enableviewstate="false">
                                <asp:HyperLink ID="lnkSubscribers" runat="server" EnableViewState="false" CssClass="cblink"
                                    NavigateUrl='<%# SiteRoot + "/Forums/SubscriberDialog.aspx?ItemID=" + DataBinder.Eval(Container.DataItem,"ItemID") + "&mid=" + ModuleId + "&pageid=" + PageId.ToString() %>'
                                    Text='<%# FormatSubscriberCount(Convert.ToInt32(Eval("SubscriberCount")))%>'
                                    ToolTip='<%# FormatSubscriberCount(Convert.ToInt32(Eval("SubscriberCount")))%>' />
                            </div>
                            <div class="forumnotify">
                               <%-- <asp:HyperLink ID="lnkNotify" runat="server" EnableViewState="false" Visible='<%# !ShowSubscribeCheckboxes %>' ImageUrl='<%# ImageSiteRoot + "/Data/SiteImages/FeatureIcons/email.png"  %>' NavigateUrl='<%# notificationUrl + "#forum" + Eval("ItemID") %>'
                                    Text='<%# Convert.ToBoolean(DataBinder.Eval(Container.DataItem, "Subscribed")) ? Resources.ForumResources.UnSubscribeLink : Resources.ForumResources.SubscribeLink %>' />--%><%--
                                &nbsp;<asp:HyperLink ID="lnkNotify2" runat="server" EnableViewState="false" Visible='<%# !ShowSubscribeCheckboxes %>' NavigateUrl='<%# notificationUrl + "#forum" + Eval("ItemID") %>'
                                    Text='<%# Convert.ToBoolean(DataBinder.Eval(Container.DataItem, "Subscribed")) ? Resources.ForumResources.UnSubscribeLink : Resources.ForumResources.SubscribeLink %>'
                                    ToolTip='<%# Convert.ToBoolean(DataBinder.Eval(Container.DataItem, "Subscribed")) ? Resources.ForumResources.UnSubscribeLink : Resources.ForumResources.SubscribeLink %>' />

                                <a id='forum<%# Eval("ItemID") %>' />
                                <asp:CheckBox ID="chkSubscribed" runat="server" Visible='<%# ShowSubscribeCheckboxes %>'
                                    Checked='<%# Convert.ToBoolean(DataBinder.Eval(Container.DataItem,"Subscribed")) %>'
                                    OnCheckedChanged="Subscribed_CheckedChanged" EnableViewState="true" />

                            </div>
                        </td>--%>
                        
                        <td headers='t2' class="ftitle">
                            <h3>
                                <portal:nofollowhyperlink id="HyperLink3" runat="server" enableviewstate="false"
                                    tooltip="RSS" cssclass="forumfeed"
                                    navigateurl='<%# NonSslSiteRoot + "/Forums/RSS.aspx?pageid=" + PageId.ToInvariantString() + "&m=" + ModuleId.ToInvariantString()  +"~" + Eval("ItemID")  %>'
                                    visible="<%# Config.EnableRSSAtForumLevel %>" />
                                <asp:HyperLink ID="viewlink1" runat="server" SkinID="TitleLink" EnableViewState="false"
                                    NavigateUrl='<%# FormatUrl(Convert.ToInt32(Eval("ItemID"))) %>'>                                    
				                    <%# DataBinder.Eval(Container.DataItem,"Title") %></asp:HyperLink>
                                <asp:HyperLink ID="editLink" runat="server" EnableViewState="false"
                                    CssClass="forumEdit"
                                    ToolTip="<%# Resources.ForumResources.ForumEditForumLabel %>"
                                    NavigateUrl='<%# SiteRoot + "/Forums/EditForum.aspx?ItemID=" + DataBinder.Eval(Container.DataItem,"ItemID") + "&mid=" + ModuleId + "&pageid=" + PageId.ToString() %>'
                                    Visible="<%# IsEditable %>" />
                            </h3>
                            <%# DataBinder.Eval(Container.DataItem,"Description").ToString() %>
            </td>
                        <td headers='t3' class="fthreadcount">
                            <%# DataBinder.Eval(Container.DataItem,"ThreadCount") %>
            </td>
                        <td headers='t4' class="fpostcount">
                            <%# DataBinder.Eval(Container.DataItem,"PostCount") %>
            </td>
                        <td headers='t5' class="fpostdate">
                            <%# FormatDate(Eval("MostRecentPostDate")) %>
            </td>
                    </tr>
                </ItemTemplate>
                <%--  <td headers='<%# tdSubscribedHead.ClientID %>' id="tdSubscribedAlt" runat="server" enableviewstate='<%# ShowSubscribeCheckboxes %>' class="txtmed padded fsubscribe" visible='<%# Request.IsAuthenticated %>'>
                            <div id="divSbubcriberCount" runat="server" enableviewstate="false" visible='<%# (Config.ShowSubscriberCount &&(!IsEditable)) %>'>
                                <asp:Literal ID="litSubCount" runat="server" EnableViewState="false" Text='<%# FormatSubscriberCount(Convert.ToInt32(Eval("SubscriberCount")))%>' />
                            </div>
                            <div id="divEditor" runat="server" enableviewstate="false" visible='<%# IsEditable %>'>
                                <asp:HyperLink ID="lnkSubscribers" runat="server" EnableViewState="false" CssClass="cblink"
                                    NavigateUrl='<%# SiteRoot + "/Forums/SubscriberDialog.aspx?ItemID=" + DataBinder.Eval(Container.DataItem,"ItemID") + "&mid=" + ModuleId + "&pageid=" + PageId.ToString() %>'
                                    Text='<%# FormatSubscriberCount(Convert.ToInt32(Eval("SubscriberCount")))%>'
                                    ToolTip='<%# FormatSubscriberCount(Convert.ToInt32(Eval("SubscriberCount")))%>' />
                            </div>
                            <div class="forumnotify">
                               <%-- <asp:HyperLink ID="lnkNotify" runat="server" EnableViewState="false" Visible='<%# !ShowSubscribeCheckboxes %>' ImageUrl='<%# ImageSiteRoot + "/Data/SiteImages/FeatureIcons/email.png"  %>' NavigateUrl='<%# notificationUrl + "#forum" + Eval("ItemID") %>'
                                    Text='<%# Convert.ToBoolean(DataBinder.Eval(Container.DataItem, "Subscribed")) ? Resources.ForumResources.UnSubscribeLink : Resources.ForumResources.SubscribeLink %>' />--%><%--
                                &nbsp;<asp:HyperLink ID="lnkNotify2" runat="server" EnableViewState="false" Visible='<%# !ShowSubscribeCheckboxes %>' NavigateUrl='<%# notificationUrl + "#forum" + Eval("ItemID") %>'
                                    Text='<%# Convert.ToBoolean(DataBinder.Eval(Container.DataItem, "Subscribed")) ? Resources.ForumResources.UnSubscribeLink : Resources.ForumResources.SubscribeLink %>'
                                    ToolTip='<%# Convert.ToBoolean(DataBinder.Eval(Container.DataItem, "Subscribed")) ? Resources.ForumResources.UnSubscribeLink : Resources.ForumResources.SubscribeLink %>' />
                                <a id='forum<%# Eval("ItemID") %>' />
                                <asp:CheckBox ID="chkSubscribedAlt" runat="server" Visible='<%# ShowSubscribeCheckboxes %>'
                                    Checked='<%# Convert.ToBoolean(DataBinder.Eval(Container.DataItem,"Subscribed")) %>'
                                    OnCheckedChanged="Subscribed_CheckedChanged" EnableViewState="true" />
                            </div>
                        </td>--%>
<%--                <AlternatingItemTemplate>
                    <tr class="modulealtrow">
                      
                        <td headers='t2' class="ftitle">
                            <h3>
                               
                                <portal:nofollowhyperlink id="HyperLink3" runat="server" enableviewstate="false"
                                    tooltip="RSS" cssclass="forumfeed"
                                    navigateurl='<%# NonSslSiteRoot + "/Forums/RSS.aspx?pageid=" + PageId.ToInvariantString() + "&m=" + ModuleId.ToInvariantString()  +"~" + Eval("ItemID")  %>'
                                    visible="<%# Config.EnableRSSAtForumLevel %>" />
                                <asp:HyperLink ID="Hyperlink2" runat="server" SkinID="TitleLink" EnableViewState="false"
                                    NavigateUrl='<%# FormatUrl(Convert.ToInt32(Eval("ItemID"))) %>'>
				                    <%# DataBinder.Eval(Container.DataItem,"Title") %></asp:HyperLink>
                                 <asp:HyperLink ID="Hyperlink1" runat="server" EnableViewState="false"
                                    CssClass="forumEdit"
                                    ToolTip="<%# Resources.ForumResources.ForumEditForumLabel %>"
                                    NavigateUrl='<%# SiteRoot + "/Forums/EditForum.aspx?ItemID=" + DataBinder.Eval(Container.DataItem,"ItemID") + "&mid=" + ModuleId + "&pageid=" + PageId.ToString() %>'
                                    Visible="<%# IsEditable %>" />
                            </h3>
                            <%# DataBinder.Eval(Container.DataItem,"Description").ToString()%>
            </td>
                        <td headers='t3' class="fthreadcount">
                            <%# DataBinder.Eval(Container.DataItem,"ThreadCount") %>
            </td>
                        <td headers='t4' class="fpostcount">
                            <%# DataBinder.Eval(Container.DataItem,"PostCount") %>
            </td>
                        <td headers='t5' class="fpostdate">
                            <%# FormatDate(Eval("MostRecentPostDate")) %>
            </td>
                    </tr>
                </AlternatingItemTemplate>--%>
                <FooterTemplate></tbody></table></FooterTemplate>
            </asp:Repeater>
            <table>
            <tr id="trSubscribeButtons" runat="server">
                <td id="tdSave" runat="server" class="settingrow forum" align="left">
                    <portal:mojobutton id="btnSave" runat="server" text="Save" />
                    <portal:mojobutton id="btnCancel" runat="server" text="Cancel" />
                    <portal:mojohelplink id="MojoHelpLink1" runat="server" helpkey="forumeditsubscriptionshelp" />
                </td>
            </tr>
        </table>
    </div>
    <%--Edit Email subscription removed, display: none--%>
    <div style="display:none" id="divEditSubscriptions" runat="server" enableviewstate="false" class="settingrow forumnotification">
        <portal:nofollowhyperlink id="lnkModuleRSS" runat="server" enableviewstate="false" cssclass="forumfeed forummodulefeed" />
        <asp:HyperLink ID="editSubscriptionsLink" EnableViewState="false" runat="server" CssClass="editforumsubcriptions" />
    </div>
</asp:Panel>
<script>
    $(document).ready(function () {
        $("#forumListTable").tablesorter({
            //sortList: [[0, 1]]
        });
        
    });
</script>