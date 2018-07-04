using System.Collections.Specialized;
using System.Globalization;
using System.Security.Cryptography;
using System.Text;
using System.Web.Security;
using mojoPortal.Business;
using mojoPortal.Business.WebHelpers.UserSignInHandlers;
using mojoPortal.Web.Components;
using mojoPortal.Web.Framework;
using System;
using System.Configuration;
using log4net;
using mojoPortal.Web.UI;
using mojoPortal.Web.UI.Pages;

namespace mojoPortal.Web
{
    public partial class LandingPage : System.Web.UI.Page
    {
        public SiteUser SiteUser { get; set; }
        private static readonly ILog loginLog = LogManager.GetLogger(typeof(SiteLogin));
        private static readonly ILog regLog = LogManager.GetLogger(typeof(Register));
        public int SiteId { get; set; }
        public SiteSettings SiteSettings { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
               // if (Request.UrlReferrer != null)
               // {
                    if (Request.QueryString.HasKeys())
                    {
                        string baseUrl = SiteUtils.GetNavigationSiteRoot();
                        //Log all querystring parameters into one file.
                        if (WriteSsoQueryStringIntoFile())
                        {
                            string fileNameWithPath = Server.MapPath("QueryStringTextFile/QueryString.txt");
                            SiteHelper.LogQueryStringParameters(fileNameWithPath, Request.QueryString);
                        }
                        SsoQueryString qParameters = new SsoQueryString(Request.QueryString);
                        if (CheckMd5WithOurSite(qParameters.TimeStamp, qParameters.Md5Hash))
                        {
                            if (CheckUserInDatabase(qParameters.UserId))
                            {
                                //Insert last login into database 
                                SiteUser.UpdateLastLoginTime();
                                //Insert user location into database
                                UpdateUserLocation();
                                
                                UserSignInEventArgs u = new UserSignInEventArgs(SiteUser);
                                OnUserSignIn(u);
                                //Allow user if it is not soft deleted from your system and it should not be locked.
                                if (!SiteUser.IsDeleted && !SiteUser.IsLockedOut)
                                {
                                    FormsAuthentication.SetAuthCookie(qParameters.UserId, false);
                                    //Navigate to home
                                    //Response.Redirect(baseUrl+"/Default.aspx");
                                    WebUtils.SetupRedirect(null, baseUrl + "/Default.aspx");
                                }
                                else
                                {
                                    lblMsg.Text = "You are not autherized to visit this site.user error";
                                }

                            }
                            else
                            {
                                this.SiteUser = SiteUtils.CreateUserFromQueryString(this.SiteSettings, qParameters);
                                if (SiteUser.UserId > -1)
                                {
                                    //Insert last login into database 
                                    SiteUser.UpdateLastLoginTime();
                                    //Insert user location into database
                                    UpdateUserLocation();
                                    FormsAuthentication.SetAuthCookie(SiteUser.Email,false);
                                    //Response.Redirect(baseUrl+"/Secure/UserProfile.aspx");
                                    //WebUtils.SetupRedirect(null, baseUrl + "/Default.aspx");
                                    WebUtils.SetupRedirect(null, baseUrl + "/browse-courses");
                                }
                            }
                            
                        }
                        else
                        {
                            lblMsg.Text = "You are not autherized to visit this site. MD5 error";
                        }
                          
                    }
                //} //URL referer end
                else
                {
                    lblMsg.Text = "You are not autherized to visit this site. Null query string ";
                }
            }
            else
            {
                lblMsg.Text = "multiple login is not allowed. error";
            }
        }

        /// <summary>
        /// Check if user present into database
        /// </summary>
        /// <param name="userEmail"></param>
        /// <returns></returns>
        private bool CheckUserInDatabase(string userEmail)
        {
            if (userEmail.Contains("@"))
            {
                SiteId = SiteSettings.GetSiteIdByHostName(WebUtils.GetHostName());
                this.SiteSettings = new SiteSettings(SiteId);
                this.SiteUser = SiteUser.GetByEmail(this.SiteSettings, userEmail);
            }
            return this.SiteUser != null;
        }

        /// <summary>
        /// Generate MD5 according to TimeStamp and saltkey
        /// </summary>
        /// <param name="timeStampString"></param>
        /// <param name="md5String"></param>
        /// <returns></returns>
        private bool CheckMd5WithOurSite(string timeStampString, string md5String)
        {
            string saltKey = ConfigurationManager.AppSettings["LoginPageSALTKey"];
            string hashValue = SiteHelper.CalculateMd5Hash(timeStampString + "|" + saltKey);
            return string.Compare(md5String, hashValue, ignoreCase: true, culture: CultureInfo.InvariantCulture) == 0;
        }

        /// <summary>
        /// Update user location into database
        /// </summary>
        private void UpdateUserLocation()
        {
            try
            {
                //Update user location
                UserLocation userLocation = new UserLocation(SiteUser.UserGuid, SiteUtils.GetIP4Address());
                SiteSettings = new SiteSettings(SiteId);
                userLocation.SiteGuid = SiteSettings.SiteGuid;
                userLocation.Hostname = Page.Request.UserHostName;
                userLocation.Save();
            }
            catch (Exception ex)
            {
                loginLog.Error(SiteUtils.GetIP4Address(), ex);
            }
        }

        /// <summary>
        /// Execute delegate on sign in
        /// </summary>
        /// <param name="e"></param>
        protected void OnUserSignIn(UserSignInEventArgs e)
        {
            foreach (UserSignInHandlerProvider handler in UserSignInHandlerProviderManager.Providers)
            {
                handler.UserSignInEventHandler(null, e);
            }
        }

        private bool WriteSsoQueryStringIntoFile()
        {
            return ConfigurationManager.AppSettings["WriteSsoQueryStringIntoFile"] == "true";
        }
    }
}