DROP PROCEDURE IF EXISTS [dbo].[PROC_TENTATIVETAX_FORAUTOEXERCISE]
GO

CREATE   PROCEDURE  [dbo].[PROC_TENTATIVETAX_FORAUTOEXERCISE]
(     
     -- OUTPUT OF PERQ_TAX  
    @TYPE_PERQ_TAX_AUTOEXERC  dbo.TYPE_PERQ_TAX_AUTOEXERC  READONLY,   
     --- NEW TYPE  
    @TYPE_PERQ_AUTOEXERCISE  dbo.TYPE_PERQ_FORAUTOEXERCISE READONLY  
)  
 
AS  
BEGIN      
 SET NOCOUNT ON;    
     
  DECLARE     
  @EXCEPT_FOR_TAXRATE_VAL INT, @EXCEPT_FOR_TAXRATE NVARCHAR(50), @IS_TAXRATE_ACTIVE INT, @IS_TAXRATEEXCEPTION_ACTIVE INT,    
  @TAX_IDENTIFIER_COUNTRY NVARCHAR(50), @TAX_IDENTIFIER_STATE NVARCHAR(50), @DateOfTermination NVARCHAR(50),     
  @COUNTRY_CATEGORY_PROPORT VARCHAR(50), @MIT_ID INT, @EmployeeID VARCHAR(50), @FMV NUMERIC(18,6), @Total_Perk_Value NUMERIC(18,6),    
  @EVENT_OF_INCIDENCE INT, @GRANT_DATE DATETIME , @VESTING_DATE DATETIME, @EXERCISE_DATE DateTime, @MN_VALUE INT, @MX_VALUE INT,    
  @GRANTOPTION_ID VARCHAR(50),@GRANTLEGSERIAL_NO BIGINT,@FROM_DATE_TAX DATETIME,@TO_DATE_TAX DATETIME,@TEMP_EXERCISEID BIGINT,@STOCK_VALUE NUMERIC (18,9)     
  ,@EXCEPT_FOR_TAXRATE_EMPLOYEE  NVARCHAR(50),@ResidentStatus NVARCHAR(500),@Resident_ID BIGINT,@Country_ID BIGINT, @Country_Name NVARCHAR(250), 
  @EventOfIncidence NVARCHAR(50), @INCIDENCEDATE DATETIME ,@IS_COMPANY_LEVEL INT ,@MINVALUE INT ,@MaxValue INT ,
  @IsResident INT ,@IsNonResident   INT ,@IsForeignNational  INT,@IsTaxApplicable  VARCHAR(500)
    ---- CREATE TEMP TABLE --         
 CREATE TABLE #TEMP_TAX_COUNTRY_DAYS    
 (      
	  ID INT IDENTITY(1,1) NOT NULL, 
	  INSTRUMENT_ID BIGINT, 
	  EMPLOYEE_ID VARCHAR(50), 
	  COUNTRY_ID INT, 
	  GRANTOPTIONID VARCHAR(50),     
	  TOT_DAYS NUMERIC (18,9),
	  GRANTLEGSERIALNO BIGINT,
	  FROM_DATE DATETIME,
	  TO_DATE DATETIME,
	  TEMP_EXERCISEID BIGINT,
	  STOCK_VALUE NUMERIC (18,9)   
 )          
              
 CREATE TABLE #TEMP_PERQ_AUTO    
 (      
	  ID INT IDENTITY(1,1) NOT NULL, 
	  MIT_ID INT, 
	  EmployeeID VARCHAR(50), 
	  FMV NUMERIC(18,6), 
	  Total_Perk_Value NUMERIC(18,6),      
	  EVENT_OF_INCIDENCE INT, 
	  GRANT_DATE DATETIME, 
	  VESTING_DATE DATETIME, 
	  EXERCISE_DATE DATETIME, 
	  GRANTOPTIONID VARCHAR(50),
	  GRANTLEGSERIALNO BIGINT,
	  TEMP_EXERCISEID BIGINT     
 )      
     
 CREATE TABLE #TEMP_EMPLOYEE_COUNTRY    
 (      
	  ID INT IDENTITY(1,1) NOT NULL, 
	  INSTRUMENT_ID BIGINT, 
	  EMPLOYEE_ID VARCHAR(50), 
	  COUNTRY_ID INT, 
	  GRANTOPTIONID VARCHAR(50),    
	  TOT_DAYS  NUMERIC (18,9), 
	  VESTING_DATE DATETIME,
	  GRANTLEGSERIALNO BIGINT,
	  FROM_DATE DATETIME,
	  TO_DATE DATETIME,
	  TEMP_EXERCISEID BIGINT,
	  STOCK_VALUE NUMERIC (18,9)    
 )       
    
 CREATE TABLE #TempTax_Details    
 (    
	  TAX_HEADING NVARCHAR(50), 
	  TAX_RATE FLOAT, 
	  RESIDENT_STATUS NVARCHAR(250), 
	  TAX_AMOUNT FLOAT, 
	  Country NVARCHAR(250) ,    
	  [STATE] NVARCHAR(250),
	  BASISOFTAXATION NVARCHAR(250),
	  FMV NVARCHAR(250),
	  TOTAL_PERK_VALUE FLOAT, 
	  RESIDENT_ID INT NULL,   
	  COUNTRY_ID INT, 
	  MIT_ID INT,EmployeeID VARCHAR(50),
	  GRANTOPTIONID VARCHAR(50),
	  VESTING_DATE DATETIME,
	  GRANT_DATE DATETIME NULL,
	  GRANTLEGSERIALNO BIGINT null,
	  FROM_DATE DATETIME,    
	  TO_DATE DATETIME,
	  TEMP_EXERCISEID BIGINT,
	  TAXCALCULATION_BASEDON VARCHAR (50), 
	  STOCK_VALUE NUMERIC (18,9)    
 )    
    
 CREATE TABLE #TempMobility_Tracking    
 (     
		ID BIGINT, 
		Country NVARCHAR(250), 
		FromDate DATETIME, 
		Todate DATETIME    
 )      
      
 CREATE TABLE #TEMP_PERQ_TAX_AUTOEXERC    
 (    
		ID INT IDENTITY(1,1) NOT NULL,
		INSTRUMENT_ID BIGINT, 
		EMPLOYEE_ID VARCHAR(50),
		COUNTRY_ID INT,
		GRANTOPTIONID VARCHAR(50),
		TOT_DAYS FLOAT,
		VESTING_DATE DATETIME,
		GRANTLEGSERIALNO BIGINT,
		TEMP_EXERCISEID BIGINT,
		STOCK_VALUE NUMERIC (18,9)     
 )    
     
 INSERT INTO #TEMP_PERQ_TAX_AUTOEXERC    
 (    
		INSTRUMENT_ID,
		EMPLOYEE_ID,
		COUNTRY_ID ,
		GRANTOPTIONID ,
		TOT_DAYS ,
		VESTING_DATE,
		GRANTLEGSERIALNO,
		TEMP_EXERCISEID,
		STOCK_VALUE    
 )    
 SELECT INSTRUMENT_ID,
		EMPLOYEE_ID,
		COUNTRY_ID ,
		GRANTOPTIONID ,
		TOT_DAYS ,
		VESTING_DATE,
		GRANTLEGSERIALNO,
		TEMP_EXERCISEID,STOCK_VALUE  
FROM @TYPE_PERQ_TAX_AUTOEXERC    
           
 INSERT INTO #TEMP_EMPLOYEE_COUNTRY    
 (    
		INSTRUMENT_ID, 
		EMPLOYEE_ID, 
		COUNTRY_ID, 
		GRANTOPTIONID, 
		TOT_DAYS,
		VESTING_DATE ,
		GRANTLEGSERIALNO,
		FROM_DATE,
		TO_DATE,
		TEMP_EXERCISEID ,
		STOCK_VALUE   
 )    
 SELECT     
		INSTRUMENT_ID, 
		EMPLOYEE_ID, 
		COUNTRY_ID, 
		GRANTOPTIONID, 
		TOT_DAYS, 
		VESTING_DATE ,
		GRANTLEGSERIALNO,
		FROM_DATE,
		TO_DATE,
		TEMP_EXERCISEID ,
		STOCK_VALUE   
 FROM   @TYPE_PERQ_TAX_AUTOEXERC    
    
 INSERT INTO #TEMP_PERQ_AUTO    
 (    
		MIT_ID, 
		EmployeeID,
		FMV, 
		Total_Perk_Value, 
		EVENT_OF_INCIDENCE, 
		GRANT_DATE, 
		VESTING_DATE, 
		EXERCISE_DATE, 
		GRANTOPTIONID,
		GRANTLEGSERIALNO,
		TEMP_EXERCISEID    
 )       
 SELECT     
		MIT_ID, 
		EmployeeID, 
		FMV,
		Total_Perk_Value, 
		EVENT_OF_INCIDENCE, 
		GRANT_DATE, 
		VESTING_DATE, 
		EXERCISE_DATE, 
		GRANTOPTIONID,
		GRANTLEGSERIALNO,
		TEMP_EXERCISEID     
 FROM   @TYPE_PERQ_AUTOEXERCISE    
    
 SELECT @MN_VALUE = MIN(ID),@MX_VALUE = MAX(ID) FROM #TEMP_PERQ_AUTO     
          
