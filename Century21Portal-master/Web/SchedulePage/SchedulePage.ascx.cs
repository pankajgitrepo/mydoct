using System;
using System.Collections.Generic;
using System.Globalization;
using System.Web.UI.WebControls;
using mojoPortal.Business;
using mojoPortal.Web.Framework;
using mojoPortal.SearchIndex;
using mojoPortal.Business.WebHelpers;
using System.Web;
using System.IO;
using System.Web.UI;
using iTextSharp.text;
using iTextSharp.text.html.simpleparser;
using iTextSharp.text.pdf;
using System.Drawing;

namespace mojoPortal.Web.SchedulePage
{
    public partial class SchedulePage : SiteModuleControl
    {
        public int SiteId { get; set; }
        public bool IsEditRecord { get; set; }

        public List<Schedule> Schedules
        {
            get { return (List<Schedule>) Session["ScheduleList"]; }
            set { Session["ScheduleList"] = value; }
        }

        public SchedulePage()
        {
            SiteId = SiteSettings.GetSiteIdByHostName(WebUtils.GetHostName());
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            btnAdd.Text = Resources.Resource.AddButtonText;
            
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                //Show list of schedules
                CourseModule course = new CourseModule();
                List<Audience> audience = course.LoadAudienceFromReader();
                cblAudience.DataSource = audience;
                cblAudience.DataBind();

                //cblInstructor.DataSource = SiteUser.LoadUsers(SiteId);
                //cblInstructor.DataBind();
                
                BindRepeater("ScheduleDate","asc");
                AddEditTemplate.Visible = false;
            }
            /*
            string htmlCode;
            using (WebClient client = new WebClient())
            {
                htmlCode = client.DownloadString("http://c21university.com/schedule/");
            }
            int strt = htmlCode.IndexOf("<div class=\"datagrid\">");
            int ends = htmlCode.IndexOf("\r\n   \t  \t<p style=\"margin-left:20px\">");
            string TableString = htmlCode.Substring(strt, ends - strt);
            ShcedulePageContent.InnerHtml = TableString;
             */ 
        }

