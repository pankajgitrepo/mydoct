USE [mojoportaldb]
GO

/****** Object:  StoredProcedure [dbo].[Usp_CourseModule_GetList_withPagingSorting]    Script Date: 6/24/2015 5:24:57 PM ******/
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'Usp_CourseModule_GetList_withPagingSorting' AND type = 'P')
BEGIN
	DROP PROCEDURE [dbo].[Usp_CourseModule_GetList_withPagingSorting]
END
GO

/****** Object:  StoredProcedure [dbo].[Usp_CourseModule_GetList_withPagingSorting]    Script Date: 6/24/2015 5:24:57 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[Usp_CourseModule_GetList_withPagingSorting] 


/*
Author:			Pawan
Created:		2015-18-05
Last Modified:	2015-26-05
*/
@UserID int,
@PageNumber int,
@PageSize int,
@FilterBy nvarchar(50),
@SortBy varchar(5)
AS

DECLARE @TotalRecords  int
DECLARE @PageLowerBound int
DECLARE @PageUpperBound int



SET @PageLowerBound = (@PageSize * @PageNumber) - @PageSize
SET @PageUpperBound = @PageLowerBound + @PageSize + 1

CREATE TABLE #PageIndex 
(
IndexID int IDENTITY (1, 1) NOT NULL,
Guid UniqueIdentifier
)



IF @SortBy = 'C' --OR @SortBy=''
	BEGIN			
		INSERT INTO #PageIndex ( 
		Guid
		)
		SELECT	[CourseGuid]	
		FROM [dbo].[Usr_TblCourses]
		WHERE Active=1 AND FilterCategory LIKE '%'+ @FilterBy +'%'
		ORDER BY COURSENAME

		SELECT @TotalRecords= COUNT(1) FROM [dbo].[Usr_TblCourses]
		WHERE Active=1 AND FilterCategory LIKE '%'+ @FilterBy +'%'
		--Print @FilterBy
	END
ELSE IF @SortBy='I'
	BEGIN
		INSERT INTO #PageIndex ( 
		Guid
		)
		SELECT	C.[CourseGuid]	
		FROM [dbo].[Usr_TblCourses] C 
		--join [dbo].[mp_Users] U
		--on C.LeadInstructor = U.UserID
		WHERE Active=1 AND FilterCategory LIKE '%'+ @FilterBy +'%'
		ORDER BY C.[LeadInstructor]

		SELECT	@TotalRecords = COUNT(1)	
		FROM [dbo].[Usr_TblCourses] C 
		--join [dbo].[mp_Users] U
		--on C.LeadInstructor = U.UserID
		WHERE Active=1 AND FilterCategory LIKE  '%'+ @FilterBy +'%'
	END
ELSE IF @SortBy=''
	BEGIN
		INSERT INTO #PageIndex ( 
		Guid
		)
		SELECT	[CourseGuid]	
		FROM [dbo].[Usr_TblCourses]
		WHERE Active=1 AND FilterCategory LIKE '%'+ @FilterBy +'%'
		ORDER BY [Audience]

		SELECT @TotalRecords= COUNT(1) FROM [dbo].[Usr_TblCourses]
		WHERE Active=1 AND FilterCategory LIKE '%'+ @FilterBy +'%'
		--Print @FilterBy
	END
--select @TotalRecords=COUNT(1) FROM [dbo].[Usr_TblCourses]
--WHERE Active=1



select T1.*,t2.IndexID,@TotalRecords AS TotalRows from (select  distinct A.*,(Select case when (LK.UserID=@UserID and A.CourseID=LK.CourseID) then 'Y' else 'N' end) LikeByThisUser 
from (
		SELECT CS.*, 
		--U.LoginName as LeadInstructorUser, 
		CS.[LeadInstructor] as LeadInstructorUser, 
		Count(CL.CourseID) as Likes,
		(select Count(1) from [dbo].[mp_Comments] where ParentGuid=CS.CourseGuid) CommentsCount

		FROM [dbo].[USR_TBLCOURSES] CS 
		--Inner Join [dbo].[MP_USERS] U 
		--		on CS.[LEADINSTRUCTOR] =U.USERID and CS.Active = 1 and CS.IsDeleted=0
		left outer join [dbo].[Usr_TblCourseUserLikes] CL 
				on CL.CourseID = CS.CourseID

		group by CL.CourseID,CS.CourseID, CS.CourseGuid,CS.CourseName ,CS.Description,CS.LeadInstructor,
		CS.CourseLength,CS.AudienceIds,CS.Audience,CS.Delivery,CS.Cost,CS.UrlLink,CS.ScheduleType,
		CS.FilterCategory,CS.FilterIds,CS.Metatags,CS.Active,CS.ModuleID,CS.IsDeleted--,U.LoginName
	)A 
	Left Outer Join [dbo].[Usr_TblCourseUserLikes] LK 
			on A.CourseID = LK.CourseID  AND LK.UserID=@UserID
			
			)T1 Join #PageIndex t2 
			

ON			

		t1.[CourseGuid] = t2.[Guid] --and  T1.Audience like '%'+@FilterBy+'%' 
WHERE

		t2.IndexID > @PageLowerBound 

		AND t2.IndexID < @PageUpperBound

		

ORDER BY t2.IndexID


DROP TABLE  #PageIndex
GO


