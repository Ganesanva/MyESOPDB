/****** Object:  Table [dbo].[PaymentSlipDetails]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PaymentSlipDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PaymentSlipDetails](
	[ExercisedID] [numeric](18, 0) NULL,
	[AmountPaid] [numeric](18, 0) NULL,
	[DrawnOn] [datetime] NULL,
	[BankName] [varchar](50) NULL,
	[Cheque_DDNo] [varchar](20) NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__PaymentSl__Exerc__3AA1AEB8]') AND parent_object_id = OBJECT_ID(N'[dbo].[PaymentSlipDetails]'))
ALTER TABLE [dbo].[PaymentSlipDetails]  WITH CHECK ADD  CONSTRAINT [FK__PaymentSl__Exerc__3AA1AEB8] FOREIGN KEY([ExercisedID])
REFERENCES [dbo].[Exercised] ([ExercisedId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__PaymentSl__Exerc__3AA1AEB8]') AND parent_object_id = OBJECT_ID(N'[dbo].[PaymentSlipDetails]'))
ALTER TABLE [dbo].[PaymentSlipDetails] CHECK CONSTRAINT [FK__PaymentSl__Exerc__3AA1AEB8]
GO
