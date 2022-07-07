/****** Object:  UserDefinedTableType [dbo].[NAPaymentModeSettingType]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[NAPaymentModeSettingType]
GO
/****** Object:  UserDefinedTableType [dbo].[NAPaymentModeSettingType]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[NAPaymentModeSettingType] AS TABLE(
	[SettingId] [int] NULL,
	[SchemeId] [varchar](50) NULL,
	[IsPaymentModeRequired] [tinyint] NULL
)
GO
