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
using Resources;

namespace mojoPortal.Web.Controls
{
    public partial class FeatureCourseSearch : SiteModuleControl
    {
        private int totalPages = 1;
        private int pageNumber = 1;
        private int pageSize = WebConfigSettings.ContentStyleTemplatePageSize;
        private bool IsNewRecord = true;
        private int courseID = 0;
        public int SiteId { get; set; }

        protected override void OnInit(EventArgs e)
        {
            //btnSave.Text = Resources.Resource.CourseEntrySaveButton;
            //btnCancel.Text = Resources.Resource.CourseEntryCancelButton;
            //btnDelete.Text = Resources.Resource.CourseDeleteBtn;
            //btnAddCourse.Text = Resources.Resource.CourseAddButton;
            ////grdCourseList.RowCommand+=grdCourseList_RowCommand;
            //reqLeadInstructor.InitialValue = Resources.Resource.DropDownPleaseSelect;
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            SiteId = SiteSettings.GetSiteIdByHostName(WebUtils.GetHostName());

            pageNumber = WebUtils.ParseInt32FromQueryString("pagenumber", pageNumber);


            //lnkAllCourses.Text = "All courses";
            //lnkAllCourses.NavigateUrl = "~/" + WebConfigSettings.CoursesUrl;
            if (!IsPostBack)
            {
                BindUserDropdown();
               // BindCourseGrid(ddlFilterforGridSearch.SelectedIndex != 0 ? ddlFilterforGridSearch.SelectedItem.Text.Trim() : null, ddlSortforGridSearch.SelectedIndex != 0 ? ddlSortforGridSearch.SelectedValue : null);
                if (Request.QueryString != null)
                {
                    BindCourseGrid(Convert.ToInt32(Request.QueryString["ItemID"]));
                }
            }

            //if (Request.QueryString != null)
            //{
            //    if (Request.QueryString["act"] == "ed" && (Request.QueryString["cid"] != null) && SiteUtils.GetCurrentSiteUser().IsInRoles("Admins"))
            //    {
            //        BindCourseInformation(Convert.ToInt32(Request.QueryString["cid"]));
            //    }
            //    else if (Request.QueryString["act"] == "lk" && (Request.QueryString["cid"] != null))
            //    {
            //        SetLikes((string)Request.QueryString["cid"]);
            //    }

            //}

           // btnAddCourse.Visible = SiteUtils.GetCurrentSiteUser() != null ? SiteUtils.GetCurrentSiteUser().IsInRoles("Admins") : false;

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


            //pgrBottom.PageURLFormat = pageUrl;
            //pgrBottom.ShowFirstLast = true;
            //pgrBottom.CurrentIndex = pageNumber;
            //pgrBottom.PageSize = pageSize;
            //pgrBottom.PageCount = totalPages;
            //pgrBottom.Visible = (totalPages > 1);
            #endregion
        }
        private void BindCourseGrid(int courseId)
        {

            if (SiteUtils.GetCurrentSiteUser() == null)
            {
                //trAddCourse.Visible = false;
                grdCourseList.DataSource = null;
                grdCourseList.DataBind();
                //pgrBottom.Visible = false;
                return;
            };

            List<CourseModule> courses = CourseModule.GetCourseByCourseId(courseId);

            if (courses.Count > 0 && courses[0].TotalRows > 0)
            {
                GridPageSetting(courses[0].TotalRows);

                //if (filterBy == null)
                //{
                    //lblCourseCount.Text = Resources.Resource.CourseCountDisplay.Replace("#CNT1", courses.Count().ToString()).Replace("#CNT2", courses[0].TotalRows.ToString());
                //}
                //else
                   // lblCourseCount.Text = Resources.Resource.CourseCountDisplayWithRole.Replace("#CNT1", courses.Count().ToString()).Replace("#CNT2", courses[0].TotalRows.ToString()).Replace("#ROLE", filterBy);
            }
            else
            {
                //lblCourseCount.Text = string.Empty;
            }

            grdCourseList.DataSource = courses;
            grdCourseList.DataBind();

        }

