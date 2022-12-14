/****** Object:  Table [dbo].[AuditTrailAutoReverseOnlineEx]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AuditTrailAutoReverseOnlineEx]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AuditTrailAutoReverseOnlineEx](
	[ATARID] [int] IDENTITY(1,1) NOT NULL,
	[MerchantreferenceNo] [numeric](18, 0) NULL,
	[Merchant_Code] [varchar](50) NULL,
	[Sh_ExerciseNo] [numeric](18, 0) NULL,
	[ExerciseId] [numeric](18, 0) NULL,
	[GrantLegSerialNumber] [numeric](18, 0) NULL,
	[Item_Code] [varchar](50) NULL,
	[Amount] [numeric](18, 2) NULL,
	[Tax_Amount] [numeric](18, 2) NULL,
	[Transaction_Date] [datetime] NULL,
	[bankid] [varchar](10) NULL,
	[TPSLTransID] [varchar](50) NULL,
	[ExercisedQuantity] [numeric](18, 0) NULL,
	[EmployeeID] [varchar](20) NULL,
	[EmployeeName] [varchar](75) NULL,
	[EmployeeEmail] [varchar](100) NULL,
	[ExerciseDate] [datetime] NULL,
	[InsertedOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ATARID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
