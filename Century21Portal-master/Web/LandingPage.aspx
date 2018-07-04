<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LandingPage.aspx.cs" Inherits="mojoPortal.Web.LandingPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Century21.com</title>
    <style>
        .errMsg {
            border: 2px solid red;
            color: red;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="errMsg">
            <asp:Label runat="server" ID="lblMsg">Here you can show the text if any error or validation message</asp:Label>
        </div>
    </form>
</body>
</html>
