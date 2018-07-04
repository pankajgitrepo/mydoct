using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using mojoPortal.Business;
using System.Collections.ObjectModel;
using AjaxControlToolkit;
using mojoPortal.Web.Framework;
using mojoPortal.SearchIndex;
using mojoPortal.Business.WebHelpers;

namespace mojoPortal.Web.Controls
{
    public partial class FeatureCourseList : SiteModuleControl
    {
        private int totalPages = 1;
        private int pageNumber = 1;
        private int pageSize = WebConfigSettings.ContentStyleTemplatePageSize;
        private bool IsNewRecord = true;
        private int courseID = 0;
        public int SiteId { get; set; }
        public static int TotalRecord;

        protected override void OnInit(EventArgs e)
        {
            btnSave.Text = Resources.Resource.CourseEntrySaveButton;
            btnCancel.Text = Resources.Resource.CourseEntryCancelButton;
            btnDelete.Text = Resources.Resource.CourseDeleteBtn;
            if (btnDelete != null)
            {
                btnDelete.OnClientClick = "return confirm('" + Resources.Resource.BrowseCourseRecordDelete + "');";
            }
            btnAddCourse.Text = Resources.Resource.CourseAddButton;
            //grdCourseList.RowCommand+=grdCourseList_RowCommand;
            reqLeadInstructor.InitialValue = Resources.Resource.DropDownPleaseSelect;
            //if (IsPostBack)
            //{
            //    Session["SortBy"] = null;
            //}
          
        }
        //protected void Page_PreRender(object sender, EventArgs e)
        //{

        //    if (Sortby != null)
        //    {
        //        ddlSortforGridSearch.SelectedValue = Sortby;
        //    }
        //    if (ViewState["FilterBy"] != null)
        //    {
        //        ddlFilterforGridSearch.SelectedValue = ViewState["FilterBy"].ToString();
        //    }

        //    BindCourseGrid(ddlFilterforGridSearch.SelectedIndex != 0 ? ddlFilterforGridSearch.SelectedItem.Text.Trim() : null, ddlSortforGridSearch.SelectedIndex != 0 ? ddlSortforGridSearch.SelectedValue : null);
                
