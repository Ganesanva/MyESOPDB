/****** Object:  UserDefinedTableType [dbo].[PUPVALIDATEEXERCISE_TYPE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[PUPVALIDATEEXERCISE_TYPE]
GO
/****** Object:  UserDefinedTableType [dbo].[PUPVALIDATEEXERCISE_TYPE]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[PUPVALIDATEEXERCISE_TYPE] AS TABLE(
	[Exercise Id] [nvarchar](40) NULL,
	[Employee ID] [nvarchar](100) NULL,
	[Employee Name] [nvarchar](400) NULL,
	[Exercise Date] [date] NULL,
	[Plan Name] [nvarchar](200) NULL,
	[Grant Date] [date] NULL,
	[PUP Options exercised] [numeric](18, 2) NULL,
	[Settled at Price/ Payout Prices/PUP FMV] [numeric](18, 2) NULL,
	[Payout value] [numeric](18, 2) NULL,
	[Perquisite value] [nvarchar](50) NULL,
	[Perquisite tax] [nvarchar](50) NULL,
	[Update Payout] [nchar](5) NULL,
	[Lot Number] [nvarchar](20) NULL,
	[IsError] [bit] NULL,
	[ErrorMessage] [nvarchar](1000) NULL
)
GO
