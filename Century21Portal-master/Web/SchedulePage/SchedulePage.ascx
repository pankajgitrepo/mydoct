<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SchedulePage.ascx.cs" Inherits="mojoPortal.Web.SchedulePage.SchedulePage"  %>
<%@ Import Namespace="System.ComponentModel" %>
<%@ Register TagPrefix="asp" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit, Version=15.1.1.100, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e" %>
<link href="ClientScript/jqueryDatePicker/jquery.datetimepicker.css" rel="stylesheet" />
<script src="ClientScript/jqueryDatePicker/jquery.datetimepicker.js"></script>
<script src="ClientScript/validateInputs.js"></script>
<script type="text/javascript">
    $(function () {
        //$('a[id^=urlLink]').click(function (event) {
        
        //$("#dialog-confirm").dialog({
        //    resizable: false,
        //    height: 200,
        //    modal: true,
        //    buttons: {
        //        "Ok": function () {
        //            $(this).dialog("close");
        //            window.open(event.toElement.href, '_blank');
        //            return true;
        //        },
        //        Cancel: function () {
        //            $(this).dialog("close");
        //            event.preventDefault();
        //        }
        //    }
        //});
        //return false;
        //});
        var url = document.URL;
        //alert($.url().param('title'));
        var param = 'title';
        var paramValue = GetParameterValues(param);
        $("#noclassMatching").hide();
        if (paramValue != '' && paramValue != undefined) {

            var param1 = 'pageid';
            var paramValue1 = GetParameterValues(param1);
            if (paramValue1 != '' && paramValue1 != undefined) {
                $("#noclassMatching").hide();
            }
            else {
                if ($("td:contains('" + paramValue.replace(/%20/g, ' ') + "')").length > 0) {
                    $("td:contains('" + paramValue.replace(/%20/g, ' ') + "')").css("background", "#FEB101");//"#25649F");
                    //$("html, body").scrollTop($("#" + paramValue).offset().top);
                    $("html, body").scrollTop($("td:contains('" + paramValue.replace(/%20/g, ' ') + "')").offset().top);
                }
                else {
                    $("#noclassMatching").show()
                }
            }
        }

    });
    function GetParameterValues(param) {
        var url = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
        for (var i = 0; i < url.length; i++) {
            var urlparam = url[i].split('=');
            if (urlparam[0] == param) {
                return urlparam[1];
            }
        }
    }
</script>
<style type="text/css">
    #btnAdd{ margin-left: 20px !important;
              margin-bottom: 6px!important;
    }
</style>
  
