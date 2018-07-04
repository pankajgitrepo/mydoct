IF EXISTS (SELECT name FROM sysobjects WHERE name = 'Usp_Schedule_SelectAll' AND type = 'P')
BEGIN 
  DROP PROCEDURE Usp_Schedule_SelectAll 
END
GO

CREATE PROCEDURE [dbo].[Usp_Schedule_SelectAll]
@SortParameter varchar(200),
@SortDirection varchar(50),
@IsAdmin bit 
AS
DECLARE @P varchar(200)
IF @IsAdmin = 1
BEGIN
	SET @P = 'SELECT * FROM [dbo].[Usr_TblSchedule] WHERE ScheduleDate >= GETDATE() ORDER BY ' + ISNULL(@SortParameter,'ScheduleDate') +' '+ ISNULL(@SortDirection,'ASC')
END
ELSE	
BEGIN
	SET @P = 'SELECT * FROM [dbo].[Usr_TblSchedule] WHERE ScheduleDate >= GETDATE() ORDER BY ' + ISNULL(@SortParameter,'ScheduleDate') +' '+ ISNULL(@SortDirection,'ASC')
END
EXECUTE (@P)
GO

/*
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'Usp_Schedule_SelectAll_1' AND type = 'P')
BEGIN 
  DROP PROCEDURE Usp_Schedule_SelectAll_1 
END
GO

CREATE PROCEDURE [dbo].[Usp_Schedule_SelectAll_1]
@SortParameter varchar(200),
@SortDirection varchar(50) 
AS
DECLARE @P varchar(200)
SET @P = 'SELECT * FROM [dbo].[Usr_TblSchedule] ORDER BY ' + ISNULL(@SortParameter,'ScheduleDate') +' '+ ISNULL(@SortDirection,'ASC')
EXECUTE (@P)
GO
*/