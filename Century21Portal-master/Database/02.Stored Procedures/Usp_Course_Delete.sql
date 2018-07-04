USE [mojoportaldb]
GO

/****** Object:  StoredProcedure [dbo].[Usp_Course_Delete]    Script Date: 6/24/2015 5:17:45 PM ******/
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'Usp_Course_Delete' AND type = 'P')
BEGIN
DROP PROCEDURE [dbo].[Usp_Course_Delete]
END
GO

/****** Object:  StoredProcedure [dbo].[Usp_Course_Delete]    Script Date: 6/24/2015 5:17:45 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[Usp_Course_Delete]

/*

Author:   			Pawan Majage
Created: 			06-05-2015
Last Modified: 		06-05-2015
*/

@CourseID INT

AS

Update [dbo].[Usr_TblCourses]
	set IsDeleted = 1 
	Where [CourseID] = @CourseID
GO