<asp:Panel ID="AddEditTemplate" runat="server" ClientIDMode="Static">
    
    <div class="settingrow">
        <mp:SiteLabel runat="server" ID="lblScheduleDate" ConfigKey="ScheduleDateLabel" ForControl="txtScheduleDate" CssClass="settinglabel" />
        <portal:mojoHiddenField runat="server" ID="hdScheduleId" Value="-1" />
        <portal:mojoHiddenField runat="server" ID="hdScheduleGuidId" Value="-1" />
        <asp:TextBox runat="server" ID="txtScheduleDate" ClientIDMode="Static" CssClass="forminput widetextbox"></asp:TextBox>
    </div>
    <div class="settingrow">
        <mp:SiteLabel runat="server" ID="lblTitle" ConfigKey="ScheduleTitleLabel" ForControl="txtTitle" CssClass="settinglabel" />
        <asp:TextBox runat="server" ID="txtTitle" ClientIDMode="Static" CssClass="forminput widetextbox"></asp:TextBox>
    </div>
    <div class="settingrow">
        <mp:SiteLabel runat="server" ID="lblTitleDescription" ConfigKey="ScheduleTitleDescriptionLabel" ForControl="txtTitle" CssClass="settinglabel" />
        <asp:TextBox runat="server" ID="txtTitleDescription" ClientIDMode="Static" TextMode="MultiLine" Rows="5" CssClass="forminput widetextbox"></asp:TextBox>
    </div>
    <div class="settingrow">
        <mp:SiteLabel runat="server" ID="lblInstructor" ConfigKey="ScheduleInstructorLabel" ForControl="ddlInstructor" CssClass="settinglabel" />
        <asp:TextBox runat="server" ID="txtInstructor" ClientIDMode="Static" CssClass="forminput widetextbox"></asp:TextBox>
        <%--<asp:UpdatePanel ID="updPanelInstructor" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <mp:SiteLabel runat="server" ID="lblInstructor" ConfigKey="ScheduleInstructorLabel" ForControl="ddlInstructor" CssClass="settinglabel" />
                <asp:TextBox runat="server" ID="TextBox1" ClientIDMode="Static" CssClass="forminput widetextbox"></asp:TextBox>
                <asp:HiddenField ID="hdnInstructorIds" runat="server" />
                <asp:PopupControlExtender
                    ID="txtInstructor_PopupControlExtender" runat="server"
                    Enabled="True" ExtenderControlID=""
                    TargetControlID="txtInstructor"
                    PopupControlID="PanelInstructor" OffsetY="22">
                </asp:PopupControlExtender>
                <asp:Panel ID="PanelInstructor" runat="server"
                    BorderStyle="Solid" BorderWidth="0.5px"
                    Direction="LeftToRight"
                    ScrollBars="Auto"
                    Style="display: none" CssClass="aspcheckboxlist">
                    <asp:CheckBoxList ID="cblInstructor" runat="server" RepeatDirection="Vertical"
                        AutoPostBack="True" DataTextField="LoginName" DataValueField="UserID"
                        OnSelectedIndexChanged="cblInstructor_SelectedIndexChanged">
                    </asp:CheckBoxList>
                </asp:Panel>
            </ContentTemplate>
        </asp:UpdatePanel>--%>
    </div>
    <div class="settingrow">
        <asp:UpdatePanel ID="updPanelAudience" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <mp:SiteLabel runat="server" ID="lblAudience" ConfigKey="ScheduleAudienceLabel" ForControl="ddlAudience" CssClass="settinglabel" />
                <%--<portal:mojoDropDownList runat="server" ID="ddlAudience" ClientIDMode="Static" DataTextField="RoleName" DataValueField="RoleId" />--%>
                <asp:TextBox runat="server" ID="txtAudience" ClientIDMode="Static" CssClass="forminput widetextbox"></asp:TextBox>
                <asp:HiddenField ID="hdnAudienceIds" runat="server" />
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
        <mp:SiteLabel runat="server" ID="lblLength" ConfigKey="ScheduleLengthLabel" ForControl="txtLength" CssClass="settinglabel" />
        <asp:TextBox runat="server" ID="txtLength" data-messageid="input-lengthError" data-allowed-chars="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/. " ClientIDMode="Static" CssClass="forminput widetextbox"></asp:TextBox>
        <span id="input-lengthError" style="color:red;visibility:hidden">Please enter course length</span>
    </div>
    <div class="settingrow">
        <mp:SiteLabel runat="server" ID="lblAccess" ConfigKey="ScheduleAccessLabel" ForControl="txtAccess" CssClass="settinglabel" />
        <asp:TextBox runat="server" ID="txtAccess" ClientIDMode="Static" data-messageid="input-accessError" data-allowed-chars="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 " CssClass="forminput widetextbox"></asp:TextBox>
        <span id="input-accessError" style="color:red;visibility:hidden">Please enter valid access string</span>
    </div>
    <div class="settingrow">
        <mp:SiteLabel runat="server" ID="SiteLabel1" ConfigKey="ScheduleUrlLabel" ForControl="txtUrl" CssClass="settinglabel" />
        <asp:TextBox runat="server" ID="txtUrl" ClientIDMode="Static" CssClass="forminput widetextbox"></asp:TextBox>
    </div>
    <div class="settingrow">
        <mp:SiteLabel runat="server" ID="lblTuition" ConfigKey="ScheduleTuitionLabel" ForControl="txtTuition" CssClass="settinglabel" />
        <asp:TextBox runat="server" ID="txtTuition" data-messageid="input-tutionError" data-allowed-chars="$.0123456789" ClientIDMode="Static" CssClass="forminput widetextbox" Text="$" ></asp:TextBox>
        <span id="input-tutionError" style="color:red;visibility:hidden">Please enter valid tuition fee</span>
    </div>
    <div class="settingrow">
        <mp:SiteLabel runat="server" ID="lblIsActive" ConfigKey="ScheduleIsActiveLabel" ForControl="chkIsActive" CssClass="settinglabel" />
        <asp:CheckBox runat="server" ID="chkIsActive" ClientIDMode="Static" Checked="True" />
    </div>
    <div class="settingrow">
        <portal:mojoButton runat="server" ID="btnSave" ClientIDMode="Static" Text="Save" OnClick="btnSave_Click" />
        <portal:mojoButton runat="server" ID="btnCancel" ClientIDMode="Static" Text="Cancel" OnClick="btnCancel_Click" />
    </div>
