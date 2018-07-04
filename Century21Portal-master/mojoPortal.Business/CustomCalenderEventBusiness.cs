using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using mojoPortal.Data;
using System.Data;

namespace mojoPortal.Business
{
    public class CustomCalenderEventBusiness
    {
        public static DataSet GetEvents(int moduleId, DateTime beginDate, DateTime endDate)
        {
            return dbCalenderEventCustom.GetEvents(moduleId, beginDate, endDate);
        }

        public static DataSet GetEventsByGroups(int moduleId, DateTime beginDate, DateTime endDate)
        {
            return dbCalenderEventCustom.GetEventsByGroups(moduleId, beginDate, endDate);
        }

        public static List<KeyValuePair<string, int>> GetModuleID(string moduleName)
        {

            List<int> lst = new List<int>();
            List<KeyValuePair<string, int>> kvpList = new List<KeyValuePair<string, int>>();
            using (IDataReader reader = dbCalenderEventCustom.GetModuleID(moduleName))
            {
                while (reader.Read())
                {
                    kvpList.Insert(0, new KeyValuePair<string, int>("ModuleID", Convert.ToInt32(reader["ModuleID"])));
                    kvpList.Insert(1, new KeyValuePair<string, int>("PageID", Convert.ToInt32(reader["PageID"])));
                }
            }
            return kvpList;
        }
    }
}
