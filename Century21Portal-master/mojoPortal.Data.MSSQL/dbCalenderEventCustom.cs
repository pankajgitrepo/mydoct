using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace mojoPortal.Data
{
    public class dbCalenderEventCustom
    {
        public static DataSet GetEvents(
                int moduleId,
                DateTime beginDate,
                DateTime endDate)
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "mp_CalendarEvents_SelectByDate", 3);
            sph.DefineSqlParameter("@ModuleID", SqlDbType.Int, ParameterDirection.Input, moduleId);
            sph.DefineSqlParameter("@BeginDate", SqlDbType.DateTime, ParameterDirection.Input, beginDate);
            sph.DefineSqlParameter("@EndDate", SqlDbType.DateTime, ParameterDirection.Input, endDate);
            return sph.ExecuteDataset();
        }

        public static IDataReader GetModuleID(string moduleName)
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "mp_Modules_GetModuleIdByModuleTitle", 1);
            sph.DefineSqlParameter("@ModuleTitle", SqlDbType.VarChar, ParameterDirection.Input, moduleName);
            return sph.ExecuteReader();
        }

        public static DataSet GetEventsByGroups(int moduleId, DateTime beginDate, DateTime endDate)
        {
            SqlParameterHelper sph = new SqlParameterHelper(ConnectionString.GetReadConnectionString(), "mp_CalendarEvents_SelectEventsInGroups", 3);
            sph.DefineSqlParameter("@ModuleID", SqlDbType.Int, ParameterDirection.Input, moduleId);
            sph.DefineSqlParameter("@BeginDate", SqlDbType.DateTime, ParameterDirection.Input, beginDate);
            sph.DefineSqlParameter("@EndDate", SqlDbType.DateTime, ParameterDirection.Input, endDate);
            return sph.ExecuteDataset();
        }
    }
}