        //}
        protected void Page_Load(object sender, EventArgs e)
        {
            SiteId = SiteSettings.GetSiteIdByHostName(WebUtils.GetHostName());

           

            if (!IsPostBack)
            {
               
                BindUserDropdown();
                //BindCourseGrid(ddlFilterforGridSearch.SelectedIndex != 0 ? ddlFilterforGridSearch.SelectedItem.Text.Trim() : null, ddlSortforGridSearch.SelectedIndex != 0 ? ddlSortforGridSearch.SelectedValue : null);
            }
            else

                //if (Sortby != null)
            {
                object obj = grdCourseList.DataSource;

                //grdCourseList.DataBind();
            }
            pageNumber = WebUtils.ParseInt32FromQueryString("pagenumber", pageNumber);

            if (ViewState["Sortby"] != null)
            {
                ddlSortforGridSearch.SelectedValue = ViewState["Sortby"].ToString();
            }
            if (ViewState["FilterBy"] != null)
            {
                ddlFilterforGridSearch.SelectedValue = ViewState["FilterBy"].ToString();
            }

                BindCourseGrid(ddlFilterforGridSearch.SelectedIndex != 0 ? ddlFilterforGridSearch.SelectedItem.Text.Trim() : null, ddlSortforGridSearch.SelectedIndex != 0 ? ddlSortforGridSearch.SelectedValue : null);
            
           
          

            if (Request.QueryString != null)
            {
                if (Request.QueryString["act"] == "ed" && (Request.QueryString["cid"] != null) && SiteUtils.GetCurrentSiteUser().IsInRoles("Admins"))
                {
                    BindCourseInformation(Convert.ToInt32(Request.QueryString["cid"]));
                }
                else if (Request.QueryString["act"] == "lk" && (Request.QueryString["cid"] != null))
                {
                    SetLikes((string)Request.QueryString["cid"]);
                }

            }

            btnAddCourse.Visible = SiteUtils.GetCurrentSiteUser() != null ? SiteUtils.GetCurrentSiteUser().IsInRoles("Admins") : false;
            
            //updPnlCourseList.Update();
        }
        private void GridPageSetting(int totalRows)
        {
            if (pageSize > 0) totalPages = totalRows / pageSize;

            if (totalRows <= pageSize)
            {
                totalPages = 1;
            }
            else
            {
                int remainder;
                Math.DivRem(totalRows, pageSize, out remainder);
                if (remainder > 0)
                {
                    totalPages += 1;
                }
            }

            #region PageSettings
            string pageUrl = SiteRoot + "/" + WebConfigSettings.CoursesUrl + "?pagenumber={0}";
            //pgrTop.PageURLFormat = pageUrl;
            //pgrTop.ShowFirstLast = true;
            //pgrTop.CurrentIndex = pageNumber;
            //pgrTop.PageSize = pageSize;
            //pgrTop.PageCount = totalPages;
            //pgrTop.Visible = (totalPages > 1);
            
            //pgrBottom.PageURLFormat = pageUrl;
            //pgrBottom.ShowFirstLast = true;
            //pgrBottom.CurrentIndex = pageNumber;
            //pgrBottom.PageSize = pageSize;
            //pgrBottom.PageCount = totalPages;
            //pgrBottom.Visible = (totalPages > 1);
            #endregion
        }
        private void BindCourseGrid(string filterBy = null, string sortBy = null)
        {

            if (SiteUtils.GetCurrentSiteUser() == null) {
                trAddCourse.Visible = false;
                grdCourseList.DataSource = null;
                grdCourseList.DataBind();
               // pgrBottom.Visible = false;
                return;
            };

            bool isAdmin= false;
            if (Request.IsAuthenticated &&
    (SiteUtils.GetCurrentSiteUser() != null && SiteUtils.GetCurrentSiteUser().IsInRoles("Admins")))
            {
                isAdmin = true;
            }

            List<CourseModule> courses = CourseModule.GetAllCourses(SiteUtils.GetCurrentSiteUser().UserId, pageNumber, pageSize, filterBy, sortBy,isAdmin);

            if (courses.Count > 0 && courses[0].TotalRows > 0)
            {
                GridPageSetting(courses[0].TotalRows);



                TotalRecord = courses.Count;
                GridViewPageCount(filterBy);
            }
            else
            {
                lblCourseCount.Text = string.Empty;
            }

            grdCourseList.DataSource = courses;
            grdCourseList.DataBind();

        }

