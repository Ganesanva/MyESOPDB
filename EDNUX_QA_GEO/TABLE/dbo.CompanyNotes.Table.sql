/****** Object:  Table [dbo].[CompanyNotes]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyNotes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CompanyNotes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PageName] [nvarchar](250) NULL,
	[SectionName] [nvarchar](250) NULL,
	[Note] [nvarchar](max) NULL,
	[UserTypeID] [numeric](18, 0) NULL,
	[LastUpdatedBy] [nvarchar](100) NULL,
	[LastUpdatedOn] [datetime] NULL,
	[MIT_ID] [int] NULL,
	[MESSAGETITLE] [varchar](200) NULL,
	[DISPLAYMESSAGEON] [varchar](100) NULL,
	[DISPLAYFROMDATE] [datetime] NULL,
	[SRNO] [int] NULL,
	[SCHEME_ID] [nvarchar](500) NULL,
	[GRANT_REGISTRATION_ID] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__CompanyNo__UserT__06D7F1EF]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyNotes]'))
ALTER TABLE [dbo].[CompanyNotes]  WITH CHECK ADD FOREIGN KEY([UserTypeID])
REFERENCES [dbo].[UserType] ([UserTypeId])
GO
