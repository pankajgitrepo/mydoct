// Author:					Pawan Majage
// Created:				    2015-06-03
// Last Modified:			2015-06-03
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using mojoPortal.Data;
using System.Data;

namespace mojoPortal.Business
{
    public class KalturaModule
    {
        private string mediaID;

        public string MediaID
        {
            get { return mediaID; }
            set { mediaID = value; }
        }
        private Guid mediaGUID;

        public Guid MediaGUID
        {
            get { return mediaGUID; }
            set { mediaGUID = value; }
        }

        public Guid GetGuidforMedia(string mediaId)
        {
            return dbKalturaMedia.GetGuidforMedia(mediaId);
        }

        public int SetLikeforKalturaMedia(string mediaId, int userId)
        {
            return dbKalturaMedia.SetLikesforKalturaMedia(mediaId, userId);
        }

        public int SetFavouritesforKalturaMedia(string mediaId, int userId)
        {
            return dbKalturaMedia.SetFavouritesforKalturaMedia(mediaId, userId);
        }

        public DataSet GetLikesforVideo(string mediaId, int userId)
        {
            return dbKalturaMedia.GetLikesforVideo(mediaId, userId);
        }

        public IDataReader GetFavouritesVideo(string mediaId, int userId)
        {
            return dbKalturaMedia.GetFavouritesVideo(mediaId,userId);
        }

        public IDataReader GetFavouritesVideoList(int userId)
        {
            return dbKalturaMedia.GetFavouritesVideoList(userId);
        }
    }
}
