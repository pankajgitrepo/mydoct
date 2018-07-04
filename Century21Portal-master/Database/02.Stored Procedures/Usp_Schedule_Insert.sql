IF EXISTS (SELECT name FROM sysobjects WHERE name = 'Usp_Schedule_Insert' AND type = 'P')
BEGIN
  DROP PROCEDURE Usp_Schedule_Insert
END
GO

CREATE PROCEDURE [dbo].[Usp_Schedule_Insert]
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
@UpdatedOn datetime,
@CreatedBy int,
@UpdatedBy int 
AS
INSERT INTO Usr_TblSchedule
(
ScheduleGuid, 
ScheduleDate,
Title,
[Description],
InstructorIds,
InstructorNames,
AudienceIds,
AudienceNames,
ScheduleLength,
ScheduleAccess,
URL,
TuitionFee,
UpdatedOn,
CreatedBy,
UpdatedBy 
)
VALUES
(
@ScheduleGuid, 
@ScheduleDate,
@Title,
@Description,
@InstructorIds,
@InstructorNames,
@AudienceIds,
@AudienceNames,
@ScheduleLength,
@ScheduleAccess,
@URL,
@TuitionFee,
@UpdatedOn,
@CreatedBy,
@UpdatedBy 
)
SELECT @@Identity As ScheduleID
GO