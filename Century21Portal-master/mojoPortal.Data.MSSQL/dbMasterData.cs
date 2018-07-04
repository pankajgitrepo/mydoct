using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Configuration;

namespace mojoPortal.Data
{
    public static class dbMasterData
    {
        public static bool DeleteMasterData(int mId, int moduleType)
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "Usr_MasterData_Delete", 2);
            sph.DefineSqlParameter("@MasterDataID", SqlDbType.Int, ParameterDirection.Input, mId);
            sph.DefineSqlParameter("@ModuleType", SqlDbType.Int, ParameterDirection.Input, moduleType);
            int rowsAffected = sph.ExecuteNonQuery();
            return (rowsAffected > -1);
        }

        public static int AddMasterData(string title, int createdBy, int moduleType)
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "Usr_MasterData_Insert", 3);

            sph.DefineSqlParameter("@Title", SqlDbType.VarChar,255, ParameterDirection.Input, title);
            sph.DefineSqlParameter("@UpdatedBy", SqlDbType.Int, ParameterDirection.Input, createdBy);
            sph.DefineSqlParameter("@ModuleType", SqlDbType.Int, ParameterDirection.Input, moduleType);

            int newID = Convert.ToInt32(sph.ExecuteScalar());

            return newID;
        }

        public static bool UpdateMasterData(int id, string title, int updatedBy, int moduleType)
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "Usr_MasterData_Update", 4);
            sph.DefineSqlParameter("@MasterDataID", SqlDbType.Int, ParameterDirection.Input, id);
            sph.DefineSqlParameter("@Title", SqlDbType.VarChar, ParameterDirection.Input, title);
            sph.DefineSqlParameter("@UpdatedBy", SqlDbType.Int, ParameterDirection.Input, updatedBy);
            sph.DefineSqlParameter("@ModuleType", SqlDbType.Int, ParameterDirection.Input, moduleType);
            int rowsAffected = sph.ExecuteNonQuery();
            return (rowsAffected > -1);
        }

        /// <summary>
        /// Gets a count of rows in the mp_Modules table.
        /// </summary>
        public static int GetCount(int masterDataTypeId)
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "Usr_MasterData_GetCount", 1);
            sph.DefineSqlParameter("@MasterDataTypeID", SqlDbType.Int, ParameterDirection.Input, masterDataTypeId);
            
            return Convert.ToInt32(sph.ExecuteScalar());
        }

        public static DataTable SelectType(
            int masterDataTypeId,
            int pageNumber,
            int pageSize,
            out int totalPages)
        {
            totalPages = 1;
            int totalRows = GetCount(masterDataTypeId);

            if (pageSize > 0) totalPages = totalRows / pageSize;

            if (totalRows <= pageSize)
            {
                totalPages = 1;
            }
            else
            {
                int remainder;
                Math.DivRem(totalRows, pageSize, out remainder);
                if (remainder > 0)
                {
                    totalPages += 1;
                }
            }

            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "Usr_MasterData_Select", 3);
            sph.DefineSqlParameter("@MasterDataTypeID", SqlDbType.Int, ParameterDirection.Input, masterDataTypeId);
            sph.DefineSqlParameter("@PageNumber", SqlDbType.Int, ParameterDirection.Input, pageNumber);
            sph.DefineSqlParameter("@PageSize", SqlDbType.Int, ParameterDirection.Input, pageSize);
           

            DataTable dt = new DataTable();
            dt.Columns.Add("Id", typeof(int));
            dt.Columns.Add("Title", typeof(String));
            dt.Columns.Add("IsActive", typeof(String));


            using (IDataReader reader = sph.ExecuteReader())
            {
                while (reader.Read())
                {
                    DataRow row = dt.NewRow();
                    row["Id"] = reader["Id"];
                    row["Title"] = reader["Title"];
                    row["IsActive"] = reader["IsActive"];

                    dt.Rows.Add(row);

                }

            }

            return dt;

        }

        public static DataTable SelectMasterDataForCourse(
            int masterDataTypeId
            )
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "Usr_MasterData_SelectAll", 1);
            sph.DefineSqlParameter("@MasterDataTypeID", SqlDbType.Int, ParameterDirection.Input, masterDataTypeId);
            
            DataTable dt = new DataTable();
            dt.Columns.Add("Id", typeof(int));
            dt.Columns.Add("Title", typeof(String));
            dt.Columns.Add("IsActive", typeof(String));


            using (IDataReader reader = sph.ExecuteReader())
            {
                while (reader.Read())
                {
                    DataRow row = dt.NewRow();
                    row["Id"] = reader["Id"];
                    row["Title"] = reader["Title"];
                    row["IsActive"] = reader["IsActive"];

                    dt.Rows.Add(row);

                }

            }

            return dt;
        }
    }
}
