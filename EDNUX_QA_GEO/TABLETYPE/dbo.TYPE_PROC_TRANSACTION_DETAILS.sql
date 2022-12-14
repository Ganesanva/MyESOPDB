/****** Object:  UserDefinedTableType [dbo].[TYPE_PROC_TRANSACTION_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_PROC_TRANSACTION_DETAILS]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_PROC_TRANSACTION_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[TYPE_PROC_TRANSACTION_DETAILS] AS TABLE(
	[ACTION] [char](50) NULL,
	[ExerciseNo] [int] NULL,
	[BankReferenceNo] [varchar](100) NULL,
	[UniqueTransactionNo] [varchar](30) NULL,
	[Item_Code] [varchar](50) NULL,
	[Transaction_Date] [datetime] NULL,
	[TPSLTransID] [varchar](50) NULL,
	[banKid] [varchar](10) NULL,
	[LastUpdatedBy] [varchar](25) NULL,
	[LastUpdated] [datetime] NULL
)
GO
