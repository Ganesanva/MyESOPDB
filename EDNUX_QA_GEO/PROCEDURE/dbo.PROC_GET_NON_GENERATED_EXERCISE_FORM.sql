/****** Object:  StoredProcedure [dbo].[PROC_GET_NON_GENERATED_EXERCISE_FORM]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_NON_GENERATED_EXERCISE_FORM]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_NON_GENERATED_EXERCISE_FORM]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_NON_GENERATED_EXERCISE_FORM]
@ExerciseDate DATETIME
AS
BEGIN
	SELECT DISTINCT SE.ExerciseNo,SE.ExerciseId,SE.EmployeeID,(SELECT CompanyID FROM CompanyMaster) AS CompanyID,
		   (SELECT CurrencyAlias FROM CurrencyMaster CM 
			INNER JOIN CompanyMaster CP 
			ON CM.CurrencyID=CP.BaseCurrencyID) AS CurrencyAlias,
			PaymentMode,MIT_ID,ISNULL(IS_UPLOAD_EXERCISE_FORM,0) AS IS_UPLOAD_EXERCISE_FORM,TAX_SEQUENCENO, CALCULATE_TAX,FMVPrice,
			(
				SELECT RT.[Description]
				FROM EmployeeMaster EM
				INNER JOIN ResidentialType RT 
				ON ISNULL(EM.ResidentialStatus,'R') = RT.ResidentialStatus
				WHERE EM.EmployeeID = SE.EmployeeID AND ISNULL(Deleted,0) = 0
			)	AS ResidentType,
			(
				SELECT PM.PayModeName
				FROM PaymentMaster PM
				WHERE PM.PaymentMode = SE.PaymentMode 
			)	AS PaymentModeName
			--CASE WHEN SE.PaymentMode = 'W' THEN 'WireTransfer'
			--END AS PaymentModeName
	FROM ShExercisedOptions SE
	INNER JOIN ESOP_FORM_GEN_REQUEST EFGR
	ON SE.EXERCISENO = EFGR.EXERCISE_NO
	Where CONVERT(DATE,ExerciseDate)>=CONVERT(DATE,@ExerciseDate) AND EFGR.ISPROCESSED = 0 --'2019-01-01' 
	
END
GO
