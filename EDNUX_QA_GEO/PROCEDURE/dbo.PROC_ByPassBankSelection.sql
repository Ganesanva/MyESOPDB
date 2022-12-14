/****** Object:  StoredProcedure [dbo].[PROC_ByPassBankSelection]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_ByPassBankSelection]
GO
/****** Object:  StoredProcedure [dbo].[PROC_ByPassBankSelection]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_ByPassBankSelection]
AS
BEGIN
	DECLARE @BANKCOUNT TINYINT,
			@ByPassBankSelection BIT			
	
	SELECT @ByPassBankSelection = BypassBankSelection FROM COMPANYPARAMETERS

	SELECT @BANKCOUNT = COUNT(BANKID) FROM PAYMENTBANKMASTER WHERE ISENABLE='Y'

	SELECT BankID,BankName,TransactionAmount,@BANKCOUNT [NoOfBank],@ByPassBankSelection [ByPassBankSelection] FROM PAYMENTBANKMASTER WHERE ISENABLE='Y'
END
GO
