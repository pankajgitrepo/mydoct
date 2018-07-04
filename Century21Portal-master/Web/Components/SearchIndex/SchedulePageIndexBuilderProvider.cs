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
    public class SchedulePageIndexBuilderProvider : IndexBuilderProvider
    {
        private static readonly ILog log = LogManager.GetLogger(typeof(SchedulePageIndexBuilderProvider));
        private static bool debugLog = log.IsDebugEnabled;

        public SchedulePageIndexBuilderProvider()
        { }
        public override void RebuildIndex(
           PageSettings pageSettings,
           string indexPath)
        {
            if (WebConfigSettings.DisableSearchIndex) { return; }

            if ((pageSettings == null) || (indexPath == null))
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("pageSettings object or index path passed to SchedulePageIndexBuilderProvider.RebuildIndex was null");
                }
                return;

            }

            //don't index pending/unpublished pages
            if (pageSettings.IsPending) { return; }

            log.Info("SchedulePageIndexBuilderProvider indexing page - "
                + pageSettings.PageName);

            try
            {
                List<PageModule> pageModules
                        = PageModule.GetPageModulesByPage(pageSettings.PageId);

                Guid scheduleFeatureGuid = new Guid("ca4ecf9b-22be-4be2-ac66-36e0e625dbed");
                ModuleDefinition forumFeature = new ModuleDefinition(scheduleFeatureGuid);



                List<Schedule> lstSchedules = Schedule.GetByScheduleByPage(pageSettings.SiteId, pageSettings.PageId);
                DataTable dataTable = ConvertToDatatable(lstSchedules);

                foreach (DataRow row in dataTable.Rows)
                {
                    mojoPortal.SearchIndex.IndexItem indexItem = new mojoPortal.SearchIndex.IndexItem();
                    indexItem.SiteId = pageSettings.SiteId;
                    indexItem.PageId = pageSettings.PageId;
                    indexItem.PageName = pageSettings.PageName;
                    indexItem.ViewRoles = pageSettings.AuthorizedRoles;
                    indexItem.ModuleViewRoles = pageSettings.AuthorizedRoles;
                    indexItem.ModuleViewRoles = row["ViewRoles"].ToString();
                    
                    indexItem.FeatureName = forumFeature.FeatureName;
                    indexItem.FeatureResourceFile = forumFeature.ResourceFile;

                    indexItem.ItemId = Convert.ToInt32(row["ScheduleId"]);
                    indexItem.ModuleId = Convert.ToInt32(row["ModuleId"]);
                    indexItem.ModuleTitle = "Schedule"; //row["ModuleTitle"].ToString();
                    indexItem.Title = row["Title"].ToString();
                    indexItem.Content = row["Description"].ToString();
                    indexItem.ViewPage = WebConfigSettings.ScheduleUrl;//"course-schedule";
                    

                    // lookup publish dates
                    foreach (PageModule pageModule in pageModules)
                    {
                        if (indexItem.ModuleId == pageModule.ModuleId)
                        {
                            indexItem.PublishBeginDate = pageModule.PublishBeginDate;
                            indexItem.PublishEndDate = pageModule.PublishEndDate;
                        }
                    }

                    //indexItem.PublishBeginDate = Convert.ToDateTime(row["PostDate"]);
                    //indexItem.PublishEndDate = DateTime.MaxValue;

                    mojoPortal.SearchIndex.IndexHelper.RebuildIndex(indexItem, indexPath);

                    if (debugLog) log.Debug("Indexed " + indexItem.Title);

                }
                

            }
            catch (System.Data.Common.DbException ex)
            {
                log.Error(ex);
            }

        }

        public override void ContentChangedHandler(
            object sender,
            ContentChangedEventArgs e)
        {
            if (WebConfigSettings.DisableSearchIndex) { return; }
            if (sender == null) return;
            if (!(sender is Schedule)) return;


            Schedule objSchedule = (Schedule)sender;
            SiteSettings siteSettings = CacheHelper.GetCurrentSiteSettings();
            objSchedule.SiteId = siteSettings.SiteId;
            objSchedule.SearchIndexPath = mojoPortal.SearchIndex.IndexHelper.GetSearchIndexPath(siteSettings.SiteId);

            if (e.IsDeleted)
            {
                if (ThreadPool.QueueUserWorkItem(new WaitCallback(RemoveForumIndexItem), objSchedule))
                {
                    if (debugLog) log.Debug("SchedulePageIndexBuilderProvider.RemoveForumIndexItem queued");
                }
                else
                {
                    log.Error("Failed to queue a thread for SchedulePageIndexBuilderProvider.RemoveForumIndexItem");
                }

                //RemoveForumIndexItem(forumThread);
            }
            else
            {
                if (ThreadPool.QueueUserWorkItem(new WaitCallback(IndexItem), objSchedule))
                {
                    if (debugLog) log.Debug("SchedulePageIndexBuilderProvider.IndexItem queued");
                }
                else
                {
                    log.Error("Failed to queue a thread for SchedulePageIndexBuilderProvider.IndexItem");
                }

                //IndexItem(forumThread);
            }

        }

        private static void IndexItem(object oForumThread)
        {
            if (WebConfigSettings.DisableSearchIndex) { return; }
            if (oForumThread == null) return;
            if (!(oForumThread is Schedule)) return;

            Schedule forumThread = oForumThread as Schedule;
            IndexItem(forumThread);

        }

        private static void IndexItem(Schedule scheduleThread)
        {
            if (WebConfigSettings.DisableSearchIndex) { return; }


            if (scheduleThread == null)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("forumThread object passed in SchedulePageIndexBuilderProvider.IndexItem was null");
                }
                return;

            }

            Schedule sched = new Schedule(scheduleThread.ScheduleId);
            Module module = new Module(scheduleThread.ModuleId);
            Guid scheduleFeatureGuid = new Guid("ca4ecf9b-22be-4be2-ac66-36e0e625dbed");
            ModuleDefinition forumFeature = new ModuleDefinition(scheduleFeatureGuid);

            // get list of pages where this module is published
            List<PageModule> pageModules
                = PageModule.GetPageModulesByModule(scheduleThread.ModuleId);

            // must update index for all pages containing
            // this module
            foreach (PageModule pageModule in pageModules)
            {
                PageSettings pageSettings
                    = new PageSettings(
                    scheduleThread.SiteId,
                    pageModule.PageId);

                //don't index pending/unpublished pages
                if (pageSettings.IsPending) { continue; }


                mojoPortal.SearchIndex.IndexItem indexItem = new mojoPortal.SearchIndex.IndexItem();
                if (scheduleThread.SearchIndexPath.Length > 0)
                {
                    indexItem.IndexPath = scheduleThread.SearchIndexPath;
                }
                indexItem.SiteId = scheduleThread.SiteId;
                indexItem.PageId = pageModule.PageId;
                indexItem.PageName = pageSettings.PageName;
                // permissions are kept in sync in search index
                // so that results are filtered by role correctly
                indexItem.ViewRoles = pageSettings.AuthorizedRoles;
                indexItem.ModuleViewRoles = module.ViewRoles;
                indexItem.ItemId = scheduleThread.ScheduleId;
                indexItem.ModuleId = scheduleThread.ModuleId;
                indexItem.ModuleTitle = module.ModuleTitle;
                indexItem.FeatureId = scheduleFeatureGuid.ToString();
                indexItem.FeatureName = forumFeature.FeatureName;
                indexItem.FeatureResourceFile = forumFeature.ResourceFile;
                indexItem.Title = scheduleThread.Title;

                indexItem.PublishBeginDate = pageModule.PublishBeginDate;
                indexItem.PublishEndDate = pageModule.PublishEndDate;
                indexItem.ViewPage = WebConfigSettings.CoursesUrl;

                indexItem.CreatedUtc = scheduleThread.CreatedOn;
                indexItem.LastModUtc = scheduleThread.UpdatedOn;

               
                    //older implementation

                indexItem.Content = scheduleThread.Description;


                    //indexItem.QueryStringAddendum = "&thread="
                    //    + forumThread.ThreadId.ToString()
                    //    + "&postid=" + forumThread.PostId.ToString();
                



                mojoPortal.SearchIndex.IndexHelper.RebuildIndex(indexItem);

                if (debugLog) { log.Debug("Indexed " + scheduleThread.Title); }


            }

        }

        public static void RemoveForumIndexItem(object oForumThread)
        {
            if (WebConfigSettings.DisableSearchIndex) { return; }

            if (!(oForumThread is Schedule)) return;

            Schedule forumThread = oForumThread as Schedule;

            // get list of pages where this module is published
            List<PageModule> pageModules
                = PageModule.GetPageModulesByModule(forumThread.ModuleId);

            // must update index for all pages containing
            // this module
            foreach (PageModule pageModule in pageModules)
            {
                mojoPortal.SearchIndex.IndexItem indexItem = new mojoPortal.SearchIndex.IndexItem();
                // note we are just assigning the properties 
                // needed to derive the key so it can be found and
                // deleted from the index
                indexItem.SiteId = forumThread.SiteId;
                indexItem.PageId = pageModule.PageId;
                indexItem.ModuleId = forumThread.ModuleId;
                indexItem.ItemId = forumThread.ScheduleId;

                //if (ForumConfiguration.AggregateSearchIndexPerThread)
                //{
                //    indexItem.QueryStringAddendum = "&thread=" + forumThread.ThreadId.ToInvariantString();
                //}
                //else
                //{

                //    indexItem.QueryStringAddendum = "&thread="
                //        + forumThread.ThreadId.ToInvariantString()
                //        + "&postid=" + forumThread.PostId.ToInvariantString();
                //}

                mojoPortal.SearchIndex.IndexHelper.RemoveIndex(indexItem);
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
            List<PageModule> pageModules
                = PageModule.GetPageModulesByModule(moduleId);

            // must update index for all pages containing
            // this module
            foreach (PageModule pageModule in pageModules)
            {
                mojoPortal.SearchIndex.IndexItem indexItem = new mojoPortal.SearchIndex.IndexItem();
                // note we are just assigning the properties 
                // needed to derive the key so it can be found and
                // deleted from the index
                indexItem.SiteId = siteSettings.SiteId;
                indexItem.PageId = pageModule.PageId;
                indexItem.ModuleId = moduleId;
                indexItem.ItemId = itemId;

                //if ((ForumConfiguration.AggregateSearchIndexPerThread) || (postId == -1))
                //{
                //    indexItem.QueryStringAddendum = "&thread=" + threadId.ToInvariantString();
                //}
                //else
                //{

                //    indexItem.QueryStringAddendum = "&thread="
                //        + threadId.ToInvariantString()
                //        + "&postid=" + postId.ToInvariantString();
                //}

                mojoPortal.SearchIndex.IndexHelper.RemoveIndex(indexItem);
            }

            if (debugLog) log.Debug("Removed Index ");

        }

        private DataTable ConvertToDatatable(List<Schedule> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("ScheduleId");
            dt.Columns.Add("Title");
            dt.Columns.Add("Description");
            dt.Columns.Add("InstructorNames");
            dt.Columns.Add("InstructorIds");

            dt.Columns.Add("AudienceIds");
            dt.Columns.Add("AudienceNames");
            dt.Columns.Add("CreatedBy");
            dt.Columns.Add("CreatedOn");
            dt.Columns.Add("ScheduleDate");
            dt.Columns.Add("ScheduleAccess");
            dt.Columns.Add("TuitionFee");
            dt.Columns.Add("ScheduleLength");
            dt.Columns.Add("ModuleId");
            dt.Columns.Add("ModuleTitle");
            dt.Columns.Add("ViewRoles");
            foreach (var item in list)
            {
                var row = dt.NewRow();
                row["ScheduleId"] = item.ScheduleId;
                row["Title"] = item.Title;
                row["Description"] = item.Description;
                row["InstructorNames"] = item.InstructorNames;

                row["InstructorIds"] = item.InstructorIds;

                row["AudienceIds"] = item.AudienceIds;
                row["AudienceNames"] = item.AudienceNames;
                row["CreatedBy"] = item.CreatedBy;
                row["CreatedOn"] = item.CreatedOn;
                row["ScheduleDate"] = item.ScheduleDate;
                row["ScheduleAccess"] = item.ScheduleAccess;
                row["ScheduleId"] = item.ScheduleId;
                row["TuitionFee"] = item.TuitionFee;
                row["ScheduleLength"] = item.ScheduleLength;
                row["ModuleId"] = item.ModuleId;
                row["ModuleTitle"] = "Schedule";
                row["ViewRoles"] = item.ViewRoles;
                dt.Rows.Add(row);
            }

            return dt;
        }
    }
}