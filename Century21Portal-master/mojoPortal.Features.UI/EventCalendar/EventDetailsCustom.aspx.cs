using mojoPortal.Business;
using mojoPortal.Web;
using mojoPortal.Web.Framework;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace mojoPortal.Features.UI.EventCalendar
{
    public partial class EventDetailsCustom : Page
    {
        private int moduleId = -1;
        private int itemId = -1;
        private Hashtable moduleSettings;
        public string strLocation { get; set; }

        #region OnInit

        //protected override void OnPreInit(EventArgs e)
        //{
        //    AllowSkinOverride = true;
        //    base.OnPreInit(e);
        //}

        override protected void OnInit(EventArgs e)
        {
            this.Load += new System.EventHandler(this.Page_Load);
            base.OnInit(e);
        }

        #endregion

        private void Page_Load(object sender, System.EventArgs e)
        {
            LoadSettings();
            PopulateControls();
        }

        private void PopulateControls()
        {
            if (itemId > -1)
            {
                CalendarEvent calendarEvent = new CalendarEvent(itemId);
                if (calendarEvent.ModuleId != moduleId)
                {
                    SiteUtils.RedirectToAccessDeniedPage(this);
                    return;
                }
                heading.Text = calendarEvent.Title;
                //if (calendarEvent.Location.Length == 0) {
                //    this.navigateToGmap.InnerHtml = "";
                //}
                this.lblDate.Text = calendarEvent.EventDate.ToString("MM/dd/yyyy");
                this.lblStartTime.Text = calendarEvent.StartTime.ToShortTimeString();
                this.lblEndTime.Text = calendarEvent.EndTime.ToShortTimeString();
                this.litDescription.InnerHtml = calendarEvent.Description;
                if (this.litDescription.InnerHtml == "")
                {
                    this.lblDescr.InnerText = null;
                    this.divOfDescription.Attributes.Add("Style", "display:none");
                }
                strLocation = calendarEvent.Location.Replace(' ','+').TrimEnd(new char[]{'+'});
                
                if (calendarEvent.Location.Length > 0)
                {
                    this.contentOfEvntDetailsPage.InnerHtml = "<b><label>Location: </label></b> <a style='text-decoration:none;color:rgb(0, 167, 213);' id='navigateToGmap' href=https://www.google.co.in/maps/place/" + strLocation + " target='_blank'>View Map</a>";
                }

            }

        }
        private void LoadSettings()
        {
            moduleId = WebUtils.ParseInt32FromQueryString("mid", -1);
            itemId = WebUtils.ParseInt32FromQueryString("ItemID", -1);
            moduleSettings = ModuleSettings.GetModuleSettings(moduleId);
        }
    }
}