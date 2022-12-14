/****** Object:  Table [dbo].[AuditTrailForEditGrantMassUpload]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AuditTrailForEditGrantMassUpload]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AuditTrailForEditGrantMassUpload](
	[SNO] [int] IDENTITY(1,1) NOT NULL,
	[DATE] [datetime] NULL,
	[TIMEOFUPLOAD] [datetime] NULL,
	[UPDATEDBY] [varchar](20) NULL,
	[GRANTLEGSERIALNO] [int] NULL,
	[STATUS] [varchar](20) NULL,
	[OLD_EXPIRY_DATE] [datetime] NULL,
	[EXPIRY_DATE] [datetime] NULL,
	[OLD_VESTING_DATE] [datetime] NULL,
	[VESTING_DATE] [datetime] NULL,
	[OLD_GRANTEDOPTIONS] [numeric](10, 0) NULL,
	[GRANTEDOPTIONS] [numeric](10, 0) NULL
) ON [PRIMARY]
END
GO