        protected void rptShedule_ItemCommand(object sender, RepeaterCommandEventArgs e)
        {
            string command = e.CommandName;
            if (command == "EditSchedule")
            {
                Schedule schedule = Schedule.GetByScheduleId(Convert.ToInt32(e.CommandArgument));
                if (schedule != null)
                {
                    hdScheduleId.Value = schedule.ScheduleId.ToString(CultureInfo.InvariantCulture);
                    hdScheduleGuidId.Value = schedule.ScheduleGuid.ToString();
                    txtScheduleDate.Text = schedule.ScheduleDate.ToString("yyyy'/'MM'/'dd HH:mm");
                    txtTitle.Text = schedule.Title;
                    txtInstructor.Text = schedule.InstructorNames;
                    /*
                    if (schedule.InstructorIds.Length > 0)
                    {
                        Array instIds = schedule.InstructorIds.Split(',');
                        foreach (string item in instIds)
                        {
                            cblInstructor.Items.FindByValue(item).Selected = true;
                        }
                    }
                    */
                    txtInstructor.Text = schedule.InstructorNames;

                    if (schedule.AudienceIds.Length > 0)
                    {
                        Array audIds = schedule.AudienceIds.Split(',');
                        foreach (string item in audIds)
                        {
                            cblAudience.Items.FindByValue(item).Selected = true;
                        }
                    }
                    txtAudience.Text = schedule.AudienceNames;

                    txtTitleDescription.Text = schedule.Description;
                    txtLength.Text = schedule.ScheduleLength;
                    txtAccess.Text = schedule.ScheduleAccess;
                    txtUrl.Text = schedule.Url;
                    txtTuition.Text = @"$"+ string.Format("{0:f2}", schedule.TuitionFee);
                    chkIsActive.Checked = schedule.IsActive;
                    ListTemplate.Visible = false;
                    AddEditTemplate.Visible = true;
                }
                //schedule.ContentChanged += new ContentChangedEventHandler(schedulepage_ContentChanged);
            }
            else if (command == "DeleteSchedule")
            {
                int deleteId = Convert.ToInt32(e.CommandArgument);
                var objSchedule = new Schedule();
                if (objSchedule.Delete(deleteId))
                {
                    BindRepeater();
                }
                objSchedule.ContentChanged += schedulepage_ContentChanged;
                SiteUtils.QueueIndexing();
            }
            else
            {
                if (hdSortColumn.Value == command)
                {
                    hdSortColumn.Value = "";
                    hdSortDirection.Value = "Up#" + command;
                    BindRepeater(command, "desc");
                }
                else
                {
                    hdSortColumn.Value = command;
                    hdSortDirection.Value = "Down";
                    BindRepeater(command);
                }
            }
        }
        protected void rptScheduledownload_ItemCommand(object sender, RepeaterCommandEventArgs e)
        {
        }
        protected void btnSave_Click(object sender, EventArgs e)
        {
            int userId = SiteUtils.GetCurrentSiteUser().UserId;
            string tuitionFee = txtTuition.Text;
            tuitionFee = tuitionFee.Contains("$") ? tuitionFee.Remove(tuitionFee.IndexOf('$'), 1) : tuitionFee;
            Schedule schedule = new Schedule();
            schedule.ScheduleId = Convert.ToInt32(hdScheduleId.Value);
            schedule.ScheduleGuid = hdScheduleGuidId.Value == "-1" ? new Guid() : new Guid(hdScheduleGuidId.Value);
            schedule.ScheduleDate = Convert.ToDateTime(txtScheduleDate.Text);
            schedule.Title = txtTitle.Text;
            schedule.Description = txtTitleDescription.Text;
            //schedule.InstructorIds = hdnInstructorIds.Value;
            schedule.InstructorNames = txtInstructor.Text;
            schedule.AudienceIds = hdnAudienceIds.Value;
            schedule.AudienceNames = txtAudience.Text;
            schedule.ScheduleLength = txtLength.Text;
            schedule.ScheduleAccess = txtAccess.Text;
            schedule.Url = txtUrl.Text;
            schedule.TuitionFee = Convert.ToDecimal(tuitionFee);
            schedule.CreatedBy = userId;
            schedule.UpdatedBy = userId;
            schedule.IsActive = chkIsActive.Checked;
            schedule.ModuleId = ModuleConfiguration.ModuleId;
            //PageSettings currentPage = CacheHelper.GetCurrentPage();
            //string pageid = currentPage.PageId.ToString();
            schedule.ContentChanged += schedulepage_ContentChanged;
            if (schedule.Save())
            {
                CacheHelper.ClearModuleCache(ModuleConfiguration.ModuleId);
                SiteUtils.QueueIndexing();

                AddEditTemplate.Visible = false;
                ListTemplate.Visible = true;
                BindRepeater();
                ClearFields();
            }
            

        }

        /*
        protected void cblInstructor_SelectedIndexChanged(object sender, EventArgs e)
        {
            string name = "";
            string ids = "";
            for (int i = 0; i < cblInstructor.Items.Count; i++)
            {
                if (cblInstructor.Items[i].Selected)
                {
                    name += cblInstructor.Items[i].Text + ", ";
                    ids += cblInstructor.Items[i].Value + ",";
                }
            }
            txtInstructor.Text = name.Trim().TrimEnd(',');
            hdnInstructorIds.Value = ids.TrimEnd(',');
            updPanelInstructor.Update();
        }
        */
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


        protected void btnAdd_Click(object sender, EventArgs e)
        {
            ClearFields();
            AddEditTemplate.Visible = true;
            ListTemplate.Visible = false;
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            AddEditTemplate.Visible = false;
            ListTemplate.Visible = true;
            BindRepeater();
        }

        private void BindRepeater(string sortBy = null, string sortDirection = null)
        {
            if (Request.IsAuthenticated &&
                (SiteUtils.GetCurrentSiteUser() != null && SiteUtils.GetCurrentSiteUser().IsInRoles("Admins")))
            {
                rptSchedule.DataSource = Schedule.GetAllSchedule(sortBy, sortDirection,true);
            }
            else
            {
                rptSchedule.DataSource = Schedule.GetAllSchedule(sortBy, sortDirection);
            }
            
            rptSchedule.DataBind();

            rptScheduledownload.DataSource = Schedule.GetAllSchedule(sortBy, sortDirection);
            rptScheduledownload.DataBind();

            //grdCourseList.DataSource = Schedule.GetAllSchedule(sortBy, sortDirection);
            //grdCourseList.DataBind();
        }

