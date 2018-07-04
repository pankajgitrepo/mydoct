
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'mp_Roles_Insert' AND type = 'P')
BEGIN
  DROP PROCEDURE mp_Roles_Insert
END
GO

CREATE PROCEDURE [dbo].[mp_Roles_Insert]



/*

Author:			Joe Audette

Created:		7/19/2004

Last Modified:	2008-01-27



*/



@RoleGuid	uniqueidentifier,

@SiteGuid	uniqueidentifier,

@SiteID    		int,

@RoleName    nvarchar(50),

@IsC21Role Bit



AS



INSERT INTO mp_Roles

(

			RoleGuid,

			SiteGuid,

    		SiteID,

    		RoleName,

    		DisplayName,
			
			IsC21Role

)



VALUES

(

		@RoleGuid,

		@SiteGuid,

    	@SiteID,

    	@RoleName,

		@RoleName,

		@IsC21Role

)



SELECT  @@Identity As RoleID