        private void BindUserDropdown()
        {
            CourseModule course = new CourseModule();
            //SiteUser users = new SiteUser();
            List<SiteUser> users = SiteUser.LoadInstructors(SiteId);
            List<Role> roles = Role.GetbySite(SiteId).Where(t=>t.IsC21Role).ToList();
            List<Audience> audience = course.LoadAudienceFromReader();
            cblAudience.DataSource = audience;
            cblAudience.DataBind();

            DataTable dt = MasterDatas.SelectMasterDataForCourse(1);
            ddlLeadInstructor.DataSource = dt;
            ddlLeadInstructor.DataBind();
            ddlLeadInstructor.Items.Insert(0, Resources.Resource.DropDownPleaseSelect);
            
            DataTable dtCourLength = MasterDatas.SelectMasterDataForCourse(2);
            ddlCourseLength.DataSource = dtCourLength;
            ddlCourseLength.DataBind();
            ddlCourseLength.Items.Insert(0, Resources.Resource.DropDownPleaseSelect);
            
            DataTable dturlName = MasterDatas.SelectMasterDataForCourse(3);
            ddlUrlName.DataSource = dturlName;
            ddlUrlName.DataBind();
            ddlUrlName.Items.Insert(0, Resources.Resource.DropDownPleaseSelect);

            cblFilterCategory.DataSource = roles;
            cblFilterCategory.DataBind();

            ddlFilterforGridSearch.DataSource = roles;
            ddlFilterforGridSearch.DataBind();
            ddlFilterforGridSearch.Items.Insert(0, Resources.Resource.DropDownAllRoles);
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            SaveCourse();
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {

        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            CourseModule objCourseModule = new CourseModule();
            int courseID = Convert.ToInt32(ViewState["CourseID"]);
            if (objCourseModule.DeleteCourse(courseID) > 0)
            {
                trAddCourse.Visible = true;
                trCourseList.Visible = true;
                divCourseList.Visible = true;
                trCourseEntry.Visible = false;
                trFilterSort.Visible = true;
                BindCourseGrid(ddlFilterforGridSearch.SelectedIndex != 0 ? ddlFilterforGridSearch.SelectedItem.Text.Trim() : null, ddlSortforGridSearch.SelectedIndex != 0 ? ddlSortforGridSearch.SelectedValue : null);

                //updPnlCourseList.Update();
                objCourseModule.ContentChanged += new ContentChangedEventHandler(coursemodulepage_ContentChanged);
                SiteUtils.QueueIndexing();
            }
        }

        public void SaveCourse()
        {
            CourseModule course = new CourseModule();
            course.CourseName = txtCourseName.Text;
            course.CourseLength = ddlCourseLength.SelectedIndex > 0 ? ddlCourseLength.SelectedItem.Text : ""; //txtCourseLength.Text;
            if ((bool)ViewState["IsNewRecord"])
                course.CourseGUID = new Guid();
            else
            {
                course.IsEdit = true;
                course.CourseId = ViewState["CourseID"] == null ? 0 : Convert.ToInt32(ViewState["CourseID"]);
            }

            course.Delivery = txtDelivery.Text;
            course.Description = txtDescription.Text;
            course.LeadInstructor = ddlLeadInstructor.SelectedItem.Text; //ddlLeadInstructor.SelectedValue; //txtLeadInstr.Text;
            course.Metatags = txtMetaTags.Text;
            course.Cost = txtCost.Text.Replace('$',' ').Trim();
            course.Active = chkActive.Checked ? 1 : 0;
            course.UrlLink = txtUrlLink.Text;
            course.ScheduleType = ddlUrlName.SelectedItem.Value!="0" ? ddlUrlName.SelectedItem.Text:""; //txtUrlName.Text.Trim();
            course.FilterCategory = txtFilterCategory.Text.Trim();
            course.FilterIds = hdnFilterCategoryIds.Value;
            course.AudienceIds = hdnAudienceIds.Value;
            course.Audience = txtAudience.Text.Trim();
            course.ModuleId = this.ModuleConfiguration.ModuleId;
            course.ContentChanged += new ContentChangedEventHandler(coursemodulepage_ContentChanged);

            int rowsAffected = course.SaveCourse(course);
            trAddCourse.Visible = true;
            trCourseList.Visible = true;
            divCourseList.Visible = true;
            trCourseEntry.Visible = false;
            trFilterSort.Visible = true;
            BindCourseGrid(ddlFilterforGridSearch.SelectedIndex != 0 ? ddlFilterforGridSearch.SelectedItem.Text.Trim() : null, ddlSortforGridSearch.SelectedIndex != 0 ? ddlSortforGridSearch.SelectedValue : null);

            //updPnlCourseList.Update();
            CacheHelper.ClearModuleCache(this.ModuleConfiguration.ModuleId);
            SiteUtils.QueueIndexing();
        }

        protected void grdCourseList_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditCourse")
            {
                object obj = grdCourseList.DataSource;
               
                if (e.CommandArgument != null)
                    BindCourseInformation(Convert.ToInt32(e.CommandArgument));
            }
            if (e.CommandName == "Comments")
            {
                if (e.CommandArgument != null)
                {
                    Session["ParentGuid"] = e.CommandArgument.ToString();

                    string url = WebConfigSettings.CourseCommentsFeatureUrl;
                    string scrpt = "window.open('" + url + "', 'popup_window', 'width=300,height=100,left=100,top=100,resizable=yes');";
                    Page.ClientScript.RegisterClientScriptBlock(typeof(Page), "Kaltura_7", scrpt, true);

                    //Response.Redirect("~/" + Resources.Resource.CourseCommentsFeatureUrl);
                }
            }
            if (e.CommandName == "SetLike")
            {
                SetLikes(e.CommandArgument.ToString());
            }
           
        }

