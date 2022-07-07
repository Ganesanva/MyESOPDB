/****** Object:  StoredProcedure [dbo].[PROC_SOPsUI_VALIDATE_BANK_DETAILS]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SOPsUI_VALIDATE_BANK_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SOPsUI_VALIDATE_BANK_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_SOPsUI_VALIDATE_BANK_DETAILS] 
	
	@SOPSsUI_EXERCISE_AND_MIT_IDS SOPSsUI_EXERCISE_AND_MIT_IDS READONLY
AS
BEGIN
	
	SET NOCOUNT ON;
		
	CREATE TABLE #TEMP_EXERCISE_NUMBER_AVALABLE
	(
		TENA_EXERCISE_NUMBER NVARCHAR(100)
	)

	CREATE TABLE #TEMP_BANK_ID_AVALABLE
	(
		TBIA_BANK_ID NVARCHAR(100)
	)
	
	INSERT INTO #TEMP_EXERCISE_NUMBER_AVALABLE 
	SELECT STEP_IDs FROM @SOPSsUI_EXERCISE_AND_MIT_IDS

	INSERT INTO #TEMP_BANK_ID_AVALABLE 
	SELECT MIT_IDs FROM @SOPSsUI_EXERCISE_AND_MIT_IDS
	
	DELETE TENA
	FROM #TEMP_EXERCISE_NUMBER_AVALABLE AS TENA
	INNER JOIN Transaction_Details AS TD ON CONVERT(NVARCHAR(100),TD.Sh_ExerciseNo) = TENA.TENA_EXERCISE_NUMBER

	DELETE TENA
	FROM #TEMP_BANK_ID_AVALABLE AS TENA
	INNER JOIN paymentbankmaster AS PBM ON PBM.BankID = TENA.TBIA_BANK_ID
 	
	SELECT STEP_IDs AS 'IDs', 'Remove Exercise Number from Excel.' AS 'Message' FROM @SOPSsUI_EXERCISE_AND_MIT_IDS GROUP BY STEP_IDs HAVING COUNT(STEP_IDs)>1
	UNION ALL
	SELECT TENA_EXERCISE_NUMBER AS 'IDs', 'Exercise number not available in table. Please remove.' AS 'Message' FROM #TEMP_EXERCISE_NUMBER_AVALABLE
	UNION ALL
	SELECT TBIA_BANK_ID AS 'IDs', 'Mention Bank ID''s not avaiable. Please remove.' AS 'Message' FROM #TEMP_BANK_ID_AVALABLE

	SET NOCOUNT OFF;				
END
GO
