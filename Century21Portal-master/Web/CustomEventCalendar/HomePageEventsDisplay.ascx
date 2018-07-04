<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="HomePageEventsDisplay.ascx.cs" Inherits="mojoPortal.Web.CustomEventCalendar.HomePageEventsDisplay" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<script>
    function pageLoad(sender, args) {
        if (!args.get_isPartialLoad()) {
            //  add our handler to the document's
            //  keydown event
            $addHandler(document, "keydown", onKeyDown);
        }
    }

    function onKeyDown(e) {
        if (e && e.keyCode == Sys.UI.Key.esc) {
            // if the key pressed is the escape key, dismiss the dialog
            //$find('EventDetailspopup').hide();
            //document.getElementById('irm1').src = "";
            $(".Popup").css("display", "none");
            $(".Background").css("display", "none");
        }
    }
    function titleclick() {
        $('body').css('overflow', 'hidden');
    }
    function popupclose() {
        $('body').css('overflow', 'auto');
    }
</script>

<style>
    /*.eventAddNew a:hover {
        font-size: 110%;
    }*/
</style>

<div style="width: 100%;">
    <%if (flagCheckIsUserAdmin)
      { %>
    <div class="eventAddNew">
        <%--  <a class="evedit" href='<%# Siteroot +  System.Web.Configuration.WebConfigurationManager.AppSettings["EventEditURL"] + EventCalenderPageID + System.Web.Configuration.WebConfigurationManager.AppSettings["ModuleIDPageURL"]  + EventCalenderModuleID %>'>
       Add Events
    </a>--%>
        <a class="evEdit addNewEventsBtn" href='<%= SiteRoot + System.Web.Configuration.WebConfigurationManager.AppSettings["EventEditURL"]  + EventCalenderPageID  + System.Web.Configuration.WebConfigurationManager.AppSettings["ModuleIDPageURL"]   + EventCalenderModuleID %>'>
            <%= Resources.Resource.AnchorAddEvents %>
        </a>
    </div>
    <% } %>

    <%--<asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>--%>

    <div class="eventscrollable" id="scroll">
        <table class="eventTable">
            <asp:Repeater ID="rptEvents" runat="server" EnableViewState="false">
                <ItemTemplate>

                    <tr class="eventdtTableTr">
                        <td class="eventdtTableTd" style="border-bottom: 1px solid #d0d0d0;text-align:left;">

                            <style>
                                .wrapEvent {
                                    margin: 0;
                                }

                                .left {
                                    float: left;
                                    width: 75%;
                                    overflow: hidden;
                                }

                                .right {
                                    float: left;
                                    width: 25%;
                                    overflow: hidden;
                                }

                               
                            </style>

                            <div class="wrapEvent" style="width: 300px;">
                                <div class="left" style="width: 250px;">
                                    <h3 style="color: darkgrey; font-size: 14px;"><%# Convert.ToDateTime(DataBinder.Eval(Container, "DataItem.EventDate")).ToString("MM/dd/yyyy") %></h3>
                                    <h3 style="color: #474747; font-size: 14px;">
                                        <asp:LinkButton ID="lnkEventTitle" runat="server" Text='<%#DataBinder.Eval(Container, "DataItem.Title").ToString() %>' OnClientClick ="titleclick()"></asp:LinkButton>
                                        <%--<%# Server.HtmlEncode(DataBinder.Eval(Container, "DataItem.Title").ToString())%>--%></h3>
                                    <h3 style="font-size: 11px; color: goldenrod;"><%# Server.HtmlEncode(DataBinder.Eval(Container, "DataItem.Location").ToString())%></h3>
                                </div>
                                <div class="right" style="width: 50px;">
                                    <%--<asp:ImageButton ToolTip="Details" runat="server" Width="30px" Height="30px" src="Data/Sites/1/skins/Theme_C21/images/detials.png" ID="detailsEvents" />--%>
                                    <cc1:ModalPopupExtender BehaviorID="EventDetailspopup" ID="mp1" runat="server" PopupControlID="popupPanel" TargetControlID="lnkEventTitle"
                                        CancelControlID="btnClose" BackgroundCssClass="Background">
                                    </cc1:ModalPopupExtender>

                                    <asp:Panel ID="popupPanel" runat="server" CssClass="PopupCustBx" align="center" Style="display: none">


                                        <div class="row">
                                            <table class="eventPopupTable">
                                                <tr>
                                                    <td class="eventPopupTitle">
                                                        <%= Resources.Resource.HoemPageEventsDisplayEventDetais %>
                                                    </td>
                                                    <td class="eventPopupbtnClose">
                                                        <asp:ImageButton ID="btnClose" ToolTip="Close" OnClientClick="popupclose()" runat="server" src="Data/Sites/1/skins/Theme_C21/images/dialog_close2.ico" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                        <div id="popupWindowIframe">
                                            <iframe style="" class="eventPopupIframe" id="irm1" src='<%# SiteRoot + System.Web.Configuration.WebConfigurationManager.AppSettings["EventDetailsURL"] + Server.HtmlEncode(DataBinder.Eval(Container, "DataItem.ItemID").ToString()) + System.Web.Configuration.WebConfigurationManager.AppSettings["ModuleIDPageURL"] + Server.HtmlEncode(DataBinder.Eval(Container, "DataItem.ModuleID").ToString()) + System.Web.Configuration.WebConfigurationManager.AppSettings["PageIDPageURL"] + EventCalenderPageID %>' runat="server"></iframe>
                                        </div>
                                        <br />
                                    </asp:Panel>

                                    <div>
                                        <% if (flagCheckIsUserAdmin)
                                           {  %>
                                        <div>
                                            <a class="evEdit" href='<%# SiteRoot +  System.Web.Configuration.WebConfigurationManager.AppSettings["EventEditURL"]  + EventCalenderPageID + System.Web.Configuration.WebConfigurationManager.AppSettings["ItemIDPageURL"] + Server.HtmlEncode(DataBinder.Eval(Container, "DataItem.ItemID").ToString()) +  System.Web.Configuration.WebConfigurationManager.AppSettings["ModuleIDPageURL"]  + Server.HtmlEncode(DataBinder.Eval(Container, "DataItem.ModuleID").ToString())%>' title="Edit">
                                                <img height="30px" width="30px" src="Data/Sites/1/skins/Theme_C21/images/edit.png" alt="" />
                                            </a>
                                        </div>

                                        <% } %>
                                    </div>
                                </div>
                            </div>

                            <%-- <div class="wrapEvent" style="width: 300px;">
                                <div class="left" style="width: 150px;">
                                    <h3 style="word-break: break-all;"><%# Server.HtmlEncode(DataBinder.Eval(Container, "DataItem.Title").ToString())%></h3>
                                </div>

                                <div class="right" style="width: 150px;">
                                    <h3 style="word-break: break-all;"><%# Server.HtmlEncode(DataBinder.Eval(Container, "DataItem.Location").ToString())%></h3>
                                </div>
                            </div>--%>
                        </td>
                    </tr>
                </ItemTemplate>

                <AlternatingItemTemplate>
                    <tr class="eventaltdtTableTr">
                        <td class="eventdtTableTd" style="border-bottom: 1px solid #d0d0d0;text-align:left;">
                            <div class="wrapEvent" style="width: 300px;">
                                <div class="left" style="width: 250px;">
                                    <h3 style="color: darkgrey; font-size: 14px;"><%# Convert.ToDateTime(DataBinder.Eval(Container, "DataItem.EventDate")).ToShortDateString() %></h3>
                                    <h3 style="color: #474747; font-size: 14px;">
                                        <asp:LinkButton ID="lnkEventTitle" runat="server" Text='<%#DataBinder.Eval(Container, "DataItem.Title").ToString() %>' OnClientClick ="titleclick()"></asp:LinkButton>
                                        <%-- <%# Server.HtmlEncode(DataBinder.Eval(Container, "DataItem.Title").ToString())%>--%>
                                    </h3>
                                    <h3 style="font-size: 11px; color: goldenrod;"><%# Server.HtmlEncode(DataBinder.Eval(Container, "DataItem.Location").ToString())%></h3>
                                </div>
                                <div class="right" style="width: 50px;">


                                    <%--<asp:ImageButton ToolTip="Details" runat="server" Width="30px" Height="30px" src="Data/Sites/1/skins/Theme_C21/images/detials.png" ID="detailsEvents" />--%>

                                    <cc1:ModalPopupExtender BehaviorID="EventDetailspopup" ID="mp1" runat="server" PopupControlID="popupPanel" TargetControlID="lnkEventTitle"
                                        CancelControlID="btnClose" BackgroundCssClass="Background">
                                    </cc1:ModalPopupExtender>

                                    <asp:Panel ID="popupPanel" runat="server" CssClass="PopupCustBx" align="center" Style="display: none">


                                        <div class="row">
                                            <table class="eventPopupTable">
                                                <tr>
                                                    <td class="eventPopupTitle">
                                                        <%= Resources.Resource.HoemPageEventsDisplayEventDetais %>
                                                    </td>
                                                    <td class="eventPopupbtnClose">
                                                        <asp:ImageButton ID="btnClose" ToolTip="Close" OnClientClick="popupclose()" runat="server" src="Data/Sites/1/skins/Theme_C21/images/dialog_close2.ico" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                        <div id="popupWindowIframe">
                                            <iframe style="" class="eventPopupIframe" id="irm1" src='<%# SiteRoot + System.Web.Configuration.WebConfigurationManager.AppSettings["EventDetailsURL"] + Server.HtmlEncode(DataBinder.Eval(Container, "DataItem.ItemID").ToString()) + System.Web.Configuration.WebConfigurationManager.AppSettings["ModuleIDPageURL"] + Server.HtmlEncode(DataBinder.Eval(Container, "DataItem.ModuleID").ToString()) + System.Web.Configuration.WebConfigurationManager.AppSettings["PageIDPageURL"] + EventCalenderPageID %>' runat="server"></iframe>
                                        </div>
                                        <br />
                                    </asp:Panel>

                                    <div>
                                        <% if (flagCheckIsUserAdmin)
                                           {  %>
                                        <div>
                                            <a class="evEdit" href='<%# SiteRoot +  System.Web.Configuration.WebConfigurationManager.AppSettings["EventEditURL"]  + EventCalenderPageID + System.Web.Configuration.WebConfigurationManager.AppSettings["ItemIDPageURL"] + Server.HtmlEncode(DataBinder.Eval(Container, "DataItem.ItemID").ToString()) +  System.Web.Configuration.WebConfigurationManager.AppSettings["ModuleIDPageURL"]  + Server.HtmlEncode(DataBinder.Eval(Container, "DataItem.ModuleID").ToString())%>' title="Edit">
                                                <img height="30px" width="30px" src="Data/Sites/1/skins/Theme_C21/images/edit.png" alt="" />
                                            </a>
                                        </div>

                                        <% } %>
                                    </div>
                                </div>
                            </div>

                            <%-- <div class="wrapEvent" style="width: 300px;">
                                <div class="left" style="width: 150px;">
                                    <h3 style="word-break: break-all;"><%# Server.HtmlEncode(DataBinder.Eval(Container, "DataItem.Title").ToString())%></h3>
                                </div>

                                <div class="right" style="width: 150px;">
                                    <h3 style="word-break: break-all;"><%# Server.HtmlEncode(DataBinder.Eval(Container, "DataItem.Location").ToString())%></h3>
                                </div>
                            </div>--%>
                        </td>
                    </tr>
                </AlternatingItemTemplate>
            </asp:Repeater>
        </table>
    </div>
</div>

<script>
    //$('#pOPUP').hover(function (e) {
    //    debugger;
    //    //alert("asdsad");  
    //    $(".eventscrollable").removeClass("eventscrollable")
    //    //css("pointer-events", "none");
    //}, function () {
    //    $(".eventscrollable").addClass("eventscrollable")
    //    //css("pointer-events", "all");
    //});
</script>
