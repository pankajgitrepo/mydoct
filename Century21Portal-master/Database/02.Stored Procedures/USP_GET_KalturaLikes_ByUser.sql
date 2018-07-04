USE [mojoportaldb]
GO

/****** Object:  StoredProcedure [dbo].[USP_GET_KalturaLikes_ByUser]    Script Date: 6/24/2015 6:07:07 PM ******/
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'USP_GET_KalturaLikes_ByUser' AND type = 'P')
DROP PROCEDURE [dbo].[USP_GET_KalturaLikes_ByUser]
GO

/****** Object:  StoredProcedure [dbo].[USP_GET_KalturaLikes_ByUser]    Script Date: 6/24/2015 6:07:07 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--USP_GET_KalturaLikes_ByUser '1_oc8yy5nc', 1
CREATE PROCEDURE [dbo].[USP_GET_KalturaLikes_ByUser] 

@MediaID nvarchar(20),
@UserID int

AS
BEGIN

Declare @MediaGUID uniqueidentifier;
Declare @Likes int;
Declare @LikeByThisUser char(1);

SELECT @MediaGUID = [MediaGUID] FROM [dbo].[Usr_TblKalturaMediaMapping] WHERE [MediaID]=@MediaID;

SELECT @Likes = count(1) from [dbo].[Usr_TblKalturaUserLikes] KL where KL.Mediaguid=@MediaGUID


SELECT @LikeByThisUser= (case when (KL.UserID=@UserID and KL.Mediaguid=@MediaGUID) then 'Y' else 'N' end) 
 FROM [dbo].[Usr_TblKalturaUserLikes] KL where KL.Mediaguid=@MediaGUID and KL.UserID = @UserID

 select @Likes Likes, @LikeByThisUser LikeByThisUser

 END
GO


