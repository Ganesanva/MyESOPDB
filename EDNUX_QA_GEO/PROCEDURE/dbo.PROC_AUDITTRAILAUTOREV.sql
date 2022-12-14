/****** Object:  StoredProcedure [dbo].[PROC_AUDITTRAILAUTOREV]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_AUDITTRAILAUTOREV]
GO
/****** Object:  StoredProcedure [dbo].[PROC_AUDITTRAILAUTOREV]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_AUDITTRAILAUTOREV]
AS
BEGIN
	SELECT      
			AR.ATARID,
			AR.EmployeeID,
			AR.EmployeeName,
			AR.EmployeeEmail,
			AR.Sh_ExerciseNo,
			AR.ExerciseId,
			AR.GrantLegSerialNumber,
			AR.ExerciseDate,
			AR.ExercisedQuantity,
			AR.Amount,
			AR.Tax_Amount,			
			AR.MerchantreferenceNo,
			AR.Merchant_Code,
			AR.Item_Code,
			AR.TPSLTransID,
			AR.Transaction_Date,
			AR.bankid [BankId],
			pbm.BankName
	FROM 
		AuditTrailAutoReverseOnlineEx AS AR 
		INNER JOIN  
		PAYMENTBANKMASTER AS pbm ON pbm.BankID=AR.bankid 
	ORDER BY 
		ExerciseDate 
		DESC
END
GO
