// Author:					Pawan Majage
// Created:				    2015-05-18
// Last Modified:			2015-05-18

using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.CSharp;
namespace mojoPortal.Data
{
    public static class dbCourses
    {

        public static IDataReader GetAllCourses(int userId=0)
        {
            //SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "Usp_CourseModule_SelectAll", 0);
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "Usp_CourseModule_GetList", 1);

            sph.DefineSqlParameter("@UserID", SqlDbType.Int, ParameterDirection.Input, userId);
            return sph.ExecuteReader();
        }

        public static IDataReader GetAllAudienceDisplayNames()
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "Usp_Audince_Select", 0);
                       
            return sph.ExecuteReader();
        }

        public static IDataReader GetAllCoursesWithPaging(int userId = 0, int pageNumber = 1, int pageSize = 1, string filterBy = null, string sortBy = null, bool isAdmin = false)
        {
            //Usp_CourseModule_GetList_withPaging, Usp_CourseModule_GetList_withPagingSorting
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "Usp_CourseModule_GetList_withPagingSorting", 6);

            sph.DefineSqlParameter("@UserID", SqlDbType.Int, ParameterDirection.Input, userId);
            sph.DefineSqlParameter("@PageNumber", SqlDbType.Int, ParameterDirection.Input, pageNumber);
            sph.DefineSqlParameter("@PageSize", SqlDbType.Int, ParameterDirection.Input, pageSize);
            sph.DefineSqlParameter("@FilterBy", SqlDbType.NVarChar, ParameterDirection.Input, filterBy == null ? "" : filterBy);
            sph.DefineSqlParameter("@SortBy", SqlDbType.VarChar, ParameterDirection.Input, sortBy == null ? "" : sortBy);
            sph.DefineSqlParameter("@IsAdmin", SqlDbType.Bit, ParameterDirection.Input, isAdmin);


            return sph.ExecuteReader();

        }
        public static IDataReader GetCoursesByPage(int siteId, int pageId)
        {
            //Usp_CourseModule_GetList_withPaging, Usp_CourseModule_GetList_withPagingSorting
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "Usp_CourseModule_SelectAllByPage", 2);

            sph.DefineSqlParameter("@SiteId", SqlDbType.Int, ParameterDirection.Input, siteId);
            sph.DefineSqlParameter("@PageId", SqlDbType.Int, ParameterDirection.Input, pageId);


            return sph.ExecuteReader();
        }
        public static DataSet GetCourseDetailsByCourseId(int CourseId)
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "Usp_CourseModule_GetByCourseId", 1);
            sph.DefineSqlParameter("@CourseId", SqlDbType.Int, ParameterDirection.Input, CourseId);
            return sph.ExecuteDataset();
        }

        public static int SaveCourse(string CourseName, string Description, string LeadInstructor,
            string CourseLength, string AudienceIds, string Audience, string Delivery, string Cost, string UrlLink, string ScheduleType, string FilterCategory,
            string Metatags, int Active, int CourseId, int ModuleId, string FilterIds )
        {
            Guid newGuid = Guid.NewGuid();
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "Usp_Course_Create", 17);
            //sph.DefineSqlParameter("@UserPageID", SqlDbType.UniqueIdentifier, ParameterDirection.Input, userPageId);

            sph.DefineSqlParameter("@CourseGuid", SqlDbType.UniqueIdentifier, ParameterDirection.Input, newGuid);
            sph.DefineSqlParameter("@CourseName", SqlDbType.NVarChar, ParameterDirection.Input, CourseName);
            sph.DefineSqlParameter("@Description", SqlDbType.NVarChar, ParameterDirection.Input, Description);
            sph.DefineSqlParameter("@LeadInstructor", SqlDbType.NVarChar, ParameterDirection.Input, LeadInstructor);
            sph.DefineSqlParameter("@CourseLength", SqlDbType.VarChar, ParameterDirection.Input, CourseLength);
            sph.DefineSqlParameter("@AudienceIds", SqlDbType.VarChar, ParameterDirection.Input, AudienceIds);
            sph.DefineSqlParameter("@Audience", SqlDbType.VarChar, ParameterDirection.Input, Audience);
            sph.DefineSqlParameter("@Delivery", SqlDbType.VarChar, ParameterDirection.Input, Delivery);
            sph.DefineSqlParameter("@Cost", SqlDbType.VarChar, ParameterDirection.Input, Cost);
            sph.DefineSqlParameter("@UrlLink", SqlDbType.NVarChar, ParameterDirection.Input, UrlLink);
            sph.DefineSqlParameter("@ScheduleType", SqlDbType.VarChar, ParameterDirection.Input, ScheduleType);
            sph.DefineSqlParameter("@FilterCategory", SqlDbType.NVarChar, ParameterDirection.Input, FilterCategory);
            sph.DefineSqlParameter("@Metatags", SqlDbType.NVarChar, ParameterDirection.Input, Metatags);
            sph.DefineSqlParameter("@Active", SqlDbType.Bit, ParameterDirection.Input, Active);
            sph.DefineSqlParameter("@ModuleId", SqlDbType.Int, ParameterDirection.Input, ModuleId);
            sph.DefineSqlParameter("@FilterIds", SqlDbType.VarChar, ParameterDirection.Input, FilterIds);
            sph.DefineSqlParameter("@CourseID", SqlDbType.Int, ParameterDirection.InputOutput, CourseId);
            int retVal = sph.ExecuteNonQuery();
            int NewCourseId = Convert.ToInt32(sph.Parameters[16].Value);
            return retVal;
        }

        public static int DeleteCourse(int CourseID)
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "Usp_Course_Delete", 1);
            sph.DefineSqlParameter("@CourseID", SqlDbType.Int, ParameterDirection.Input, CourseID);
            return sph.ExecuteNonQuery();
        }

        /// <summary>
        /// Set Likes
        /// </summary>
        /// <param name="courseID"></param>
        /// <param name="userID"></param>
        /// <returns></returns>
        public static int SetLikes(int courseID, int userID)
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "Usp_Course_SetLikes", 2);

            sph.DefineSqlParameter("@CourseID", SqlDbType.Int, ParameterDirection.Input, courseID);
            sph.DefineSqlParameter("@UserID", SqlDbType.Int, ParameterDirection.Input, userID);

            return sph.ExecuteNonQuery();

        }

    }
}
