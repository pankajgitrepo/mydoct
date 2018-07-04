IF EXISTS (SELECT name FROM sysobjects WHERE name = 'Usp_Audince_Select' AND type = 'P')
BEGIN
  DROP PROCEDURE Usp_Audince_Select
END
GO

CREATE PROCEDURE [dbo].[Usp_Audince_Select]



/*

Last Modified:		2012-04-10 Joe Audette



*/

    




AS



SELECT  [ID],[DisplayName]

FROM [dbo].[Usr_TblCourseAudience]







