using System;
using System.Data;

namespace mojoPortal.Data
{
    public static class DBKalturaVideo
    {
        /// <summary>
        /// Get all Kaltura Videos
        /// </summary>
        public static IDataReader GetAllKalturaVideos(string sortBy = null, string sortDirection = null)
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "Usp_KalturaVideo_SelectAll", 2);
            sph.DefineSqlParameter("@SortParameter", SqlDbType.VarChar, ParameterDirection.Input, sortBy);
            sph.DefineSqlParameter("@SortDirection", SqlDbType.VarChar, ParameterDirection.Input, sortDirection);
            return sph.ExecuteReader();
        }

        /// <summary>
        /// Get Kaltura Video by EntryId
        /// </summary>
        public static IDataReader GetKalturaVideoById(string entryId)
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "Usp_KalturaVideo_SelectById", 1);
            sph.DefineSqlParameter("@EntryId", SqlDbType.NVarChar, 200, ParameterDirection.Input, entryId);
            return sph.ExecuteReader();
        }


        /// <summary>
        /// Get Kaltura Videos by site Id(1) and page Id(23) 
        /// </summary>
        public static IDataReader GetKalturaVideoByPage(int siteId, int pageId)
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "Usp_KalturaVideo_SelectAllByPage", 2);
            sph.DefineSqlParameter("@SiteId", SqlDbType.Int, ParameterDirection.Input, siteId);
            sph.DefineSqlParameter("@PageId", SqlDbType.Int, ParameterDirection.Input, pageId);
            return sph.ExecuteReader();
        }

        /// <summary>
        /// Add Kaltura Video
        /// </summary>
        public static int AddKalturaVideo(string entryId,
                                          string name,
                                          string tags,
                                          string description,
                                          string thumbnailUrl,
                                          int createdBy,
                                          int moduleId)
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetWriteConnectionString(), "Usp_KalturaVideo_Insert", 7);
            sph.DefineSqlParameter("@EntryId", SqlDbType.NVarChar, 200, ParameterDirection.Input, entryId);
            sph.DefineSqlParameter("@Name", SqlDbType.NVarChar, 200, ParameterDirection.Input, name);
            sph.DefineSqlParameter("@Tags", SqlDbType.NVarChar, 200, ParameterDirection.Input, tags);
            sph.DefineSqlParameter("@Description", SqlDbType.NVarChar, ParameterDirection.Input, description);
            sph.DefineSqlParameter("@ThumnailURL", SqlDbType.NVarChar, 200, ParameterDirection.Input, thumbnailUrl);
            sph.DefineSqlParameter("@CreatedBy", SqlDbType.Int, ParameterDirection.Input, createdBy);
            sph.DefineSqlParameter("@ModuleId", SqlDbType.Int, ParameterDirection.Input, moduleId);
            int newID = Convert.ToInt32(sph.ExecuteScalar());
            return newID;
        }


        /// <summary>
        /// Update Kaltura Video
        /// </summary>
        public static bool UpdateKalturaVideo(int KalturaVideoID,
                                          string entryId,
                                          string name,
                                          string tags,
                                          string description,
                                          string thumbnailUrl,
                                          int updatedBy)
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetWriteConnectionString(), "Usp_KalturaVideo_Update", 7);
            sph.DefineSqlParameter("@KalturaVideoID", SqlDbType.Int, ParameterDirection.Input, KalturaVideoID);
            sph.DefineSqlParameter("@EntryId", SqlDbType.NVarChar, 200, ParameterDirection.Input, entryId);
            sph.DefineSqlParameter("@Name", SqlDbType.NVarChar, 200, ParameterDirection.Input, name);
            sph.DefineSqlParameter("@Tags", SqlDbType.NVarChar, 200, ParameterDirection.Input, tags);
            sph.DefineSqlParameter("@Description", SqlDbType.NVarChar, ParameterDirection.Input, description);
            sph.DefineSqlParameter("@ThumnailURL", SqlDbType.NVarChar, 200, ParameterDirection.Input, thumbnailUrl);
            sph.DefineSqlParameter("@UpdatedBy", SqlDbType.Int, ParameterDirection.Input, updatedBy);
            int rowsAffected = sph.ExecuteNonQuery();
            return (rowsAffected > -1);
        }


        /// <summary>
        /// Delete Kaltura Video
        /// </summary>
        public static bool DeleteKalturaVideo(int KalturaVideoID)
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "Usp_KalturaVideo_Delete", 1);
            sph.DefineSqlParameter("@KalturaVideoID", SqlDbType.Int, ParameterDirection.Input, KalturaVideoID);
            int rowsAffected = sph.ExecuteNonQuery();
            return (rowsAffected > -1);
        }
    }
}
