/****** Object:  Table [dbo].[Transaction_Details_Funding]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Transaction_Details_Funding]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Transaction_Details_Funding](
	[MerchantreferenceNo] [numeric](18, 0) NOT NULL,
	[BankReferenceNo] [varchar](25) NULL,
	[Merchant_Code] [varchar](50) NULL,
	[Sh_ExerciseNo] [numeric](18, 0) NULL,
	[TransactionType] [varchar](10) NULL,
	[Amount] [numeric](18, 2) NULL,
	[Item_Code] [varchar](50) NULL,
	[Payment_status] [varchar](25) NULL,
	[Transaction_Status] [varchar](25) NULL,
	[Transaction_Date] [datetime] NULL,
	[LastUpdatedBy] [varchar](25) NULL,
	[LastUpdated] [datetime] NULL,
	[Tax_Amount] [numeric](18, 2) NULL,
	[temp_ExerciseId] [numeric](18, 0) NULL,
	[BankName] [varchar](100) NULL,
	[Failure Reson] [varchar](50) NULL,
	[ErrorCode] [varchar](50) NULL,
	[transactionfees] [numeric](18, 2) NULL,
	[TPSTTransID] [numeric](18, 0) NULL,
	[FailureReson] [varchar](50) NULL,
	[MarginOrFunding] [varchar](1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MerchantreferenceNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
