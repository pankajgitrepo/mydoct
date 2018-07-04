USE [mojoportaldb]
GO

/****** Object:  StoredProcedure [dbo].[USP_Users_GetInstructors] 1   Script Date: 6/17/2015 10:53:19 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[USP_Users_GetInstructors]


@SiteID		int

AS
SELECT  
    U.UserID,
	LoginName,
    Email,
    PasswordSalt,
	Pwd

FROM
    [dbo].mp_Users U INNER JOIN mp_userroles UR on U.UserID = UR.UserID 
	AND UR.RoleID = (select RoleID from mp_roles where RoleName like '%Instructor%')

WHERE SiteID = @SiteID
    
ORDER BY Email



GO


