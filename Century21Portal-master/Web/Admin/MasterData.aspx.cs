using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using log4net;
using mojoPortal.Business;
using mojoPortal.Business.WebHelpers;
using mojoPortal.Web.Framework;
using Resources;
using System.Data;

namespace mojoPortal.Web.AdminUI
{
    public partial class MasterData : NonCmsBasePage
    {
        private string sortParam;
        private String sort = "ModuleTitle";
        private int pageNumber = 1;
        private int pageSize = WebConfigSettings.MasterDataPageSize;
        private int totalPages = 0;

        private bool sortByFeature = false;
        private bool sortByAuthor = false;
        private string skinBaseUrl;
        private bool isContentAdmin = false;
        private bool isAdmin = false;
        private bool isSiteEditor = false;
        private int moduleDefId = -1;
        private string title = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            LoadSettings();
            if ((!isContentAdmin) && (!isSiteEditor))
            {
                SiteUtils.RedirectToEditAccessDeniedPage();
                return;
            }

            if (SiteUtils.IsFishyPost(this))
            {
                SiteUtils.RedirectToAccessDeniedPage(this);
                return;
            }
            if ((!Page.IsPostBack) && (!Page.IsCallback))
            {
                PopulateLabels();
                PopulateControls();
            }
        }
        protected void Page_PreRender(object sender, EventArgs e)
        {
            BindGrid();
        }
        private void PopulateControls()
        {
            //if (Page.IsPostBack) return;

            BindFeatureList();
            BindGrid();

            if (moduleDefId > -1)
            {
                //chkFilterByFeature.Checked = true;
                ListItem item = ddModuleType.Items.FindByValue(moduleDefId.ToInvariantString());
                if (item != null)
                {
                    ddModuleType.ClearSelection();
                    item.Selected = true;
                }
            }
            //txtTitleFilter.Text = title;

        }

        private void BindGrid()
        {

            //DataTable dt = Module.SelectPage(
            //    siteSettings.SiteId,
            //    moduleDefId,
            //    title,
            //    pageNumber,
            //    pageSize,
            //    sortByFeature,
            //    sortByAuthor,
            //    out totalPages);

            //string pageUrl = SiteRoot + "/Admin/ContentCatalog.aspx"
            //    + "?md=" + moduleDefId.ToInvariantString()
            //    + "&amp;title=" + Server.UrlEncode(title)
            //    + "&amp;sort=" + this.sort
            //    + "&amp;pagenumber={0}";

            //pgrContent.PageURLFormat = pageUrl;
            //pgrContent.ShowFirstLast = true;
            //pgrContent.CurrentIndex = pageNumber;
            //pgrContent.PageSize = pageSize;
            //pgrContent.PageCount = totalPages;
            //pgrContent.Visible = (totalPages > 1);

            //grdContent.DataSource = dt;
            //grdContent.DataBind();
            int moduleType = Convert.ToInt32( ddModuleType.SelectedItem.Value);
            DataTable dt = MasterDatas.SelectType(moduleType,
                pageNumber,
            pageSize,
            out totalPages);
            //pgrContent.PageURLFormat = pageUrl;
            pgrContent.ShowFirstLast = true;
            pgrContent.CurrentIndex = pageNumber;
            pgrContent.PageSize = pageSize;
            pgrContent.PageCount = totalPages;
            pgrContent.Visible = (totalPages > 1);
            grdContent.DataSource = dt;
            grdContent.DataBind();
            ddModuleType.Enabled = true;
        }

        private void BindFeatureList()
        {

            ListItem lstItem;
            lstItem = new ListItem("Lead Instructor", "1");
            ddModuleType.Items.Add(lstItem);
            lstItem = new ListItem("Course Length", "2");
            ddModuleType.Items.Add(lstItem);
            lstItem = new ListItem("Link Name", "3");
            ddModuleType.Items.Add(lstItem);
            btnCreateNewContent.Enabled = (ddModuleType.Items.Count > 0);

        }

