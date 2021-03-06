/********************************************************************************************
*  Object Type:	    Stored Procedures
*  Function:       Procedures to insert, update, delete and select records from Usr_TblKalturaVideo
*  Created By:     Marissa Fernandes 
*  Create Date:    05-August-2015
*  Maintenance Log: 
*  Date          Modified By             Description            
*  ----------    --------------------    ---------------------------------------------------- 

********************************************************************************************/

/****** Object:  StoredProcedure [dbo].[Usp_KalturaVideo_Insert]    Script Date: 08/28/2015 14:28:19 ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Usp_KalturaVideo_Insert]
@EntryId nvarchar(200),
@Name nvarchar(100),
@Tags nvarchar(200),
@Description nvarchar(max),
@ThumnailURL nvarchar(200),
@CreatedBy int,
@ModuleId int 
AS

INSERT INTO Usr_TblKalturaVideo
(
[EntryID], 
[Name],
[Tags],
[Description],
[ThumnailURL],
[CreatedBy],
[ModuleId]
)
VALUES
(
@EntryId, 
@Name,
@Tags,
@Description,
@ThumnailURL,
@CreatedBy,
@ModuleId 
)

SELECT @@Identity As ScheduleID

/****** Object:  StoredProcedure [dbo].[Usp_KalturaVideo_Update]    Script Date: 08/28/2015 14:38:47 ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Usp_KalturaVideo_Update]
@KalturaVideoID int,
@EntryId nvarchar(200),
@Name nvarchar(100),
@Tags nvarchar(200),
@Description nvarchar(max),
@ThumnailURL nvarchar(200),
@UpdatedBy int
AS
UPDATE Usr_TblKalturaVideo SET 
EntryID =  @EntryId,
Name = @Name,
Tags = @Tags,
[Description] = @Description,
ThumnailURL = @ThumnailURL,
UpdatedOn = GetDate(),
UpdatedBy = @UpdatedBy 
WHERE KalturaVideoID = @KalturaVideoID

/****** Object:  StoredProcedure [dbo].[Usp_KalturaVideo_Delete]    Script Date: 08/28/2015 16:14:08 ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Usp_KalturaVideo_Delete]
@KalturaVideoID int
AS
DELETE FROM [Usr_TblKalturaVideo] 
WHERE KalturaVideoID = @KalturaVideoID

/****** Object:  StoredProcedure [dbo].[Usp_KalturaVideo_SelectById]    Script Date: 08/28/2015 13:11:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Usp_KalturaVideo_SelectById]
@EntryId nvarchar(200)
AS
SELECT * FROM [Usr_TblKalturaVideo] WHERE EntryID = @EntryId

/****** Object:  StoredProcedure [dbo].[Usp_Schedule_SelectAll]    Script Date: 08/28/2015 12:59:55 ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Usp_KalturaVideo_SelectAll]
@SortParameter varchar(200),
@SortDirection varchar(50)
AS
DECLARE @P varchar(200)

SET @P = 'SELECT * FROM [dbo].[Usr_TblKalturaVideo] ORDER BY ' + ISNULL(@SortParameter,'CreatedOn') +' '+ ISNULL(@SortDirection,'ASC')

EXECUTE (@P)
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[Usp_KalturaVideo_SelectAllByPage]    Script Date: 09/02/2015 16:33:58 ******/

CREATE PROCEDURE [dbo].[Usp_KalturaVideo_SelectAllByPage]
@SiteId INT,
@PageId int 
AS

SELECT  tab.*,
		m.ModuleTitle,
		m.ViewRoles,
		md.FeatureName

FROM	Usr_TblKalturaVideo tab

JOIN	mp_Modules m
ON		tab.ModuleID = m.ModuleID

JOIN	mp_ModuleDefinitions md
ON		m.ModuleDefID = md.ModuleDefID

JOIN	mp_PageModules pm
ON		pm.ModuleID = m.ModuleID

JOIN	mp_Pages p
ON		p.PageID = pm.PageID

WHERE	p.SiteID = @SiteID
		AND pm.PageID = @PageID

