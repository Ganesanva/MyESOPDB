/****** Object:  UserDefinedTableType [dbo].[TYPE_INSTRUMENT_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_INSTRUMENT_DETAILS]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_INSTRUMENT_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[TYPE_INSTRUMENT_DETAILS] AS TABLE(
	[MIT_ID] [int] NULL,
	[INS_DISPLY_NAME] [nvarchar](1000) NULL,
	[CurrencyID] [int] NULL,
	[MSE_ID] [varchar](200) NULL,
	[SEM_VAL_RPT_ID] [int] NULL,
	[IS_ENABLED] [tinyint] NULL,
	[IsActivatedAccount] [varchar](1) NULL
)
GO
