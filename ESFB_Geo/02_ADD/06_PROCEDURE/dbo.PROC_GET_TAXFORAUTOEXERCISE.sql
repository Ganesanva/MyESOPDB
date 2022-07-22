DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_TAXFORAUTOEXERCISE]
GO

CREATE   PROCEDURE [dbo].[PROC_GET_TAXFORAUTOEXERCISE]
 -- PERQUSITE TYPE ---    
 @PERQ_DETAILS  dbo.TYPE_PERQ_VALUE_AUTO_EXE READONLY,  
 -- FINAL PERQUSITE RESULT ---  
 @PERQ_RESULT  dbo.TYPE_PERQ_FORAUTOEXERCISE READONLY,  
 @ISTEMPLATE INT =NULL -- Used   
AS  
BEGIN  
  
 SET NOCOUNT ON;  
   
 CREATE  TABLE #TEMP_PERQ_TAX_VALUE    
 (         
  INSTRUMENT_ID BIGINT NULL, EMPLOYEE_ID  VARCHAR(50) NULL, COUNTRY_ID INT NULL, GRANTOPTIONID VARCHAR(100) NULL,  
  TOT_DAYS  FLOAT NULL, VESTING_DATE DATETIME NULL,GRANTLEGSERIALNO BIGINT NULL,FROM_DATE DATETIME NULL,TO_DATE DATETIME NULL,TEMP_EXERCISEID BIGINT NULL ,STOCK_VALUE NUMERIC (18,9) 
 )  
   
 ------------------------ -- GET PERQUSITE_TAX VALUE ------------------------------  
   
 DECLARE @PERQ_VALUE_TYPE dbo.TYPE_PERQ_VALUE_AUTO_EXE  
  
 INSERT INTO @PERQ_VALUE_TYPE    
 SELECT    
  INSTRUMENT_ID, EMPLOYEE_ID, EXERCISE_PRICE, OPTION_VESTED, FMV_VALUE, OPTION_EXERCISED, GRANTED_OPTIONS, EXERCISE_DATE,  
  GRANTOPTIONID, GRANTDATE, VESTINGDATE ,GRANTLEGSERIALNO,FROM_DATE,TO_DATE,TEMP_EXERCISEID  
 FROM   
  @PERQ_DETAILS  
 
   EXEC PROC_GET_PERQUISITE_TAX_VALUE @EMPLOYEE_DETAILS = @PERQ_VALUE_TYPE,@ISTEMPLATE =1  
  
 INSERT INTO #TEMP_PERQ_TAX_VALUE  
 (  
  INSTRUMENT_ID, EMPLOYEE_ID, COUNTRY_ID, GRANTOPTIONID, TOT_DAYS, VESTING_DATE,GRANTLEGSERIALNO,FROM_DATE,TO_DATE,TEMP_EXERCISEID ,STOCK_VALUE 
 )  
 SELECT   
  INSTRUMENT_ID, EMPLOYEE_ID, COUNTRY_ID, GRANTOPTIONID, TOT_DAYS, VESTINGDATE ,GRANTLEGSERIALNO,FROM_DATE,TO_DATE,TEMP_EXERCISEID ,STOCK_VALUE 
 FROM   
  TEMP_PERQUISITETAX_DETAILS  
   ORDER BY TEMP_EXERCISEID
  

 --IF EXISTS (SELECT * FROM SYS.TABLES WHERE name = 'TEMP_PERQUISITETAX_DETAILS')  
 --BEGIN  
 -- DROP TABLE TEMP_PERQUISITETAX_DETAILS    
 --END  
   
 ------------- GET PERQUSITE_TAX VALUE && GET TAX CALCULATION FOR COUNTRIES ---------------------  
  
 -- OUTPUT OF PERQUSITE TAX -----  
 DECLARE @PERQ_VALUE_TAX_TYPE_1 dbo.TYPE_PERQ_TAX_AUTOEXERC      
   
 INSERT INTO @PERQ_VALUE_TAX_TYPE_1    
 SELECT   
  INSTRUMENT_ID, EMPLOYEE_ID, COUNTRY_ID,GRANTOPTIONID,TOT_DAYS,VESTING_DATE,GRANTLEGSERIALNO,FROM_DATE ,TO_DATE,TEMP_EXERCISEID,STOCK_VALUE  
 FROM   
  #TEMP_PERQ_TAX_VALUE  
 --- OUTPUT OF PERQUSITE TAX -----  

  --------------------------
 
 BEGIN /* TOTAL NUMBER OF DAYS ADJUSTEMENT */
		
			CREATE TABLE #TEMP_PERQ_VALUE_TAX_TYPE_1
			(
				INSTRUMENT_ID NVARCHAR(10), EMPLOYEE_ID NVARCHAR(500), COUNTRY_ID BIGINT, GRANTOPTIONID NVARCHAR(100), TOT_DAYS NUMERIC(18,9),
				VESTING_DATE DATETIME, 	GRANTLEGSERIALNO BIGINT, FROM_DATE DATETIME, TO_DATE DATETIME, TEMP_EXERCISEID BIGINT, STOCK_VALUE NUMERIC(18,9)
			)

			INSERT INTO #TEMP_PERQ_VALUE_TAX_TYPE_1
			(
				INSTRUMENT_ID, EMPLOYEE_ID, COUNTRY_ID, GRANTOPTIONID, TOT_DAYS, VESTING_DATE, 	GRANTLEGSERIALNO, 
				FROM_DATE, TO_DATE, TEMP_EXERCISEID, STOCK_VALUE
			)
			SELECT 
				INSTRUMENT_ID, EMPLOYEE_ID, COUNTRY_ID, GRANTOPTIONID, TOT_DAYS, VESTING_DATE, GRANTLEGSERIALNO, 
				FROM_DATE, TO_DATE, TEMP_EXERCISEID, STOCK_VALUE
			FROM
				@PERQ_VALUE_TAX_TYPE_1 

			
			CREATE TABLE #TOTAL_NO_DAYS_ADJUSTEMENT
			(
				ID BIGINT IDENTITY (1, 1), 
				INSTRUMENT_ID NVARCHAR(10), EMPLOYEE_ID NVARCHAR(500), COUNTRY_ID BIGINT, GRANTOPTIONID NVARCHAR(100), TOT_DAYS NUMERIC(18,9),
				VESTING_DATE DATETIME, 	GRANTLEGSERIALNO BIGINT, FROM_DATE DATETIME, TO_DATE DATETIME, TEMP_EXERCISEID BIGINT, STOCK_VALUE NUMERIC(18,9),
				GROUP_NUMBER BIGINT, PARENT NVARCHAR(5)		
			)

			CREATE TABLE #TOTAL_NO_DAYS_ADJUSTED
			(
				ID BIGINT, INSTRUMENT_ID NVARCHAR(10), EMPLOYEE_ID NVARCHAR(500), COUNTRY_ID BIGINT, GRANTOPTIONID NVARCHAR(100), TOT_DAYS NUMERIC(18,9),
				VESTING_DATE DATETIME, 	GRANTLEGSERIALNO BIGINT, FROM_DATE DATETIME, TO_DATE DATETIME, TEMP_EXERCISEID BIGINT, STOCK_VALUE NUMERIC(18,9),
				GROUP_NUMBER BIGINT, PARENT NVARCHAR(5), ADJ_TOTAL_DAYS NUMERIC(18,9)
			)
			
			INSERT INTO #TOTAL_NO_DAYS_ADJUSTEMENT
			(
				INSTRUMENT_ID, EMPLOYEE_ID, COUNTRY_ID, GRANTOPTIONID, TOT_DAYS, VESTING_DATE, GRANTLEGSERIALNO, FROM_DATE, TO_DATE, 
				TEMP_EXERCISEID, STOCK_VALUE, GROUP_NUMBER, PARENT	
			)
			SELECT 
				TPVTT.INSTRUMENT_ID, TPVTT.EMPLOYEE_ID, TPVTT.COUNTRY_ID, TPVTT.GRANTOPTIONID, TPVTT.TOT_DAYS, TPVTT.VESTING_DATE, TPVTT.GRANTLEGSERIALNO, 
				TPVTT.FROM_DATE, TPVTT.TO_DATE, TPVTT.TEMP_EXERCISEID, TPVTT.STOCK_VALUE, GMOEN_TDAYS.GroupNumber, GMOEN_TDAYS.PARENT
			FROM
				#TEMP_PERQ_VALUE_TAX_TYPE_1 AS TPVTT
				INNER JOIN GrantMappingOnExNow AS GMOEN_TDAYS ON GMOEN_TDAYS.GrantOptionId = TPVTT.GRANTOPTIONID
			ORDER BY 
				GMOEN_TDAYS.GroupNumber, TPVTT.COUNTRY_ID, TPVTT.FROM_DATE, TPVTT.TO_DATE ASC, TPVTT.TEMP_EXERCISEID, GMOEN_TDAYS.PARENT DESC		
			
			INSERT INTO #TOTAL_NO_DAYS_ADJUSTED
			(
				ID, INSTRUMENT_ID, EMPLOYEE_ID, COUNTRY_ID, GRANTOPTIONID, TOT_DAYS, VESTING_DATE, GRANTLEGSERIALNO, FROM_DATE, TO_DATE, 
				TEMP_EXERCISEID, STOCK_VALUE, GROUP_NUMBER, PARENT, ADJ_TOTAL_DAYS
			) 			
			SELECT TOP 1 
				TNDD.ID, TNDD.INSTRUMENT_ID, TNDD.EMPLOYEE_ID, TNDD.COUNTRY_ID, TNDD.GRANTOPTIONID, TNDD.TOT_DAYS, TNDD.VESTING_DATE, TNDD.GRANTLEGSERIALNO, 
				TNDD.FROM_DATE, TNDD.TO_DATE, TNDD.TEMP_EXERCISEID, TNDD.STOCK_VALUE, TNDD.GROUP_NUMBER, TNDD.PARENT,
				CASE WHEN ((TNDD.TOT_DAYS <= 0)  AND ((TNDD.ID % 2 ) <> 0)) THEN 0 ELSE TNDD.TOT_DAYS END AS PERQST_VALUE				 
			FROM 
				#TOTAL_NO_DAYS_ADJUSTEMENT AS TNDD			
			UNION ALL
			SELECT 
				TNDD.ID, TNDD.INSTRUMENT_ID, TNDD.EMPLOYEE_ID, TNDD.COUNTRY_ID, TNDD.GRANTOPTIONID, TNDD.TOT_DAYS, TNDD.VESTING_DATE, TNDD.GRANTLEGSERIALNO, 
				TNDD.FROM_DATE, TNDD.TO_DATE, TNDD.TEMP_EXERCISEID, TNDD.STOCK_VALUE, TNDD.GROUP_NUMBER, TNDD.PARENT,
				CASE WHEN ((TNDD.TOT_DAYS <= 0)  AND ((TNDD.ID % 2 ) <> 0)) THEN 0 
						WHEN ((TNDD.TOT_DAYS > 0) AND (T_TNDD_SELF.TOT_DAYS > 0)) THEN TNDD.TOT_DAYS 
					ELSE T_TNDD_SELF.TOT_DAYS + TNDD.TOT_DAYS  END AS PERQ_VALUE				
			FROM 
				#TOTAL_NO_DAYS_ADJUSTEMENT AS TNDD
				INNER JOIN #TOTAL_NO_DAYS_ADJUSTEMENT AS T_TNDD_SELF ON (T_TNDD_SELF.PARENT <> TNDD.PARENT)
				 AND  (T_TNDD_SELF.ID = TNDD.ID - 1)
			

			 UPDATE PVTT_DAYS 
				SET PVTT_DAYS.TOT_DAYS = TNDA.ADJ_TOTAL_DAYS
			 FROM 
				@PERQ_VALUE_TAX_TYPE_1 AS PVTT_DAYS
				INNER JOIN #TOTAL_NO_DAYS_ADJUSTED AS TNDA ON (TNDA.GRANTLEGSERIALNO = PVTT_DAYS.GRANTLEGSERIALNO) 
					AND (TNDA.TEMP_EXERCISEID = PVTT_DAYS.TEMP_EXERCISEID) AND (TNDA.COUNTRY_ID = PVTT_DAYS.COUNTRY_ID)
					AND  ( ISNULL(TNDA.FROM_DATE,'') = ISNULL(PVTT_DAYS.FROM_DATE,'')) AND (ISNULL(TNDA.TO_DATE,'') = ISNULL(PVTT_DAYS.TO_DATE,''))
						
		END /* ******************************* */

		--- OUTPUT OF PERQUSITE TAX -----  
	IF EXISTS (SELECT * FROM SYS.TABLES WHERE name = 'TEMP_PERQUISITETAX_DETAILS')  
	BEGIN  
		DROP TABLE TEMP_PERQUISITETAX_DETAILS    
	END  

 ----------------------------------------
   --- PERQUSITE TYPE --------  
 DECLARE @PERQ_TYPE_1 dbo.TYPE_PERQ_FORAUTOEXERCISE   
 INSERT INTO @PERQ_TYPE_1   
 SELECT   
  MIT_ID, EmployeeID, FMV, Total_Perk_Value, EVENT_OF_INCIDENCE, GRANT_DATE, VESTING_DATE, EXERCISE_DATE, GRANTOPTIONID,GRANTLEGSERIALNO,TEMP_EXERCISEID ,NULL   
 FROM   
  @PERQ_RESULT     
   
 ----- PERQUSITE TYPE --------  

 EXEC PROC_TENTATIVETAX_FORAUTOEXERCISE @TYPE_PERQ_TAX_AUTOEXERC = @PERQ_VALUE_TAX_TYPE_1, @TYPE_PERQ_AUTOEXERCISE = @PERQ_TYPE_1   
  
  
 
	DROP TABLE #TEMP_PERQ_VALUE_TAX_TYPE_1
	DROP TABLE #TOTAL_NO_DAYS_ADJUSTEMENT
	DROP TABLE #TOTAL_NO_DAYS_ADJUSTED
	
	
 SET NOCOUNT OFF;  
END
GO
