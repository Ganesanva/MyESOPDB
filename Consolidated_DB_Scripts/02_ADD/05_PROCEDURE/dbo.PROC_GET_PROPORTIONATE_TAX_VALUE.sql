/****** Object:  StoredProcedure [dbo].[PROC_GET_PROPORTIONATE_TAX_VALUE]    Script Date: 7/8/2022 3:00:41 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_PROPORTIONATE_TAX_VALUE]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_PROPORTIONATE_TAX_VALUE]    Script Date: 7/8/2022 3:00:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_PROPORTIONATE_TAX_VALUE]
		
 @INSTRUMENT_IDs BIGINT = NULL ,   
 @PERQ_DETAILS1  dbo.TYPE_PROP_VALUE_AUTO_EXE READONLY,  
 @ISTEMPLATE INT = NULL  

AS   
BEGIN  
 
 --SET NOCOUNT ON;   
 DECLARE  @ISPERQUSITE_VAL TINYINT,@ISROPORTIONATE_VAL  TINYINT,@EXCEPTFOR_PERQUISITE NVARCHAR(50)  
       ,@EXCEPTFOR_PROPORTIONATE VARCHAR(50),@MN_VALUE INT,@MX_VALUE INT,@INSTRUMENT_ID BIGINT ,@EMPLOYEE_ID  VARCHAR(50),@GRANTOPTIONID VARCHAR(50) ,@GRANTDATE  VARCHAR(200) ,@VESTINGDATE VARCHAR(200), @EXERCISE_DATE  DATETIME    
       ,@EXERCISEPRICE NUMERIC(18,4),@OPTIONVESTED  NUMERIC(18,4),@FACEVAUE NUMERIC(18,4),@PRAPORTIONATE_FORMULA NVARCHAR(1000),  
        @OPTION_VESTED NUMERIC(18,4) ,@EXCEPT_FOR_PROPORT_VAL TINYINT,@EXCEPT_FOR_PERQ_VAL TINYINT,@PERQ_PRICE INT,@PERQ_FORMULA NVARCHAR(500),@OPTIONEXERCISED  NUMERIC(18,4)  
       ,@SQL NVARCHAR(MAX),@result FLOAT,@EXERCISEDATE DATETIME,@EMPLOYEE_STATUS INT ,@EMPLOYEE_COUNTRY_ID INT,@EVENTOF_INCIDENCE BIGINT  
             ,@COUNTRY_ID  VARCHAR(100),@CODE_NAME NVARCHAR(500),@INCIDENCEDATE VARCHAR(50),@CHECKCOUNT INT,@FORMULA_DESCRIPTION NVARCHAR(1000)  
             ,@PERQ_VALUE NUMERIC (18,4),@Finalresult FLOAT ,@temp_days BIGINT, @TEMP_DAYSLENGTH VARCHAR(500), @TEMP_FORMULA NVARCHAR(1000), @FINAL_FORMULA NVARCHAR(1000)  
          ,@FMV_VALUE NUMERIC(18,9),@GRANTED_OPTIONS NUMERIC(18,9),@COUNTRY_CATEGORY VARCHAR(500),@FROM_DATE VARCHAR(200),@TO_DATE VARCHAR(200),@SETVALUE VARCHAR(500),@SETVALUE_BEFORE_OPERATOR VARCHAR(500),@SETVALUE_AFTER_OPERATOR VARCHAR(500),  
          @CMNVAL INT,@CMXVAL INT ,@CAL_COUNTRY_DAYS FLOAT,@TEMPCOUNT INT,@GRANTLEGSERIALNO BIGINT,@TEMP_EXERCISEID BIGINT ,@STOCK_VALUE NUMERIC (18,9)  
 CREATE TABLE #TEMP_PRAPORTIONATE  
 (  
  ID INT IDENTITY(1,1) NOT NULL,INSTRUMENT_ID BIGINT ,EMPLOYEE_ID  VARCHAR(50),EXERCISE_PRICE NUMERIC(18,4),OPTION_VESTED NUMERIC(18,4),EXERCISE_DATE DATETIME,PERQ_PRAPORT_VALUE NUMERIC(18,4),EVENTOFINCIDENCE INT,FMV_VALUE NUMERIC(18,4),OPTION_EXERCISED NUMERIC(18,4),GRANTED_OPTIONS NUMERIC(18,4)  
  ,GRANTOPTIONID VARCHAR(50)  NUll,GRANTDATE  VARCHAR(200) NUll,VESTINGDATE VARCHAR(200) NUll,OLD_PERQ_VALUE NUMERIC(18,4) NULL   
 )   
 CREATE TABLE #TEMP_EMP_DATA    
 (  
   ID INT IDENTITY(1,1) NOT NULL,INSTRUMENT_ID BIGINT ,EMPLOYEE_ID  VARCHAR(50),EXERCISE_PRICE NUMERIC(18,4),OPTION_VESTED NUMERIC(18,4),EXERCISE_DATE DATETIME,PERQ_VALUE NUMERIC(18,4),  
   EVENTOFINCIDENCE INT,FMV_VALUE NUMERIC(18,4),OPTION_EXERCISED NUMERIC(18,4),GRANTED_OPTIONS NUMERIC(18,4)  
  ,GRANTOPTIONID VARCHAR(50)  NUll,GRANTDATE  VARCHAR(200) NUll,VESTINGDATE VARCHAR(200) NUll,GRANTLEGSERIALNO BIGINT,TEMP_EXERCISEID BIGINT,STOCK_VALUE NUMERIC(18,9)  
 )                  
 CREATE TABLE #TEMP_FMV_DETAILS  
 (    
  ID INT IDENTITY(1,1) NOT NULL,INSTRUMENT_ID BIGINT ,EMPLOYEE_ID  VARCHAR(50),GRANTOPTIONID VARCHAR(50) ,GRANTDATE  VARCHAR(200) ,VESTINGDATE VARCHAR(200), EXERCISE_DATE  DATETIME  
 )         
 CREATE TABLE #TEMP_PROP_FORMULA  
 (  
  FORMULA_DESC VARCHAR(500),EVENTOFINCIDENCE INT    
 )       
             
 CREATE TABLE #TEMP_FILTER_DAYS  
 (    
  ID INT IDENTITY(1,1) NOT NULL,COUNTRY NVARCHAR(500),FROMDATE  DATETIME,TODATE  DATETIME,TOT_DAYS BIGINT NULL,IS_LASTTRAVEL INT NULL  
 )         
   
  CREATE TABLE #GET_LAST_RECORD  
    (  
  MOVED_TO VARCHAR(500),FROM_DATE_OF_MOVEMENT DATE  
     )     
     CREATE TABLE #GET_LAST_RECORD_FILTER  
    (  
  MOVED_TO VARCHAR(500),FROM_DATE_OF_MOVEMENT DATE  
    )   
      
    CREATE TABLE #TEMP_ALL_COUNTRY  
    (  
       ID INT IDENTITY(1,1) NOT NULL ,COUNTRY_ID INT  
    )  
      
    CREATE TABLE #TEMP_ALL_COUNTRIES_DAYS  
 (    
  ID INT IDENTITY(1,1) NOT NULL,INSTRUMENT_ID BIGINT,EMPLOYEE_ID VARCHAR(50),COUNTRY_ID INT,GRANTOPTIONID VARCHAR(50),TOT_DAYS FLOAT NULL,FMV_PRICE NUMERIC(18,9),VESTINGDATE VARCHAR(200),GRANTLEGSERIALNO BIGINT ,  
  FROM_DATE DATETIME, TO_DATE DATETIME,TEMP_EXERCISEID BIGINT,STOCK_VALUE NUMERIC (18,9)    
 )      
      
  BEGIN TRY   
  INSERT INTO #TEMP_EMP_DATA     
  (   
   INSTRUMENT_ID  ,EMPLOYEE_ID ,EXERCISE_PRICE ,OPTION_VESTED ,EXERCISE_DATE, PERQ_VALUE,EVENTOFINCIDENCE,  
   FMV_VALUE,OPTION_EXERCISED ,GRANTED_OPTIONS ,GRANTOPTIONID ,GRANTDATE  ,VESTINGDATE ,GRANTLEGSERIALNO,TEMP_EXERCISEID,STOCK_VALUE   
  )    
   SELECT  INSTRUMENT_ID  ,EMPLOYEE_ID ,EXERCISE_PRICE ,OPTION_VESTED  ,EXERCISE_DATE ,PERQ_VALUE,EVENTOFINCIDENCE  
  ,FMV_VALUE,OPTION_EXERCISED ,GRANTED_OPTIONS,GRANTOPTIONID ,GRANTDATE  ,VESTINGDATE,GRANTLEGSERIALNO,TEMP_EXERCISEID,STOCK_VALUE FROM @PERQ_DETAILS1    
                     
  SELECT @INSTRUMENT_ID = INSTRUMENT_ID FROM #TEMP_EMP_DATA   
          
  SELECT @ISPERQUSITE_VAL = CAL_PERQUSITE_VAL,@ISROPORTIONATE_VAL = CAL_PROPORTIONATE_VAL,@EXCEPTFOR_PERQUISITE = EXCEPT_FOR_PERQUISITE,@EXCEPTFOR_PROPORTIONATE = EXCEPT_FOR_PROPORTIONATE  
    ,@EXCEPT_FOR_PROPORT_VAL = EXCEPT_FOR_PROPORT_VAL ,@EXCEPT_FOR_PERQ_VAL = EXCEPT_FOR_PERQ_VAL,@COUNTRY_CATEGORY = COUNTRY_CATEGORY_PROPORT  
  FROM COMPANY_INSTRUMENT_MAPPING  
  WHERE MIT_ID = @INSTRUMENT_ID  
       
  SELECT @INSTRUMENT_ID = INSTRUMENT_ID, @EMPLOYEE_ID = EMPLOYEE_ID, @EXERCISE_DATE = EXERCISE_DATE,  
  @OPTION_VESTED=OPTION_VESTED,@EVENTOF_INCIDENCE = EVENTOFINCIDENCE,@GRANTDATE = GRANTDATE , @VESTINGDATE = VESTINGDATE,  
  @PERQ_VALUE = PERQ_VALUE,@FMV_VALUE = FMV_VALUE,@GRANTED_OPTIONS = GRANTED_OPTIONS,@EXERCISEPRICE = EXERCISE_PRICE,@OPTIONEXERCISED = OPTION_EXERCISED,@GRANTOPTIONID = GRANTOPTIONID  
  ,@GRANTLEGSERIALNO = GRANTLEGSERIALNO,@TEMP_EXERCISEID = TEMP_EXERCISEID ,@STOCK_VALUE = STOCK_VALUE  
  FROM #TEMP_EMP_DATA   
  WHERE INSTRUMENT_ID = @INSTRUMENT_ID   
   
  SELECT @CODE_NAME = CODE_NAME FROM MST_COM_CODE  WHERE MCC_ID = @EVENTOF_INCIDENCE  
    
  SELECT @GRANTDATE = GRANTDATE,@VESTINGDATE = VESTINGDATE,@EXERCISEDATE = EXERCISE_DATE FROM #TEMP_FMV_DETAILS WHERE INSTRUMENT_ID = @INSTRUMENT_ID  
       
  IF(@CODE_NAME = 'Grant Date')      
   SET  @INCIDENCEDATE = @GRANTDATE                   
  ELSE IF(@CODE_NAME = 'Vesting Date')       
   SET  @INCIDENCEDATE = @VESTINGDATE      
  ELSE IF(@CODE_NAME = 'Exercise Date')      
   SET  @INCIDENCEDATE = @EXERCISE_DATE  
        
  PRINT 'EXCEPTFOR_PROPORTIONATE=' + @EXCEPTFOR_PROPORTIONATE  
  PRINT 'ISPERQUSITE_VAL=' + CONVERT(VARCHAR(10), @ISPERQUSITE_VAL)  
  PRINT 'ISROPORTIONATE_VAL=' + CONVERT(VARCHAR(10), @ISROPORTIONATE_VAL)  
  PRINT 'EXCEPTFOR_PROPORTIONATE=' + CONVERT(VARCHAR(10), @EXCEPTFOR_PROPORTIONATE)  
		
  IF(@ISPERQUSITE_VAL = 1)   
  BEGIN          
   IF(@ISROPORTIONATE_VAL = 1)  
   BEGIN        
    IF(@EXCEPT_FOR_PROPORT_VAL = 1)   
    BEGIN  
        -- EXCEPTION FOR RESIDENT    
     IF(@EXCEPTFOR_PROPORTIONATE = 'R')  
     BEGIN  
      PRINT 'R'                      
     END   
     -- EXCEPTION FOR COUNTRY      
     ELSE IF(@EXCEPTFOR_PROPORTIONATE = 'C')  
     BEGIN  
     PRINT @COUNTRY_CATEGORY  
         -- FOR DATE OF EVENT --  
         IF(UPPER(@COUNTRY_CATEGORY) != 'DOE')         
         -- FOR ALL COUNTRIES --  
         BEGIN  
             SET @TEMPCOUNT =(SELECT COUNT(SRNO) FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD WHERE EmployeeId = @EMPLOYEE_ID )         
        -- FOR SINGLE RECORD --  
           
             INSERT INTO #TEMP_ALL_COUNTRY          
          SELECT DISTINCT ID FROM  
                                (   
                                  SELECT DISTINCT CM.ID  
          FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD AS ATM  
          INNER JOIN CountryMaster AS CM ON ATM.[Moved To] = CM.CountryName  
          WHERE ATM.EmployeeId = @EMPLOYEE_ID AND UPPER(ATM.Field) = 'TAX IDENTIFIER COUNTRY'      
          UNION ALL  
          SELECT DISTINCT CM1.ID  
          FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD AS ATM  
          INNER JOIN CountryMaster AS CM1 ON ATM.CurrentDetails = CM1.CountryName  
          WHERE ATM.EmployeeId = @EMPLOYEE_ID AND UPPER(ATM.Field) = 'TAX IDENTIFIER COUNTRY'   
        )  
          AS TempOutput  
                  
       DELETE FROM #TEMP_FILTER_DAYS  
       DELETE FROM #GET_LAST_RECORD  
       DELETE FROM #GET_LAST_RECORD_FILTER  
       DELETE FROM #TEMP_ALL_COUNTRIES_DAYS  
                  
       SELECT @CMNVAL = MIN(ID),@CMXVAL = MAX(ID) FROM #TEMP_ALL_COUNTRY   
       WHILE(@CMNVAL <= @CMXVAL)  
       BEGIN    
        SET @Country_ID = (SELECT COUNTRY_ID FROM #TEMP_ALL_COUNTRY  WHERE ID = @CMNVAL)  
                                  
        DELETE FROM #TEMP_PROP_FORMULA   
        DELETE FROM #TEMP_FILTER_DAYS  
          
        -- CHECK FORMULA IS AVAILABLE FOR EXCEPTION --         
        SELECT @CHECKCOUNT = COUNT(PPC_ID) FROM PROPORTIONATE_PERQ_CONFIG AS PPC   
        INNER JOIN COMPANY_INSTRUMENT_MAP_DETAILS  AS  CIMPD  ON PPC.Country_ID = CIMPD.Country_ID   
        WHERE UPPER(CIMPD.SETTING_TYPE)='PROPORTIONATE' AND CIMPD.ACTIVE = 1 AND PPC.COUNTRY_ID = @Country_ID  
        AND ((CONVERT(DATE, PPC.APPLICABLE_FROM_DATE) <= CONVERT(DATE,@EXERCISE_DATE)) AND (CONVERT(DATE, ISNULL(PPC.APPLICABLE_TO_DATE, @EXERCISE_DATE)) >=  CONVERT(DATE,@EXERCISE_DATE)))                 
        AND PPC.MIT_ID = @INSTRUMENT_ID  
        -- IF EXCEPTION LEVEL FORMULA IS NOT  PRESENT THEN PICK COMPANY LEVEL FORMULA --  
        IF(ISNULL(@CHECKCOUNT,0) = 0)  
        BEGIN                                      
        IF((SELECT COUNT(*)  FROM COMPANY_INSTRUMENT_MAP_DETAILS AS CIMD INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM  
                                ON CIM.CIM_ID = CIMD.CIM_ID WHERE SETTING_TYPE = 'PROPORTIONATE' and ACTIVE = 1 AND CIM.MIT_ID = @INSTRUMENT_ID AND COUNTRY_ID = @COUNTRY_ID ) = 1)     
        BEGIN   
              
          SELECT @CHECKCOUNT = COUNT(PPC_ID) FROM PROPORTIONATE_PERQ_CONFIG WHERE  
          ISNULL(RESIDENTIAL_ID,0) = 0 AND ISNULL(COUNTRY_ID,0) = 0  
          AND ((CONVERT(DATE, APPLICABLE_FROM_DATE) <= CONVERT(DATE,@EXERCISE_DATE)) AND (CONVERT(DATE, ISNULL(APPLICABLE_TO_DATE, @EXERCISE_DATE)) >=  CONVERT(DATE,@EXERCISE_DATE)))   
          AND MIT_ID = @INSTRUMENT_ID                
                              
          SELECT @FORMULA_DESCRIPTION = FORMULA_DESCRIPTION FROM PROPORTIONATE_PERQ_CONFIG WHERE ISNULL(RESIDENTIAL_ID,0) = 0 AND ISNULL(COUNTRY_ID,0) = 0  
          AND ((CONVERT(DATE, APPLICABLE_FROM_DATE) <= CONVERT(DATE,@EXERCISE_DATE)) AND (CONVERT(DATE, ISNULL(APPLICABLE_TO_DATE, @EXERCISE_DATE)) >=  CONVERT(DATE,@EXERCISE_DATE)))   
          AND MIT_ID = @INSTRUMENT_ID   
                                      
          INSERT INTO #TEMP_PROP_FORMULA(FORMULA_DESC)   
          SELECT FORMULA_DESCRIPTION FROM PROPORTIONATE_PERQ_CONFIG  
          WHERE ISNULL(RESIDENTIAL_ID,0) = 0 AND ISNULL(COUNTRY_ID,0) = 0  
          AND ((CONVERT(DATE, APPLICABLE_FROM_DATE) <= CONVERT(DATE,@EXERCISE_DATE)) AND (CONVERT(DATE, ISNULL(APPLICABLE_TO_DATE, @EXERCISE_DATE)) >=  CONVERT(DATE,@EXERCISE_DATE)))   
          AND MIT_ID = @INSTRUMENT_ID                                     
          PRINT @FORMULA_DESCRIPTION  
        END  
        END  
        ELSE  
        BEGIN  
         SELECT @FORMULA_DESCRIPTION = FORMULA_DESCRIPTION  
         FROM PROPORTIONATE_PERQ_CONFIG  
         WHERE COUNTRY_ID = @Country_ID  
         AND((CONVERT(DATE, APPLICABLE_FROM_DATE) <= CONVERT(DATE,@EXERCISE_DATE)) AND (CONVERT(DATE, ISNULL(APPLICABLE_TO_DATE, @EXERCISE_DATE)) >=  CONVERT(DATE,@EXERCISE_DATE)))                 
         AND MIT_ID = @INSTRUMENT_ID   
                                      
         INSERT INTO #TEMP_PROP_FORMULA(FORMULA_DESC)   
         SELECT FORMULA_DESCRIPTION   
         FROM PROPORTIONATE_PERQ_CONFIG  AS PPC   
         INNER JOIN COMPANY_INSTRUMENT_MAP_DETAILS  AS  CIMPD  ON PPC.Country_ID = CIMPD.Country_ID   
         WHERE UPPER(CIMPD.SETTING_TYPE) = 'PROPORTIONATE'  AND CIMPD.ACTIVE = 1  
         AND PPC.COUNTRY_ID = @Country_ID AND((CONVERT(DATE, PPC.APPLICABLE_FROM_DATE) <= CONVERT(DATE,@EXERCISE_DATE)) AND (CONVERT(DATE, ISNULL(PPC.APPLICABLE_TO_DATE, @EXERCISE_DATE)) >=  CONVERT(DATE,@EXERCISE_DATE)))   
         AND MIT_ID = @INSTRUMENT_ID                        
        END  
                         
        IF(@CHECKCOUNT > 0)  
        BEGIN  
         -- GET FORMULA                   
         --DELETE FROM #TEMP_PROP_FORMULA   
         --DELETE FROM #TEMP_FILTER_DAYS  
                                         
         -- FOR LAST TRAVEL DATE FORMULA   
         IF EXISTS(SELECT FORMULA_DESC FROM #TEMP_PROP_FORMULA WHERE FORMULA_DESC  LIKE '%@Last Travel Date@%')  
         BEGIN    
             print 'p1111'                      
          SET @SETVALUE   = (SELECT STUFF(@FORMULA_DESCRIPTION, 1 , (CHARINDEX('/', @FORMULA_DESCRIPTION) - 1), ''))  
          SET @SETVALUE = (SELECT REPLACE(REPLACE(@SETVALUE, '/(', ''),')',''))  
          SET @SETVALUE_BEFORE_OPERATOR = (SELECT TOP(1)* FROM  DBO.[FN_SPLIT_STRING](@SETVALUE,'@') WHERE Item <> '' AND LEN(Item) > 1 )             
          SET @SETVALUE_AFTER_OPERATOR = (SELECT  TOP(1)Item FROM  DBO.[FN_SPLIT_STRING](@SETVALUE,'@') WHERE Item <> '' AND LEN(Item) > 1 ORDER BY ROW_NUMBER() OVER (ORDER BY (SELECT 100)) DESC)  
                             
          IF(UPPER(@SETVALUE_AFTER_OPERATOR )= 'GRANT DATE')        
           SET @FROM_DATE = @GRANTDATE        
          ELSE IF(UPPER(@SETVALUE_AFTER_OPERATOR )= 'VESTING DATE')  
           SET @FROM_DATE = @VESTINGDATE  
  
          IF(UPPER(@SETVALUE_BEFORE_OPERATOR )= 'VESTING DATE')        
           SET @TO_DATE = @VESTINGDATE        
          ELSE IF(UPPER(@SETVALUE_BEFORE_OPERATOR )= 'EXERCISE DATE')  
           SET @TO_DATE = @EXERCISE_DATE  
  
  
          INSERT INTO #GET_LAST_RECORD (MOVED_TO, FROM_DATE_OF_MOVEMENT)  
          SELECT TOP 1[Moved To], [From Date of Movement]   
          FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD    
          WHERE EmployeeId =@EMPLOYEE_ID  AND UPPER(Field) = 'TAX IDENTIFIER COUNTRY'          
          ORDER BY [From Date of Movement] DESC  
  
  
          INSERT INTO #GET_LAST_RECORD_FILTER(MOVED_TO, FROM_DATE_OF_MOVEMENT)  
          SELECT MOVED_TO, FROM_DATE_OF_MOVEMENT FROM #GET_LAST_RECORD  
          WHERE (MOVED_TO = (SELECT CountryName FROM CountryMaster  WHERE ID = @COUNTRY_ID))  
  
          INSERT INTO #TEMP_FILTER_DAYS(COUNTRY ,FROMDATE ,TODATE ,TOT_DAYS,IS_LASTTRAVEL)  
          SELECT TOP 1 COUNTRY,FROM_DATE,TO_DATE,DATEDIFF(d,FROM_DATE, TO_DATE) AS totdays, IS_LASTTRAVEL FROM   
          (  
          SELECT COUNTRY,FROM_DATE,TO_DATE,DATEDIFF(d,FROM_DATE, TO_DATE) AS totdays,  0 AS IS_LASTTRAVEL FROM   
          (  
           SELECT TOP 1   
           CASE WHEN CurrentDetails IS NULL THEN [Moved To] ELSE CurrentDetails END AS COUNTRY,  
           CASE WHEN FromDate IS NULL AND CONVERT(DATE,[From Date of Movement]) > CONVERT(DATE, @FROM_DATE) THEN CONVERT(DATE,[From Date of Movement]) ELSE             
           CASE WHEN FromDate >= CONVERT(DATE, @FROM_DATE )  THEN FromDate ELSE CONVERT(DATE,  @FROM_DATE) END END AS FROM_DATE,  
                                   
           CASE WHEN (CONVERT(DATE,[From Date of Movement]) > CONVERT(DATE,  @FROM_DATE ) AND CONVERT(DATE,[From Date of Movement]) < CONVERT(DATE,  @TO_DATE )) THEN   
           CASE WHEN FromDate IS NULL THEN CONVERT(DATE, @TO_DATE ) ELSE CONVERT(date,[From Date of Movement]) END ELSE   
           CASE WHEN CONVERT(DATE,[From Date of Movement]) > CONVERT(DATE, @TO_DATE) THEN CONVERT(DATE, @TO_DATE ) END END AS TO_DATE,@TO_DATE AS VESTINGDATE  
           FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD   
           WHERE EmployeeId = @EMPLOYEE_ID                                       
           AND   
           (  
            CurrentDetails IN  
            (SELECT CountryName FROM CountryMaster  WHERE ID = @COUNTRY_ID)  
            OR CurrentDetails IS NULL  
           )   AND (FromDate <= @TO_DATE)             
           --AND FromDate <= CONVERT(DATE, @VESTINGDATE) AND FromDate > CONVERT(DATE, @GRANTDATE)  
           ORDER BY SRNO desc  
          ) AS OUT_PUT WHERE FROM_DATE <=  CASE WHEN TO_DATE IS NULL THEN CONVERT(DATE,@TO_DATE) ELSE TO_DATE END   
          AND TO_DATE IS NOT null        
          UNION ALL  
          SELECT DISTINCT COUNTRY,FROM_DATE,TO_DATE,DATEDIFF(d,FROM_DATE,TO_DATE) AS totdays,1 AS IS_LASTTRAVEL FROM   
          (  
           SELECT   
           MOVED_TO AS COUNTRY,    
           CASE   
            WHEN (CONVERT(DATE,FROM_DATE_OF_MOVEMENT) >= CONVERT(DATE, @FROM_DATE)) AND (CONVERT(DATE,FROM_DATE_OF_MOVEMENT) <= CONVERT(DATE, @TO_DATE)) THEN FROM_DATE_OF_MOVEMENT   
            WHEN (CONVERT(DATE,FROM_DATE_OF_MOVEMENT) <= CONVERT(DATE, @FROM_DATE)) AND (CONVERT(DATE,FROM_DATE_OF_MOVEMENT) <= CONVERT(DATE,@TO_DATE)) THEN @FROM_DATE END AS FROM_DATE,                         
           CASE  
            WHEN (CONVERT(DATE,FROM_DATE_OF_MOVEMENT) >= CONVERT(DATE, @FROM_DATE)) AND (CONVERT(DATE,FROM_DATE_OF_MOVEMENT) <= CONVERT(DATE, @TO_DATE)) THEN CONVERT(DATE, @TO_DATE)   
            ELSE @TO_DATE END AS TO_DATE  
           FROM #GET_LAST_RECORD_FILTER    
           WHERE CONVERT(DATE,FROM_DATE_OF_MOVEMENT) <= CONVERT(DATE, @TO_DATE)  
          ) AS OUT_PUT WHERE FROM_DATE <= CASE WHEN TO_DATE IS NULL THEN CONVERT(DATE,@TO_DATE) ELSE TO_DATE END   
  
  
          ) AS OUT_QUERY order BY IS_LASTTRAVEL DESC  
  
            
          ------FOR DEBUGGING REMOVE COMMENT                                        
          --PRINT '  
          --INSERT INTO #GET_LAST_RECORD (MOVED_TO, FROM_DATE_OF_MOVEMENT)  
          --SELECT TOP 1  
          --[Moved To], [From Date of Movement]   
          --FROM   
          --AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD    
          --WHERE EmployeeId ='''+@EMPLOYEE_ID+'''            
          --ORDER BY [From Date of Movement] DESC  
  
  
          --INSERT INTO #GET_LAST_RECORD_FILTER(MOVED_TO, FROM_DATE_OF_MOVEMENT)  
          --SELECT MOVED_TO, FROM_DATE_OF_MOVEMENT FROM #GET_LAST_RECORD  
          --WHERE (MOVED_TO = (SELECT CountryName FROM CountryMaster  WHERE ID = '''+@COUNTRY_ID+'''))  
  
          --SELECT TOP 1 COUNTRY,FROM_DATE,TO_DATE,DATEDIFF(d,FROM_DATE, TO_DATE) AS totdays, IS_LASTTRAVEL FROM   
          --(  
          --SELECT COUNTRY,FROM_DATE,TO_DATE,DATEDIFF(d,FROM_DATE, TO_DATE) AS totdays , 0 AS IS_LASTTRAVEL FROM   
          --(  
          --SELECT TOP 1   
          --CASE WHEN CurrentDetails IS NULL THEN [Moved To] ELSE CurrentDetails END AS COUNTRY,  
          --CASE WHEN FromDate IS NULL AND CONVERT(DATE,[From Date of Movement]) > CONVERT(DATE, ''' + @FROM_DATE + ''') THEN CONVERT(DATE,[From Date of Movement]) ELSE             
          --CASE WHEN (FromDate >= CONVERT(DATE, ''' +@FROM_DATE + ''') )THEN FromDate ELSE CONVERT(DATE, ''' + @FROM_DATE+''') END END AS FROM_DATE,  
                                  
          --CASE WHEN (CONVERT(DATE,[From Date of Movement]) > CONVERT(DATE, ''' + @FROM_DATE + ''') AND CONVERT(DATE,[From Date of Movement]) < CONVERT(DATE, ''' + @TO_DATE + ''')) THEN  
          --CASE WHEN FromDate IS NULL THEN CONVERT(DATE, ''' + @TO_DATE + ''') ELSE  CONVERT(date,[From Date of Movement]) END   
          --ELSE CASE WHEN CONVERT(DATE,[From Date of Movement]) > CONVERT(DATE, ''' + @TO_DATE + ''') THEN CONVERT(DATE, ''' + @TO_DATE + ''') END END AS TO_DATE,  
          --'''+@TO_DATE+''' AS VESTINGDATE  
  
          --FROM   
          --AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD   
          --WHERE   
          --EmployeeId = '''+@EMPLOYEE_ID+'''   
  
          --AND (CurrentDetails IN  
          --(SELECT CountryName FROM CountryMaster  WHERE ID = '''+@COUNTRY_ID+''')  
          --OR CurrentDetails IS NULL)  
          --and   
          --(FromDate <= '''+@TO_DATE+''')  
          --ORDER BY SRNO desc  
          --) AS OUT_PUT WHERE FROM_DATE <=  CASE WHEN TO_DATE IS NULL THEN CONVERT(DATE,'''+@TO_DATE +''') ELSE TO_DATE END  
          --AND TO_DATE IS NOT null  
          --UNION ALL  
          --SELECT DISTINCT COUNTRY,FROM_DATE,TO_DATE,DATEDIFF(d,FROM_DATE,TO_DATE) AS totdays, 1 AS IS_LASTTRAVEL  FROM   
          --(  
          --SELECT   
          --MOVED_TO AS COUNTRY,    
          --CASE   
          --WHEN (CONVERT(DATE,FROM_DATE_OF_MOVEMENT) >= CONVERT(DATE, '''+@FROM_DATE+''')) AND  (CONVERT(DATE,FROM_DATE_OF_MOVEMENT) <= CONVERT(DATE,'''+ @TO_DATE+''')) THEN FROM_DATE_OF_MOVEMENT    
          --WHEN  (CONVERT(DATE,FROM_DATE_OF_MOVEMENT) <= CONVERT(DATE, '''+@FROM_DATE+''')) AND  (CONVERT(DATE,FROM_DATE_OF_MOVEMENT) <= CONVERT(DATE,'''+@TO_DATE+'''))    
          --THEN  '''+@FROM_DATE+'''  
          --END AS FROM_DATE,                         
  
          --CASE WHEN (CONVERT(DATE,FROM_DATE_OF_MOVEMENT) >= CONVERT(DATE, '''+@FROM_DATE+''')) AND  (CONVERT(DATE,FROM_DATE_OF_MOVEMENT) <= CONVERT(DATE, '''+@TO_DATE+''')) THEN CONVERT(DATE,'''+ @TO_DATE+''')   
          --ELSE '''+@TO_DATE+'''  
          --END AS TO_DATE  
          --FROM   
          --#GET_LAST_RECORD_FILTER    
          --WHERE   
          --CONVERT(DATE,FROM_DATE_OF_MOVEMENT) <= CONVERT(DATE, '''+@TO_DATE+''')  
          --) AS OUT_PUT WHERE FROM_DATE <= CASE WHEN TO_DATE IS NULL THEN CONVERT(DATE,'''+@TO_DATE+''') ELSE TO_DATE END   
          --) AS OUT_QUERY order BY IS_LASTTRAVEL DESC  
          --'  
         END         
         ELSE  
         BEGIN  
          PRINT 'ALL FORMULA'  
  
          SET @SETVALUE   = (SELECT STUFF(@FORMULA_DESCRIPTION, 1 , (CHARINDEX('/', @FORMULA_DESCRIPTION) - 1), ''))  
          SET @SETVALUE = (SELECT REPLACE(REPLACE(@SETVALUE, '/(', ''),')',''))  
          SET @SETVALUE_BEFORE_OPERATOR = (SELECT TOP(1)* FROM  DBO.[FN_SPLIT_STRING](@SETVALUE,'@') WHERE Item <> '' AND LEN(Item) > 1 )             
          SET @SETVALUE_AFTER_OPERATOR = (SELECT  TOP(1)Item FROM  DBO.[FN_SPLIT_STRING](@SETVALUE,'@') WHERE Item <> '' AND LEN(Item) > 1 ORDER BY ROW_NUMBER() OVER (ORDER BY (SELECT 100)) DESC)  
                                                                    
          IF(UPPER(@SETVALUE_AFTER_OPERATOR )= 'GRANT DATE')        
           SET @FROM_DATE = @GRANTDATE        
          ELSE IF(UPPER(@SETVALUE_AFTER_OPERATOR )= 'VESTING DATE')  
           SET @FROM_DATE = @VESTINGDATE  
  
          IF(UPPER(@SETVALUE_BEFORE_OPERATOR )= 'VESTING DATE')        
           SET @TO_DATE = @VESTINGDATE        
          ELSE IF(UPPER(@SETVALUE_BEFORE_OPERATOR )= 'EXERCISE DATE')  
           SET @TO_DATE = @EXERCISE_DATE  
             
                  -- FOR ALL FORMULA         
          IF(@TEMPCOUNT = 1)  
          BEGIN  
          ----FOR DEBUGGING REMOVE COMMENT           
          --PRINT  
          -- '  
          -- SELECT DISTINCT COUNTRY,FROM_DATE,TO_DATE,DATEDIFF(d,FROM_DATE,TO_DATE) AS totdays FROM   
          -- (  
          -- SELECT  CurrentDetails AS COUNTRY,    
          -- CASE WHEN FromDate IS NULL AND CONVERT(DATE,[From Date of Movement]) >= CONVERT(DATE, '''+@FROM_DATE+''') THEN CONVERT(DATE, '''+@FROM_DATE+''') ELSE                                                               
          -- CASE WHEN FromDate >= CONVERT(DATE, @FROM_DATE) THEN FromDate ELSE CONVERT(DATE,'''+@FROM_DATE+''') END END AS FROM_DATE,                                                                                                                         
       
          -- CASE WHEN ((CONVERT(DATE,[From Date of Movement]) >= CONVERT(DATE, '''+@FROM_DATE+''') AND CONVERT(DATE,[From Date of Movement]) <= CONVERT(DATE,'''+@FROM_DATE+'''))   
          -- OR CONVERT(DATE,[From Date of Movement]) <= CONVERT(DATE, '''+@FROM_DATE+''') AND CONVERT(DATE,[From Date of Movement]) <= CONVERT(DATE,'+@TO_DATE+'))   
          -- THEN              
          -- CASE WHEN FromDate IS NULL THEN (CONVERT(DATE,[From Date of Movement])) ELSE  DATEADD(d,1, DATEADD(d,-1, CONVERT(date,[From Date of Movement]))) END ELSE CASE WHEN CONVERT(DATE,[From Date of Movement]) > CONVERT(DATE, @TO_DATE) THEN CONVERT(DATE, @TO_DATE) END END AS TO_DATE  
          -- FROM   
          -- AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD    
          -- WHERE EmployeeId ='''+@EMPLOYEE_ID+'''  
          -- AND   
          -- ((ISNULL(FromDate,CONVERT(DATE, '''+@FROM_DATE+''')) <=  CASE WHEN ISNULL(FromDate,CONVERT(DATE, '''+@FROM_DATE+''')) <= CONVERT(DATE, CONVERT(DATE, '''+@FROM_DATE+''')) THEN CONVERT(DATE, CONVERT(DATE, @FROM_DATE)) ELSE ISNULL(FromDate,CONVERT(DATE, @FROM_DATE)) END)  
          -- AND ([From Date of Movement] >=  CASE WHEN [From Date of Movement] >= CONVERT(DATE, CONVERT(DATE, @TO_DATE)) THEN CONVERT(DATE, CONVERT(DATE, @TO_DATE))ELSE [From Date of Movement] END)  
          -- OR  CurrentDetails IS NULL)                 
             
          -- UNION ALL                 
             
          -- SELECT  [Moved To]  AS COUNTRY,    
          -- CASE WHEN FromDate IS NULL AND CONVERT(DATE,[From Date of Movement]) >= CONVERT(DATE,'''+@FROM_DATE+''') THEN   
          -- CONVERT(DATE, [From Date of Movement]) ELSE                                                                   
          -- CASE WHEN FromDate >= CONVERT(DATE, '''+@FROM_DATE+''') THEN FromDate ELSE CONVERT(DATE, '''+@FROM_DATE+''') END END AS FROM_DATE,                                                                                                                
                
          -- CASE WHEN( (CONVERT(DATE,[From Date of Movement]) >= CONVERT(DATE,'''+@FROM_DATE+''') AND CONVERT(DATE,[From Date of Movement]) <= CONVERT(DATE, @TO_DATE))  
          -- OR (CONVERT(DATE,[From Date of Movement]) <= CONVERT(DATE, @FROM_DATE) AND CONVERT(DATE,[From Date of Movement]) <= CONVERT(DATE, @TO_DATE))  
          -- )  
          --  THEN   
             
          -- CASE WHEN FromDate IS NULL THEN (CONVERT(DATE,@TO_DATE)) ELSE  DATEADD(d,1, DATEADD(d,-1, CONVERT(date,[From Date of Movement]))) END ELSE CASE WHEN CONVERT(DATE,[From Date of Movement]) >= CONVERT(DATE, '+@TO_DATE+') THEN CONVERT(DATE, '+@TO_DATE+') END END AS TO_DATE  
          -- FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD    
          -- WHERE EmployeeId =@EMPLOYEE_ID  
          -- AND   
          -- ( (ISNULL(FromDate,CONVERT(DATE, '''+@FROM_DATE+''')) <=  CASE WHEN ISNULL(FromDate,CONVERT(DATE, '''+@FROM_DATE+''')) <= CONVERT(DATE, CONVERT(DATE, '''+@FROM_DATE+''')) THEN CONVERT(DATE, CONVERT(DATE, '+@FROM_DATE+')) ELSE ISNULL(FromDate,CONVERT(DATE, '+@FROM_DATE+')) END)  
          -- AND ([From Date of Movement] >=  CASE WHEN [From Date of Movement] >= CONVERT(DATE, CONVERT(DATE, '+@TO_DATE+')) THEN CONVERT(DATE, CONVERT(DATE, '+@TO_DATE+'))ELSE [From Date of Movement] END)  
          -- OR CurrentDetails IS NULL)  
          -- ) AS OUT_PUT WHERE FROM_DATE <= CASE WHEN TO_DATE IS NULL THEN CONVERT(DATE,@TO_DATE) ELSE TO_DATE END     
          -- AND COUNTRY IS NOT NULL   
          -- AND COUNTRY IN  
          -- (  
          --  SELECT CountryName FROM CountryMaster  WHERE ID = '+@COUNTRY_ID+'  
          -- )           '  
           PRINT 'SINGLE RECORD'   
           INSERT INTO #TEMP_FILTER_DAYS(COUNTRY ,FROMDATE ,TODATE ,TOT_DAYS)  
           SELECT DISTINCT COUNTRY,FROM_DATE,TO_DATE,DATEDIFF(d,FROM_DATE,TO_DATE) AS totdays FROM   
           (  
           SELECT  CurrentDetails AS COUNTRY,    
           CASE WHEN FromDate IS NULL AND CONVERT(DATE,[From Date of Movement]) >= CONVERT(DATE, @FROM_DATE) THEN CONVERT(DATE, @FROM_DATE) ELSE                                                               
           CASE WHEN FromDate >= CONVERT(DATE, @FROM_DATE) THEN FromDate ELSE CONVERT(DATE, @FROM_DATE) END END AS FROM_DATE,                                                                                                                                
  
           CASE WHEN ((CONVERT(DATE,[From Date of Movement]) >= CONVERT(DATE, @FROM_DATE) AND CONVERT(DATE,[From Date of Movement]) <= CONVERT(DATE,@TO_DATE))  
           OR (CONVERT(DATE,[From Date of Movement]) <= CONVERT(DATE, @FROM_DATE) AND CONVERT(DATE,[From Date of Movement]) <= CONVERT(DATE, @TO_DATE))  
           ) THEN   
           CASE WHEN FromDate IS NULL THEN (CONVERT(DATE,[From Date of Movement])) ELSE  DATEADD(d,1, DATEADD(d,-1, CONVERT(date,[From Date of Movement]))) END ELSE CASE WHEN CONVERT(DATE,[From Date of Movement]) >= CONVERT(DATE, @TO_DATE) THEN CONVERT(DATE, @TO_DATE) END END AS TO_DATE  
           FROM   
           AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD    
           WHERE EmployeeId =@EMPLOYEE_ID  
           AND   
           ((ISNULL(FromDate,CONVERT(DATE, @FROM_DATE)) <=  CASE WHEN ISNULL(FromDate,CONVERT(DATE, @FROM_DATE)) <= CONVERT(DATE, CONVERT(DATE, @FROM_DATE)) THEN CONVERT(DATE, CONVERT(DATE, @FROM_DATE)) ELSE ISNULL(FromDate,CONVERT(DATE, @FROM_DATE)) END)
           AND ([From Date of Movement] >=  CASE WHEN [From Date of Movement] >= CONVERT(DATE, CONVERT(DATE, @TO_DATE)) THEN CONVERT(DATE, CONVERT(DATE, @TO_DATE))ELSE [From Date of Movement] END)  
           OR  CurrentDetails IS NULL)                 
             
           UNION ALL                 
             
           SELECT  [Moved To]  AS COUNTRY,    
           CASE WHEN FromDate IS NULL AND CONVERT(DATE,[From Date of Movement]) >= CONVERT(DATE,@FROM_DATE) THEN   
           CONVERT(DATE, [From Date of Movement]) ELSE                                                                   
           CASE WHEN FromDate >= CONVERT(DATE, @FROM_DATE) THEN FromDate ELSE CONVERT(DATE, @FROM_DATE) END END AS FROM_DATE,                                                                                                                                
  
           CASE WHEN ((CONVERT(DATE,[From Date of Movement]) >= CONVERT(DATE, @FROM_DATE) AND CONVERT(DATE,[From Date of Movement]) <= CONVERT(DATE, @TO_DATE))  
             OR (CONVERT(DATE,[From Date of Movement]) <= CONVERT(DATE, @FROM_DATE) AND CONVERT(DATE,[From Date of Movement]) <= CONVERT(DATE, @TO_DATE))  
           )  
             
            THEN   
           CASE WHEN FromDate IS NULL THEN (CONVERT(DATE,@TO_DATE)) ELSE  DATEADD(d,1, DATEADD(d,-1, CONVERT(date,[From Date of Movement]))) END ELSE CASE WHEN CONVERT(DATE,[From Date of Movement]) >= CONVERT(DATE, @TO_DATE) THEN CONVERT(DATE, @TO_DATE) END END AS TO_DATE  
           FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD    
           WHERE EmployeeId =@EMPLOYEE_ID AND UPPER(Field) = 'TAX IDENTIFIER COUNTRY'   
           AND   
           ( (ISNULL(FromDate,CONVERT(DATE, @FROM_DATE)) <=  CASE WHEN ISNULL(FromDate,CONVERT(DATE, @FROM_DATE)) <= CONVERT(DATE, CONVERT(DATE, @FROM_DATE)) THEN CONVERT(DATE, CONVERT(DATE, @FROM_DATE)) ELSE ISNULL(FromDate,CONVERT(DATE, @FROM_DATE)) END)
           AND ([From Date of Movement] >=  CASE WHEN [From Date of Movement] >= CONVERT(DATE, CONVERT(DATE, @TO_DATE)) THEN CONVERT(DATE, CONVERT(DATE, @TO_DATE))ELSE [From Date of Movement] END)  
           OR CurrentDetails IS NULL)  
           ) AS OUT_PUT WHERE FROM_DATE <= CASE WHEN TO_DATE IS NULL THEN CONVERT(DATE,@TO_DATE) ELSE TO_DATE END     
           AND COUNTRY IS NOT NULL   
           AND COUNTRY IN  
           (  
            SELECT CountryName FROM CountryMaster  WHERE ID = @COUNTRY_ID  
           )  
          END  
          ELSE  
          BEGIN  
											PRINT 'MULTIPLE RECORD**' 
             
           DELETE FROM #GET_LAST_RECORD_FILTER  
           DELETE FROM #GET_LAST_RECORD             
                                                 
           INSERT INTO #GET_LAST_RECORD (MOVED_TO, FROM_DATE_OF_MOVEMENT)  
           SELECT TOP 1[Moved To], [From Date of Movement]   
           FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD    
           WHERE EmployeeId =@EMPLOYEE_ID  AND UPPER(Field) = 'TAX IDENTIFIER COUNTRY'           
           ORDER BY [From Date of Movement] DESC  
                     
           INSERT INTO #GET_LAST_RECORD_FILTER(MOVED_TO, FROM_DATE_OF_MOVEMENT)  
           SELECT MOVED_TO, FROM_DATE_OF_MOVEMENT FROM #GET_LAST_RECORD  
           WHERE (MOVED_TO = (SELECT CountryName FROM CountryMaster  WHERE ID = @COUNTRY_ID))   
             
           INSERT INTO #TEMP_FILTER_DAYS(COUNTRY ,FROMDATE ,TODATE ,TOT_DAYS)  
             SELECT DISTINCT COUNTRY,FROM_DATE,TO_DATE,DATEDIFF(d,FROM_DATE,TO_DATE) AS totdays FROM   
             (  
              SELECT    
              CASE WHEN CurrentDetails IS NULL THEN [Moved To] ELSE CurrentDetails END AS COUNTRY,    
              CASE WHEN FromDate IS NULL AND CONVERT(DATE,[From Date of Movement]) > CONVERT(DATE, @FROM_DATE) THEN CONVERT(DATE, @FROM_DATE) ELSE  
              CASE WHEN FromDate >= CONVERT(DATE, @FROM_DATE) THEN FromDate ELSE CONVERT(DATE, @FROM_DATE) END END AS FROM_DATE,  
                
              CASE WHEN (CONVERT(DATE,[From Date of Movement]) > CONVERT(DATE, @FROM_DATE) AND CONVERT(DATE,[From Date of Movement]) < CONVERT(DATE, @TO_DATE))   
              THEN CASE WHEN FromDate IS NULL THEN CONVERT(DATE,[From Date of Movement])  
              ELSE  DATEADD(d,1, DATEADD(d,-1, CONVERT(date,[From Date of Movement]))) END  
              ELSE CASE WHEN CONVERT(DATE,[From Date of Movement]) > CONVERT(DATE, @TO_DATE) THEN CONVERT(DATE, @TO_DATE) END END AS TO_DATE  
              FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD    
              WHERE EmployeeId = @EMPLOYEE_ID  AND UPPER(Field) = 'TAX IDENTIFIER COUNTRY' AND   
              (CurrentDetails IN  
              (  
               SELECT CountryName FROM CountryMaster  WHERE ID = @COUNTRY_ID  
              ) AND (ISNULL(FromDate,@FROM_DATE) <=  CASE WHEN ISNULL(FromDate,@FROM_DATE) <= CONVERT(DATE, @FROM_DATE) THEN CONVERT(DATE, @FROM_DATE) ELSE ISNULL(FromDate,@FROM_DATE) END)  
               AND ([From Date of Movement] >=  CASE WHEN [From Date of Movement] >= CONVERT(DATE, @TO_DATE) THEN CONVERT(DATE, @TO_DATE)ELSE [From Date of Movement] END)  
              OR CurrentDetails IS NULL)       
             ) AS OUT_PUT WHERE FROM_DATE <= CASE WHEN TO_DATE IS NULL THEN CONVERT(DATE,@TO_DATE ) ELSE TO_DATE END  
             UNION ALL  
           SELECT DISTINCT COUNTRY,FROM_DATE,TO_DATE,DATEDIFF(d,FROM_DATE,TO_DATE) AS totdays FROM   
             (  
              SELECT MOVED_TO AS COUNTRY,    
              CASE WHEN (CONVERT(DATE,FROM_DATE_OF_MOVEMENT) >= CONVERT(DATE, @FROM_DATE)) AND  (CONVERT(DATE,FROM_DATE_OF_MOVEMENT) <= CONVERT(DATE, @TO_DATE))  
              THEN FROM_DATE_OF_MOVEMENT  ELSE CONVERT(DATE, @FROM_DATE)END AS FROM_DATE,   
                                         
              CASE WHEN (CONVERT(DATE,FROM_DATE_OF_MOVEMENT) >= CONVERT(DATE, @FROM_DATE)) AND  (CONVERT(DATE,FROM_DATE_OF_MOVEMENT) <= CONVERT(DATE, @TO_DATE))  
              THEN CONVERT(DATE, @TO_DATE) ELSE CONVERT(DATE, @TO_DATE)  END AS TO_DATE  
                
              FROM #GET_LAST_RECORD_FILTER    
              WHERE CONVERT(DATE,FROM_DATE_OF_MOVEMENT) <= CONVERT(DATE, @TO_DATE)  
             ) AS OUT_PUT WHERE FROM_DATE <= CASE WHEN TO_DATE IS NULL THEN CONVERT(DATE,@TO_DATE) ELSE TO_DATE END            
  
           --FOR DEBUGGING REMOVE COMMENT   
           --PRINT'      
  
           --INSERT INTO #GET_LAST_RECORD (MOVED_TO, FROM_DATE_OF_MOVEMENT)  
           --SELECT TOP 1  
           --[Moved To], [From Date of Movement]   
           --FROM   
           --AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD    
           --WHERE EmployeeId = '''+@EMPLOYEE_ID +'''          
           --ORDER BY [From Date of Movement] DESC  
  
  
           --INSERT INTO #GET_LAST_RECORD_FILTER(MOVED_TO, FROM_DATE_OF_MOVEMENT)  
           --SELECT MOVED_TO, FROM_DATE_OF_MOVEMENT FROM #GET_LAST_RECORD  
           --WHERE (MOVED_TO = (SELECT CountryName FROM CountryMaster  WHERE ID = '''+@COUNTRY_ID+'''))  
                  
           --INSERT INTO #TEMP_FILTER_DAYS(COUNTRY ,FROMDATE ,TODATE ,TOT_DAYS)  
           --SELECT DISTINCT COUNTRY,FROM_DATE,TO_DATE,DATEDIFF(d,FROM_DATE,TO_DATE) AS totdays FROM   
           --(  
           --                                     SELECT    
           -- CASE WHEN CurrentDetails IS NULL THEN [Moved To] ELSE CurrentDetails END AS COUNTRY,    
           -- CASE WHEN FromDate IS NULL AND CONVERT(DATE,[From Date of Movement]) > CONVERT(DATE,  '''+@FROM_DATE+''') THEN CONVERT(DATE,  '''+@FROM_DATE+''') ELSE  
           -- CASE WHEN FromDate >= CONVERT(DATE,  '''+@FROM_DATE+''') THEN FromDate ELSE CONVERT(DATE,  '''+@FROM_DATE+''') END END AS FROM_DATE,  
           -- CASE WHEN (CONVERT(DATE,[From Date of Movement]) > CONVERT(DATE,  '''+@FROM_DATE+''') AND CONVERT(DATE,[From Date of Movement]) < CONVERT(DATE, '''+@TO_DATE+'''))   
           -- THEN CASE WHEN FromDate IS NULL THEN CONVERT(DATE,[From Date of Movement])  
           -- ELSE  DATEADD(d,1, DATEADD(d,-1, CONVERT(date,[From Date of Movement]))) END  
           -- ELSE CASE WHEN CONVERT(DATE,[From Date of Movement]) > CONVERT(DATE, '''+@TO_DATE+''') THEN CONVERT(DATE, '''+@TO_DATE+''') END END AS TO_DATE  
           -- FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD    
           -- WHERE EmployeeId = '''+@EMPLOYEE_ID +'''   AND   
           -- (CurrentDetails IN  
           -- (  
           --  SELECT CountryName FROM CountryMaster  WHERE ID = '''+@COUNTRY_ID+'''  
           -- ) AND (ISNULL(FromDate, '''+@FROM_DATE+''') <=  CASE WHEN ISNULL(FromDate, '''+@FROM_DATE+''') <= CONVERT(DATE,  '''+@FROM_DATE+''') THEN CONVERT(DATE,  '''+@FROM_DATE+''') ELSE ISNULL(FromDate, '''+@FROM_DATE+''') END)  
           --  AND ([From Date of Movement] >=  CASE WHEN [From Date of Movement] >= CONVERT(DATE, '''+@TO_DATE+''') THEN CONVERT(DATE, '''+@TO_DATE+''')ELSE [From Date of Movement] END)  
           -- OR CurrentDetails IS NULL)       
           --) AS OUT_PUT WHERE FROM_DATE <= CASE WHEN TO_DATE IS NULL THEN CONVERT(DATE,'''+@TO_DATE+''' ) ELSE TO_DATE END  
           --UNION ALL  
           --SELECT DISTINCT COUNTRY,FROM_DATE,TO_DATE,DATEDIFF(d,FROM_DATE,TO_DATE) AS totdays FROM   
           --(  
           --SELECT   
           --MOVED_TO AS COUNTRY,    
             
             
           --CASE WHEN (CONVERT(DATE,FROM_DATE_OF_MOVEMENT) >= CONVERT(DATE,'''+@FROM_DATE+''')) AND  (CONVERT(DATE,FROM_DATE_OF_MOVEMENT) <= CONVERT(DATE, '''+@TO_DATE+'''))  
           --THEN FROM_DATE_OF_MOVEMENT  ELSE CONVERT(DATE, '''+@FROM_DATE+''')END AS FROM_DATE,   
                                       
           --CASE WHEN (CONVERT(DATE,FROM_DATE_OF_MOVEMENT) >= CONVERT(DATE, '''+@FROM_DATE+''')) AND  (CONVERT(DATE,FROM_DATE_OF_MOVEMENT) <= CONVERT(DATE, '''+@TO_DATE+'''))  
           --THEN CONVERT(DATE, '''+@TO_DATE+''') ELSE CONVERT(DATE, '''+@TO_DATE+''')  END AS TO_DATE  
             
           --FROM   
           --#GET_LAST_RECORD_FILTER    
           --WHERE   
           --CONVERT(DATE,FROM_DATE_OF_MOVEMENT) <= CONVERT(DATE, '''+@TO_DATE+''')  
           --) AS OUT_PUT WHERE FROM_DATE <= CASE WHEN TO_DATE IS NULL THEN CONVERT(DATE,'''+@TO_DATE+''') ELSE TO_DATE END                   
           --'               
          END  
  
         END              
        END    
        DECLARE @COUNTRY_DAYS BIGINT   
        DECLARE @TESTCOUNT INT  
           SELECT @TESTCOUNT = COUNT(TOT_DAYS )FROM #TEMP_FILTER_DAYS WHERE COUNTRY IN(SELECT COUNTRY FROM CountryMaster WHERE ID = @COUNTRY_ID)  
          
        SET @FINAL_FORMULA = 'DATEDIFF(day, '''+@FROM_DATE+''' ,'''+@TO_DATE+''')'  
        SET @SQL = N'set @result = ' + @FINAL_FORMULA  
          
        DECLARE @CAL_COUNTRY_DAYS_1 FLOAT  
        EXEC sp_executesql @SQL, N'@result FLOAT   output', @result OUT  
        SET @CAL_COUNTRY_DAYS = dbo.FN_GET_COMPANY_DECIMAL_SETTING( @PERQ_VALUE,'TAXVALUE') /@result                                               
        --SET @CAL_COUNTRY_DAYS = @PERQ_VALUE /@result   
        DECLARE @FROM_DATE_COUNTRY DATETIME ,@TO_DATE_COUNTRY DATETIME  
        SET @FROM_DATE_COUNTRY=Null   
        SET @TO_DATE_COUNTRY=Null  
          
        IF(@TESTCOUNT > 0 AND ISNULL(@ISTEMPLATE,0)=1)   
        BEGIN   
          /*Print 'Seprated view'*/  
         INSERT INTO #TEMP_ALL_COUNTRIES_DAYS(INSTRUMENT_ID,EMPLOYEE_ID,COUNTRY_ID,GRANTOPTIONID,TOT_DAYS,VESTINGDATE,GRANTLEGSERIALNO,FROM_DATE,TO_DATE,TEMP_EXERCISEID)  
         SELECT @INSTRUMENT_ID,@EMPLOYEE_ID,@COUNTRY_ID,@GRANTOPTIONID,(ISNULL(TOT_DAYS,0) * ISNULL((dbo.FN_GET_COMPANY_DECIMAL_SETTING( @PERQ_VALUE,'TAXVALUE') /@result),0)) AS CAL_COUNTRY_DAYS_1,@VESTINGDATE,@GRANTLEGSERIALNO,  
         FROMDATE AS FROM_DATE_COUNTRY,           
         CASE WHEN (CONVERT(VARCHAR, @TO_DATE )=  CONVERT(VARCHAR,TODATE)) THEN TODATE ELSE DATEADD(d,-1, CONVERT(DATE,TODATE))END AS TO_DATE_COUNTRY        
         ,@TEMP_EXERCISEID  
         FROM #TEMP_FILTER_DAYS   
          WHERE ISNULL(TOT_DAYS,0) > 0
          
        END   
        ELSE   
        BEGIN   
         /*Print 'Consolated view'*/  
           IF(@TESTCOUNT > 0)    
           BEGIN      
          SELECT @COUNTRY_DAYS = SUM(TOT_DAYS )FROM #TEMP_FILTER_DAYS   
         END          
           
         /* Add From Date for Country*/  
           
         SELECT @FROM_DATE_COUNTRY=FROMDATE  , @TO_DATE_COUNTRY=TODATE  
         FROM #TEMP_FILTER_DAYS  
         /* End Add for country */  
         PRINT 'Days_24444 ' + CONVERT(VARCHAR(10), @COUNTRY_DAYS)   
                         
         SET @FINAL_FORMULA = 'DATEDIFF(day, '''+@FROM_DATE+''' ,'''+@TO_DATE+''')'  
         SET @SQL = N'set @result = ' + @FINAL_FORMULA     
         SET @CAL_COUNTRY_DAYS = dbo.FN_GET_COMPANY_DECIMAL_SETTING( @PERQ_VALUE,'TAXVALUE') /@result                                  
                   
            SET @CAL_COUNTRY_DAYS_1 = @CAL_COUNTRY_DAYS *  @COUNTRY_DAYS  
           
         IF(ISNULL(@COUNTRY_DAYS,0)=0)  
         BEGIN  
            PRINT 'NO DATA FOUND'  
            SET @CAL_COUNTRY_DAYS = 0  
         END   
            
         IF(@TESTCOUNT > 0)  
         BEGIN   
									
         INSERT INTO #TEMP_ALL_COUNTRIES_DAYS(INSTRUMENT_ID,EMPLOYEE_ID,COUNTRY_ID,GRANTOPTIONID,TOT_DAYS,VESTINGDATE,GRANTLEGSERIALNO,FROM_DATE,TO_DATE,TEMP_EXERCISEID,STOCK_VALUE)  
         VALUES (@INSTRUMENT_ID,@EMPLOYEE_ID,@COUNTRY_ID,@GRANTOPTIONID,@CAL_COUNTRY_DAYS_1,@VESTINGDATE,@GRANTLEGSERIALNO,@FROM_DATE_COUNTRY,@TO_DATE_COUNTRY,@TEMP_EXERCISEID,@STOCK_VALUE)                      
         END   
           
        END  
          
         DECLARE @TESTCOUNTRY_COUNT INT  
         SET @TESTCOUNTRY_COUNT = (SELECT COUNT(*) FROM #TEMP_ALL_COUNTRIES_DAYS)  
                                 
           SET @CMNVAL = @CMNVAL + 1   
       END  
                                     
         END   
     END  
    END             
   END      
     END     
       
     IF(( SELECT COUNT( INSTRUMENT_ID) FROM #TEMP_ALL_COUNTRIES_DAYS ) > 0)  
     BEGIN  
       SELECT INSTRUMENT_ID,EMPLOYEE_ID,COUNTRY_ID,GRANTOPTIONID,TOT_DAYS,VESTINGDATE,GRANTLEGSERIALNO,FROM_DATE,TO_DATE,TEMP_EXERCISEID,STOCK_VALUE FROM #TEMP_ALL_COUNTRIES_DAYS  
     END  
     ELSE  
     BEGIN 
     
   
	    INSERT INTO #TEMP_ALL_COUNTRIES_DAYS(INSTRUMENT_ID,EMPLOYEE_ID,COUNTRY_ID,GRANTOPTIONID,TOT_DAYS,VESTINGDATE,GRANTLEGSERIALNO,FROM_DATE,TO_DATE,TEMP_EXERCISEID,STOCK_VALUE)  
	    VALUES (@INSTRUMENT_ID,@EMPLOYEE_ID,0,@GRANTOPTIONID,@PERQ_VALUE,@VESTINGDATE,@GRANTLEGSERIALNO,Null,Null,@TEMP_EXERCISEID,@STOCK_VALUE)                      
     
	    SELECT INSTRUMENT_ID,EMPLOYEE_ID,COUNTRY_ID,GRANTOPTIONID,TOT_DAYS,VESTINGDATE,GRANTLEGSERIALNO,FROM_DATE,TO_DATE,TEMP_EXERCISEID,STOCK_VALUE FROM #TEMP_ALL_COUNTRIES_DAYS  
    END  
        
       
   END TRY  
  BEGIN CATCH  
        DECLARE  @MAILBODY VARCHAR( MAX) ,@ERROR_NUMBER VARCHAR(50),@ERROR_SEVERITY VARCHAR(50) ,@ERROR_STATE VARCHAR(50),@ERROR_PROCEDURE VARCHAR(500),  
          @ERROR_LINE  VARCHAR(MAX),@ERROR_MESSAGE VARCHAR(MAX),@Subject_body NVARCHAR(250)  
           
          SELECT @ERROR_NUMBER = ERROR_NUMBER() ,@ERROR_SEVERITY = ERROR_SEVERITY() ,@ERROR_STATE = ERROR_STATE() ,@ERROR_PROCEDURE =  ERROR_PROCEDURE(),   
    @ERROR_LINE = ERROR_LINE(), @ERROR_MESSAGE = ERROR_MESSAGE()   
      
    SET @MAILBODY = 'ERROR NUMBER -' +@ERROR_NUMBER+','+ 'ERROR SEVERITY -' +@ERROR_SEVERITY+','+ 'ERROR STATE -' +@ERROR_STATE+','+ 'ERROR PROCEDURE -' +@ERROR_PROCEDURE+','+ 'ERROR LINE -' +@ERROR_LINE+','+ 'ERROR MESSAGE -' +@ERROR_MESSAGE     
    SET @Subject_body='Error Occured on [Date:'+Convert(NVARCHAR(50),getdate())+']'  
     
   ---- SEND MAIL --  
   --DECLARE @tab CHAR(1) = CHAR(9)  
   --EXECUTE   
   -- msdb.dbo.sp_send_dbmail     
   -- @recipients = 'esopit@esopdirect.com',     
   -- @subject =  @Subject_body,   
   -- @body = @MAILBODY,    
   -- @body_format = 'HTML',  
   -- @query = '',   
   -- @attach_query_result_as_file = 0,  
   -- @query_attachment_filename = NULL,  
   -- @query_result_separator = @tab,  
   -- @query_result_no_padding = 1   
   PRINT @MAILBODY             
  END CATCH  
 DROP TABLE #TEMP_EMP_DATA   
 DROP TABLE #TEMP_FMV_DETAILS  
 DROP TABLE #TEMP_PROP_FORMULA   
 DROP TABLE #TEMP_FILTER_DAYS  
 DROP TABLE #GET_LAST_RECORD  
 DROP TABLE #GET_LAST_RECORD_FILTER  
    DROP TABLE #TEMP_ALL_COUNTRIES_DAYS  
 --SET NOCOUNT OFF;   
END
GO
