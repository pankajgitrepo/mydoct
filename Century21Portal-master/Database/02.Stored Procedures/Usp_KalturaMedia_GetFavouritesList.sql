IF EXISTS (SELECT name FROM sysobjects WHERE name = 'Usp_KalturaMedia_GetFavouritesList' AND type = 'P')
BEGIN
  DROP PROCEDURE Usp_KalturaMedia_GetFavouritesList
END
GO

--[dbo].[Usp_KalturaMedia_GetFavouritesList]  1

CREATE PROCEDURE [dbo].[Usp_KalturaMedia_GetFavouritesList] 
/*

Author:   			Manoj Dhepe

Created: 			14-07-2015

Last Modified: 		14-07-2015

*/

@UserID int

AS

DECLARE @listStr VARCHAR(MAX)

SELECT @listStr = COALESCE(@listStr+',' , '') + MediaID from [dbo].[Usr_TblKalturaUserFavourites] KF 
INNER JOIN [dbo].[Usr_TblKalturaMediaMapping] KM on KF.MediaGUID = KM.MediaGUID
 and KF.[UserID]=@UserID

SELECT @listStr as KalturaFavouritesIds