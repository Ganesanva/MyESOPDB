/****** Object:  UserDefinedTableType [dbo].[TYPE_TAX_RATE_SETTING_MASSUPLOAD]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_TAX_RATE_SETTING_MASSUPLOAD]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_TAX_RATE_SETTING_MASSUPLOAD]    Script Date: 7/6/2022 1:40:55 PM ******/
CREATE TYPE [dbo].[TYPE_TAX_RATE_SETTING_MASSUPLOAD] AS TABLE(
	[EMPLOYEE_NAME] [nvarchar](250) NULL,
	[EMPLOYEE_ID] [nvarchar](250) NULL,
	[INSTRUMENT_TYPE] [nvarchar](250) NOT NULL,
	[COUNTRY] [nvarchar](250) NULL,
	[STATE] [nvarchar](250) NULL,
	[RESIDENTAL_STATUS] [nvarchar](250) NULL,
	[TAX_HEADING] [nvarchar](250) NOT NULL,
	[TAX_RATE_LIVE_EMPLOYEE] [decimal](18, 2) NOT NULL,
	[TAX_RATE_SEPRATED_EMPLOYEE] [decimal](18, 2) NOT NULL
)
GO
