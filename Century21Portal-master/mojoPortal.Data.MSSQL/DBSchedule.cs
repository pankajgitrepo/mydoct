using System;
using System.Data;

namespace mojoPortal.Data
{
    public static class DBSchedule
    {
        /// <summary>
        /// Get all schedules
        /// </summary>
        /// <returns></returns>
        public static IDataReader GetAllSchedule(string sortBy = null, string sortDirection = null, bool isAdmin = false)
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "Usp_Schedule_SelectAll", 3);
            sph.DefineSqlParameter("@SortParameter", SqlDbType.VarChar, ParameterDirection.Input, sortBy);
            sph.DefineSqlParameter("@SortDirection", SqlDbType.VarChar, ParameterDirection.Input, sortDirection);
            sph.DefineSqlParameter("@IsAdmin", SqlDbType.Bit, ParameterDirection.Input, isAdmin);
            return sph.ExecuteReader();
        }

        /// <summary>
        /// Get Schedule by Id
        /// </summary>
        /// <param name="scheduleId"></param>
        /// <returns></returns>
        public static IDataReader GetByScheduleId(int scheduleId)
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "Usp_Schedule_SelectById", 1);
            sph.DefineSqlParameter("@ScheduleID", SqlDbType.Int, ParameterDirection.Input, scheduleId);
            return sph.ExecuteReader();
        }

        /// <summary>
        /// Get Schedule by Id
        /// </summary>
        /// <param name="scheduleId"></param>
        /// <returns></returns>
        public static IDataReader GetByScheduleByPage(int siteId, int pageId)
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "Usp_Schedule_SelectAllByPage", 2);
            sph.DefineSqlParameter("@SiteId", SqlDbType.Int, ParameterDirection.Input, siteId);
            sph.DefineSqlParameter("@PageId", SqlDbType.Int, ParameterDirection.Input, pageId);
            return sph.ExecuteReader();
        }

        /// <summary>
        /// Delete Schedule
        /// </summary>
        /// <param name="scheduleId"></param>
        /// <returns></returns>
        public static bool DeleteSchedule(int scheduleId)
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "Usp_Schedule_Delete", 1);
            sph.DefineSqlParameter("@ScheduleID", SqlDbType.Int, ParameterDirection.Input, scheduleId);
            int rowsAffected = sph.ExecuteNonQuery();
            return (rowsAffected > -1);
        }

        /// <summary>
        /// Add Schedule
        /// </summary>
        /// <param name="scheduleGuid"></param>
        /// <param name="scheduleDate"></param>
        /// <param name="title"></param>
        /// <param name="description"></param>
        /// <param name="instructor"></param>
        /// <param name="instructorNames"></param>
        /// <param name="audienceIds"></param>
        /// <param name="audienceNames"></param>
        /// <param name="scheduleLength"></param>
        /// <param name="scheduleAccess"></param>
        /// <param name="url"></param>
        /// <param name="tuitionFee"></param>
        /// <param name="updatedOn"></param>
        /// <param name="createdBy"></param>
        /// <param name="updatedBy"></param>
        /// <param name="instructorIds"></param>
        /// <returns></returns>
        public static int AddSchedule(
                Guid scheduleGuid,
                DateTime scheduleDate,
                string title,
                string description,
                string instructorIds,
                string instructorNames,
                string audienceIds,
                string audienceNames,
                string scheduleLength,
                string scheduleAccess,
                string url,
                decimal tuitionFee,
                DateTime updatedOn,
                int createdBy,
                int updatedBy,
            int moduleId
            )
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetWriteConnectionString(), "Usp_Schedule_Insert", 16);
            sph.DefineSqlParameter("@ScheduleGuid", SqlDbType.UniqueIdentifier, ParameterDirection.Input, scheduleGuid);
            sph.DefineSqlParameter("@ScheduleDate", SqlDbType.DateTime, ParameterDirection.Input, scheduleDate);
            sph.DefineSqlParameter("@Title", SqlDbType.NVarChar, 100, ParameterDirection.Input, title);
            sph.DefineSqlParameter("@Description", SqlDbType.NVarChar,ParameterDirection.Input, description);
            sph.DefineSqlParameter("@InstructorIds", SqlDbType.VarChar, 500, ParameterDirection.Input, instructorIds);
            sph.DefineSqlParameter("@InstructorNames", SqlDbType.VarChar, 2000, ParameterDirection.Input, instructorNames);
            sph.DefineSqlParameter("@AudienceIds", SqlDbType.VarChar, 500, ParameterDirection.Input, audienceIds);
            sph.DefineSqlParameter("@AudienceNames", SqlDbType.VarChar, 2000, ParameterDirection.Input, audienceNames);
            sph.DefineSqlParameter("@ScheduleLength", SqlDbType.VarChar, 50, ParameterDirection.Input, scheduleLength);
            sph.DefineSqlParameter("@ScheduleAccess", SqlDbType.VarChar,100, ParameterDirection.Input, scheduleAccess);
            sph.DefineSqlParameter("@URL", SqlDbType.NVarChar,200, ParameterDirection.Input, url);
            sph.DefineSqlParameter("@TuitionFee", SqlDbType.Money, ParameterDirection.Input, tuitionFee);
            sph.DefineSqlParameter("@UpdatedOn", SqlDbType.DateTime, ParameterDirection.Input, updatedOn);
            sph.DefineSqlParameter("@CreatedBy", SqlDbType.Int, ParameterDirection.Input, createdBy);
            sph.DefineSqlParameter("@UpdatedBy", SqlDbType.Int, ParameterDirection.Input, updatedBy);
            sph.DefineSqlParameter("@ModuleId", SqlDbType.Int, ParameterDirection.Input, moduleId);
            int newID = Convert.ToInt32(sph.ExecuteScalar());
            return newID;
        }

        /// <summary>
        /// Update Schedule
        /// </summary>
        /// <param name="scheduleId"></param>
        /// <param name="scheduleDate"></param>
        /// <param name="scheduleGuid"></param>
        /// <param name="title"></param>
        /// <param name="description"></param>
        /// <param name="instructorNames"></param>
        /// <param name="audienceIds"></param>
        /// <param name="audienceNames"></param>
        /// <param name="scheduleLength"></param>
        /// <param name="scheduleAccess"></param>
        /// <param name="url"></param>
        /// <param name="tuitionFee"></param>
        /// <param name="isActive"></param>
        /// <param name="updatedOn"></param>
        /// <param name="updatedBy"></param>
        /// <param name="instructorIds"></param>
        /// <returns></returns>
        public static bool UpdateSchedule(
                int scheduleId,
                Guid scheduleGuid,
                DateTime scheduleDate,
                string title,
                string description,
                string instructorIds,
                string instructorNames,
                string audienceIds,
                string audienceNames,
                string scheduleLength,
                string scheduleAccess,
                string url,
                decimal tuitionFee,
                bool isActive,
                DateTime updatedOn,
                int updatedBy
            )
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetWriteConnectionString(), "Usp_Schedule_Update", 16);
            sph.DefineSqlParameter("@ScheduleID", SqlDbType.Int, ParameterDirection.Input, scheduleId);
            sph.DefineSqlParameter("@ScheduleGuid", SqlDbType.UniqueIdentifier, 100, ParameterDirection.Input, scheduleGuid);
            sph.DefineSqlParameter("@ScheduleDate", SqlDbType.DateTime, ParameterDirection.Input, scheduleDate);
            sph.DefineSqlParameter("@Title", SqlDbType.NVarChar, 100, ParameterDirection.Input, title);
            sph.DefineSqlParameter("@Description", SqlDbType.NVarChar, ParameterDirection.Input, description);
            sph.DefineSqlParameter("@InstructorIds", SqlDbType.VarChar, 500, ParameterDirection.Input, instructorIds);
            sph.DefineSqlParameter("@InstructorNames", SqlDbType.VarChar, 2000, ParameterDirection.Input, instructorNames);
            sph.DefineSqlParameter("@AudienceIds", SqlDbType.VarChar, 500, ParameterDirection.Input, audienceIds);
            sph.DefineSqlParameter("@AudienceNames", SqlDbType.VarChar, 2000, ParameterDirection.Input, audienceNames);
            sph.DefineSqlParameter("@ScheduleLength", SqlDbType.VarChar, 50, ParameterDirection.Input, scheduleLength);
            sph.DefineSqlParameter("@ScheduleAccess", SqlDbType.VarChar, 100, ParameterDirection.Input, scheduleAccess);
            sph.DefineSqlParameter("@URL", SqlDbType.NVarChar, 200, ParameterDirection.Input, url);
            sph.DefineSqlParameter("@TuitionFee", SqlDbType.Money, ParameterDirection.Input, tuitionFee);
            sph.DefineSqlParameter("@IsActive", SqlDbType.Bit, ParameterDirection.Input, isActive);
            sph.DefineSqlParameter("@UpdatedOn", SqlDbType.DateTime, ParameterDirection.Input, updatedOn);
            sph.DefineSqlParameter("@UpdatedBy", SqlDbType.Int, ParameterDirection.Input, updatedBy);
            int rowsAffected = sph.ExecuteNonQuery();
            return (rowsAffected > -1);
        }
    }
}
