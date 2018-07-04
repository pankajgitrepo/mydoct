USE [mojoportaldb]
GO

--***************Courses Table******************


ALTER TABLE [dbo].[Usr_TblCourses] DROP CONSTRAINT [DF__Usr_TblCo__Filte__768C7B8D]
GO

ALTER TABLE [dbo].[Usr_TblCourses] DROP CONSTRAINT [DF__Usr_TblCo__ISDEL__7D6E8346]
GO

/****** Object:  Table [dbo].[Usr_TblCourses]    Script Date: 7/31/2015 1:08:23 PM ******/
DROP TABLE [dbo].[Usr_TblCourses]
GO

/****** Object:  Table [dbo].[Usr_TblCourses]    Script Date: 7/31/2015 1:08:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING OFF
GO

CREATE TABLE [dbo].[Usr_TblCourses](
	[CourseID] [int] IDENTITY(1,1) NOT NULL,
	[CourseGuid] [uniqueidentifier] NOT NULL,
	[CourseName] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[LeadInstructor] [nvarchar](50) NULL,
	[CourseLength] [varchar](250) NULL,
	[AudienceIds] [varchar](250) NULL,
	[Audience] [varchar](max) NULL,
	[Delivery] [varchar](50) NULL,
	[Cost] [varchar](20) NULL,
	[UrlLink] [nvarchar](250) NULL,
	[ScheduleType] [varchar](20) NULL,
	[FilterCategory] [nvarchar](max) NULL,
	[Metatags] [nvarchar](500) NULL,
	[Active] [bit] NOT NULL,
	[IsDeleted] [bit] NULL,
	[ModuleId] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
SET ANSI_PADDING ON
ALTER TABLE [dbo].[Usr_TblCourses] ADD [FilterIds] [varchar](250) NULL

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Usr_TblCourses] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO

ALTER TABLE [dbo].[Usr_TblCourses] ADD  DEFAULT (NULL) FOR [FilterIds]
GO



--***************Course Comments******************
SET ANSI_PADDING OFF
GO

/****** Object:  Table [dbo].[Usr_CourseComments]    Script Date: 5/14/2015 5:49:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Usr_CourseComments](
	[CourseGUID] [uniqueidentifier] NOT NULL,
	[CommentGUID] [uniqueidentifier] NOT NULL,
) ON [PRIMARY]

GO

--***************Table Course Audience Mapping******************

USE [mojoportaldb]
GO

/****** Object:  Table [dbo].[Usr_TblCourseAudience]    Script Date: 7/30/2015 5:02:46 PM ******/
DROP TABLE [dbo].[Usr_TblCourseAudience]
GO

/****** Object:  Table [dbo].[Usr_TblCourseAudience]    Script Date: 7/30/2015 5:02:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Usr_TblCourseAudience](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DisplayName] [nvarchar](50) NOT NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[UpdatedBy] [varchar](50) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO




--***************Table Course Userwise Likes******************
/****** Object:  Table [dbo].[Usr_TblCourseUserLikes]    Script Date: 5/14/2015 5:55:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Usr_TblCourseUserLikes](
	[CourseID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[LikedOn] [datetime] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

--***************Table Kaltura Media Mapping******************
/****** Object:  Table [dbo].[Usr_TblKalturaMediaMapping]    Script Date: 6/3/2015 4:39:41 PM ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Usr_TblKalturaMediaMapping](
	[MediaID] [nvarchar](20) NOT NULL,
	[MediaGUID] [uniqueidentifier] NOT NULL,
	[CreatedOn] [datetime] NULL
) ON [PRIMARY]

GO

--***************Table Katura Userwise Likes******************
/****** Object:  Table [dbo].[Usr_TblKalturaUserLikes]    Script Date: 6/3/2015 6:09:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Usr_TblKalturaUserLikes](
	[MediaGUID] uniqueidentifier NOT NULL,
	[UserID] [int] NOT NULL,
	[LikedOn] [datetime] NULL
) ON [PRIMARY]

GO


--***************Table Katura Userwise Favourites******************
/****** Object:  Table [dbo].[Usr_TblKalturaUserFavourites]    Script Date: 6/3/2015 6:09:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Usr_TblKalturaUserFavourites](
	[MediaGUID] uniqueidentifier NOT NULL,
	[UserID] [int] NOT NULL,
	[AddedOn] [datetime] NULL
) ON [PRIMARY]

GO

--********************************************--

--***************Table Schedule******************
IF OBJECT_ID('dbo.Usr_TblSchedule', 'U') IS NOT NULL
BEGIN
	DROP TABLE [dbo].[Usr_TblSchedule]
END
GO

CREATE TABLE [dbo].[Usr_TblSchedule](
	[ScheduleID] [int] IDENTITY(1,1) NOT NULL,
	[ScheduleGuid] [uniqueidentifier] NOT NULL,
	[ScheduleDate] [datetime] NOT NULL,
	[Title] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[InstructorIds] [varchar] (500) NULL,
	[InstructorNames] [varchar] (2000) NULL,
	[AudienceIds] [varchar](500) NULL,
	[AudienceNames] [varchar](2000) NULL,
	[ScheduleLength] [varchar](50) NULL,
	[ScheduleAccess] [varchar](100) NULL,
	[URL] [nvarchar](200) NULL,
	[TuitionFee] [money] NULL DEFAULT 0,
	[IsActive] [bit] NOT NULL DEFAULT 1,
	[CreatedOn] [datetime] NOT NULL DEFAULT GETDATE(),
	[UpdatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedBy] [int] NULL
	
 CONSTRAINT [PK_Usr_TblSchedule] PRIMARY KEY CLUSTERED 
(
	[ScheduleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
--********************************************--

--***************Table Katura Videos******************
/****** Object:  Table [dbo].[Usr_TblKalturaVideo]    Script Date: 08/28/2015 11:45:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Usr_TblKalturaVideo](
	[KalturaVideoID] [int] IDENTITY(1,1) NOT NULL,
	[EntryID] [nvarchar](200) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Tags] [nvarchar](200) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ThumnailURL] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NOT NULL,
	[UpdatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedBy] [int] NULL,
	[ModuleId] [int] NULL,
 CONSTRAINT [PK_Usr_TblKalturaVideo] PRIMARY KEY CLUSTERED 
(
	[KalturaVideoID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Usr_TblKalturaVideo] ADD  DEFAULT (getdate()) FOR [CreatedOn]
GO
--********************************************--