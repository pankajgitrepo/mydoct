USE [mojoportaldb]
GO

/****** Object:  StoredProcedure [dbo].[Usp_KalturaMedia_GetGuid]    Script Date: 6/24/2015 6:10:38 PM ******/
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'Usp_KalturaMedia_GetGuid' AND type = 'P')
BEGIN
	DROP PROCEDURE [dbo].[Usp_KalturaMedia_GetGuid]
END
GO

/****** Object:  StoredProcedure [dbo].[Usp_KalturaMedia_GetGuid]    Script Date: 6/24/2015 6:10:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*

Author:   			Pawan Majage
Created: 			06-03-2015
Last Modified: 		06-03-2015
*/

CREATE PROCEDURE [dbo].[Usp_KalturaMedia_GetGuid]

@MediaID varchar(20),
@MediaGuid uniqueidentifier output

AS
DECLARE @CNT int;

SELECT @CNT = COUNT(1) FROM [dbo].[Usr_TblKalturaMediaMapping] WHERE [MediaID]=@MediaID

IF @CNT >0
	BEGIN
	SELECT @MediaGuid= [MediaGUID] FROM [dbo].[Usr_TblKalturaMediaMapping] WHERE [MediaID]=@MediaID
	END
ELSE
	BEGIN
	INSERT INTO [dbo].[Usr_TblKalturaMediaMapping]
	VALUES(@MediaID, 	NEWID()	, GETDATE())

	SELECT @MediaGuid= [MediaGUID] FROM [dbo].[Usr_TblKalturaMediaMapping] WHERE [MediaID]=@MediaID
	--PRINT 'ELSEPART'
	END


GO


