USE [mojoportaldb]
GO

/****** Object:  StoredProcedure [dbo].[Usp_Course_Create]    Script Date: 7/31/2015 11:17:59 AM ******/
DROP PROCEDURE [dbo].[Usp_Course_Create]
GO

/****** Object:  StoredProcedure [dbo].[Usp_Course_Create]    Script Date: 7/31/2015 11:17:59 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[Usp_Course_Create]

/*

Author:   			Pawan Majage
Created: 			05-20-2015
Last Modified: 		05-20-2015
*/
@CourseGuid uniqueidentifier,
@CourseName nvarchar(100),
@Description nvarchar(500),
@LeadInstructor nvarchar(50),
@CourseLength varchar(30),
@AudienceIds varchar(250),
@Audience varchar(max),
@Delivery varchar(50),
@Cost varchar(20),
@UrlLink nvarchar(250),
@ScheduleType varchar(20),
@FilterCategory nvarchar(250),
@Metatags nvarchar(250),
@Active bit,
@ModuleId int,
@FilterIds varchar(250),
@CourseID int output
AS
IF(@CourseID=0)
	Begin
		Insert Into [dbo].[Usr_TblCourses]
		([CourseGuid],[CourseName],[Description],
		[LeadInstructor],[CourseLength],[AudienceIds],[Audience],[Delivery],
		[Cost],[UrlLink],[ScheduleType],
		[FilterCategory],[Metatags],[Active],[IsDeleted],[ModuleId],[FilterIds]
		)
		values
		(@CourseGuid, @CourseName,@Description, 
		@LeadInstructor, @CourseLength, @AudienceIds, @Audience, @Delivery, 
		@Cost, @UrlLink, @ScheduleType, 
		@FilterCategory, @Metatags, @Active, 0,@ModuleId,@FilterIds)

	SELECT @CourseID = SCOPE_IDENTITY()
	END
ELSE
BEGIN
	Update [dbo].[Usr_TblCourses]
	set 
	[CourseName] = @CourseName,
	[Description]= @Description,
		[LeadInstructor]=@LeadInstructor,
		[CourseLength]=@CourseLength,
		[AudienceIds]=@AudienceIds,
		[Audience]=@Audience,
		[Delivery]=@Delivery,
		[Cost]=@Cost,
		[UrlLink]=@UrlLink,
		[ScheduleType]=@ScheduleType,
		[FilterCategory]=@FilterCategory,
		[Metatags]=@Metatags,
		[Active]=@Active,
		[ModuleId]=@ModuleId,
		[FilterIds]=@FilterIds
		Where [CourseID]=@CourseID
END

GO


