/****** Object:  Table [dbo].[SendMailIdList]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SendMailIdList]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SendMailIdList](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TypeId] [int] NOT NULL,
	[DisplayName] [varchar](50) NOT NULL,
	[EmailAddress] [varchar](50) NOT NULL,
	[TOorCC] [char](10) NOT NULL,
	[CreatedBy] [varchar](100) NOT NULL,
	[CreatedOn] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