        private void ClearFields()
        {
            hdScheduleId.Value ="-1";
            hdScheduleGuidId.Value = "-1";
            txtScheduleDate.Text = DateTime.UtcNow.ToString("yyyy'/'MM'/'dd HH:mm",CultureInfo.InvariantCulture);
            txtTitle.Text = string.Empty;
            txtInstructor.Text = string.Empty;
            //hdnInstructorIds.Value = string.Empty;
            //cblInstructor.ClearSelection();
            txtAudience.Text = string.Empty;
            hdnAudienceIds.Value = string.Empty;
            cblAudience.ClearSelection();
            txtTitleDescription.Text = string.Empty;
            txtLength.Text = string.Empty;
            txtAccess.Text = string.Empty;
            txtUrl.Text = string.Empty;
            txtTuition.Text = @"$0";
            chkIsActive.Checked = true;
        }

        void schedulepage_ContentChanged(object sender, ContentChangedEventArgs e)
        {
            IndexBuilderProvider indexBuilder = IndexBuilderManager.Providers["SchedulePageIndexBuilderProvider"];
            if (indexBuilder != null)
            {
                indexBuilder.ContentChangedHandler(sender, e);
            }
        }

         

        protected void btnPrint_Click(object sender, EventArgs e)
        {
            Response.ContentType = "application/pdf";
            Response.AddHeader("content-disposition",
                "attachment;filename=CourseSchedule.pdf");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            StringWriter sw = new StringWriter();
            HtmlTextWriter hw = new HtmlTextWriter(sw);

            Repeater repAllCustomers = this.rptScheduledownload;
            repAllCustomers.DataSource = Schedule.GetAllSchedule(null, null);
            repAllCustomers.DataBind();
            var lstSchedule = Schedule.GetAllSchedule(null, null);
            //repAllCustomers.RenderControl(hw);

            //this.Page.RenderControl(hw);         
            //this.rptScheduledownload.RenderControl(hw);
            //this.grdCourseList.RenderControl(hw);

            StringReader sr = new StringReader
                (sw.ToString().Replace("\r", "")
                .Replace("\n", "").Replace("  ", ""));

            Document pdfDoc =
                new Document(iTextSharp.text.PageSize.A4,
                             3f, 3f, 3f, 0.0f);

            PdfPTable table = new PdfPTable(8);
            //table.TotalWidth = 100;
            table.WidthPercentage = 100;
            table.HeaderRows = 1;
            table.HorizontalAlignment = 0;
            //leave a gap before and after the table
            table.SpacingBefore = 20f;
            table.SpacingAfter = 30f;
            float[] widths = new float[] { 200f, 250f, 350f, 180f, 200f, 150f, 120f, 150f };
            table.SetWidths(widths);
            PdfPCell cell = new PdfPCell(new Phrase("C21 University Course Schedule", new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 14f, iTextSharp.text.Font.UNDERLINE, iTextSharp.text.BaseColor.BLACK)));
            cell.HorizontalAlignment = 1; //0=Left, 1=Centre, 2=Right
            cell.Colspan = 8;
            cell.Border = 0;
            cell.PaddingBottom = 20f;
            table.AddCell(cell);
            
