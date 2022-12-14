/****** Object:  StoredProcedure [dbo].[PROC_GetFailureTransactionDetails_2Hours]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetFailureTransactionDetails_2Hours]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetFailureTransactionDetails_2Hours]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetFailureTransactionDetails_2Hours]
  @CompanyId			VARCHAR(250) ,
  @PickupFailedRecordsOfHrs VARCHAR(10)
AS
BEGIN
	DECLARE @ConvertHrsDays NUMERIC(8,0)

	SET @ConvertHrsDays = @PickupFailedRecordsOfHrs;
	
	SELECT 
		DISTINCT ExerciseNo
	INTO
		#TEMP_SHEXERCISEOPTIONS
	FROM 
		ShExercisedOptions 
	WHERE 
		PaymentMode = 'N' 

	SELECT 
		@CompanyId as [Company Name],TD.Sh_ExerciseNo as [Exercise Number], TD.Transaction_Date as [Transaction Date]
		
	FROM 
		Transaction_Details AS TD
		INNER JOIN #TEMP_SHEXERCISEOPTIONS AS TSEO ON TD.Sh_ExerciseNo = TSEO.ExerciseNo
	WHERE 
		(TD.Transaction_Status IS NULL) AND (TD.BankReferenceNo IS NULL) AND (TD.TPSLTransID IS NULL) AND
		((CAST(Transaction_Date AS DATETIME) >= DATEADD(HOUR, @ConvertHrsDays, GETDATE())))
	ORDER BY 
		TD.Transaction_Date ASC
END       
GO
