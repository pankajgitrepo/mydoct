using mojoPortal.Business;
using mojoPortal.Data;
using mojoPortal.SearchIndex;
using mojoPortal.Web.Century21_Kaltura;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using Kaltura;
using System.Configuration;
using System.Reflection;

namespace mojoPortal.Web.KalturaNotification
{
    /// <summary>
    ///KalturaEventHandler is the URL which will be hit when a Kaltura video is added, updated or deleted
    ///to process the notification and make changes to Lucene search index.
    /// </summary>
    public class KalturaEventHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            try
            {
                using (StreamReader stream = new StreamReader(context.Request.InputStream))
                {
                    //1. Read the kaltura notification
                    string data = stream.ReadToEnd();
                    string kalturaNotification = HttpUtility.UrlDecode(data);

                    //2. Create a dictionary
                    Dictionary<string, string> kalturaDict = new Dictionary<string, string>();
                    if (!string.IsNullOrEmpty(kalturaNotification))
                    {
                        foreach (var kalturaParam in kalturaNotification.Split('&'))
                        {
                            var keyvalue = kalturaParam.Split('=');
                            kalturaDict.Add(keyvalue[0], keyvalue[1]);
                        }
                    }
                    string m_exePath = @"C:\Inetpub\vhosts\c21university.com\httpdocs\QueryStringTextFile";
                    //string m_exePath = @"D:\Sandeep\Century21Portal";
                    using (StreamWriter singleLineWrite = File.AppendText(m_exePath+"\\videolog.txt"))
                    {

                        singleLineWrite.Write(Environment.NewLine);
                        singleLineWrite.Write("----------------------" + "katura video entry : " + DateTime.Now.ToString() + "----------------------" + Environment.NewLine);
                        if (!string.IsNullOrEmpty(kalturaNotification))
                        {
                            foreach (var kalturaParam in kalturaNotification.Split('&'))
                            {
                                var keyvalue = kalturaParam.Split('=');
                                //kalturaDict.Add(keyvalue[0], keyvalue[1])
                                singleLineWrite.Write(Environment.NewLine); ;
                                singleLineWrite.Write(keyvalue[0] + " = " + keyvalue[1]);

                            }
                        }
                        singleLineWrite.Write(Environment.NewLine);
                        singleLineWrite.WriteLine("----------------------" + "katura video End : " + DateTime.Now.ToString() + "----------------------" + Environment.NewLine);
                    }

                    //3. Assign values required to KalturaVideoNotification object
                    KalturaVideoNotification video = new KalturaVideoNotification();
                    video.EntryId = kalturaDict.Where(y => y.Key == "entry_id").Select(s => s.Value).FirstOrDefault();
                    video.Name = kalturaDict.Where(y => y.Key == "name").Select(s => s.Value).FirstOrDefault();
                    video.Tags = kalturaDict.Where(y => y.Key == "tags").Select(s => s.Value).FirstOrDefault();
                    string NotificationType = kalturaDict.Where(y => y.Key == "notification_type").Select(s => s.Value).FirstOrDefault();
                    video.ThumnailURL = kalturaDict.Where(y => y.Key == "thumbnail_url").Select(s => s.Value).FirstOrDefault();
                    video.Sign = kalturaDict.Where(y => y.Key == "sig").Select(s => s.Value).FirstOrDefault();
                    video.ModuleID = Convert.ToInt32(WebConfigurationManager.AppSettings["KalturaPlayVideosModuleID"]);
                    video.ContentChanged += KalturaContentChanged;
                    video.Description = GetKalturaVideoDescription(video.EntryId);
                    
                    //4.Call respective database methods 
                    switch (NotificationType)
                    {
                        case "entry_add":
                            video.CreatedBy = 1;
                            if (!video.Tags.ToLower().Contains("archive"))
                            {
                                if (CheckVideoIsInCategory(video.EntryId))
                                {
                                    if (video.Save())
                                    {
                                        SiteUtils.QueueIndexing();
                                    }
                                }
                            }
                            break;
                        case "entry_update":
                            KalturaVideoNotification dbVideo = KalturaVideoNotification.GetByKalturaVideoId(video.EntryId);
                            if (dbVideo != null)
                            {
                                video.KalturaVideoID = dbVideo.KalturaVideoID;
                                video.UpdatedBy = 1;
                            }
                            else
                            {
                                video.CreatedBy = 1;
                            }
                            if (!video.Tags.ToLower().Contains("archive"))
                            {
                                if (CheckVideoIsInCategory(video.EntryId))
                                {
                                    if (video.Save())
                                    {
                                        SiteUtils.QueueIndexing();
                                    }
                                }
                                else
                                {
                                    if (dbVideo != null)
                                    {
                                        dbVideo.ContentChanged += KalturaContentChanged;
                                        dbVideo.Delete();
                                        SiteUtils.QueueIndexing();
                                    }
                                }
                            }
                            else
                            {
                                if (dbVideo != null)
                                {
                                    dbVideo.ContentChanged += KalturaContentChanged;
                                    dbVideo.Delete();
                                    SiteUtils.QueueIndexing();
                                }
                            }
                            break;
                        case "entry_delete": KalturaVideoNotification delVideo = KalturaVideoNotification.GetByKalturaVideoId(video.EntryId);
                            if (delVideo != null)
                            {
                                delVideo.ContentChanged += KalturaContentChanged;
                                delVideo.Delete();
                                SiteUtils.QueueIndexing();
                            }
                            break;
                    }
                }

