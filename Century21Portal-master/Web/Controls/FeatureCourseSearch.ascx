<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FeatureCourseSearch.ascx.cs" Inherits="mojoPortal.Web.Controls.FeatureCourseSearch" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<portal:OuterWrapperPanel ID="pnlOuterWrap" runat="server">
    <mp:CornerRounderTop ID="ctop1" runat="server" EnableViewState="false" />
    <portal:InnerWrapperPanel ID="pnlInnerWrap" runat="server" CssClass="panelwrapper linksmodule">
        <portal:ModuleTitleControl ID="Title1" runat="server" EnableViewState="false" />
        <portal:OuterBodyPanel ID="pnlOuterBody" runat="server">
            <portal:InnerBodyPanel ID="pnlInnerBody" runat="server" CssClass="modulecontent">
                <div >
                                    <portal:mojoButton ID="btnAllcourses" Text="All courses" runat="server"
                                                CausesValidation="false" OnClick="btnAllcourses_Click" />

</div>
                <div id="divCourseList" runat="server" class="courseListDiv" style="margin-top: 10px;">
                    
                    <%--<asp:HyperLink ID="lnkAllCourses" runat="server" CssClass="art-button allcourseslink"  />--%>


                        <div id="browsecourselist" class="AspNet-GridView">
                    <asp:UpdatePanel ID="updPnlCourseList" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <%--<portal:mojoCutePager ID="pgrTop" runat="server" />--%>
                            <mp:mojoGridView ID="grdCourseList" runat="server"
                                AllowPaging="false"
                                AllowSorting="true"
                                AutoGenerateColumns="false"
                                EnableViewState="false" CellPadding="3"
                                DataKeyNames="CourseId" BorderWidth="0px"
                                UseAccessibleHeader="true">
                                <Columns>
                                    <asp:TemplateField SortExpression="CourseName">
                                        <ItemTemplate>
                                            <table border="0" cellspacing="0px" cellpadding="0px" style="width: 100%;">
                                                <tr>
                                                    <td colspan="6" class="tdNoBorder">
                                                        <div class="courseListHeader">
                                                            <span class="courseTitle"><%# Eval("CourseName").ToString()%></span>
                                                            <%--<asp:LinkButton runat="server" ID="lnkMore" OnClientClick="return false;" CssClass="the-tooltip top left carrot-orange">More..<span><%#Eval("Description")%> </span></asp:LinkButton>--%>
                                                            <asp:LinkButton runat="server" ID="lnkMore" OnClientClick="return false;">More..</asp:LinkButton>


                                                            <%--<asp:LinkButton ID="lbtnCourseEdit" Visible='<%#SiteUtils.GetCurrentSiteUser()!=null?SiteUtils.GetCurrentSiteUser().IsInRoles("Admins"):false%>' runat="server" PostBackUrl='<%#"~/"+WebConfigSettings.CoursesUrl+"?act=ed&cid="+Eval("CourseId").ToString() %>' Text="Edit"></asp:LinkButton>--%>
                                                        </div>
                                                        <div>
                                                           <%-- <asp:Panel ID="panelCourseMoreInfo" runat="server" style="background-color: #dadada; height:auto; width:400px; padding:20px">
                                                                <span><%#Eval("Description")%> </span>
                                                                <br />
                                                                <portal:mojoButton ID="btnOk" Text="OK" runat="server" />
                                                            </asp:Panel>--%>
                                                        </div>
                                                       <%-- <ajaxToolkit:ModalPopupExtender ID="mpeCourseMoreInfo" runat="server" PopupControlID="panelCourseMoreInfo" TargetControlID="lnkMore"
                                                           DropShadow="true" CancelControlID="btnOk"></ajaxToolkit:ModalPopupExtender>--%>

                                                         <ajaxToolkit:CollapsiblePanelExtender ID="cpe" runat="Server"
                                                            TargetControlID="panelCourseMoreInfo"
                                                            CollapsedSize="0"
                                                            Collapsed="True"
                                                            ExpandControlID="lnkMore"
                                                            CollapseControlID="lnkMore"
                                                            AutoCollapse="false"
                                                            AutoExpand="false"
                                                            ScrollContents="false"    
                                                             TextLabelID="lnkMore"                                                        
                                                            CollapsedText="More"
                                                            ExpandedText="Less"  
                                                            ExpandedImage="~/Images/dialog_close2.ico"                                                           
                                                            ExpandDirection="Vertical" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="6">                                                                                                            
                                                        <asp:Panel ID="panelCourseMoreInfo" runat="server" ScrollBars="None" CssClass="pnlCourseDesc">
                                                          <span><%#Eval("Description")%> </span>                                                            
                                                        </asp:Panel>                                                                                                               
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 17%" class="corseListBody tdBorderRight tdTextCenter"><b>Instructor</b><br /><%# Eval("LeadInstructor").ToString()%></td>
                                                    <td style="width: 30%" class="tdBorderRight tdTextCenter">
                                                       <%-- <img src="Data\Sites\1\skins\Theme_C21\images\postauthoricon.png" />--%>
                                                         <b><mp:SiteLabel ID="lblAudienceCaption" runat="server" ForControl="ddlSortforGridSearch" 
                                                            ConfigKey="CourseListAudience"></mp:SiteLabel></b><br />
                                                        <%# Eval("Audience").ToString().Replace(",","/")%></td>
                                                    <td class="tdBorderRight tdTextCenter" style="width: 16%"> <b><mp:SiteLabel ID="lblCourseLength" runat="server" ForControl="txtCourseLength" 
                                        ConfigKey="CourseListCourseDuration"></mp:SiteLabel></b><br /><%# Eval("CourseLength").ToString()%></td>

                                                    <td class="tdBorderRight tdTextCenter" style="width: 12%"><a target="_blank" href='<%# Eval("UrlLink").ToString()%>'><%# Eval("ScheduleType").ToString()%></a></td>

                                                    <td style="width: 10%;" class="tdNoBorder tdTextCenter">
                                                       <%-- <a href='<%#Resources.Resource.CourseCommentsFeatureUrl+"?parentguid="+Eval("CourseGUID") %>' class="cblink">
                                                                        <img src="Data/Sites/1/skins/Theme_C21/images/commentsicon_Blue.png"></img>

                                                                    </a>--%>

                                                        <a title='<%# Eval("CourseName").ToString()%>' href='<%#WebConfigSettings.CourseCommentsFeatureUrl+"?parentguid="+Eval("CourseGUID") %>' class="cblink">
                                                            <img src="Data/Sites/1/skins/Theme_C21/images/commentsicon_Blue.png"></img>

                                                        </a>

                                                        <br />
                                                       <span class="comments"> <%# Eval("CommentsCount").ToString()%>&nbsp;comments</span>
                                                                    

                                                    </td>
                                                    <td style="text-align: center" class="tdNoBorder tdTextCenter">
                                                        <asp:ImageButton PostBackUrl='<%#"~/"+WebConfigSettings.CoursesUrl+"?act=lk&cid="+Eval("CourseId").ToString() %>' CommandName="SetLike" Enabled='<%# !(bool)Eval("LikeByThisUser")%>' CommandArgument='<%# Eval("CourseId").ToString()%>' ID="imgBtnLikes" runat="server" AlternateText="Like"
                                                            ImageUrl='<%# (bool)Eval("LikeByThisUser") == true?WebConfigSettings.LikeGrayImageUrl:WebConfigSettings.LikeBlueImageUrl%>' />
                                                        <br />
                                                        <span class="likes"><%# Eval("Likes").ToString()%>&nbsp;Likes</span></td>
                                                </tr>
                                            </table>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <p class="nodata">
                                        <asp:Literal ID="litempty" runat="server" Text="<%$ Resources:Resource, GridViewNoData %>" />
                                    </p>
                                </EmptyDataTemplate>
                            </mp:mojoGridView>
                            <%--<asp:Label ID="lblforModelPopup" runat="server" />--%>
                            <%--<portal:mojoCutePager ID="pgrBottom" runat="server" />--%>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    </div>
                </div>
            </portal:InnerBodyPanel>
        </portal:OuterBodyPanel>
    </portal:InnerWrapperPanel>
    <mp:CornerRounderBottom ID="cbottom1" runat="server" EnableViewState="false" />
    <script type="text/javascript">


        $(document).ready(function () {
            //When popup closed, refresh this page
            $(".cblink").colorbox({
                onClosed: function () {
                    //check current page having pagging...
                    //http://localhost:81/browse-course?pagenumber=5
                    var nav = window.location;
                    if (nav.search == '') {
                        window.location.href = "courses";
                    }
                    else if (nav.search.indexOf('pagenumber') > -1) {
                        window.location.href = window.location;
                    }
                }
            });

            //$(".art-header").style.display = "none";
            //$(".art-hmenu").style.display = "none";
            //$(".art-footer").style.display = "none";
            //$(".art-footer-wrapper").style.display = "none";

        });


        var courseListRow = document.getElementById("trCourseList");
        var courseEntryRow = document.getElementById("trCourseEntry");
        var addNewCourseRow = document.getElementById("trAddCourse");

        function AddNewCourse() {
            document.getElementById("trCourseList").style.display = "none";
            document.getElementById("trCourseEntry").style.display = "block";
            document.getElementById("trAddCourse").style.display = "none";
        }

    </script>
</portal:OuterWrapperPanel>
