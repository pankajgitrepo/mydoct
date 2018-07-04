// Author:					Pawan Majage
// Created:				    2015-05-18
// Last Modified:			2015-05-18


using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using mojoPortal.Data;

namespace mojoPortal.Business
{
    /// <summary>
    /// This class represents the data object for Courses corresponding to table 
    /// </summary>
    public class CourseModule : IIndexableContent
    {
        #region Properties and Variables
        private int courseId = 0;
        private object courseGUID = null;
        private string courseName = string.Empty;
        private string description = string.Empty;
        private string leadInstructor = string.Empty;
        private string courseLength = string.Empty;
        private string delivery = string.Empty;
        private string cost = string.Empty;
        private string urlLink = string.Empty;
        private string scheduleType = string.Empty;
        private string filterCategory = string.Empty;
        private string metatags = string.Empty;
        private int active = 1;
        private string audience = string.Empty;
        private string audienceIds = string.Empty;
        private string filterIds = string.Empty;       
        private int likes = 0;
        private int commentsCount = 0;
        private int totalRows = 0;
        private bool isEdit = false;
        private int moduleId = -1;
        private int siteId = -1;
        private string searchIndexPath = string.Empty;
        private string viewRole = string.Empty;

        public bool IsEdit
        {
            get { return isEdit; }
            set { isEdit = value; }
        }

        public int TotalRows
        {
            get;
            set;
        }

        public bool LikeByThisUser
        {
            get;
            set;
        }    

        public int CommentsCount
        {
            get;
            set;
        }

        public int Likes
        {
            get;
            set;
        }

        public string AudienceIds
        {
            get;
            set;
        }

        public string Audience
        {
            get;
            set;
        }

        public int CourseId
        {
            get;
            set;
        }

        public object CourseGUID
        {
            get;
            set;
        }

        public string CourseName
        {
            get;
            set;
        }

        public string Description
        {
            get;
            set;
        }

        public string LeadInstructor
        {
            get;
            set;
        }

        public string CourseLength
        {
            get;
            set;
        }

        public string Delivery
        {
            get;
            set;
        }

        public string Cost
        {
            get;
            set;
        }

        public string UrlLink
        {
            get;
            set;
        }

        public string ScheduleType
        {
            get;
            set;
        }

        public string FilterCategory
        {
            get{return filterCategory;}
            set { filterCategory = value; }
        }

        public string FilterIds
        {
            get { return filterIds; }
            set { filterIds = value; }
        }

        public string Metatags
        {
            get;
            set;
        }

        public int Active
        {
            get;
            set;
        }
        /// <summary>
        /// This is not persisted to the db. It is only set and used when indexing forum threads in the search index.
        /// Its a convenience because when we queue the task to index on a new thread we can only pass one object.
        /// So we store extra properties here so we don't need any other objects.
        /// </summary>
        public int SiteId
        {
            get { return siteId; }
            set { siteId = value; }
        }

        /// <summary>
        /// This is not persisted to the db. It is only set and used when indexing forum threads in the search index.
        /// Its a convenience because when we queue the task to index on a new thread we can only pass one object.
        /// So we store extra properties here so we don't need any other objects.
        /// </summary>
        public string SearchIndexPath
        {
            get { return searchIndexPath; }
            set { searchIndexPath = value; }
        }
        public int ModuleId
        {
            get { return moduleId; }
            set { moduleId = value; }

        }

        public string ViewRoles
        {
            get { return viewRole; }
            set { viewRole = value; }

        }
        
        #endregion
                        #region Constructors

        public CourseModule()
        { }

        public CourseModule(int courseId)
        {
            if (courseId > -1)
            {
                GetCourseDetailsByCourseId(courseId);
            }

        }

