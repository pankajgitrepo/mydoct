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
    public class BrowseCoursesIndexBuilderProvider: IndexBuilderProvider
    {
        private static readonly ILog log = LogManager.GetLogger(typeof(BrowseCoursesIndexBuilderProvider));
        private static bool debugLog = log.IsDebugEnabled;

        public BrowseCoursesIndexBuilderProvider()
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
                    log.Error("pageSettings object or index path passed to BrowseCoursesIndexBuilderProvider.RebuildIndex was null");
                }
                return;

            }

            //don't index pending/unpublished pages
            if (pageSettings.IsPending) { return; }

            log.Info("BrowseCoursesIndexBuilderProvider indexing page - "
                + pageSettings.PageName);

            try
            {
                List<PageModule> pageModules
                        = PageModule.GetPageModulesByPage(pageSettings.PageId);

                Guid scheduleFeatureGuid = new Guid("dc873d76-5bf2-4ac5-bff7-434a86a3fc9e");
                ModuleDefinition forumFeature = new ModuleDefinition(scheduleFeatureGuid);



                List<CourseModule> lstSchedules = CourseModule.GetCoursesByPage(pageSettings.SiteId, pageSettings.PageId);
                DataTable dataTable = ConvertToDatatable(lstSchedules);

                foreach (DataRow row in dataTable.Rows)
                {
                    mojoPortal.SearchIndex.IndexItem indexItem = new mojoPortal.SearchIndex.IndexItem();
                    indexItem.SiteId = pageSettings.SiteId;
                    indexItem.PageId = pageSettings.PageId;
                    indexItem.PageName = pageSettings.PageName;
                    indexItem.ViewRoles = pageSettings.AuthorizedRoles;
                    indexItem.ModuleViewRoles = row["ViewRoles"].ToString();
                    indexItem.FeatureId = scheduleFeatureGuid.ToString();
                    indexItem.FeatureName = forumFeature.FeatureName;
                    indexItem.FeatureResourceFile = forumFeature.ResourceFile;

                    indexItem.ItemId = Convert.ToInt32(row["CourseID"]);
                    indexItem.ModuleId = Convert.ToInt32(row["ModuleId"]);
                    indexItem.ModuleTitle = row["ModuleTitle"].ToString();
                    indexItem.Title = row["CourseName"].ToString();
                    indexItem.Content = row["Description"].ToString() + " " + row["Metatags"].ToString() + " " + row["LeadInstructor"].ToString();
                    indexItem.ViewPage = WebConfigSettings.CourseSearchUrl; //"browse-course";


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
            if (!(sender is CourseModule)) return;


            CourseModule objSchedule = (CourseModule)sender;
            SiteSettings siteSettings = CacheHelper.GetCurrentSiteSettings();
            objSchedule.SiteId = siteSettings.SiteId;
            objSchedule.SearchIndexPath = mojoPortal.SearchIndex.IndexHelper.GetSearchIndexPath(siteSettings.SiteId);

            if (e.IsDeleted)
            {
                if (ThreadPool.QueueUserWorkItem(new WaitCallback(RemoveForumIndexItem), objSchedule))
                {
                    if (debugLog) log.Debug("BrowseCoursesIndexBuilderProvider.RemoveForumIndexItem queued");
                }
                else
                {
                    log.Error("Failed to queue a thread for BrowseCoursesIndexBuilderProvider.RemoveForumIndexItem");
                }

                //RemoveForumIndexItem(forumThread);
            }
            else
            {
                if (ThreadPool.QueueUserWorkItem(new WaitCallback(IndexItem), objSchedule))
                {
                    if (debugLog) log.Debug("BrowseCoursesIndexBuilderProvider.IndexItem queued");
                }
                else
                {
                    log.Error("Failed to queue a thread for BrowseCoursesIndexBuilderProvider.IndexItem");
                }

                //IndexItem(forumThread);
            }

        }

        private static void IndexItem(object oForumThread)
        {
            if (WebConfigSettings.DisableSearchIndex) { return; }
            if (oForumThread == null) return;
            if (!(oForumThread is CourseModule)) return;

            CourseModule forumThread = oForumThread as CourseModule;
            IndexItem(forumThread);

        }

        private static void IndexItem(CourseModule courseModule)
        {
            if (WebConfigSettings.DisableSearchIndex) { return; }


            if (courseModule == null)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("forumThread object passed in BrowseCoursesIndexBuilderProvider.IndexItem was null");
                }
                return;

            }

            CourseModule courMod = new CourseModule(courseModule.CourseId);
            Module module = new Module(courseModule.ModuleId);
            Guid scheduleFeatureGuid = new Guid("dc873d76-5bf2-4ac5-bff7-434a86a3fc9e");
            ModuleDefinition forumFeature = new ModuleDefinition(scheduleFeatureGuid);

            // get list of pages where this module is published
            List<PageModule> pageModules
                = PageModule.GetPageModulesByModule(courseModule.ModuleId);

            // must update index for all pages containing
            // this module
            foreach (PageModule pageModule in pageModules)
            {
                PageSettings pageSettings
                    = new PageSettings(
                    courseModule.SiteId,
                    pageModule.PageId);

                //don't index pending/unpublished pages
                if (pageSettings.IsPending) { continue; }


                mojoPortal.SearchIndex.IndexItem indexItem = new mojoPortal.SearchIndex.IndexItem();
                if (courseModule.SearchIndexPath.Length > 0)
                {
                    indexItem.IndexPath = courseModule.SearchIndexPath;
                }
                indexItem.SiteId = courseModule.SiteId;
                indexItem.PageId = pageModule.PageId;
                indexItem.PageName = pageSettings.PageName;
                // permissions are kept in sync in search index
                // so that results are filtered by role correctly
                indexItem.ViewRoles = pageSettings.AuthorizedRoles;
                indexItem.ModuleViewRoles = module.ViewRoles;
                indexItem.ItemId = courseModule.CourseId;
                indexItem.ModuleId = courseModule.ModuleId;
                indexItem.ModuleTitle = module.ModuleTitle;
                indexItem.FeatureId = scheduleFeatureGuid.ToString();
                indexItem.FeatureName = forumFeature.FeatureName;
                indexItem.FeatureResourceFile = forumFeature.ResourceFile;
                indexItem.Title = courseModule.CourseName;

                indexItem.PublishBeginDate = pageModule.PublishBeginDate;
                indexItem.PublishEndDate = pageModule.PublishEndDate;
                indexItem.ViewPage = WebConfigSettings.CourseSearchUrl; //"browse-course";
                indexItem.Content = courseModule.Description + " " + courseModule.Metatags + " " + courseModule.LeadInstructor;
                //indexItem.CreatedUtc = courseModule.CreatedOn;
                //indexItem.LastModUtc = courseModule.UpdatedOn;

               
                    //older implementation

                //indexItem.Content = scheduleThread.PostMessage;


                    //indexItem.QueryStringAddendum = "&thread="
                    //    + forumThread.ThreadId.ToString()
                    //    + "&postid=" + forumThread.PostId.ToString();
                



                mojoPortal.SearchIndex.IndexHelper.RebuildIndex(indexItem);

                if (debugLog) { log.Debug("Indexed " + courseModule.CourseName); }


            }

        }

        public static void RemoveForumIndexItem(object oForumThread)
        {
            if (WebConfigSettings.DisableSearchIndex) { return; }

            if (!(oForumThread is CourseModule)) return;

            CourseModule forumThread = oForumThread as CourseModule;

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
                indexItem.ItemId = forumThread.CourseId;

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
                log.Error("siteSettings object retrieved in BrowseCoursesIndexBuilderProvider.RemoveForumIndexItem was null");
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

        private DataTable ConvertToDatatable(List<CourseModule> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("CourseID");
            dt.Columns.Add("CourseName");
            dt.Columns.Add("Description");
            dt.Columns.Add("LeadInstructor");
            dt.Columns.Add("CourseLength");

            dt.Columns.Add("AudienceIds");
            dt.Columns.Add("Audience");
            dt.Columns.Add("CreatedBy");
            dt.Columns.Add("CreatedOn");
            dt.Columns.Add("Delivery");
            dt.Columns.Add("Cost");
            dt.Columns.Add("UrlLink");
            dt.Columns.Add("ScheduleType");
            dt.Columns.Add("FilterCategory");
            dt.Columns.Add("Metatags");

            dt.Columns.Add("ModuleId");
            dt.Columns.Add("ModuleTitle");
            dt.Columns.Add("ViewRoles");

            foreach (var item in list)
            {
                var row = dt.NewRow();
                row["CourseID"] = item.CourseId;
                row["CourseName"] = item.CourseName;
                row["Description"] = item.Description;
                row["LeadInstructor"] = item.LeadInstructor;
                row["CourseLength"] = item.CourseLength;

                row["AudienceIds"] = item.AudienceIds;
                row["Audience"] = item.Audience;
                //row["CreatedBy"] = item.CreatedBy;
                //row["CreatedOn"] = item.CreatedOn;
                row["Delivery"] = item.Delivery;
                row["Cost"] = item.Cost;
                row["UrlLink"] = item.UrlLink;
                row["ScheduleType"] = item.ScheduleType;
                row["FilterCategory"] = item.FilterCategory;
                row["Metatags"] = item.Metatags;
                row["ModuleId"] = item.ModuleId;
                row["ModuleTitle"] = "Courses";
                row["ViewRoles"] = item.ViewRoles;
                dt.Rows.Add(row);
            }

            return dt;
        }
    }
}