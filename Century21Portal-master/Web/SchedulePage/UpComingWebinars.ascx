<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UpComingWebinars.ascx.cs" Inherits="mojoPortal.Web.SchedulePage.UpComingWebinars" %>
<%@ Import Namespace="System.ComponentModel" %>

<asp:Panel ID="ListTemplate" runat="server">
    <asp:Panel ID="pnlGridView" runat="server">
        <asp:Repeater ID="rptSchedule" runat="server" ClientIDMode="Static" OnItemCommand="rptShedule_ItemCommand">
            <HeaderTemplate>
                <div class="datagrid">
                    <table>
                        <thead>
                            <tr>
                                <th style="width: 30%">
                                    <asp:LinkButton runat="server" ID="lnkTitle" ClientIDMode="Static" CommandName="Title">Title</asp:LinkButton>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td class="the-tooltip top right black" style="text-decoration: underline" id='<%# Eval("Title").ToString().Replace(" ","_") %>'><%# Eval("Title").ToString() %> <%# (Eval("IsActive").ToString()=="False")?"<img src='Data\\Sites\\1\\skins\\Theme_C21\\images\\inactive.png' title='Inactive course' style='float:right;'/>":"" %> <span><%# Eval("Description") %></span> </td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                </tbody>
                    </table>
                    </div>
            </FooterTemplate>
        </asp:Repeater>
    </asp:Panel>
</asp:Panel>




