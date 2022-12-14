/****** Object:  Table [dbo].[DeferredCashGrant]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeferredCashGrant]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DeferredCashGrant](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Action] [char](1) NULL,
	[PayoutTranchId] [int] NULL,
	[EmployeeId] [nvarchar](20) NULL,
	[EmployeeNAme] [nvarchar](50) NULL,
	[SchemeName] [nvarchar](500) NULL,
	[GrantFinancialYear] [nvarchar](50) NULL,
	[GrantID] [nvarchar](50) NULL,
	[GrantDate] [datetime] NULL,
	[GrantAmount] [numeric](22, 2) NULL,
	[Currency] [varchar](100) NULL,
	[PayOutdueDate] [datetime] NULL,
	[PayOutDistribution] [numeric](22, 2) NULL,
	[PayOutCategory] [nvarchar](50) NULL,
	[GrossPayoutAmount] [numeric](22, 2) NULL,
	[TaxDeducted] [numeric](22, 2) NULL,
	[NetPayoutAmount] [numeric](22, 2) NULL,
	[PayOutDate] [datetime] NULL,
	[PayOutRevesion] [numeric](22, 2) NULL,
	[DateOfRevision] [datetime] NULL,
	[ReasoForRevision] [nvarchar](50) NULL,
	[CREATED_BY] [nvarchar](100) NULL,
	[CREATED_ON] [datetime] NULL,
	[UPDATED_BY] [nvarchar](100) NULL,
	[UPDATED_ON] [datetime] NULL,
	[QueryExecutionON] [datetime] NULL,
	[StatusType] [char](1) NULL,
	[Remark] [nvarchar](50) NULL,
	[PayOutdue] [numeric](18, 9) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
