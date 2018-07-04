IF EXISTS (SELECT name FROM sysobjects WHERE name = 'mp_Roles_Select' AND type = 'P')
BEGIN
  DROP PROCEDURE mp_Roles_Select
END
GO

CREATE PROCEDURE [dbo].[mp_Roles_Select]



/*

Last Modified:		2012-04-10 Joe Audette



*/

    

@SiteID  int



AS



SELECT  

r.RoleID,

r.SiteID,

r.RoleName,

r.DisplayName,

r.SiteGuid,

r.RoleGuid,

COUNT(ur.UserID) As MemberCount,

r.[IsC21Role]



FROM		[dbo].mp_Roles r



LEFT OUTER JOIN [dbo].mp_UserRoles ur

ON		ur.RoleID = r.RoleID



WHERE   	r.SiteID = @SiteID



GROUP BY

r.RoleID,

r.SiteID,

r.RoleName,

r.DisplayName,

r.SiteGuid,

r.RoleGuid,

r.[IsC21Role]


ORDER BY r.DisplayName