</asp:Panel>
<asp:Panel ID="ListTemplate" runat="server">
<%-- <div id="dialog-confirm" title="Confirmation?" style="display:none;">
  <p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>You are now leaving the C21U portal. Are you sure?</p>
</div>--%>
  
           <div id="noclassMatching" style="display:none; float: left; width:90%;padding:20px;">
         <%--<span style="font-size: 12px; border: 1px solid; background: #F5F5DC; font-weight: 700;"> There is no matching cousrse found in course scheduled.</span>--%>
             <div class="warning">There is no matching course found in course schedule.</div>
             </div>
    <% if (Request.IsAuthenticated)
           if (SiteUtils.GetCurrentSiteUser() != null && SiteUtils.GetCurrentSiteUser().IsInRoles("Admins"))
           {
               { %>
    <portal:mojoButton runat="server" ID="btnAdd" Text ="+ Add"  ClientIDMode="Static" OnClick="btnAdd_Click" CssClass="btnAdd" />
    <% }
           } %>


    <%-- <asp:UpdatePanel ID="updListTemplate" runat="server" UpdateMode="Conditional">
        <ContentTemplate>--%>
    <portal:mojoHiddenField runat="server" ID="hdSortColumn" ClientIDMode="Static" Value="ScheduleDate" />
    <portal:mojoHiddenField runat="server" ID="hdSortDirection" ClientIDMode="Static" Value="Down"/>
    
    
        <div class="settingrow">
        <portal:mojoButton runat="server" ID="btnPrint" ClientIDMode="Static" Text="Print Schedule" OnClick="btnPrint_Click" />
        
    </div>
     <%--OnClientClick="printGrid()"--%>
    <asp:Panel id="pnlGridView" runat="server" >
              
    <asp:Repeater ID="rptSchedule" runat="server" ClientIDMode="Static" OnItemCommand="rptShedule_ItemCommand"  >
        <HeaderTemplate>
            <div class="datagrid">
                <table>
                    <thead>
                        <tr>
                            <th style="width:10%">
                                <asp:LinkButton runat="server" ID="lnkScheduleDate" ClientIDMode="Static" CommandName="ScheduleDate" >Date /Time (EST)</asp:LinkButton>
                            </th>
                            <th style="width:30%">
                                <asp:LinkButton runat="server" ID="lnkTitle" ClientIDMode="Static" CommandName="Title">Title</asp:LinkButton>
                            </th>
                            <th style="width:10%">
                                <asp:LinkButton runat="server" ID="lnkInstructorNames" ClientIDMode="Static" CommandName="InstructorNames">Instructor</asp:LinkButton>
                            </th>
                            <th style="width:15%">
                                <asp:LinkButton runat="server" ID="lnkAudienceNames" ClientIDMode="Static" CommandName="AudienceNames">Audience</asp:LinkButton>
                            </th>
                            <th style="width:5%">
                                <asp:LinkButton runat="server" ID="lnkScheduleLength" ClientIDMode="Static" CommandName="ScheduleLength">Length</asp:LinkButton>
                            </th>
                            <th style="width:5%">
                                <asp:LinkButton runat="server" ID="lnkScheduleAccess" ClientIDMode="Static" CommandName="ScheduleAccess">Access</asp:LinkButton>
                            </th>
                            <th style="width:12%;">
                                <asp:LinkButton runat="server" ID="lnkTuitionFee" ClientIDMode="Static" CommandName="TuitionFee">Tuition</asp:LinkButton>
                            </th>

                            <% if (Request.IsAuthenticated)
                                   if (SiteUtils.GetCurrentSiteUser() != null && SiteUtils.GetCurrentSiteUser().IsInRoles("Admins"))
                                   {
                                       { %>
                            <th style="width:5%">Action</th>
                            <% }
                                           } %>
                        </tr>
                    </thead>
                    <tbody>
        </HeaderTemplate>
        <ItemTemplate>
            <tr>
                <td style="text-decoration: none"><%# string.Format("{0:ddd MM'/'dd'/'yyyy @hh:mmtt}", DataBinder.Eval(Container.DataItem, "ScheduleDate"))%></td>
                <td class="the-tooltip top right black" style="text-decoration: underline" id='<%# Eval("Title").ToString().Replace(" ","_") %>' ><%# Eval("Title").ToString() %> <%# (Eval("IsActive").ToString()=="False")?"<img src='Data\\Sites\\1\\skins\\Theme_C21\\images\\inactive.png' title='Inactive course' style='float:right;'/>":"" %> <span><%# Eval("Description") %></span>  
                    </td>
                <td><%# Eval("InstructorNames").ToString()%></td>
                <td><%# Eval("AudienceNames").ToString()%></td>
                <td><%# Eval("ScheduleLength").ToString()%></td>
                <td>
                   <%# (Eval("Url").ToString() == "" || Eval("Url").ToString() == "#")? Eval("ScheduleAccess").ToString() : "<a id='urlLink' href=" + Eval("Url").ToString() +" target='_blank'>"+ Eval("ScheduleAccess").ToString()+"</a>" %>
                </td>
                <td>$<%# string.Format("{0:f2}", DataBinder.Eval(Container.DataItem, "TuitionFee"))%></td>
                <% if (Request.IsAuthenticated)
                       if (SiteUtils.GetCurrentSiteUser() != null && SiteUtils.GetCurrentSiteUser().IsInRoles("Admins"))
                       {
                           { %>
                <td>
                    <asp:LinkButton runat="server" ID="btnEdit" Text="Edit" CommandName="EditSchedule" CommandArgument='<%# Eval("ScheduleId") %>' /> &#47;
                    <asp:LinkButton runat="server" ID="btnDelete" Text="Delete" CommandName="DeleteSchedule" CommandArgument='<%# Eval("ScheduleId") %>' OnClientClick="return confirm('Are you sure you want to delete?')" />
                </td>
                <% }
                               } %>
            </tr>
        </ItemTemplate>
        <FooterTemplate>
            </tbody>
                    </table>
                    </div>
        </FooterTemplate>
    </asp:Repeater>

        <asp:Repeater ID="rptScheduledownload" runat="server" ClientIDMode="Static" OnItemCommand="rptScheduledownload_ItemCommand" EnableViewState="false"  >
        <HeaderTemplate>
            <div style="display:none; " class="datagrid"> <%--class="datagrid" >--%>
                <div style="text-align:center;margin-bottom:20px;"><h2><u>C21 University Course Schedule</u></h2></div>
                <br />
                <table cellspacing="0" cellpadding="5" rules="all" border="1" id="gvDetails" style="border-collapse: collapse;font-size:10px;margin-top:20px;">
                    <thead>
                        <tr style="background-color: #DF5015;font-weight: bold;">
                            <th style="width:10%" scope="col">
                                Date /Time (EST)
                            </th>
                            <th style="width:25%">
                                Title
                            </th>
                            <%--<th style="width:30%">Description</th>--%>
                            <th style="width:10%">
                                Instructor
                            </th>
                            <th style="width:10%">
                                Audience
                            </th>
                            <th style="width:5%">
                                Length
                            </th>
                            <th style="width:5%">
                                Access
                            </th>
                            <th style="width:12%;">
                                Tuition
                            </th>

                        </tr>
                    </thead>
                    <tbody>
        </HeaderTemplate>
        <ItemTemplate>
            <tr>
                <td style="text-decoration: none;width:10% "><%# string.Format("{0:ddd MM'/'dd'/'yyyy @hh:mmtt}", DataBinder.Eval(Container.DataItem, "ScheduleDate"))%></td>
                <td style="text-decoration: underline; width:25%" id='<%# Eval("Title").ToString().Replace(" ","_") %>' ><%# Eval("Title").ToString() %> <%# (Eval("IsActive").ToString()=="False")?"<img src='Data\\Sites\\1\\skins\\Theme_C21\\images\\inactive.png' title='Inactive course' style='float:right;'/>":"" %>   
                    </td> 
                <%--<td><%# Eval("Description") %></td>--%>
                <td style="width:10%"><%# Eval("InstructorNames").ToString()%></td>
                <td style="width:10%"><%# Eval("AudienceNames").ToString()%></td>
                <td><%# Eval("ScheduleLength").ToString()%></td>
                <td>
                   <%# (Eval("Url").ToString() == "" || Eval("Url").ToString() == "#")? Eval("ScheduleAccess").ToString() : "<a id='urlLink' href=" + Eval("Url").ToString() +" target='_blank'>"+ Eval("ScheduleAccess").ToString()+"</a>" %>
                </td>
                <td>$<%# string.Format("{0:f2}", DataBinder.Eval(Container.DataItem, "TuitionFee"))%></td>
                <% if (Request.IsAuthenticated)
                       if (SiteUtils.GetCurrentSiteUser() != null && SiteUtils.GetCurrentSiteUser().IsInRoles("Admins"))
                       {
                           { %>
                <%--<td>--%>
                    <%--<asp:LinkButton runat="server" ID="btnEdit" Text="Edit" CommandName="EditSchedule" CommandArgument='<%# Eval("ScheduleId") %>' /> &#47;
                    <asp:LinkButton runat="server" ID="btnDelete" Text="Delete" CommandName="DeleteSchedule" CommandArgument='<%# Eval("ScheduleId") %>' OnClientClick="return confirm('Are you sure you want to delete?')" />--%>
               <%-- </td>--%>
                <% }
                               } %>
            </tr>
        </ItemTemplate>
        <FooterTemplate>
            </tbody>
                    </table>
                    </div>
        </FooterTemplate>
    </asp:Repeater>
