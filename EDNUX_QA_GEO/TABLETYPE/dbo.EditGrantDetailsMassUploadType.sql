/****** Object:  UserDefinedTableType [dbo].[EditGrantDetailsMassUploadType]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[EditGrantDetailsMassUploadType]
GO
/****** Object:  UserDefinedTableType [dbo].[EditGrantDetailsMassUploadType]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[EditGrantDetailsMassUploadType] AS TABLE(
	[ID] [numeric](10, 0) NULL,
	[EMPLOYEEID] [varchar](20) NULL,
	[EMPLOYEENAME] [varchar](max) NULL,
	[GRANTREGISTRATIONID] [varchar](20) NULL,
	[GRANTOPTIONID] [varchar](100) NULL,
	[VESTINGPERIODID] [numeric](18, 0) NULL,
	[COUNTER] [numeric](18, 0) NULL,
	[PARENT] [char](1) NULL,
	[VESTINGTYPE] [char](1) NULL,
	[GRANTDATE] [datetime] NULL,
	[EXERCISEPRICE] [numeric](10, 2) NULL,
	[OPTIONSGRANTED] [numeric](18, 0) NULL,
	[VESTINGDATE] [datetime] NULL,
	[EXPIRYDATE] [datetime] NULL
)
GO
