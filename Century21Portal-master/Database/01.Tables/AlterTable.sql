ALTER TABLE mp_users ADD Address1 nvarchar(250) null DEFAULT(NULL), 
Address2 nvarchar(250) NULL DEFAULT(NULL), 
City nvarchar(100) NULL DEFAULT(NULL), 
Zip varchar(50) NULL DEFAULT(NULL),
AccountId nvarchar(100) NULL DEFAULT(NULL);

----User to make available browse option for user avatar setting.--
UPDATE mp_sitesettingsex SET KeyValue = 'internal'--'gravatar'
WHERE keyname = 'AvatarSystem';
----User to make available browse option for user avatar setting.--
UPDATE mp_sitesettingsexdef SET DefaultValue = 'internal'--'gravatar'
WHERE keyname = 'AvatarSystem';
--Hide question and answer option in user profile
UPDATE mp_sites SET RequiresQuestionAndAnswer = 0
WHERE SiteID = 1

----Role Table Alter Script----
ALTER TABLE [dbo].[mp_Roles] ADD IsC21Role bit null default(0);

--Courses TABLE
Alter table [dbo].[Usr_TblCourses]
Add FilterIds varchar(250) null default(null);