using System;
using System.Configuration;
using System.Globalization;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using log4net;
using mojoPortal.Business;
using mojoPortal.Business.WebHelpers;
using mojoPortal.Web.Framework;
using Resources;

namespace mojoPortal.Web.Century21_Kaltura
{
    public partial class Kaltura_DisplayVideosByCategory : NonCmsBasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (siteSettings == null)
            {
                siteSettings = CacheHelper.GetCurrentSiteSettings();
            }
            
        }
    }
}