            //Set Table header 
            cell = new PdfPCell(new Phrase("Date /Time (EST)", new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 8f, iTextSharp.text.Font.BOLD, iTextSharp.text.BaseColor.BLACK)));
            cell.HorizontalAlignment = 0; //0=Left, 1=Centre, 2=Right
            cell.BackgroundColor = BaseColor.LIGHT_GRAY;
            table.AddCell(cell);
            
            cell = new PdfPCell(new Phrase("Title", new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 8f, iTextSharp.text.Font.BOLD, iTextSharp.text.BaseColor.BLACK)));
            cell.BackgroundColor = BaseColor.LIGHT_GRAY;
            cell.HorizontalAlignment = 0; //0=Left, 1=Centre, 2=Right
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("Description", new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 8f, iTextSharp.text.Font.BOLD, iTextSharp.text.BaseColor.BLACK)));
            cell.BackgroundColor = BaseColor.LIGHT_GRAY;
            cell.HorizontalAlignment = 0; //0=Left, 1=Centre, 2=Right
            table.AddCell(cell);
            
            cell = new PdfPCell(new Phrase("Instructor", new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 8f, iTextSharp.text.Font.BOLD, iTextSharp.text.BaseColor.BLACK)));
            cell.HorizontalAlignment = 0; //0=Left, 1=Centre, 2=Right
            cell.BackgroundColor = BaseColor.LIGHT_GRAY;
            table.AddCell(cell);
            
            cell = new PdfPCell(new Phrase("Audience", new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 8f, iTextSharp.text.Font.BOLD, iTextSharp.text.BaseColor.BLACK)));
            cell.BackgroundColor = BaseColor.LIGHT_GRAY;
            cell.HorizontalAlignment = 0; //0=Left, 1=Centre, 2=Right
            table.AddCell(cell);
            
            cell = new PdfPCell(new Phrase("Length", new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 8f, iTextSharp.text.Font.BOLD, iTextSharp.text.BaseColor.BLACK)));
            cell.BackgroundColor = BaseColor.LIGHT_GRAY;
            cell.HorizontalAlignment = 0; //0=Left, 1=Centre, 2=Right
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("Access", new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 8f, iTextSharp.text.Font.BOLD, iTextSharp.text.BaseColor.BLACK)));
            cell.BackgroundColor = BaseColor.LIGHT_GRAY;
            cell.HorizontalAlignment = 0; //0=Left, 1=Centre, 2=Right
            table.AddCell(cell);

            cell = new PdfPCell(new Phrase("Tuition", new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 8f, iTextSharp.text.Font.BOLD, iTextSharp.text.BaseColor.BLACK)));
            cell.BackgroundColor = BaseColor.LIGHT_GRAY;
            cell.HorizontalAlignment = 0; //0=Left, 1=Centre, 2=Right
            table.AddCell(cell);
            foreach (var sched in lstSchedule)
            {
                cell = new PdfPCell(new Phrase(string.Format("{0:ddd MM'/'dd'/'yyyy @hh:mmtt}", sched.ScheduleDate), new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 7f, iTextSharp.text.Font.NORMAL, iTextSharp.text.BaseColor.BLACK)));
                cell.HorizontalAlignment = 0; //0=Left, 1=Centre, 2=Right
                table.AddCell(cell);
                
                cell = new PdfPCell(new Phrase(sched.Title, new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 7f, iTextSharp.text.Font.NORMAL, iTextSharp.text.BaseColor.BLACK)));
                cell.HorizontalAlignment = 0; //0=Left, 1=Centre, 2=Right
                table.AddCell(cell);

                cell = new PdfPCell(new Phrase(sched.Description, new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 7f, iTextSharp.text.Font.NORMAL, iTextSharp.text.BaseColor.BLACK)));
                cell.HorizontalAlignment = 0; //0=Left, 1=Centre, 2=Right
                table.AddCell(cell);
                
                cell = new PdfPCell(new Phrase(sched.InstructorNames, new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 7f, iTextSharp.text.Font.NORMAL, iTextSharp.text.BaseColor.BLACK)));
                cell.HorizontalAlignment = 0; //0=Left, 1=Centre, 2=Right
                table.AddCell(cell);
                
                cell = new PdfPCell(new Phrase(sched.AudienceNames, new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 7f, iTextSharp.text.Font.NORMAL, iTextSharp.text.BaseColor.BLACK)));
                cell.HorizontalAlignment = 0; //0=Left, 1=Centre, 2=Right
                table.AddCell(cell);
                
                cell = new PdfPCell(new Phrase(sched.ScheduleLength, new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 7f, iTextSharp.text.Font.NORMAL, iTextSharp.text.BaseColor.BLACK)));
                cell.HorizontalAlignment = 0; //0=Left, 1=Centre, 2=Right
                table.AddCell(cell);

                
                
                cell = new PdfPCell(new Phrase(sched.ScheduleAccess, new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 7f, iTextSharp.text.Font.NORMAL, iTextSharp.text.BaseColor.BLACK)));
                cell.HorizontalAlignment = 0; //0=Left, 1=Centre, 2=Right
                if (!string.IsNullOrEmpty(sched.Url))
                {
                    var c = new Chunk(sched.ScheduleAccess, new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 7f, iTextSharp.text.Font.NORMAL, iTextSharp.text.BaseColor.BLACK));
                    c.SetAnchor(sched.Url);
                    cell.AddElement(c);
                }
                table.AddCell(cell);

                cell = new PdfPCell(new Phrase(string.Format("{0:f2}", sched.TuitionFee), new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 7f, iTextSharp.text.Font.NORMAL, iTextSharp.text.BaseColor.BLACK)));
                cell.HorizontalAlignment = 2; //0=Left, 1=Centre, 2=Right
                table.AddCell(cell);
            }
            

            HTMLWorker htmlparser = new HTMLWorker(pdfDoc);
            PdfWriter.GetInstance(pdfDoc, Response.OutputStream);
            pdfDoc.Open();
            pdfDoc.Add(table);
            htmlparser.Parse(sr);
            pdfDoc.Close();
            Response.Write(pdfDoc);
            Response.End();
            

        }

        //public void DownloadAsPDF()
        //{
        //    try
        //    {
        //        string strHtml = string.Empty;
        //        string pdfFileName = Request.PhysicalApplicationPath + "\\files\\" + "GenerateHTMLTOPDF.pdf";

        //        StringWriter sw = new StringWriter();
        //        HtmlTextWriter hw = new HtmlTextWriter(sw);
        //        dvHtml.RenderControl(hw);
        //        StringReader sr = new StringReader(sw.ToString());
        //        strHtml = sr.ReadToEnd();
        //        sr.Close();

        //        CreatePDFFromHTMLFile(strHtml, pdfFileName);

        //        Response.ContentType = "application/x-download";
        //        Response.AddHeader("Content-Disposition", string.Format("attachment; filename=\"{0}\"", "GenerateHTMLTOPDF.pdf"));
        //        Response.WriteFile(pdfFileName);
        //        Response.Flush();
        //        Response.End();
        //    }
        //    catch (Exception ex)
        //    {
        //        Response.Write(ex.Message);
        //    }
        //}

        //public void CreatePDFFromHTMLFile(string HtmlStream, string FileName)
        //{
        //    try
        //    {
        //        object TargetFile = FileName;
        //        string ModifiedFileName = string.Empty;
        //        string FinalFileName = string.Empty;


        //        GeneratePDF.HtmlToPdfBuilder builder = new GeneratePDF.HtmlToPdfBuilder(iTextSharp.text.PageSize.A4);
        //        GeneratePDF.HtmlPdfPage first = builder.AddPage();
        //        first.AppendHtml(HtmlStream);
        //        byte[] file = builder.RenderPdf();
        //        File.WriteAllBytes(TargetFile.ToString(), file);

        //        iTextSharp.text.pdf.PdfReader reader = new iTextSharp.text.pdf.PdfReader(TargetFile.ToString());
        //        ModifiedFileName = TargetFile.ToString();
        //        ModifiedFileName = ModifiedFileName.Insert(ModifiedFileName.Length - 4, "1");

        //        iTextSharp.text.pdf.PdfEncryptor.Encrypt(reader, new FileStream(ModifiedFileName, FileMode.Append), iTextSharp.text.pdf.PdfWriter.STRENGTH128BITS, "", "", iTextSharp.text.pdf.PdfWriter.AllowPrinting);
        //        reader.Close();
        //        if (File.Exists(TargetFile.ToString()))
        //            File.Delete(TargetFile.ToString());
        //        FinalFileName = ModifiedFileName.Remove(ModifiedFileName.Length - 5, 1);
        //        File.Copy(ModifiedFileName, FinalFileName);
        //        if (File.Exists(ModifiedFileName))
        //            File.Delete(ModifiedFileName);

        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //}
    }
}