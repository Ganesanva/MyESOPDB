/****** Object:  Table [dbo].[CancellationDetails_rpt]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CancellationDetails_rpt]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CancellationDetails_rpt](
	[Expr1] [numeric](18, 0) NULL,
	[GrantOptionId] [varchar](100) NOT NULL,
	[GrantDate] [datetime] NOT NULL,
	[VestingDate] [datetime] NOT NULL,
	[FinalVestingDate] [datetime] NULL,
	[FinalExpirayDate] [datetime] NULL,
	[ExpirayDate] [datetime] NOT NULL,
	[CancelledDate] [datetime] NULL,
	[Expr2] [varchar](100) NULL,
	[EmployeeID] [varchar](20) NOT NULL,
	[EmployeeName] [varchar](75) NULL,
	[DateOfTermination] [datetime] NULL,
	[SchemeTitle] [varchar](50) NOT NULL,
	[GrantRegistrationId] [varchar](20) NOT NULL,
	[OptionRatioDivisor] [numeric](18, 0) NOT NULL,
	[OptionRatioMultiplier] [numeric](18, 0) NOT NULL,
	[GrantLegSerialNumber] [numeric](18, 0) NOT NULL,
	[CancelledQuantity] [numeric](18, 0) NOT NULL,
	[CancellationReason] [varchar](100) NULL,
	[Status] [varchar](10) NULL,
	[VestedUnVested] [varchar](15) NULL,
	[OptionsCancelled] [numeric](18, 2) NULL,
	[Flag] [numeric](18, 0) NULL,
	[Note] [varchar](15) NULL,
	[PANNumber] [varchar](10) NULL,
	[RowInsrtDttm] [datetime] NULL,
	[RowUpdtDttm] [datetime] NULL
) ON [PRIMARY]
END
GO
