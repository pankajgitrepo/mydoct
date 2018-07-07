USE [mojoportaldb]
GO
/****** Object:  StoredProcedure [dbo].[Usp_KalturaMedia_SetFavourites]    Script Date: 08-07-2018 03:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[dbo].[USP_DEL_KalturaFavourite_ByUser] '1_ra8t8647', 1

ALTER PROCEDURE [dbo].[USP_DEL_KalturaFavourite_ByUser] 

/*

Author:   			Ranjan Biswas

Created: 			08-07-2018

Last Modified: 		08-07-2018

*/

@MediaID nvarchar(20),
@UserID int

AS
Declare @MediaGUID uniqueidentifier

SELECT @MediaGUID = [MediaGUID] FROM [dbo].[Usr_TblKalturaMediaMapping] WHERE [MediaID]=@MediaID;

DELETE FROM [dbo].[Usr_TblKalturaUserFavourites]  WHERE  [dbo].[Usr_TblKalturaUserFavourites].MediaGUID = @MediaGUID AND [dbo].[Usr_TblKalturaUserFavourites].UserID = @UserID
DELETE FROM [dbo].[Usr_TblKalturaMediaMapping] WHERE [MediaGUID]=@MediaGUID

