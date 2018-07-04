USE [mojoportaldb]
GO

/****** Object:  StoredProcedure [dbo].[Usp_KalturaMedia_SetLikes]    Script Date: 6/24/2015 6:11:52 PM ******/
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'Usp_KalturaMedia_SetLikes' AND type = 'P')
BEGIN
	DROP PROCEDURE [dbo].[Usp_KalturaMedia_SetLikes]
END
GO

/****** Object:  StoredProcedure [dbo].[Usp_KalturaMedia_SetLikes]    Script Date: 6/24/2015 6:11:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--[dbo].[Usp_KalturaMedia_SetLikes] '1_ra8t8647', 1
CREATE PROCEDURE [dbo].[Usp_KalturaMedia_SetLikes] 
/*
Author:   			Pawan Majage
Created: 			06-03-2015
Last Modified: 		06-03-2015
*/
@MediaID nvarchar(20),
@UserID int

AS

Declare @MediaGUID uniqueidentifier

EXEC [dbo].[Usp_KalturaMedia_GetGuid] @MediaID, NULL

SELECT @MediaGUID = [MediaGUID] FROM [dbo].[Usr_TblKalturaMediaMapping] WHERE [MediaID]=@MediaID;

Insert into [dbo].[Usr_TblKalturaUserLikes]
Values(@MediaGUID, @UserID, GETDATE());
GO


