/****** Object:  UserDefinedTableType [dbo].[TYPE_INSERTEXERCISED_TAX]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_INSERTEXERCISED_TAX]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_INSERTEXERCISED_TAX]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[TYPE_INSERTEXERCISED_TAX] AS TABLE(
	[COUNTRYID] [int] NULL,
	[TAXHEADING] [varchar](50) NULL,
	[TAXRATE] [decimal](18, 4) NULL,
	[SEQUENCENO] [bigint] NULL,
	[FMVVALUE] [decimal](18, 4) NULL,
	[TENTATIVEFMVVALUE] [decimal](18, 4) NULL,
	[PERQVALUE] [decimal](18, 4) NULL,
	[TENTATIVEPERQVALUE] [decimal](18, 4) NULL,
	[BASISOFTAXATION] [nvarchar](250) NULL,
	[TAX_AMOUNT] [decimal](18, 4) NULL,
	[GRANTLEGSERIALNO] [int] NULL,
	[FROM_DATE] [datetime] NULL,
	[TO_DATE] [datetime] NULL,
	[TAXCALCULATION_BASEDON] [varchar](50) NULL,
	[STOCKVALUE] [decimal](18, 4) NULL,
	[TENTATIVESTOCKVALUE] [decimal](18, 4) NULL,
	[EXERCISE_NO] [int] NULL
)
GO