                context.Response.ContentType = "text/plain";
                context.Response.Write("Notification Saved.");
            }
            catch (Exception ex)
            {
                context.Response.ContentType = "text/plain";
                context.Response.Write(ex.Message);
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

        void KalturaContentChanged(object sender, ContentChangedEventArgs e)
        {
            IndexBuilderProvider indexBuilder = IndexBuilderManager.Providers["KalturaIndexBuilderProvider"];
            if (indexBuilder != null)
            {
                indexBuilder.ContentChangedHandler(sender, e);
            }
        }

        private int PARTNER_ID = Convert.ToInt32(ConfigurationManager.AppSettings["KalturaPartnerID"]); 
        private string SECRET = ConfigurationManager.AppSettings["KalturaAdminSecret"].ToString();
        private string ADMIN_SECRET = ConfigurationManager.AppSettings["KalturaAdminSecret"].ToString();
        private string SERVICE_URL = ConfigurationManager.AppSettings["KalturaServiceUrl"].ToString();
        private string USER_ID = ConfigurationManager.AppSettings["KalturaUserID"].ToString();

        private KalturaConfiguration GetConfig()
        {
            KalturaConfiguration config = new KalturaConfiguration(PARTNER_ID);
            config.ServiceUrl = SERVICE_URL;
            return config;
        }

        private string GetKalturaVideoDescription(string mediaID)
        {
            KalturaClient client = new KalturaClient(GetConfig());
            string ks = client.GenerateSession(ADMIN_SECRET, USER_ID, KalturaSessionType.ADMIN, PARTNER_ID, 86400, "");
            client.KS = ks;
            var result = client.MediaService.Get(mediaID);
            if (!String.IsNullOrEmpty(result.Description))
            {
                return result.Description;
            }
            return "No Description Found for this Video.";
        }

        private bool CheckVideoIsInCategory(string mediaId)
        {
            bool result = false;
            string channelFullName = ConfigurationManager.AppSettings["KalturaPrivateChannelFullName"].ToString();
            
            //Initialize & set client
            KalturaClient client = new KalturaClient(GetConfig());
            string ks = client.GenerateSession(ADMIN_SECRET, USER_ID, KalturaSessionType.ADMIN, PARTNER_ID, 86400, "");
            client.KS = ks;

            //Filter for category entry
            KalturaCategoryEntryFilter filterCatEntry = new KalturaCategoryEntryFilter();
            filterCatEntry.EntryIdEqual = mediaId;
            filterCatEntry.StatusIn = "2";
            
            // Filter for pager
            var pagerc = new KalturaFilterPager();
            pagerc.PageSize = 10;
            
            var cateEntry = client.CategoryEntryService.List(filterCatEntry, pagerc);
            //If media is part of category
            if (cateEntry.Objects.Count() > 0)
            {
                //Filter for category
                KalturaCategoryFilter filterCategory = new KalturaCategoryFilter();
                filterCategory.FullIdsEqual = cateEntry.Objects[0].CategoryFullIds;
                filterCategory.StatusIn = "2";

                //Get video category
                var videoCategory = client.CategoryService.List(filterCategory, pagerc);

                if (videoCategory.Objects[0].FullName.Contains(channelFullName))
                    result = true;
            }
            
            return result;
            
        }
    }
}