/****** Object:  Table [dbo].[DYNAMIC_REPORT_1900_01_01_2022_07_06_EDUI006ASS]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DYNAMIC_REPORT_1900_01_01_2022_07_06_EDUI006ASS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DYNAMIC_REPORT_1900_01_01_2022_07_06_EDUI006ASS](
	[OptionsGranted] [numeric](38, 0) NULL,
	[OptionsVested] [numeric](38, 0) NULL,
	[OptionsExercised] [numeric](38, 0) NOT NULL,
	[OptionsCancelled] [numeric](38, 0) NOT NULL,
	[OptionsLapsed] [numeric](38, 0) NULL,
	[OptionsUnVested] [numeric](38, 0) NOT NULL,
	[Pending For Approval] [numeric](38, 0) NOT NULL,
	[GrantOptionId] [varchar](100) NOT NULL,
	[GrantLegId] [decimal](10, 0) NOT NULL,
	[SchemeId] [varchar](50) NULL,
	[GrantRegistrationId] [varchar](20) NULL,
	[Employeeid] [varchar](20) NOT NULL,
	[employeename] [varchar](75) NULL,
	[SBU] [varchar](200) NULL,
	[AccountNo] [varchar](20) NULL,
	[PANNumber] [varchar](10) NULL,
	[Entity] [varchar](200) NULL,
	[Status] [varchar](9) NOT NULL,
	[GrantDate] [datetime] NOT NULL,
	[Vesting Type] [varchar](17) NOT NULL,
	[ExercisePrice] [numeric](18, 9) NULL,
	[VestingDate] [datetime] NULL,
	[ExpirayDate] [datetime] NULL,
	[Parent_Note] [varchar](3) NOT NULL,
	[UnvestedCancelled] [numeric](38, 0) NOT NULL,
	[VestedCancelled] [numeric](38, 0) NOT NULL,
	[INSTRUMENT_NAME] [nvarchar](500) NULL,
	[CurrencyName] [varchar](50) NULL,
	[COST_CENTER] [varchar](200) NULL,
	[Department] [varchar](200) NULL,
	[Location] [varchar](200) NULL,
	[EmployeeDesignation] [varchar](200) NULL,
	[Grade] [varchar](200) NULL,
	[ResidentialStatus] [char](1) NULL,
	[CountryName] [varchar](50) NULL,
	[CurrencyAlias] [varchar](50) NULL,
	[MIT_ID] [int] NOT NULL,
	[CancellationReason] [varchar](1) NOT NULL
) ON [PRIMARY]
END
GO
