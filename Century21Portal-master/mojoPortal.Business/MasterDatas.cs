using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using mojoPortal.Data;
using System.Data;


namespace mojoPortal.Business
{
    public class MasterDatas
    {

        #region Properties and Variables

        
        
        private int modId = -1;

        public int Id { get; set; }

        public string Title { get; set; }

        public int ModuleType { get; set; }
        public int CreatedBy { get; set; }
        public int UpdatedBy { get; set; }
        #endregion Properties and Variables
        #region Constructors

        public MasterDatas()
		{}

        #endregion


        #region Static Methods
        public static DataTable SelectType(
    int masterDataTypeId,
            int pageNumber,
            int pageSize,
    out int totalCount)
        {
            return dbMasterData.SelectType(
                masterDataTypeId,
                pageNumber,
            pageSize,
                out totalCount);
        }

        public static DataTable SelectMasterDataForCourse
            (int masterDataTypeId)
        {
            return dbMasterData.SelectMasterDataForCourse(
                masterDataTypeId);
        }
        #endregion

        public bool Save()
        {
            return Id > -1 ? Update() : Create();
        }

        private bool Update()
        {
            bool result = dbMasterData.UpdateMasterData(Id, Title, UpdatedBy, ModuleType);
            
            return result;
        }

        private bool Create()
        {
            int newId = 0;

            newId = dbMasterData.AddMasterData(Title, CreatedBy, ModuleType);

            
            return (newId > 0);
        }

        public bool Delete(int mId)
        {
            bool result = dbMasterData.DeleteMasterData(mId, ModuleType);


            return result;

        }
    }
}
