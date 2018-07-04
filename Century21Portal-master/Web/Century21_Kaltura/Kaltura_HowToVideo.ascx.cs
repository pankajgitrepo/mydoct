using System;
using System.Web.UI;

namespace mojoPortal.Web.Century21_Kaltura
{
    public partial class Kaltura_HowToVideo : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Page.ClientScript.RegisterClientScriptBlock(typeof(Page), "Kaltura_1", "\n<script type=\"text/javascript\" src=\"" + Page.ResolveUrl("~/ClientScript/KalturaScripts/ox.ajast.js") + "\" ></script>");
            Page.ClientScript.RegisterClientScriptBlock(typeof(Page), "Kaltura_2", "\n<script type=\"text/javascript\" src=\"" + Page.ResolveUrl("~/ClientScript/KalturaScripts/webtoolkit.md5.js") + "\" ></script>");
            Page.ClientScript.RegisterClientScriptBlock(typeof(Page), "Kaltura_3", "\n<script type=\"text/javascript\" src=\"" + Page.ResolveUrl("~/ClientScript/KalturaScripts/KalturaClientBase.js") + "\" ></script>");
            Page.ClientScript.RegisterClientScriptBlock(typeof(Page), "Kaltura_4", "\n<script type=\"text/javascript\" src=\"" + Page.ResolveUrl("~/ClientScript/KalturaScripts/KalturaTypes.js") + "\" ></script>");
            Page.ClientScript.RegisterClientScriptBlock(typeof(Page), "Kaltura_5", "\n<script type=\"text/javascript\" src=\"" + Page.ResolveUrl("~/ClientScript/KalturaScripts/KalturaVO.js") + "\" ></script>");
            Page.ClientScript.RegisterClientScriptBlock(typeof(Page), "Kaltura_6", "\n<script type=\"text/javascript\" src=\"" + Page.ResolveUrl("~/ClientScript/KalturaScripts/KalturaServices.js") + "\" ></script>");
            Page.ClientScript.RegisterClientScriptBlock(typeof(Page), "Kaltura_7", "\n<script type=\"text/javascript\" src=\"" + Page.ResolveUrl("~/ClientScript/KalturaScripts/KalturaClient.js") + "\" ></script>");
        }
    }
}