IF EXISTS (SELECT name FROM sysobjects WHERE name = 'Usp_Schedule_Delete' AND type = 'P')
BEGIN
  DROP PROCEDURE Usp_Schedule_Delete
END
GO

CREATE PROCEDURE [dbo].[Usp_Schedule_Delete]
@ScheduleID int
AS
DELETE FROM [Usr_TblSchedule] 
WHERE ScheduleID = @ScheduleID
GO