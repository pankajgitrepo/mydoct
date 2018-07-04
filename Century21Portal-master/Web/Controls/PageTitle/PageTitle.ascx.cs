using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using mojoPortal.Web;
using mojoPortal.Web.UI;
using mojoPortal.Web.Framework;
using mojoPortal.Business;
using mojoPortal.Business.WebHelpers;

namespace mojoPortal.Web.Controls.PageTitle
{
    public partial class PageTitle : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            PopulateControls();

        }
        private void PopulateControls()
        {
            PageSettings currentPage = CacheHelper.GetCurrentPage();
            if (currentPage == null) { return; }
            if (currentPage.PageTitle == "")
                litPageTitle.Text = currentPage.PageName;
            else
                litPageTitle.Text = currentPage.PageTitle;
        }
    }
}