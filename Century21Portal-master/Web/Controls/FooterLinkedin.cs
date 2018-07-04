using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using mojoPortal.Business;
using mojoPortal.Business.WebHelpers;
using Resources;

namespace mojoPortal.Web.UI
{
    public class FooterLinkedin : WebControl
    {
        // these separator properties are deprecated
        // it is recommended not to use these properties
        // but instead to use mojoPortal.Web.Controls.SeparatorControl
        private bool useLeftSeparator = false;
        /// <summary>
        /// deprecated
        /// </summary>
        public bool UseLeftSeparator
        {
            get { return useLeftSeparator; }
            set { useLeftSeparator = value; }
        }

        private string imageUrl = SiteUtils.GetNavigationSiteRoot() + "/Data/Sites/1/skins/Theme_C21/images/footer_linkedin.png";
        public string ImageUrl
        {
            get { return imageUrl; }
            set { imageUrl = value; }
        }

        private bool renderAsListItem = false;
        public bool RenderAsListItem
        {
            get { return renderAsListItem; }
            set { renderAsListItem = value; }
        }

        private string listItemCSS = "topnavitem";
        public string ListItemCss
        {
            get { return listItemCSS; }
            set { listItemCSS = value; }
        }

        private string siteMapStartingUrl = string.Empty;
        public string SiteMapStartingUrl
        {
            get { return siteMapStartingUrl; }
            set { siteMapStartingUrl = value; }
        }

        protected override void Render(HtmlTextWriter writer)
        {
            if (HttpContext.Current == null)
            {
                writer.Write("[" + this.ID + "]");
                return;
            }

            DoRender(writer);


        }

        private void DoRender(HtmlTextWriter writer)
        {
            string urlToUse = SiteUtils.GetRelativeNavigationSiteRoot() + "/SiteMap.aspx";
            if (CssClass.Length == 0) CssClass = "sitelink imgLkdin";

            //if (SiteUtils.IsSecureRequest())
            //{
            //    SiteSettings siteSettings = CacheHelper.GetCurrentSiteSettings();
            //    if ((siteSettings != null) && (!siteSettings.UseSslOnAllPages))
            //    {
            //        urlToUse = urlToUse.Replace("https", "http");

            //    }
            //}

            if (siteMapStartingUrl.Length > 0)
            {
                urlToUse += "?startnode=" + Context.Server.UrlEncode(siteMapStartingUrl);
            }

            if (renderAsListItem)
            {
                writer.WriteBeginTag("li");
                writer.WriteAttribute("class", listItemCSS);
                writer.Write(HtmlTextWriter.TagRightChar);

            }

            if (UseLeftSeparator) writer.Write("<span class='accent'>|</span> ");

            if (imageUrl.Length > 0)
            { //style='float: right;  margin-right: -100px;  margin-top: -8px;'
                writer.Write(string.Format(
                                 " <a href='{0}' class='"
                                 + CssClass + "'  title='{1}' target='_blank'><img alt='{1}' src='{2}' /></a>",
                                 Page.ResolveUrl(System.Web.Configuration.WebConfigurationManager.AppSettings["Century21LinkedIn"]),
                                 Resource.FooterLinkedinHover,
                                 Page.ResolveUrl(imageUrl)));
            }
            else
            {

                writer.WriteBeginTag("a");
                writer.WriteAttribute("class", CssClass);
                //writer.WriteAttribute("title", Resource.SiteMapLink);
                writer.WriteAttribute("href", Page.ResolveUrl(System.Web.Configuration.WebConfigurationManager.AppSettings["Century21LinkedIn"]));
                writer.WriteAttribute("target", "_blank");
                writer.Write(HtmlTextWriter.TagRightChar);
                writer.WriteEncodedText(Resources.Resource.JoinC21Link);
                writer.WriteEndTag("a");

            }

            if (renderAsListItem) writer.WriteEndTag("li");
        }
    }
}