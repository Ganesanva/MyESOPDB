/****** Object:  StoredProcedure [dbo].[PROC_GetPaymentBankMaster]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetPaymentBankMaster]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetPaymentBankMaster]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GetPaymentBankMaster]  
AS
BEGIN
	SET NOCOUNT ON;   
	SELECT BankID,BankName, TransactionAmount AS TransactionCharges from PaymentBankMaster where IsEnable ='Y'
END
GO
