/****** Object:  Table [dbo].[BonusSplitPolicy]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BonusSplitPolicy]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[BonusSplitPolicy](
	[ApplyBonusTo] [char](1) NOT NULL,
	[ApplySplitTo] [char](1) NOT NULL,
	[DisplayAs] [char](1) NOT NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[DisplaySplit] [char](1) NULL
) ON [PRIMARY]
END
GO