WHILE(@MN_VALUE <= @MX_VALUE)    
BEGIN      
	SELECT     
		@MIT_ID = MIT_ID, 
		@EmployeeID = EmployeeID, 
		@FMV = FMV, 
		@Total_Perk_Value = Total_Perk_Value,      
		@EVENT_OF_INCIDENCE = EVENT_OF_INCIDENCE, 
		@GRANT_DATE= GRANT_DATE, 
		@VESTING_DATE = VESTING_DATE,     
		@EXERCISE_DATE = EXERCISE_DATE, 
		@GRANTOPTION_ID = GRANTOPTIONID ,
		@GRANTLEGSERIAL_NO=GRANTLEGSERIALNO,
		@TEMP_EXERCISEID = TEMP_EXERCISEID    
	FROM    #TEMP_PERQ_AUTO     
	WHERE     
		ID = @MN_VALUE   
 
   
	SELECT @STOCK_VALUE = STOCK_VALUE
	FROM   #TEMP_EMPLOYEE_COUNTRY     
	WHERE  GRANTLEGSERIALNO = @GRANTLEGSERIAL_NO 
			AND  TEMP_EXERCISEID = @TEMP_EXERCISEID     
    
	SELECT	@EXCEPT_FOR_TAXRATE = CM.EXCEPT_FOR_TAXRATE, 
			@EXCEPT_FOR_TAXRATE_VAL = CM.EXCEPT_FOR_TAXRATE_VAL,    
			@COUNTRY_CATEGORY_PROPORT = COUNTRY_CATEGORY_PROPORT , 
			@EXCEPT_FOR_TAXRATE_EMPLOYEE =  EXCEPT_FOR_TAXRATE_EMPLOYEE ,			
		
		    @IsResident = IsResident,
			@IsNonResident = IsNonResident,
			@IsForeignNational = IsForeignNational,
			@IsTaxApplicable = IsTaxApplicable

	FROM  COMPANY_INSTRUMENT_MAPPING CM    
	WHERE CM.MIT_ID = @MIT_ID       
      
	SELECT   @TAX_IDENTIFIER_COUNTRY = EM.TAX_IDENTIFIER_COUNTRY, 
			 @TAX_IDENTIFIER_STATE = EM.TAX_IDENTIFIER_STATE,    
			 @DateOfTermination = EM.DATEOFTERMINATION   ,
			 @Resident_ID = ISNULL(RT.ID,0) ,
			 @ResidentStatus = ISNULL(RT.[Description],'') 
	FROM     
	EmployeeMaster EM LEFT JOIN RESIDENTIALTYPE RT ON RT.ResidentialStatus = EM.ResidentialStatus       
	WHERE  EM.EmployeeID = @EmployeeID  AND ISNULL(Deleted,0)=0

  --SELECT     
  --   @ResidentStatus = ISNULL(RT.ID,0)     
  --  FROM     
  --   EmployeeMaster EM LEFT JOIN RESIDENTIALTYPE RT ON RT.ResidentialStatus = EM.ResidentialStatus     
  --  WHERE     
  --   EmployeeID=@EmployeeID AND ISNULL(Deleted,0)=0 
  
	IF(@Resident_ID = @IsResident OR @Resident_ID  = @IsNonResident OR @Resident_ID = @IsForeignNational OR (@Resident_ID IS NULL) OR @Resident_ID=' ')
	BEGIN
	print '**print in*******************'
		print '*********************'
  IF(@EXCEPT_FOR_TAXRATE_VAL = '1')    
  BEGIN               
    -- check exception For Tax Rate is Resident --    
	   IF(@EXCEPT_FOR_TAXRATE='R')    
	   BEGIN    
		/* Tax rate calculation for residential*/    
			IF EXISTS    
			(    
				 SELECT     
				  TR.TRSC_ID     
				 FROM    
				  TAX_RATE_SETTING_CONFIG TR     
				  INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id    
				  INNER JOIN COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID = CM.MIT_ID     
				  INNER JOIN RESIDENTIALTYPE RT ON RT.ID = TR.RESIDENTIAL_ID 
				  INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID AND ISNULL(TRM.Employee_ID,'')=''   
				 WHERE    
				  TR.MIT_ID = @MIT_ID AND ISNULL(TR.RESIDENTIAL_ID,0)=@Resident_ID AND ISNULL(TR.COUNTRY_ID,0)=0  AND TR.IS_TAXRATEAPPLICABLE = 1  AND TAX_RATE_STATUS_DETAILS = 1     
			)    
			BEGIN    
				 IF(ISNULL(LEN(@DateOfTermination),0)<=0)   
				 BEGIN    
						INSERT INTO #TempTax_Details    
						(    
							TAX_HEADING, 
							TAX_RATE, 
							RESIDENT_STATUS, 
							TAX_AMOUNT, 
							Country, 
							[STATE], 
							BASISOFTAXATION, 
							FMV, 
							TOTAL_PERK_VALUE, 
							RESIDENT_ID,    
							COUNTRY_ID, 
							MIT_ID,
							EmployeeID, 
							GRANTOPTIONID, 
							VESTING_DATE,
							GRANT_DATE,
							GRANTLEGSERIALNO,
							TAXCALCULATION_BASEDON ,
							TEMP_EXERCISEID   
						)    
						SELECT    
							CASE WHEN @Total_Perk_Value = '-990099' THEN 'NA' ELSE
					MTRT.TAX_HEADING END, 
							dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_LIVE_EMPLOYEE) AS TAX_RATE, 
							RT.[Description] AS RESIDENT_STATUS,    
							CASE WHEN @Total_Perk_Value = '-990099' THEN -990099 ELSE
							dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_LIVE_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100), 'TAXAMT')
							END AS TAX_AMOUNT ,   
							
							NULL AS Country, 
							NULL AS [STATE],
							CASE WHEN @Total_Perk_Value = '-990099' THEN  CASE WHEN(@IsTaxApplicable = '') THEN 'NA' ELSE @IsTaxApplicable END  ELSE
							'Resident Level' END AS BASISOFTAXATION,   
							dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV, 
							((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
							RT.ID, 
							0 AS COUNTRY_ID, 
							@MIT_ID, 
							@EmployeeID,     
							@GRANTOPTION_ID,
							@VESTING_DATE,
							@GRANT_DATE,
							@GRANTLEGSERIAL_NO,
							TAXCALCULATION_BASEDON,
							@TEMP_EXERCISEID     
						FROM    
							TAX_RATE_SETTING_CONFIG TR     
							INNER JOIN COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID = CM.MIT_ID  
							INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID   
							INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID=TR.Tax_Head_Id 
							INNER JOIN RESIDENTIALTYPE RT ON RT.ID=TR.RESIDENTIAL_ID          
						WHERE    
							TR.MIT_ID = @MIT_ID 
							AND ISNULL(TRM.Employee_ID,'')='' 
							AND ISNULL(TR.RESIDENTIAL_ID,0)=@Resident_ID 
							AND ISNULL(TR.COUNTRY_ID,0)=0           
				 END             
				 ELSE    
				 BEGIN     
						INSERT INTO #TempTax_Details    
						(    
							TAX_HEADING, 
							TAX_RATE, 
							RESIDENT_STATUS, 
							TAX_AMOUNT, 
							Country, 
							[STATE], 
							BASISOFTAXATION, 
							FMV, 
							TOTAL_PERK_VALUE, 
							RESIDENT_ID,
							COUNTRY_ID,    
							MIT_ID, 
							EmployeeID, 
							GRANTOPTIONID, 
							VESTING_DATE,
							GRANT_DATE,
							GRANTLEGSERIALNO,
							TAXCALCULATION_BASEDON,
							TEMP_EXERCISEID    
						)     
						SELECT    
							CASE WHEN @Total_Perk_Value = '-990099' THEN 'NA' ELSE
					MTRT.TAX_HEADING END, 
							dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_SEPRATED_EMPLOYEE) AS TAX_RATE ,
							RT.[Description] AS RESIDENT_STATUS,    
							CASE WHEN @Total_Perk_Value = '-990099' THEN -990099 ELSE
							dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100), 'TAXAMT')
							END AS TAX_AMOUNT ,   
							
							NULL AS Country, NULL AS [STATE],           
							CASE WHEN @Total_Perk_Value = '-990099' THEN  CASE WHEN(@IsTaxApplicable = '') THEN 'NA' ELSE @IsTaxApplicable END  ELSE
							'Resident Level' END AS BASISOFTAXATION, 
							dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV,   
							dbo.FN_PQ_TAX_ROUNDING((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE ,
							RT.ID, 
							0 AS COUNTRY_ID,
							@MIT_ID,
							@EmployeeID,
							@GRANTOPTION_ID,
							@VESTING_DATE,
							@GRANT_DATE
							,@GRANTLEGSERIAL_NO ,
							TAXCALCULATION_BASEDON ,
							@TEMP_EXERCISEID               
						FROM     
							TAX_RATE_SETTING_CONFIG TR     
							INNER JOIN COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID  
							INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID   
							INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID=TR.Tax_Head_Id  
							INNER JOIN RESIDENTIALTYPE RT ON RT.ID=TR.RESIDENTIAL_ID 
						WHERE           
							TR.MIT_ID = @MIT_ID 
							AND ISNULL(TRM.Employee_ID,'')='' 
							AND ISNULL(TR.RESIDENTIAL_ID,0)=@Resident_ID 
							AND ISNULL(TR.COUNTRY_ID,0)=0             
				 END     
			END    
			ELSE    
			BEGIN    
					-- company level status   
					 Print'S3'
					INSERT INTO #TempTax_Details    
					(    
							TAX_HEADING, 
							TAX_RATE, 
							RESIDENT_STATUS, 
							TAX_AMOUNT, 
							Country, 
							[STATE], 
							BASISOFTAXATION, 
							FMV, 
							TOTAL_PERK_VALUE,    
							COUNTRY_ID, 
							MIT_ID, 
							EmployeeID, 
							GRANTOPTIONID, 
							VESTING_DATE ,
							GRANT_DATE,
							GRANTLEGSERIALNO ,
							TAXCALCULATION_BASEDON ,
							TEMP_EXERCISEID  
					)     
					SELECT
					CASE WHEN @Total_Perk_Value = '-990099' THEN 'NA' ELSE
					MTRT.TAX_HEADING END, 
							dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_SEPRATED_EMPLOYEE) AS TAX_RATE, 
							@ResidentStatus AS RESIDENT_STATUS,    
							CASE WHEN @Total_Perk_Value = '-990099' THEN -990099 ELSE
							dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100), 'TAXAMT')
							END AS TAX_AMOUNT ,    
							'' AS Country, 
							'' AS [STATE], 

							CASE WHEN @Total_Perk_Value = '-990099' THEN  CASE WHEN(@IsTaxApplicable = '') THEN 'NA' ELSE @IsTaxApplicable END  ELSE
							'Company Level' END AS BASISOFTAXATION, 
							dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV, dbo.FN_PQ_TAX_ROUNDING((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,     
							0 AS COUNTRY_ID, 
							@MIT_ID, 
							@EmployeeID, 
							@GRANTOPTION_ID, 
							@VESTING_DATE,
							@GRANT_DATE,
							@GRANTLEGSERIAL_NO ,
							TAXCALCULATION_BASEDON,
							@TEMP_EXERCISEID                
					FROM     
							TAX_RATE_SETTING_CONFIG TR     
							INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID  
							INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID  
							INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id   
					WHERE    
							TR.MIT_ID = @MIT_ID 
							AND ISNULL(TRM.Employee_ID,'')='' 
							AND ISNULL(TR.RESIDENTIAL_ID,0) = 0 
							AND ISNULL(TR.COUNTRY_ID,0)=0              
        
			END    
	   END    
		-- check exception For Tax Rate is Country -- 
	   ELSE IF(@EXCEPT_FOR_TAXRATE='C')    
	   BEGIN    
		/* Tax rate calculation for Country Level*/        
		/*******Print 'Tax rate calculation for Country Level'******/    
		-- Check for employee country    
		-- Get country on event of incidence of perquisite value     
           
			SELECT @EventOfIncidence = CODE_NAME FROM MST_COM_CODE  WHERE MCC_ID = @Event_OF_INCIDENCE
		    
			IF(@EventOfIncidence = 'Grant Date')        
				SET  @INCIDENCEDATE = @GRANT_DATE                     
			ELSE IF(@EventOfIncidence = 'Vesting Date')         
				SET  @INCIDENCEDATE = @VESTING_DATE        
			ELSE IF(@EventOfIncidence = 'Exercise Date')        
				SET  @INCIDENCEDATE = @EXERCISE_DATE    
        
			print @INCIDENCEDATE     
			DELETE FROM #TEMP_TAX_COUNTRY_DAYS    
			IF(UPPER(@COUNTRY_CATEGORY_PROPORT) = 'AC')    
			BEGIN    
					print 'All Country'    
					INSERT INTO #TEMP_TAX_COUNTRY_DAYS 
					(
								INSTRUMENT_ID,
								EMPLOYEE_ID,
								COUNTRY_ID,
								GRANTOPTIONID,
								TOT_DAYS,
								GRANTLEGSERIALNO,
								FROM_DATE,
								TO_DATE,
								TEMP_EXERCISEID,
								STOCK_VALUE)           
					SELECT       
								INSTRUMENT_ID,
								EMPLOYEE_ID,
								COUNTRY_ID,
								GRANTOPTIONID,
								TOT_DAYS,
								GRANTLEGSERIALNO,
								FROM_DATE,
								TO_DATE,
								TEMP_EXERCISEID,
								STOCK_VALUE      
					FROM     
						#TEMP_EMPLOYEE_COUNTRY    
					WHERE      
						INSTRUMENT_ID = @MIT_ID 
						AND EMPLOYEE_ID =@EmployeeID 
						AND GRANTOPTIONID = @GRANTOPTION_ID     
						AND VESTING_DATE =@VESTING_DATE 
						AND GRANTLEGSERIALNO=@GRANTLEGSERIAL_NO     
						AND TEMP_EXERCISEID=@TEMP_EXERCISEID      
			END     
			ELSE    
			BEGIN           
		  
					INSERT INTO #TEMP_TAX_COUNTRY_DAYS
					(
							INSTRUMENT_ID,
							EMPLOYEE_ID,
							COUNTRY_ID,
							GRANTOPTIONID,
							TOT_DAYS,
							GRANTLEGSERIALNO,
							FROM_DATE,
							TO_DATE,
							TEMP_EXERCISEID,
							STOCK_VALUE
					)    
					SELECT  INSTRUMENT_ID,
							EMPLOYEE_ID,
							COUNTRY_ID,
							GRANTOPTIONID,
							TOT_DAYS,
							GRANTLEGSERIALNO,
							FROM_DATE,
							TO_DATE,
							TEMP_EXERCISEID,
							STOCK_VALUE 
					FROM #TEMP_EMPLOYEE_COUNTRY    
					WHERE  INSTRUMENT_ID = @MIT_ID 
					AND EMPLOYEE_ID =@EmployeeID 
					AND GRANTOPTIONID = @GRANTOPTION_ID  
					AND GRANTLEGSERIALNO=@GRANTLEGSERIAL_NO     
					AND  TEMP_EXERCISEID=@TEMP_EXERCISEID    
         
					DELETE FROM #TempMobility_Tracking    
					INSERT INTO #TempMobility_Tracking(ID,Country,FromDate,Todate)    
					EXEC PROC_GET_MOBILITY_DETAILS @EmployeeID, @INCIDENCEDATE,@INCIDENCEDATE     
             
					 IF NOT EXISTS(SELECT *  FROM #TEMP_TAX_COUNTRY_DAYS WHERE COUNTRY_ID >0 AND TEMP_EXERCISEID=@TEMP_EXERCISEID)    
					 BEGIN          
					 IF EXISTS(SELECT * FROM  #TempMobility_Tracking)    
					  BEGIN    
						   UPDATE  #TEMP_TAX_COUNTRY_DAYS    
						   SET COUNTRY_ID=TMT.ID    
						   FROM #TempMobility_Tracking TMT    
						   WHERE TEMP_EXERCISEID=@TEMP_EXERCISEID    
					  END    
         
					 END         
         
                 
			END    
			-- Loop for multiple Countries    
			SET @IS_COMPANY_LEVEL=0    
            
			SELECT @MINVALUE=MIN(ID),@MaxValue=MAX(ID)From #TEMP_TAX_COUNTRY_DAYS    
			WHILE(@MINVALUE<=@MAXVALUE)    
			BEGIN          
                     
				SELECT @Country_ID=COUNTRY_ID,@GRANTLEGSERIAL_NO  = GRANTLEGSERIALNO,@FROM_DATE_TAX=FROM_DATE,@TO_DATE_TAX = TO_DATE  FROM #TEMP_TAX_COUNTRY_DAYS    
				WHERE ID=@MINVALUE    
				IF(@Country_ID >0)    
				BEGIN    
					IF(UPPER(@COUNTRY_CATEGORY_PROPORT) = 'AC')    
					BEGIN    
						/* Block For AC */    
						IF EXISTS(
									Select TR.TRSC_ID 
									FROM TAX_RATE_SETTING_CONFIG TR  
									INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID AND ISNULL(TRM.Employee_ID,'')='' 
									WHERE COUNTRY_ID=@Country_ID AND MIT_ID=@MIT_ID
								)    
						BEGIN     
						Print ' tax found For Country'        
						/* For AC Type County wise data*/    
							IF(ISNULL(LEN(@DateOfTermination),0)<=0)   
							BEGIN   
								INSERT INTO #TempTax_Details
								(
										TAX_HEADING,
										TAX_RATE,
										RESIDENT_STATUS,
										TAX_AMOUNT,
										Country,
										[STATE],
										BASISOFTAXATION,
										FMV,
										TOTAL_PERK_VALUE,
										COUNTRY_ID, 
										MIT_ID ,
										EmployeeID ,
										GRANTOPTIONID,
										VESTING_DATE,
										GRANT_DATE ,
										GRANTLEGSERIALNO,
										FROM_DATE,
										TO_DATE,
										TEMP_EXERCISEID,
										TAXCALCULATION_BASEDON
								)    
								SELECT CASE WHEN @Total_Perk_Value = '-990099' THEN 'NA' ELSE
					MTRT.TAX_HEADING END, 
										dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_LIVE_EMPLOYEE) AS TAX_RATE, 
										'' AS RESIDENT_STATUS, 
									CASE WHEN @Total_Perk_Value = '-990099' THEN 0 ELSE
							dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_LIVE_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN TAXD.TOT_DAYS ELSE TAXD.STOCK_VALUE END ))/100), 'TAXAMT')
							END AS TAX_AMOUNT ,  
										
										
										
										CM.CountryName AS Country, 
										NULL AS [STATE],
										
							CASE WHEN @Total_Perk_Value = '-990099' THEN  CASE WHEN(@IsTaxApplicable = '') THEN 'NA' ELSE @IsTaxApplicable END  ELSE
							'Country Level' END AS BASISOFTAXATION,    
										dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV, 
										((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN TAXD.TOT_DAYS ELSE TAXD.STOCK_VALUE END )) AS TOTAL_PERK_VALUE
										,CM.ID,
										@MIT_ID,
										@EmployeeID,
										@GRANTOPTION_ID,
										@VESTING_DATE,
										@GRANT_DATE,    
										TAXD.GRANTLEGSERIALNO,
										TAXD.FROM_DATE,
										TAXD.TO_DATE,
										TAXD.TEMP_EXERCISEID,
										TAXCALCULATION_BASEDON    
               
								FROM    TAX_RATE_SETTING_CONFIG TR     
								INNER JOIN  COMPANY_INSTRUMENT_MAPPING CIM ON TR.MIT_ID=CIM.MIT_ID     
								INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID=TR.Tax_Head_Id    
								INNER JOIN  COUNTRYMASTER CM ON CM.ID=TR.COUNTRY_ID    
								INNER JOIN #TEMP_TAX_COUNTRY_DAYS AS TAXD ON CM.ID=TAXD.COUNTRY_ID  AND CM.ID =@Country_ID AND TAXD.ID=@MINVALUE    
								INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID    
								--INNER JOIN EmployeeMaster EM  ON EM.EmployeeID= TRM.EMPLOYEE_ID                                
								WHERE  TR.MIT_ID = @MIT_ID 
								AND ISNULL(TRM.Employee_ID,'')='' 
								AND CM.ID=@Country_ID  
								AND ISNULL(TR.RESIDENTIAL_ID,0)=0           
							END             
							ELSE    
							BEGIN   
							-- For seprated  
							INSERT INTO #TempTax_Details
							(
									TAX_HEADING,
									TAX_RATE,
									RESIDENT_STATUS,
									TAX_AMOUNT,
									Country,
									[STATE],
									BASISOFTAXATION,
									FMV,
									TOTAL_PERK_VALUE,
									COUNTRY_ID, 
									MIT_ID ,
									EmployeeID ,
									GRANTOPTIONID,
									VESTING_DATE ,
									GRANT_DATE,
									GRANTLEGSERIALNO,
									FROM_DATE,
									TO_DATE,
									TEMP_EXERCISEID,
									TAXCALCULATION_BASEDON
							)    
							SELECT  CASE WHEN @Total_Perk_Value = '-990099' THEN 'NA' ELSE
					MTRT.TAX_HEADING END, 
									dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_SEPRATED_EMPLOYEE) AS TAX_RATE ,
									'' AS RESIDENT_STATUS,    
											  			
										CASE WHEN @Total_Perk_Value = '-990099' THEN 0 ELSE
							dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN TAXD.TOT_DAYS ELSE TAXD.STOCK_VALUE END ))/100), 'TAXAMT')
							END AS TAX_AMOUNT ,  
										
									
									
									CM.CountryName AS Country, 
									NULL AS [STATE],
									CASE WHEN @Total_Perk_Value = '-990099' THEN  CASE WHEN(@IsTaxApplicable = '') THEN 'NA' ELSE @IsTaxApplicable END  ELSE
							'Country Level' END AS BASISOFTAXATION, 
									
									dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV,   
									((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN TAXD.TOT_DAYS ELSE TAXD.STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
									CM.ID,
									@MIT_ID,
									@EmployeeID,
									@GRANTOPTION_ID,
									@VESTING_DATE,
									@GRANT_DATE    
									,TAXD.GRANTLEGSERIALNO,
									TAXD.FROM_DATE,
									TAXD.TO_DATE,
									TAXD.TEMP_EXERCISEID ,
									TAXCALCULATION_BASEDON   
                
							FROM    TAX_RATE_SETTING_CONFIG TR     
							INNER JOIN  COMPANY_INSTRUMENT_MAPPING CIM ON TR.MIT_ID=CIM.MIT_ID     
							INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID=TR.Tax_Head_Id    
							INNER JOIN  COUNTRYMASTER CM ON CM.ID=TR.COUNTRY_ID    
							INNER JOIN #TEMP_TAX_COUNTRY_DAYS AS TAXD ON CM.ID=TAXD.COUNTRY_ID  AND CM.ID =@Country_ID AND TAXD.ID=@MINVALUE    
							INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID   
							WHERE      TR.MIT_ID= @MIT_ID 
										AND ISNULL(TRM.Employee_ID,'')='' 
										AND CM.ID=@Country_ID  
										AND ISNULL(TR.RESIDENTIAL_ID,0)=0
							END    
    
						END         
						ELSE    
						BEGIN       
							/* Tax Not found for @Country_ID select company level */           
							IF(@IS_COMPANY_LEVEL=0)    
							BEGIN 
							IF EXISTS(SELECT * FROM  #TEMP_TAX_COUNTRY_DAYS)          
							BEGIN    
								SELECT @Total_Perk_Value = SUM(TOT_DAYS) 
								FROM #TEMP_TAX_COUNTRY_DAYS 
								WHERE COUNTRY_ID = @Country_ID AND GRANTLEGSERIALNO = @GRANTLEGSERIAL_NO           
								AND TEMP_EXERCISEID= @TEMP_EXERCISEID 
								AND INSTRUMENT_ID = @MIT_ID 
								AND EMPLOYEE_ID =@EmployeeID 
								AND GRANTOPTIONID = @GRANTOPTION_ID            
							END  
		             
							IF(ISNULL(LEN(@DateOfTermination),0)<=0)    
							BEGIN   
							print 'ss1'
								INSERT INTO #TempTax_Details
								(
										TAX_HEADING,
										TAX_RATE,
										RESIDENT_STATUS,
										TAX_AMOUNT,
										Country,
										[STATE],
										BASISOFTAXATION,
										FMV,
										TOTAL_PERK_VALUE,
										COUNTRY_ID ,
										MIT_ID ,
										EmployeeID ,
										GRANTOPTIONID,
										VESTING_DATE,
										GRANT_DATE,
										GRANTLEGSERIALNO,
										FROM_DATE,
										TO_DATE,
										TEMP_EXERCISEID,
										TAXCALCULATION_BASEDON
										
								)    
								SELECT  CASE WHEN @Total_Perk_Value = '-990099' THEN 'NA' ELSE
					MTRT.TAX_HEADING END,
										dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_LIVE_EMPLOYEE) AS TAX_RATE, 
										'' AS RESIDENT_STATUS,    
									    
									CASE WHEN @Total_Perk_Value = '-990099' THEN 0 ELSE
							dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_LIVE_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100), 'TAXAMT')
							END AS TAX_AMOUNT ,  
									
									@Country_ID AS Country, 
									'' AS [STATE],
									CASE WHEN @Total_Perk_Value = '-990099' THEN  CASE WHEN(@IsTaxApplicable = '') THEN 'NA' ELSE @IsTaxApplicable END  ELSE
							'Company Level' END AS BASISOFTAXATION,    
									dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV, 
									((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
									0 ,
									@MIT_ID,
									@EmployeeID,
									@GRANTOPTION_ID,
									@VESTING_DATE,
									@GRANT_DATE,
									@GRANTLEGSERIAL_NO,
									NULL,
									NULL ,
									@TEMP_EXERCISEID ,
									TAXCALCULATION_BASEDON   
                
								FROM        TAX_RATE_SETTING_CONFIG TR     
								INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID    
								INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID 
								INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id 
								--INNER JOIN  RESIDENTIALTYPE RT ON RT.ID=TR.RESIDENTIAL_ID                 
								WHERE       TR.MIT_ID = @MIT_ID 
										AND ISNULL(TRM.Employee_ID,'')=''  
										AND ISNULL(TR.RESIDENTIAL_ID,0) =0 
										AND ISNULL(TR.COUNTRY_ID,0)=0      
            
							END             
							ELSE    
							BEGIN    
							 Print'S5'
								INSERT INTO #TempTax_Details
								(
										TAX_HEADING,
										TAX_RATE,
										RESIDENT_STATUS,
										TAX_AMOUNT,
										Country,
										[STATE],
										BASISOFTAXATION,
										FMV,
										TOTAL_PERK_VALUE,
										COUNTRY_ID, 
										MIT_ID ,
										EmployeeID ,
										GRANTOPTIONID,
										VESTING_DATE,
										GRANT_DATE,
										GRANTLEGSERIALNO,
										FROM_DATE,
										TO_DATE,
										TEMP_EXERCISEID,
										TAXCALCULATION_BASEDON
								)    
								SELECT  CASE WHEN @Total_Perk_Value = '-990099' THEN 'NA' ELSE
				                     	MTRT.TAX_HEADING END, 
										dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_SEPRATED_EMPLOYEE) AS TAX_RATE ,
										'' AS RESIDENT_STATUS,    
											CASE WHEN @Total_Perk_Value = '-990099' THEN 0 ELSE
						                 	dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100), 'TAXAMT')
							             END AS TAX_AMOUNT ,    
										@Country_ID AS Country, 
										'' AS [STATE], 
										CASE WHEN @Total_Perk_Value = '-990099' THEN  CASE WHEN(@IsTaxApplicable = '') THEN 'NA' ELSE @IsTaxApplicable END  ELSE
							             'Company Level' END AS BASISOFTAXATION, 
										dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV, 
										((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
										0 ,
										@MIT_ID,
										@EmployeeID,
										@GRANTOPTION_ID,
										@VESTING_DATE,
										@GRANT_DATE,
										@GRANTLEGSERIAL_NO,
										NULL,
										NULL,
										@TEMP_EXERCISEID ,
										TAXCALCULATION_BASEDON    
                 
								FROM    TAX_RATE_SETTING_CONFIG TR     
									INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID    
									INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID 
									INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id     
									--INNER JOIN  RESIDENTIALTYPE RT ON RT.ID=TR.RESIDENTIAL_ID    
								WHERE TR.MIT_ID = @MIT_ID 
								AND ISNULL(TRM.Employee_ID,'')=''  
								AND ISNULL(TR.RESIDENTIAL_ID,0) =0 
								AND ISNULL(TR.COUNTRY_ID,0)=0      
							END     
							SET @IS_COMPANY_LEVEL = 1    
						END    
    
					END 
              
					END     
					ELSE    
					BEGIN    
					/* Date Of incidence*/    
					Print 'Date Of incidence __1'    
    print 'see'
					IF EXISTS
							(
								SELECT TR.TRSC_ID 
								FROM TAX_RATE_SETTING_CONFIG TR INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID  
								WHERE COUNTRY_ID=@Country_ID AND MIT_ID=@MIT_ID AND ISNULL(TRM.Employee_ID,'')=''
							)    
					--(SELECT TRSC_ID FROM TAX_RATE_SETTING_CONFIG WHERE COUNTRY_ID=@Country_ID AND MIT_ID=@MIT_ID)    
					BEGIN    
					/* Date of incidence Country wise*/     
					/* Tax Not found for @Country_ID select company level on date of incidence */        
						IF(ISNULL(LEN(@DateOfTermination),0)<=0)   
						BEGIN             
							print 'Seprated employee in Date of incidence '    
							INSERT INTO #TempTax_Details
							(
									TAX_HEADING,
									TAX_RATE,
									RESIDENT_STATUS,
									TAX_AMOUNT,
									Country,
									[STATE],
									BASISOFTAXATION,
									FMV,
									TOTAL_PERK_VALUE,
									COUNTRY_ID, 
									MIT_ID ,
									EmployeeID ,
									GRANTOPTIONID,
									VESTING_DATE,
									GRANT_DATE ,
									GRANTLEGSERIALNO,
									FROM_DATE,
									TO_DATE,
									TEMP_EXERCISEID,
									TAXCALCULATION_BASEDON
							)    
							SELECT  CASE WHEN @Total_Perk_Value = '-990099' THEN 'NA' ELSE
							  MTRT.TAX_HEADING END, 
									dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_LIVE_EMPLOYEE) AS TAX_RATE, 
									'' AS RESIDENT_STATUS,    
									--dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_LIVE_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100),'TAXAMT')AS TAX_AMOUNT,    
									CASE WHEN @Total_Perk_Value = '-990099' THEN 0 ELSE
							dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_LIVE_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100), 'TAXAMT')
							END AS TAX_AMOUNT  ,
										
									CM.CountryName AS Country, 
									NULL AS [STATE],
									CASE WHEN @Total_Perk_Value = '-990099' THEN  CASE WHEN(@IsTaxApplicable = '') THEN 'NA' ELSE @IsTaxApplicable END  ELSE
							       'Country Level' END AS BASISOFTAXATION,    
									dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV, ((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
									CM.ID as 'COUNTRY_ID'    
									,@MIT_ID,
									@EmployeeID,
									@GRANTOPTION_ID,
									@VESTING_DATE ,
									@GRANT_DATE,
									@GRANTLEGSERIAL_NO,
									@FROM_DATE_TAX,
									@TO_DATE_TAX,
									@TEMP_EXERCISEID ,
									TAXCALCULATION_BASEDON   
    
							FROM        TAX_RATE_SETTING_CONFIG TR     
							INNER JOIN  COMPANY_INSTRUMENT_MAPPING CIM ON TR.MIT_ID=CIM.MIT_ID     
							INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID=TR.Tax_Head_Id    
							INNER JOIN  COUNTRYMASTER CM ON CM.ID=TR.COUNTRY_ID    
							INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID  
							--INNER JOIN EmployeeMaster EM  ON EM.EmployeeID= TRM.EMPLOYEE_ID                  
							WHERE  TR.MIT_ID = @MIT_ID 
							AND ISNULL(TRM.Employee_ID,'')='' 
							AND CM.ID=@Country_ID  
							AND ISNULL(TR.RESIDENTIAL_ID,0)=0           
    
						END             
						ELSE    
						BEGIN     
							print 'Active employee in Date of incidence '    
							INSERT INTO #TempTax_Details
							(
									TAX_HEADING,
									TAX_RATE,
									RESIDENT_STATUS,
									TAX_AMOUNT,
									Country,
									[STATE],
									BASISOFTAXATION,
									FMV,
									TOTAL_PERK_VALUE,
									COUNTRY_ID, 
									MIT_ID ,
									EmployeeID ,
									GRANTOPTIONID,
									VESTING_DATE,
									GRANT_DATE ,
									GRANTLEGSERIALNO,
									FROM_DATE,
									TO_DATE,
									TEMP_EXERCISEID,
									TAXCALCULATION_BASEDON
							)    
							SELECT  CASE WHEN @Total_Perk_Value = '-990099' THEN 'NA' ELSE
					MTRT.TAX_HEADING END, 
									dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_SEPRATED_EMPLOYEE) AS TAX_RATE ,
									'' AS RESIDENT_STATUS,    
									--dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100),'TAXAMT')AS TAX_AMOUNT,
									CASE WHEN @Total_Perk_Value = '-990099' THEN 0 ELSE
							dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100), 'TAXAMT')
							END AS TAX_AMOUNT ,
									CM.CountryName AS Country, 
									NULL AS [STATE],--EM.TAX_IDENTIFIER_STATE AS [STATE],            
									CASE WHEN @Total_Perk_Value = '-990099' THEN  CASE WHEN(@IsTaxApplicable = '') THEN 'NA' ELSE @IsTaxApplicable END  ELSE
							       'Country Level' END AS BASISOFTAXATION,
									dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV,     
									((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
									CM.ID as COUNTRY_ID    
									,@MIT_ID,
									@EmployeeID,
									@GRANTOPTION_ID,
									@VESTING_DATE ,
									@GRANT_DATE,
									@GRANTLEGSERIAL_NO,
									@FROM_DATE_TAX,
									@TO_DATE_TAX,
									@TEMP_EXERCISEID,
									TAXCALCULATION_BASEDON    
    
							FROM    TAX_RATE_SETTING_CONFIG TR     
							INNER JOIN  COMPANY_INSTRUMENT_MAPPING CIM ON TR.MIT_ID=CIM.MIT_ID     
							INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID=TR.Tax_Head_Id    
							INNER JOIN  COUNTRYMASTER CM ON CM.ID=TR.COUNTRY_ID    
							INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID  
							WHERE  TR.MIT_ID = @MIT_ID 
									AND ISNULL(TRM.Employee_ID,'')='' 
									AND CM.ID=@Country_ID  
									AND ISNULL(TR.RESIDENTIAL_ID,0)=0
						END         
          
						END    
					ELSE    
					BEGIN    
					/* Date of incidence company Level if*/    
					print @IS_COMPANY_LEVEL
					print @DateOfTermination
						IF(@IS_COMPANY_LEVEL=0)    
						BEGIN          
							IF(ISNULL(LEN(@DateOfTermination),0)<=0)    
							BEGIN   
							 Print'S6'
								INSERT INTO #TempTax_Details
								(
										TAX_HEADING,
										TAX_RATE,
										RESIDENT_STATUS,
										TAX_AMOUNT,
										Country,
										[STATE],
										BASISOFTAXATION,
										FMV,
										TOTAL_PERK_VALUE,
										COUNTRY_ID,
										MIT_ID ,
										EmployeeID ,
										GRANTOPTIONID,
										VESTING_DATE,
										GRANT_DATE ,
										GRANTLEGSERIALNO,
										FROM_DATE,
										TO_DATE,
										TEMP_EXERCISEID,
										TAXCALCULATION_BASEDON
								)    
								SELECT CASE WHEN @Total_Perk_Value = '-990099' THEN 'NA' ELSE
					MTRT.TAX_HEADING END, 
										dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_LIVE_EMPLOYEE) AS TAX_RATE, 
										'' AS RESIDENT_STATUS,    
										CASE WHEN @Total_Perk_Value = '-990099' THEN 0 ELSE
							dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_LIVE_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100), 'TAXAMT')
							END AS TAX_AMOUNT   , 
										'' AS Country, 
										'' AS [STATE],
											CASE WHEN @Total_Perk_Value = '-990099' THEN  CASE WHEN(@IsTaxApplicable = '') THEN 'NA' ELSE @IsTaxApplicable END  ELSE
							'Company Level' END AS BASISOFTAXATION,    
										dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV, ((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
										0,    
										@MIT_ID,
										@EmployeeID,
										@GRANTOPTION_ID,
										@VESTING_DATE ,
										@GRANT_DATE,
										@GRANTLEGSERIAL_NO,
										NULL,
										NULL,
										@TEMP_EXERCISEID,
										TAXCALCULATION_BASEDON     
								FROM   TAX_RATE_SETTING_CONFIG TR     
								INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID    
								INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID 
								INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id   
								WHERE       TR.MIT_ID = @MIT_ID 
											AND ISNULL(TRM.Employee_ID,'') = ''  
											AND ISNULL(TR.RESIDENTIAL_ID,0) =0 
											AND ISNULL(TR.COUNTRY_ID,0)=0      
                
							END             
							ELSE    
							BEGIN  
							print 'ss2'
								INSERT INTO #TempTax_Details
								(
										TAX_HEADING,
										TAX_RATE,
										RESIDENT_STATUS,
										TAX_AMOUNT,
										Country,
										[STATE],
										BASISOFTAXATION,
										FMV,
										TOTAL_PERK_VALUE,
										COUNTRY_ID,
										MIT_ID ,
										EmployeeID ,
										GRANTOPTIONID,
										VESTING_DATE,
										GRANT_DATE ,
										GRANTLEGSERIALNO,
										FROM_DATE,
										TO_DATE,
										TEMP_EXERCISEID,
										TAXCALCULATION_BASEDON
								)    
								SELECT 		CASE WHEN @Total_Perk_Value = '-990099' THEN 'NA' ELSE
					MTRT.TAX_HEADING END, 
										dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_SEPRATED_EMPLOYEE) AS TAX_RATE ,
										'' AS RESIDENT_STATUS,    
										CASE WHEN @Total_Perk_Value = '-990099' THEN 0 ELSE
							dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100), 'TAXAMT')
							END AS TAX_AMOUNT ,    
										'' AS Country, 
										'' AS [STATE], 
											CASE WHEN @Total_Perk_Value = '-990099' THEN  CASE WHEN(@IsTaxApplicable = '') THEN 'NA' ELSE @IsTaxApplicable END  ELSE
							'Company Level' END AS BASISOFTAXATION, 
										dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV, 
										((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
										0,    
										@MIT_ID,
										@EmployeeID,
										@GRANTOPTION_ID,
										@VESTING_DATE ,
										@GRANT_DATE,
										@GRANTLEGSERIAL_NO,
										NULL,
										NULL,
										@TEMP_EXERCISEID,
										TAXCALCULATION_BASEDON     
								FROM    TAX_RATE_SETTING_CONFIG TR     
								INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID  
								INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID   
								INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id    
								WHERE       TR.MIT_ID= @MIT_ID 
											AND ISNULL(TRM.Employee_ID,'') = '' 
											AND ISNULL(TR.RESIDENTIAL_ID,0) =0 
											AND ISNULL(TR.COUNTRY_ID,0)=0              
							END    
							SET @IS_COMPANY_LEVEL=1              
						END     
       
						END    
         
					END       
    
    
				END --End Country ID >0    
				ELSE    
				BEGIN    
				/* Company Level  */    
				/* Mobility not done*/      
					IF(ISNULL(LEN(@DateOfTermination),0)<=0)    
					BEGIN 
					 Print'S7'
						INSERT INTO #TempTax_Details
						(
								TAX_HEADING,
								TAX_RATE,
								RESIDENT_STATUS,
								TAX_AMOUNT,
								Country,
								[STATE],
								BASISOFTAXATION,
								FMV,
								TOTAL_PERK_VALUE,
								COUNTRY_ID, 
								MIT_ID ,
								EmployeeID ,
								GRANTOPTIONID,
								VESTING_DATE,
								GRANT_DATE,
								GRANTLEGSERIALNO,
								FROM_DATE,
								TO_DATE,
								TEMP_EXERCISEID,
								TAXCALCULATION_BASEDON
						)    
						SELECT CASE WHEN @Total_Perk_Value = '-990099' THEN 'NA' ELSE
					MTRT.TAX_HEADING END, 
								dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_LIVE_EMPLOYEE) AS TAX_RATE, 
								'' AS RESIDENT_STATUS,    
								CASE WHEN @Total_Perk_Value = '-990099' THEN 0 ELSE
							dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_LIVE_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100), 'TAXAMT')
							END AS TAX_AMOUNT ,  
								'' AS COUNTRY, 
								NULL AS [STATE],
								CASE WHEN @Total_Perk_Value = '-990099' THEN  CASE WHEN(@IsTaxApplicable = '') THEN 'NA' ELSE @IsTaxApplicable END  ELSE
							'Company Level' END AS BASISOFTAXATION, 
								dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV,     
								dbo.FN_PQ_TAX_ROUNDING((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
								0 AS COUNTRY_ID    
								,@MIT_ID,
								@EmployeeID,
								@GRANTOPTION_ID,
								@VESTING_DATE,
								@GRANT_DATE, 
								@GRANTLEGSERIAL_NO,
								NULL,
								NULL,
								@TEMP_EXERCISEID,
								TAXCALCULATION_BASEDON     
                     
						FROM    TAX_RATE_SETTING_CONFIG TR     
						INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID 
						INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID      
						INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id               
						WHERE       TR.MIT_ID= @MIT_ID 
									AND ISNULL(TRM.Employee_ID,'') = '' 
									AND ISNULL(TR.RESIDENTIAL_ID,0) = 0 
									AND ISNULL(TR.COUNTRY_ID,0)=0    
					END    
               
					ELSE    
					BEGIN    
             Print'S7'
						INSERT INTO #TempTax_Details
						(
								TAX_HEADING,
								TAX_RATE,
								RESIDENT_STATUS,
								TAX_AMOUNT,
								Country,
								[STATE],
								BASISOFTAXATION,
								FMV,
								TOTAL_PERK_VALUE,
								COUNTRY_ID, 
								MIT_ID ,
								EmployeeID ,
								GRANTOPTIONID,
								VESTING_DATE,
								GRANT_DATE, 
								GRANTLEGSERIALNO,
								FROM_DATE,
								TO_DATE,
								TEMP_EXERCISEID,
								TAXCALCULATION_BASEDON
						)    
						SELECT  CASE WHEN @Total_Perk_Value = '-990099' THEN 'NA' ELSE
					MTRT.TAX_HEADING END,
								dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_SEPRATED_EMPLOYEE) AS TAX_RATE, 
								'' AS RESIDENT_STATUS,    
								--dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100),'TAXAMT')AS TAX_AMOUNT,    


								CASE WHEN @Total_Perk_Value = '-990099' THEN 0 ELSE
							dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100), 'TAXAMT')
							END AS TAX_AMOUNT ,  
								'' AS COUNTRY, 
								'' AS [STATE],
								CASE WHEN @Total_Perk_Value = '-990099' THEN  CASE WHEN(@IsTaxApplicable = '') THEN 'NA' ELSE @IsTaxApplicable END  ELSE
							'Company Level' END AS BASISOFTAXATION, 
								dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV,     
								((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
								0 AS COUNTRY_ID    
								,@MIT_ID,
								@EmployeeID,
								@GRANTOPTION_ID,
								@VESTING_DATE,
								@GRANT_DATE, 
								@GRANTLEGSERIAL_NO,
								NULL,
								NULL,
								@TEMP_EXERCISEID,
								TAXCALCULATION_BASEDON     
                           
						FROM    TAX_RATE_SETTING_CONFIG TR     
						INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID
						INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID        
						INNER JOIN  MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id            
						WHERE  TR.MIT_ID= @MIT_ID 
								AND ISNULL(TRM.Employee_ID,'') = '' 
								AND ISNULL(TR.RESIDENTIAL_ID,0) = 0 
								AND ISNULL(TR.COUNTRY_ID,0)=0    
					END    
        
				END    
						SET @MINVALUE=@MINVALUE+1      
				END    
			-- End Loof for multiple countries    
               
	   END -- End /* Tax rate calculation for Country Level*/      
		-- check exception For Tax Rate is Employee --
	   ELSE IF(@EXCEPT_FOR_TAXRATE='E') 
	   BEGIN
		-- check exception For Tax Rate Employee is Resident --
			IF(@EXCEPT_FOR_TAXRATE_EMPLOYEE='R')    
			BEGIN    
           
				IF EXISTS    
				(    
					SELECT     
					TR.TRSC_ID     
					FROM    
					TAX_RATE_SETTING_CONFIG TR     
					INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id    
					INNER JOIN COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID = CM.MIT_ID     
					INNER JOIN RESIDENTIALTYPE RT ON RT.ID = TR.RESIDENTIAL_ID AND RT.ResidentialStatus = @ResidentStatus CROSS JOIN EMPLOYEEMASTER EM     
					WHERE    
					TR.MIT_ID = @MIT_ID 
					AND EM.EmployeeID = @EmployeeID 
					AND TR.IS_TAXRATEAPPLICABLE = 1  
					AND TAX_RATE_STATUS_DETAILS = 1     
				)    
				BEGIN    
				IF(ISNULL(LEN(@DateOfTermination),0)<=0)    
				BEGIN    
					INSERT INTO #TempTax_Details    
					(    
							TAX_HEADING, 
							TAX_RATE, 
							RESIDENT_STATUS, 
							TAX_AMOUNT, 
							Country, 
							[STATE], 
							BASISOFTAXATION, 
							FMV, 
							TOTAL_PERK_VALUE,     
							COUNTRY_ID, 
							MIT_ID, 
							EmployeeID, 
							GRANTOPTIONID, 
							VESTING_DATE,
							GRANT_DATE,
							GRANTLEGSERIALNO,
							TAXCALCULATION_BASEDON ,
							TEMP_EXERCISEID   
					)    
					SELECT    
							CASE WHEN @Total_Perk_Value = '-990099' THEN 'NA' ELSE
					         MTRT.TAX_HEADING END,
							dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_LIVE_EMPLOYEE) AS TAX_RATE, 
							RT.[Description] AS RESIDENT_STATUS,    
							  
							CASE WHEN @Total_Perk_Value = '-990099' THEN -990099 ELSE
							dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_LIVE_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100), 'TAXAMT')
							END AS TAX_AMOUNT , 
							@Country_Name AS Country, NULL AS [STATE],
							CASE WHEN @Total_Perk_Value = '-990099' THEN  CASE WHEN(@IsTaxApplicable = '') THEN 'NA' ELSE @IsTaxApplicable END  ELSE
							'Employee Resident' END AS BASISOFTAXATION, 
							   
							dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV, 
							((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE, 
							0 AS COUNTRY_ID, 
							@MIT_ID, 
							@EmployeeID,     
							@GRANTOPTION_ID,
							@VESTING_DATE,
							@GRANT_DATE,
							@GRANTLEGSERIAL_NO,
							TAXCALCULATION_BASEDON,
							@TEMP_EXERCISEID     
					FROM    
					TAX_RATE_SETTING_CONFIG TR     
					INNER JOIN COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID = CM.MIT_ID   
					INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID   
					INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID=TR.Tax_Head_Id 
					INNER JOIN RESIDENTIALTYPE RT ON RT.ID=TR.RESIDENTIAL_ID                 
					WHERE    
					TR.MIT_ID = @MIT_ID 
			END             
			ELSE    
			BEGIN     
				INSERT INTO #TempTax_Details    
				(    
						TAX_HEADING, 
						TAX_RATE, 
						RESIDENT_STATUS, 
						TAX_AMOUNT, 
						Country, 
						[STATE], 
						BASISOFTAXATION, 
						FMV, 
						TOTAL_PERK_VALUE, 
						COUNTRY_ID,    
						MIT_ID, 
						EmployeeID, 
						GRANTOPTIONID, 
						VESTING_DATE,
						GRANT_DATE,
						GRANTLEGSERIALNO,
						TAXCALCULATION_BASEDON,
						TEMP_EXERCISEID    
				)     
				SELECT    
						CASE WHEN @Total_Perk_Value = '-990099' THEN 'NA' ELSE
					MTRT.TAX_HEADING END, 
						dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_SEPRATED_EMPLOYEE) AS TAX_RATE ,
						RT.[Description] AS RESIDENT_STATUS,    
						  
						CASE WHEN @Total_Perk_Value = '-990099' THEN -990099 ELSE
							dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100), 'TAXAMT')
							END AS TAX_AMOUNT , 
						@Country_Name AS Country, 
						NULL AS [STATE],           
						CASE WHEN @Total_Perk_Value = '-990099' THEN  CASE WHEN(@IsTaxApplicable = '') THEN 'NA' ELSE @IsTaxApplicable END  ELSE
							'Employee Resident' END AS BASISOFTAXATION,
					
						dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV,     
						((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE ,
						0 AS COUNTRY_ID,
						@MIT_ID,
						@EmployeeID,
						@GRANTOPTION_ID,
						@VESTING_DATE,
						@GRANT_DATE,
						@GRANTLEGSERIAL_NO,
						TAXCALCULATION_BASEDON,
						@TEMP_EXERCISEID                
				FROM     
				TAX_RATE_SETTING_CONFIG TR     
				INNER JOIN COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID 
				INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID   
				INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID=TR.Tax_Head_Id   
				INNER JOIN RESIDENTIALTYPE RT ON RT.ID=TR.RESIDENTIAL_ID   
				WHERE           
				TR.MIT_ID = @MIT_ID 
			END     
			END    
			ELSE    
			BEGIN    
				-- company level status    
				INSERT INTO #TempTax_Details    
				(    
						TAX_HEADING, 
						TAX_RATE, 
						RESIDENT_STATUS, 
						TAX_AMOUNT,
						Country, 
						[STATE], 
						BASISOFTAXATION, 
						FMV, 
						TOTAL_PERK_VALUE, 
						RESIDENT_ID,   
						COUNTRY_ID, 
						MIT_ID, 
						EmployeeID, 
						GRANTOPTIONID, 
						VESTING_DATE ,
						GRANT_DATE,
						GRANTLEGSERIALNO ,
						TAXCALCULATION_BASEDON,
						TEMP_EXERCISEID   
				)     
				SELECT    
						CASE WHEN @Total_Perk_Value = '-990099' THEN 'NA' ELSE
					MTRT.TAX_HEADING END,
						dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_SEPRATED_EMPLOYEE) AS TAX_RATE, 
						@ResidentStatus AS RESIDENT_STATUS,    
						--dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100), 'TAXAMT')AS TAX_AMOUNT,    
							CASE WHEN @Total_Perk_Value = '-990099' THEN -990099 ELSE
							dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100), 'TAXAMT')
							END AS TAX_AMOUNT , 
						
						'' AS Country, 
						'' AS [STATE], 
						CASE WHEN @Total_Perk_Value = '-990099' THEN  CASE WHEN(@IsTaxApplicable = '') THEN 'NA' ELSE @IsTaxApplicable END  ELSE
							'Company Level' END AS BASISOFTAXATION,  
						dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV, 
						((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE, 
						@Resident_ID AS Resident_ID ,    
						0 AS COUNTRY_ID, 
						@MIT_ID, 
						@EmployeeID, 
						@GRANTOPTION_ID, 
						@VESTING_DATE,
						@GRANT_DATE,
						@GRANTLEGSERIAL_NO ,
						TAXCALCULATION_BASEDON,
						@TEMP_EXERCISEID                
				FROM     
				TAX_RATE_SETTING_CONFIG TR     
				INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID 
				INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID      
				INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id 
				WHERE    
				TR.MIT_ID = @MIT_ID
				AND ISNULL(TR.RESIDENTIAL_ID,0) = 0 
				AND ISNULL(TR.COUNTRY_ID,0)=0              
        
			END  
			END  
			-- check exception For Tax Rate Employee is Country --   
			ELSE IF(@EXCEPT_FOR_TAXRATE_EMPLOYEE='C')    
			BEGIN    
  
				SELECT @EventOfIncidence = CODE_NAME FROM MST_COM_CODE  WHERE MCC_ID = @Event_OF_INCIDENCE    
        
				IF(@EventOfIncidence = 'Grant Date')        
					SET  @INCIDENCEDATE = @GRANT_DATE                     
				ELSE IF(@EventOfIncidence = 'Vesting Date')         
					SET  @INCIDENCEDATE = @VESTING_DATE        
				ELSE IF(@EventOfIncidence = 'Exercise Date')        
					SET  @INCIDENCEDATE = @EXERCISE_DATE    
        
				print @INCIDENCEDATE     
				DELETE FROM #TEMP_TAX_COUNTRY_DAYS 
				   
				IF(UPPER(@COUNTRY_CATEGORY_PROPORT) = 'AC')    
				BEGIN    
					print 'All Country'    
          
					INSERT INTO #TEMP_TAX_COUNTRY_DAYS    
					(
							INSTRUMENT_ID,
							EMPLOYEE_ID,
							COUNTRY_ID,
							GRANTOPTIONID,
							TOT_DAYS,
							GRANTLEGSERIALNO,
							FROM_DATE,
							TO_DATE,
							TEMP_EXERCISEID,
							STOCK_VALUE
					)           
					SELECT       
							INSTRUMENT_ID,
							EMPLOYEE_ID,
							COUNTRY_ID,
							GRANTOPTIONID,
							TOT_DAYS,
							GRANTLEGSERIALNO,
							FROM_DATE,
							TO_DATE,
							TEMP_EXERCISEID,
							STOCK_VALUE      
					FROM     
							#TEMP_EMPLOYEE_COUNTRY    
					WHERE   INSTRUMENT_ID = @MIT_ID 
							AND EMPLOYEE_ID =@EmployeeID 
							AND GRANTOPTIONID = @GRANTOPTION_ID     
							AND VESTING_DATE =@VESTING_DATE 
							AND GRANTLEGSERIALNO=@GRANTLEGSERIAL_NO     
							AND TEMP_EXERCISEID=@TEMP_EXERCISEID    
            
			END     
			ELSE    
			BEGIN    
        
					INSERT INTO #TEMP_TAX_COUNTRY_DAYS
					(		INSTRUMENT_ID,
							EMPLOYEE_ID,
							COUNTRY_ID,
							GRANTOPTIONID,
							TOT_DAYS,
							GRANTLEGSERIALNO,
							FROM_DATE,
							TO_DATE,
							TEMP_EXERCISEID,
							STOCK_VALUE
					)    
					SELECT  INSTRUMENT_ID,
							EMPLOYEE_ID,
							COUNTRY_ID,
							GRANTOPTIONID,
							TOT_DAYS,
							GRANTLEGSERIALNO,
							FROM_DATE,
							TO_DATE,
							TEMP_EXERCISEID,
							STOCK_VALUE 
					FROM	#TEMP_EMPLOYEE_COUNTRY    
					WHERE	INSTRUMENT_ID = @MIT_ID 
							AND EMPLOYEE_ID =@EmployeeID 
							AND GRANTOPTIONID = @GRANTOPTION_ID  
							AND GRANTLEGSERIALNO=@GRANTLEGSERIAL_NO     
							AND  TEMP_EXERCISEID=@TEMP_EXERCISEID    
         
					DELETE FROM #TempMobility_Tracking    
					INSERT INTO #TempMobility_Tracking(ID,Country,FromDate,Todate)    
					EXEC PROC_GET_MOBILITY_DETAILS @EmployeeID, @INCIDENCEDATE,@INCIDENCEDATE     
         
    
					IF NOT EXISTS(Select *  from #TEMP_TAX_COUNTRY_DAYS WHERE COUNTRY_ID >0 AND TEMP_EXERCISEID=@TEMP_EXERCISEID)    
					BEGIN    
         
						IF EXISTS(Select * from  #TempMobility_Tracking)    
						BEGIN    
							UPDATE  #TEMP_TAX_COUNTRY_DAYS    
							SET COUNTRY_ID=TMT.ID    
							FROM #TempMobility_Tracking TMT    
							WHERE TEMP_EXERCISEID=@TEMP_EXERCISEID    
						END    
         
					END    
         
			END    
			-- Loop for multiple Countries  
			SET @IS_COMPANY_LEVEL=0      
             
			SELECT @MINVALUE=MIN(ID),@MaxValue=MAX(ID)From #TEMP_TAX_COUNTRY_DAYS    
			WHILE(@MINVALUE<=@MAXVALUE)    
			BEGIN          
                     
			SELECT @Country_ID=COUNTRY_ID,@GRANTLEGSERIAL_NO  = GRANTLEGSERIALNO,@FROM_DATE_TAX=FROM_DATE,@TO_DATE_TAX = TO_DATE  FROM #TEMP_TAX_COUNTRY_DAYS    
			WHERE ID=@MINVALUE    
       
        
			IF(@Country_ID >0)    
			BEGIN    
			IF(UPPER(@COUNTRY_CATEGORY_PROPORT) = 'AC')    
			BEGIN    
			/* Block For AC */    
			IF EXISTS(Select TR.TRSC_ID FRom TAX_RATE_SETTING_CONFIG TR  INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID AND TRM.Employee_ID=@EmployeeID WHERE COUNTRY_ID=@Country_ID AND MIT_ID=@MIT_ID)    
			BEGIN     
			Print ' tax found For Country'        
			/* For AC Type County wise data*/    
					IF(ISNULL(LEN(@DateOfTermination),0)<=0)    
					BEGIN    
						INSERT INTO #TempTax_Details
						(
								TAX_HEADING,
								TAX_RATE,
								RESIDENT_STATUS,
								TAX_AMOUNT,
								Country,
								[STATE],
								BASISOFTAXATION,
								FMV,
								TOTAL_PERK_VALUE,
								COUNTRY_ID, 
								MIT_ID ,
								EmployeeID ,
								GRANTOPTIONID,
								VESTING_DATE,
								GRANT_DATE ,
								GRANTLEGSERIALNO,
								FROM_DATE,TO_DATE,
								TEMP_EXERCISEID,
								TAXCALCULATION_BASEDON
						)    
						SELECT  CASE WHEN @Total_Perk_Value = '-990099' THEN 'NA' ELSE
					MTRT.TAX_HEADING END, 
								dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_LIVE_EMPLOYEE) AS TAX_RATE, 
								'' AS RESIDENT_STATUS,    
								--dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_LIVE_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN TAXD.TOT_DAYS ELSE TAXD.STOCK_VALUE END ))/100),'TAXAMT')AS TAX_AMOUNT, 
								CASE WHEN @Total_Perk_Value = '-990099' THEN 0 ELSE
							dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_LIVE_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN TAXD.TOT_DAYS ELSE TAXD.STOCK_VALUE END ))/100), 'TAXAMT')
							END AS TAX_AMOUNT ,  
										
								
								CM.CountryName AS Country, 
								NULL AS [STATE],
								CASE WHEN @Total_Perk_Value = '-990099' THEN  CASE WHEN(@IsTaxApplicable = '') THEN 'NA' ELSE @IsTaxApplicable END  ELSE
							'Country Level' END AS BASISOFTAXATION,  
								dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV, 
								((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN TAXD.TOT_DAYS ELSE TAXD.STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
								CM.ID,
								@MIT_ID,
								@EmployeeID,
								@GRANTOPTION_ID,
								@VESTING_DATE,
								@GRANT_DATE,    
								TAXD.GRANTLEGSERIALNO,
								TAXD.FROM_DATE,
								TAXD.TO_DATE,
								TAXD.TEMP_EXERCISEID,
								TAXCALCULATION_BASEDON    
						FROM    TAX_RATE_SETTING_CONFIG TR     
						INNER JOIN  COMPANY_INSTRUMENT_MAPPING CIM ON TR.MIT_ID=CIM.MIT_ID     
						INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID=TR.Tax_Head_Id    
						INNER JOIN  COUNTRYMASTER CM ON CM.ID=TR.COUNTRY_ID    
						INNER JOIN #TEMP_TAX_COUNTRY_DAYS AS TAXD ON CM.ID=TAXD.COUNTRY_ID  AND CM.ID =@Country_ID AND TAXD.ID=@MINVALUE    
						INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID
						WHERE       TR.MIT_ID = @MIT_ID
									AND CM.ID=@Country_ID           
					END             
				ELSE    
				BEGIN     
				-- For seprated    
					INSERT INTO #TempTax_Details
					(
							TAX_HEADING,
							TAX_RATE,
							RESIDENT_STATUS,
							TAX_AMOUNT,
							Country,
							[STATE],
							BASISOFTAXATION,
							FMV,
							TOTAL_PERK_VALUE,
							COUNTRY_ID, 
							MIT_ID ,
							EmployeeID ,
							GRANTOPTIONID,
							VESTING_DATE ,
							GRANT_DATE,
							GRANTLEGSERIALNO,
							FROM_DATE,
							TO_DATE,
							TEMP_EXERCISEID,
							TAXCALCULATION_BASEDON
					)    
					SELECT  CASE WHEN @Total_Perk_Value = '-990099' THEN 'NA' ELSE
					MTRT.TAX_HEADING END, 
							dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_SEPRATED_EMPLOYEE) AS TAX_RATE ,
							'' AS RESIDENT_STATUS,    
							--dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN TAXD.TOT_DAYS ELSE TAXD.STOCK_VALUE END ))/100),'TAXAMT')AS TAX_AMOUNT,    
							CASE WHEN @Total_Perk_Value = '-990099' THEN 0 ELSE
							dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN TAXD.TOT_DAYS ELSE TAXD.STOCK_VALUE END ))/100), 'TAXAMT')
							END AS TAX_AMOUNT , 
							CM.CountryName AS Country, 
							NULL AS [STATE],              
							CASE WHEN @Total_Perk_Value = '-990099' THEN  CASE WHEN(@IsTaxApplicable = '') THEN 'NA' ELSE @IsTaxApplicable END  ELSE
							'Country Level' END AS BASISOFTAXATION, 
							dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV,     
							((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN TAXD.TOT_DAYS ELSE TAXD.STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
							CM.ID,
							@MIT_ID,
							@EmployeeID,
							@GRANTOPTION_ID,
							@VESTING_DATE,
							@GRANT_DATE,
							TAXD.GRANTLEGSERIALNO,
							TAXD.FROM_DATE,
							TAXD.TO_DATE,
							TAXD.TEMP_EXERCISEID ,
							TAXCALCULATION_BASEDON   
					FROM    TAX_RATE_SETTING_CONFIG TR  
					INNER JOIN  COMPANY_INSTRUMENT_MAPPING CIM ON TR.MIT_ID=CIM.MIT_ID     
					INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID=TR.Tax_Head_Id    
					INNER JOIN  COUNTRYMASTER CM ON CM.ID=TR.COUNTRY_ID    
					INNER JOIN #TEMP_TAX_COUNTRY_DAYS AS TAXD ON CM.ID=TAXD.COUNTRY_ID  AND CM.ID =@Country_ID AND TAXD.ID=@MINVALUE    
					INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID 
					WHERE       TR.MIT_ID= @MIT_ID 
					AND CM.ID=@Country_ID    
				END    
    
			END         
			ELSE    
			BEGIN       
				/* Tax Not found for @Country_ID select company level */           
				IF(@IS_COMPANY_LEVEL=0)    
				BEGIN 
				IF EXISTS(SELECT * FROM  #TEMP_TAX_COUNTRY_DAYS)          
					BEGIN    
						SELECT @Total_Perk_Value = SUM(TOT_DAYS) 
						FROM #TEMP_TAX_COUNTRY_DAYS 
						WHERE COUNTRY_ID = @Country_ID 
							AND GRANTLEGSERIALNO = @GRANTLEGSERIAL_NO           
							AND TEMP_EXERCISEID= @TEMP_EXERCISEID 
							AND INSTRUMENT_ID = @MIT_ID 
							AND EMPLOYEE_ID =@EmployeeID 
							AND GRANTOPTIONID = @GRANTOPTION_ID            
					END  
                 
				IF(ISNULL(LEN(@DateOfTermination),0)<=0)    
				BEGIN    
						INSERT INTO #TempTax_Details
						(		TAX_HEADING,
								TAX_RATE,
								RESIDENT_STATUS,
								TAX_AMOUNT,
								Country,
								[STATE],
								BASISOFTAXATION,
								FMV,
								TOTAL_PERK_VALUE,
								COUNTRY_ID ,
								MIT_ID ,
								EmployeeID ,
								GRANTOPTIONID,
								VESTING_DATE,
								GRANT_DATE,
								GRANTLEGSERIALNO,
								FROM_DATE,
								TO_DATE,
								TEMP_EXERCISEID,
								TAXCALCULATION_BASEDON
						)    
						SELECT  CASE WHEN @Total_Perk_Value = '-990099' THEN 'NA' ELSE
					MTRT.TAX_HEADING END, 
								dbo.FN_PQ_TAX_ROUNDING(TR.TAXRATE_LIVE_EMPLOYEE) AS TAX_RATE, 
								'' AS RESIDENT_STATUS,    
								--dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TAXRATE_LIVE_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100),'TAXAMT')AS TAX_AMOUNT,    
								CASE WHEN @Total_Perk_Value = '-990099' THEN 0 ELSE
							dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TAXRATE_LIVE_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100), 'TAXAMT')
							END AS TAX_AMOUNT ,  
								@Country_ID AS Country, 
								'' AS [STATE],
								CASE WHEN @Total_Perk_Value = '-990099' THEN  CASE WHEN(@IsTaxApplicable = '') THEN 'NA' ELSE @IsTaxApplicable END  ELSE
							'Company Level' END AS BASISOFTAXATION,   
								dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV, 
								((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
								0 ,
								@MIT_ID,
								@EmployeeID,
								@GRANTOPTION_ID,
								@VESTING_DATE,
								@GRANT_DATE,
								@GRANTLEGSERIAL_NO,
								NULL,
								NULL ,
								@TEMP_EXERCISEID ,
								TAXCALCULATION_BASEDON   
                
						FROM    TAX_RATE_SETTING_CONFIG TR     
						INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID    
						INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id        
						WHERE   TR.MIT_ID = @MIT_ID 
								AND ISNULL(TR.RESIDENTIAL_ID,0) =0 
								AND ISNULL(TR.COUNTRY_ID,0)=0      
            
			END             
			ELSE    
			BEGIN         
						INSERT INTO #TempTax_Details
						(
								TAX_HEADING,
								TAX_RATE,
								RESIDENT_STATUS,
								TAX_AMOUNT,
								Country,
								[STATE],
								BASISOFTAXATION,
								FMV,
								TOTAL_PERK_VALUE,
								COUNTRY_ID, 
								MIT_ID ,
								EmployeeID ,
								GRANTOPTIONID,
								VESTING_DATE,
								GRANT_DATE,
								GRANTLEGSERIALNO,
								FROM_DATE,
								TO_DATE,
								TEMP_EXERCISEID,
								TAXCALCULATION_BASEDON
						)    
						SELECT  CASE WHEN @Total_Perk_Value = '-990099' THEN 'NA' ELSE
					MTRT.TAX_HEADING END, 
								dbo.FN_PQ_TAX_ROUNDING(TR.TAXRATE_SEPRATED_EMPLOYEE) AS TAX_RATE ,
								'' AS RESIDENT_STATUS,    
								--dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100),'TAXAMT')AS TAX_AMOUNT,    
								CASE WHEN @Total_Perk_Value = '-990099' THEN 0 ELSE
							dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100), 'TAXAMT')
							END AS TAX_AMOUNT , 
								
								@Country_ID AS Country, 
								'' AS [STATE], 
								CASE WHEN @Total_Perk_Value = '-990099' THEN  CASE WHEN(@IsTaxApplicable = '') THEN 'NA' ELSE @IsTaxApplicable END  ELSE
							'Company Level' END AS BASISOFTAXATION, 
								dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV,
								((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
								0 ,
								@MIT_ID,
								@EmployeeID,
								@GRANTOPTION_ID,
								@VESTING_DATE,
								@GRANT_DATE,
								@GRANTLEGSERIAL_NO,
								NULL,
								NULL,
								@TEMP_EXERCISEID ,
								TAXCALCULATION_BASEDON    
                 
						FROM    TAX_RATE_SETTING_CONFIG TR     
							INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID    
							INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id      
							WHERE   TR.MIT_ID= @MIT_ID 
									AND ISNULL(TR.RESIDENTIAL_ID,0) =0 
									AND ISNULL(TR.COUNTRY_ID,0)=0              
						END     
						SET @IS_COMPANY_LEVEL = 1    
			END    
    
			END   
              
			END     
			ELSE    
			BEGIN    
				/* Date Of incidence*/    
				Print 'Date Of incidence __1'    
       print 'see1'
				IF EXISTS(
							SELECT TR.TRSC_ID 
							FROM TAX_RATE_SETTING_CONFIG TR INNER JOIN TAX_RATE_EMP_MAP TRM     
							ON TR.TRSC_ID=TRM.TRSC_ID AND TRM.Employee_ID=@EmployeeID 
							WHERE COUNTRY_ID=@Country_ID AND MIT_ID=@MIT_ID
						 )    
				   
				BEGIN    
				/* Date of incidence Country wise*/     
				/* Tax Not found for @Country_ID select company level on date of incidence */        
				IF(LEN(ISNULL(@DateOfTermination,''))<=0)    
				BEGIN             
					print 'Seprated employee in Date of incidence '    
					INSERT INTO #TempTax_Details
					(
							TAX_HEADING,
							TAX_RATE,
							RESIDENT_STATUS,
							TAX_AMOUNT,
							Country,
							[STATE],
							BASISOFTAXATION,
							FMV,
							TOTAL_PERK_VALUE,
							COUNTRY_ID, 
							MIT_ID ,
							EmployeeID ,
							GRANTOPTIONID,
							VESTING_DATE,
							GRANT_DATE ,
							GRANTLEGSERIALNO,
							FROM_DATE,
							TO_DATE,
							TEMP_EXERCISEID,
							TAXCALCULATION_BASEDON
					)    
					SELECT  CASE WHEN @Total_Perk_Value = '-990099' THEN 'NA' ELSE
					MTRT.TAX_HEADING END,
							dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_LIVE_EMPLOYEE) AS TAX_RATE, 
							'' AS RESIDENT_STATUS,    
							--dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_LIVE_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100),'TAXAMT')AS TAX_AMOUNT,    
							CASE WHEN @Total_Perk_Value = '-990099' THEN 0 ELSE
							dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100), 'TAXAMT')
							END AS TAX_AMOUNT ,  
							CM.CountryName AS Country, 
							NULL AS [STATE],
							CASE WHEN @Total_Perk_Value = '-990099' THEN  CASE WHEN(@IsTaxApplicable = '') THEN 'NA' ELSE @IsTaxApplicable END  ELSE
							'Country Level' END AS BASISOFTAXATION,    
							dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV, ((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
							CM.ID as 'COUNTRY_ID',
							@MIT_ID,
							@EmployeeID,
							@GRANTOPTION_ID,
							@VESTING_DATE ,
							@GRANT_DATE,
							@GRANTLEGSERIAL_NO,
							@FROM_DATE_TAX,
							@TO_DATE_TAX,
							@TEMP_EXERCISEID ,
							TAXCALCULATION_BASEDON   
    
					FROM    TAX_RATE_SETTING_CONFIG TR     
					INNER JOIN  COMPANY_INSTRUMENT_MAPPING CIM ON TR.MIT_ID=CIM.MIT_ID     
					INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID=TR.Tax_Head_Id    
					INNER JOIN  COUNTRYMASTER CM ON CM.ID=TR.COUNTRY_ID    
					INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID AND TRM.Employee_ID=@EmployeeID    
					WHERE       TR.MIT_ID = @MIT_ID 
					AND CM.ID=@Country_ID    
    
			END             
			ELSE    
			BEGIN     
				print 'Active employee in Date of incidence '    
				INSERT INTO #TempTax_Details
				(
						TAX_HEADING,
						TAX_RATE,
						RESIDENT_STATUS,
						TAX_AMOUNT,
						Country,
						[STATE],
						BASISOFTAXATION,
						FMV,
						TOTAL_PERK_VALUE,
						COUNTRY_ID, 
						MIT_ID ,
						EmployeeID ,
						GRANTOPTIONID,
						VESTING_DATE,
						GRANT_DATE ,
						GRANTLEGSERIALNO,
						FROM_DATE,
						TO_DATE,
						TEMP_EXERCISEID,
						TAXCALCULATION_BASEDON
				)    
				SELECT  CASE WHEN @Total_Perk_Value = '-990099' THEN 'NA' ELSE
					MTRT.TAX_HEADING END, 
						dbo.FN_PQ_TAX_ROUNDING(TR.TAXRATE_SEPRATED_EMPLOYEE) AS TAX_RATE ,
						'' AS RESIDENT_STATUS,    
						--dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100),'TAXAMT')AS TAX_AMOUNT,    
						CASE WHEN @Total_Perk_Value = '-990099' THEN 0 ELSE
							dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100), 'TAXAMT')
							END AS TAX_AMOUNT ,  
						
						CM.CountryName AS Country, 
						NULL AS [STATE],            
						CASE WHEN @Total_Perk_Value = '-990099' THEN  CASE WHEN(@IsTaxApplicable = '') THEN 'NA' ELSE @IsTaxApplicable END  ELSE
							'Country Level' END AS BASISOFTAXATION, 
						
						dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV,     
						((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
						CM.ID as COUNTRY_ID,    
						@MIT_ID,
						@EmployeeID,
						@GRANTOPTION_ID,
						@VESTING_DATE ,
						@GRANT_DATE,
						@GRANTLEGSERIAL_NO,
						@FROM_DATE_TAX,
						@TO_DATE_TAX,
						@TEMP_EXERCISEID,
						TAXCALCULATION_BASEDON    
    
				FROM    TAX_RATE_SETTING_CONFIG TR     
				INNER JOIN  COMPANY_INSTRUMENT_MAPPING CIM ON TR.MIT_ID=CIM.MIT_ID     
				INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID=TR.Tax_Head_Id    
				INNER JOIN  COUNTRYMASTER CM ON CM.ID=TR.COUNTRY_ID    
				INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID AND TRM.Employee_ID=@EmployeeID    
				WHERE		TR.MIT_ID= @MIT_ID 
				AND CM.ID=@Country_ID    
			END         
          
			END    
			ELSE    
			BEGIN    
			/* Date of incidence company Level if*/    
			IF(@IS_COMPANY_LEVEL=0)    
			BEGIN          
				IF(ISNULL(LEN(@DateOfTermination),0)<=0)    
				BEGIN    
					INSERT INTO #TempTax_Details
					(
							TAX_HEADING,
							TAX_RATE,
							RESIDENT_STATUS,
							TAX_AMOUNT,
							Country,
							[STATE],
							BASISOFTAXATION,
							FMV,
							TOTAL_PERK_VALUE,
							COUNTRY_ID,
							GRANTLEGSERIALNO,
							VESTING_DATE,
							GRANT_DATE,
							FROM_DATE,
							TO_DATE,
							TEMP_EXERCISEID,
							TAXCALCULATION_BASEDON
					)    
					SELECT  MTRT.TAX_HEADING,
							dbo.FN_PQ_TAX_ROUNDING(TR.TAXRATE_LIVE_EMPLOYEE) AS TAX_RATE, 
							'' AS RESIDENT_STATUS,    
							dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TAXRATE_LIVE_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100),'TAXAMT')AS TAX_AMOUNT,    
							'' AS Country, 
							'' AS [STATE],'Company Level' AS BASISOFTAXATION,    
							dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV, ((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
							0,
							@GRANTLEGSERIAL_NO,
							@VESTING_DATE,
							@GRANT_DATE,
							NULL,
							NULL,
							@TEMP_EXERCISEID,
							TAXCALCULATION_BASEDON     
					FROM   TAX_RATE_SETTING_CONFIG TR     
					INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID    
					INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id       
					WHERE       TR.MIT_ID = @MIT_ID 
					
								AND ISNULL(TR.RESIDENTIAL_ID,0) =0 
								AND ISNULL(TR.COUNTRY_ID,0)=0      
                
				END             
				ELSE    
				BEGIN         
					INSERT INTO #TempTax_Details
					(
							TAX_HEADING,
							TAX_RATE,
							RESIDENT_STATUS,
							TAX_AMOUNT,
							Country,
							[STATE],
							BASISOFTAXATION,
							FMV,
							TOTAL_PERK_VALUE,
							COUNTRY_ID,
							GRANTLEGSERIALNO,
							VESTING_DATE,
							GRANT_DATE,
							FROM_DATE,
							TO_DATE,
							TEMP_EXERCISEID,
							TAXCALCULATION_BASEDON
					)    
					SELECT  MTRT.TAX_HEADING,
							dbo.FN_PQ_TAX_ROUNDING(TR.TAXRATE_SEPRATED_EMPLOYEE) AS TAX_RATE ,
							'' AS RESIDENT_STATUS,    
							dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100),'TAXAMT')AS TAX_AMOUNT,    
							'' AS Country, 
							'' AS [STATE], 
							'Company Level' AS BASISOFTAXATION,
							dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV, 
							((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,0    
							,@GRANTLEGSERIAL_NO,
							@VESTING_DATE,@GRANT_DATE,
							NULL,
							NULL,
							@TEMP_EXERCISEID,
							TAXCALCULATION_BASEDON     
					FROM    TAX_RATE_SETTING_CONFIG TR     
					INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID    
					INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id   
					WHERE       TR.MIT_ID= @MIT_ID 
						AND ISNULL(TR.RESIDENTIAL_ID,0) =0 
						AND ISNULL(TR.COUNTRY_ID,0)=0              
					END    
					SET @IS_COMPANY_LEVEL=1              
			END     
			/*End date of incidence company level */     
			END    
         
			END       
    
    
			END --End Country ID >0    
			ELSE    
			BEGIN    
			/* Company Level  */    
			/* Mobility not done*/      
			IF(ISNULL(LEN(@DateOfTermination),0)<=0)   
			BEGIN    
				INSERT INTO #TempTax_Details
				(
						TAX_HEADING,
						TAX_RATE,
						RESIDENT_STATUS,
						TAX_AMOUNT,
						Country,
						[STATE],
						BASISOFTAXATION,
						FMV,
						TOTAL_PERK_VALUE,
						COUNTRY_ID, 
						MIT_ID ,
						EmployeeID ,
						GRANTOPTIONID,
						VESTING_DATE,
						GRANT_DATE,
						GRANTLEGSERIALNO,
						FROM_DATE,
						TO_DATE,
						TEMP_EXERCISEID,
						TAXCALCULATION_BASEDON
				)    
				SELECT  MTRT.TAX_HEADING,
						dbo.FN_PQ_TAX_ROUNDING(TR.TAXRATE_LIVE_EMPLOYEE) AS TAX_RATE, 
						'' AS RESIDENT_STATUS,    
						dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TAXRATE_LIVE_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100),'TAXAMT')AS TAX_AMOUNT,    
						'' AS COUNTRY, 
						NULL AS [STATE],
						'Company Level' AS BASISOFTAXATION, 
						dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV,     
						((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
						0 AS COUNTRY_ID    
						,@MIT_ID,
						@EmployeeID,
						@GRANTOPTION_ID,
						@VESTING_DATE,
						@GRANT_DATE, 
						@GRANTLEGSERIAL_NO,
						NULL,
						NULL,
						@TEMP_EXERCISEID,
						TAXCALCULATION_BASEDON     
                     
				FROM        TAX_RATE_SETTING_CONFIG TR     
				INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID    
				INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id                
				WHERE       TR.MIT_ID= @MIT_ID 
							AND ISNULL(TR.RESIDENTIAL_ID,0) = 0 
							AND ISNULL(TR.COUNTRY_ID,0)=0    
			END    
			ELSE    
			BEGIN    
            
				INSERT INTO #TempTax_Details
				(
						TAX_HEADING,
						TAX_RATE,
						RESIDENT_STATUS,
						TAX_AMOUNT,
						Country,
						[STATE],
						BASISOFTAXATION,
						FMV,
						TOTAL_PERK_VALUE,
						COUNTRY_ID, 
						MIT_ID ,
						EmployeeID ,
						GRANTOPTIONID,
						VESTING_DATE,
						GRANT_DATE, 
						GRANTLEGSERIALNO,
						FROM_DATE,
						TO_DATE,
						TEMP_EXERCISEID,
						TAXCALCULATION_BASEDON
				)    
				SELECT  MTRT.TAX_HEADING,
						dbo.FN_PQ_TAX_ROUNDING(TR.TAXRATE_SEPRATED_EMPLOYEE) AS TAX_RATE, 
						'' AS RESIDENT_STATUS,    
						dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100),'TAXAMT')AS TAX_AMOUNT,    
						'' AS COUNTRY, 
						'' AS [STATE],
						'Company Level' AS BASISOFTAXATION, 
						dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV,     
						((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
						0 AS COUNTRY_ID    
						,@MIT_ID,
						@EmployeeID,
						@GRANTOPTION_ID,
						@VESTING_DATE,
						@GRANT_DATE, 
						@GRANTLEGSERIAL_NO,
						NULL,
						NULL,
						@TEMP_EXERCISEID,
						TAXCALCULATION_BASEDON     
                           
				FROM        TAX_RATE_SETTING_CONFIG TR     
				INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID     
				INNER JOIN  MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id           
				WHERE	TR.MIT_ID= @MIT_ID 
						AND ISNULL(TR.RESIDENTIAL_ID,0) = 0 
						AND ISNULL(TR.COUNTRY_ID,0)=0    
			END    
        
			END    
    
			SET @MINVALUE=@MINVALUE+1    
    
			END    
        
			-- End Loof for multiple countries    
               
			END  
		 -- check exception For Tax Rate Employee is Employee Resident --
			IF(@EXCEPT_FOR_TAXRATE_EMPLOYEE='ER')    
			BEGIN    
				/* Tax rate calculation for residential*/    
				IF EXISTS    
				(    
					SELECT     
					TR.TRSC_ID     
					FROM    
					TAX_RATE_SETTING_CONFIG TR     
					INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id    
					INNER JOIN COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID = CM.MIT_ID     
					INNER JOIN RESIDENTIALTYPE RT ON RT.ID = TR.RESIDENTIAL_ID 
					INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID    
					WHERE    
					TR.MIT_ID = @MIT_ID 
					AND TRM.Employee_ID = @EmployeeID 
					AND TR.IS_TAXRATEAPPLICABLE = 1  
					AND TAX_RATE_STATUS_DETAILS = 1  
					AND ISNULL(TR.RESIDENTIAL_ID,0)=@Resident_ID 
					AND ISNULL(TR.COUNTRY_ID,0)=0    
				)    
				BEGIN    
						IF(ISNULL(LEN(@DateOfTermination),0)<=0)  
						BEGIN    
							INSERT INTO #TempTax_Details    
							(    
									TAX_HEADING, 
									TAX_RATE, 
									RESIDENT_STATUS, 
									TAX_AMOUNT, 
									Country, 
									[STATE], 
									BASISOFTAXATION, 
									FMV, 
									TOTAL_PERK_VALUE,
									RESIDENT_ID,     
									COUNTRY_ID, 
									MIT_ID, 
									EmployeeID, 
									GRANTOPTIONID, 
									VESTING_DATE,
									GRANT_DATE,
									GRANTLEGSERIALNO,
									TAXCALCULATION_BASEDON,
									TEMP_EXERCISEID    
							)    
							SELECT    
									MTRT.TAX_HEADING, 
									dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_LIVE_EMPLOYEE) AS TAX_RATE, 
									RT.[Description] AS RESIDENT_STATUS,    
									dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_LIVE_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100),'TAXAMT')AS TAX_AMOUNT,    
									NULL AS Country, 
									NULL AS [STATE],
									'Employee Resident' AS BASISOFTAXATION,    
									dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV,
									((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
									RT.id AS Resident_ID, 
									0 AS COUNTRY_ID, 
									@MIT_ID, 
									@EmployeeID,     
									@GRANTOPTION_ID,
									@VESTING_DATE,
									@GRANT_DATE,
									@GRANTLEGSERIAL_NO,
									TAXCALCULATION_BASEDON ,
									@TEMP_EXERCISEID    
							FROM    
							TAX_RATE_SETTING_CONFIG TR     
							INNER JOIN COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID = CM.MIT_ID 
							INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID   
							INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID=TR.Tax_Head_Id    
							INNER JOIN RESIDENTIALTYPE RT ON RT.ID=TR.RESIDENTIAL_ID            
							WHERE    
									TR.MIT_ID = @MIT_ID 
									AND ISNULL(TRM.Employee_ID,'') = @EmployeeID 
									AND ISNULL(TR.RESIDENTIAL_ID,0)=@Resident_ID 
									AND ISNULL(TR.COUNTRY_ID,0)=0           
						END             
						ELSE    
						BEGIN     
							INSERT INTO #TempTax_Details    
							(    
									TAX_HEADING, 
									TAX_RATE, 
									RESIDENT_STATUS, 
									TAX_AMOUNT, 
									Country, 
									[STATE], 
									BASISOFTAXATION, 
									FMV, 
									TOTAL_PERK_VALUE, 
									RESIDENT_ID, 
									COUNTRY_ID,    
									MIT_ID, 
									EmployeeID, 
									GRANTOPTIONID, 
									VESTING_DATE,
									GRANT_DATE,
									GRANTLEGSERIALNO,
									TAXCALCULATION_BASEDON ,
									TEMP_EXERCISEID   
							)     
							SELECT    
									MTRT.TAX_HEADING,
									dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_SEPRATED_EMPLOYEE) AS TAX_RATE ,
									RT.[Description] AS RESIDENT_STATUS,    
									dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100),'TAXAMT')AS TAX_AMOUNT,   
									NULL AS Country, NULL AS [STATE],           
									'Employee Resident' AS BASISOFTAXATION,dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV,     
									((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE ,
									RT.id AS Resident_ID ,
									0 AS COUNTRY_ID,
									@MIT_ID,
									@EmployeeID,
									@GRANTOPTION_ID,
									@VESTING_DATE,
									@GRANT_DATE,
									@GRANTLEGSERIAL_NO ,
									TAXCALCULATION_BASEDON,
									@TEMP_EXERCISEID                
							FROM   TAX_RATE_SETTING_CONFIG TR     
							INNER JOIN COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID 
							INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID   
							INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID=TR.Tax_Head_Id     
							INNER JOIN RESIDENTIALTYPE RT ON RT.ID=TR.RESIDENTIAL_ID   
							WHERE	TR.MIT_ID = @MIT_ID 
									AND ISNULL(TRM.Employee_ID,'') = @EmployeeID  
									AND ISNULL(TR.RESIDENTIAL_ID,0)=@Resident_ID 
									AND ISNULL(TR.COUNTRY_ID,0)=0  
						END     
				END    
				ELSE    
				BEGIN    
					-- company level status    
						INSERT INTO #TempTax_Details    
						(    
								TAX_HEADING, 
								TAX_RATE, 
								RESIDENT_STATUS, 
								TAX_AMOUNT, 
								Country, 
								[STATE], 
								BASISOFTAXATION, 
								FMV, 
								TOTAL_PERK_VALUE,
								RESIDENT_ID,    
								COUNTRY_ID, 
								MIT_ID, 
								EmployeeID, 
								GRANTOPTIONID, 
								VESTING_DATE ,
								GRANT_DATE,
								GRANTLEGSERIALNO ,
								TAXCALCULATION_BASEDON ,
								TEMP_EXERCISEID  
						)     
							SELECT    
								MTRT.TAX_HEADING, 
								dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_SEPRATED_EMPLOYEE) AS TAX_RATE, 
								@ResidentStatus AS RESIDENT_STATUS,    
								dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100), 'TAXAMT')AS TAX_AMOUNT,   
								'' AS Country, 
								'' AS [STATE], 
								'Company Level' AS BASISOFTAXATION, 
								dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV,
								((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,   
								@Resident_ID As RESIDENT_ID ,
								0 AS COUNTRY_ID, 
								@MIT_ID, 
								@EmployeeID, 
								@GRANTOPTION_ID, 
								@VESTING_DATE,
								@GRANT_DATE,
								@GRANTLEGSERIAL_NO ,
								TAXCALCULATION_BASEDON,
								@TEMP_EXERCISEID                
							FROM     
							TAX_RATE_SETTING_CONFIG TR     
							INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID  
							INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID  
							INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id     
							WHERE    
							TR.MIT_ID = @MIT_ID 
							AND ISNULL(TRM.Employee_ID,'') = '' 
							AND ISNULL(TR.RESIDENTIAL_ID,0) = 0 
							AND ISNULL(TR.COUNTRY_ID,0)=0              
        
				END    
				END  
			 -- check exception For Tax Rate Employee is Employee Country --   
				ELSE IF(@EXCEPT_FOR_TAXRATE_EMPLOYEE='EC')    
				BEGIN    
  
					SELECT @EventOfIncidence = CODE_NAME FROM MST_COM_CODE  WHERE MCC_ID = @Event_OF_INCIDENCE    
        
					IF(@EventOfIncidence = 'Grant Date')        
						SET  @INCIDENCEDATE = @GRANT_DATE                     
					ELSE IF(@EventOfIncidence = 'Vesting Date')         
						SET  @INCIDENCEDATE = @VESTING_DATE        
					ELSE IF(@EventOfIncidence = 'Exercise Date')        
						SET  @INCIDENCEDATE = @EXERCISE_DATE    
        
					print @INCIDENCEDATE     
					DELETE FROM #TEMP_TAX_COUNTRY_DAYS    
					IF(UPPER(@COUNTRY_CATEGORY_PROPORT) = 'AC')    
					BEGIN    
					print 'All Country'    
          
						INSERT INTO #TEMP_TAX_COUNTRY_DAYS    
						(
								INSTRUMENT_ID,
								EMPLOYEE_ID,
								COUNTRY_ID,
								GRANTOPTIONID,
								TOT_DAYS,
								GRANTLEGSERIALNO,
								FROM_DATE,
								TO_DATE,
								TEMP_EXERCISEID,
								STOCK_VALUE
						)           
						SELECT  INSTRUMENT_ID,
								EMPLOYEE_ID,
								COUNTRY_ID,
								GRANTOPTIONID,
								TOT_DAYS,
								GRANTLEGSERIALNO,
								FROM_DATE,
								TO_DATE,
								TEMP_EXERCISEID,
								STOCK_VALUE      
						FROM     
						#TEMP_EMPLOYEE_COUNTRY    
						WHERE   INSTRUMENT_ID = @MIT_ID 
								AND EMPLOYEE_ID =@EmployeeID 
								AND GRANTOPTIONID = @GRANTOPTION_ID     
								AND VESTING_DATE =@VESTING_DATE 
								AND GRANTLEGSERIALNO=@GRANTLEGSERIAL_NO     
								AND TEMP_EXERCISEID=@TEMP_EXERCISEID    
           
					END     
					ELSE    
					BEGIN    
        
						INSERT INTO #TEMP_TAX_COUNTRY_DAYS
						(
								INSTRUMENT_ID,
								EMPLOYEE_ID,
								COUNTRY_ID,
								GRANTOPTIONID,
								TOT_DAYS,
								GRANTLEGSERIALNO,
								FROM_DATE,
								TO_DATE,
								TEMP_EXERCISEID,
								STOCK_VALUE
						)    
						SELECT  INSTRUMENT_ID,
								EMPLOYEE_ID,
								COUNTRY_ID,
								GRANTOPTIONID,
								TOT_DAYS,
								GRANTLEGSERIALNO,
								FROM_DATE,
								TO_DATE,
								TEMP_EXERCISEID,
								STOCK_VALUE 
						FROM #TEMP_EMPLOYEE_COUNTRY    
						WHERE	INSTRUMENT_ID = @MIT_ID 
								AND EMPLOYEE_ID =@EmployeeID 
								AND GRANTOPTIONID = @GRANTOPTION_ID  
								AND GRANTLEGSERIALNO=@GRANTLEGSERIAL_NO     
								AND  TEMP_EXERCISEID=@TEMP_EXERCISEID    
         
						DELETE FROM #TempMobility_Tracking    
						INSERT INTO #TempMobility_Tracking(ID,Country,FromDate,Todate)    
						EXEC PROC_GET_MOBILITY_DETAILS @EmployeeID, @INCIDENCEDATE,@INCIDENCEDATE     
         
    
						IF NOT EXISTS(Select *  from #TEMP_TAX_COUNTRY_DAYS WHERE COUNTRY_ID >0 AND TEMP_EXERCISEID=@TEMP_EXERCISEID)    
						BEGIN    
         
							IF EXISTS(Select * from  #TempMobility_Tracking)    
							BEGIN    
								UPDATE  #TEMP_TAX_COUNTRY_DAYS    
								SET COUNTRY_ID=TMT.ID    
								FROM #TempMobility_Tracking TMT    
								WHERE TEMP_EXERCISEID=@TEMP_EXERCISEID    
							END    
         
						END    
         
				END    
				-- Loop for multiple Countries    
   
				SET @IS_COMPANY_LEVEL=0    
         
				SELECT @MINVALUE=MIN(ID),@MaxValue=MAX(ID)From #TEMP_TAX_COUNTRY_DAYS    
				WHILE(@MINVALUE<=@MAXVALUE)    
				BEGIN          
                     
						SELECT	@Country_ID=COUNTRY_ID,
								@GRANTLEGSERIAL_NO  = GRANTLEGSERIALNO,
								@FROM_DATE_TAX=FROM_DATE,
								@TO_DATE_TAX = TO_DATE  
						FROM #TEMP_TAX_COUNTRY_DAYS    
						WHERE ID=@MINVALUE    
       
        
						IF(@Country_ID >0)    
						BEGIN    
								IF(UPPER(@COUNTRY_CATEGORY_PROPORT) = 'AC')    
								BEGIN    
									/* Block For AC */    
									IF EXISTS
											(
												SELECT TR.TRSC_ID 
												FROM TAX_RATE_SETTING_CONFIG TR  
												INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID AND TRM.Employee_ID=@EmployeeID 
												WHERE COUNTRY_ID=@Country_ID AND MIT_ID=@MIT_ID
											)    
									BEGIN     
										/* Print ' tax found For Country11'        */
										/* For AC Type County wise data*/    
										IF(ISNULL(LEN(@DateOfTermination),0)<=0)   
										BEGIN    
											INSERT INTO #TempTax_Details
											(
													TAX_HEADING,
													TAX_RATE,
													RESIDENT_STATUS,
													TAX_AMOUNT,
													Country,
													[STATE],
													BASISOFTAXATION,
													FMV,
													TOTAL_PERK_VALUE,
													COUNTRY_ID, 
													MIT_ID ,
													EmployeeID ,
													GRANTOPTIONID,
													VESTING_DATE,
													GRANT_DATE ,
													GRANTLEGSERIALNO,
													FROM_DATE,
													TO_DATE,
													TEMP_EXERCISEID,
													TAXCALCULATION_BASEDON
											)    
											SELECT  MTRT.TAX_HEADING,
													dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_LIVE_EMPLOYEE) AS TAX_RATE, 
													'' AS RESIDENT_STATUS,    
													dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_LIVE_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN TAXD.TOT_DAYS ELSE TAXD.STOCK_VALUE END ))/100),'TAXAMT')AS TAX_AMOUNT,    


													CM.CountryName AS Country, 
													NULL AS [STATE],
													'Country Level' AS BASISOFTAXATION,    
													dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV,
													((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN TAXD.TOT_DAYS ELSE TAXD.STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
													CM.ID,
													@MIT_ID,
													@EmployeeID,
													@GRANTOPTION_ID,
													@VESTING_DATE,
													@GRANT_DATE,    
													TAXD.GRANTLEGSERIALNO,
													TAXD.FROM_DATE,
													TAXD.TO_DATE,
													TAXD.TEMP_EXERCISEID,
													TAXCALCULATION_BASEDON    
               
											FROM    TAX_RATE_SETTING_CONFIG TR
										     
											INNER JOIN  COMPANY_INSTRUMENT_MAPPING CIM ON TR.MIT_ID=CIM.MIT_ID     
											INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID=TR.Tax_Head_Id    
											INNER JOIN  COUNTRYMASTER CM ON CM.ID=TR.COUNTRY_ID    
											INNER JOIN #TEMP_TAX_COUNTRY_DAYS AS TAXD ON CM.ID=TAXD.COUNTRY_ID  AND CM.ID =@Country_ID AND TAXD.ID=@MINVALUE    
											INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID  
										   
											WHERE   TR.MIT_ID = @MIT_ID 
													AND ISNULL(TRM.Employee_ID,'') = @EmployeeID 
													AND CM.ID=@Country_ID 
													AND ISNULL(TR.RESIDENTIAL_ID,0)=0          
										END             
										ELSE    
										BEGIN     
										-- For seprated  
											INSERT INTO #TempTax_Details
											(
													TAX_HEADING,
													TAX_RATE,
													RESIDENT_STATUS,
													TAX_AMOUNT,
													Country,
													[STATE],
													BASISOFTAXATION,
													FMV,
													TOTAL_PERK_VALUE,
													COUNTRY_ID, 
													MIT_ID ,
													EmployeeID ,
													GRANTOPTIONID,
													VESTING_DATE ,
													GRANT_DATE,
													GRANTLEGSERIALNO,
													FROM_DATE,
													TO_DATE,
													TEMP_EXERCISEID,
													TAXCALCULATION_BASEDON
											)    
											SELECT  MTRT.TAX_HEADING,
													dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_SEPRATED_EMPLOYEE) AS TAX_RATE ,
													'' AS RESIDENT_STATUS,    
													dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN TAXD.TOT_DAYS ELSE TAXD.STOCK_VALUE END ))/100),'TAXAMT')AS TAX_AMOUNT,  
  
													CM.CountryName AS Country, 
													NULL AS [STATE],              
													'Country Level' AS BASISOFTAXATION,
													dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV,     
													((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN TAXD.TOT_DAYS ELSE TAXD.STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
													CM.ID,
													@MIT_ID,
													@EmployeeID,
													@GRANTOPTION_ID,
													@VESTING_DATE,
													@GRANT_DATE,    
													TAXD.GRANTLEGSERIALNO,
													TAXD.FROM_DATE,
													TAXD.TO_DATE,
													TAXD.TEMP_EXERCISEID,
													TAXCALCULATION_BASEDON  
												 
											FROM    TAX_RATE_SETTING_CONFIG TR 
										    
													INNER JOIN  COMPANY_INSTRUMENT_MAPPING CIM ON TR.MIT_ID=CIM.MIT_ID     
													INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID=TR.Tax_Head_Id    
													INNER JOIN  COUNTRYMASTER CM ON CM.ID=TR.COUNTRY_ID    
													INNER JOIN #TEMP_TAX_COUNTRY_DAYS AS TAXD ON CM.ID=TAXD.COUNTRY_ID  AND CM.ID =@Country_ID AND TAXD.ID=@MINVALUE    
													INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID   
												  
											WHERE   TR.MIT_ID= @MIT_ID 
													AND ISNULL(TRM.Employee_ID,'') = @EmployeeID 
													AND CM.ID=@Country_ID 
													AND ISNULL(TR.RESIDENTIAL_ID,0)=0
										END    
    
								END         
								ELSE    
								BEGIN       
									/* Tax Not found for @Country_ID select company level */           
									IF(@IS_COMPANY_LEVEL=0)    
									BEGIN           
										IF(ISNULL(LEN(@DateOfTermination),0)<=0)    
										BEGIN    
										print 'ss8'
											INSERT INTO #TempTax_Details
											(
													TAX_HEADING,
													TAX_RATE,
													RESIDENT_STATUS,
													TAX_AMOUNT,
													Country,
													[STATE],
													BASISOFTAXATION,
													FMV,
													TOTAL_PERK_VALUE,
													COUNTRY_ID ,
													MIT_ID ,
													EmployeeID ,
													GRANTOPTIONID,
													VESTING_DATE,
													GRANT_DATE,
													GRANTLEGSERIALNO,
													FROM_DATE,
													TO_DATE,
													TEMP_EXERCISEID,
													TAXCALCULATION_BASEDON
											)    
											SELECT  MTRT.TAX_HEADING,
													dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_LIVE_EMPLOYEE) AS TAX_RATE, 
													'' AS RESIDENT_STATUS,    
													dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_LIVE_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100),'TAXAMT')AS TAX_AMOUNT,    
													NULL AS Country, 
													'' AS [STATE],
													'Company Level' AS BASISOFTAXATION,    
													dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV, 
													((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
													0 ,
													@MIT_ID,
													@EmployeeID,
													@GRANTOPTION_ID,
													@VESTING_DATE,
													@GRANT_DATE,
													@GRANTLEGSERIAL_NO,
													NULL,
													NULL ,
													@TEMP_EXERCISEID ,
													TAXCALCULATION_BASEDON   
											FROM    TAX_RATE_SETTING_CONFIG TR     
													INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID    
													INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id
													INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID          
											WHERE   TR.MIT_ID = @MIT_ID 
													--AND ISNULL(TRM.Employee_ID,'')='' 
													AND ISNULL(TR.RESIDENTIAL_ID,0) =0 
													AND ISNULL(TR.COUNTRY_ID,0)=0      
            
										END             
										ELSE    
										BEGIN 
										print 'ss6'
											INSERT INTO #TempTax_Details
											(
													TAX_HEADING,
													TAX_RATE,
													RESIDENT_STATUS,
													TAX_AMOUNT,
													Country,
													[STATE],
													BASISOFTAXATION,
													FMV,
													TOTAL_PERK_VALUE,
													COUNTRY_ID, 
													MIT_ID ,
													EmployeeID ,
													GRANTOPTIONID,
													VESTING_DATE,
													GRANT_DATE,
													GRANTLEGSERIALNO,
													FROM_DATE,
													TO_DATE,
													TEMP_EXERCISEID,
													TAXCALCULATION_BASEDON
											)    
											SELECT  MTRT.TAX_HEADING,
													dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_SEPRATED_EMPLOYEE) AS TAX_RATE ,
													'' AS RESIDENT_STATUS,    
													dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100),'TAXAMT')AS TAX_AMOUNT,  
  
													NULL AS Country, 
													NULL AS [STATE], 
													'Company Level' AS BASISOFTAXATION,
													dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV,
													((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
													0 ,
													@MIT_ID,
													@EmployeeID,
													@GRANTOPTION_ID,
													@VESTING_DATE,
													@GRANT_DATE,
													@GRANTLEGSERIAL_NO,
													NULL,
													NULL,
													@TEMP_EXERCISEID ,
													TAXCALCULATION_BASEDON    
                 
											FROM    TAX_RATE_SETTING_CONFIG TR     
													INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID    
													INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id 
													INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID      
											WHERE   TR.MIT_ID= @MIT_ID 
													--AND ISNULL(TRM.Employee_ID,'')='' 
													AND ISNULL(TR.RESIDENTIAL_ID,0) =0 
													AND ISNULL(TR.COUNTRY_ID,0)=0              
										END     
											SET @IS_COMPANY_LEVEL = 1    
									END    
    
								END   
              
								END     
								ELSE    
								BEGIN    
									/* Date Of incidence*/    
									Print 'Date Of incidence __1'    
       print 'see2'
									IF EXISTS(
												SELECT TR.TRSC_ID FROM TAX_RATE_SETTING_CONFIG TR 
												INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID AND TRM.Employee_ID=@EmployeeID 
												WHERE COUNTRY_ID=@Country_ID AND MIT_ID=@MIT_ID
											 )    
									BEGIN    
									/* Date of incidence Country wise*/     
									/* Tax Not found for @Country_ID select company level on date of incidence */        
										IF(ISNULL(LEN(@DateOfTermination),0)<=0)   
										BEGIN             
											print 'Seprated employee in Date of incidence '    
											INSERT INTO #TempTax_Details
											(		
													TAX_HEADING,
													TAX_RATE,
													RESIDENT_STATUS,
													TAX_AMOUNT,
													Country,
													[STATE],
													BASISOFTAXATION,
													FMV,
													TOTAL_PERK_VALUE,
													COUNTRY_ID, 
													MIT_ID ,
													EmployeeID ,
													GRANTOPTIONID,
													VESTING_DATE,
													GRANT_DATE ,
													GRANTLEGSERIALNO,
													FROM_DATE,
													TO_DATE,
													TEMP_EXERCISEID,
													TAXCALCULATION_BASEDON
											)    
											SELECT  MTRT.TAX_HEADING,
													dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_LIVE_EMPLOYEE) AS TAX_RATE, 
													'' AS RESIDENT_STATUS,    
													dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_LIVE_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100),'TAXAMT')AS TAX_AMOUNT,    
													CM.CountryName AS Country, 
													NULL AS [STATE],
													'Country Level' AS BASISOFTAXATION,    
													dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV,
													((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
													CM.ID as 'COUNTRY_ID',    
													@MIT_ID,
													@EmployeeID,
													@GRANTOPTION_ID,
													@VESTING_DATE ,
													@GRANT_DATE,
													@GRANTLEGSERIAL_NO,
													@FROM_DATE_TAX,
													@TO_DATE_TAX,
													@TEMP_EXERCISEID ,
													TAXCALCULATION_BASEDON   
    
											FROM    TAX_RATE_SETTING_CONFIG TR     
													INNER JOIN  COMPANY_INSTRUMENT_MAPPING CIM ON TR.MIT_ID=CIM.MIT_ID     
													INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID=TR.Tax_Head_Id    
													INNER JOIN  COUNTRYMASTER CM ON CM.ID=TR.COUNTRY_ID    
													INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID    
											WHERE   TR.MIT_ID = @MIT_ID 
													AND ISNULL(TRM.Employee_ID,'') = @EmployeeID 
													AND CM.ID=@Country_ID    
    
										END             
										ELSE    
										BEGIN     
											print 'Active employee in Date of incidence '    
											INSERT INTO #TempTax_Details
											(
													TAX_HEADING,
													TAX_RATE,
													RESIDENT_STATUS,
													TAX_AMOUNT,
													Country,
													[STATE],
													BASISOFTAXATION,
													FMV,
													TOTAL_PERK_VALUE,
													COUNTRY_ID, 
													MIT_ID ,
													EmployeeID ,
													GRANTOPTIONID,
													VESTING_DATE,
													GRANT_DATE ,
													GRANTLEGSERIALNO,
													FROM_DATE,
													TO_DATE,
													TEMP_EXERCISEID,
													TAXCALCULATION_BASEDON
											)    
											SELECT  MTRT.TAX_HEADING,
													dbo.FN_PQ_TAX_ROUNDING(TR.TAXRATE_SEPRATED_EMPLOYEE) AS TAX_RATE ,
													'' AS RESIDENT_STATUS,    
													dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100),'TAXAMT')AS TAX_AMOUNT,  
  
													CM.CountryName AS Country, 
													NULL AS [STATE],            
													'Country Level' AS BASISOFTAXATION,
													dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV,     
													((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
													CM.ID as COUNTRY_ID,    
													@MIT_ID,
													@EmployeeID,
													@GRANTOPTION_ID,
													@VESTING_DATE ,
													@GRANT_DATE,
													@GRANTLEGSERIAL_NO,
													@FROM_DATE_TAX,
													@TO_DATE_TAX,
													@TEMP_EXERCISEID,
													TAXCALCULATION_BASEDON    
											FROM    TAX_RATE_SETTING_CONFIG TR     
													INNER JOIN  COMPANY_INSTRUMENT_MAPPING CIM ON TR.MIT_ID=CIM.MIT_ID     
													INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID=TR.Tax_Head_Id    
													INNER JOIN  COUNTRYMASTER CM ON CM.ID=TR.COUNTRY_ID    
													INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID    
											--INNER JOIN EmployeeMaster EM  ON EM.EmployeeID= TRM.EMPLOYEE_ID                  
											WHERE   TR.MIT_ID= @MIT_ID 
													AND ISNULL(TRM.Employee_ID,'') = @EmployeeID 
													AND CM.ID=@Country_ID    
										END         
          
									END    
									ELSE    
									BEGIN    
									/* Date of incidence company Level if*/    
									print @IS_COMPANY_LEVEL
									print @DateOfTermination
									IF(@IS_COMPANY_LEVEL=0)    
									BEGIN          
										IF(ISNULL(LEN(@DateOfTermination),0)<=0)    
										BEGIN
										
										print 'ss5'
											INSERT INTO #TempTax_Details
											(
													TAX_HEADING,
													TAX_RATE,
													RESIDENT_STATUS,
													TAX_AMOUNT,
													Country,
													[STATE],
													BASISOFTAXATION,
													FMV,
													TOTAL_PERK_VALUE,
													COUNTRY_ID, 
													MIT_ID ,
													EmployeeID ,
													GRANTOPTIONID,
													GRANTLEGSERIALNO,
													VESTING_DATE,
													GRANT_DATE,
													FROM_DATE,
													TO_DATE,
													TEMP_EXERCISEID,
													TAXCALCULATION_BASEDON
												
											)    
											SELECT  MTRT.TAX_HEADING,
													dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_LIVE_EMPLOYEE) AS TAX_RATE, 
													'' AS RESIDENT_STATUS,    
													dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_LIVE_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100),'TAXAMT')AS TAX_AMOUNT,    
													'' AS Country, 
													'' AS [STATE],
													'Company Level' AS BASISOFTAXATION,    
													dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV,
													((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
													0,
													@MIT_ID,
													@EmployeeID,
													@GRANTOPTION_ID,
													@GRANTLEGSERIAL_NO,
													@VESTING_DATE,
													@GRANT_DATE,
													NULL,
													NULL,
													@TEMP_EXERCISEID,
													TAXCALCULATION_BASEDON     
											FROM	TAX_RATE_SETTING_CONFIG TR     
											INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID   
											INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID  
											INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id        
											WHERE   TR.MIT_ID = @MIT_ID 
													--AND ISNULL(TRM.Employee_ID,'') = @EmployeeID  
													AND ISNULL(TR.RESIDENTIAL_ID,0) =0 
													AND ISNULL(TR.COUNTRY_ID,0)=0      
                
										END             
										ELSE    
										BEGIN
										print 'ss5'
											INSERT INTO #TempTax_Details
											(
													TAX_HEADING,
													TAX_RATE,
													RESIDENT_STATUS,
													TAX_AMOUNT,
													Country,
													[STATE],
													BASISOFTAXATION,
													FMV,TOTAL_PERK_VALUE,
													COUNTRY_ID,
													GRANTLEGSERIALNO,
													VESTING_DATE,
													GRANT_DATE,
													FROM_DATE,
													TO_DATE,
													TEMP_EXERCISEID,
													TAXCALCULATION_BASEDON
											)    
											SELECT  MTRT.TAX_HEADING,
													dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_SEPRATED_EMPLOYEE) AS TAX_RATE ,
													'' AS RESIDENT_STATUS,    
													dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100),'TAXAMT')AS TAX_AMOUNT,  
  
													'' AS Country, 
													'' AS [STATE], 
													'Company Level' AS BASISOFTAXATION,
													dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV,
													((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
													0,
													@GRANTLEGSERIAL_NO,
													@VESTING_DATE,
													@GRANT_DATE,
													NULL,
													NULL,
													@TEMP_EXERCISEID,
													TAXCALCULATION_BASEDON     
											FROM    TAX_RATE_SETTING_CONFIG TR     
											INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID    
											INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID 
											INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id      
											WHERE   TR.MIT_ID= @MIT_ID 
													--AND ISNULL(TRM.Employee_ID,'') = @EmployeeID 
													AND ISNULL(TR.RESIDENTIAL_ID,0) =0 
													AND ISNULL(TR.COUNTRY_ID,0)=0              
										END    
										SET @IS_COMPANY_LEVEL=1              
									END     
									/*End date of incidence company level */     
									END    
         
								END       
    
						END --End Country ID >0    
						ELSE    
						BEGIN    
							/* Company Level  */    
							/* Mobility not done*/      
								IF(ISNULL(LEN(@DateOfTermination),0)<=0)    
								BEGIN    
								print 'ss7'
								print @Total_Perk_Value
								print @stock_value
									INSERT INTO #TempTax_Details
									(
											TAX_HEADING,
											TAX_RATE,
											RESIDENT_STATUS,
											TAX_AMOUNT,
											Country,
											[STATE],
											BASISOFTAXATION,
											FMV,
											TOTAL_PERK_VALUE,
											COUNTRY_ID, 
											MIT_ID ,
											EmployeeID ,
											GRANTOPTIONID,
											VESTING_DATE,
											GRANT_DATE,
											GRANTLEGSERIALNO,
											FROM_DATE,
											TO_DATE,
											TEMP_EXERCISEID,
											TAXCALCULATION_BASEDON
									)    
									SELECT  MTRT.TAX_HEADING,
											dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_LIVE_EMPLOYEE) AS TAX_RATE, 
											'' AS RESIDENT_STATUS,    
											dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_LIVE_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100),'TAXAMT')AS TAX_AMOUNT,    
											'' AS COUNTRY, 
											NULL AS [STATE],
											'Company Level' AS BASISOFTAXATION, 
											dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV,     
											((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
											0 AS COUNTRY_ID,
											@MIT_ID,
											@EmployeeID,
											@GRANTOPTION_ID,
											@VESTING_DATE,
											@GRANT_DATE, 
											@GRANTLEGSERIAL_NO,
											NULL,
											NULL,
											@TEMP_EXERCISEID,
											TAXCALCULATION_BASEDON     
                     
									FROM	TAX_RATE_SETTING_CONFIG TR     
									INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID    
									INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID 
									INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id                
									WHERE	TR.MIT_ID= @MIT_ID 
											AND ISNULL(TRM.Employee_ID,'') = ''
											AND ISNULL(TR.RESIDENTIAL_ID,0) = 0 
											AND ISNULL(TR.COUNTRY_ID,0)=0    
								END    
								ELSE    
								BEGIN    
            print 'ss6'
									INSERT INTO #TempTax_Details
									(
											TAX_HEADING,
											TAX_RATE,
											RESIDENT_STATUS,
											TAX_AMOUNT,
											Country,
											[STATE],
											BASISOFTAXATION,
											FMV,
											TOTAL_PERK_VALUE,
											COUNTRY_ID, 
											MIT_ID ,
											EmployeeID ,
											GRANTOPTIONID,
											VESTING_DATE,
											GRANT_DATE, 
											GRANTLEGSERIALNO,
											FROM_DATE,
											TO_DATE,
											TEMP_EXERCISEID,
											TAXCALCULATION_BASEDON
									)    
									SELECT  MTRT.TAX_HEADING,
											dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_SEPRATED_EMPLOYEE) AS TAX_RATE, 
											'' AS RESIDENT_STATUS,    
											dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100),'TAXAMT')AS TAX_AMOUNT,    

											'' AS COUNTRY, 
											'' AS [STATE],'Company Level' AS BASISOFTAXATION, 
											dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV,     
											((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
											0 AS COUNTRY_ID,
											@MIT_ID,
											@EmployeeID,
											@GRANTOPTION_ID,
											@VESTING_DATE,
											@GRANT_DATE, 
											@GRANTLEGSERIAL_NO,
											NULL,
											NULL,
											@TEMP_EXERCISEID,
											TAXCALCULATION_BASEDON     
                           
									FROM    TAX_RATE_SETTING_CONFIG TR     
									INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID  
									INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID      
									INNER JOIN  MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id            
									WHERE	TR.MIT_ID= @MIT_ID 
											AND ISNULL(TRM.Employee_ID,'') = ''
											AND ISNULL(TR.RESIDENTIAL_ID,0) = 0 
											AND ISNULL(TR.COUNTRY_ID,0)=0    
								END    
						END    
    
						SET @MINVALUE=@MINVALUE+1    
    
					END    
        
				-- End Loof for multiple countries    
               
				END  
					-- check exception For Tax Rate Employee is  Country and state --   
				ELSE IF(@EXCEPT_FOR_TAXRATE_EMPLOYEE='CS')  
				BEGIN 
					Print 'COUNTRY AND STATE '
				END 
				-- Check For employee Country and state Level --         
				ELSE IF(@EXCEPT_FOR_TAXRATE_EMPLOYEE='ECS')  
				BEGIN  
					Print 'EMPLOYEE COUNTRY AND STATE '
				END     
				-- Check For employee Company Level --         
				ELSE IF(@EXCEPT_FOR_TAXRATE_EMPLOYEE='E')  
				BEGIN       
				/* Tax rate calculation default setting company level*/    
							IF (
									(	SELECT Count(TR.TRSC_ID )  
										FROM TAX_RATE_SETTING_CONFIG AS TR 
										INNER JOIN TAX_RATE_EMP_MAP AS TRM ON TR.TRSC_ID= TRM.TRSC_ID   
										WHERE ISNULL(TRM.employee_id,'') = @EMPLOYEEID 
										AND  TR.MIT_ID= @MIT_ID 
										AND ISNULL(TR.RESIDENTIAL_ID,0) = 0 
										AND ISNULL(TR.COUNTRY_ID,0)=0   
									) > 0
								)
							BEGIN
								IF(ISNULL(LEN(@DateOfTermination),0)<=0)    
								BEGIN    
								/*For LIVE Employee*/
   
										INSERT INTO #TempTax_Details
										(
												TAX_HEADING,
												TAX_RATE,
												RESIDENT_STATUS,
												Country,
												[STATE],
												TAX_AMOUNT,
												BASISOFTAXATION,
												FMV,
												TOTAL_PERK_VALUE,
												COUNTRY_ID, 
												MIT_ID ,
												EmployeeID ,
												GRANTOPTIONID,
												VESTING_DATE,
												GRANT_DATE,
												GRANTLEGSERIALNO,
												FROM_DATE,
												TO_DATE,
												TEMP_EXERCISEID,
												TAXCALCULATION_BASEDON
										)    
										SELECT  CASE WHEN @Total_Perk_Value = '-990099' THEN 'NA' ELSE
					                          MTRT.TAX_HEADING END, 
												dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_LIVE_EMPLOYEE) AS TAX_RATE, 
												'' AS RESIDENT_STATUS,    
												'' AS COUNTRY, 
												NULL AS [STATE],    
												 
												CASE WHEN @Total_Perk_Value = '-990099' THEN 0 ELSE
						                       	dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_LIVE_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100), 'TAXAMT')
							                   END AS TAX_AMOUNT , 

													CASE WHEN @Total_Perk_Value = '-990099' THEN  CASE WHEN(@IsTaxApplicable = '') THEN 'NA' ELSE @IsTaxApplicable END  ELSE
							                         'Employee Level' END AS BASISOFTAXATION, 
												dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV,     
												((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
												0 AS COUNTRY_ID,    
												@MIT_ID,
												@EmployeeID,
												@GRANTOPTION_ID,
												@VESTING_DATE,
												@GRANT_DATE,
												@GRANTLEGSERIAL_NO,
												NULL,
												NULL,
												@TEMP_EXERCISEID ,
												TAXCALCULATION_BASEDON    
                  
										FROM    TAX_RATE_SETTING_CONFIG TR  
									   
												INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID 
												INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID   
												INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id 

										WHERE   TR.MIT_ID= @MIT_ID 
												AND ISNULL(TRM.Employee_ID,'') = @EMPLOYEEID 
												AND ISNULL(TR.RESIDENTIAL_ID,0) = 0 
												AND ISNULL(TR.COUNTRY_ID,0)=0    

								END
								ELSE
								BEGIN
       print 'ss4'
										INSERT INTO #TempTax_Details
										(
												TAX_HEADING,
												TAX_RATE,
												RESIDENT_STATUS,
												Country,
												[STATE],
												TAX_AMOUNT,
												BASISOFTAXATION,
												FMV,
												TOTAL_PERK_VALUE,
												COUNTRY_ID, 
												MIT_ID ,
												EmployeeID ,
												GRANTOPTIONID,
												VESTING_DATE,
												GRANT_DATE,
												GRANTLEGSERIALNO,
												FROM_DATE,
												TO_DATE,
												TEMP_EXERCISEID,
												TAXCALCULATION_BASEDON
										)    
										SELECT CASE WHEN @Total_Perk_Value = '-990099' THEN 'NA' ELSE
					MTRT.TAX_HEADING END, 
												dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_SEPRATED_EMPLOYEE) AS TAX_RATE, 
												'' AS RESIDENT_STATUS,    
												'' AS COUNTRY, NULL AS [STATE],    
												CASE WHEN @Total_Perk_Value = '-990099' THEN 0 ELSE
							dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100), 'TAXAMT')
							END AS TAX_AMOUNT ,     
												CASE WHEN @Total_Perk_Value = '-990099' THEN  CASE WHEN(@IsTaxApplicable = '') THEN 'NA' ELSE @IsTaxApplicable END  ELSE
							'Employee Level' END AS BASISOFTAXATION, 
												dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV,     
												((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
												0 AS COUNTRY_ID,    
												@MIT_ID,
												@EmployeeID,
												@GRANTOPTION_ID,
												@VESTING_DATE,
												@GRANT_DATE,
												@GRANTLEGSERIAL_NO,
												NULL,
												NULL,
												@TEMP_EXERCISEID ,
												TAXCALCULATION_BASEDON    
                  
										FROM    TAX_RATE_SETTING_CONFIG TR
									     
												INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID 
												INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID   
												INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id
                    
										WHERE   TR.MIT_ID= @MIT_ID 
												AND ISNULL(TRM.Employee_ID,'') = @EMPLOYEEID 
												AND ISNULL(TR.RESIDENTIAL_ID,0) = 0 
												AND ISNULL(TR.COUNTRY_ID,0)=0    

								END
							END    
							ELSE    
							BEGIN    
							/*print 'Company Level data test ELSE'*/    
								IF(ISNULL(LEN(@DateOfTermination),0)<=0)
								BEGIN   
							print'S1'
										INSERT INTO #TempTax_Details
										(
												TAX_HEADING,
												TAX_RATE,
												RESIDENT_STATUS,
												Country,
												[STATE],
												TAX_AMOUNT,
												BASISOFTAXATION,
												FMV,
												TOTAL_PERK_VALUE,
												COUNTRY_ID, 
												MIT_ID ,
												EmployeeID ,
												GRANTOPTIONID,
												VESTING_DATE,
												GRANT_DATE,
												GRANTLEGSERIALNO,
												FROM_DATE,
												TO_DATE,
												TEMP_EXERCISEID,
												TAXCALCULATION_BASEDON
										)    
										SELECT  CASE WHEN @Total_Perk_Value = '-990099' THEN 'NA' ELSE
					                            MTRT.TAX_HEADING END,
												dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_LIVE_EMPLOYEE) AS TAX_RATE, 
												'' AS RESIDENT_STATUS,    
												'' AS COUNTRY, '' AS [STATE],    
									              CASE WHEN @Total_Perk_Value = '-990099' THEN 0 ELSE
							                      dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100), 'TAXAMT'
)
							                      END AS TAX_AMOUNT ,
											
												CASE WHEN @Total_Perk_Value = '-990099' THEN  CASE WHEN(@IsTaxApplicable = '') THEN 'NA' ELSE @IsTaxApplicable END  ELSE
							                   'Company Level' END AS BASISOFTAXATION, 
												dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV,     
												((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
												0 AS COUNTRY_ID,
												@MIT_ID,
												@EmployeeID,
												@GRANTOPTION_ID,
												@VESTING_DATE,
												@GRANT_DATE,
												@GRANTLEGSERIAL_NO,
												NULL,
												NULL,
												@TEMP_EXERCISEID ,
												TAXCALCULATION_BASEDON 
											   
										FROM	TAX_RATE_SETTING_CONFIG TR     

												INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID  
												INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID   
												INNER JOIN  MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id
										WHERE   TR.MIT_ID= @MIT_ID 
												AND ISNULL(TRM.Employee_ID,'') = ''  
												AND ISNULL(TR.RESIDENTIAL_ID,0) = 0 
												AND ISNULL(TR.COUNTRY_ID,0)=0    

								END
								ELSE
								BEGIN
										print 'ss3'
										INSERT INTO #TempTax_Details
										(
												TAX_HEADING,
												TAX_RATE,
												RESIDENT_STATUS,
												Country,
												[STATE],
												TAX_AMOUNT,
												BASISOFTAXATION,
												FMV,
												TOTAL_PERK_VALUE,
												COUNTRY_ID, 
												MIT_ID ,
												EmployeeID ,
												GRANTOPTIONID,
												VESTING_DATE,
												GRANT_DATE,
												GRANTLEGSERIALNO,
												FROM_DATE,
												TO_DATE,
												TEMP_EXERCISEID,
												TAXCALCULATION_BASEDON
										)    
										SELECT  MTRT.TAX_HEADING,
												dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_SEPRATED_EMPLOYEE) AS TAX_RATE, 
												'' AS RESIDENT_STATUS,    
												'' AS COUNTRY, 
												'' AS [STATE],    
												dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100),'TAXAMT')AS TAX_AMOUNT,   
      
												'Company Level' AS BASISOFTAXATION, 
												dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV,     
												((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
												0 AS COUNTRY_ID,    
												@MIT_ID,
												@EmployeeID,
												@GRANTOPTION_ID,
												@VESTING_DATE,
												@GRANT_DATE,
												@GRANTLEGSERIAL_NO,
												NULL,
												NULL,
												@TEMP_EXERCISEID ,
												TAXCALCULATION_BASEDON
											    
										FROM	TAX_RATE_SETTING_CONFIG TR  
									   
												INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID  
												INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID   
												INNER JOIN  MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id

										WHERE   TR.MIT_ID= @MIT_ID 
												AND ISNULL(TRM.Employee_ID,'') = ''  
												AND ISNULL(TR.RESIDENTIAL_ID,0) = 0 
												AND ISNULL(TR.COUNTRY_ID,0)=0    

								END
						END   
				END        
	  END
   
  END          
  ELSE    
  BEGIN       
    /* Tax rate calculation default setting company level*/    
		IF(ISNULL(LEN(@DateOfTermination),0)<=0)    
		BEGIN    
     Print'S2'
			INSERT INTO #TempTax_Details
			(
					TAX_HEADING,
					TAX_RATE,
					RESIDENT_STATUS,
					Country,
					[STATE],
					TAX_AMOUNT,
					BASISOFTAXATION,
					FMV,
					TOTAL_PERK_VALUE,
					COUNTRY_ID, 
					MIT_ID ,
					EmployeeID ,
					GRANTOPTIONID,
					VESTING_DATE,
					GRANT_DATE,
					GRANTLEGSERIALNO,
					FROM_DATE,
					TO_DATE,
					TEMP_EXERCISEID,
					TAXCALCULATION_BASEDON
			)    
			SELECT  	CASE WHEN @Total_Perk_Value = '-990099' THEN 'NA' ELSE
					MTRT.TAX_HEADING END, 
					dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_LIVE_EMPLOYEE) AS TAX_RATE, 
					'' AS RESIDENT_STATUS,    
					'' AS COUNTRY,
					NULL AS [STATE],    
					--dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_LIVE_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100),'TAXAMT')AS TAX_AMOUNT,    
					CASE WHEN @Total_Perk_Value = '-990099' THEN 0 ELSE
							dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_LIVE_EMPLOYEE
							* (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100), 'TAXAMT')
							END AS TAX_AMOUNT , 
					CASE WHEN @Total_Perk_Value = '-990099' THEN  CASE WHEN(@IsTaxApplicable = '') THEN 'NA' ELSE @IsTaxApplicable END  ELSE
							'Company Level' END AS BASISOFTAXATION, 
					dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV,     
					((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
					0 AS COUNTRY_ID    
					,@MIT_ID,
					@EmployeeID,
					@GRANTOPTION_ID,
					@VESTING_DATE,
					@GRANT_DATE,
					@GRANTLEGSERIAL_NO,
					NULL,
					NULL,
					@TEMP_EXERCISEID ,
					TAXCALCULATION_BASEDON    
                  
			FROM	TAX_RATE_SETTING_CONFIG TR     

					INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID    
					INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID
					INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id                    
			WHERE	TR.MIT_ID= @MIT_ID 
					AND ISNULL(TRM.Employee_ID,'') = '' 
					AND ISNULL(TR.RESIDENTIAL_ID,0) = 0 
					AND ISNULL(TR.COUNTRY_ID,0)=0    
		END    
            
		ELSE   
		BEGIN   
			/*print 'Company Level data test ELSE'*/    
			 Print'S3'
			INSERT INTO #TempTax_Details
			(
					TAX_HEADING,
					TAX_RATE,RESIDENT_STATUS,
					Country,[STATE],
					TAX_AMOUNT,
					BASISOFTAXATION,
					FMV,
					TOTAL_PERK_VALUE,
					COUNTRY_ID, MIT_ID ,
					EmployeeID ,
					GRANTOPTIONID,
					VESTING_DATE,
					GRANT_DATE,
					GRANTLEGSERIALNO,
					FROM_DATE,
					TO_DATE,
					TEMP_EXERCISEID,
					TAXCALCULATION_BASEDON
			)    
			SELECT  	CASE WHEN @Total_Perk_Value = '-990099' THEN 'NA' ELSE
					MTRT.TAX_HEADING END, 
					dbo.FN_PQ_TAX_ROUNDING(TRM.TAXRATE_SEPRATED_EMPLOYEE) AS TAX_RATE,
					'' AS RESIDENT_STATUS,    
					'' AS COUNTRY, '' AS [STATE],    
					--dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100),'TAXAMT')AS TAX_AMOUNT,
					CASE WHEN @Total_Perk_Value = '-990099' THEN 0 ELSE
							dbo.FN_GET_COMPANY_DECIMAL_SETTING(((TRM.TAXRATE_SEPRATED_EMPLOYEE * (CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END ))/100), 'TAXAMT')
							END AS TAX_AMOUNT , 
					CASE WHEN @Total_Perk_Value = '-990099' THEN  CASE WHEN(@IsTaxApplicable = '') THEN 'NA' ELSE @IsTaxApplicable END  ELSE
							'Company Level' END AS BASISOFTAXATION, 
					dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV,     
					((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
					0 AS COUNTRY_ID,    
					@MIT_ID,
					@EmployeeID,
					@GRANTOPTION_ID,
					@VESTING_DATE,
					@GRANT_DATE,
					@GRANTLEGSERIAL_NO,
					NULL,
					NULL,
					@TEMP_EXERCISEID,
					TAXCALCULATION_BASEDON    
			FROM            
					TAX_RATE_SETTING_CONFIG TR     
					INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID 
					INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID   
					INNER JOIN  MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id         
			WHERE   TR.MIT_ID= @MIT_ID 
					AND ISNULL(TRM.Employee_ID,'') = '' 
					AND ISNULL(TR.RESIDENTIAL_ID,0) = 0 
					AND ISNULL(TR.COUNTRY_ID,0)=0    
		END    
   --END    
  END      
      
		SET @MN_VALUE = @MN_VALUE + 1     
         
  END    
  else
  begin
  print '4'
 print @Total_Perk_Value

  INSERT INTO #TempTax_Details    
						(    
							TAX_HEADING, 
							TAX_RATE, 
							RESIDENT_STATUS, 
							TAX_AMOUNT, 
							Country, 
							[STATE], 
							BASISOFTAXATION, 
							FMV, 
							TOTAL_PERK_VALUE, 
							RESIDENT_ID,    
							COUNTRY_ID, 
							MIT_ID,
							EmployeeID, 
							GRANTOPTIONID, 
							VESTING_DATE,
							GRANT_DATE,
							GRANTLEGSERIALNO,
							TAXCALCULATION_BASEDON ,
							TEMP_EXERCISEID   
							
						)    
						SELECT    
							'NA', 
							0, 
							'',    
							-990099
							
						,   
							
							NULL AS Country, 
							NULL AS [STATE],
							 CASE WHEN( ISNULL(@IsTaxApplicable,'')= '') THEN 'NA' ELSE @IsTaxApplicable END,    
							dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV, 
							 
							((CASE WHEN  (ISNULL(TAXCALCULATION_BASEDON,'')='' OR  TAXCALCULATION_BASEDON = 'rdoPerqusite') THEN @Total_Perk_Value ELSE @STOCK_VALUE END )) AS TOTAL_PERK_VALUE,
							0, 
							0 AS COUNTRY_ID, 
							@MIT_ID, 
							@EmployeeID,     
							@GRANTOPTION_ID,
							@VESTING_DATE,
							@GRANT_DATE,
							@GRANTLEGSERIAL_NO,
							TAXCALCULATION_BASEDON,
							@TEMP_EXERCISEID 
							
						FROM    COMPANY_INSTRUMENT_MAPPING
						--	--TAX_RATE_SETTING_CONFIG TR     
						--	INNER JOIN COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID = CM.MIT_ID  
						--	--INNER JOIN TAX_RATE_EMP_MAP TRM ON TR.TRSC_ID=TRM.TRSC_ID   
						--	--INNER JOIN MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID=TR.Tax_Head_Id 
						--	--INNER JOIN RESIDENTIALTYPE RT ON RT.ID=TR.RESIDENTIAL_ID--, EmployeeMaster EM                  
						WHERE    
						MIT_ID = @MIT_ID 
							--AND ISNULL(TRM.Employee_ID,'')='' 
							--AND ISNULL(TR.RESIDENTIAL_ID,0)=@Resident_ID 
							--AND ISNULL(TR.COUNTRY_ID,0)=0    

		SET @MN_VALUE = @MN_VALUE + 1     

  end
	
	
 END 
     
 -- Final Out put    
 IF EXISTS (SELECT * FROM SYS.tables WHERE name = 'TEMP_GET_TAXDETAILS')    
 BEGIN    
  DROP TABLE TEMP_GET_TAXDETAILS    
 END    
    
		SELECT    
				TAX_HEADING,
				TAX_RATE,
				RESIDENT_STATUS, 
				TAX_AMOUNT, 
				Country, 
				[STATE], 
				BASISOFTAXATION, 
				FMV, 
				TOTAL_PERK_VALUE,
				RESIDENT_ID,     
				COUNTRY_ID, 
				MIT_ID, 
				EmployeeID, 
				GRANTOPTIONID, 
				VESTING_DATE,
				GRANT_DATE,
				GRANTLEGSERIALNO,
				FROM_DATE,
				TO_DATE,
				TEMP_EXERCISEID,
				TAXCALCULATION_BASEDON   
				 
		INTO	TEMP_GET_TAXDETAILS     
		FROM     
				#TempTax_Details    
    
		SELECT     
				TAX_HEADING, 
				TAX_RATE, 
				RESIDENT_STATUS, 
				TAX_AMOUNT, 
				Country, 
				[STATE], 
				BASISOFTAXATION, 
				FMV, 
				TOTAL_PERK_VALUE,
				RESIDENT_ID,     
				COUNTRY_ID, 
				MIT_ID, 
				EmployeeID, 
				GRANTOPTIONID, 
				VESTING_DATE ,
				GRANT_DATE,
				GRANTLEGSERIALNO,
				FROM_DATE,
				TO_DATE,
				TEMP_EXERCISEID,
				TAXCALCULATION_BASEDON    
		FROM     
				#TempTax_Details    
    
DROP TABLE #TempMobility_Tracking    
     
 SET NOCOUNT OFF;    
END