        private void BindUserDropdown()
        {
            //CourseModule course = new CourseModule();
            ////SiteUser users = new SiteUser();
            //List<SiteUser> users = SiteUser.LoadInstructors(SiteId);
            //List<Role> roles = Role.GetbySite(SiteId).Where(t => t.IsC21Role).ToList();
            //List<Audience> audience = course.LoadAudienceFromReader();
            //cblAudience.DataSource = audience;
            //cblAudience.DataBind();

            ////ddlLeadInstructor.DataSource = users;
            ////ddlLeadInstructor.DataBind();
            ////ddlLeadInstructor.Items.Insert(0, Resources.Resource.DropDownPleaseSelect);


            //cblFilterCategory.DataSource = roles;
            //cblFilterCategory.DataBind();

            //ddlFilterforGridSearch.DataSource = roles;
            //ddlFilterforGridSearch.DataBind();
            //ddlFilterforGridSearch.Items.Insert(0, Resources.Resource.DropDownPleaseSelect);
        }

        //protected void btnSave_Click(object sender, EventArgs e)
        //{
        //    SaveCourse();
        //}

        //protected void btnUpdate_Click(object sender, EventArgs e)
        //{

        //}

        //protected void btnDelete_Click(object sender, EventArgs e)
        //{
        //    CourseModule objCourseModule = new CourseModule();
        //    if (objCourseModule.DeleteCourse(courseID) > 0)
        //    {
        //        trAddCourse.Visible = true;
        //        trCourseList.Visible = true;
        //        divCourseList.Visible = true;
        //        trCourseEntry.Visible = false;
        //        trFilterSort.Visible = true;
        //        BindCourseGrid();
        //        updPnlCourseList.Update();
        //        objCourseModule.ContentChanged += new ContentChangedEventHandler(coursemodulepage_ContentChanged);
        //        SiteUtils.QueueIndexing();
        //    }
        //}

        //public void SaveCourse()
        //{
        //    CourseModule course = new CourseModule();
        //    course.CourseName = txtCourseName.Text;
        //    course.CourseLength = txtCourseLength.Text;
        //    if (IsNewRecord)
        //        course.CourseGUID = new Guid();
        //    else
        //    {
        //        course.IsEdit = true;
        //        course.CourseId = courseID;
        //    }

        //    course.Delivery = txtDelivery.Text;
        //    course.Description = txtDescription.Text;
        //    course.LeadInstructor = txtLeadInstr.Text;//ddlLeadInstructor.SelectedValue;
        //    course.Metatags = txtMetaTags.Text;
        //    course.Cost = txtCost.Text.Replace('$', ' ').Trim();
        //    course.Active = chkActive.Checked ? 1 : 0;
        //    course.UrlLink = txtUrlLink.Text;
        //    course.ScheduleType = "Check Schedule";//This will be replaced in future
        //    course.FilterCategory = txtFilterCategory.Text.Trim();
        //    course.FilterIds = hdnFilterCategoryIds.Value;
        //    course.AudienceIds = hdnAudienceIds.Value;
        //    course.Audience = txtAudience.Text.Trim();
        //    course.ModuleId = this.ModuleConfiguration.ModuleId;
        //    course.ContentChanged += new ContentChangedEventHandler(coursemodulepage_ContentChanged);

        //    int rowsAffected = course.SaveCourse(course);
        //    trAddCourse.Visible = true;
        //    trCourseList.Visible = true;
        //    divCourseList.Visible = true;
        //    trCourseEntry.Visible = false;
        //    trFilterSort.Visible = true;
        //    BindCourseGrid();
        //    updPnlCourseList.Update();
        //    CacheHelper.ClearModuleCache(this.ModuleConfiguration.ModuleId);
        //    SiteUtils.QueueIndexing();
        //}

        //protected void grdCourseList_RowCommand(object sender, GridViewCommandEventArgs e)
        //{
        //    if (e.CommandName == "EditCourse")
        //    {
        //        if (e.CommandArgument != null)
        //            BindCourseInformation(Convert.ToInt32(e.CommandArgument));
        //    }
        //    if (e.CommandName == "Comments")
        //    {
        //        if (e.CommandArgument != null)
        //        {
        //            Session["ParentGuid"] = e.CommandArgument.ToString();

