/****** Object:  StoredProcedure [dbo].[UpdateFormStatusFromTrustDB]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[UpdateFormStatusFromTrustDB]
GO
/****** Object:  StoredProcedure [dbo].[UpdateFormStatusFromTrustDB]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UpdateFormStatusFromTrustDB] 
	@TrsutCompanyId VARCHAR(150)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @RowCount INT;
	DECLARE @MIT_ID INT
	DECLARE @CURRENT_DB_NAME VARCHAR(150)
	SET @CURRENT_DB_NAME = (SELECT DB_NAME()) 
	
	CREATE TABLE #TEMP
		(
			EXERCISE_FORM_STATUS VARCHAR(1),
			IS_SELLALL_ENABLED bit,
			IS_SELLPARTIAL_ENABLED bit
		)
	
		
	INSERT INTO #TEMP			
	EXECUTE
		(	
			'SELECT  TOP 1 CASE WHEN TC.ExerciseFormID =''1'' THEN ''Y'' ELSE ''N'' END  AS ExerciseFrom,
			CASE  TC.SellTypeIDAll WHEN ''1'' THEN ''1'' ELSE ''0'' END,
			CASE  TC.SellTypeIDCoverExerciseDetails WHEN ''2'' THEN ''1'' ELSE ''0'' END
			FROM ' + @TrsutCompanyId + '..TrustCashlessDetails TC , ' + @TrsutCompanyId + '..TRUST T  
			WHERE T.TrustID =TC.TrustID  AND UPPER(T.ClientCompany) = UPPER(''' + @CURRENT_DB_NAME +  ''')  AND T.IsCashless =1 ORDER BY TC.TrustCashlessID DESC '
		)
	
	IF(SELECT COUNT(1) FROM #TEMP) > 0 
	BEGIN
	
	    SELECT @RowCount = Count(MIT_ID) from MST_INSTRUMENT_TYPE
		WHILE @RowCount > 0
		BEGIN
		    SELECT @MIT_ID = INSTRUMENT_TYPES.MIT_ID FROM (SELECT ROW_NUMBER() OVER (ORDER BY MIT_ID DESC) AS ROW_ID, MIT_ID from MST_INSTRUMENT_TYPE) INSTRUMENT_TYPES
            WHERE INSTRUMENT_TYPES.ROW_ID = @RowCount
            
			IF EXISTS (SELECT ExerciseProcessId FROM ExerciseProcessSetting WHERE PaymentMode = 'A' AND MIT_ID = @MIT_ID)
				UPDATE ExerciseProcessSetting SET TrustRecOfEXeForm = (SELECT EXERCISE_FORM_STATUS FROM #TEMP) WHERE PaymentMode = 'A' AND MIT_ID = @MIT_ID
			ELSE
				INSERT INTO ExerciseProcessSetting (PaymentMode, TrustRecOfEXeForm, MIT_ID, LastUpdatedBy, LastUpdatedOn) VALUES ('A',((SELECT EXERCISE_FORM_STATUS FROM #TEMP)), @MIT_ID, 'Admin', GETDATE())
				
				
			IF EXISTS (SELECT ExerciseProcessId FROM ExerciseProcessSetting WHERE PaymentMode = 'P' AND MIT_ID = @MIT_ID)
				UPDATE ExerciseProcessSetting SET TrustRecOfEXeForm = (SELECT EXERCISE_FORM_STATUS FROM #TEMP) WHERE PaymentMode = 'P' AND MIT_ID = @MIT_ID
			ELSE
				INSERT INTO ExerciseProcessSetting (PaymentMode, TrustRecOfEXeForm, MIT_ID, LastUpdatedBy, LastUpdatedOn) VALUES ('P',((SELECT EXERCISE_FORM_STATUS FROM #TEMP)), @MIT_ID, 'Admin', GETDATE())
				
		 SET @RowCount = @RowCount - 1;
			
		 END
	END
			
	DROP TABLE #TEMP
END
GO
