/****** Object:  Table [dbo].[AuditTrail_PaymentBankMaster]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AuditTrail_PaymentBankMaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AuditTrail_PaymentBankMaster](
	[ATBM_ID] [int] IDENTITY(1,1) NOT NULL,
	[BANKID] [varchar](10) NULL,
	[BANKNAME] [varchar](100) NULL,
	[TRANSACTIONAMOUNT] [numeric](18, 9) NULL,
	[ISENABLE] [char](1) NULL,
	[TCMID] [int] NULL,
	[CHK_TRNVAL_EXAMT] [bit] NULL,
	[TRNVAL_EXAMT] [numeric](18, 9) NULL,
	[CHK_TRNVAL_PQTAX] [bit] NULL,
	[TRNVAL_PQTAX] [numeric](18, 9) NULL,
	[TRNVAL_MAXLIMIT] [int] NULL,
	[CHK_MAXVAL_EXAMT] [bit] NULL,
	[MAXVAL_EXAMT] [numeric](18, 9) NULL,
	[CHK_MAXVAL_PQTAX] [bit] NULL,
	[MAXVAL_PQTAX] [numeric](18, 9) NULL,
	[MAXVAL_MAXLIMIT] [int] NULL,
	[LAST_UPDATED_BY] [varchar](50) NULL,
	[LAST_UPDATED_ON] [datetime] NULL
) ON [PRIMARY]
END
GO
