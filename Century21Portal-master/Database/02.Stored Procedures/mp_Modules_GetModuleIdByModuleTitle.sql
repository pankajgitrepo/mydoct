USE [mojoportaldb]
GO

/****** Object:  StoredProcedure [dbo].[mp_Modules_GetModuleIdByModuleTitle]    Script Date: 11-06-2015 10:08:41 ******/
DROP PROCEDURE [dbo].[mp_Modules_GetModuleIdByModuleTitle]
GO

/****** Object:  StoredProcedure [dbo].[mp_Modules_GetModuleIdByModuleTitle]    Script Date: 11-06-2015 10:08:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[mp_Modules_GetModuleIdByModuleTitle]

/*
Author:   			Tushar Wadhavane
Created: 			2015-05-28

*/

@ModuleTitle varchar(200)

AS

SELECT m.ModuleID, p.PageID FROM [dbo].[mp_Modules] m
INNER JOIN  [dbo].[mp_pagemodules] p ON m.ModuleID = p.ModuleID
WHERE m.[Moduletitle] = @ModuleTitle;	





GO


