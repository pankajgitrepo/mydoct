using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using mojoPortal.Business;
using mojoPortal.Business.WebHelpers;
using System.Data;

namespace mojoPortal.Web.Century21_Kaltura
{
    public partial class Kaltura_TopTenViewed : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            SiteSettings siteSettings = new SiteSettings();
            if (siteSettings == null)
            {
                siteSettings = CacheHelper.GetCurrentSiteSettings();
            }

            Page.ClientScript.RegisterClientScriptBlock(typeof(Page), "Kaltura_1", "\n<script type=\"text/javascript\" src=\"" + Page.ResolveUrl("~/ClientScript/KalturaScripts/ox.ajast.js") + "\" ></script>");
            Page.ClientScript.RegisterClientScriptBlock(typeof(Page), "Kaltura_2", "\n<script type=\"text/javascript\" src=\"" + Page.ResolveUrl("~/ClientScript/KalturaScripts/webtoolkit.md5.js") + "\" ></script>");
            Page.ClientScript.RegisterClientScriptBlock(typeof(Page), "Kaltura_3", "\n<script type=\"text/javascript\" src=\"" + Page.ResolveUrl("~/ClientScript/KalturaScripts/KalturaClientBase.js") + "\" ></script>");
            Page.ClientScript.RegisterClientScriptBlock(typeof(Page), "Kaltura_4", "\n<script type=\"text/javascript\" src=\"" + Page.ResolveUrl("~/ClientScript/KalturaScripts/KalturaTypes.js") + "\" ></script>");
            Page.ClientScript.RegisterClientScriptBlock(typeof(Page), "Kaltura_5", "\n<script type=\"text/javascript\" src=\"" + Page.ResolveUrl("~/ClientScript/KalturaScripts/KalturaVO.js") + "\" ></script>");
            Page.ClientScript.RegisterClientScriptBlock(typeof(Page), "Kaltura_6", "\n<script type=\"text/javascript\" src=\"" + Page.ResolveUrl("~/ClientScript/KalturaScripts/KalturaServices.js") + "\" ></script>");
            Page.ClientScript.RegisterClientScriptBlock(typeof(Page), "Kaltura_7", "\n<script type=\"text/javascript\" src=\"" + Page.ResolveUrl("~/ClientScript/KalturaScripts/KalturaClient.js") + "\" ></script>");

            if (!IsPostBack)
            {
                GetFavouriteVideosList();
            }
        }

        private void GetFavouriteVideosList()
        {
            if (Request.QueryString != null && Request.QueryString["id"] != null)
            {
                string value = string.Empty;
                string categoryId = (string)Request.QueryString["id"];
                if (categoryId == "1")
                {
                    IDataReader dsFavouritesList = (new KalturaModule()).GetFavouritesVideoList(SiteUtils.GetCurrentSiteUser().UserId);
                    while (dsFavouritesList.Read())
                    {
                        value = dsFavouritesList.IsDBNull(0) ? string.Empty : dsFavouritesList.GetString(0).ToString();
                    }
                }
                if (value != string.Empty)
                {
                    mediaIdList.Value = value;
                }
                else if (categoryId == "1")
                {
                    lblNoFavourites.Visible = true;
                    lblNoFavourites.Text = Resources.Resource.KalturaFavouriteVideoDefaultText;
                }
            }
        }
    }
}