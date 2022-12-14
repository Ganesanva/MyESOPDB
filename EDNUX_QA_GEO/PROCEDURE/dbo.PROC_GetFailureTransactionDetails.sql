/****** Object:  StoredProcedure [dbo].[PROC_GetFailureTransactionDetails]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetFailureTransactionDetails]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetFailureTransactionDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE   PROCEDURE [dbo].[PROC_GetFailureTransactionDetails]-- 'UTIAMC_QA','10'
  @CompanyId			VARCHAR(250),
  @PickupRecordsOfHrs	VARCHAR(10)
AS
BEGIN

	DECLARE @ConvertHrsDays NUMERIC(8,0)

	SET @ConvertHrsDays = (SELECT FORMAT(@PickupRecordsOfHrs / 24, '00'))

	--PRINT @ConvertHrsDays
	--PRINT CONVERT(DATE, GETDATE() - @ConvertHrsDays)

	SELECT 
		DISTINCT ExerciseNo, EmployeeID
	INTO
		#TEMP_SHEXERCISEOPTIONS
	FROM 
		ShExercisedOptions 
	--WHERE 
	--	PaymentMode = 'N' 
		
	SELECT 
		TD.Merchant_Code, TD.MerchantreferenceNo, TD.Item_Code, TD.Amount, '' AS UniqueCustId, TD.TPSLTransID, '' AS ShoppingCardDetails, TD.Transaction_Date, '' AS Email,
		MobileNumber, TD.bankid AS BankCode, '' AS CustomerName , '' AS CardId, '' AS BankAccountNo, TD.Sh_ExerciseNo, EM.EmployeeName, EM.EmployeeEmail
	FROM 
		Transaction_Details AS TD
		INNER JOIN #TEMP_SHEXERCISEOPTIONS AS TSEO ON TD.Sh_ExerciseNo = TSEO.ExerciseNo
		INNER JOIN EmployeeMaster AS EM ON EM.EmployeeID = TSEO.EmployeeID
	WHERE 
		(TD.Transaction_Status IS NULL) AND (TD.BankReferenceNo IS NULL) AND (TD.TPSLTransID IS NULL)  
		 AND
		((CONVERT(DATE,TD.Transaction_Date) >= CONVERT(DATE, GETDATE() - @ConvertHrsDays)) AND (CONVERT(DATE,TD.Transaction_Date) <= CONVERT(DATE, GETDATE())))
	ORDER BY 
		TD.Transaction_Date ASC
END       
GO
