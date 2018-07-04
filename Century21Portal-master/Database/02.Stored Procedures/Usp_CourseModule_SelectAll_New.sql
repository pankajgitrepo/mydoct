

select  distinct A.*,(Select case when (LK.UserID=2 and A.CourseID=LK.CourseID) then 'Y' else 'N' end) LikeByThisUser from (
SELECT CS.*, U.LoginName as LeadInstructorUser, Count(CL.CourseID) as Likes
FROM [dbo].[USR_TBLCOURSES] CS 
Inner Join [dbo].[MP_USERS] U on CS.[LEADINSTRUCTOR] =U.USERID and CS.Active = 1
left outer join [dbo].[Usr_TblCourseUserLikes] CL on CL.CourseID = CS.CourseID
group by CL.CourseID,CS.CourseID, CS.CourseGuid,CS.CourseName ,CS.Description,CS.LeadInstructor,
CS.CourseLength,CS.AudienceIds,CS.Audience,CS.Delivery,CS.Cost,CS.UrlLink,CS.ScheduleType,CS.FilterCategory,
CS.Metatags,CS.Active
,U.LoginName

)A Left Outer Join [dbo].[Usr_TblCourseUserLikes] LK on A.CourseID = LK.CourseID  and LK.UserID=2




SELECT * FROM USER_TBLCOURCES
--SELECT * FROM MP_USERS
SELECT * FROM USR_TBLCOURSEUSERLIKES

