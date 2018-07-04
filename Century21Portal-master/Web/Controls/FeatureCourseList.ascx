<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FeatureCourseList.ascx.cs" Inherits="mojoPortal.Web.Controls.FeatureCourseList" %>
<%@ Import Namespace="System.Security.Policy" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<style type="text/css">

</style>


<portal:OuterWrapperPanel ID="pnlOuterWrap" runat="server">
    <mp:CornerRounderTop ID="ctop1" runat="server" EnableViewState="false" />
    <portal:InnerWrapperPanel ID="pnlInnerWrap" runat="server" CssClass="panelwrapper linksmodule">
        <portal:ModuleTitleControl ID="Title1" runat="server" EnableViewState="false" />
        <portal:OuterBodyPanel ID="pnlOuterBody" runat="server">
            <portal:InnerBodyPanel ID="pnlInnerBody" runat="server" CssClass="modulecontent">
                <div>
                    <table style="width: 100%" border="0">
                        <tr runat="server" id="trCourseEntry" visible="false">
                            <td colspan="5">
                                <div class="settingrow">
                                    <mp:SiteLabel ID="lblCourseName" runat="server" ForControl="txtCourseName" CssClass="settinglabel"
                                        ConfigKey="CourseListCourseNameLabel"></mp:SiteLabel>
                                    <asp:TextBox ID="txtCourseName" runat="server" TabIndex="10" Columns="45" MaxLength="100"
                                        CssClass="forminput widetextbox"></asp:TextBox><span style="color:red">*</span>
                                    <asp:RequiredFieldValidator ID="reqTxtCourseName" runat="server" ControlToValidate="txtCourseName" ValidationGroup="save"
                                        ErrorMessage=" Required field"></asp:RequiredFieldValidator>
                                </div>
                                <div class="settingrow">
                                    <mp:SiteLabel ID="lblDescription" runat="server" ForControl="txtDescription" CssClass="settinglabel"
                                        ConfigKey="CourseListCourseDescLabel"></mp:SiteLabel>
                                    <asp:TextBox ID="txtDescription" runat="server" TabIndex="10" TextMode="MultiLine" Columns="45"
                                        CssClass="forminput widetextbox"></asp:TextBox>
                                </div>
                                <div class="settingrow">
                                    <mp:SiteLabel ID="lblLeadInstructor" runat="server" ForControl="ddlLeadInstructor" CssClass="settinglabel"
                                        ConfigKey="CourseListLeadInstructor"></mp:SiteLabel>
                                    <%--<asp:TextBox ID="txtLeadInstr" runat="server" TabIndex="10" Columns="45" MaxLength="50"
                                        CssClass="forminput widetextbox"></asp:TextBox>--%>
                                    <asp:DropDownList ID="ddlLeadInstructor" CssClass="dropdown" runat="server" DataValueField="Id" DataTextField="Title">
                                    </asp:DropDownList><span style="color:red">*</span>
                                    <asp:RequiredFieldValidator ID="reqLeadInstructor" runat="server" ControlToValidate="ddlLeadInstructor" ValidationGroup="save"
                                        ErrorMessage=" Required field"></asp:RequiredFieldValidator>
                                </div>
                                <div class="settingrow">
                                    <mp:SiteLabel ID="lblCourseLength" runat="server" ForControl="txtCourseLength" CssClass="settinglabel"
                                        ConfigKey="CourseListCourseLength"></mp:SiteLabel>
                                    <%--        <asp:TextBox ID="txtCourseLength" runat="server" TabIndex="10" Columns="45" MaxLength="250"
                                        CssClass="forminput widetextbox"></asp:TextBox>--%>
                                    <asp:DropDownList ID="ddlCourseLength" CssClass="dropdown" runat="server" DataValueField="Id" DataTextField="Title">
                                    </asp:DropDownList>
                                </div>
                                <div class="settingrow">
                                    <asp:UpdatePanel ID="updPanelAudience" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <mp:SiteLabel ID="lblAudience" runat="server" ForControl="ddlAudience" CssClass="settinglabel"
                                                ConfigKey="CourseListAudience"></mp:SiteLabel>
                                            <asp:TextBox ID="txtAudience" runat="server" TabIndex="10" Columns="45" ReadOnly="true"
                                                CssClass="forminput widetextbox"></asp:TextBox>
                                            <asp:HiddenField ID="hdnAudienceIds" runat="server" />
                                            <%--  <asp:DropDownList ID="ddlAudience" runat="server" DataValueField="UserID" DataTextField="LoginName">
                                            </asp:DropDownList>--%>
                                            <asp:PopupControlExtender
                                                ID="txtAudience_PopupControlExtender" runat="server"
                                                Enabled="True" ExtenderControlID=""
                                                TargetControlID="txtAudience"
                                                PopupControlID="PanelAudience" OffsetY="22">
                                            </asp:PopupControlExtender>
                                            <asp:Panel ID="PanelAudience" runat="server"
                                                BorderStyle="Solid" BorderWidth="0.5px"
                                                Direction="LeftToRight"
                                                ScrollBars="Auto"
                                                Style="display: none" CssClass="aspcheckboxlist">

                                                <asp:CheckBoxList ID="cblAudience" runat="server" RepeatDirection="Vertical"
                                                    AutoPostBack="True" DataTextField="DisplayName" DataValueField="AudienceId"
                                                    OnSelectedIndexChanged="cblAudience_SelectedIndexChanged">
                                                </asp:CheckBoxList>

                                            </asp:Panel>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                                <div class="settingrow">
                                    <mp:SiteLabel ID="lblDelivery" runat="server" ForControl="txtDelivery" CssClass="settinglabel"
                                        ConfigKey="CourseListDelivery"></mp:SiteLabel>
                                    <asp:TextBox ID="txtDelivery" runat="server" TabIndex="10" Columns="45" MaxLength="50"
                                        CssClass="forminput widetextbox"></asp:TextBox>
                                </div>
                                <div class="settingrow">
                                    <mp:SiteLabel ID="lblCost" runat="server" ForControl="txtCost" CssClass="settinglabel"
                                        ConfigKey="CourseListCost"></mp:SiteLabel>
                                    <asp:TextBox ID="txtCost" runat="server" TabIndex="10" Columns="45" MaxLength="30" Text="$0"
                                        CssClass="forminput mediumtextbox"></asp:TextBox>

                                </div>
                                <div class="settingrow">
                                    <mp:SiteLabel ID="lblLinkName" runat="server" ForControl="txtUrlName" CssClass="settinglabel"
                                        ConfigKey="CourseListLinkName"></mp:SiteLabel>
                                    <%--<asp:TextBox ID="txtUrlName" runat="server" TabIndex="10" Columns="45" MaxLength="250"
                                        CssClass="forminput widetextbox"></asp:TextBox>--%>
                                    <asp:DropDownList ID="ddlUrlName" CssClass="dropdown" runat="server" DataValueField="Id" DataTextField="Title">
                                    </asp:DropDownList>
                                </div>
                                <div class="settingrow">
                                    <mp:SiteLabel ID="lblUrlLink" runat="server" ForControl="txtUrlLink" CssClass="settinglabel"
                                        ConfigKey="CourseListLink"></mp:SiteLabel>
                                    <asp:TextBox ID="txtUrlLink" runat="server" TabIndex="10" Columns="45" MaxLength="250"
                                        CssClass="forminput widetextbox"></asp:TextBox>
                                </div>
                                <div class="settingrow">
                                    <asp:UpdatePanel ID="updPanelFilterCategory" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <mp:SiteLabel ID="lblFilterCategory" runat="server" ForControl="ddlFilterCategory" CssClass="settinglabel"
                                                ConfigKey="CourseListFilterCategory"></mp:SiteLabel>
                                            <asp:TextBox ID="txtFilterCategory" runat="server" TabIndex="10" Columns="45" ReadOnly="true"
                                                CssClass="forminput widetextbox">
                                            </asp:TextBox>
                                            <asp:HiddenField ID="hdnFilterCategoryIds" runat="server" />
                                            <%--  <asp:DropDownList ID="ddlFilterCategory" runat="server" DataValueField="UserID" DataTextField="LoginName">
                                        </asp:DropDownList>--%>
                                            <asp:PopupControlExtender
                                                ID="txtFilterCategory_PopupControlExtender" runat="server"
                                                Enabled="True" ExtenderControlID=""
                                                TargetControlID="txtFilterCategory"
                                                PopupControlID="PanelFilterCategory" OffsetY="22">
                                            </asp:PopupControlExtender>
                                            <asp:Panel ID="PanelFilterCategory" runat="server"
                                                BorderStyle="Solid" BorderWidth="0.5px"
                                                Direction="NotSet"
                                                ScrollBars="Auto" CssClass="aspcheckboxlist"
                                                Style="display: none">
                                                <asp:CheckBoxList ID="cblFilterCategory" runat="server" RepeatDirection="Vertical"
                                                    AutoPostBack="True" DataTextField="RoleName" DataValueField="RoleID"
                                                    OnSelectedIndexChanged="cblFilterCategory_SelectedIndexChanged">
                                                </asp:CheckBoxList>
                                            </asp:Panel>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                                <div class="settingrow">
                                    <mp:SiteLabel ID="lblMetaTags" runat="server" ForControl="txtMetaTags" CssClass="settinglabel"
                                        ConfigKey="CourseListMetaTags"></mp:SiteLabel>
                                    <asp:TextBox ID="txtMetaTags" runat="server" TabIndex="10" TextMode="MultiLine" Columns="45" MaxLength="250"
                                        CssClass="forminput widetextbox"></asp:TextBox>
                                </div>
                                <div class="settingrow">
                                    <mp:SiteLabel ID="lblActive" runat="server" ForControl="chkActive" CssClass="settinglabel"
                                        ConfigKey="CourseListActive"></mp:SiteLabel>
                                    <asp:CheckBox ID="chkActive" runat="server" Checked="true" CssClass="forminput" />
                                </div>
                                <div class="settingrow">
                                    <portal:mojoButton ID="btnSave" ValidationGroup="save" Text="<%#Resources.Resource.CourseEntrySaveButton %>" runat="server" OnClick="btnSave_Click" />
                                    <portal:mojoButton ID="btnCancel" Text="<%#Resources.Resource.CourseEntryCancelButton %>" runat="server" OnClick="btnCancel_Click" />
                                    <portal:mojoButton ID="btnDelete" Text="<%#Resources.Resource.CourseDeleteBtn %>" Visible="false" runat="server" OnClick="btnDelete_Click" />

                                </div>
                            </td>
                        </tr>

                    </table>
                    <div id="courseFilter">
                        <table style="width: 100%" border="0">
                            <tr runat="server" id="trAddCourse">
                                <td colspan="5">

                                    <table class="FilterGride">
                                        <tr class="courseModuleFilter">
                                            <td class="tdaddcourse">
                                                <!--style="width: 25%; padding-left: 10px;"-->
                                                <portal:mojoButton ID="btnAddCourse" Text="<%#Resources.Resource.CourseAddButton %>" runat="server"
                                                    CausesValidation="false" OnClick="btnAddCourse_Click" />
                                            </td>

                                            <td class="tdFilterforGridSearch">
                                                <!-- style="width: 17%;"-->
                                                <%--             <asp:updatepanel id="UpdatePanelFilterBy" runat="server" updatemode="Always">
                                             <ContentTemplate>--%>
                                                <mp:SiteLabel ID="lblFilterBy" runat="server" ForControl="ddlFilterforGridSearch"
                                                    ConfigKey="CourseListFilterBy"></mp:SiteLabel>
                                                <%--</td>
                                        <td style="width: 20%">--%>
                                                <asp:DropDownList ID="ddlFilterforGridSearch" CssClass="dropdown" runat="server" DataTextField="RoleName" AutoPostBack="true"
                                                    DataValueField="RoleID" OnSelectedIndexChanged="ddlFilterforGridSearch_SelectedIndexChanged">
                                                </asp:DropDownList>
                                                <%--</ContentTemplate>
                                                <Triggers>
                                               <asp:AsyncPostBackTrigger ControlID="ddlFilterforGridSearch" EventName="SelectedIndexChanged" />
                                               </Triggers>
                                         </asp:UpdatePanel> --%>
                                          
                                            </td>

                                            <td class="tdSortforGridSearch">
                                                <!--style="width: 9%;" -->
                                                <%--<asp:updatepanel id="UpdatePanelSortBy" runat="server" updatemode="Always">
                                             <ContentTemplate>--%>
                                                <mp:SiteLabel ID="lblSortBy" runat="server" ForControl="ddlSortforGridSearch"
                                                    ConfigKey="CourseListSortBy"></mp:SiteLabel>
                                                <%--  </td>
                                        <td style="width: 20%">--%>
                                                <asp:DropDownList ID="ddlSortforGridSearch" CssClass="dropdown" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlSortforGridSearch_SelectedIndexChanged">
                                                    <asp:ListItem Text="--Sort by--" Value=""></asp:ListItem>
                                                    <asp:ListItem Text="Course Title" Value="C"></asp:ListItem>
                                                    <asp:ListItem Text="Instructor" Value="I"></asp:ListItem>
                                                </asp:DropDownList>
                                                <%--                </ContentTemplate>
                                                <Triggers>
                                               <asp:AsyncPostBackTrigger ControlID="ddlSortforGridSearch" EventName="SelectedIndexChanged" />
                                               </Triggers>
                                         </asp:UpdatePanel> --%>
                                            </td>
                                        </tr>
                                    </table>

                                </td>
                            </tr>
                            <tr runat="server" id="trFilterSort">
                                <td colspan="5">
                                    <%--<asp:updatepanel id="UpdatePanel1" runat="server" updatemode="Conditional">
                                             <ContentTemplate>--%>
                                    <div class="settingrow" style="text-align: right">
                                        <h6>
                                            <asp:Literal ID="lblCourseCount" runat="server"></asp:Literal></></h6>
                                    </div>
                                    <%--</ContentTemplate>
                                    </asp:UpdatePanel> --%>
                                </td>
                            </tr>
                            <tr runat="server" id="trCourseList">
                                <td colspan="5">
                                    <%-- divCourseList was here--%>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="5"></td>
                            </tr>
                        </table>
                    </div>
                </div>
                <%--<div id="dialog-confirm" title="Information" style="display: none;">
                    <p><span class="ui-icon ui-icon-alert" style="float: left; margin: 0 7px 20px 0;"></span>you are being taken to an external site outside of the portal</p>
                </div>--%>
                <div id="divCourseList" runat="server" class="courseListDiv">
                    <%--<asp:UpdatePanel ID="updPnlCourseList" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <%--<portal:mojoCutePager ID="pgrTop" runat="server" />--%>
                    <div id="browsecourselist" class="AspNet-GridView">
                        <asp:GridView ID="grdCourseList" runat="server" CssClass="AspNet-GridView"
                            AutoGenerateColumns="false"
                            EnableViewState="false" CellPadding="3"
                            DataKeyNames="CourseId" BorderWidth="0px"
                            OnRowCommand="grdCourseList_RowCommand" AllowPaging="true" PageSize="15"
                            UseAccessibleHeader="true" ShowHeader="false" OnPageIndexChanging="grdCourseList_PageIndexChanging1" ShowFooter="true">
                            <HeaderStyle BorderWidth="0" BorderStyle="None" CssClass="noDisplay" />
                            <Columns>
                                <asp:TemplateField SortExpression="CourseName">
                                    <ItemTemplate>
                                        <table border="0" cellspacing="0px" cellpadding="0px" style="width: 100%;">
                                            <tr>
                                                <td colspan="6" class="tdNoBorder">
                                                    <%# (Eval("Active").ToString()=="0")?"<img src='Data\\Sites\\1\\skins\\Theme_C21\\images\\inactive.png' title='Inactive course' style='float:left;'/>":"" %>
                                                    <div class="courseListHeader">

                                                        <span class="courseTitle"><%# Eval("CourseName").ToString()%></span>
                                                        <%--<asp:LinkButton runat="server" ID="lnkMore" OnClientClick="return false;" CssClass="the-tooltip top left carrot-orange">More..<span><%#Eval("Description")%> </span></asp:LinkButton>--%>
                                                        <asp:LinkButton runat="server" ID="lnkMore" OnClientClick="return false;">More..</asp:LinkButton>
                                                        <%--OnClick="lbtnEdit_Click"--%>
                                                        <asp:LinkButton ID="lbtnCourseEdit" Visible='<%#SiteUtils.GetCurrentSiteUser()!=null?SiteUtils.GetCurrentSiteUser().IsInRoles("Admins"):false%>' runat="server" Text="Edit" CommandName="EditCourse" CommandArgument='<%#Eval("CourseId")  %>' CausesValidation="true"></asp:LinkButton>

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
                                                <td style="width: 17%" class="corseListBody tdBorderRight tdTextCenter"><b>Instructor</b><br />
                                                    <%# Eval("LeadInstructor").ToString()%></td>
                                                <td style="width: 30%" class="tdBorderRight tdTextCenter">
                                                    <%-- <img src="Data\Sites\1\skins\Theme_C21\images\postauthoricon.png" />--%>
                                                    <b>
                                                        <mp:SiteLabel ID="lblAudienceCaption" runat="server" ForControl="ddlSortforGridSearch"
                                                            ConfigKey="CourseListAudience"></mp:SiteLabel>
                                                    </b>
                                                    <br />
                                                    <%# Eval("Audience").ToString().Replace(",","/")%></td>
                                                <td class="tdBorderRight tdTextCenter" style="width: 16%"><b>
                                                    <mp:SiteLabel ID="lblCourseLength" runat="server" ForControl="txtCourseLength"
                                                        ConfigKey="CourseListCourseDuration"></mp:SiteLabel>
                                                </b>
                                                    <br />
                                                    <%# Eval("CourseLength").ToString()%></td>
                                                <td class="tdBorderRight tdTextCenter" style="width: 12%">
                                                    <!--If schedule type is "Check Schedule", pass title as parameter to schedule page -->
                                                    <%# 
                                                    string.Format(
                                                    (Eval("ScheduleType").ToString() == "Check Schedule") && (Eval("UrlLink").ToString().Contains(Request.Url.Host)) 
                                                    ? "<a target='_blank' id='urlLink_{0}' href='{1}{2}'>{3}</a>"
                                                    : "<a target='_blank' id='urlLink_{0}' href='{1}'>{3}</a>"
                                                    , Eval("CourseId"), Eval("UrlLink"), "?title=" + Eval("CourseName").ToString(), Eval("ScheduleType") 
                                                    )
                                                    %>
                                                    <%--<a target="_blank" id='urlLink_<%# Eval("CourseId").ToString()%>' href='<%# Eval("UrlLink").ToString()%>'><%# Eval("ScheduleType").ToString()%></a>--%>
                                                </td>

                                                <td style="width: 10%;" class="tdNoBorder tdTextCenter">
                                                    <%-- <a href='<%#Resources.Resource.CourseCommentsFeatureUrl+"?parentguid="+Eval("CourseGUID") %>' class="cblink">
                                                                        <img src="Data/Sites/1/skins/Theme_C21/images/commentsicon_Blue.png"></img>

                                                                    </a>--%>

                                                    <a title='<%# Eval("CourseName").ToString()%>' href='<%#WebConfigSettings.CourseCommentsFeatureUrl+"?parentguid="+Eval("CourseGUID") %>' class="cblink">
                                                        <img src="Data/Sites/1/skins/Theme_C21/images/commentsicon_Blue.png"></img>

                                                    </a>

                                                    <br />
                                                    <span class="comments"><%# Eval("CommentsCount").ToString()%>&nbsp;comments</span>


                                                </td>
                                                <td style="text-align: center" class="tdNoBorder tdTextCenter">
                                                    <asp:ImageButton PostBackUrl='<%#"~/"+WebConfigSettings.CoursesUrl+"?act=lk&cid="+Eval("CourseId").ToString() %>' CommandName="SetLike" Enabled='<%# !(bool)Eval("LikeByThisUser")%>' CommandArgument='<%# Eval("CourseId").ToString()%>' ID="imgBtnLikes" runat="server" AlternateText="Like"
                                                        ImageUrl='<%# (bool)Eval("LikeByThisUser") == true?WebConfigSettings.LikeGrayImageUrl:WebConfigSettings.LikeBlueImageUrl%>' />
                                                    <br />
                                                    <span class="likes"><%# Eval("Likes").ToString()%>&nbsp;Likes</span></td>
                                                <%-- <td>
                                                         <pagersettings mode="Numeric"  position="Bottom"  pagebuttoncount="10"/>  
         
                                                    <pagerstyle backcolor="LightBlue"   height="30px"   verticalalign="Bottom"   horizontalalign="Center"/>
                                                    </td>--%>
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
                            <PagerSettings Mode="NumericFirstLast" Position="Bottom" FirstPageText="<<" LastPageText=">>" PageButtonCount="5" />
                            <PagerStyle CssClass="pagination-ys" />

                        </asp:GridView>
                    </div>
                    <%--<asp:Label ID="lblforModelPopup" runat="server" />--%>
                    <%--<portal:mojoCutePager ID="pgrBottom" runat="server" />--%>
                    <%-- </ContentTemplate>
                    </asp:UpdatePanel> --%>
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
                        window.location.href = "browse-courses";
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
        //commented confirm dialog code as it is implemented in layout.master
        //$(function () {
        //    $('a[id^=urlLink]').click(function (event) {

        //        //$("#dialog-confirm").html("TAG").fadeIn().delay(3000).fadeOut();
        //        var link = $(event.toElement).closest(":has(tr td div span)").find('span.courseTitle');
        //        console.log(link.text()); //"Hello"
        //        if (event.toElement.innerText != 'Check Schedule') {
        //            $("#dialog-confirm").dialog({
        //                resizable: false,
        //                height: 200,
        //                modal: true,
        //                open: function (evnt, ui) {
        //                    setTimeout(function () {
        //                        $(".ui-dialog-titlebar-close", ui.dialog | ui).hide();
        //                        $('#dialog-confirm').dialog('close');//window.parent.$('#divDialog').dialog('close');
        //                        window.open(event.toElement.href, '_blank');
        //                        return true;
        //                    }, 2000); // milliseconds delay

        //                }
        //                //,
        //                //buttons: {
        //                //    //"Ok": function () {
        //                //    //    $(this).dialog("close");
        //                //    //    window.open(event.toElement.href, '_blank');
        //                //    //    return true;
        //                //    //},
        //                //    //Cancel: function () {
        //                //    //    $(this).dialog("close");
        //                //    //    event.preventDefault();
        //                //    //}
        //                //}
        //            });
        //            return false;
        //        }
        //        else {
        //            window.open(event.toElement.href + "?title=" + $.trim(link.text()).replace(/ /g, "_"), '_blank');
        //            event.preventDefault();
        //            //return true;
        //        }
        //    });

        //});
    </script>
</portal:OuterWrapperPanel>
