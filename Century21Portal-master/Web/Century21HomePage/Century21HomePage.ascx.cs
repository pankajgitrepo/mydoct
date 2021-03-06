﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using mojoPortal.Business;
using mojoPortal.Business.WebHelpers;
using mojoPortal.Web.Framework;
using mojoPortal.Web;
using mojoPortal.Web.Controls;
using mojoPortal.Web.UI;
using mojoPortal.Web.Editor;
using mojoPortal.Net;

namespace mojoPortal.Web.Century21HomePage
{
    public partial class Century21HomePage : SiteModuleControl 
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