        protected void lbtnEdit_Click(object sender, EventArgs e)
        {
            GridViewRow grd = (GridViewRow)((LinkButton)sender).NamingContainer;
            LinkButton btn = (LinkButton)sender;
            string commandName = btn.CommandName;
            string commandArgument = btn.CommandArgument;
            if (commandArgument != null)
                BindCourseInformation(Convert.ToInt32(commandArgument));
        }

        //protected void lbtnCourseEdit_DataBinding(object sender, EventArgs e)
        //{
        //    LinkButton lb = (LinkButton)sender;
        //    ScriptManager sm = (ScriptManager)Page.Master.FindControl("SM_ID");
        //    sm.RegisterPostBackControl(lb);
        //}
        private void SetLikes(string courseId)
        {
            CourseModule.SetLikesforCourse(Convert.ToInt32(courseId), SiteUtils.GetCurrentSiteUser().UserId);
            //BindCourseGrid();
            BindCourseGrid(ddlFilterforGridSearch.SelectedIndex != 0 ? ddlFilterforGridSearch.SelectedItem.Text.Trim() : null, ddlSortforGridSearch.SelectedIndex != 0 ? ddlSortforGridSearch.SelectedValue : null);
            //updPnlCourseList.Update();
        }

        private void BindCourseInformation(int CourseId)
        {
            GetCourseDetailsByCourseId(CourseId);            
        }

        private void GetCourseDetailsByCourseId(int CourseId)
        {
            CourseModule course= CourseModule.GetCourseDetailsByCourseId(CourseId);
            courseID = CourseId;
            ViewState["CourseID"] = CourseId.ToString();
            txtCourseName.Text = course.CourseName;
            txtDescription.Text = course.Description;
            //ddlLeadInstructor.SelectedValue=   course.LeadInstructor;
            ddlLeadInstructor.SelectedValue = ddlLeadInstructor.Items.FindByText(course.LeadInstructor) != null ? ddlLeadInstructor.Items.FindByText(course.LeadInstructor).Value : Resources.Resource.DropDownPleaseSelect;
            ddlCourseLength.SelectedValue = ddlCourseLength.Items.FindByText(course.CourseLength) != null ? ddlCourseLength.Items.FindByText(course.CourseLength).Value : Resources.Resource.DropDownPleaseSelect;
            ddlUrlName.SelectedValue = ddlUrlName.Items.FindByText(course.ScheduleType) != null ? ddlUrlName.Items.FindByText(course.ScheduleType).Value : Resources.Resource.DropDownPleaseSelect;
            //txtLeadInstr.Text = course.LeadInstructor;
            //txtCourseLength.Text = course.CourseLength;
            txtDelivery.Text = course.Delivery;
            txtCost.Text = "$" + course.Cost;
            //txtUrlName.Text = course.ScheduleType;
            txtUrlLink.Text = course.UrlLink;
            //ddlFilterCategory.SelectedValue = course.FilterCategory;
            txtMetaTags.Text = course.Metatags;
            chkActive.Checked = course.Active == 1 ? true : false;
            txtAudience.Text = course.Audience;
            if (course.AudienceIds.Length>0)
            {
                Array audIds = course.AudienceIds.Split(',');
                foreach (string item in audIds)
                {
                    cblAudience.Items.FindByValue(item).Selected = true;
                }
            }
            cblFilterCategory.ClearSelection();
            if (course.FilterIds.Length > 0)
            {
                Array flCat = course.FilterIds.Split(',');
                string strflCat = string.Empty;
                hdnFilterCategoryIds.Value = course.FilterIds;
                foreach (string item in flCat)
                {
                    cblFilterCategory.Items.FindByValue(item).Selected = true;
                    //strflCat += cblFilterCategory.Items.FindByValue(item).Text + ", ";
                }
                txtFilterCategory.Text = course.FilterCategory;
            }
            else
            {
                hdnFilterCategoryIds.Value = string.Empty;
                txtFilterCategory.Text = string.Empty;
            }

            trCourseList.Visible = false;
            divCourseList.Visible = false;
            trCourseEntry.Visible = true;
            trAddCourse.Visible = false;
            trFilterSort.Visible = false;
            btnSave.Text = Resources.Resource.CourseEntryUpdateButton;
            btnDelete.Visible = true;
            ViewState["IsNewRecord"] = false;
        }