        private void PopulateLabels()
        {
            Title = SiteUtils.FormatPageTitle(siteSettings, Resource.AdminMenuContentManagerLink);
            heading.Text = Resource.AdminMenuMasterDataLink;

            lnkAdminMenu.Text = Resource.AdminMenuLink;
            lnkAdminMenu.ToolTip = Resource.AdminMenuLink;
            lnkAdminMenu.NavigateUrl = SiteRoot + "/Admin/AdminMenu.aspx";

            lnkMasterDataManager.Text = Resource.AdminMenuMasterDataLink;
            lnkMasterDataManager.ToolTip = Resource.AdminMenuMasterDataLink;
            lnkMasterDataManager.NavigateUrl = SiteRoot + "/Admin/MasterData.aspx";

            lblTitle.Text = Resource.MasterDataTitleColumnHeader; 
            this.grdContent.Columns[0].HeaderText = "Id";
            this.grdContent.Columns[1].HeaderText = Resource.MasterDataTitleColumnHeader; 
            //this.grdContent.Columns[2].HeaderText = Resource.ContentManagerAuthorColumnHeader;

            this.btnCreateNewContent.Text = Resource.MasterDataCreateNew;
            SiteUtils.SetButtonAccessKey
                (btnCreateNewContent, AccessKeys.ContentManagerCreateNewContentButtonAccessKey);

            //viewEditText = Resource.ContentManagerViewEditLabel;
            //publishingText = Resource.ContentManagerPublishDeleteLabel;
            if (!Page.IsPostBack)
            {
                if (WebConfigSettings.PrePopulateDefaultContentTitle)
                {
                    txtModuleTitle.Text = Resource.PageLayoutDefaultNewTitleName;
                }
            }

            //chkFilterByFeature.Text = Resource.ContentManagerFilterByFeature;
            //btnFind.Text = Resource.ContentManagerFindButton;

            reqModuleTitle.ErrorMessage = Resource.TitleRequiredWarning;
            reqModuleTitle.Enabled = WebConfigSettings.RequireContentTitle;

            cvModuleTitle.ValueToCompare = Resource.PageLayoutDefaultNewModuleName;
            cvModuleTitle.ErrorMessage = Resource.DefaultContentTitleWarning;
            cvModuleTitle.Enabled = WebConfigSettings.RequireChangeDefaultContentTitle;

        }
        private void LoadSettings()
        {
            isSiteEditor = SiteUtils.UserIsSiteEditor();
            isContentAdmin = WebUser.IsAdminOrContentAdmin;
            isAdmin = WebUser.IsAdmin;
            skinBaseUrl = SiteUtils.GetSkinBaseUrl(this);
            pageNumber = WebUtils.ParseInt32FromQueryString("pagenumber", 1);
            moduleDefId = WebUtils.ParseInt32FromQueryString("md", moduleDefId);

            AddClassToBody("administration");
            AddClassToBody("cmadmin");

            if (Request.QueryString["title"] != null)
            {
                title = Request.QueryString["title"];
            }

            sortParam = "sort";

            if (Page.Request.Params[sortParam] != null)
            {
                sort = Page.Request.Params[sortParam];
                switch (sort)
                {


                    case "FeatureName":
                        this.sortByFeature = true;
                        this.sortByAuthor = false;
                        break;

                    case "CreatedBy":
                        this.sortByFeature = false;
                        this.sortByAuthor = true;

                        break;

                    case "ModuleTitle":
                    default:
                        this.sortByFeature = false;
                        this.sortByAuthor = false;
                        sort = "ModuleTitle";

                        break;

                }
            }

        }

        #region OnInit

        protected override void OnPreInit(EventArgs e)
        {
            AllowSkinOverride = true;
            base.OnPreInit(e);
            
        }
        override protected void OnInit(EventArgs e)
        {
            base.OnInit(e);
            this.Load += new EventHandler(this.Page_Load);
            ScriptConfig.IncludeJQTable = true;
            btnCreateNewContent.Click += new EventHandler(btnCreateNewContent_Click);
            
            grdContent.RowCommand += new System.Web.UI.WebControls.GridViewCommandEventHandler(GrdContent_RowCommand);
            grdContent.RowEditing += new GridViewEditEventHandler(GrdContent_RowEditing);
            
            SuppressMenuSelection();
            SuppressPageMenu();

            

        }


        #endregion

        void GrdContent_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string command = e.CommandName;
            if (command == "EditMasterData")
            {
                
                int iIndex = Convert.ToInt32(e.CommandArgument);
                GridViewRow gvRow = grdContent.Rows[iIndex];
                //var title = Server.HtmlDecode(gvRow.Cells[1].Text);
                
                masterDataId.Value = Server.HtmlDecode(gvRow.Cells[0].Text);
                txtModuleTitle.Text = Server.HtmlDecode(gvRow.Cells[1].Text);
                btnCreateNewContent.Visible = false;
                pnlNewContent.Visible = true;
                pnlContent.Visible = false;
                ddModuleType.Enabled = false;
            }
            else if (command == "DeleteMasterData")
            {
                int iIndex = Convert.ToInt32(e.CommandArgument);
                GridViewRow gvRow = grdContent.Rows[iIndex];

                MasterDatas objMasterData = new MasterDatas();
                objMasterData.ModuleType = Convert.ToInt32(ddModuleType.SelectedValue);
                objMasterData.Delete(Convert.ToInt32(Server.HtmlDecode(gvRow.Cells[0].Text)));
                BindGrid();
            }
        }


        void GrdContent_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GridView grid = (GridView)sender;
            grid.EditIndex = e.NewEditIndex;
        }
        protected void btnCreateNewContent_Click(object sender, EventArgs e)
        {
            btnCreateNewContent.Visible = false;
            pnlNewContent.Visible = true;
            pnlContent.Visible = false;
            masterDataId.Value = "";
        }

        protected void ddModuleType_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindGrid();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            int userId = SiteUtils.GetCurrentSiteUser().UserId;
            btnCreateNewContent.Visible = true;
            pnlNewContent.Visible = false;
            pnlContent.Visible = true;
            MasterDatas objMasterData = new MasterDatas();
            if (string.IsNullOrEmpty(masterDataId.Value))
            {
                objMasterData.Id = -1;
            }
            else
            {
                objMasterData.Id = Convert.ToInt32(masterDataId.Value);
            }
            objMasterData.Title = txtModuleTitle.Text;
            objMasterData.ModuleType = Convert.ToInt32(ddModuleType.SelectedValue);
            objMasterData.CreatedBy = userId;
            objMasterData.Save();
            BindGrid();
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            //AddEditTemplate.Visible = false;
            //ListTemplate.Visible = true;
            btnCreateNewContent.Visible = true;
            pnlNewContent.Visible = false;
            pnlContent.Visible = true;
            ddModuleType.Enabled = true;
            //BindRepeater();
        }
    }
}