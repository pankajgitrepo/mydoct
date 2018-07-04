IF EXISTS (SELECT name FROM sysobjects WHERE name = 'Usp_KalturaMedia_SetFavourites' AND type = 'P')
BEGIN
  DROP PROCEDURE Usp_KalturaMedia_SetFavourites
END
GO

--[dbo].[Usp_KalturaMedia_SetFavourites] '1_ra8t8647', 1

CREATE PROCEDURE [dbo].[Usp_KalturaMedia_SetFavourites] 

/*

Author:   			Manoj Dhepe

Created: 			14-07-2015

Last Modified: 		14-07-2015

*/

@MediaID nvarchar(20),

@UserID int



AS



Declare @MediaGUID uniqueidentifier



EXEC [dbo].[Usp_KalturaMedia_GetGuid] @MediaID, NULL



SELECT @MediaGUID = [MediaGUID] FROM [dbo].[Usr_TblKalturaMediaMapping] WHERE [MediaID]=@MediaID;



Insert into [dbo].[Usr_TblKalturaUserFavourites]

Values(@MediaGUID, @UserID, GETDATE());