        #endregion
        public List<Audience> LoadAudienceFromReader()
        {
            List<Audience> audience = new List<Audience>();
            using (IDataReader reader = dbCourses.GetAllAudienceDisplayNames())
            {
                while (reader.Read())
                {
                    Audience aud = new Audience();
                    aud.AudienceId = Convert.ToInt32(reader["ID"]);
                    aud.DisplayName = Convert.ToString(reader["DisplayName"]);
                    audience.Add(aud);
                }
            }

            return audience;
            
        }
        private static List<CourseModule> LoadListFromReader(int userId=0, int pageNumber=1, int pageSize=1, string filterBy=null, string sortBy=null, bool isAdmin = false)
        {
            List<CourseModule> courseModules = new List<CourseModule>();
            //using (IDataReader reader = dbCourses.GetAllCourses(userId))
            using (IDataReader reader = dbCourses.GetAllCoursesWithPaging(userId, pageNumber, pageSize, filterBy, sortBy, isAdmin)) 
            {
                while (reader.Read())
                {
                    CourseModule courseModule = new CourseModule();

                    courseModule.CourseId = Convert.ToInt32(reader["CourseID"]);
                    courseModule.CourseGUID = reader["CourseGuid"];
                    courseModule.CourseName = Convert.ToString(reader["CourseName"]);
                    courseModule.Description = Convert.ToString(reader["Description"]);
                    courseModule.LeadInstructor = Convert.ToString(reader["LeadInstructorUser"]);
                    courseModule.Audience = Convert.ToString(reader["Audience"]);
                    courseModule.CourseLength = Convert.ToString(reader["CourseLength"]);
                    courseModule.Delivery = Convert.ToString(reader["Delivery"]);
                    courseModule.Cost = Convert.ToString(reader["Cost"]);
                    courseModule.UrlLink = Convert.ToString(reader["UrlLink"]);
                    courseModule.ScheduleType = Convert.ToString(reader["ScheduleType"]);
                    courseModule.FilterCategory = Convert.ToString(reader["FilterCategory"]);
                    courseModule.Metatags = Convert.ToString(reader["Metatags"]);
                    courseModule.Active = Convert.ToInt32(reader["Active"]);
                    courseModule.Likes = Convert.ToInt32(reader["Likes"]);
                    courseModule.LikeByThisUser = reader["LikeByThisUser"].ToString().ToUpper() == "Y" ? true : false;
                    courseModule.CommentsCount = Convert.ToInt32(reader["CommentsCount"]);
                    courseModule.TotalRows = Convert.ToInt32(reader["TotalRows"]);
                    courseModules.Add(courseModule);
                }
            }

            return courseModules;
        }

        /// <summary>
        /// Returns all PageModules for the given pageID
        /// including un published ones
        /// </summary>
        public static List<CourseModule> GetAllCourses(int userid=0, int pageNumber=1, int pageSize=1, string filterBy=null, string sortBy=null, bool isAdmin=false)
        {
            List<CourseModule> courseModules = new List<CourseModule>();

            courseModules = LoadListFromReader(userid, pageNumber, pageSize, filterBy, sortBy, isAdmin);

            return courseModules;
        }

        public static List<CourseModule> GetCoursesByPage(int siteId, int pageId)
        {
            List<CourseModule> courseModules = new List<CourseModule>();

            using (var reader = dbCourses.GetCoursesByPage(siteId, pageId))
            {
                while (reader.Read())
                {
                    courseModules.Add(
                    new CourseModule
                    {
                        CourseId = Convert.ToInt32(reader["CourseID"]),
                        CourseGUID = (Guid)(reader["CourseGuid"]),
                        CourseName = (string)reader["CourseName"],
                        Description = (string)reader["Description"],
                        LeadInstructor = (string)reader["LeadInstructor"],
                        CourseLength = (string)reader["CourseLength"],
                        Delivery = (string)reader["Delivery"],
                        Cost = (string)reader["Cost"],
                        UrlLink = (string)reader["UrlLink"],
                        ScheduleType = (string)reader["ScheduleType"],
                        FilterCategory = (string)reader["FilterCategory"],
                        Metatags = (string)reader["Metatags"],
                        Active = Convert.ToInt32(reader["Active"]),
                        AudienceIds = (string)(reader["AudienceIds"]),
                        Audience = (string)(reader["Audience"]),
                        ModuleId = Convert.ToInt32(reader["ModuleId"]),
                        ViewRoles = reader["ViewRoles"].ToString()

                    });
                }
            }
            return courseModules;

        }