        protected void btnAddCourse_Click(object sender, EventArgs e)
        {
            ClearAllFields();
            trCourseList.Visible = false;
            divCourseList.Visible = false;
            trCourseEntry.Visible = true;
            trAddCourse.Visible = false;
            trFilterSort.Visible = false;
            btnDelete.Visible = false;//For New record delete button is hidden
            btnSave.Text = Resources.Resource.CourseEntrySaveButton;
        }

        private void ClearAllFields()
        {
            txtCourseName.Text = string.Empty;
            //txtCourseLength.Text = string.Empty;
            txtCost.Text = "$0.00";
            txtDescription.Text = string.Empty;
            txtAudience.Text = string.Empty;
            txtFilterCategory.Text = string.Empty;
            txtDelivery.Text = string.Empty;
            //txtUrlName.Text = string.Empty;
            ddlLeadInstructor.SelectedIndex = -1;
            ddlCourseLength.SelectedIndex = -1;
            ddlUrlName.SelectedIndex = -1;
            //txtLeadInstr.Text = string.Empty;
            cblAudience.ClearSelection();
            cblFilterCategory.ClearSelection();
            txtMetaTags.Text = string.Empty;
            txtUrlLink.Text = string.Empty;
            chkActive.Checked = true;
            ViewState["IsNewRecord"] = true;    
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            trCourseList.Visible = true;
            divCourseList.Visible = true;
            trCourseEntry.Visible = false;
            trAddCourse.Visible = true;
            trFilterSort.Visible = true;
            BindCourseGrid(ddlFilterforGridSearch.SelectedIndex != 0 ? ddlFilterforGridSearch.SelectedItem.Text.Trim() : null, ddlSortforGridSearch.SelectedIndex != 0 ? ddlSortforGridSearch.SelectedValue : null);
            
            //updPnlCourseList.Update();
        }

        protected void cblAudience_SelectedIndexChanged(object sender, EventArgs e)
        {
            string name = "";
            string ids = "";
            for (int i = 0; i < cblAudience.Items.Count; i++)
            {
                if (cblAudience.Items[i].Selected)
                {                                      
                    name += cblAudience.Items[i].Text + ", ";
                    ids += cblAudience.Items[i].Value + ",";
                }
            }
            txtAudience.Text = name.Trim().TrimEnd(',');
            hdnAudienceIds.Value = ids.TrimEnd(',');
            updPanelAudience.Update();
        }

        protected void cblFilterCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            string name = "";
            string ids = "";

            for (int i = 0; i < cblFilterCategory.Items.Count; i++)
            {
                if (cblFilterCategory.Items[i].Selected)
                {
                    name += cblFilterCategory.Items[i].Text + ",";
                    ids += cblFilterCategory.Items[i].Value + ",";
                }
            }
            txtFilterCategory.Text = name.Trim().TrimEnd(',');
            hdnFilterCategoryIds.Value = ids.TrimEnd(',');
            updPanelFilterCategory.Update();
        }

