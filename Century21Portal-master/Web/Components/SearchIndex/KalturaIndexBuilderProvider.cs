using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Threading;
using log4net;
using mojoPortal.Business;
using mojoPortal.Business.WebHelpers;
using mojoPortal.SearchIndex;
using mojoPortal.Web;
using mojoPortal.Web.Framework;
using System.Data;
using System.Configuration;
using Resources;
using System.Globalization;
using System.Text;
namespace mojoPortal.SearchIndex
{
    public class KalturaIndexBuilderProvider : IndexBuilderProvider
    {
        private static readonly ILog log = LogManager.GetLogger(typeof(KalturaIndexBuilderProvider));
        private static bool debugLog = log.IsDebugEnabled;

        public KalturaIndexBuilderProvider()
        { }


        public override void RebuildIndex(PageSettings pageSettings, string indexPath)
        {
            if (WebConfigSettings.DisableSearchIndex) { return; }

            if ((pageSettings == null) || (indexPath == null))
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("pageSettings object or index path passed to KalturaIndexBuilderProvider.RebuildIndex was null");
                }
                return;

            }

            //don't index pending/unpublished pages
            if (pageSettings.IsPending) { return; }

            log.Info("KalturaIndexBuilderProvider indexing page - " + pageSettings.PageName);

            try
            {
                List<PageModule> pageModules = PageModule.GetPageModulesByPage(pageSettings.PageId);

                //1. Get Century21_Kaltura_PlayVideos data from mp_ModuleDefinitions table using GUID
                Guid kalturaVideoGuid = new Guid("40C79626-E229-4CBA-B9B1-52745734FE44");
                ModuleDefinition forumFeature = new ModuleDefinition(kalturaVideoGuid);
                //2. Get all Kaltura videos which are saved in Usr_TblKalturaVideo table
                List<KalturaVideoNotification> lstVideos = KalturaVideoNotification.GetKalturaVideoByPage(pageSettings.SiteId, pageSettings.PageId);
                foreach (KalturaVideoNotification video in lstVideos)
                {
                    IndexItem indexItem = new IndexItem();
                    indexItem.SiteId = pageSettings.SiteId;
                    indexItem.PageId = pageSettings.PageId;
                    indexItem.PageName = pageSettings.PageName;
                    indexItem.ViewRoles = pageSettings.AuthorizedRoles;
                    indexItem.ModuleViewRoles = video.ViewRoles;

                    indexItem.FeatureName = forumFeature.FeatureName;
                    indexItem.FeatureResourceFile = forumFeature.ResourceFile;

                    indexItem.ItemId = video.KalturaVideoID;
                    indexItem.ModuleId = video.ModuleID;
                    indexItem.ModuleTitle = "Play Videos";
                    indexItem.Title = video.Name;
                    indexItem.Content = video.Description +" --&gt; "+video.Tags;
                    indexItem.OtherContent = video.ThumnailURL;
                    indexItem.ViewPage = "/play-video?mediaId=" + video.EntryId;
                   
                    var pageModule = pageModules.Where(p => p.ModuleId == indexItem.ModuleId).FirstOrDefault();
                    if (pageModule != null)
                    {
                        indexItem.PublishBeginDate = pageModule.PublishBeginDate;
                        indexItem.PublishEndDate = pageModule.PublishEndDate;
                    }

                    IndexHelper.RebuildIndex(indexItem, indexPath);
                    if (debugLog)
                        log.Debug("Indexed " + indexItem.Title);
                }
            }
            catch (System.Data.Common.DbException ex)
            {
                log.Error(ex);
            }
        }

        public override void ContentChangedHandler(object sender, ContentChangedEventArgs e)
        {
            if (WebConfigSettings.DisableSearchIndex) { return; }
            if (sender == null) return;
            if (!(sender is KalturaVideoNotification)) return;


            KalturaVideoNotification objVideo = (KalturaVideoNotification)sender;
            SiteSettings siteSettings = CacheHelper.GetCurrentSiteSettings();
            objVideo.SiteId = siteSettings.SiteId;
            objVideo.SearchIndexPath = mojoPortal.SearchIndex.IndexHelper.GetSearchIndexPath(siteSettings.SiteId);

            if (e.IsDeleted)
            {
                if (ThreadPool.QueueUserWorkItem(new WaitCallback(RemoveForumIndexItem), objVideo))
                {
                    if (debugLog) log.Debug("KalturaIndexBuilderProvider.RemoveForumIndexItem queued");
                }
                else
                {
                    log.Error("Failed to queue a thread for KalturaIndexBuilderProvider.RemoveForumIndexItem");
                }
            }
            else
            {
                if (ThreadPool.QueueUserWorkItem(new WaitCallback(IndexItem), objVideo))
                {
                    if (debugLog) log.Debug("KalturaIndexBuilderProvider.IndexItem queued");
                }
                else
                {
                    log.Error("Failed to queue a thread for KalturaIndexBuilderProvider.IndexItem");
                }
            }

        }

        //To Do remove repeated code 
        private static void IndexItem(object video)
        {
            if (WebConfigSettings.DisableSearchIndex) { return; }
            if (video == null) return;
            if (!(video is KalturaVideoNotification)) return;

            KalturaVideoNotification kalturaVideo = video as KalturaVideoNotification;
            IndexItem(kalturaVideo);
        }

        private static void IndexItem(KalturaVideoNotification video)
        {
            if (WebConfigSettings.DisableSearchIndex) { return; }

            if (video == null)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("forumThread object passed in KalturaIndexBuilderProvider.IndexItem was null");
                }
                return;

            }

            Module module = new Module(video.ModuleID);
            Guid FeatureGuid = new Guid("40C79626-E229-4CBA-B9B1-52745734FE44");
            ModuleDefinition forumFeature = new ModuleDefinition(FeatureGuid);

            // get list of pages where this module is published
            List<PageModule> pageModules = PageModule.GetPageModulesByModule(video.ModuleID);

            // must update index for all pages contained in this module
            foreach (PageModule pageModule in pageModules)
            {
                PageSettings pageSettings = new PageSettings(video.SiteId, pageModule.PageId);
                if (pageSettings.IsPending) { continue; }

                IndexItem indexItem = new IndexItem();
                if (video.SearchIndexPath.Length > 0)
                {
                    indexItem.IndexPath = video.SearchIndexPath;
                }
                indexItem.SiteId = video.SiteId;
                indexItem.PageId = pageModule.PageId;
                indexItem.PageName = pageSettings.PageName;

                indexItem.ViewRoles = pageSettings.AuthorizedRoles;
                indexItem.ModuleViewRoles = module.ViewRoles;
                indexItem.ModuleId = video.ModuleID;
                indexItem.ModuleTitle = module.ModuleTitle;
                indexItem.FeatureId = FeatureGuid.ToString();
                indexItem.FeatureName = forumFeature.FeatureName;
                indexItem.FeatureResourceFile = forumFeature.ResourceFile;

                indexItem.ItemId = video.KalturaVideoID;
                indexItem.Title = video.Name;
                indexItem.Content = video.Description + " --&gt; " + video.Tags;
                indexItem.OtherContent = video.ThumnailURL;
                indexItem.ViewPage = "/play-video?mediaId=" + video.EntryId;

                indexItem.PublishBeginDate = pageModule.PublishBeginDate;
                indexItem.PublishEndDate = pageModule.PublishEndDate;
    
                IndexHelper.RebuildIndex(indexItem);

                if (debugLog)
                {
                    log.Debug("Indexed " + video.Name);
                }
                
            }

        }

        public static void RemoveForumIndexItem(object oForumThread)
        {
            if (WebConfigSettings.DisableSearchIndex) { return; }

            if (!(oForumThread is KalturaVideoNotification)) return;

            KalturaVideoNotification forumThread = oForumThread as KalturaVideoNotification;
            // get list of pages where this module is published
            List<PageModule> pageModules = PageModule.GetPageModulesByModule(forumThread.ModuleID);

            // must update index for all pages containing this module
            foreach (PageModule pageModule in pageModules)
            {
                IndexItem indexItem = new IndexItem();
                // note we are just assigning the properties needed to derive the key so it can be found and deleted from the index
                indexItem.SiteId = forumThread.SiteId;
                indexItem.PageId = pageModule.PageId;
                indexItem.ModuleId = forumThread.ModuleID;
                indexItem.ItemId = forumThread.KalturaVideoID;
                IndexHelper.RemoveIndex(indexItem);
            }
            if (debugLog) { log.Debug("Removed Index "); }
        }

        public static void RemoveForumIndexItem(
            int moduleId,
            int itemId,
            int threadId,
            int postId)
        {
            if (WebConfigSettings.DisableSearchIndex) { return; }

            SiteSettings siteSettings = CacheHelper.GetCurrentSiteSettings();
            if (siteSettings == null)
            {
                log.Error("siteSettings object retrieved in ForumThreadIndexBuilderProvider.RemoveForumIndexItem was null");
                return;
            }

            // get list of pages where this module is published
            List<PageModule> pageModules = PageModule.GetPageModulesByModule(moduleId);

            // must update index for all pages containing this module
            foreach (PageModule pageModule in pageModules)
            {
                mojoPortal.SearchIndex.IndexItem indexItem = new mojoPortal.SearchIndex.IndexItem();
                // note we are just assigning the properties needed to derive the key so it can be found and deleted from the index
                indexItem.SiteId = siteSettings.SiteId;
                indexItem.PageId = pageModule.PageId;
                indexItem.ModuleId = moduleId;
                indexItem.ItemId = itemId;
                IndexHelper.RemoveIndex(indexItem);
            }

            if (debugLog) log.Debug("Removed Index ");
        }
    }
}