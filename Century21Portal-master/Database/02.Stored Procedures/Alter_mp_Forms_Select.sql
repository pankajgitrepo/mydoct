USE [mojoportaldb]
GO

/****** Object:  StoredProcedure [dbo].[mp_Forums_Select]    Script Date: 15-09-2015 17:47:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[mp_Forums_Select]


/*
Author:			Joe Audette
Created:		2004-09-12
Last Modified:	2013-08-18

*/

@ModuleID			int,
@UserID				int

AS


SELECT		f.*,
			u.[Name] AS MostRecentPostUser,
			CASE WHEN s.[SubscribeDate] IS NOT NULL and s.[UnSubscribeDate] IS NULL THEN 1
					Else 0
					End AS Subscribed,
			(SELECT COUNT(*) 
				FROM mp_ForumSubscriptions fs 
				WHERE fs.ForumID = f.ItemID AND fs.UnSubscribeDate IS NULL) AS SubscriberCount

FROM			[dbo].mp_Forums f

LEFT OUTER JOIN	[dbo].mp_Users u
ON			f.MostRecentPostUserID = u.UserID

LEFT OUTER JOIN [dbo].mp_ForumSubscriptions s
on			f.ItemID = s.ForumID and s.UserID = @UserID AND s.UnSubscribeDate IS NULL

WHERE		f.ModuleID	= @ModuleID
			AND f.IsActive = 1

ORDER BY		
--f.SortOrder, f.ItemID
f.title



GO


