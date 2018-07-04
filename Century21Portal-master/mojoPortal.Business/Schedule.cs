using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using mojoPortal.Data;

namespace mojoPortal.Business
{
    public class Schedule : IIndexableContent
    {
        #region Properties and Variables

        private int siteId = -1;
        private string searchIndexPath = string.Empty;
        private int moduleID = -1;

        public int ScheduleId { get; set; }
        public Guid ScheduleGuid { get; set; }
        public DateTime ScheduleDate { get; set; }
        public string  Title { get; set; }
        public string Description { get; set; }
        public string InstructorIds { get; set; }
        public string InstructorNames { get; set; }
        public string AudienceIds { get; set; }
        public string  AudienceNames { get; set; }
        public string ScheduleLength { get; set; }
        public string ScheduleAccess { get; set; }
        public string Url { get; set; }
        public decimal TuitionFee { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedOn { get; set; }
        public DateTime UpdatedOn { get; set; }
        public int CreatedBy { get; set; }
        public int UpdatedBy { get; set; }
        private string viewRole = string.Empty;

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
            get { return moduleID; }
            set { moduleID = value; }

        }
        public string ViewRoles
        {
            get { return viewRole; }
            set { viewRole = value; }

        }
        #endregion Properties and Variables
        
                #region Constructors

        public Schedule()
        { }

        public Schedule(int scheduleId)
        {
            if (scheduleId > -1)
            {
                GetByScheduleId(scheduleId);
            }

        }

        #endregion

        public static Schedule GetByScheduleId(int scheduleId)
        {
            Schedule schedule = null;
            using (var reader = DBSchedule.GetByScheduleId(scheduleId))
            {
                if (reader.Read())
                {
                    schedule = new Schedule
                    {
                        ScheduleId = Convert.ToInt32(reader["ScheduleID"]),
                        ScheduleGuid = new Guid(reader["ScheduleGuid"].ToString()),
                        ScheduleDate = Convert.ToDateTime(reader["ScheduleDate"]),
                        AudienceIds = reader["AudienceIds"].ToString(),
                        AudienceNames = reader["AudienceNames"].ToString(),
                        CreatedBy = Convert.ToInt32(reader["CreatedBy"]),
                        CreatedOn = Convert.ToDateTime(reader["CreatedOn"]),
                        Description = reader["Description"].ToString(),
                        InstructorIds = reader["InstructorIds"].ToString(),
                        InstructorNames = reader["InstructorNames"].ToString(),
                        IsActive = Convert.ToBoolean(reader["IsActive"]),
                        ScheduleAccess = reader["ScheduleAccess"].ToString(),
                        ScheduleLength = reader["ScheduleLength"].ToString(),
                        Title = reader["Title"].ToString(),
                        TuitionFee = Convert.ToDecimal(reader["TuitionFee"]),
                        UpdatedBy = Convert.ToInt32(reader["UpdatedBy"]),
                        UpdatedOn = Convert.ToDateTime(reader["UpdatedOn"]),
                        Url = reader["URL"].ToString()
                    };
                }
            }
            return schedule;
        }
        public static List<Schedule> GetByScheduleByPage(int siteId, int pageId)
        {
            List<Schedule> schedule = new List<Schedule>();
            using (var reader = DBSchedule.GetByScheduleByPage(siteId, pageId))
            {
                while (reader.Read())
                {
                    schedule.Add(
                    new Schedule
                    {
                        ScheduleId = Convert.ToInt32(reader["ScheduleID"]),
                        ScheduleGuid = new Guid(reader["ScheduleGuid"].ToString()),
                        ScheduleDate = Convert.ToDateTime(reader["ScheduleDate"]),
                        AudienceIds = reader["AudienceIds"].ToString(),
                        AudienceNames = reader["AudienceNames"].ToString(),
                        CreatedBy = Convert.ToInt32(reader["CreatedBy"]),
                        CreatedOn = Convert.ToDateTime(reader["CreatedOn"]),
                        Description = reader["Description"].ToString(),
                        InstructorIds = reader["InstructorIds"].ToString(),
                        InstructorNames = reader["InstructorNames"].ToString(),
                        IsActive = Convert.ToBoolean(reader["IsActive"]),
                        ScheduleAccess = reader["ScheduleAccess"].ToString(),
                        ScheduleLength = reader["ScheduleLength"].ToString(),
                        Title = reader["Title"].ToString(),
                        TuitionFee = Convert.ToDecimal(reader["TuitionFee"]),
                        UpdatedBy = Convert.ToInt32(reader["UpdatedBy"]),
                        UpdatedOn = Convert.ToDateTime(reader["UpdatedOn"]),
                        Url = reader["URL"].ToString(),
                        ModuleId = Convert.ToInt32(reader["ModuleId"]),
                        ViewRoles = reader["ViewRoles"].ToString()
                    });
                }
            }
            return schedule;
        }
        public static List<Schedule> GetAllSchedule(string sortBy = null, string sortDirection = null, bool isAdmin = false)
        {
            var schedules = new List<Schedule>();
            using (var reader = DBSchedule.GetAllSchedule(sortBy, sortDirection, isAdmin))
            {
                while (reader.Read())
                {
                    schedules.Add(
                    new Schedule
                    {
                        ScheduleId = Convert.ToInt32(reader["ScheduleID"]),
                        ScheduleGuid = new Guid(reader["ScheduleGuid"].ToString()),
                        ScheduleDate = Convert.ToDateTime(reader["ScheduleDate"]),
                        AudienceIds = reader["AudienceIds"].ToString(),
                        AudienceNames = reader["AudienceNames"].ToString(),
                        CreatedBy = Convert.ToInt32(reader["CreatedBy"]),
                        CreatedOn = Convert.ToDateTime(reader["CreatedOn"]),
                        Description = reader["Description"].ToString(),
                        InstructorIds = reader["InstructorIds"].ToString(),
                        InstructorNames = reader["InstructorNames"].ToString(),
                        IsActive = Convert.ToBoolean(reader["IsActive"]),
                        ScheduleAccess = reader["ScheduleAccess"].ToString(),
                        ScheduleLength = reader["ScheduleLength"].ToString(),
                        Title = reader["Title"].ToString(),
                        TuitionFee = Convert.ToDecimal(reader["TuitionFee"]),
                        UpdatedBy = Convert.ToInt32(reader["UpdatedBy"]),
                        UpdatedOn = Convert.ToDateTime(reader["UpdatedOn"]),
                        Url = reader["URL"].ToString()
                        
                    });
                }
            }
            return schedules;
        }

