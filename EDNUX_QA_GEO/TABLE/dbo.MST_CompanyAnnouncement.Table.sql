/****** Object:  Table [dbo].[MST_CompanyAnnouncement]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MST_CompanyAnnouncement]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MST_CompanyAnnouncement](
	[CompanyID] [varchar](50) NULL,
	[AnnuncerName] [nvarchar](200) NULL,
	[AnnuncerDesignation] [nvarchar](200) NULL,
	[AnnuncementText] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
