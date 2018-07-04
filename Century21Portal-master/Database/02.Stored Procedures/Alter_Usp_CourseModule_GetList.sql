USE [mojoportaldb]
GO

/****** Object:  StoredProcedure [dbo].[Usp_CourseModule_GetList]    Script Date: 15-09-2015 12:41:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[Usp_CourseModule_GetList]


/*
Author:			Pawan
Created:		2015-18-05
Last Modified:	2015-15-09
*/
@UserID int
 
AS

select  distinct A.*,(Select case when (LK.UserID=@UserID and A.CourseID=LK.CourseID) then 'Y' else 'N' end) LikeByThisUser 
from (
		SELECT CS.*, 
		U.LoginName as LeadInstructorUser, 
		Count(CL.CourseID) as Likes,
		(select Count(1) from [dbo].[mp_Comments] where ParentGuid=CS.CourseGuid) CommentsCount

		FROM [dbo].[USR_TBLCOURSES] CS 
		Inner Join [dbo].[MP_USERS] U 
				on CS.[LEADINSTRUCTOR] =U.USERID and CS.Active = 1
		left outer join [dbo].[Usr_TblCourseUserLikes] CL 
				on CL.CourseID = CS.CourseID

		group by CL.CourseID,CS.CourseID, CS.CourseGuid,CS.CourseName ,CS.Description,CS.LeadInstructor,
		CS.CourseLength,CS.AudienceIds,CS.Audience,CS.Delivery,CS.Cost,CS.UrlLink,CS.ScheduleType,
		CS.FilterCategory,CS.Metatags,CS.Active, CS.IsDeleted,CS.ModuleId,CS.FilterIds,U.LoginName
	)A 
	Left Outer Join [dbo].[Usr_TblCourseUserLikes] LK 
			on A.CourseID = LK.CourseID  AND LK.UserID=@UserID


GO