<%@ Control Language="C#" AutoEventWireup="false" CodeBehind="ThreadList.ascx.cs" Inherits="mojoPortal.Web.ForumUI.ThreadList" %>
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
 #ChangeLogTable tbody tr:nth-child(odd) {
   background-color: #e3e4e6;   
}
</style>
<asp:Panel ID="pnlNotify" runat="server" Visible="false" CssClass="forumnotify">
        <asp:HyperLink ID="lnkNotify" runat="server" CssClass="fsubcribe1"  />&nbsp;
        <asp:HyperLink ID="lnkNotify2" runat="server" CssClass="fsubcribe2"  />
    </asp:Panel>
    <%--<div class="modulepager" style="padding-bottom: 32px; margin-top: -56px;">--%>
    <div class="modulepager">
        <portal:mojoCutePager ID="pgrTop" runat="server" />
        <a href="" class="ModulePager newForumTopic" id="lnkNewThread" runat="server"></a>
        <asp:HyperLink ID="lnkLogin" runat="server" CssClass="ModulePager" />
    </div>
	
<asp:Repeater id="rptForums" runat="server" >
    <HeaderTemplate><table summary='<%# Resources.ForumResources.ForumViewTableSummary %>' id="ChangeLogTable" border="0" cellspacing="1" width="100%" cellpadding="3">
		<thead><tr class="forumTtle">
		    <th id='t1' class="ftitle">
                
				<mp:SiteLabel id="SiteLabel1" runat="server" ConfigKey="ForumViewSubjectLabel" ResourceFile="ForumResources" UseLabelTag="false" />
			</th>
			<th id='t2' class="fstartedby">
				<mp:SiteLabel id="lblForumStartedBy" runat="server" ConfigKey="ForumViewStartedByLabel" ResourceFile="ForumResources" UseLabelTag="false" />
			</th>
			<th id='t3' class="fpostviews">
				<mp:SiteLabel id="lblTotalViewsCountLabel" runat="server" ConfigKey="ForumViewViewCountLabel" ResourceFile="ForumResources" UseLabelTag="false" />
			</th>
			<th id='t4' class="fpostreplies">
				<mp:SiteLabel id="lblTotalRepliesCountLabel" runat="server" ConfigKey="ForumViewReplyCountLabel" ResourceFile="ForumResources" UseLabelTag="false" />
			</th >
			<th id='t5' class="fpostdate">
				<mp:SiteLabel id="lblLastPostLabel" runat="server" ConfigKey="ForumViewPostLastPostLabel" ResourceFile="ForumResources" UseLabelTag="false" />	
			</th>
		</tr></thead></HeaderTemplate>
	<ItemTemplate>
		<tr class='modulerow <%# GetRowCssClass(Convert.ToInt32(Eval("SortOrder")),Convert.ToBoolean(Eval("IsLocked"))) %>'>
			<td headers='t1' class="ftitle"> 
                
			    <span style="display: none;" class='<%# GetFolderCssClass(Convert.ToInt32(Eval("SortOrder")),Convert.ToBoolean(Eval("IsLocked"))) %>'>&nbsp;</span>
					<asp:HyperLink id="editLink" 
					CssClass="threadEdit"
					Tooltip="<%# Resources.ForumResources.ForumThreadEditLabel %>"
					NavigateUrl='<%# SiteRoot + "/Forums/EditThread.aspx?thread=" + DataBinder.Eval(Container.DataItem,"ThreadID") + "&mid=" + ModuleId + "&pageid=" + PageId.ToString()  %>' 
					Visible='<%# GetPermission(DataBinder.Eval(Container.DataItem,"StartedByUserID"))%>' runat="server" />
					<portal:NoFollowHyperlink id="HyperLink3" runat="server"
		            Tooltip="RSS" CssClass="forumfeed"
		            NavigateUrl='<%# NonSslSiteRoot + "/Forums/RSS.aspx?pageid=" + PageId.ToString() + "&m=" + ModuleId.ToString() + "~" + ItemId.ToString()  + "~" + Eval("ThreadID") %>' 
		            Visible="<%# Config.EnableRSSAtThreadLevel %>"  />
					<a href='<%# FormatUrl(Convert.ToInt32(Eval("ThreadID"))) %>'>
					<%# Server.HtmlEncode(Eval("ThreadSubject").ToString())%></a>		
			</td>
			<td headers='t2' class="fstartedby">  
				<%# Eval("StartedBy") %>
			</td>
			<td headers='t3' class="fpostviews">  
				<%# Eval("TotalViews") %>
			</td>
			<td headers='t4' class="fpostreplies">  
				<%# Eval("TotalReplies") %>
			</td>
			<td headers='t5' class="fpostdate">  
				<%# FormatDate(Convert.ToDateTime(Eval("MostRecentPostDate"))) %>
				<br /><%# Eval("MostRecentPostUser") %>
			</td>
		</tr>
	</ItemTemplate>
	<%--<alternatingItemTemplate>
		<tr class='modulealtrow <%# GetRowCssClass(Convert.ToInt32(Eval("SortOrder")),Convert.ToBoolean(Eval("IsLocked"))) %>'>
			<td  headers='t1' class="ftitle"> 
			    <span style="display: none;" class='<%# GetFolderCssClass(Convert.ToInt32(Eval("SortOrder")),Convert.ToBoolean(Eval("IsLocked"))) %>'>&nbsp;</span>
				<asp:HyperLink id="editLink"
				CssClass="threadEdit"
				Tooltip="<%# Resources.ForumResources.ForumThreadEditLabel %>"
				NavigateUrl='<%# SiteRoot + "/Forums/EditThread.aspx?thread=" + DataBinder.Eval(Container.DataItem,"ThreadID") + "&mid=" + ModuleId + "&pageid=" + PageId.ToString()  %>' 
				Visible='<%# GetPermission(DataBinder.Eval(Container.DataItem,"StartedByUserID"))%>' 
				runat="server" />
			    <portal:NoFollowHyperlink id="HyperLink3" runat="server"
		            Tooltip="RSS" CssClass="forumfeed"
		            NavigateUrl='<%# NonSslSiteRoot + "/Forums/RSS.aspx?pageid=" + PageId.ToString() + "&m=" + ModuleId.ToString() + "~" + ItemId.ToString()  + "~" + Eval("ThreadID") %>' 
		            Visible="<%# Config.EnableRSSAtThreadLevel %>"  />
				<a href='<%# FormatUrl(Convert.ToInt32(Eval("ThreadID"))) %>'>
					<%# Server.HtmlEncode(Eval("ThreadSubject").ToString())%></a>
			</td>
			<td headers='t2' class="fstartedby">  
				<%# Eval("StartedBy") %>
			</td>
			<td headers='t3' class="fpostviews">  
				<%# Eval("TotalViews") %>
			</td>
			<td headers='t4' class="fpostreplies">  
				<%# Eval("TotalReplies") %>
			</td>
			<td headers='t5' class="fpostdate">  
				<%# FormatDate(Convert.ToDateTime(Eval("MostRecentPostDate"))) %>
				<br /><%# Eval("MostRecentPostUser") %>
			</td>
		</tr>
	</AlternatingItemTemplate>--%>
	<FooterTemplate></tbody></table></FooterTemplate>
</asp:Repeater>
	
    <div class="modulepager">
		<portal:mojoCutePager ID="pgrBottom" runat="server" EnableViewState="false" />
		<%--<a href="" class="ModulePager newthread" id="lnkNewThreadBottom" runat="server" EnableViewState="false"></a>--%>
    </div>
<script>
    $(document).ready(function () {
        $("#ChangeLogTable").tablesorter({
            
            sortList: [[4, 1]]
        });
    });
</script>