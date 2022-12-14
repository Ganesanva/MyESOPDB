/****** Object:  UserDefinedTableType [dbo].[TYPE_CRUD_BuyBackOptions]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_CRUD_BuyBackOptions]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_CRUD_BuyBackOptions]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[TYPE_CRUD_BuyBackOptions] AS TABLE(
	[ACTION] [char](50) NULL,
	[ApplicationID] [int] NULL,
	[EmployeeID] [varchar](100) NULL,
	[EmployeeStatus] [varchar](50) NULL,
	[ApplicationDate] [datetime] NULL,
	[NoOfOptionsApplied] [int] NULL,
	[SettlementPrice] [numeric](18, 9) NULL,
	[GrossValuePayable] [numeric](18, 0) NULL,
	[NameInBankRecord] [varchar](100) NULL,
	[BankName] [varchar](100) NULL,
	[BankAddress] [varchar](200) NULL,
	[BankAccountNumber] [varchar](100) NULL,
	[BankIFSCCode] [varchar](100) NULL,
	[PANNumber] [varchar](100) NULL,
	[AadhaarNumber] [varchar](100) NULL,
	[IsFileUploaded] [varchar](10) NULL,
	[UpdatedBy] [varchar](100) NULL,
	[UpdatedOn] [datetime] NULL
)
GO
