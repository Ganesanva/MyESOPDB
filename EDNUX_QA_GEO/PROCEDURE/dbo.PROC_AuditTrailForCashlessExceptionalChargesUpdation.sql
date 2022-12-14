/****** Object:  StoredProcedure [dbo].[PROC_AuditTrailForCashlessExceptionalChargesUpdation]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_AuditTrailForCashlessExceptionalChargesUpdation]
GO
/****** Object:  StoredProcedure [dbo].[PROC_AuditTrailForCashlessExceptionalChargesUpdation]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author			: Chetan Chopkar
-- Create date		: 01 Oct 2013
-- Description		: Audit trail report for Cashless Exceptional Charges Updation
-- EXEC PROC_AuditTrailForCashlessExceptionalChargesUpdation
-- =============================================
CREATE PROCEDURE [dbo].[PROC_AuditTrailForCashlessExceptionalChargesUpdation]

AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ID, ExerciseNo, ExerciseId, EmployeeId, EmployeeName, ExerciseDate, ExercisableQuantity, (CASE 
	WHEN PaymentMode = 'Q' THEN 'Cheque' 
	WHEN PaymentMode = 'D' THEN 'Demand Draft' 
	WHEN PaymentMode = 'W' THEN 'Wire Transfer'
	WHEN PaymentMode = 'R' THEN 'RTGS'
	WHEN PaymentMode = 'I' THEN 'Direct Debit'
	WHEN PaymentMode = 'F' THEN 'Funding'
	WHEN PaymentMode = 'N' THEN 'Online'
	WHEN PaymentMode = 'A' THEN 'Sell All'
	WHEN PaymentMode = 'A' THEN 'Sell To Cover'
	END
	) AS PaymentMode, SaleDate, PerquisiteValue,
	PerqTax, PerquisiteTaxPaid, CashlessCharges, CAFilling, ServiceTaxOnCAFilling, CessOnCAFillingFees, BankCharges, ServiceTaxOnBankCharges, CessOnBankChargesFillingFees, CapitalGainValue, CapitalTaxRateApplicable, CapitalGainTax,
	(CASE 
	WHEN IdStatus = 'O' THEN 'Original' 
	WHEN IdStatus = 'U' THEN 'Updated' 
	END
	) AS IdStatus,
	LastUpdatedBy, LastUpdatedOn
	FROM
	(
		SELECT CETH.UpdationChargesHisID AS ID, SEO.ExerciseNo, CETH.ExerciseId, CETH.EmployeeId, EM.EmployeeName, SEO.ExerciseDate, SEO.ExercisableQuantity, SEO.PaymentMode, CETH.SaleDate, CETH.PerquisiteValue, 
		CETH.PerqTax, CETH.PerquisiteTaxPaid, CETH.CashlessCharges,CETH.CAFilling, CETH.ServiceTaxOnCAFilling, CETH.CessOnCAFillingFees, CETH.BankCharges, CETH.ServiceTaxOnBankCharges,	
		CETH.CessOnBankChargesFillingFees, CETH.CapitalGainValue, CETH.CapitalTaxRateApplicable, CETH.CapitalGainTax, CETH.IdStatus, CETH.LastUpdatedBy, CETH.LastUpdatedOn 
		FROM CashlessExceptionalChargesUpdationHistory AS CETH
		INNER JOIN ShExercisedOptions AS SEO ON CETH.ExerciseId = SEO.ExerciseId
		INNER JOIN EmployeeMaster AS EM ON CETH.EmployeeId =  EM.EmployeeID 
		UNION ALL
		SELECT CETH.UpdationChargesHisID AS ID, EXER.ExerciseNo, CETH.ExerciseId, CETH.EmployeeId, EM.EmployeeName, EXER.ExercisedDate, EXER.ExercisableQuantity, EXER.PaymentMode, CETH.SaleDate, CETH.PerquisiteValue, 
		CETH.PerqTax, CETH.PerquisiteTaxPaid, CETH.CashlessCharges, CETH.CAFilling, CETH.ServiceTaxOnCAFilling,	CETH.CessOnCAFillingFees, CETH.BankCharges, CETH.ServiceTaxOnBankCharges,	
		CETH.CessOnBankChargesFillingFees, CETH.CapitalGainValue, CETH.CapitalTaxRateApplicable, CETH.CapitalGainTax, CETH.IdStatus, CETH.LastUpdatedBy, CETH.LastUpdatedOn 
		FROM CashlessExceptionalChargesUpdationHistory AS CETH
		INNER JOIN Exercised AS EXER ON CETH.ExerciseId = EXER.ExercisedId
		INNER JOIN EmployeeMaster AS EM ON CETH.EmployeeId =  EM.EmployeeID
				
	) AS FINAL_DATA
	ORDER BY ExerciseId, LastUpdatedOn DESC
	
END

GO
