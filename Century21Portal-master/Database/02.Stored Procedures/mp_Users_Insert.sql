----ALTER USER INSERT PROCEDURE-----
USE [mojoportaldb]
GO
/****** Object:  StoredProcedure [dbo].[mp_Users_Insert]    Script Date: 05-06-2015 16:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER Procedure [dbo].[mp_Users_Insert]

/*
Author:			Joe Audette
Created:		2004-09-30
Last Modified:	2014-07-23

*/

@SiteGuid	uniqueidentifier,
@SiteID	int,
@Name     	nvarchar(100),
@LoginName	nvarchar(50),
@Email    	nvarchar(100),
@Password 	nvarchar(1000),
@PasswordSalt nvarchar(128),
@UserGuid	uniqueidentifier,
@DateCreated datetime,
@MustChangePwd bit,
@FirstName     	nvarchar(100),
@LastName     	nvarchar(100),
@TimeZoneId     	nvarchar(32),
@EmailChangeGuid	uniqueidentifier,
@DateOfBirth	datetime,
@EmailConfirmed bit,
@PwdFormat int,
@PasswordHash nvarchar(max),
@SecurityStamp nvarchar(max),
@PhoneNumber nvarchar(50),
@PhoneNumberConfirmed bit,
@TwoFactorEnabled bit,
@LockoutEndDateUtc datetime,
@City nvarchar(100),
@Address1 nvarchar(250),
@Address2 nvarchar(250),
@Zip varchar(50),
@AccountId nvarchar(100)

AS
INSERT INTO 		mp_Users
(
		SiteGuid,
			SiteID,
    			[Name],
			LoginName,
    			Email,
    			[Pwd],
			UserGuid,
			DateCreated,
			TotalRevenue,
			MustChangePwd,
			RolesChanged,
			FirstName,
			LastName,
			TimeZoneId,
			EmailChangeGuid,
			PasswordResetGuid,
			PasswordSalt,
			DateOfBirth,
			PwdFormat,
			EmailConfirmed,
			PasswordHash,
			SecurityStamp,
			PhoneNumber,
			PhoneNumberConfirmed,
			TwoFactorEnabled,
			LockoutEndDateUtc,
			City,
			Address1,
			Address2,
			Zip,
			AccountId
)

VALUES
(
			@SiteGuid,
			@SiteID,
    			@Name,
			@LoginName,
    			@Email,
    			@Password,
			@UserGuid,
			@DateCreated,
			0,
			@MustChangePwd,
			0,
			@FirstName,
			@LastName,
			@TimeZoneId,
			@EmailChangeGuid,
			'00000000-0000-0000-0000-000000000000',
			@PasswordSalt,
			@DateOfBirth,
			@PwdFormat,
			@EmailConfirmed,
			@PasswordHash,
			@SecurityStamp,
			@PhoneNumber,
			@PhoneNumberConfirmed,
			@TwoFactorEnabled,
			@LockoutEndDateUtc,
			@City,
			@Address1,
			@Address2,
			@Zip,
			@AccountId
)
SELECT		@@Identity As UserID
