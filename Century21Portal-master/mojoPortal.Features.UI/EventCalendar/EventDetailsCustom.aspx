<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EventDetailsCustom.aspx.cs" Inherits="mojoPortal.Features.UI.EventCalendar.EventDetailsCustom" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <style type="text/css">
        .eventDescription {
            margin-top: 20px;
            font-family: 'Segoe UI', Frutiger, 'Frutiger Linotype', 'Dejavu Sans', 'Helvetica Neue', Arial, sans-serif;
        }
        /*.custpopupdiv {
            height: 384px;
            overflow-y: auto;
            overflow-X: hidden;
        }*/
    </style>
    <title></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="Content-Security-Policy" content="default-src *; style-src 'self' 'unsafe-inline'; script-src 'self' 'unsafe-inline' 'unsafe-eval'">
        <portal:IEStyleIncludes ID="IEStyleIncludes1" runat="server" IncludeHtml5Script="true"
        IncludeIETransitionMeta="true" IE6CssFile="style.ie6.css" IE7CssFile="style.ie7.css" />
        <portal:SkinFolderScript ID="sfsc1" runat="server" ScriptFileName="script.js" AddToCombinedScript="false" />
    <portal:SkinFolderScript ID="sfsc2" runat="server" ScriptFileName="script.responsive.js"
        AddToCombinedScript="false" />
</head>
<body>
    <form id="form1" runat="server">

        <div class="custpopupdiv" style=" ">
            <div style="font-size: 16px;font-family: 'Segoe UI', Frutiger, 'Frutiger Linotype', 'Dejavu Sans', 'Helvetica Neue', Arial, sans-serif;">
                <b>
                    <asp:Label ID="heading" runat="server" /></b>
                <br />
                <br />
            </div>

            <div runat="server" id="divOfDescription" class="eventDescription" style="font-size: 14px;">
                <label runat="server" id="lblDescr"><b>Description: </b></label>
                <br />
                <div id="litDescription" runat="server" style="text-align: justify;font-family: 'Segoe UI', Frutiger, 'Frutiger Linotype', 'Dejavu Sans', 'Helvetica Neue', Arial, sans-serif;"></div>
            </div>

            <div  style="font-size: 14px;font-family: 'Segoe UI', Frutiger, 'Frutiger Linotype', 'Dejavu Sans', 'Helvetica Neue', Arial, sans-serif;">
                <label><b>Event Date: </b></label>
                <asp:Label ID="lblDate" runat="server"></asp:Label>
                <br />
                <br />
            </div>


            <div style="display:none; font-size: 14px;font-family: 'Segoe UI', Frutiger, 'Frutiger Linotype', 'Dejavu Sans', 'Helvetica Neue', Arial, sans-serif;">
                <label><b>Start Time: </b></label>
                <asp:Label ID="lblStartTime" runat="server"></asp:Label>
                <br />
                <br />
            </div>

            <div style="display:none; font-size: 14px;font-family: 'Segoe UI', Frutiger, 'Frutiger Linotype', 'Dejavu Sans', 'Helvetica Neue', Arial, sans-serif;">
                <label><b>End Time: </b></label>
                <asp:Label ID="lblEndTime" runat="server"></asp:Label>
                <br />
                <br />
            </div>

            <div runat="server" style="font-family: 'Segoe UI', Frutiger, 'Frutiger Linotype', 'Dejavu Sans', 'Helvetica Neue', Arial, sans-serif; font-size:14px;" id="contentOfEvntDetailsPage">
            </div>
        </div>

    </form>
</body>
</html>