<%--                <asp:GridView ID="grdCourseList" runat="server" CssClass="AspNet-GridView"
                                
                                AutoGenerateColumns="false"
                                EnableViewState="false" CellPadding="3"
                                DataKeyNames="ScheduleId" BorderWidth="0px"
                                 AllowPaging="true" PageSize="15"
                                UseAccessibleHeader="true" ShowHeader="false"  ShowFooter="true" >
                                <HeaderStyle BorderWidth="0" BorderStyle="None" CssClass="noDisplay" />
                                <Columns>
                                    <asp:BoundField DataField="ScheduleDate" HeaderText="Id" ItemStyle-Width="90" ItemStyle-CssClass="hideGridColumn" />
            <asp:BoundField DataField="Title" HeaderText="Title" ItemStyle-Width="120" />
                                    </Columns>
                     </asp:GridView>--%>
        </asp:Panel>
    <%--</ContentTemplate>
    </asp:UpdatePanel>--%>
</asp:Panel>

<script type="text/javascript">
    jQuery('#txtScheduleDate').datetimepicker({ mask: true });
    $(function () {
        //$('#datagriddownload').css('display', 'none');
        var sortValue = $("#hdSortColumn").val();
        var sortDirection = $("#hdSortDirection").val();
        var selector = $("#lnk" + sortValue);
        if (sortValue) {
            if(sortDirection == "Down") {
                selector.append("<img src='Data\\Sites\\1\\skins\\Theme_C21\\images\\downSort.png' style='float:right;'/>");
            }
        } else {
            if (sortDirection.length > 0) {
                selector = $("#lnk" + sortDirection.split("#")[1]);
                sortDirection = sortDirection.split('#')[0];
                if (sortDirection == "Up") {
                    selector.append("<img src='Data\\Sites\\1\\skins\\Theme_C21\\images\\upSort.png' style='float:right;'/>");
                }
            }
        }
    });
    function printGrid() {
        var printContent = '';//document.getElementById('<%= rptSchedule.ClientID %>');
               //var printWindow = window.open("All Records", "Print Panel", 'left=50000,top=50000,width=0,height=0');
               //printWindow.document.write(printContent.innerHTML);
               //printWindow.document.close();
               //printWindow.focus();
        //printWindow.print();
        var windowUrl = 'about:blank';
        //set print document name for gridview
        var uniqueName = new Date();
        var windowName = 'Print_' + uniqueName.getTime();

        var prtWindow = window.open(windowUrl, windowName,
        'left=100,top=100,right=100,bottom=100,width=700,height=500');
        prtWindow.document.write('<html><head></head>');
prtWindow.document.write('<body style="background:none !important">');
prtWindow.document.write(printContent.outerHTML);
prtWindow.document.write('</body></html>');
prtWindow.document.close();
prtWindow.focus();
prtWindow.print();
prtWindow.close();
    }
</script>

<div style="height: 1px;"></div>
