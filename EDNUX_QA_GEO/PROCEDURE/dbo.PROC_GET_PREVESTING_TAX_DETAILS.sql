/****** Object:  StoredProcedure [dbo].[PROC_GET_PREVESTING_TAX_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_PREVESTING_TAX_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_PREVESTING_TAX_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_PREVESTING_TAX_DETAILS]
	@EPPS_ID INT = NULL	,
	@Exercise_Number varchar(50) = NULL	
AS
BEGIN
	SET NOCOUNT ON;	
	
	     DECLARE @DisplayAs CHAR(1),@DisplaySplit CHAR(1)
	    CREATE TABLE #TEMP_PREVESTING_TAX
		(
			TAX_HEADING NVARCHAR (250), TAX_RATE NUMERIC (18, 2), RESIDENT_STATUS VARCHAR (100), TAX_AMOUNT FLOAT, 
			Country VARCHAR (50), STATE VARCHAR (1), BASISOFTAXATION NVARCHAR (250), FMV FLOAT, TOTAL_PERK_VALUE FLOAT, 
			COUNTRY_ID NUMERIC (18,0),GRANTLEGSERIALNO BIGINT, FROM_DATE DATETIME, TO_DATE DATETIME
			
		)

		SELECT @DisplayAs = DisplayAs,@DisplaySplit = DisplaySplit FROM BonusSplitPolicy
						
					/* GEt Tax details*/
					

					BEGIN

					   IF(@EPPS_ID != 0)
	             	  BEGIN
						/* Resident data*/
						INSERT INTO #TEMP_PREVESTING_TAX 
						
						(
							TAX_HEADING, TAX_RATE, RESIDENT_STATUS, TAX_AMOUNT, Country, STATE, BASISOFTAXATION, FMV, TOTAL_PERK_VALUE, COUNTRY_ID, GRANTLEGSERIALNO ,FROM_DATE,TO_DATE
						)						

						
						SELECT * FROM (
						
						SELECT Tax_Title AS TAX_HEADING ,TAX_RATE ,RT.[Description] AS RESIDENT_STATUS 
						,CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVETAXAMOUNT,0) ,'TAXVALUE') ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVETAXAMOUNT,0),'TAXVALUE') END AS TAX_AMOUNT
						,'' AS Country ,'' AS [STATE] ,BASISOFTAXATION ,
						CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax'
						THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVEFMVVALUE,0),'FMV') 
						ELSE
						  CASE WHEN ISNULL(FMVVALUE,0)=0 THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEFMVVALUE,'FMV') ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEFMVVALUE,'FMV')  END end AS FMV
						
						,CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' 
						THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVEPERQVALUE,0),'TAXVALUE') 
						ELSE
						  CASE WHEN ISNULL(PERQVALUE,0)=0 THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEPERQVALUE,'TAXVALUE') ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEPERQVALUE,'TAXVALUE')  END end AS TOTAL_PERK_VALUE
						 , 0 AS COUNTRY_ID ,
						ISNULL(TAX_SEQ_NO,GRANTLEGSERIALNO) AS GRANTLEGSERIALNO,ETD.FROM_DATE,ETD.TO_DATE
						FROM EXERCISE_TAXRATE_DETAILS ETD 
						INNER JOIN ShExercisedOptions SH ON SH.ExerciseId=ETD.EXERCISE_NO   
						INNER JOIN ResidentialType RT ON ETD.RESIDENT_ID=RT.id
						INNER JOIN GrantLeg GL ON GL.ID=SH.GrantLegSerialNumber
						INNER JOIN  Scheme AS SCH	on SCH.SchemeId = GL.SchemeId
						WHERE SH.ExerciseId=@EPPS_ID AND ISNULL(COUNTRY_ID,0)=0 AND ISNULL(RESIDENT_ID,0)>0
					   
					    UNION
					
						SELECT  Tax_Title AS TAX_HEADING ,dbo.FN_PQ_TAX_ROUNDING(TAX_RATE) AS TAX_RATE ,'' AS RESIDENT_STATUS ,	
						CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(SUM(ISNULL(TENTATIVETAXAMOUNT,0)) ,'TAXVALUE') ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(SUM(ISNULL(TENTATIVETAXAMOUNT,0)) ,'TAXVALUE') END AS TAX_AMOUNT,
						CM.CountryName AS Country ,'' AS [STATE] ,BASISOFTAXATION ,						
						CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' 
						THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVEFMVVALUE,0),'FMV')
						ELSE 
						CASE WHEN ISNULL(FMVVALUE,0)=0 THEN     dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEFMVVALUE,'FMV') ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEFMVVALUE,'FMV')  END end AS FMV,
						
						SUM(CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax'
						THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVEPERQVALUE,0),'TAXVALUE') ELSE 
						CASE WHEN ISNULL(PERQVALUE,0)=0 THEN     dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEPERQVALUE,'TAXVALUE') ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEPERQVALUE,'TAXVALUE')  END end) AS TOTAL_PERK_VALUE,
						CM.ID AS COUNTRY_ID ,GRANTLEGSERIALNO ,MAX(ETD.FROM_DATE) AS FROM_DATE,MAX(ETD.TO_DATE) AS TO_DATE
						FROM EXERCISE_TAXRATE_DETAILS ETD
						INNER JOIN ShExercisedOptions SH ON SH.ExerciseId=ETD.EXERCISE_NO   
						INNER JOIN CountryMaster CM ON ETD.COUNTRY_ID=CM.id
						INNER JOIN GrantLeg GL ON GL.ID=SH.GrantLegSerialNumber
						INNER JOIN  Scheme AS SCH	on SCH.SchemeId = GL.SchemeId
						WHERE SH.ExerciseId=@EPPS_ID AND ISNULL(COUNTRY_ID,0)>0 AND ISNULL(RESIDENT_ID,0)=0
						GROUP BY Tax_Title, TAX_RATE ,CM.CountryName ,BASISOFTAXATION ,FMVVALUE, TENTATIVEFMVVALUE,	CM.ID ,GRANTLEGSERIALNO,SH.CALCULATE_TAX
						
					    UNION
						
						SELECT  Tax_Title AS TAX_HEADING ,TAX_RATE ,'' AS RESIDENT_STATUS 
						,CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVETAXAMOUNT,0) ,'TAXVALUE') ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVETAXAMOUNT,0) ,'TAXVALUE') END AS TAX_AMOUNT 
						,'' AS Country ,'' AS [STATE] ,BASISOFTAXATION ,
						CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' 
						THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVEFMVVALUE,0),'FMV') ELSE
						 CASE WHEN ISNULL(FMVVALUE,0)=0 THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEFMVVALUE,'FMV') ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEFMVVALUE,'FMV')  END end AS FMV
						
						,CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax'
						THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVEPERQVALUE,0),'TAXVALUE') ELSE 
						  CASE WHEN ISNULL(PERQVALUE,0)=0 THEN     dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEPERQVALUE,'TAXVALUE') ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEPERQVALUE,'TAXVALUE')  END end AS TOTAL_PERK_VALUE
						, 0 AS COUNTRY_ID ,
						ISNULL(TAX_SEQ_NO,GRANTLEGSERIALNO) AS GRANTLEGSERIALNO, FROM_DATE, TO_DATE
						FROM EXERCISE_TAXRATE_DETAILS
						INNER JOIN ShExercisedOptions SH ON SH.ExerciseId=EXERCISE_TAXRATE_DETAILS.EXERCISE_NO 
						INNER JOIN GrantLeg GL ON GL.ID=SH.GrantLegSerialNumber
						INNER JOIN  Scheme AS SCH	on SCH.SchemeId = GL.SchemeId  
						WHERE SH.ExerciseId=@EPPS_ID AND ISNULL(COUNTRY_ID,0)=0 AND ISNULL(RESIDENT_ID,0)=0					
					) AS  T 
					ORDER BY  T.TAX_HEADING
					  END
                      ELSE
					     BEGIN 
						
					  /* Resident data*/
							INSERT INTO #TEMP_PREVESTING_TAX 
						
							(
								TAX_HEADING, TAX_RATE, RESIDENT_STATUS, TAX_AMOUNT, Country, STATE, BASISOFTAXATION, FMV, TOTAL_PERK_VALUE, COUNTRY_ID, GRANTLEGSERIALNO ,FROM_DATE,TO_DATE
							)						

						
							SELECT * FROM (
						
							SELECT Tax_Title AS TAX_HEADING ,TAX_RATE ,RT.[Description] AS RESIDENT_STATUS 
							, CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' 
							THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(SUM(ISNULL(TENTATIVETAXAMOUNT,0)) ,'TAXVALUE') ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(SUM(ISNULL(TENTATIVETAXAMOUNT,0)) ,'TAXVALUE') END AS TAX_AMOUNT
							,'' AS Country ,'' AS [STATE] ,BASISOFTAXATION ,
							CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax'
							THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVEFMVVALUE,0),'FMV') 
							ELSE
							  CASE WHEN ISNULL(FMVVALUE,0)=0 THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEFMVVALUE,'FMV') ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEFMVVALUE,'FMV')  END end AS FMV
							,
							CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax'
							THEN SUM( dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVEPERQVALUE,0),'TAXVALUE') )
							ELSE 
							 CASE WHEN SUM(ISNULL(PERQVALUE,0))=0 THEN    
							SUM( dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEPERQVALUE,'TAXVALUE') )
							 ELSE 
							SUM( dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEPERQVALUE,'TAXVALUE') )
							 END end AS TOTAL_PERK_VALUE, 0 AS COUNTRY_ID ,
							0 AS GRANTLEGSERIALNO,ETD.FROM_DATE,ETD.TO_DATE
							FROM EXERCISE_TAXRATE_DETAILS ETD 
							INNER JOIN ShExercisedOptions SH ON SH.ExerciseId=ETD.EXERCISE_NO   
							INNER JOIN ResidentialType RT ON ETD.RESIDENT_ID=RT.id
							INNER JOIN GrantLeg GL ON GL.ID=SH.GrantLegSerialNumber
							INNER JOIN  Scheme AS SCH	on SCH.SchemeId = GL.SchemeId
							WHERE SH.ExerciseNo=@Exercise_Number AND ISNULL(COUNTRY_ID,0)=0 AND ISNULL(RESIDENT_ID,0)>0
							GROUP BY Tax_Title ,TAX_RATE ,SH.CALCULATE_TAX,RT.[Description],
							BASISOFTAXATION ,TENTATIVEFMVVALUE,FMVVALUE,COUNTRY_ID,FROM_DATE, TO_DATE
					   
							UNION
					
							SELECT  Tax_Title AS TAX_HEADING ,dbo.FN_PQ_TAX_ROUNDING(TAX_RATE) AS TAX_RATE ,'' AS RESIDENT_STATUS ,	
							CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' 
							THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(SUM(ISNULL(TENTATIVETAXAMOUNT,0)) ,'TAXVALUE') ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(SUM(ISNULL(TENTATIVETAXAMOUNT,0)) ,'TAXVALUE') END AS TAX_AMOUNT,
							CM.CountryName AS Country ,'' AS [STATE] ,BASISOFTAXATION ,						
							CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' 
							THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVEFMVVALUE,0),'FMV')
							ELSE 
							CASE WHEN ISNULL(FMVVALUE,0)=0 THEN     dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEFMVVALUE,'FMV') ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEFMVVALUE,'FMV')  END end AS FMV,
						
						
						    CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax'
							THEN SUM( dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVEPERQVALUE,0),'TAXVALUE') )
							ELSE 
							 CASE WHEN SUM(ISNULL(PERQVALUE,0))=0 THEN    
							SUM( dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEPERQVALUE,'TAXVALUE') )
							 ELSE 
							SUM( dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEPERQVALUE,'TAXVALUE') )
							 END end AS TOTAL_PERK_VALUE,

							CM.ID AS COUNTRY_ID ,0 ,MAX(ETD.FROM_DATE) AS FROM_DATE,MAX(ETD.TO_DATE) AS TO_DATE
							FROM EXERCISE_TAXRATE_DETAILS ETD
							INNER JOIN ShExercisedOptions SH ON SH.ExerciseId=ETD.EXERCISE_NO   
							INNER JOIN CountryMaster CM ON ETD.COUNTRY_ID=CM.id
							INNER JOIN GrantLeg GL ON GL.ID=SH.GrantLegSerialNumber
							INNER JOIN  Scheme AS SCH	on SCH.SchemeId = GL.SchemeId
							WHERE SH.ExerciseNo=@Exercise_Number AND ISNULL(COUNTRY_ID,0)>0 AND ISNULL(RESIDENT_ID,0)=0
							GROUP BY Tax_Title, TAX_RATE ,CM.CountryName ,BASISOFTAXATION ,FMVVALUE, TENTATIVEFMVVALUE,	CM.ID ,SH.CALCULATE_TAX
						
							UNION
							

							SELECT  Tax_Title AS TAX_HEADING ,TAX_RATE ,'' AS RESIDENT_STATUS ,
							CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN SUM( dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVETAXAMOUNT,0) ,'TAXVALUE'))
							ELSE  SUM(dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVETAXAMOUNT,0) ,'TAXVALUE')) END AS TAX_AMOUNT
							,'' AS Country ,'' AS [STATE] ,BASISOFTAXATION ,
							 CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' 
							 THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVEFMVVALUE,0),'FMV') ELSE
							 CASE WHEN ISNULL(FMVVALUE,0)=0 THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEFMVVALUE,'FMV') 
							 ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEFMVVALUE,'FMV')  END end AS FMV
						 
							,CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax'
							THEN SUM( dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVEPERQVALUE,0),'TAXVALUE') )
							ELSE 
							 CASE WHEN SUM(ISNULL(PERQVALUE,0))=0 THEN    
							SUM( dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEPERQVALUE,'TAXVALUE') )
							 ELSE 
							SUM( dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEPERQVALUE,'TAXVALUE') )
							 END end AS TOTAL_PERK_VALUE, 0 AS COUNTRY_ID ,0, FROM_DATE, TO_DATE
						
						
							FROM EXERCISE_TAXRATE_DETAILS
							INNER JOIN ShExercisedOptions SH ON SH.ExerciseId=EXERCISE_TAXRATE_DETAILS.EXERCISE_NO 
							INNER JOIN GrantLeg GL ON GL.ID=SH.GrantLegSerialNumber
							INNER JOIN  Scheme AS SCH	on SCH.SchemeId = GL.SchemeId  
							WHERE SH.ExerciseNo=@Exercise_Number AND ISNULL(COUNTRY_ID,0)=0 AND ISNULL(RESIDENT_ID,0)=0	
							GROUP BY Tax_Title ,TAX_RATE ,SH.CALCULATE_TAX
							,BASISOFTAXATION ,TENTATIVEFMVVALUE,FMVVALUE,COUNTRY_ID,FROM_DATE, TO_DATE



						) AS  T 
						ORDER BY  T.TAX_HEADING
					  
					  END
				    END
				
				SELECT * FROM #TEMP_PREVESTING_TAX ORDER BY TAX_HEADING DESC 
				DROP TABLE #TEMP_PREVESTING_TAX
	SET NOCOUNT OFF;	
END
GO
