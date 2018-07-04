using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using mojoPortal.Business;
using System.Data;
using System.Text;

namespace mojoPortal.Web.CustomEventCalendar
{
    public partial class HomePageEventsDisplay : SiteModuleControl
    {
        //private int moduleId = -1;
        private DateTime FrmDate = DateTime.Today;
        private DateTime ToDate = DateTime.Now.AddYears(10);
        public int EventCalenderModuleID { get; set; }
        public int EventCalenderPageID { get; set; }
        public bool flagCheckIsUserAdmin = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            GetpageIdModuleID();
            PopulateControls();
            //PopulateEvents();
        }

        #region
        //Commented Code of Binding Data to UI with table at server side dynamically.

        //private void PopulateEvents()
        //{
        //    DataSet ds = CustomCalenderEventBusiness.GetEventsByGroups(EventCalenderModuleID, FrmDate, ToDate);
        //    PrintingEventsToTable(ds);
        //}




        //private void PrintingEventsToTable(DataSet ds2)
        //{
        //    //string USER = SiteUtils.GetCurrentSiteUser().UserId.ToString();

        //    if (SiteUtils.GetCurrentSiteUser() != null)
        //    {
        //        flagCheckIsUserAdmin = SiteUtils.GetCurrentSiteUser().IsInRoles("Admins");
        //    }
        //    //Role.Get("admin@century21.com");
        //    string[] ChkRepeatDate = new string[1000];
        //    int countforRepeatDateChk = 0;
        //    string widthStyle = "width:33.33%;text-align:'';";
        //    string withsytleTD = (flagCheckIsUserAdmin) ? string.Empty : widthStyle.ToString();

        //    DataTable EventsGroups = ds2.Tables[0];
        //    DataTable CountsDate = ds2.Tables[1];

        //    StringBuilder html = new StringBuilder();

        //    //Table start.
        //    html.Append("<table class='eventTable' style='table-layout:fixed;'>");

        //    #region
        //    //Building the Header row.
        //    //html.Append("<tr>");
        //    //foreach (DataColumn column in dt.Columns)
        //    //{
        //    //    html.Append("<th>");
        //    //    html.Append(column.ColumnName);
        //    //    html.Append("</th>");
        //    //}
        //    //html.Append("</tr>");
        //    #endregion

        //    //Building the Data rows.
        //    try
        //    {
        //        if (EventsGroups.Rows.Count > 0)
        //        {
        //            foreach (DataRow row in EventsGroups.Rows)
        //            {
        //                int countforThirdTD = 0;
        //                if (countforRepeatDateChk == 0)
        //                {
        //                    ChkRepeatDate[countforRepeatDateChk] = "NULL";
        //                }
        //                countforRepeatDateChk++;
        //                ChkRepeatDate[countforRepeatDateChk] = Convert.ToDateTime(row.ItemArray[6]).ToString("dd/MM/yyyy");


        //                if (ChkRepeatDate[countforRepeatDateChk] != ChkRepeatDate[countforRepeatDateChk - 1])
        //                {
        //                    if (countforRepeatDateChk != 1)
        //                    {
        //                        html.Append("<tr><td><br /></td></tr>");
        //                    }
        //                    html.Append("<tr class='eventTableTr'><td class='eventTableTd' style='padding-left: 40%;'>");
        //                    html.Append(ChkRepeatDate[countforRepeatDateChk]);
        //                    html.Append("</td></tr>");
        //                }
        //                html.Append("<tr class='eventTableTr'>");
        //                foreach (DataColumn column in EventsGroups.Columns)
        //                {
        //                    if (column.ColumnName == "Title" || column.ColumnName == "Location")
        //                    {
        //                        html.Append("<td class='eventTableTd' style='" + withsytleTD + "'>");
        //                        html.Append(row[column.ColumnName]);
        //                        countforThirdTD++;
        //                        html.Append("</td>");
        //                    }
        //                    else if (countforThirdTD == 2)
        //                    //else if (countforThirdTD == 3 && flagCheckIsUserAdmin)
        //                    {
        //                        html.Append("<td class='eventTableTd' style='" + withsytleTD + "'>");
        //                        html.Append("<a class='cblink' href='" + SiteRoot + "/EventCalendar/EventDetailsCustom.aspx?ItemID=" + row["ItemID"].ToString() + "&mid=" + EventCalenderModuleID + "&pageid=" + EventCalenderPageID + "'>Details</a>");
        //                        html.Append("</td>");
        //                        countforThirdTD++;
        //                    }

        //                    if (countforThirdTD == 3 && flagCheckIsUserAdmin)
        //                    //if (countforThirdTD == 3)
        //                    {
        //                        html.Append("<td class='eventTableTd'style='" + withsytleTD + "'>");
        //                        html.Append("<a class='' href='" + SiteRoot + "/EventCalendar/EditEvent.aspx?pageid=" + EventCalenderPageID + "&ItemID=" + row["ItemID"].ToString() + "&mid=" + EventCalenderModuleID + "'>Edit Events</a>");
        //                        html.Append("</td>");
        //                    }
        //                }
        //                html.Append("</tr>");
        //            }
        //        }

        //        else
        //        {
        //            html.Append("<tr><td>No Events!</td></tr>");
        //        }
        //    }
        //    catch
        //    {

        //    }

        //    //Table end.
        //    html.Append("</table>");

        //    //ShowEvents.Controls.Add(new Literal { Text = html.ToString() });
        //}
        #endregion


        private void GetpageIdModuleID()
        {
            List<KeyValuePair<string, int>> lstMIDPID = new List<KeyValuePair<string, int>>();
            lstMIDPID = CustomCalenderEventBusiness.GetModuleID(Resources.Resource.GetModuleIDByModuleNameEventCalender);
            EventCalenderModuleID = lstMIDPID[0].Value;
            EventCalenderPageID = lstMIDPID[1].Value;
        }

        private void PopulateControls()
        {
            if (SiteUtils.GetCurrentSiteUser() != null)
            {
                flagCheckIsUserAdmin = SiteUtils.GetCurrentSiteUser().IsInRoles(Resources.Resource.GiveAccessToAdmins);
            }
            DataSet ds = CustomCalenderEventBusiness.GetEvents(EventCalenderModuleID, FrmDate, ToDate);
            this.rptEvents.DataSource = ds;
            this.rptEvents.DataBind();
        }
    }
}