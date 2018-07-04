<%@ Control Language="C#" AutoEventWireup="false" CodeBehind="CommentsWidget.ascx.cs" Inherits="mojoPortal.Web.UI.CommentsWidget" %>
<portal:CommentSystemDisplaySettings id="displaySettings" runat="server" />
<portal:CommentsOuterPanel ID="pnlFeedback" runat="server" CssClass="bcommentpanel">
<portal:HeadingControl ID="commentListHeading" runat="server" SkinID="Comments" HeadingTag="h3"/>
<portal:CommentsInnerPanel ID="pnlListWrapper" runat="server" CssClass="postlistwrap">
    <asp:Repeater ID="rptComments" runat="server" EnableViewState="true">
        <ItemTemplate>
            <portal:CommentItemWrapper id="pnlItem" runat="server" CssClass='<%# "postcontainer modstatus" + Eval("ModerationStatus").ToString() %>' Visible='<%# UserCanModerate || (Convert.ToInt32(Eval("ModerationStatus")) == Comment.ModerationApproved)   %>'>
           <%-- <portal:CommentDateWrapper id="dw1" runat="server" CssClass="forumpostheader">
                <%# FormatCommentDate(Convert.ToDateTime(Eval("CreatedUtc"))) %>
            </portal:CommentDateWrapper>--%>
            <portal:CommentItemInnerPanel id="ip1" runat="server" CssClass="postwrapper">
                <portal:CommentItemLeftPanel id="pnlLeft" runat="server" CssClass="postleft">                   
                    <div class="forumpostuseravatar">
                    <portal:Avatar id="av1" runat="server"	                    
	                    MaxAllowedRating='<%# MaxAllowedGravatarRating %>'
                        AvatarFile='<%# Eval("PostAuthorAvatar") %>'
	                    UserName='<%# Eval("PostAuthor") %>'
                        UserId='<%# Convert.ToInt32(Eval("UserId")) %>'
                        SiteId='<%# SiteId %>'
                        SiteRoot='<%# SiteRoot %>'
	                    Email='<%# Eval("AuthorEmail") %>'
                        UserNameTooltipFormat='<%# UserNameTooltipFormat %>'
	                    Disable='<%# disableAvatars %>'
	                    UseGravatar='<%# allowGravatars %>'
                        />
                    </div>
                    <div id="divRevenue" runat="server" visible='<%# showUserRevenue %>' class="forumpostuserattribute">
                        <mp:SiteLabel ID="SiteLabel1" runat="server" ConfigKey="UserSalesLabel" ResourceFile="ForumResources"
                            UseLabelTag="false" />
                        <%# string.Format(currencyCulture, "{0:c}", Convert.ToDecimal(Eval("UserRevenue"))) %>
                    </div>
                    <portal:mojoButton id="btnDelete" runat="server" Text='<%$ Resources:Resource, DeleteButtonComments %>' CommandName="DeleteComment" CommandArgument='<%# Eval("Guid")%>'
                        Visible='<%# UserCanModerate %>' />
                   <portal:mojoButton id="btnApprove" runat="server" Text='<%$ Resources:Resource, ContentManagerPublishContentLink %>' CommandName="ApproveComment" CommandArgument='<%# Eval("Guid")%>'
                        Visible='<%# UserCanModerate && (Convert.ToInt32(Eval("ModerationStatus")) != Comment.ModerationApproved) %>' />
                    
                </portal:CommentItemLeftPanel>
                <portal:CommentItemRightPanel id="pnlRight" runat="server" CssClass="postright">
                     <div class="forumpostusername">
                        <asp:HyperLink ID="useredit1" runat="server" 
                            ImageUrl='<%#  Page.ResolveUrl(UserEditIcon)  %>'                            
                            NavigateUrl='<%# SiteRoot + "/Admin/ManageUsers.aspx?userid=" + Eval("UserId")   %>'
                            Enabled="false"
                            Visible='<%# CanManageUsers && (Convert.ToInt32(Eval("UserId")) > -1) %>'  />
