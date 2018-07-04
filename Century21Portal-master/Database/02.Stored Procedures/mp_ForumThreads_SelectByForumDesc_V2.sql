USE [mojoportaldb]
GO

/****** Object:  StoredProcedure [dbo].[mp_ForumThreads_SelectByForumDesc_v2]    Script Date: 15-09-2015 11:36:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[mp_ForumThreads_SelectByForumDesc_v2]

/*
Author:			Joe Audette
Created:		2004-09-25
Last Modified:	2010-04-13

*/


@ForumID			int,
@PageNumber			int

AS

DECLARE @ThreadsPerPage	int
DECLARE @TotalThreads	int

SELECT	@ThreadsPerPage = ThreadsPerPage,
		@TotalThreads = ThreadCount
FROM		mp_Forums
WHERE	ItemID = @ForumID


DECLARE @PageLowerBound int
DECLARE @PageUpperBound int


SET @PageLowerBound = (@ThreadsPerPage * @PageNumber) - @ThreadsPerPage
SET @PageUpperBound = @PageLowerBound + @ThreadsPerPage + 1

CREATE TABLE #PageIndex 
(
	IndexID int IDENTITY (1, 1) NOT NULL,
	ThreadID int
	
)

INSERT INTO #PageIndex (ThreadID)


SELECT	t.ThreadID
FROM		[dbo].mp_ForumThreads t
WHERE	t.ForumID = @ForumID	
ORDER BY t.SortOrder,	t.MostRecentPostDate DESC


SELECT	t.*,
		u.[Name] AS MostRecentPostUser,
		s.[Name] AS StartedBy


FROM		[dbo].mp_ForumThreads t

JOIN		#PageIndex p
ON		p.ThreadID = t.ThreadID

LEFT OUTER JOIN		[dbo].mp_Users u
ON		t.MostRecentPostUserID = u.UserID

LEFT OUTER JOIN		[dbo].mp_Users s
ON		t.StartedByUserID = s.UserID

WHERE	t.ForumID = @ForumID

		

AND p.IndexID > @PageLowerBound 
		AND p.IndexID < @PageUpperBound

ORDER BY	
--t.ThreadSubject
--p.IndexID 
t.SortOrder,	t.MostRecentPostDate DESC
DROP TABLE #PageIndex


GO


