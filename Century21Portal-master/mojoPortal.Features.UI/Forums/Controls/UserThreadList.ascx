<%@ Control Language="C#" AutoEventWireup="false" CodeBehind="UserThreadList.ascx.cs" Inherits="mojoPortal.Web.ForumUI.UserThreadList" %>
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
 #tableUserThread tbody tr:nth-child(odd) {
   background-color: #e3e4e6;   
}
    ftitle {
        width: 45%;
    }
</style>
<div class="modulepager">
		<portal:mojoCutePager ID="pgrTop" runat="server" />
	</div>
	
<asp:Repeater id="rptForums" runat="server" >
	<HeaderTemplate><table summary='<%# Resources.ForumResources.ForumViewTableSummary %>' id="tableUserThread" border="0" cellspacing="1" width="100%" cellpadding="3">
		<thead><tr class="moduletitle forumTitle">
			<th id='<%# Resources.ForumResources.ForumViewSubjectLabel %>' class="ftitle">
				<mp:SiteLabel id="SiteLabel1" runat="server" ConfigKey="ForumViewSubjectLabel" ResourceFile="ForumResources" UseLabelTag="false" />
			</th>
			<th id='<%# Resources.ForumResources.ForumLabel %>' class="fforumtitle" >
				<mp:SiteLabel id="ForumLabel1" runat="server" ConfigKey="ForumLabel" ResourceFile="ForumResources" UseLabelTag="false" />
			</th>
			<th id='<%# Resources.ForumResources.ForumViewStartedByLabel %>' class="fstartedby">
				<mp:SiteLabel id="lblForumStartedBy" runat="server" ConfigKey="ForumViewStartedByLabel" ResourceFile="ForumResources" UseLabelTag="false" />
			</th>
			<th id='<%# Resources.ForumResources.ForumViewViewCountLabel %>' class="fpostviews">
				<mp:SiteLabel id="lblTotalViewsCountLabel" runat="server" ConfigKey="ForumViewViewCountLabel" ResourceFile="ForumResources" UseLabelTag="false" />
			</th>
			<th id='<%# Resources.ForumResources.ForumViewReplyCountLabel %>' class="fpostreplies">
				<mp:SiteLabel id="lblTotalRepliesCountLabel" runat="server" ConfigKey="ForumViewReplyCountLabel" ResourceFile="ForumResources" UseLabelTag="false" />
			</th >
			<th id='<%# Resources.ForumResources.ForumViewPostLastPostLabel %>' class="fpostdate">
				<mp:SiteLabel id="lblLastPostLabel" runat="server" ConfigKey="ForumViewPostLastPostLabel" ResourceFile="ForumResources" UseLabelTag="false" />	
			</th>
		</tr></thead></HeaderTemplate>
	<ItemTemplate>
		<tr class="modulerow">
			<td headers='<%# Resources.ForumResources.ForumViewSubjectLabel %>' class="ftitle"> 
				<img alt="" src='<%# ImageSiteRoot + "/Data/SiteImages/thread.gif"  %>'  />
				<a href='<%# FormatThreadUrl(Convert.ToInt32(Eval("ThreadID")),Convert.ToInt32(Eval("ModuleID")),Convert.ToInt32(Eval("ForumID")),Convert.ToInt32(Eval("PageID"))) %>'>
					<%# Server.HtmlEncode(DataBinder.Eval(Container.DataItem, "ThreadSubject").ToString())%></a>
			</td>
			<td headers='<%# Resources.ForumResources.ForumLabel %>' class="fforumtitle">    
				<a href='<%# FormatForumUrl(Convert.ToInt32(Eval("ForumID")),Convert.ToInt32(Eval("ModuleID")), Convert.ToInt32(Eval("PageID"))) %>'>
					<%# Server.HtmlEncode(DataBinder.Eval(Container.DataItem, "Forum").ToString())%></a>		
			</td>
			<td headers='<%# Resources.ForumResources.ForumViewStartedByLabel %>' class="fstartedby">  
				<%# DataBinder.Eval(Container.DataItem, "StartedBy")%>
			</td>
			<td headers='<%# Resources.ForumResources.ForumViewViewCountLabel %>' class="fpostviews">  
				<%# DataBinder.Eval(Container.DataItem, "TotalViews")%>
			</td>
			<td headers='<%# Resources.ForumResources.ForumViewReplyCountLabel %>' class="fpostreplies">  
				<%# DataBinder.Eval(Container.DataItem, "TotalReplies")%>
			</td>
			<td headers='<%# Resources.ForumResources.ForumViewPostLastPostLabel %>' class="fpostdate">  
				<%# DateTimeHelper.GetTimeZoneAdjustedDateTimeString(((System.Data.Common.DbDataRecord)Container.DataItem), "MostRecentPostDate", timeOffset)%>
				<br /><%# DataBinder.Eval(Container.DataItem, "MostRecentPostUser")%>
			</td>
		</tr>
	</ItemTemplate>
	<%--<AlternatingItemTemplate>
		<tr class="modulealtrow">
			<td  headers='<%# Resources.ForumResources.ForumViewSubjectLabel %>' class="ftitle"> 
				<img alt="" src='<%# ImageSiteRoot + "/Data/SiteImages/thread.gif"  %>'  />
				<a href='<%# FormatThreadUrl(Convert.ToInt32(Eval("ThreadID")),Convert.ToInt32(Eval("ModuleID")),Convert.ToInt32(Eval("ForumID")),Convert.ToInt32(Eval("PageID"))) %>'>
					<%# Server.HtmlEncode(DataBinder.Eval(Container.DataItem, "ThreadSubject").ToString())%></a>
			</td>
			<td headers='<%# Resources.ForumResources.ForumLabel %>' class="fforumtitle"> 	
				<a href='<%# FormatForumUrl(Convert.ToInt32(Eval("ForumID")),Convert.ToInt32(Eval("ModuleID")), Convert.ToInt32(Eval("PageID"))) %>'>
					<%# Server.HtmlEncode(DataBinder.Eval(Container.DataItem, "Forum").ToString())%></a>		
			</td>
			<td headers='<%# Resources.ForumResources.ForumViewStartedByLabel %>' class="fstartedby">  
				<%# DataBinder.Eval(Container.DataItem, "StartedBy")%>
			</td>
			<td headers='<%# Resources.ForumResources.ForumViewViewCountLabel %>' class="fpostviews">  
				<%# DataBinder.Eval(Container.DataItem, "TotalViews")%>
			</td>
			<td headers='<%# Resources.ForumResources.ForumViewReplyCountLabel %>' class="fpostreplies">  
				<%# DataBinder.Eval(Container.DataItem, "TotalReplies")%>
			</td>
			<td headers='<%# Resources.ForumResources.ForumViewPostLastPostLabel %>' class="fpostdate">  
				<%# DateTimeHelper.GetTimeZoneAdjustedDateTimeString(((System.Data.Common.DbDataRecord)Container.DataItem), "MostRecentPostDate", timeOffset)%>
				<br /><%# DataBinder.Eval(Container.DataItem, "MostRecentPostUser")%>
			</td>
		</tr>
	</AlternatingItemTemplate>--%>
	<FooterTemplate></tbody></table></FooterTemplate>
</asp:Repeater>
	
	<div class="modulepager">
		<portal:mojoCutePager ID="pgrBottom" runat="server" />
	</div>
<script>
    $(document).ready(function () {
        $("#tableUserThread").tablesorter({
            widgets: ['zebra'],
            sortList: [[5, 1]]
        });
    });
</script>