        protected void ddlFilterforGridSearch_SelectedIndexChanged(object sender, EventArgs e)
        {            
                trAddCourse.Visible = true;
                trCourseList.Visible = true;
                divCourseList.Visible = true;
                trCourseEntry.Visible = false;
                trFilterSort.Visible = true;
                
                ViewState["FilterBy"] = ddlFilterforGridSearch.SelectedValue;

           ViewState["FilterData"]=ddlFilterforGridSearch.SelectedItem.Text.Trim();
        
                BindCourseGrid(ddlFilterforGridSearch.SelectedIndex != 0 ? ddlFilterforGridSearch.SelectedItem.Text.Trim() : null, ddlSortforGridSearch.SelectedIndex != 0 ? ddlSortforGridSearch.SelectedValue : null);
              //  UpdatePanelFilterBy.Update();
                //UpdatePanel1.Update();

            //updPnlCourseList.Update();
           
        }

        protected void ddlSortforGridSearch_SelectedIndexChanged(object sender, EventArgs e)
        {
            trAddCourse.Visible = true;
            trCourseList.Visible = true;
            divCourseList.Visible = true;
            trCourseEntry.Visible = false;
            trFilterSort.Visible = true;
            ViewState["Sortby"] = ddlSortforGridSearch.SelectedValue;

          //  ViewState["SortBy"] = ddlSortforGridSearch.SelectedValue;
            BindCourseGrid(ddlFilterforGridSearch.SelectedIndex != 0 ? ddlFilterforGridSearch.SelectedItem.Text.Trim() : null, ddlSortforGridSearch.SelectedIndex != 0 ? ddlSortforGridSearch.SelectedValue : null);
            //UpdatePanel1.Update();
        }

        protected void imgBtnComments_Click(object sender, ImageClickEventArgs e)
        {

        }

        void coursemodulepage_ContentChanged(object sender, ContentChangedEventArgs e)
        {
            IndexBuilderProvider indexBuilder = IndexBuilderManager.Providers["BrowseCoursesIndexBuilderProvider"];
            if (indexBuilder != null)
            {
                indexBuilder.ContentChangedHandler(sender, e);
            }
        }

       

        protected void grdCourseList_PageIndexChanging1(object sender, GridViewPageEventArgs e)
        {
            grdCourseList.PageIndex = e.NewPageIndex;

            string FilterBy = Convert.ToString(ViewState["FilterBy"]);

            GridViewPageCount(FilterBy);

           BindCourseGrid(ddlFilterforGridSearch.SelectedIndex != 0 ? ddlFilterforGridSearch.SelectedItem.Text.Trim() : null, ddlSortforGridSearch.SelectedIndex != 0 ? ddlSortforGridSearch.SelectedValue : null);

        }

        private void GridViewPageCount(string filterBy)
        {
            int i = grdCourseList.PageSize;
            int iTotalRecords = TotalRecord;
            int iEndRecord;

            iEndRecord = grdCourseList.PageSize * (grdCourseList.PageIndex + 1);

            int iStartsRecods = iEndRecord - grdCourseList.PageSize+1   ;

            if (iEndRecord > iTotalRecords)
                iEndRecord = iTotalRecords;

            if (iStartsRecods == 0) iStartsRecods = 1;
            if (iEndRecord == 0) iEndRecord = iTotalRecords;
            //UpdatePanel1.Update();

            if (string.IsNullOrEmpty(filterBy))
            {
                lblCourseCount.Text = Resources.Resource.CourseCountDisplay.Replace("#CNT1", iStartsRecods + " to " + iEndRecord).Replace("#CNT2", TotalRecord.ToString());

            }
            else
            {
                lblCourseCount.Text = Resources.Resource.CourseCountDisplayWithRole.Replace("#CNT1", iStartsRecods + " to " + iEndRecord).Replace("#CNT2", TotalRecord.ToString()).Replace("#ROLE", filterBy);

            }



        }
    }

   
}