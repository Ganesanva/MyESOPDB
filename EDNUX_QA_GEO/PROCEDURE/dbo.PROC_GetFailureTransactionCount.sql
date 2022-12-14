/****** Object:  StoredProcedure [dbo].[PROC_GetFailureTransactionCount]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetFailureTransactionCount]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetFailureTransactionCount]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GetFailureTransactionCount]
  @CompanyId   VARCHAR(250)
AS
BEGIN
	SELECT DISTINCT ExerciseNo
	INTO #TEMP_SHEXERCISEOPTIONS
	FROM ShExercisedOptions WHERE PaymentMode='N'
		
	SELECT COUNT(*) as TransCount FROM Transaction_Details TD
	INNER JOIN #TEMP_SHEXERCISEOPTIONS TSEO on TD.Sh_ExerciseNo= TSEO.ExerciseNo
	WHERE TD.Transaction_Status IS NULL AND BankReferenceNo IS NULL AND TPSLTransID IS NULL
	AND CONVERT(DATE,TD.Transaction_Date) = CONVERT(DATE, GETDATE())
END   
GO
