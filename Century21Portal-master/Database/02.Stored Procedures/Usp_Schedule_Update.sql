IF EXISTS (SELECT name FROM sysobjects WHERE name = 'Usp_Schedule_Update' AND type = 'P')
BEGIN
  DROP PROCEDURE Usp_Schedule_Update
END
GO

CREATE PROCEDURE [dbo].[Usp_Schedule_Update]
@ScheduleID int,
@ScheduleGuid uniqueidentifier,
@ScheduleDate datetime,
@Title nvarchar(100),
@Description nvarchar(max),
@InstructorIds varchar(500),
@InstructorNames varchar(2000),
@AudienceIds varchar(500),
@AudienceNames varchar(2000),
@ScheduleLength varchar(50),
@ScheduleAccess varchar(100),
@URL nvarchar(200),
@TuitionFee money,
@IsActive bit,
@UpdatedOn datetime,
@UpdatedBy int 
AS
UPDATE Usr_TblSchedule SET 
ScheduleGuid =  @ScheduleGuid,
ScheduleDate = @ScheduleDate,
Title = @Title,
[Description] = @Description,
InstructorIds = @InstructorIds,
InstructorNames = @InstructorNames,
AudienceIds = @AudienceIds,
AudienceNames = @AudienceNames,
ScheduleLength = @ScheduleLength,
ScheduleAccess = @ScheduleAccess,
URL = @URL,
TuitionFee = @TuitionFee,
UpdatedOn = @UpdatedOn,
UpdatedBy = @UpdatedBy 
WHERE ScheduleID = @ScheduleID
GO