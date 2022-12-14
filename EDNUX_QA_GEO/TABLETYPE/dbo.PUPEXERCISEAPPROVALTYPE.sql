/****** Object:  UserDefinedTableType [dbo].[PUPEXERCISEAPPROVALTYPE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[PUPEXERCISEAPPROVALTYPE]
GO
/****** Object:  UserDefinedTableType [dbo].[PUPEXERCISEAPPROVALTYPE]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[PUPEXERCISEAPPROVALTYPE] AS TABLE(
	[EXERCISE ID] [int] NULL,
	[EXERCISE NO] [int] NULL,
	[EMPLOYEE ID] [nvarchar](200) NULL,
	[GRANTLEGSERIALNUMBER] [numeric](10, 0) NULL,
	[EMPLOYEE NAME] [nvarchar](200) NULL,
	[EXERCISE DATE] [date] NULL,
	[SCHEME TITLE] [nvarchar](200) NULL,
	[GRANT REGISTRATION ID] [nvarchar](150) NULL,
	[GRANT OPTION ID] [nvarchar](200) NULL,
	[GRANT DATE] [date] NULL,
	[PUP OPTIONS EXERCISED] [numeric](18, 0) NULL,
	[EXERCISE PRICE] [numeric](18, 2) NULL,
	[SETTLED AT PRICE / PAYOUT PRICES /PUP FMV] [numeric](18, 2) NULL,
	[PAYOUT VALUE] [numeric](18, 2) NULL,
	[PERQUISITE VALUE] [numeric](18, 2) NULL,
	[PERQUISITE TAX] [numeric](18, 2) NULL,
	[UPDATE PAYOUT] [nvarchar](10) NULL,
	[LOTNUMBER] [nvarchar](10) NULL,
	[PAYMENTMODE] [nchar](1) NULL,
	[CASH] [nvarchar](10) NULL,
	[PayoutDate] [date] NULL,
	[ISERROR] [bit] NULL,
	[REASON] [nvarchar](100) NULL,
	[USERID] [nvarchar](50) NULL
)
GO