        public bool Save()
        {
            return ScheduleId > -1 ? Update() : Create();
        }

        private bool Update()
        {
           bool result= DBSchedule.UpdateSchedule(ScheduleId, ScheduleGuid, ScheduleDate, Title, Description, InstructorIds, InstructorNames,
                AudienceIds, AudienceNames, ScheduleLength, ScheduleAccess, Url, TuitionFee, IsActive, DateTime.UtcNow, UpdatedBy);
            if (result)
            {
                ContentChangedEventArgs e = new ContentChangedEventArgs();
                OnContentChanged(e);
            }
            return result;
        }

        private bool Create()
        {
            int newId = 0;
            ScheduleGuid = Guid.NewGuid();
            UpdatedOn = DateTime.UtcNow;
            newId = DBSchedule.AddSchedule(ScheduleGuid, ScheduleDate, Title, Description, InstructorIds, InstructorNames, 
                AudienceIds, AudienceNames,ScheduleLength, ScheduleAccess, Url, TuitionFee, UpdatedOn, CreatedBy, UpdatedBy,ModuleId);

            if (newId>0)
            {
                ContentChangedEventArgs e = new ContentChangedEventArgs();
                OnContentChanged(e);
            }
            return (newId > 0);
        }

        public bool Delete(int scheduleId)
        {
            bool result = DBSchedule.DeleteSchedule(scheduleId);

            if (result)
            {
                ContentChangedEventArgs e = new ContentChangedEventArgs();
                e.IsDeleted = true;
                OnContentChanged(e);
            }

            return result;
            
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
}
