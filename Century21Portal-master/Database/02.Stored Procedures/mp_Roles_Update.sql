IF EXISTS (SELECT name FROM sysobjects WHERE name = 'mp_Roles_Update' AND type = 'P')
BEGIN
  DROP PROCEDURE mp_Roles_Update
END
GO

CREATE PROCEDURE [dbo].[mp_Roles_Update]



/*

Last Modified:		5/19/2005 Joe Audette



*/



    

@RoleID      int,

@RoleName    nvarchar(50),

@IsC21Role Bit



AS



UPDATE		mp_Roles



SET

    			DisplayName = @RoleName, IsC21Role = @IsC21Role



WHERE

    			RoleID = @RoleID


