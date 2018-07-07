using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace mojoPortal.Data
{
    public static class dbKalturaMedia
    {
        /// <summary>
        /// Get Guid for Media for the provided mediaID
        /// </summary>
        /// <param name="mediaID">Media ID</param>
        public static Guid GetGuidforMedia(string mediaID)
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "Usp_KalturaMedia_GetGuid", 2);
            sph.DefineSqlParameter("@MediaID", SqlDbType.VarChar, ParameterDirection.Input, mediaID);
            sph.DefineSqlParameter("@MediaGuid", SqlDbType.UniqueIdentifier, ParameterDirection.InputOutput, DBNull.Value);

            sph.ExecuteNonQuery();

            return new Guid(sph.Parameters[1].Value.ToString());
        }

        public static int SetLikesforKalturaMedia(string mediaId, int userId)
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "Usp_KalturaMedia_SetLikes", 2);
            sph.DefineSqlParameter("@MediaID", SqlDbType.NVarChar, ParameterDirection.Input, mediaId);
            sph.DefineSqlParameter("@UserID", SqlDbType.Int, ParameterDirection.Input, userId);

            return sph.ExecuteNonQuery();
        }

        public static int SetFavouritesforKalturaMedia(string mediaId, int userId)
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "Usp_KalturaMedia_SetFavourites", 2);
            sph.DefineSqlParameter("@MediaID", SqlDbType.NVarChar, ParameterDirection.Input, mediaId);
            sph.DefineSqlParameter("@UserID", SqlDbType.Int, ParameterDirection.Input, userId);

            return sph.ExecuteNonQuery();
        }

        public static IDataReader GetFavouritesVideo(string mediaId, int userId)
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "USP_GET_KalturaFavourite_ByUser", 2);
            sph.DefineSqlParameter("@MediaID", SqlDbType.NVarChar, ParameterDirection.Input, mediaId);
            sph.DefineSqlParameter("@UserID", SqlDbType.Int, ParameterDirection.Input, userId);
            return sph.ExecuteReader();
        }



        public static int DeleteFavouritesVideo(string mediaId, int userId)
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "USP_DEL_KalturaFavourite_ByUser", 2);
            sph.DefineSqlParameter("@MediaID", SqlDbType.NVarChar, ParameterDirection.Input, mediaId);
            sph.DefineSqlParameter("@UserID", SqlDbType.Int, ParameterDirection.Input, userId);
            return sph.ExecuteNonQuery();
        }



        public static IDataReader GetFavouritesVideoList(int userId)
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "Usp_KalturaMedia_GetFavouritesList", 1);
            sph.DefineSqlParameter("@UserID", SqlDbType.Int, ParameterDirection.Input, userId);
            return sph.ExecuteReader();
        }

        public static DataSet GetLikesforVideo(string mediaId, int userId)
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "USP_GET_KalturaLikes_ByUser", 2);
            sph.DefineSqlParameter("@MediaID", SqlDbType.NVarChar, ParameterDirection.Input, mediaId);
            sph.DefineSqlParameter("@UserID", SqlDbType.Int, ParameterDirection.Input, userId);

            return sph.ExecuteDataset();
        }
    }
}
