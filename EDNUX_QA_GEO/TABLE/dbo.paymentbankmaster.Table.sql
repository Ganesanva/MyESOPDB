/****** Object:  Table [dbo].[paymentbankmaster]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[paymentbankmaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[paymentbankmaster](
	[BankID] [varchar](10) NOT NULL,
	[BankName] [varchar](100) NOT NULL,
	[TransactionAmount] [numeric](18, 2) NULL,
	[IsEnable] [char](1) NULL,
	[Lastupdatedby] [varchar](20) NULL,
	[Lastupdatedon] [datetime] NULL,
	[TCMID] [int] NULL,
	[CHK_TRNVAL_EXAMT] [bit] NULL,
	[TRNVAL_EXAMT] [numeric](18, 4) NULL,
	[CHK_TRNVAL_PQTAX] [bit] NULL,
	[TRNVAL_PQTAX] [numeric](18, 4) NULL,
	[TRNVAL_MAXLIMIT] [int] NULL,
	[CHK_MAXVAL_EXAMT] [bit] NULL,
	[MAXVAL_EXAMT] [numeric](18, 4) NULL,
	[CHK_MAXVAL_PQTAX] [bit] NULL,
	[MAXVAL_PQTAX] [numeric](18, 4) NULL,
	[MAXVAL_MAXLIMIT] [int] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__paymentba__TCMID__4A23E96A]') AND parent_object_id = OBJECT_ID(N'[dbo].[paymentbankmaster]'))
ALTER TABLE [dbo].[paymentbankmaster]  WITH CHECK ADD FOREIGN KEY([TCMID])
REFERENCES [dbo].[TRANSACTION_COST_METHOD_MASTER] ([TCMID])
GO
