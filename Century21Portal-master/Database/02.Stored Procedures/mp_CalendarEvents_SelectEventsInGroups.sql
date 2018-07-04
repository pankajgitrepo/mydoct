USE [mojoportaldb]
GO

/****** Object:  StoredProcedure [dbo].[mp_CalendarEvents_SelectEventsInGroups]    Script Date: 11-06-2015 10:07:28 ******/
DROP PROCEDURE [dbo].[mp_CalendarEvents_SelectEventsInGroups]
GO

/****** Object:  StoredProcedure [dbo].[mp_CalendarEvents_SelectEventsInGroups]    Script Date: 11-06-2015 10:07:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[mp_CalendarEvents_SelectEventsInGroups]

/*
Author:   			Joe Audette
Created: 			4/10/2005
Last Modified: 		2008-01-27

*/

@ModuleID		int,
@BeginDate		datetime,
@EndDate		datetime

AS

--Declare @TotalCount int;

--SELECT @TotalCount = count(EventDate)  FROM [dbo].[mp_CalendarEvents] group by EventDate

SELECT
 Title, ItemID, ModuleID, StartTime, EndTime,Location, EventDate
 FROM [dbo].[mp_CalendarEvents]
 WHERE	ModuleID = @ModuleID
		AND (EventDate >= @BeginDate)
		AND (EventDate <= @EndDate)
GROUP BY EventDate, Title, StartTime, EndTime,Location, ItemID, ModuleID
ORDER BY EventDate
 
SELECT count(EventDate) as DateCount, EventDate FROM [dbo].[mp_CalendarEvents]
WHERE	ModuleID = @ModuleID
		AND (EventDate >= @BeginDate)
		AND (EventDate <= @EndDate)
 group by EventDate





GO


