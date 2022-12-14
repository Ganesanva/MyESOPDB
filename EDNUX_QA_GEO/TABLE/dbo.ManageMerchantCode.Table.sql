/****** Object:  Table [dbo].[ManageMerchantCode]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ManageMerchantCode]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ManageMerchantCode](
	[GrantRegistrationId] [varchar](20) NOT NULL,
	[MLFV_ID] [int] NULL,
	[MerchantCode] [varchar](20) NULL,
	[CreatedBy] [varchar](20) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [varchar](20) NULL,
	[LastUpdatedOn] [datetime] NULL
) ON [PRIMARY]
END
GO
