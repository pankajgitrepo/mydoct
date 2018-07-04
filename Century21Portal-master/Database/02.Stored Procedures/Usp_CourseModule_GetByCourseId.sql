USE [mojoportaldb]
GO

/****** Object:  StoredProcedure [dbo].[Usp_CourseModule_GetByCourseId]    Script Date: 6/24/2015 5:20:37 PM ******/
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'Usp_CourseModule_GetByCourseId' AND type = 'P')
BEGIN
	DROP PROCEDURE [dbo].[Usp_CourseModule_GetByCourseId]
END
GO

/****** Object:  StoredProcedure [dbo].[Usp_CourseModule_GetByCourseId]    Script Date: 6/24/2015 5:20:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Usp_CourseModule_GetByCourseId]

/*
Author:			Pawan
Created:		2015-18-05
Last Modified:	2015-18-05
*/

@CourseId int

AS

Select CS.* from [dbo].[Usr_TblCourses] CS
Where CS.CourseID  = @CourseId
GO


