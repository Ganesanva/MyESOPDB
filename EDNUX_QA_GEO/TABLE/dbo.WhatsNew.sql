/****** Object:  Table [dbo].[WhatsNew]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WhatsNew]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[WhatsNew](
	[NewsID] [int] IDENTITY(1,1) NOT NULL,
	[DisplayOrder] [varchar](10) NULL,
	[News] [varchar](200) NULL
) ON [PRIMARY]
END
GO