        //            string url = WebConfigSettings.CourseCommentsFeatureUrl;
        //            string scrpt = "window.open('" + url + "', 'popup_window', 'width=300,height=100,left=100,top=100,resizable=yes');";
        //            Page.ClientScript.RegisterClientScriptBlock(typeof(Page), "Kaltura_7", scrpt, true);

        //            //Response.Redirect("~/" + Resources.Resource.CourseCommentsFeatureUrl);
        //        }
        //    }
        //    if (e.CommandName == "SetLike")
        //    {
        //        SetLikes(e.CommandArgument.ToString());
        //    }

        //}

        private void SetLikes(string courseId)
        {
            CourseModule.SetLikesforCourse(Convert.ToInt32(courseId), SiteUtils.GetCurrentSiteUser().UserId);
            //BindCourseGrid();
            //BindCourseGrid(ddlFilterforGridSearch.SelectedIndex != 0 ? ddlFilterforGridSearch.SelectedItem.Text.Trim() : null, ddlSortforGridSearch.SelectedIndex != 0 ? ddlSortforGridSearch.SelectedValue : null);
            updPnlCourseList.Update();
        }

        private void BindCourseInformation(int CourseId)
        {
            //GetCourseDetailsByCourseId(CourseId);
        }

        //private void GetCourseDetailsByCourseId(int CourseId)
        //{
        //    CourseModule course = CourseModule.GetCourseDetailsByCourseId(CourseId);
        //    courseID = CourseId;
        //    txtCourseName.Text = course.CourseName;
        //    txtDescription.Text = course.Description;
        //    //ddlLeadInstructor.SelectedValue=   course.LeadInstructor;
        //    txtLeadInstr.Text = course.LeadInstructor;
        //    txtCourseLength.Text = course.CourseLength;
        //    txtDelivery.Text = course.Delivery;
        //    txtCost.Text = "$" + course.Cost;
        //    txtUrlLink.Text = course.UrlLink;
        //    //ddlFilterCategory.SelectedValue = course.FilterCategory;
        //    txtMetaTags.Text = course.Metatags;
        //    chkActive.Checked = course.Active == 1 ? true : false;
        //    txtAudience.Text = course.Audience;
        //    if (course.AudienceIds.Length > 0)
        //    {
        //        Array audIds = course.AudienceIds.Split(',');
        //        foreach (string item in audIds)
        //        {
        //            cblAudience.Items.FindByValue(item).Selected = true;
        //        }
        //    }

        //    if (course.FilterIds.Length > 0)
        //    {
        //        Array flCat = course.FilterIds.Split(',');
        //        string strflCat = string.Empty;
        //        hdnFilterCategoryIds.Value = course.FilterIds;
        //        foreach (string item in flCat)
        //        {
        //            cblFilterCategory.Items.FindByValue(item).Selected = true;
        //            //strflCat += cblFilterCategory.Items.FindByValue(item).Text + ", ";
        //        }
        //        txtFilterCategory.Text = course.FilterCategory;
        //    }
        //    else
        //    {
        //        hdnFilterCategoryIds.Value = string.Empty;
        //        txtFilterCategory.Text = string.Empty;
        //    }

        //    trCourseList.Visible = false;
        //    divCourseList.Visible = false;
        //    trCourseEntry.Visible = true;
        //    trAddCourse.Visible = false;
        //    trFilterSort.Visible = false;
        //    btnSave.Text = Resources.Resource.CourseEntryUpdateButton;
        //    btnDelete.Visible = true;
        //    IsNewRecord = false;
        //}

        //protected void btnAddCourse_Click(object sender, EventArgs e)
        //{
        //    ClearAllFields();
        //    trCourseList.Visible = false;
        //    divCourseList.Visible = false;
        //    trCourseEntry.Visible = true;
        //    trAddCourse.Visible = false;
        //    trFilterSort.Visible = false;
        //    btnDelete.Visible = false;//For New record delete button is hidden
        //    btnSave.Text = Resources.Resource.CourseEntrySaveButton;
        //}