<%--                        <%# GetProfileLinkOrLabel(Convert.ToInt32(Eval("UserId")), Eval("PostAuthor").ToString(), Eval("PostAuthorWebSiteUrl").ToString())%>--%>
                         <%#Eval("PostAuthor").ToString()%>
                         <span class="postduration"><%# GetCommentDuration(Convert.ToDateTime(Eval("CreatedUtc"))) %></span>
                    </div>
                    <NeatHtml:UntrustedContent ID="UntrustedContent1" runat="server" TrustedImageUrlPattern='<%# AllowedImageUrlRegexPatern %>'
                            ClientScriptUrl="~/ClientScript/NeatHtml.js">
                    <portal:CommentItemTitlePanel id="pnlTitle" runat="server" CssClass="posttopic"  Visible='<%# UseCommentTitle %>'>
                        <<%# CommentItemHeaderElement %>>
                            <a id='post<%# Eval("Guid") %>'></a>
                            
                            <%# Server.HtmlEncode(Eval("Title").ToString())%></<%# CommentItemHeaderElement %>>
                    </portal:CommentItemTitlePanel>
                    <portal:CommentItemBodyPanel id="pnlBody" runat="server" CssClass="postbody">
                            <%# Eval("UserComment").ToString()%>   
                    </portal:CommentItemBodyPanel>
                   </NeatHtml:UntrustedContent>
                    <asp:HyperLink  CssClass="commentEdit ceditlink" Text="<%$ Resources:Resource, EditLink %>"
                                ID="editLink" 
                                 NavigateUrl='<%# EditBaseUrl + "&c=" + Eval("Guid")  %>'
                                Visible='<%# UserCanEdit(new Guid(Eval("UserGuid").ToString()), Eval("UserEmail").ToString(), Convert.ToInt32(Eval("ModerationStatus")), Convert.ToDateTime(Eval("CreatedUtc"))) %>' runat="server" />
                </portal:CommentItemRightPanel>
            </portal:CommentItemInnerPanel>
            </portal:CommentItemWrapper>
        </ItemTemplate>
        <AlternatingItemTemplate>
            <portal:CommentItemWrapper id="pnlItem" runat="server" CssClass='<%# "postcontainer postcontaineralt modstatus" + Eval("ModerationStatus").ToString() %>' Visible='<%# UserCanModerate || (Convert.ToInt32(Eval("ModerationStatus")) == Comment.ModerationApproved)   %>'>
           <%-- <portal:CommentDateWrapper id="dw1" runat="server" CssClass="forumpostheader">
                <%# FormatCommentDate(Convert.ToDateTime(Eval("CreatedUtc"))) %>
            </portal:CommentDateWrapper>--%>
            <portal:CommentItemInnerPanel id="ip1" runat="server" CssClass="postwrapper">
                <portal:CommentItemLeftPanel id="pnlLeft" runat="server" CssClass="postleft">                  
                    <div class="forumpostuseravatar">
                    <portal:Avatar id="av1" runat="server"	                    
	                    MaxAllowedRating='<%# MaxAllowedGravatarRating %>'
                        AvatarFile='<%# Eval("PostAuthorAvatar") %>'
	                    UserName='<%# Eval("PostAuthor") %>'
                        UserId='<%# Convert.ToInt32(Eval("UserId")) %>'
                        SiteId='<%# SiteId %>'
                        SiteRoot='<%# SiteRoot %>'
	                    Email='<%# Eval("AuthorEmail") %>'
                        UserNameTooltipFormat='<%# UserNameTooltipFormat %>'
	                    Disable='<%# disableAvatars %>'
	                    UseGravatar='<%# allowGravatars %>'
                        />
                    </div>
                    <div id="divRevenue" runat="server" visible='<%# showUserRevenue %>' class="forumpostuserattribute">
                        <mp:SiteLabel ID="SiteLabel1" runat="server" ConfigKey="UserSalesLabel" ResourceFile="ForumResources"
                            UseLabelTag="false" />
                        <%# string.Format(currencyCulture, "{0:c}", Convert.ToDecimal(Eval("UserRevenue"))) %>
                    </div>
                    <portal:mojoButton id="btnDelete" runat="server" Text='<%$ Resources:Resource, DeleteButtonComments %>' CommandName="DeleteComment" CommandArgument='<%# Eval("Guid")%>'
                        Visible='<%# UserCanModerate %>' />
                    <portal:mojoButton id="btnApprove" runat="server" Text='<%$ Resources:Resource, ContentManagerPublishContentLink %>' CommandName="ApproveComment" CommandArgument='<%# Eval("Guid")%>'
                        Visible='<%# UserCanModerate && (Convert.ToInt32(Eval("ModerationStatus")) != Comment.ModerationApproved) %>' />
                </portal:CommentItemLeftPanel>
                <portal:CommentItemRightPanel id="pnlRight" runat="server" CssClass="postright"> 
                      <div class="forumpostusername">
                        <asp:HyperLink ID="edituser2"  runat="server"                            
                            ImageUrl='<%# Page.ResolveUrl(UserEditIcon)  %>'
                            NavigateUrl='<%# SiteRoot + "/Admin/ManageUsers.aspx?userid=" + Eval("UserId")   %>'
                            Enabled="false"
                            Visible='<%# CanManageUsers && (Convert.ToInt32(Eval("UserId")) > -1) %>' />
                        <%--<%# GetProfileLinkOrLabel(Convert.ToInt32(Eval("UserId")), Eval("PostAuthor").ToString(),Eval("PostAuthorWebSiteUrl").ToString())%>--%>
                          <%#Eval("PostAuthor").ToString()%>
                          <span class="postduration"><%# GetCommentDuration(Convert.ToDateTime(Eval("CreatedUtc"))) %></span>
                    </div>
                    <NeatHtml:UntrustedContent ID="UntrustedContent1" runat="server" TrustedImageUrlPattern='<%# AllowedImageUrlRegexPatern %>'
                            ClientScriptUrl="~/ClientScript/NeatHtml.js">
                    <portal:CommentItemTitlePanel id="pnlTitle" runat="server" CssClass="posttopic" Visible='<%# UseCommentTitle %>'>
                        <<%# CommentItemHeaderElement %>>
                            <a id='post<%# Eval("Guid") %>'></a>
                            <%# Server.HtmlEncode(Eval("Title").ToString())%></<%# CommentItemHeaderElement %>>
                    </portal:CommentItemTitlePanel>
                    <portal:CommentItemBodyPanel id="pnlBody" runat="server" CssClass="postbody">
                            <%# Eval("UserComment").ToString()%>
                    </portal:CommentItemBodyPanel>    
                    </NeatHtml:UntrustedContent>
                    <asp:HyperLink  CssClass="commentEdit ceditlink" Text="<%$ Resources:Resource, EditLink %>"
                                ID="editLink" 
                                NavigateUrl='<%# EditBaseUrl + "&c=" + Eval("Guid")  %>'
                                Visible='<%# UserCanEdit(new Guid(Eval("UserGuid").ToString()), Eval("UserEmail").ToString(), Convert.ToInt32(Eval("ModerationStatus")), Convert.ToDateTime(Eval("CreatedUtc"))) %>' runat="server" />
                </portal:CommentItemRightPanel>
            </portal:CommentItemInnerPanel>
            </portal:CommentItemWrapper>
        </AlternatingItemTemplate>
    </asp:Repeater>
    </portal:CommentsInnerPanel>
    <portal:CommentEditor id="commentEditor" runat="server" />
    <asp:Panel ID="pnlCommentsClosed" runat="server" EnableViewState="false" CssClass="commentsclosed">
        <asp:Literal ID="litCommentsClosed" runat="server" EnableViewState="false" />
    </asp:Panel>
    <asp:Panel ID="pnlCommentsRequireAuthentication" runat="server" Visible="false" EnableViewState="false" CssClass="commentsclosed">
        <portal:SignInOrRegisterPrompt ID="srPrompt" runat="server" />
    </asp:Panel>
    <script type="text/javascript">
        
        $(document).ready(function () {
            
            var url = window.location.href;
            if (url.indexOf('coursecomments')>0) {
                $(".art-hmenu").removeAttr("style").attr('style', 'display:none');
                $(".art-footer").removeAttr("style").attr('style', 'display:none');
                $(".art-footer-wrapper").removeAttr("style").attr('style', 'display:none');
                $(".searchpanel").removeAttr("style").attr('style', 'display:none');
                $(".topnavwrap").removeAttr("style").attr('style', 'display:none');
                $("#toolbar").removeAttr("style").attr('style', 'display:none');
                $("#toolbarbut").remove();//removeAttr("style").attr('style', 'display:none');
                $("#top-stuff").remove();
                $(".art-shapesbottom").removeAttr("style").attr('style', 'display:none');
                $(".art-nav-inner").removeAttr("style").attr('style', 'display:none');
                $(".art-shape-search").removeAttr("style").attr('style', 'display:none');
                var header = $(".art-header");//.removeAttr("style").attr('style', 'display:none');
                header.removeClass("art-header");
                var span = $(".modulelinks");
                span.remove();
                var span1 = $(".showbar");
                span1.remove();
            }

        });

    </script>
</portal:CommentsOuterPanel>
<div id="divCommentService" runat="server" enableviewstate="false" class="blogcommentservice commentservice">
    <portal:IntenseDebateDiscussion ID="intenseDebate" runat="server" EnableViewState="false" />
    <portal:DisqusWidget ID="disqus" runat="server" RenderPoweredBy="false" EnableViewState="false" />
    <portal:FacebookCommentWidget ID="fbComments" runat="server" Visible="false" EnableViewState="false" SkinID="Blog" />
</div>
