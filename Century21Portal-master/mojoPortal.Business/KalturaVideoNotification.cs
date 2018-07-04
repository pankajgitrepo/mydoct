using System;
using System.Data;
using mojoPortal.Data;
using System.Collections.Generic;

namespace mojoPortal.Business
{
    /// <summary>
    /// Kaltura video Notification class is used to hold the data from kaltura notification
    /// when a video is added, updated or deleted.
    /// </summary>
    public class KalturaVideoNotification : IIndexableContent
    {
        private int siteId = -1;
        private string searchIndexPath = string.Empty;

        #region Properties
        public int KalturaVideoID { get; set; }
        public string EntryId { get; set; }
        public string Name { get; set; }
        public string Tags { get; set; }
        public string Description { get; set; }
        public string ViewPageURL { get; set; }
        public string ThumnailURL { get; set; }
        public string Sign { get; set; }
        public DateTime CreatedOn { get; set; }
        public DateTime UpdatedOn { get; set; }
        public int CreatedBy { get; set; }
        public int UpdatedBy { get; set; }
        public int ModuleID { get; set; }
        public string ModuleName { get; set; }
        public string ViewRoles { get; set; }

        public int SiteId
        {
            get { return siteId; }
            set { siteId = value; }
        }

        public string SearchIndexPath
        {
            get { return searchIndexPath; }
            set { searchIndexPath = value; }
        }
        #endregion

        #region Constructors

        public KalturaVideoNotification() { }

        public KalturaVideoNotification(string EntryId)
        {
            if (!String.IsNullOrEmpty(EntryId))
            {
                GetByKalturaVideoId(EntryId);
            }

        }

        #endregion

        public static KalturaVideoNotification GetByKalturaVideoId(string EntryId)
        {
            KalturaVideoNotification kalturaVideo = null;
            using (var reader = DBKalturaVideo.GetKalturaVideoById(EntryId))
            {
                if (reader.Read())
                {
                    kalturaVideo = new KalturaVideoNotification
                    {
                        KalturaVideoID = Convert.ToInt32(reader["KalturaVideoID"]),
                        EntryId = Convert.ToString(reader["EntryID"]),
                        Name = Convert.ToString(reader["Name"]),
                        Tags = Convert.ToString(reader["Tags"]),
                        Description = Convert.ToString(reader["Description"]),
                        ThumnailURL = Convert.ToString(reader["ThumnailURL"]),
                        CreatedBy = Convert.ToInt32(reader["CreatedBy"]),
                        CreatedOn = Convert.ToDateTime(reader["CreatedOn"]),
                        ModuleID = Convert.ToInt32(reader["ModuleID"]),
                        UpdatedBy = reader["UpdatedBy"] == DBNull.Value ? 0 : Convert.ToInt32(reader["UpdatedBy"]),
                        UpdatedOn = reader["UpdatedBy"] == DBNull.Value ? new DateTime() : Convert.ToDateTime(reader["UpdatedOn"])
                    };
                }
            }
            return kalturaVideo;
        }
        public static List<KalturaVideoNotification> GetKalturaVideoByPage(int siteId, int pageId)
        {
            List<KalturaVideoNotification> kalturaVideo = new List<KalturaVideoNotification>();
            using (var reader = DBKalturaVideo.GetKalturaVideoByPage(siteId, pageId))
            {
                while (reader.Read())
                {
                    kalturaVideo.Add(
                    new KalturaVideoNotification
                    {
                        KalturaVideoID = Convert.ToInt32(reader["KalturaVideoID"]),
                        EntryId = Convert.ToString(reader["EntryID"]),
                        Name = Convert.ToString(reader["Name"]),
                        Tags = Convert.ToString(reader["Tags"]),
                        Description = Convert.ToString(reader["Description"]),
                        ThumnailURL = Convert.ToString(reader["ThumnailURL"]),
                        ModuleName = Convert.ToString(reader["ModuleTitle"]),
                        ViewRoles = Convert.ToString(reader["ViewRoles"]),
                        ModuleID = Convert.ToInt32(reader["ModuleID"]),
                        CreatedBy = Convert.ToInt32(reader["CreatedBy"]),
                        CreatedOn = Convert.ToDateTime(reader["CreatedOn"]),
                        UpdatedBy = reader["UpdatedBy"] == DBNull.Value ? 0 : Convert.ToInt32(reader["UpdatedBy"]),
                        UpdatedOn = reader["UpdatedBy"] == DBNull.Value ? new DateTime() : Convert.ToDateTime(reader["UpdatedOn"])
                    });
                }
            }
            return kalturaVideo;
        }
        public static List<KalturaVideoNotification> GetAllKalturaVideo(string sortBy = null, string sortDirection = null)
        {
            var kalturaVideo = new List<KalturaVideoNotification>();
            using (var reader = DBKalturaVideo.GetAllKalturaVideos(sortBy, sortDirection))
            {
                while (reader.Read())
                {
                    kalturaVideo.Add(
                    new KalturaVideoNotification
                    {
                        KalturaVideoID = Convert.ToInt32(reader["KalturaVideoID"]),
                        EntryId = Convert.ToString(reader["EntryID"]),
                        Name = Convert.ToString(reader["Name"]),
                        Tags = Convert.ToString(reader["Tags"]),
                        Description = Convert.ToString(reader["Description"]),
                        ThumnailURL = Convert.ToString(reader["ThumnailURL"]),
                        ModuleID = Convert.ToInt32(reader["ModuleID"]),
                        CreatedBy = Convert.ToInt32(reader["CreatedBy"]),
                        CreatedOn = Convert.ToDateTime(reader["CreatedOn"]),
                        UpdatedBy = reader["UpdatedBy"] == DBNull.Value ? 0 : Convert.ToInt32(reader["UpdatedBy"]),
                        UpdatedOn = reader["UpdatedBy"] == DBNull.Value ? new DateTime() : Convert.ToDateTime(reader["UpdatedOn"])
                    });
                }
            }
            return kalturaVideo;
        }

        public bool Save()
        {
            return KalturaVideoID != 0 ? Update() : Create();
        }

        private bool Update()
        {
            bool result = DBKalturaVideo.UpdateKalturaVideo(KalturaVideoID, EntryId, Name, Tags, Description, ThumnailURL, UpdatedBy);
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
            newId = DBKalturaVideo.AddKalturaVideo(EntryId, Name, Tags, Description, ThumnailURL, CreatedBy, ModuleID);

            if (newId > 0)
            {
                ContentChangedEventArgs e = new ContentChangedEventArgs();
                OnContentChanged(e);
            }
            return (newId > 0);
        }

        public bool Delete()
        {
            bool result = DBKalturaVideo.DeleteKalturaVideo(KalturaVideoID);

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
