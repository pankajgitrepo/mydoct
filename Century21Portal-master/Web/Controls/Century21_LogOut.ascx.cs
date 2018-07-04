using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using mojoPortal.Business;
using Resources;

namespace mojoPortal.Web.UI
{
    public partial class Century21_LogOut : WebControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
           
        }
        private bool useRightSeparator = false;
        /// <summary>
        /// This property is deprecated. Instead to use mojoPortal.Web.Controls.SeparatorControl
        /// </summary>
        public bool UseRightSeparator
        {
            get { return useRightSeparator; }
            set { useRightSeparator = value; }
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

        private bool useFirstLast = false;
        public bool UseFirstLast
        {
            get { return useFirstLast; }
            set { useFirstLast = value; }
        }

        private string firstLastFormat = string.Empty;
        /// <summary>
        /// allows using first and last name in the welcome message, the default value is "Signed in as: {0} {1}"
        /// the {0} is required and will be replaced by the first name and {1} will be replaced by the last name
        /// However this is only useful if first and last name are actually populated
        /// which it may not be if you have not required it on registration and there are existing users
        /// also requires setting UseFirstLast to true
        /// </summary>
        public string FirstLastFormat
        {
            get { return firstLastFormat; }
            set { firstLastFormat = value; }
        }



        private string overrideFormat = string.Empty;
        /// <summary>
        /// allows overriding the welcome message, the default value is "Signed in as: {0}"
        /// the {0} is required and will be replaced by the user name
        /// </summary>
        public string OverrideFormat
        {
            get { return overrideFormat; }
            set { overrideFormat = value; }
        }

        private bool wrapInAnchor = false;
        public bool WrapInAnchor
        {
            get { return wrapInAnchor; }
            set { wrapInAnchor = value; }
        }

        private bool wrapInProfileLink = false;
        public bool WrapInProfileLink
        {
            get { return wrapInProfileLink; }
            set { wrapInProfileLink = value; }
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
            //Page.ClientScript.RegisterClientScriptBlock(typeof(Page), "Bootstrap_1", "\n<script type=\"text/javascript\" src=\"" + Page.ResolveUrl("~/ClientScript/bootstrap.min.js") + "\" ></script>");
            if (!HttpContext.Current.Request.IsAuthenticated) { return; }

            SiteUser siteUser = SiteUtils.GetCurrentSiteUser();
            if ((siteUser == null) || (siteUser.UserId <= -1)) { return; }

            if (CssClass.Length == 0) CssClass = "sitelink";

            if (renderAsListItem) writer.Write("<li class='" + listItemCSS + "'>");

            if ((useFirstLast) && (siteUser.FirstName.Length > 0) && (siteUser.LastName.Length > 0))
            {
                if (firstLastFormat.Length == 0) { firstLastFormat = Resource.FirstLastFormat; }

                if (wrapInProfileLink)
                {
                    writer.Write("<a class='" + CssClass + "' href='" + SiteUtils.GetNavigationSiteRoot() + "/Secure/UserProfile.aspx" + "'>" + string.Format(firstLastFormat,
                        HttpUtility.HtmlEncode(siteUser.FirstName), HttpUtility.HtmlEncode(siteUser.LastName)) + "</a>");
                }
                else if (wrapInAnchor)
                {
                    writer.Write("<a class='" + CssClass + "' name='welcome'>" + string.Format(firstLastFormat,
                        HttpUtility.HtmlEncode(siteUser.FirstName), HttpUtility.HtmlEncode(siteUser.LastName)) + "</a>");
                }
                else
                {

                    writer.Write("<span class='" + CssClass + "'>" + string.Format(firstLastFormat,
                        HttpUtility.HtmlEncode(siteUser.FirstName), HttpUtility.HtmlEncode(siteUser.LastName)) + "</span>");
                }

            }
            else
            {
                string format = Resource.WelcomeMessageFormat;

                if (overrideFormat.Length > 0) { format = overrideFormat; }

                if (wrapInProfileLink)
                {
                    writer.Write("<a class='" + CssClass + "' href='" + SiteUtils.GetNavigationSiteRoot() + "/Secure/UserProfile.aspx" + "'>" + string.Format(format, HttpUtility.HtmlEncode(siteUser.Name)) + "</a>");
                }
                else if (wrapInAnchor)
                {
                    writer.Write("<a class='" + CssClass + "' name='welcome'>" + string.Format(format, HttpUtility.HtmlEncode(siteUser.Name)) + "</a>");
                }
                else
                {
                    string fName = string.Format(format, HttpUtility.HtmlEncode(siteUser.FirstName));
                    string avtarUrl = string.IsNullOrEmpty(siteUser.AvatarUrl) ? SiteUtils.GetNavigationSiteRoot() + "/Data/SiteImages/anonymous.png" : SiteUtils.GetNavigationSiteRoot() + "/Data/Sites/1/useravatars/" + siteUser.AvatarUrl;
                    if (fName != "Hi !")
                    {
                        writer.Write("<div id='top-stuff'><div id='top-bar-out'><div id='container'><div id='pnav'><div class='active-links'><div id='session'><a id='signin-link' href='#'><ul><li><img class='user-profile' src='" + avtarUrl + "' alt=''><span class='divDownArrowUserProfile'><img src='" + SiteUtils.GetNavigationSiteRoot() + "/Data/Sites/1/skins/Theme_C21/images/login_dropdown.png' /></span></li> </ul></a></div><div id='signin-dropdown'><a class='anchorStyle' href='" + SiteUtils.GetNavigationSiteRoot() + "/Secure/UserProfile.aspx'><span>" + Resources.Resource.UserProfileMyProfileLabel + "</span></a><br /><a class='anchorStyle' href='" + SiteUtils.GetNavigationSiteRoot() + "/logoff.aspx'><span>" + Resources.Resource.SiteLogOutText + "</span></a></div></div></div></div></div><div class='divUserName'>" + fName + "</div></div>");
                    }
                    else {
                        writer.Write("<div id='top-stuff'><div id='top-bar-out'><div id='container'><div id='pnav'><div class='active-links'><div id='session'><a id='signin-link' href='#'><ul><li><img class='user-profile' src='" + avtarUrl + "' alt=''><span class='divDownArrowUserProfile'><img src='" + SiteUtils.GetNavigationSiteRoot() + "/Data/Sites/1/skins/Theme_C21/images/login_dropdown.png' /></span></li> </ul></a></div><div id='signin-dropdown'><a class='anchorStyle' href='" + SiteUtils.GetNavigationSiteRoot() + "/Secure/UserProfile.aspx'><span>" + Resources.Resource.UserProfileMyProfileLabel + "</span></a><br /><a class='anchorStyle' href='" + SiteUtils.GetNavigationSiteRoot() + "/logoff.aspx'><span>" + Resources.Resource.SiteLogOutText + "</span></a></div></div></div></div></div><div class='divUserName'>" + string.Format(format, HttpUtility.HtmlEncode(siteUser.Name)) + "</div></div>");
                    }
                }
            }

            if (UseRightSeparator) writer.Write(" <span class='Accent'>|</span>");

            if (renderAsListItem) writer.Write("</li>");
        }

    }
}