        /// <summary>
        /// Save Courses
        /// </summary>
        /// <param name="course"></param>
        /// <returns></returns>
        public int SaveCourse(CourseModule course)
        {
                var result= dbCourses.SaveCourse(course.CourseName, course.Description, course.LeadInstructor,
                    course.CourseLength, course.AudienceIds, course.Audience, course.Delivery, course.Cost, course.UrlLink, course.ScheduleType, course.FilterCategory,
                    course.Metatags, course.Active, course.CourseId, course.ModuleId, course.FilterIds);
                if (result>-1)
                {
                    ContentChangedEventArgs e = new ContentChangedEventArgs();
                    OnContentChanged(e);
                }
                return result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="CourseID"></param>
        /// <returns></returns>
        public int DeleteCourse(int CourseID)
        {
            int result = dbCourses.DeleteCourse(CourseID);
            if (result>-1)
            {
                ContentChangedEventArgs e = new ContentChangedEventArgs();
                e.IsDeleted = true;
                OnContentChanged(e);
            }
            return result;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="CourseId"></param>
        /// <returns></returns>
        public static CourseModule GetCourseDetailsByCourseId(int courseId)
        {
            DataSet ds = dbCourses.GetCourseDetailsByCourseId(courseId);
            CourseModule course = new CourseModule();

            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                course.CourseId = Convert.ToInt32(ds.Tables[0].Rows[0]["CourseID"]);
                course.CourseGUID = (Guid)(ds.Tables[0].Rows[0]["CourseGuid"]);
                course.CourseName = (string)ds.Tables[0].Rows[0]["CourseName"];
                course.Description = (string)ds.Tables[0].Rows[0]["Description"];
                course.LeadInstructor = (string)ds.Tables[0].Rows[0]["LeadInstructor"];
                course.CourseLength = (string)ds.Tables[0].Rows[0]["CourseLength"];
                course.Delivery = (string)ds.Tables[0].Rows[0]["Delivery"];
                course.Cost = (string)ds.Tables[0].Rows[0]["Cost"];
                course.UrlLink = (string)ds.Tables[0].Rows[0]["UrlLink"];
                course.ScheduleType = (string)ds.Tables[0].Rows[0]["ScheduleType"];
                course.FilterCategory = (string)ds.Tables[0].Rows[0]["FilterCategory"];
                course.Metatags = (string)ds.Tables[0].Rows[0]["Metatags"];
                course.Active = Convert.ToInt32(ds.Tables[0].Rows[0]["Active"]);
                course.AudienceIds = (string)(ds.Tables[0].Rows[0]["AudienceIds"]);
                course.FilterCategory = (string)(ds.Tables[0].Rows[0]["FilterCategory"]);
                course.FilterIds = (string)(ds.Tables[0].Rows[0]["FilterIds"]);
                course.Audience = (string)(ds.Tables[0].Rows[0]["Audience"]);
                course.ModuleId = Convert.ToInt32(ds.Tables[0].Rows[0]["ModuleId"]);
            }
            return course;
        }

        /// <summary>
        /// set likes for specified course from a user
        /// </summary>
        /// <param name="CourseId"></param>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public static int SetLikesforCourse(int courseId, int userId)
        {
            return dbCourses.SetLikes(courseId, userId);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="CourseId"></param>
        /// <returns></returns>
        public static List<CourseModule> GetCourseByCourseId(int courseId)
        {
            DataSet ds = dbCourses.GetCourseDetailsByCourseId(courseId);
            CourseModule course = new CourseModule();
            List<CourseModule> lstCourse = new List<CourseModule>();
            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                course.CourseId = Convert.ToInt32(ds.Tables[0].Rows[0]["CourseID"]);
                course.CourseGUID = (Guid)(ds.Tables[0].Rows[0]["CourseGuid"]);
                course.CourseName = (string)ds.Tables[0].Rows[0]["CourseName"];
                course.Description = (string)ds.Tables[0].Rows[0]["Description"];
                course.LeadInstructor = (string)ds.Tables[0].Rows[0]["LeadInstructor"];
                course.CourseLength = (string)ds.Tables[0].Rows[0]["CourseLength"];
                course.Delivery = (string)ds.Tables[0].Rows[0]["Delivery"];
                course.Cost = (string)ds.Tables[0].Rows[0]["Cost"];
                course.UrlLink = (string)ds.Tables[0].Rows[0]["UrlLink"];
                course.ScheduleType = (string)ds.Tables[0].Rows[0]["ScheduleType"];
                course.FilterCategory = (string)ds.Tables[0].Rows[0]["FilterCategory"];
                course.Metatags = (string)ds.Tables[0].Rows[0]["Metatags"];
                course.Active = Convert.ToInt32(ds.Tables[0].Rows[0]["Active"]);
                course.AudienceIds = (string)(ds.Tables[0].Rows[0]["AudienceIds"]);
                course.FilterCategory = (string)(ds.Tables[0].Rows[0]["FilterCategory"]);
                course.FilterIds = (string)(ds.Tables[0].Rows[0]["FilterIds"]);
                course.Audience = (string)(ds.Tables[0].Rows[0]["Audience"]);
                course.ModuleId = Convert.ToInt32(ds.Tables[0].Rows[0]["ModuleId"]);
                lstCourse.Add(course);
            }
            return lstCourse;
        }

        #region IIndexableContent

        public event ContentChangedEventHandler ContentChanged;

        protected void OnContentChanged(ContentChangedEventArgs e)
        {
            if (ContentChanged != null)
            {
                ContentChanged(this, e);
            }
        }


        #endregion
    }

    public class Audience
    {
        public int AudienceId { get; set; }

        public string DisplayName { get; set; }
    }
}
