/****** Object:  Table [dbo].[EDIT_GRANT_MASSUPLOAD]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EDIT_GRANT_MASSUPLOAD]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EDIT_GRANT_MASSUPLOAD](
	[SRNO] [int] IDENTITY(1,1) NOT NULL,
	[GRANTID] [numeric](10, 0) NULL,
	[EMPLOYEEID] [varchar](20) NULL,
	[EMPLOYEENAME] [varchar](max) NULL,
	[GRANTREGISTRATIONID] [varchar](20) NULL,
	[GRANTOPTIONID] [varchar](100) NOT NULL,
	[VESTINGPERIODID] [numeric](18, 0) NULL,
	[COUNTER] [numeric](18, 0) NULL,
	[PARENT] [char](1) NULL,
	[VESTINGTYPE] [char](1) NULL,
	[GRANTDATE] [datetime] NULL,
	[EXERCISEPRICE] [numeric](10, 2) NULL,
	[OPTIONSGRANTED] [numeric](18, 0) NULL,
	[VESTINGDATE] [datetime] NULL,
	[EXPIRYDATE] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
