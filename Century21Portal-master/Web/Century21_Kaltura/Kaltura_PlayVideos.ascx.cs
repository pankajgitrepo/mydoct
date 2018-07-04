using mojoPortal.Business;
using mojoPortal.Business.WebHelpers;
using System;
using System.Data;
using System.Web.UI;

namespace mojoPortal.Web.Century21_Kaltura
{
    public partial class Kaltura_PlayVideos1 : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Request.IsAuthenticated)
            {
                SiteUtils.RedirectToLoginPage(this);
                return;
            }

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
                GetLikesforVideo();
                GetFavouriteVideos();
            }
        }

        private void GetLikesforVideo()
        {

            if (Request.QueryString != null && Request.QueryString["mediaId"] != null)
            {
                string mediaId = (string)Request.QueryString["mediaId"];
                DataSet dsLikes = (new KalturaModule()).GetLikesforVideo(mediaId, SiteUtils.GetCurrentSiteUser().UserId);

                if (dsLikes != null && dsLikes.Tables.Count > 0 && dsLikes.Tables[0].Rows.Count > 0)
                {
                    lblLikesCount.Text = (dsLikes.Tables[0].Rows[0]["Likes"].ToString()) + " Likes";
                    if (dsLikes.Tables[0].Rows[0]["LikeByThisUser"] != null && dsLikes.Tables[0].Rows[0]["LikeByThisUser"].ToString() == "Y")
                    {
                        imgBtnLikes.Enabled = false;
                        imgBtnLikes.ImageUrl = WebConfigSettings.LikeGrayImageUrl;
                    }
                    else
                    {
                        imgBtnLikes.Enabled = true;
                        imgBtnLikes.ImageUrl = WebConfigSettings.LikeBlueImageUrl;
                    }

                }
            }
        }

        private void GetFavouriteVideos()
        {
            if (Request.QueryString != null && Request.QueryString["mediaId"] != null)
            {
                string value = string.Empty;
                string mediaId = (string)Request.QueryString["mediaId"];
                IDataReader dsFavourites = (new KalturaModule()).GetFavouritesVideo(mediaId, SiteUtils.GetCurrentSiteUser().UserId);
                while (dsFavourites.Read())
                {
                    value = dsFavourites.IsDBNull(0) ? string.Empty : dsFavourites.GetString(0).ToString();
                }
                if (value == "Y" && value != string.Empty)
                {
                    imgBtnFavourites.Enabled = false;
                    imgBtnFavourites.ImageUrl = WebConfigSettings.FavouriteGreyImageUrl;
                    imgBtnFavourites.ToolTip = Resources.Resource.KalturaAddedToFavouritesTooltip;
                }
                else if (value == "N" && value != string.Empty)
                {
                    imgBtnFavourites.Enabled = true;
                    imgBtnFavourites.ImageUrl = WebConfigSettings.FavouriteImageUrl;
                    imgBtnFavourites.ToolTip = Resources.Resource.KalturaAddToFavouritesTooltip;
                }
            }
        }

        protected void imgBtnLikes_Click(object sender, ImageClickEventArgs e)
        {
            if (Request.QueryString != null && Request.QueryString["mediaId"] != null)
            {
                string mediaId = (string)Request.QueryString["mediaId"];
                (new KalturaModule()).SetLikeforKalturaMedia(mediaId, SiteUtils.GetCurrentSiteUser().UserId);
            }
            GetLikesforVideo();
        }

        protected void imgBtnFavourites_Click(object sender, ImageClickEventArgs e)
        {
            if (Request.QueryString != null && Request.QueryString["mediaId"] != null)
            {
                string mediaId = (string)Request.QueryString["mediaId"];
                (new KalturaModule()).SetFavouritesforKalturaMedia(mediaId, SiteUtils.GetCurrentSiteUser().UserId);
            }
            GetFavouriteVideos();
        }
    }
}