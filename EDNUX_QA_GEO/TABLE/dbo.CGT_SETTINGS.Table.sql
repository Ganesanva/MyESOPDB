/****** Object:  Table [dbo].[CGT_SETTINGS]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CGT_SETTINGS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CGT_SETTINGS](
	[CGT_SETTINGS_Id] [int] IDENTITY(1,1) NOT NULL,
	[MIT_ID] [int] NULL,
	[IS_CGT_ENABLED] [char](1) NULL,
	[CGT_SETTINGS_At] [char](1) NULL,
	[RI_STCG_Rate_WPAN] [numeric](18, 9) NULL,
	[FN_STCG_Rate_WPAN] [numeric](18, 9) NULL,
	[NRI_STCG_Rate_WPAN] [numeric](18, 9) NULL,
	[RI_STCG_Rate_WOPAN] [numeric](18, 9) NULL,
	[FN_STCG_Rate_WOPAN] [numeric](18, 9) NULL,
	[NRI_STCG_Rate_WOPAN] [numeric](18, 9) NULL,
	[RI_LTCG_Rate] [numeric](18, 9) NULL,
	[FN_LTCG_Rate] [numeric](18, 9) NULL,
	[NRI_LTCG_Rate] [numeric](18, 9) NULL,
	[CGT_RI_CGT_Formula] [varchar](500) NULL,
	[FN_CGT_Formula] [varchar](500) NULL,
	[NRI_CGT_Formula] [varchar](500) NULL,
	[CGV_FOR_Decimal_upto] [int] NULL,
	[Short_CGT_Rate_Decimal_upto] [int] NULL,
	[Long_CGT_Rate_Decimal_upto] [int] NULL,
	[CGV_FOR_Rounding_Type] [char](1) NULL,
	[Short_CGT_Rate_Rounding_Type] [char](1) NULL,
	[Long_CGT_Rate_Rounding_Type] [char](1) NULL,
	[LastUpdated_By] [varchar](50) NULL,
	[LastUpdated_On] [datetime] NULL,
	[APPLICABLE_FROM] [datetime] NULL
) ON [PRIMARY]
END
GO
