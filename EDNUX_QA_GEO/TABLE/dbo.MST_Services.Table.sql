/****** Object:  Table [dbo].[MST_Services]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MST_Services]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MST_Services](
	[MS_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[PageName] [nvarchar](250) NULL,
	[IsActive] [bit] NULL,
	[CREATED_BY] [nvarchar](50) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [nvarchar](50) NULL,
	[UPDATED_ON] [datetime] NULL
) ON [PRIMARY]
END
GO
