using Kaltura;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace mojoPortal.Web.Century21_Kaltura
{
    public partial class Kaltura_UploadVideo : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Page.ClientScript.RegisterClientScriptBlock(typeof(Page), "Kaltura_1", "\n<script type=\"text/javascript\" src=\"" + Page.ResolveUrl("~/ClientScript/KalturaScripts/ox.ajast.js") + "\" ></script>");
            Page.ClientScript.RegisterClientScriptBlock(typeof(Page), "Kaltura_2", "\n<script type=\"text/javascript\" src=\"" + Page.ResolveUrl("~/ClientScript/KalturaScripts/webtoolkit.md5.js") + "\" ></script>");
            Page.ClientScript.RegisterClientScriptBlock(typeof(Page), "Kaltura_3", "\n<script type=\"text/javascript\" src=\"" + Page.ResolveUrl("~/ClientScript/KalturaScripts/KalturaClientBase.js") + "\" ></script>");
            Page.ClientScript.RegisterClientScriptBlock(typeof(Page), "Kaltura_4", "\n<script type=\"text/javascript\" src=\"" + Page.ResolveUrl("~/ClientScript/KalturaScripts/KalturaTypes.js") + "\" ></script>");
            Page.ClientScript.RegisterClientScriptBlock(typeof(Page), "Kaltura_5", "\n<script type=\"text/javascript\" src=\"" + Page.ResolveUrl("~/ClientScript/KalturaScripts/KalturaVO.js") + "\" ></script>");
            Page.ClientScript.RegisterClientScriptBlock(typeof(Page), "Kaltura_6", "\n<script type=\"text/javascript\" src=\"" + Page.ResolveUrl("~/ClientScript/KalturaScripts/KalturaServices.js") + "\" ></script>");
            Page.ClientScript.RegisterClientScriptBlock(typeof(Page), "Kaltura_7", "\n<script type=\"text/javascript\" src=\"" + Page.ResolveUrl("~/ClientScript/KalturaScripts/KalturaClient.js") + "\" ></script>");
            Page.ClientScript.RegisterClientScriptBlock(typeof(Page), "Kaltura_8", "\n<script type=\"text/javascript\" src=\"" + Page.ResolveUrl("~/Scripts/js/vendor/jquery.ui.widget.js") + "\" ></script>");
            Page.ClientScript.RegisterClientScriptBlock(typeof(Page), "Kaltura_9", "\n<script type=\"text/javascript\" src=\"" + Page.ResolveUrl("~/Scripts/js/jquery.fileupload.js") + "\" ></script>");
            Page.ClientScript.RegisterClientScriptBlock(typeof(Page), "Kaltura_10", "\n<script type=\"text/javascript\" src=\"" + Page.ResolveUrl("~/Scripts/js/jquery.fileupload-kaltura.js") + "\" ></script>");

        }
        protected void btnUpload_Click(object sender, EventArgs e)
        {
            string kalturaUGCFilePath = ConfigurationManager.AppSettings["KalturaUGCFilePath"].ToString();
            try
            {
                
                if (uploader.HasFile)
                {

                    lblmsg.Text = "Upload media file";
                System.Threading.Thread.Sleep(5000);
                    //Uncomment this line to Save the uploaded file
                    uploader.SaveAs(kalturaUGCFilePath + uploader.FileName);
                    Label1.Text = "Received " + uploader.FileName + " Content Type " + uploader.PostedFile.ContentType + " Length " + uploader.PostedFile.ContentLength;

                    lblmsg.Text = "Ready to upload file to kaltura media space";
                    //Create Session
                    int partnerId = Convert.ToInt32(ConfigurationManager.AppSettings["KalturaPartnerID"].ToString());
                    string secret = ConfigurationManager.AppSettings["KalturaAdminSecret"].ToString();
                    string userId = ConfigurationManager.AppSettings["KalturaUserID"].ToString();
                    int expiry = Convert.ToInt32(ConfigurationManager.AppSettings["KalturaSessionExpiry"].ToString());

                    KalturaConfiguration config = new KalturaConfiguration(partnerId);

                    config.ServiceUrl = ConfigurationManager.AppSettings["KalturaServiceUrl"].ToString();//"https://www.kaltura.com/";// SERVICE_URL;
                    KalturaClient client = new KalturaClient(config);
                    client.KS = client.GenerateSession(secret, userId, KalturaSessionType.ADMIN, partnerId, expiry, "");

                    //Add entry
                    KalturaMediaEntry mediaEntry = new KalturaMediaEntry();
                    mediaEntry.Name = txtFriendlyName.Text; //"Media Entry Using C#";
                    mediaEntry.Description = edDescription.Text;
                    mediaEntry.MediaType = KalturaMediaType.VIDEO;
                    mediaEntry.Categories = ConfigurationManager.AppSettings["KalturaUGCCategories"].ToString();
                    mediaEntry.CategoriesIds = ConfigurationManager.AppSettings["KalturaUGCCategoriesIds"].ToString();
                    //mediaEntry.ModerationStatus = KalturaEntryModerationStatus.PENDING_MODERATION;
                    mediaEntry = client.MediaService.Add(mediaEntry);
                    
                    lblmsg.Text = "Added entry to kaltura media space";
                    //Upload token
                    FileStream fileStream = new FileStream(kalturaUGCFilePath + uploader.FileName, FileMode.Open, FileAccess.Read);
                    KalturaUploadToken uploadToken = client.UploadTokenService.Add();
                    client.UploadTokenService.Upload(uploadToken.Id, fileStream);
                    lblmsg.Text = "Update the upload token for the entry to kaltura media space";
                    //Attach Media Entry
                    KalturaUploadedFileTokenResource mediaResource = new KalturaUploadedFileTokenResource();
                    mediaResource.Token = uploadToken.Id;
                    mediaEntry = client.MediaService.AddContent(mediaEntry.Id, mediaResource);
                    
                    lblmsg.Text = "Attached media entry to kaltura media space";
                }
                else
                {
                    Label1.Text = "No uploaded file";
                }
                
            }
            catch (Exception ex)
            {
                lblmsg.Text = "There is some error while uploading media entry to kaltura media space.";
                
            }
        }
    }
}