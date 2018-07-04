USE [mojoportaldb]
GO

/****** Object:  StoredProcedure [dbo].[Usp_CourseModule_SelectAll]    Script Date: 6/24/2015 5:26:00 PM ******/
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'Usp_CourseModule_SelectAll' AND type = 'P')
BEGIN
	DROP PROCEDURE [dbo].[Usp_CourseModule_SelectAll]
END	
GO

/****** Object:  StoredProcedure [dbo].[Usp_CourseModule_SelectAll]    Script Date: 6/24/2015 5:26:00 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[Usp_CourseModule_SelectAll]


/*
Author:			Pawan
Created:		2015-18-05
Last Modified:	2015-18-05
*/

 
AS

SELECT CS.*, U.LoginName as LeadInstructorUser, Count(CL.CourseID) as Likes--, CL.UserID
--,(Select case when (CL.UserID=1 and CL.CourseID=CS.CourseID) then 'Y' else 'N' end)LikeByUser
FROM [dbo].[USR_TBLCOURSES] CS 
Inner Join [dbo].[MP_USERS] U on CS.[LEADINSTRUCTOR] =U.USERID and CS.Active = 1
left outer join [dbo].[Usr_TblCourseUserLikes] CL on CL.CourseID = CS.CourseID
group by CL.CourseID,CS.CourseID, CS.CourseGuid,CS.CourseName ,CS.Description,CS.LeadInstructor,
CS.CourseLength,CS.AudienceIds,CS.Audience,CS.Delivery,CS.Cost,CS.UrlLink,CS.ScheduleType,CS.FilterCategory,
CS.Metatags,CS.Active--,CL.UserID
,U.LoginName



GO