        //private void ClearAllFields()
        //{
        //    txtCourseName.Text = string.Empty;
        //    txtCourseLength.Text = string.Empty;
        //    txtCost.Text = "$0.00";
        //    txtDescription.Text = string.Empty;
        //    txtAudience.Text = string.Empty;
        //    txtFilterCategory.Text = string.Empty;
        //    txtDelivery.Text = string.Empty;

        //    //ddlLeadInstructor.SelectedIndex = -1;
        //    txtLeadInstr.Text = string.Empty;
        //    cblAudience.ClearSelection();
        //    cblFilterCategory.ClearSelection();
        //    txtMetaTags.Text = string.Empty;
        //    txtUrlLink.Text = string.Empty;
        //    chkActive.Checked = true;

        //}

        //protected void btnCancel_Click(object sender, EventArgs e)
        //{
        //    trCourseList.Visible = true;
        //    divCourseList.Visible = true;
        //    trCourseEntry.Visible = false;
        //    trAddCourse.Visible = true;
        //    trFilterSort.Visible = true;
        //    BindCourseGrid();
        //    updPnlCourseList.Update();
        //    WebUtils.SetupRedirect(this, SiteUtils.GetCurrentPageUrl());
        //}

        //protected void cblAudience_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    string name = "";
        //    string ids = "";
        //    for (int i = 0; i < cblAudience.Items.Count; i++)
        //    {
        //        if (cblAudience.Items[i].Selected)
        //        {
        //            name += cblAudience.Items[i].Text + ", ";
        //            ids += cblAudience.Items[i].Value + ",";
        //        }
        //    }
        //    txtAudience.Text = name.Trim().TrimEnd(',');
        //    hdnAudienceIds.Value = ids.TrimEnd(',');
        //    updPanelAudience.Update();
        //}

        //protected void cblFilterCategory_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    string name = "";
        //    string ids = "";

        //    for (int i = 0; i < cblFilterCategory.Items.Count; i++)
        //    {
        //        if (cblFilterCategory.Items[i].Selected)
        //        {
        //            name += cblFilterCategory.Items[i].Text + ",";
        //            ids += cblFilterCategory.Items[i].Value + ",";
        //        }
        //    }
        //    txtFilterCategory.Text = name.Trim().TrimEnd(',');
        //    hdnFilterCategoryIds.Value = ids.TrimEnd(',');
        //    updPanelFilterCategory.Update();
        //}

        //protected void ddlFilterforGridSearch_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    trAddCourse.Visible = true;
        //    trCourseList.Visible = true;
        //    divCourseList.Visible = true;
        //    trCourseEntry.Visible = false;
        //    trFilterSort.Visible = true;

        //    BindCourseGrid(ddlFilterforGridSearch.SelectedIndex != 0 ? ddlFilterforGridSearch.SelectedItem.Text.Trim() : null, ddlSortforGridSearch.SelectedIndex != 0 ? ddlSortforGridSearch.SelectedValue : null);
        //    updPnlCourseList.Update();

        //}

        //protected void ddlSortforGridSearch_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    trAddCourse.Visible = true;
        //    trCourseList.Visible = true;
        //    divCourseList.Visible = true;
        //    trCourseEntry.Visible = false;
        //    trFilterSort.Visible = true;

        //    BindCourseGrid(ddlFilterforGridSearch.SelectedIndex != 0 ? ddlFilterforGridSearch.SelectedItem.Text.Trim() : null, ddlSortforGridSearch.SelectedIndex != 0 ? ddlSortforGridSearch.SelectedValue : null);
        //    updPnlCourseList.Update();
        //}

        protected void imgBtnComments_Click(object sender, ImageClickEventArgs e)
        {

        }
        protected void btnAllcourses_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/" + WebConfigSettings.CoursesUrl);
 
        }
        void coursemodulepage_ContentChanged(object sender, ContentChangedEventArgs e)
        {
            IndexBuilderProvider indexBuilder = IndexBuilderManager.Providers["BrowseCoursesIndexBuilderProvider"];
            if (indexBuilder != null)
            {
                indexBuilder.ContentChangedHandler(sender, e);
            }
        }

    }
}