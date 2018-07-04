----ALTER USER UPDATE PROCEDURE-----
USE [mojoportaldb]
GO
/****** Object:  StoredProcedure [dbo].[mp_Users_Update]    Script Date: 05-06-2015 16:34:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[mp_Users_Update]

/*
Author:			Joe Audette
Created:		2004-09-30
Last Modified:	2014-07-23

*/
    
@UserID        			int,   
@Name				nvarchar(100),
@LoginName			nvarchar(50),
@Email           			nvarchar(100),   
@Password    			nvarchar(1000),
@PasswordSalt nvarchar(128),
@Gender			nchar(1),
@ProfileApproved		bit,
@ApprovedForForums		bit,
@Trusted			bit,
@DisplayInMemberList		bit,
@WebSiteURL			nvarchar(100),
@Country			nvarchar(100),
@State				nvarchar(100),
@Occupation			nvarchar(100),
@Interests			nvarchar(100),
@MSN				nvarchar(50),
@Yahoo			nvarchar(50),
@AIM				nvarchar(50),
@ICQ				nvarchar(50),
@AvatarUrl			nvarchar(255),
@Signature			nvarchar(max),
@Skin				nvarchar(100),
@LoweredEmail		nvarchar(100),
@PasswordQuestion		nvarchar(255),
@PasswordAnswer		nvarchar(255),
@Comment		nvarchar(max),
@TimeOffsetHours	int,
@OpenIDURI			nvarchar(255),
@WindowsLiveID			nvarchar(255),
@MustChangePwd bit,
@FirstName     	nvarchar(100),
@LastName     	nvarchar(100),
@TimeZoneId     	nvarchar(32),
@EditorPreference nvarchar(100),
@NewEmail nvarchar(100),
@EmailChangeGuid	uniqueidentifier,
@PasswordResetGuid uniqueidentifier,
@RolesChanged bit,
@AuthorBio nvarchar(max),
@DateOfBirth	datetime,
@PwdFormat int,
@EmailConfirmed bit,
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
UPDATE		mp_Users

SET			[Name] = @Name,
			LoginName = @LoginName,
			Email = @Email,
    			[Pwd] = @Password,
    			MustChangePwd = @MustChangePwd,
			Gender = @Gender,
			ProfileApproved = @ProfileApproved,
			ApprovedForForums = @ApprovedForForums,
			Trusted = @Trusted,
			DisplayInMemberList = @DisplayInMemberList,
			WebSiteURL = @WebSiteURL,
			Country = @Country,
			[State] = @State,
			Occupation = @Occupation,
			Interests = @Interests,
			MSN = @MSN,
			Yahoo = @Yahoo,
			AIM = @AIM,
			ICQ = @ICQ,
			AvatarUrl = @AvatarUrl,
			[Signature] = @Signature,
			Skin = @Skin,
			LoweredEmail = @LoweredEmail,
			PasswordQuestion = @PasswordQuestion,
			PasswordAnswer = @PasswordAnswer,
			Comment = @Comment,
			TimeOffsetHours = @TimeOffsetHours,
			OpenIDURI = @OpenIDURI,
			WindowsLiveID = @WindowsLiveID,
			FirstName = @FirstName,
			LastName = @LastName,
			TimeZoneId = @TimeZoneId,
			EditorPreference = @EditorPreference,
			NewEmail = @NewEmail,
			EmailChangeGuid = @EmailChangeGuid,
			PasswordResetGuid = @PasswordResetGuid,
			PasswordSalt = @PasswordSalt,
			RolesChanged = @RolesChanged,
			AuthorBio = @AuthorBio,
			DateOfBirth = @DateOfBirth,
			PwdFormat = @PwdFormat,
			EmailConfirmed = @EmailConfirmed,
			PasswordHash = @PasswordHash,
			SecurityStamp = @SecurityStamp,
			PhoneNumber = @PhoneNumber,
			PhoneNumberConfirmed = @PhoneNumberConfirmed,
			TwoFactorEnabled = @TwoFactorEnabled,
			LockoutEndDateUtc = @LockoutEndDateUtc,
			City = @City,
			Address1 = @Address1,
			Address2 = @Address2,
			Zip = @Zip,
			AccountId = @AccountId
WHERE		UserID = @UserID