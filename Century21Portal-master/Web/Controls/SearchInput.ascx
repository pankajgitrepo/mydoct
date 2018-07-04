<%@ Control Language="c#" AutoEventWireup="True" CodeBehind="SearchInput.ascx.cs" Inherits="mojoPortal.Web.UI.SearchInput" %>
<portal:SearchPanel id="pnlS" runat="server">
    <asp:Panel id="pnlSearch" runat="server" CssClass="searchpanel ">
        <h2 id="heading" runat="server" style="position: absolute; left: -2000px; text-indent: -999em;" enableviewstate="false">
            <asp:Label ID="lblSearchHeading" runat="server" AssociatedControlID="txtSearch" EnableViewState="false" /></h2>
        <mp:WatermarkTextBox ID="txtSearch" runat="server" Height="19px" Style="padding: 5px 0 4px; box-shadow: none !important; border: none;" CssClass="watermarktextbox" />
        <portal:mojoButton ID="btnSearch" runat="server" OnClick="btnSearch_Click" CausesValidation="false" SkinID="searchbutton" />
        <asp:ImageButton ID="btnSearch2" runat="server" OnClick="btnSearch2_Click" CausesValidation="false" Visible="false" />
    </asp:Panel>
</portal:SearchPanel>
