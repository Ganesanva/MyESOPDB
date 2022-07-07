/****** Object:  Table [dbo].[shfmvMails]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[shfmvMails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[shfmvMails](
	[VestingDate] [datetime] NULL,
	[PriceDate] [datetime] NULL,
	[GrantRegistrationId] [varchar](20) NULL,
	[VestingId] [varchar](20) NULL,
	[FMVPrice] [numeric](18, 2) NULL,
	[IsMailSent] [char](1) NULL
) ON [PRIMARY]
END
GO
