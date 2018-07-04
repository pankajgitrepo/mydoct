﻿// Author:					Joe Audette
// Created:					2011-10-30
// Last Modified:			2011-10-30
// 
// The use and distribution terms for this software are covered by the 
// Common Public License 1.0 (http://opensource.org/licenses/cpl.php)  
// which can be found in the file CPL.TXT at the root of this distribution.
// By using this software in any fashion, you are agreeing to be bound by 
// the terms of this license.
//
// You must not remove this notice, or any other, from this software.

using System;
using System.Data;
using System.Data.Common;
using System.Configuration;
using System.Globalization;
using System.IO;
using System.Text;
using System.Web;
using FirebirdSql.Data.FirebirdClient;

namespace mojoPortal.Data
{
    public static class DBCategoryItem
    {
        
        private static String GetReadConnectionString()
        {
            return ConfigurationManager.AppSettings["FirebirdConnectionString"];

        }

        private static String GetWriteConnectionString()
        {
            if (ConfigurationManager.AppSettings["FirebirdWriteConnectionString"] != null)
            {
                return ConfigurationManager.AppSettings["FirebirdWriteConnectionString"];
            }

            return ConfigurationManager.AppSettings["FirebirdConnectionString"];

        }


        /// <summary>
        /// Inserts a row in the mp_CategoryItem table. Returns rows affected count.
        /// </summary>
        /// <param name="guid"> guid </param>
        /// <param name="siteGuid"> siteGuid </param>
        /// <param name="featureGuid"> featureGuid </param>
        /// <param name="moduleGuid"> moduleGuid </param>
        /// <param name="itemGuid"> itemGuid </param>
        /// <param name="categoryGuid"> categoryGuid </param>
        /// <param name="extraGuid"> extraGuid </param>
        /// <returns>int</returns>
        public static int Create(
            Guid guid,
            Guid siteGuid,
            Guid featureGuid,
            Guid moduleGuid,
            Guid itemGuid,
            Guid categoryGuid,
            Guid extraGuid)
        {

            FbParameter[] arParams = new FbParameter[7];


            arParams[0] = new FbParameter("@Guid", FbDbType.Char, 36);
            arParams[0].Direction = ParameterDirection.Input;
            arParams[0].Value = guid.ToString();

            arParams[1] = new FbParameter("@SiteGuid", FbDbType.Char, 36);
            arParams[1].Direction = ParameterDirection.Input;
            arParams[1].Value = siteGuid.ToString();

            arParams[2] = new FbParameter("@FeatureGuid", FbDbType.Char, 36);
            arParams[2].Direction = ParameterDirection.Input;
            arParams[2].Value = featureGuid.ToString();

            arParams[3] = new FbParameter("@ModuleGuid", FbDbType.Char, 36);
            arParams[3].Direction = ParameterDirection.Input;
            arParams[3].Value = moduleGuid.ToString();

            arParams[4] = new FbParameter("@ItemGuid", FbDbType.Char, 36);
            arParams[4].Direction = ParameterDirection.Input;
            arParams[4].Value = itemGuid.ToString();

            arParams[5] = new FbParameter("@CategoryGuid", FbDbType.Char, 36);
            arParams[5].Direction = ParameterDirection.Input;
            arParams[5].Value = categoryGuid.ToString();

            arParams[6] = new FbParameter("@ExtraGuid", FbDbType.Char, 36);
            arParams[6].Direction = ParameterDirection.Input;
            arParams[6].Value = extraGuid.ToString();


            StringBuilder sqlCommand = new StringBuilder();
            sqlCommand.Append("INSERT INTO mp_CategoryItem (");
            sqlCommand.Append("Guid, ");
            sqlCommand.Append("SiteGuid, ");
            sqlCommand.Append("FeatureGuid, ");
            sqlCommand.Append("ModuleGuid, ");
            sqlCommand.Append("ItemGuid, ");
            sqlCommand.Append("CategoryGuid, ");
            sqlCommand.Append("ExtraGuid )");


            sqlCommand.Append(" VALUES (");
            sqlCommand.Append("@Guid, ");
            sqlCommand.Append("@SiteGuid, ");
            sqlCommand.Append("@FeatureGuid, ");
            sqlCommand.Append("@ModuleGuid, ");
            sqlCommand.Append("@ItemGuid, ");
            sqlCommand.Append("@CategoryGuid, ");
            sqlCommand.Append("@ExtraGuid )");
            sqlCommand.Append(";");

            int rowsAffected = FBSqlHelper.ExecuteNonQuery(
                GetWriteConnectionString(),
                sqlCommand.ToString(),
                arParams);



            return rowsAffected;

        }


        

        /// <summary>
        /// Deletes a row from the mp_CategoryItem table. Returns true if row deleted.
        /// </summary>
        /// <param name="guid"> guid </param>
        /// <returns>bool</returns>
        public static bool Delete(Guid guid)
        {
            StringBuilder sqlCommand = new StringBuilder();
            sqlCommand.Append("DELETE FROM mp_CategoryItem ");
            sqlCommand.Append("WHERE ");
            sqlCommand.Append("Guid = @Guid ");
            sqlCommand.Append(";");
            FbParameter[] arParams = new FbParameter[1];

            arParams[0] = new FbParameter("@Guid", FbDbType.Char, 36);
            arParams[0].Direction = ParameterDirection.Input;
            arParams[0].Value = guid.ToString();


            int rowsAffected = FBSqlHelper.ExecuteNonQuery(
                GetWriteConnectionString(),
                sqlCommand.ToString(),
                arParams);

            return (rowsAffected > -1);
        }

