using mojoPortal.Business;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace mojoPortal.Web.SchedulePage
{
    public partial class UpComingWebinars : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                BindRepeater("ScheduleDate", "asc");
            }
        }
        private void BindRepeater(string sortBy = null, string sortDirection = null)
        {
            rptSchedule.DataSource = Schedule.GetAllSchedule(sortBy, sortDirection).Where(a => a.ScheduleDate.Date > DateTime.Now.Date && a.ScheduleDate.Date <= DateTime.Now.AddDays(7).Date).ToList();
            rptSchedule.DataBind();
        }
    }
}