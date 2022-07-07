/****** Object:  Table [dbo].[ManageAccleratedVesting]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ManageAccleratedVesting]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ManageAccleratedVesting](
	[TNSID] [numeric](10, 0) NOT NULL,
	[SchemeID] [numeric](10, 0) NOT NULL,
	[AccleratedDate] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
