/****** Object:  UserDefinedTableType [dbo].[PUPValueMassUploadType]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[PUPValueMassUploadType]
GO
/****** Object:  UserDefinedTableType [dbo].[PUPValueMassUploadType]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[PUPValueMassUploadType] AS TABLE(
	[PUPID] [int] NULL,
	[GrantID] [int] NULL,
	[EmployeeId] [varchar](100) NULL,
	[GrantOptionId] [varchar](100) NULL,
	[VestId] [int] NULL,
	[ParentType] [char](1) NULL,
	[PUPFMV] [numeric](18, 2) NULL,
	[PayoutAmt] [numeric](18, 2) NULL,
	[PayoutDate] [date] NULL DEFAULT (NULL),
	[PerqValue] [numeric](18, 2) NULL,
	[PerqTax] [numeric](18, 2) NULL
)
GO