        public static bool DeleteByItem(Guid itemGuid)
        {
            StringBuilder sqlCommand = new StringBuilder();
            sqlCommand.Append("DELETE FROM mp_CategoryItem ");
            sqlCommand.Append("WHERE ");
            sqlCommand.Append("ItemGuid = @ItemGuid ");
            sqlCommand.Append(";");
            FbParameter[] arParams = new FbParameter[1];

            arParams[0] = new FbParameter("@ItemGuid", FbDbType.Char, 36);
            arParams[0].Direction = ParameterDirection.Input;
            arParams[0].Value = itemGuid.ToString();


            int rowsAffected = FBSqlHelper.ExecuteNonQuery(
                GetWriteConnectionString(),
                sqlCommand.ToString(),
                arParams);

            return (rowsAffected > -1);
        }

        public static bool DeleteByExtraGuid(Guid extraGuid)
        {
            StringBuilder sqlCommand = new StringBuilder();
            sqlCommand.Append("DELETE FROM mp_CategoryItem ");
            sqlCommand.Append("WHERE ");
            sqlCommand.Append("ExtraGuid = @ExtraGuid ");
            sqlCommand.Append(";");
            FbParameter[] arParams = new FbParameter[1];

            arParams[0] = new FbParameter("@ExtraGuid", FbDbType.Char, 36);
            arParams[0].Direction = ParameterDirection.Input;
            arParams[0].Value = extraGuid.ToString();


            int rowsAffected = FBSqlHelper.ExecuteNonQuery(
                GetWriteConnectionString(),
                sqlCommand.ToString(),
                arParams);

            return (rowsAffected > -1);
        }

        public static bool DeleteByCategory(Guid categoryGuid)
        {
            StringBuilder sqlCommand = new StringBuilder();
            sqlCommand.Append("DELETE FROM mp_CategoryItem ");
            sqlCommand.Append("WHERE ");
            sqlCommand.Append("CategoryGuid = @CategoryGuid ");
            sqlCommand.Append(";");
            FbParameter[] arParams = new FbParameter[1];

            arParams[0] = new FbParameter("@CategoryGuid", FbDbType.Char, 36);
            arParams[0].Direction = ParameterDirection.Input;
            arParams[0].Value = categoryGuid.ToString();


            int rowsAffected = FBSqlHelper.ExecuteNonQuery(
                GetWriteConnectionString(),
                sqlCommand.ToString(),
                arParams);

            return (rowsAffected > -1);
        }

        public static bool DeleteByModule(Guid moduleGuid)
        {
            StringBuilder sqlCommand = new StringBuilder();
            sqlCommand.Append("DELETE FROM mp_CategoryItem ");
            sqlCommand.Append("WHERE ");
            sqlCommand.Append("ModuleGuid = @ModuleGuid ");
            sqlCommand.Append(";");
            FbParameter[] arParams = new FbParameter[1];

            arParams[0] = new FbParameter("@ModuleGuid", FbDbType.Char, 36);
            arParams[0].Direction = ParameterDirection.Input;
            arParams[0].Value = moduleGuid.ToString();


            int rowsAffected = FBSqlHelper.ExecuteNonQuery(
                GetWriteConnectionString(),
                sqlCommand.ToString(),
                arParams);

            return (rowsAffected > -1);
        }

        public static bool DeleteByFeature(Guid featureGuid)
        {
            StringBuilder sqlCommand = new StringBuilder();
            sqlCommand.Append("DELETE FROM mp_CategoryItem ");
            sqlCommand.Append("WHERE ");
            sqlCommand.Append("FeatureGuid = @FeatureGuid ");
            sqlCommand.Append(";");
            FbParameter[] arParams = new FbParameter[1];

            arParams[0] = new FbParameter("@FeatureGuid", FbDbType.Char, 36);
            arParams[0].Direction = ParameterDirection.Input;
            arParams[0].Value = featureGuid.ToString();


            int rowsAffected = FBSqlHelper.ExecuteNonQuery(
                GetWriteConnectionString(),
                sqlCommand.ToString(),
                arParams);

            return (rowsAffected > -1);
        }

        public static bool DeleteBySite(Guid siteGuid)
        {
            StringBuilder sqlCommand = new StringBuilder();
            sqlCommand.Append("DELETE FROM mp_CategoryItem ");
            sqlCommand.Append("WHERE ");
            sqlCommand.Append("SiteGuid = @SiteGuid ");
            sqlCommand.Append(";");
            FbParameter[] arParams = new FbParameter[1];

            arParams[0] = new FbParameter("@SiteGuid", FbDbType.Char, 36);
            arParams[0].Direction = ParameterDirection.Input;
            arParams[0].Value = siteGuid.ToString();


            int rowsAffected = FBSqlHelper.ExecuteNonQuery(
                GetWriteConnectionString(),
                sqlCommand.ToString(),
                arParams);

            return (rowsAffected > -1);
        }

    }
}
