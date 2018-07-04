USE [mojoportaldb]
GO
/****** Object:  StoredProcedure [dbo].[Usp_CourseModule_GetList_withPaging]  1,1,4,'News',null   Script Date: 5/27/2015 3:54:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[Usp_CourseModule_GetList_withPaging] 


/*
Author:			Pawan
Created:		2015-18-05
Last Modified:	2015-26-05
*/
@UserID int,
@PageNumber int,
@PageSize int,
@FilterBy varchar,
@SortBy varchar
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

BEGIN
INSERT INTO #PageIndex ( 
Guid
)
SELECT	[CourseGuid]	
FROM [dbo].[Usr_TblCourses]
WHERE Active=1

END


select @TotalRecords=COUNT(1) FROM [dbo].[Usr_TblCourses]
WHERE Active=1



select T1.*,t2.IndexID,@TotalRecords AS TotalRows from (select  distinct A.*,(Select case when (LK.UserID=@UserID and A.CourseID=LK.CourseID) then 'Y' else 'N' end) LikeByThisUser 
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
		CS.FilterCategory,CS.Metatags,CS.Active	,U.LoginName
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