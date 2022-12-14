/****** Object:  StoredProcedure [dbo].[Proc_ListForAllotmentReversal]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Proc_ListForAllotmentReversal]
GO
/****** Object:  StoredProcedure [dbo].[Proc_ListForAllotmentReversal]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author :	Chetan Chopkar
-- Create date : 03/Aug/2013 
-- Description : Stored procedure is used to diaply records for reversal grid
-- =============================================
CREATE PROCEDURE [dbo].[Proc_ListForAllotmentReversal]
	-- Add the parameters for the stored procedure here
	@UniqueId VARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT SC.SchemeTitle, GR.GrantDate, EM.EmployeeID, EM.EmployeeName, SEO.ExerciseNo, SEO.ExerciseId, SEO.ExercisedQuantity, 
	(CASE 
	WHEN SEO.PaymentMode = 'Q' THEN 'Cheque' 
	WHEN SEO.PaymentMode = 'D' THEN 'Demand Draft' 
	WHEN SEO.PaymentMode = 'W' THEN 'Wire Transfer'
	WHEN SEO.PaymentMode = 'R' THEN 'RTGS'
	WHEN SEO.PaymentMode = 'I' THEN 'Direct Debit'
	WHEN SEO.PaymentMode = 'F' THEN 'Funding'
	WHEN SEO.PaymentMode = 'N' THEN 'Online'
	END
	) AS PaymentMode,
	SEO.ExercisePrice, SEO.ExerciseDate, SEO.PerqstPayable,
	(CASE
				 WHEN ((SEO.paymentmode = 'D' OR SEO.paymentmode = 'Q' OR SEO.paymentmode = 'R' OR SEO.paymentmode = 'W' OR SEO.paymentmode = 'I') AND (SHOFF.DPIDNo IS NOT NULL OR SHOFF.DPIDNo!='')) THEN SHOFF.DPIDNo
				 WHEN ((SEO.paymentmode = 'A' OR SEO.paymentmode = 'P') AND (SHCASH.DPId IS NOT NULL OR SHCASH.DPId!='')) THEN SHCASH.DPId
				 WHEN (SEO.paymentmode = 'N' AND (SHON.DPId IS NOT NULL OR SHON.DPId!='')) THEN SHON.DPId
				 ELSE (EM.DepositoryIDNumber)
	END) AS  DepositoryIDNumber, 
	(CASE 
				 WHEN ((SEO.paymentmode = 'D' OR SEO.paymentmode = 'Q' OR SEO.paymentmode = 'R' OR SEO.paymentmode = 'W' OR SEO.paymentmode = 'I') AND (SHOFF.DepositoryParticipantName IS NOT NULL OR SHOFF.DepositoryParticipantName!='')) THEN SHOFF.DepositoryParticipantName
				 WHEN ((SEO.paymentmode = 'A' OR SEO.paymentmode = 'P') AND (SHCASH.DPName IS NOT NULL OR SHCASH.DPName!='')) THEN SHCASH.DPName
				 WHEN (SEO.paymentmode = 'N' AND (SHON.DPName IS NOT NULL OR SHON.DPName!='')) THEN SHON.DPName
				 ELSE (EM.DepositoryParticipantNo) 
	END) AS DepositoryParticipantNo,
	(CASE WHEN ((SEO.paymentmode = 'D' OR SEO.paymentmode = 'Q' OR SEO.paymentmode = 'R' OR SEO.paymentmode = 'W' OR SEO.paymentmode = 'I') AND (SHOFF.ClientNo IS NOT NULL OR SHOFF.ClientNo!='')) THEN SHOFF.ClientNo
				 WHEN ((SEO.paymentmode = 'A' OR SEO.paymentmode = 'P') AND (SHCASH.ClientId IS NOT NULL OR SHCASH.ClientId!='')) THEN SHCASH.ClientId
				 WHEN (SEO.paymentmode = 'N' AND (SHON.ClientId IS NOT NULL OR SHON.ClientId!='')) THEN SHON.ClientId
				 ELSE EM.ClientIDNumber
	END) AS  ClientIDNumber,
	(CASE 
			WHEN ((SEO.paymentmode = 'D' OR SEO.paymentmode = 'Q' OR SEO.paymentmode = 'R' OR SEO.paymentmode = 'W' OR SEO.paymentmode = 'I') AND (SHOFF.DepositoryName IS NOT NULL OR SHOFF.DepositoryName!='')) THEN  
				CASE WHEN SHOFF.DepositoryName='N' THEN 'NSDL'
            							   WHEN SHOFF.DepositoryName='C' THEN 'CDSL'  
            							 ELSE SHOFF.DepositoryName 
            						END     
			WHEN ((SEO.paymentmode = 'A' OR SEO.paymentmode = 'P') AND (SHCASH.DepositoryName IS NOT NULL OR SHCASH.DepositoryName!='')) THEN 
	CASE WHEN SHCASH.DepositoryName='N' THEN 'NSDL'
            										  WHEN SHCASH.DepositoryName='C' THEN 'CDSL'  
            								 ELSE SHCASH.DepositoryName 
	END 
			 WHEN (SEO.paymentmode = 'N' AND (SHON.DepositoryName IS NOT NULL OR SHON.DepositoryName!='')) THEN 
					   CASE WHEN SHON.DepositoryName='N' THEN 'NSDL'
										  WHEN SHON.DepositoryName='C' THEN 'CDSL'  
								 ELSE SHON.DepositoryName END 
			  ELSE 
					   CASE WHEN EM.DepositoryName='N' THEN 'NSDL'
										  WHEN EM.DepositoryName='C' THEN 'CDSL'  
								 ELSE EM.DepositoryName END 
	END) AS DepositoryName,
	SEO.ExerciseFormReceived, PM.Exerciseform_Submit, SEO.ValidationStatus, SEO.LotNumber, SEO.IsAllotmentGenerated, SEO.IsAllotmentGeneratedReversed, 
	EM.EmployeeEmail, NULL AS Condition, SEO.AllotmentGeneratedReversedDate
	FROM ShExercisedOptions AS SEO  
	INNER JOIN GrantLeg AS GL ON GL.ID = SEO.GrantLegSerialNumber  
	INNER JOIN EmployeeMaster AS EM ON EM.EmployeeID = SEO.EmployeeID  
	INNER JOIN GrantRegistration AS GR ON GR.GrantRegistrationId = GL.GrantRegistrationId  
	INNER JOIN Scheme AS SC ON SC.SchemeId = GL.SchemeId 
	INNER JOIN PaymentMaster AS PM ON PM.PaymentMode = SEO.PaymentMode  
	LEFT OUTER JOIN shtransactiondetails SHOFF ON SEO.ExerciseNo = SHOFF.ExerciseNo
	LEFT OUTER JOIN transactiondetails_funding SHFUND ON SEO.ExerciseNo = SHFUND.ExerciseNO
	LEFT OUTER JOIN transaction_details SHON ON SEO.ExerciseNo = SHON.exerciseno
	LEFT OUTER JOIN transactiondetails_cashless SHCASH ON SEO.ExerciseNo = SHCASH.ExerciseNo
	WHERE (SEO.PaymentMode NOT IN ('A','P')) AND (SEO.IsAllotmentGeneratedReversed=0) AND (SEO.GenerateAllotListUniqueId = @UniqueId) AND (SEO.ValidationStatus='N') 

	UNION 

	SELECT DISTINCT SC.SchemeTitle, GR.GrantDate, EM.EmployeeID, EM.EmployeeName, SEO.ExerciseNo, SEO.ExerciseId, SEO.ExercisedQuantity, 
	(CASE 
	WHEN SEO.PaymentMode = 'Q' THEN 'Cheque' 
	WHEN SEO.PaymentMode = 'D' THEN 'Demand Draft' 
	WHEN SEO.PaymentMode = 'W' THEN 'Wire Transfer'
	WHEN SEO.PaymentMode = 'R' THEN 'RTGS'
	WHEN SEO.PaymentMode = 'I' THEN 'Direct Debit'
	WHEN SEO.PaymentMode = 'F' THEN 'Funding'
	WHEN SEO.PaymentMode = 'N' THEN 'Online'
	END
	) AS PaymentMode,
	SEO.ExercisePrice, SEO.ExerciseDate, SEO.PerqstPayable,
	(CASE
				 WHEN ((SEO.paymentmode = 'D' OR SEO.paymentmode = 'Q' OR SEO.paymentmode = 'R' OR SEO.paymentmode = 'W' OR SEO.paymentmode = 'I') AND (SHOFF.DPIDNo IS NOT NULL OR SHOFF.DPIDNo!='')) THEN SHOFF.DPIDNo
				 WHEN ((SEO.paymentmode = 'A' OR SEO.paymentmode = 'P') AND (SHCASH.DPId IS NOT NULL OR SHCASH.DPId!='')) THEN SHCASH.DPId
				 WHEN (SEO.paymentmode = 'N' AND (SHON.DPId IS NOT NULL OR SHON.DPId!='')) THEN SHON.DPId
				 ELSE (EM.DepositoryIDNumber)
	END) AS  DepositoryIDNumber, 
	(CASE 
				 WHEN ((SEO.paymentmode = 'D' OR SEO.paymentmode = 'Q' OR SEO.paymentmode = 'R' OR SEO.paymentmode = 'W' OR SEO.paymentmode = 'I') AND (SHOFF.DepositoryParticipantName IS NOT NULL OR SHOFF.DepositoryParticipantName!='')) THEN SHOFF.DepositoryParticipantName
				 WHEN ((SEO.paymentmode = 'A' OR SEO.paymentmode = 'P') AND (SHCASH.DPName IS NOT NULL OR SHCASH.DPName!='')) THEN SHCASH.DPName
				 WHEN (SEO.paymentmode = 'N' AND (SHON.DPName IS NOT NULL OR SHON.DPName!='')) THEN SHON.DPName
				 ELSE (EM.DepositoryParticipantNo) 
	END) AS DepositoryParticipantNo,
	(CASE WHEN ((SEO.paymentmode = 'D' OR SEO.paymentmode = 'Q' OR SEO.paymentmode = 'R' OR SEO.paymentmode = 'W' OR SEO.paymentmode = 'I') AND (SHOFF.ClientNo IS NOT NULL OR SHOFF.ClientNo!='')) THEN SHOFF.ClientNo
				 WHEN ((SEO.paymentmode = 'A' OR SEO.paymentmode = 'P') AND (SHCASH.ClientId IS NOT NULL OR SHCASH.ClientId!='')) THEN SHCASH.ClientId
				 WHEN (SEO.paymentmode = 'N' AND (SHON.ClientId IS NOT NULL OR SHON.ClientId!='')) THEN SHON.ClientId
				 ELSE EM.ClientIDNumber
	END) AS  ClientIDNumber,
	(CASE 
			WHEN ((SEO.paymentmode = 'D' OR SEO.paymentmode = 'Q' OR SEO.paymentmode = 'R' OR SEO.paymentmode = 'W' OR SEO.paymentmode = 'I') AND (SHOFF.DepositoryName IS NOT NULL OR SHOFF.DepositoryName!='')) THEN  
				CASE WHEN SHOFF.DepositoryName='N' THEN 'NSDL'
            							   WHEN SHOFF.DepositoryName='C' THEN 'CDSL'  
            							 ELSE SHOFF.DepositoryName 
            						END     
			WHEN ((SEO.paymentmode = 'A' OR SEO.paymentmode = 'P') AND (SHCASH.DepositoryName IS NOT NULL OR SHCASH.DepositoryName!='')) THEN 
	CASE WHEN SHCASH.DepositoryName='N' THEN 'NSDL'
            										  WHEN SHCASH.DepositoryName='C' THEN 'CDSL'  
            								 ELSE SHCASH.DepositoryName 
	END 
			 WHEN (SEO.paymentmode = 'N' AND (SHON.DepositoryName IS NOT NULL OR SHON.DepositoryName!='')) THEN 
					   CASE WHEN SHON.DepositoryName='N' THEN 'NSDL'
										  WHEN SHON.DepositoryName='C' THEN 'CDSL'  
								 ELSE SHON.DepositoryName END 
			  ELSE 
					   CASE WHEN EM.DepositoryName='N' THEN 'NSDL'
										  WHEN EM.DepositoryName='C' THEN 'CDSL'  
								 ELSE EM.DepositoryName END 
	END) AS DepositoryName,
	SEO.ExerciseFormReceived, PM.Exerciseform_Submit, SEO.ValidationStatus, SEO.LotNumber, SEO.IsAllotmentGenerated,  SEO.IsAllotmentGeneratedReversed, 
	EM.EmployeeEmail, 'Reversed' AS Condition, SEO.AllotmentGeneratedReversedDate
	FROM ShExercisedOptions AS SEO  
	INNER JOIN GrantLeg AS GL ON GL.ID = SEO.GrantLegSerialNumber  
	INNER JOIN EmployeeMaster AS EM ON EM.EmployeeID = SEO.EmployeeID  
	INNER JOIN GrantRegistration AS GR ON GR.GrantRegistrationId = GL.GrantRegistrationId  
	INNER JOIN Scheme AS SC ON SC.SchemeId = GL.SchemeId 
	INNER JOIN PaymentMaster AS PM ON PM.PaymentMode = SEO.PaymentMode  
	LEFT OUTER JOIN shtransactiondetails SHOFF ON SEO.ExerciseNo = SHOFF.ExerciseNo
	LEFT OUTER JOIN transactiondetails_funding SHFUND ON SEO.ExerciseNo = SHFUND.ExerciseNO
	LEFT OUTER JOIN transaction_details SHON ON SEO.ExerciseNo = SHON.exerciseno
	LEFT OUTER JOIN transactiondetails_cashless SHCASH ON SEO.ExerciseNo = SHCASH.ExerciseNo
	LEFT OUTER JOIN AuditTrailAllotmentListReversal AS REV ON REV.ExerciseNo = SEO.ExerciseNo
	WHERE (SEO.PaymentMode NOT IN ('A','P'))  AND (SEO.IsAllotmentGeneratedReversed = 1) AND (REV.AllotedUniqueId = @UniqueId) 
	ORDER BY SEO.ExerciseId ASC 
	
END
GO
