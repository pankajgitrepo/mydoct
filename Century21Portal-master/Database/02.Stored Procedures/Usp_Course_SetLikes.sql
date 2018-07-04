USE [mojoportaldb]
GO

/****** Object:  StoredProcedure [dbo].[Usp_Course_SetLikes]    Script Date: 6/24/2015 5:19:53 PM ******/
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'Usp_Course_SetLikes' AND type = 'P')
BEGIN
	DROP PROCEDURE [dbo].[Usp_Course_SetLikes]
END
GO

/****** Object:  StoredProcedure [dbo].[Usp_Course_SetLikes]    Script Date: 6/24/2015 5:19:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Usp_Course_SetLikes]
/*
Author:   			Pawan Majage
Created: 			05-25-2015
Last Modified: 		05-25-2015
*/
@CourseID int,
@UserID int

AS
IF NOT EXISTS(SELECT * FROM [dbo].[Usr_TblCourseUserLikes] WHERE COURSEID=@CourseID AND USERID=@UserID)
BEGIN
	Insert into [dbo].[Usr_TblCourseUserLikes]
	Values(@CourseID, @UserID, GETDATE())
END
GO


