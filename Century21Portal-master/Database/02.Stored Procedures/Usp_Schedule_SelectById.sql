IF EXISTS (SELECT name FROM sysobjects WHERE name = 'Usp_Schedule_SelectById' AND type = 'P')
BEGIN
  DROP PROCEDURE Usp_Schedule_SelectById
END
GO

CREATE PROCEDURE [dbo].[Usp_Schedule_SelectById]
@ScheduleID int
AS
SELECT * FROM [Usr_TblSchedule] WHERE ScheduleID = @ScheduleID
GO