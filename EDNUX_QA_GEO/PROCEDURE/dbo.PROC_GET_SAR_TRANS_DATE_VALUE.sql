/****** Object:  StoredProcedure [dbo].[PROC_GET_SAR_TRANS_DATE_VALUE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_SAR_TRANS_DATE_VALUE]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_SAR_TRANS_DATE_VALUE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_SAR_TRANS_DATE_VALUE]
(   
 @EMPLOYEE_TRANS_DETAILS dbo.TYPE_SAR_TRANSACTION_DATE READONLY,   
 @CalledFrom VARCHAR(50) = NULL  
)  
AS  
BEGIN    
 SET NOCOUNT ON;      
      
 DECLARE     
   @PRICEPERIODID NVARCHAR(200), @MSEID NVARCHAR(50), @CONCATSTRING VARCHAR(4000), @PRICEDAYS INT, @STOCKPRICE NVARCHAR(1000),@SQLTEXT NVARCHAR(MAX),     
   @EVENTDATE VARCHAR(200), @TRANSACTIONDATE NVARCHAR(1000), @Count INT, @ISTRADINGDAYS TINYINT, @PRICEDAY VARCHAR(50), @INCIDENCEDATEID VARCHAR(50),    
   @INCIDENCEDATE VARCHAR(50), @SQLQUERY NVARCHAR(1000), @MINVALUE INT, @MAXVALUE INT, @STARTDATE  VARCHAR(200),     
   @ENDATE  VARCHAR(200), @OPENIGPRICE  DECIMAL(18,4), @CLOSINGPRICE  DECIMAL(18,4), @STOCKEXCHANGE VARCHAR(50), @TRADINGVOLUME VARCHAR(50),     
   @AVGOPENCLOSEPRICE  DECIMAL(18,4), @INSTRUMENT_ID BIGINT, @EMPLOYEE_ID VARCHAR(50), @GRANTOPTIONID VARCHAR(50), @GRANTDATE VARCHAR(200),    
   @VESTINGDATE VARCHAR(200), @EXERCISE_DATE  DATETIME, @TRANS_DATE_PRICE  DECIMAL(18,4), @MN_VALUE INT, @MX_VALUE INT, @EMPLOYEE_COUNTRY_ID INT,    
   @TRANSDATEID NVARCHAR(1000),@TRANSDATE NVARCHAR(1000),@MNVAL INT, @MXVAL INT,@VALIDDATE VARCHAR(200),@TAXFLAG CHAR(1),@FORMULATYPE VARCHAR(50),    
            @SCHEMEID  NVARCHAR(100),@CALCULATE_TAX NVARCHAR(100),@CALCUALTE_TAX_PRIOR_DAYS INT,@STOCKEXCHANGECODE CHAR(1), @SAR_TRANS_DATE_ID BIGINT    
            ,@TEMP_TAXFLAG VARCHAR(50),@TAXFLAG_HEADER CHAR(1),@ISLISTED CHAR(1),@Is_SARPriceExists AS INTEGER, @TEMP_EVENTDATE VARCHAR(200)    
     -- CREATE TEMP TABLE --    
    CREATE TABLE #TEMP_FILTER_TRANS_DATE_DATA    
    (    
  FFC_ID BIGINT, FORNULA_NAME NVARCHAR(1000), MSE_ID NVARCHAR(50), Residential_ID BIGINT, FORMULA_DESCRIPTION NVARCHAR(MAX), TRANS_DATE_ID NVARCHAR(1000), PRICE_DAY_ID NVARCHAR(1000) ,     
        TRADING_VOL_ID  NVARCHAR(1000), STOCK_PRICE_ID  NVARCHAR(1000), PRICE_PERIOD NVARCHAR(200), PRICE_PERIOD_DAY INT,IS_TRADINGDAYS TINYINT    
    )    
              
    CREATE TABLE #TEMP_AVGPRICE    
    (      
        ID INT IDENTITY(1,1) NOT NULL,STOCKPRICE  DECIMAL(18,4),Volume  DECIMAL(18,4),StockExchange VARCHAR(50),TransactionDate DATETIME    
    )     
      
    CREATE TABLE #TEMP_CALENDERDAYS    
    (    
  id INT IDENTITY(1,1) NOT NULL, CALENDERDATES VARCHAR(200)     
    )     
         
    CREATE TABLE #TEMP_FILTER_CALENDERDAYS    
    (    
  CALENDERDATES DATETIME    
    )    
       
    CREATE TABLE #TEMP_TRADINGDAYS    
    (    
  ID INT IDENTITY(1,1 )NOT NULL, TRADINGDATES DATETIME    
    )    
      
    CREATE TABLE #TEMP_MULTIPLE_STOCK    
    (      
   ID INT IDENTITY(1,1) NOT NULL, STOCKOPEN_HIGHPRICE DECIMAL(18,4), STOCKCLOSE_LOWPRICE  DECIMAL(18,4), Volume  DECIMAL(18,4),    
   StockExchange VARCHAR(50), TransactionDate DATETIME    
    )     
        
    CREATE TABLE #TEMP_TD_EMPLOYEE_DETAILS    
    (      
        ID INT IDENTITY(1,1) NOT NULL,INSTRUMENT_ID BIGINT ,EMPLOYEE_ID  VARCHAR(50),GRANTOPTIONID VARCHAR(50) ,GRANTDATE  VARCHAR(200) ,VESTINGDATE VARCHAR(200), EXERCISE_DATE  DATETIME, SAR_TRANS_DATE_ID BIGINT    
    )      
          
    CREATE TABLE #TEMP_TRANS_DATE_DETAILS    
    (      
        ID INT IDENTITY(1,1) NOT NULL,INSTRUMENT_ID BIGINT ,EMPLOYEE_ID  VARCHAR(50),GRANTOPTIONID VARCHAR(50) ,GRANTDATE  VARCHAR(200) ,VESTINGDATE VARCHAR(200), EXERCISE_DATE  DATETIME,TRANS_DATE_VALUE  DECIMAL(18,4) NULL,TAXFLAG CHAR(1) NULL, SAR_TRANS_DATE_ID BIGINT    
    )      
       
    CREATE TABLE #TEMP_NON_TRADING_DAYS    
    (     
  ID INT IDENTITY(1,1 )NOT NULL, NONTRADINGDATES DATETIME    
    )    
       
   CREATE TABLE #TEMP_COMPARE_DATA    
 (      
  STOCKPRICE  DECIMAL(18,4),Volume  DECIMAL(18,4),StockExchange VARCHAR(50)    
 )     
    INSERT INTO #TEMP_TD_EMPLOYEE_DETAILS     
 (    
     INSTRUMENT_ID, EMPLOYEE_ID, GRANTOPTIONID, GRANTDATE, VESTINGDATE, EXERCISE_DATE, SAR_TRANS_DATE_ID    
 )    
 SELECT  INSTRUMENT_ID, EMPLOYEE_ID, GRANTOPTIONID, GRANTDATE,VESTINGDATE, EXERCISE_DATE, SAR_TRANS_DATE_ID    
 FROM @EMPLOYEE_TRANS_DETAILS    
            
    
 BEGIN TRY    
  -- GET MIN AND MAX VALUE --    
  SELECT @MN_VALUE = MIN(ID ),@MX_VALUE = MAX(ID) FROM #TEMP_TD_EMPLOYEE_DETAILS    
       
  WHILE(@MN_VALUE <= @MX_VALUE)    
  BEGIN    
  SELECT @INSTRUMENT_ID = INSTRUMENT_ID, @EMPLOYEE_ID = EMPLOYEE_ID, @GRANTOPTIONID = GRANTOPTIONID,@GRANTDATE = GRANTDATE,@VESTINGDATE=VESTINGDATE, @EXERCISE_DATE = EXERCISE_DATE, @SAR_TRANS_DATE_ID = SAR_TRANS_DATE_ID      
  FROM #TEMP_TD_EMPLOYEE_DETAILS  WHERE ID = @MN_VALUE    
       
  SET @SCHEMEID = (SELECT SchemeId FROM GrantOptions   WHERE GrantOptionId = @GRANTOPTIONID)    
         
     SELECT @CALCULATE_TAX = CALCULATE_TAX,@CALCUALTE_TAX_PRIOR_DAYS = CALCUALTE_TAX_PRIOR_DAYS FROM Scheme WHERE SchemeId = @SCHEMEID          
          
        SELECT @INCIDENCEDATEID = dbo.FN_GET_COM_CODE_VALUE(EVENT_OF_INCIDENCE_ID) FROM PERQUISITE_FORMULA_CONFIG WHERE RESIDENTIAL_ID IS NULL  AND COUNTRY_ID IS NULL     
           
        IF(@INCIDENCEDATEID = 'Grant Date')    
        BEGIN    
    SET  @INCIDENCEDATE = @GRANTDATE    
        END                    
        ELSE IF(@INCIDENCEDATEID = 'Vesting Date')    
        BEGIN    
   SET  @INCIDENCEDATE = @VESTINGDATE    
        END    
        ELSE IF(@INCIDENCEDATEID = 'Exercise Date')    
  BEGIN    
    SET  @INCIDENCEDATE = @EXERCISE_DATE    
        END    
                         
     SET @TRANSDATEID =(SELECT TOP(1) CASE WHEN(  DBO.FN_GET_COM_CODE_VALUE(TRANS_DATE_ID) = 'Grant Date') THEN 'Grant Date'    
             WHEN(  DBO.FN_GET_COM_CODE_VALUE(TRANS_DATE_ID) = 'Vesting Date') THEN 'Vesting Date'     
             WHEN(  DBO.FN_GET_COM_CODE_VALUE(TRANS_DATE_ID) = 'Exercise Date') THEN 'Exercise Date'                                  
           END AS 'TransactionDate'     
         FROM FMV_FORMULA_CONFIG AS FFC        
         WHERE FFC.FFC_ID = CASE WHEN (ISNULL(@SAR_TRANS_DATE_ID, 0) = 0 AND FFC.FORMULA_CONFIG_TYPE = 'SARFMV' AND SAR_FORMULA = 'BasedOnTransactionDate'          
                AND ((CONVERT(DATE, FFC.APPLICABLE_FROM_DATE) <= CONVERT(DATE,@EXERCISE_DATE)) AND (CONVERT(DATE, ISNULL(FFC.APPLICABLE_TO_DATE, GETDATE())) >=  CONVERT(DATE,@EXERCISE_DATE)))     
                AND ISNULL(Residential_ID,0) = 0 AND ISNULL( Country_ID,0) = 0 AND MIT_ID = @INSTRUMENT_ID AND SCHEME_ID = @SCHEMEID)    
               THEN FFC.FFC_ID    
               ELSE @SAR_TRANS_DATE_ID    
               END    
         ORDER BY FFC_ID DESC)    
                 
        IF(@TRANSDATEID = 'Grant Date')        
           SET @TRANSDATE = @GRANTDATE                       
        ELSE IF(@TRANSDATEID = 'Vesting Date')        
           SET @TRANSDATE = @VESTINGDATE        
        ELSE IF(@TRANSDATEID = 'Exercise Date')         
           SET @TRANSDATE = @EXERCISE_DATE    
          
        IF((SELECT COUNT(*) AS NonTradeDay FROM NonTradingDays WHERE CONVERT(DATE,NonTradDay) = CONVERT(DATE,@TRANSDATE)) > 0)    
     BEGIN     
           -- FOR NON TRADIND DAY    
     INSERT INTO #TEMP_FILTER_TRANS_DATE_DATA              
     SELECT TOP(1)FFC.FFC_ID,FFC.FORNULA_NAME,FFC.MSE_ID,FFC.Residential_ID,FORMULA_DESCRIPTION,        
       CASE WHEN(  DBO.FN_GET_COM_CODE_VALUE(TRANS_DATE_ID) = 'Grant Date') THEN 'GrantDate'    
         WHEN(  DBO.FN_GET_COM_CODE_VALUE(TRANS_DATE_ID) = 'Vesting Date') THEN 'FinalVestingDate'     
         WHEN(  DBO.FN_GET_COM_CODE_VALUE(TRANS_DATE_ID) = 'Exercise Date') THEN 'ExerciseDate'                                  
       END AS 'TransactionDate',    
       dbo.FN_GET_COM_CODE_VALUE(PRICE_DAY_ID) AS Price ,dbo.FN_GET_COM_CODE_VALUE(TRADING_VOL_ID) AS TradingVolume  ,    
       CASE WHEN( dbo.FN_GET_COM_CODE_VALUE(STOCK_PRICE_ID) = 'Opening Price') THEN 'OpenPrice'    
         WHEN( dbo.FN_GET_COM_CODE_VALUE(STOCK_PRICE_ID) = 'Closing Price') THEN 'ClosePrice'    
         WHEN( dbo.FN_GET_COM_CODE_VALUE(STOCK_PRICE_ID) = 'High Price') THEN 'HighPrice'    
         WHEN( dbo.FN_GET_COM_CODE_VALUE(STOCK_PRICE_ID) = 'Low Price') THEN 'LowPrice'    
            WHEN( dbo.FN_GET_COM_CODE_VALUE(STOCK_PRICE_ID) = 'Average of Opening Closing') THEN 'OpenPrice,ClosePrice'    
         WHEN( dbo.FN_GET_COM_CODE_VALUE(STOCK_PRICE_ID) = 'Average of High Low') THEN 'HighPrice,LowPrice'              
       END AS 'StockPrice',        
       FFC.PRICE_PERIOD, FFC.PRICE_PERIOD_DAY,FFC.IS_TRADINGDAYS    
    FROM FMV_FORMULA_CONFIG  AS FFC        
    WHERE     
       FFC.FFC_ID = CASE WHEN (ISNULL(@SAR_TRANS_DATE_ID, 0) = 0 AND FFC.FORMULA_CONFIG_TYPE = 'SARFMV' AND SAR_FORMULA = 'BasedOnTransactionDate'          
           AND ((CONVERT(DATE, FFC.APPLICABLE_FROM_DATE) <= CONVERT(DATE,@EXERCISE_DATE)) AND (CONVERT(DATE, ISNULL(FFC.APPLICABLE_TO_DATE, GETDATE())) >=  CONVERT(DATE,@EXERCISE_DATE)))     
           AND FFC.IS_TRADINGDAYS = 0 AND ISNULL(Residential_ID,0) = 0 AND ISNULL(Country_ID,0) = 0 AND MIT_ID = @INSTRUMENT_ID AND SCHEME_ID = @SCHEMEID)                      
          THEN FFC.FFC_ID    
          ELSE @SAR_TRANS_DATE_ID    
           END    
    ORDER BY FFC_ID DESC    
        
   END    
   ELSE    
   BEGIN    
          -- FOR TRADING DAY    
    INSERT INTO #TEMP_FILTER_TRANS_DATE_DATA              
    SELECT TOP(1)FFC.FFC_ID,FFC.FORNULA_NAME,FFC.MSE_ID,FFC.Residential_ID,FORMULA_DESCRIPTION,        
      CASE WHEN(  DBO.FN_GET_COM_CODE_VALUE(TRANS_DATE_ID) = 'Grant Date') THEN 'GrantDate'    
        WHEN(  DBO.FN_GET_COM_CODE_VALUE(TRANS_DATE_ID) = 'Vesting Date') THEN 'FinalVestingDate'     
        WHEN(  DBO.FN_GET_COM_CODE_VALUE(TRANS_DATE_ID) = 'Exercise Date') THEN 'ExerciseDate'                                  
      END AS 'TransactionDate',    
      dbo.FN_GET_COM_CODE_VALUE(PRICE_DAY_ID) as Price ,dbo.FN_GET_COM_CODE_VALUE(TRADING_VOL_ID) As TradingVolume,    
      CASE WHEN( dbo.FN_GET_COM_CODE_VALUE(STOCK_PRICE_ID) = 'Opening Price') THEN 'OpenPrice'    
        WHEN( dbo.FN_GET_COM_CODE_VALUE(STOCK_PRICE_ID) = 'Closing Price') THEN 'ClosePrice'    
        WHEN( dbo.FN_GET_COM_CODE_VALUE(STOCK_PRICE_ID) = 'High Price') THEN 'HighPrice'    
        WHEN( dbo.FN_GET_COM_CODE_VALUE(STOCK_PRICE_ID) = 'Low Price') THEN 'LowPrice'    
        WHEN( dbo.FN_GET_COM_CODE_VALUE(STOCK_PRICE_ID) = 'Average of Opening Closing') THEN 'OpenPrice,ClosePrice'    
        WHEN( dbo.FN_GET_COM_CODE_VALUE(STOCK_PRICE_ID) = 'Average of High Low') THEN 'HighPrice,LowPrice'              
       END AS 'StockPrice',    
       FFC.PRICE_PERIOD, FFC.PRICE_PERIOD_DAY,FFC.IS_TRADINGDAYS    
    FROM FMV_FORMULA_CONFIG  AS FFC        
    WHERE     
     FFC.FFC_ID = CASE WHEN (ISNULL(@SAR_TRANS_DATE_ID, 0) = 0 AND FFC.FORMULA_CONFIG_TYPE = 'SARFMV' AND SAR_FORMULA = 'BasedOnTransactionDate' AND ((CONVERT(DATE, FFC.APPLICABLE_FROM_DATE) <= CONVERT(DATE,@EXERCISE_DATE)) AND (CONVERT(DATE, ISNULL(FFC.APPLICABLE_TO_DATE, GETDATE())) >=  CONVERT(DATE,@EXERCISE_DATE)))   
          AND FFC.IS_TRADINGDAYS = 1 AND ISNULL(Residential_ID, 0) = 0 AND ISNULL(Country_ID,0) = 0 AND MIT_ID = @INSTRUMENT_ID AND SCHEME_ID = @SCHEMEID)     
           THEN FFC.FFC_ID    
           ELSE @SAR_TRANS_DATE_ID    
         END                      
    ORDER BY FFC_ID DESC    
    END    
    
        SELECT @PRICEPERIODID = PRICE_PERIOD,@PRICEDAYS = PRICE_PERIOD_DAY, @STOCKPRICE = STOCK_PRICE_ID,@MSEID = MSE_ID ,@TRANSACTIONDATE = TRANS_DATE_ID,@PRICEDAY = PRICE_DAY_ID,@TRADINGVOLUME = TRADING_VOL_ID, @ISTRADINGDAYS = IS_TRADINGDAYS FROM #TEMP_FILTER_TRANS_DATE_DATA         
        
    -- CALCULATE SAR PRICE FOR LISTED COMPANY ----     
    SET @ISLISTED = (SELECT ListedYN FROM CompanyParameters)    
       IF(@ISLISTED = 'Y')    
       BEGIN    
    --  FIRST CASE --    
   IF(UPPER(@PRICEPERIODID) = 'RDOPRICECONSIDERATIONDATE')          
   BEGIN    
    PRINT '1ST CASE'    
    SET @ConcatString = null      
    SET @Count = ((SELECT COUNT( * )FROM dbo.FN_SPLIT_STRING(@MSEID,',')))                             
    SELECT  @ConcatString = COALESCE(@ConcatString + ',', '') +     
    CASE STOCK_EXCHANGE_SYMBOL WHEN'NSE' THEN 'N' WHEN  'BSE'  THEN 'B' WHEN  'NYSE'  THEN 'N' ELSE '' END    
    FROM MST_STOCK_EXCHANGE                    
    WHERE CONVERT(VARCHAR(50), MSE_ID) IN(SELECT * FROM dbo.FN_SPLIT_STRING(@MSEID,','))                        
    
        
    IF(@TRANSACTIONDATE = 'GrantDate')               
     SET @EVENTDATE = CASE WHEN(@PRICEDAY = 'Prior Day' )THEN CASE WHEN(@CALCULATE_TAX = 'rdoTentativeTax') THEN @GRANTDATE ELSE DATEADD(D,-1,@GRANTDATE) END ELSE  @GRANTDATE END                  
    ELSE IF(@TRANSACTIONDATE = 'FinalVestingDate')           
     SET @EVENTDATE = CASE WHEN(@PRICEDAY = 'Prior Day' )THEN CASE WHEN(@CALCULATE_TAX = 'rdoTentativeTax')THEN @VESTINGDATE ELSE DATEADD(D,-1,@VESTINGDATE)END ELSE  @VESTINGDATE END                      
    ELSE IF(@TRANSACTIONDATE = 'ExerciseDate')    
     SET @EVENTDATE = CASE WHEN(@PRICEDAY = 'Prior Day' )THEN CASE WHEN(@CALCULATE_TAX = 'rdoTentativeTax') THEN @EXERCISE_DATE ELSE DATEADD(D,-1,@EXERCISE_DATE) END ELSE  @EXERCISE_DATE END     
    
             
    IF(((SELECT COUNT(NonTradDay) AS NonTradeDay FROM NonTradingDays WHERE CONVERT(DATE,NonTradDay) = CONVERT(DATE,@TRANSDATE)) > 0) AND (@CALCULATE_TAX != 'rdoTentativeTax') )    
    BEGIN     
    SET @FORMULATYPE = 'NT'    
    IF(@PRICEDAY = 'Prior Day')    
    BEGIN    
     INSERT INTO #TEMP_NON_TRADING_DAYS    
     SELECT TOP 100 NonTradDay FROM NonTradingDays WHERE NonTradDay <= @EVENTDATE GROUP BY NonTradDay ORDER BY NonTradDay DESC    
                          
     SELECT @MNVAL = MIN(ID),@MXVAL = MAX(ID) FROM #TEMP_NON_TRADING_DAYS     
    
     WHILE(@MNVAL <= @MXVAL)    
     BEGIN       
     IF ((SELECT NONTRADINGDATES FROM #TEMP_NON_TRADING_DAYS WHERE ID = @MNVAL) = @EVENTDATE)    
      BEGIN    
       SET @EVENTDATE =(SELECT CONVERT(DATE,DATEADD(DAY, - 1,@EVENTDATE)))         
      END     
      ELSE    
       BREAK            
      SET @MNVAL = @MNVAL + 1           
      END           
     END       
                  
    END    
    ELSE    
    BEGIN    
     SET @FORMULATYPE = 'TR'         
    END     
              
    --- CHANGES DONE FOR TENTATIVE SCHEME ----    
    IF(@CALCULATE_TAX = 'rdoTentativeTax')    
    BEGIN          
      SET @TAXFLAG = @TEMP_TAXFLAG        
      IF(@TEMP_TAXFLAG = 'A')    
      BEGIN                 
       IF NOT EXISTS(SELECT FMVPriceID FROM FMVSharePrices WHERE CONVERT(DATE,TransactionDate )= CONVERT(DATE,@EVENTDATE))    
       BEGIN               
         SET @TAXFLAG = '0'    
       END          
       END    
         
       IF(@TEMP_TAXFLAG = 'T')            
        SET @EVENTDATE =(SELECT CONVERT(DATE,DATEADD(DAY, - @CALCUALTE_TAX_PRIOR_DAYS,@EVENTDATE)))     
        
      DELETE FROM #TEMP_NON_TRADING_DAYS    
      INSERT INTO #TEMP_NON_TRADING_DAYS    
      SELECT TOP 100 NonTradDay FROM NonTradingDays WHERE CONVERT(DATE, NonTradDay) <= CONVERT(DATE, @EVENTDATE) GROUP BY NonTradDay    
      ORDER BY NonTradDay DESC    
    
      SELECT @MNVAL = MIN(ID ),@MXVAL = MAX(ID) FROM #TEMP_NON_TRADING_DAYS     
    
      WHILE(@MNVAL <= @MXVAL)    
      BEGIN    
       IF ((SELECT NONTRADINGDATES FROM #TEMP_NON_TRADING_DAYS WHERE ID = @MNVAL) = @EVENTDATE)    
       BEGIN    
          SET @EVENTDATE =(SELECT CONVERT(DATE,DATEADD(DAY, - 1,@EVENTDATE)))         
       END     
       ELSE IF ((SELECT COUNT(FMVPriceID) FROM FMVSharePrices WHERE CONVERT(DATE, TransactionDate) = CONVERT(DATE,@EVENTDATE)) = 0)    
       BEGIN                
        SET @EVENTDATE =(SELECT CONVERT(DATE,DATEADD(DAY, - 1,@EVENTDATE)))     
       END    
       ELSE    
        BREAK    
       SET @MNVAL = @MNVAL + 1           
       END       
     END    
    --- CHANGES DONE FOR TENTATIVE SCHEME ----    
     ELSE    
     BEGIN    
       SET @TEMP_TAXFLAG = NULL    
     END    
    
   IF( @Count > 1)       
    BEGIN   
    PRINT 'FOR MULTISELECT'  
       SET @STOCKEXCHANGECODE = NULL    
      SET @STOCKEXCHANGECODE = (SELECT StockExchange FROM FMVSharePrices WHERE StockExchange IN(SELECT * FROM dbo.FN_SPLIT_STRING(''+@ConcatString+'',','))AND CONVERT(DATE, TransactionDate) = CONVERT(DATE, ''+ @EVENTDATE +'')    
      AND Volume IN (SELECT CASE WHEN UPPER(@TRADINGVOLUME) = 'HIGH' THEN  MAX(Volume) ELSE MIN(Volume) END AS MaxDateTime    
      FROM FMVSharePrices WHERE  StockExchange IN(SELECT * FROM dbo.FN_SPLIT_STRING(''+@ConcatString+'',',')) AND CONVERT(DATE, TransactionDate) = CONVERT(DATE, ''+ @EVENTDATE +'')))               
   END
    SET @SQLTEXT =  N'SELECT  ' + @STOCKPRICE + ' ,Volume,TransactionDate FROM FMVSharePrices WHERE StockExchange IN(SELECT * FROM dbo.FN_SPLIT_STRING('''+CASE WHEN @Count = 1 THEN @ConcatString ELSE  @STOCKEXCHANGECODE END+''','',''))AND CONVERT(DATE,TransactionDate) =  CONVERT(DATE,'''+ @EVENTDATE +''')'      
    /*PRINT @SQLTEXT*/
   
    DELETE FROM #TEMP_AVGPRICE    
    IF(@STOCKPRICE = 'OpenPrice,ClosePrice')    
    BEGIN         
     DELETE FROM #TEMP_MULTIPLE_STOCK    
         
            
      INSERT INTO #TEMP_MULTIPLE_STOCK(STOCKOPEN_HIGHPRICE,STOCKCLOSE_LOWPRICE,Volume,TransactionDate)             
      EXEC (@SQLTEXT)     
          
         SET @AVGOPENCLOSEPRICE = 0    
      SELECT @AVGOPENCLOSEPRICE =(STOCKOPEN_HIGHPRICE + STOCKCLOSE_LOWPRICE)/2     
      FROM #TEMP_MULTIPLE_STOCK    
      WHERE Volume IN (SELECT  CASE WHEN UPPER(@TRADINGVOLUME) = 'HIGH' THEN  MAX(Volume) ELSE MIN(Volume) END FROM #TEMP_MULTIPLE_STOCK)    
      INSERT INTO #TEMP_AVGPRICE(STOCKPRICE)    
      VALUES(@AVGOPENCLOSEPRICE)    
    END    
    ELSE IF(@STOCKPRICE = 'HighPrice,LowPrice')    
    BEGIN         
     DELETE FROM #TEMP_MULTIPLE_STOCK    
     INSERT INTO #TEMP_MULTIPLE_STOCK(STOCKOPEN_HIGHPRICE,STOCKCLOSE_LOWPRICE,Volume,TransactionDate)             
     EXEC (@SQLTEXT)     
     SET @AVGOPENCLOSEPRICE = 0      
     SELECT @AVGOPENCLOSEPRICE =(STOCKOPEN_HIGHPRICE + STOCKCLOSE_LOWPRICE)/2      
     FROM #TEMP_MULTIPLE_STOCK    
     WHERE Volume IN (SELECT  CASE WHEN UPPER(@TRADINGVOLUME) = 'HIGH' THEN  MAX(Volume) ELSE MIN(Volume) END FROM #TEMP_MULTIPLE_STOCK)    
    
     INSERT INTO #TEMP_AVGPRICE(STOCKPRICE)    
     VALUES(@AVGOPENCLOSEPRICE)           
    END    
    ELSE     
    BEGIN               
     INSERT INTO #TEMP_AVGPRICE(STOCKPRICE,Volume,TransactionDate)    
     EXEC (@SQLTEXT)    
    END                                            
    SET  @TRANS_DATE_PRICE = 0    
    SELECT  @TRANS_DATE_PRICE  = AVG(STOCKPRICE)  FROM #TEMP_AVGPRICE      
         
    DELETE FROM #TEMP_AVGPRICE    
        
    -- SET TENTATIVE/ACTUAL FLAG  --     
           
    IF(@FORMULATYPE = 'TR')    
     BEGIN     
      /* print  @TRANS_DATE_PRICE*/    
      SET @TAXFLAG = CASE WHEN ((ISNULL( @TRANS_DATE_PRICE,0)>0) AND (@TEMP_TAXFLAG='A' or  ISNULL(@TEMP_TAXFLAG ,'')= '')) THEN    'A' ELSE 'T' END    
      SET @TAXFLAG_HEADER = CASE WHEN ((ISNULL( @TRANS_DATE_PRICE,0)>0)) THEN 'A' ELSE 'T' END                    
     END    
     ELSE IF (@FORMULATYPE = 'NT')    
     BEGIN    
      IF(@PRICEDAY = 'Prior Day' )    
      BEGIN    
       SET @TAXFLAG_HEADER = 'A'    
       SET @TAXFLAG =  CASE WHEN (@TEMP_TAXFLAG='A' or  ISNULL(@TEMP_TAXFLAG ,'')= '') THEN 'A' ELSE 'T' END    
      END     
      ELSE IF(@PRICEDAY = 'Same Day' )    
      BEGIN    
        SET @TAXFLAG = CASE WHEN ((ISNULL( @TRANS_DATE_PRICE,0)>0) AND (@TEMP_TAXFLAG='A' or  ISNULL(@TEMP_TAXFLAG ,'')= '')) THEN 'A' ELSE 'T' END     
       SET @TAXFLAG_HEADER = CASE WHEN ((ISNULL( @TRANS_DATE_PRICE,0)>0)) THEN 'A' ELSE 'T' END                  
      END    
     END    
    
    -- SET TENTATIVE/ACTUAL FLAG  --      
    
    ---- IF FMV VALUE IS NULL ----    
    IF( @TRANS_DATE_PRICE IS  NULL  OR  @TRANS_DATE_PRICE= 0)     
    BEGIN    
     print 'FMV IS NULL'  
     PRINT @CALCULATE_TAX    
     IF(@CALCULATE_TAX = 'rdoActualTax')    
     BEGIN    
         SET @EVENTDATE =(SELECT CONVERT(DATE,DATEADD(DAY, - 1,@EVENTDATE)))        
       DELETE FROM #TEMP_NON_TRADING_DAYS    
       INSERT INTO #TEMP_NON_TRADING_DAYS    
       SELECT TOP 100 NonTradDay FROM NonTradingDays WHERE NonTradDay <= @EVENTDATE GROUP BY NonTradDay    
       ORDER BY NonTradDay DESC    
    
       SELECT @MNVAL = MIN(ID ),@MXVAL = MAX(ID) FROM #TEMP_NON_TRADING_DAYS     
    
       WHILE(@MNVAL <= @MXVAL)    
       BEGIN    
    
        IF ((SELECT NONTRADINGDATES FROM #TEMP_NON_TRADING_DAYS WHERE ID = @MNVAL) = @EVENTDATE)    
        BEGIN    
         SET @EVENTDATE =(SELECT CONVERT(DATE,DATEADD(DAY, - 1,@EVENTDATE)))         
        END     
        ELSE IF ((SELECT COUNT(FMVPriceID) FROM FMVSharePrices WHERE CONVERT(DATE, TransactionDate) =  CONVERT(DATE, @EVENTDATE)) = 0)    
        BEGIN                
         SET @EVENTDATE =(SELECT CONVERT(DATE,DATEADD(DAY, - 1,@EVENTDATE)))     
        END    
        ELSE    
         BREAK    
            
        SET @MNVAL = @MNVAL + 1           
       END                             
        
          
        
     IF( @Count > 1)       
     BEGIN    
      /*PRINT 'FOR MULTISELECT'*/    
      SET @STOCKEXCHANGECODE = NULL    
    
      SET @STOCKEXCHANGECODE = (SELECT StockExchange FROM FMVSharePrices WHERE StockExchange IN(SELECT * FROM dbo.FN_SPLIT_STRING(''+@ConcatString+'',','))AND CONVERT(DATE, TransactionDate) = CONVERT(DATE,''+ @EVENTDATE +'')    
      AND Volume IN (SELECT CASE WHEN UPPER(@TRADINGVOLUME) = 'HIGH' THEN  MAX(Volume) ELSE MIN(Volume) END AS MaxDateTime    
      FROM FMVSharePrices WHERE  StockExchange IN(SELECT * FROM dbo.FN_SPLIT_STRING(''+@ConcatString+'',',')) AND TransactionDate = ''+ @EVENTDATE +''))               
     END     
    
          
      SET @SQLTEXT =  N'SELECT  ' + @STOCKPRICE + ' ,Volume,TransactionDate FROM FMVSharePrices WHERE StockExchange IN(SELECT * FROM dbo.FN_SPLIT_STRING('''+CASE WHEN @Count = 1 THEN @ConcatString ELSE  @STOCKEXCHANGECODE END+''','',''))AND CONVERT(DATE,TransactionDate) = CONVERT(DATE,'''+ @EVENTDATE +''')'     
      print @SQLTEXT    
      /*PRINT @SQLTEXT*/    
                     
      DELETE FROM #TEMP_AVGPRICE    
      IF(@STOCKPRICE = 'OpenPrice,ClosePrice' OR @STOCKPRICE = 'HighPrice,LowPrice')    
      BEGIN     
       DELETE FROM #TEMP_MULTIPLE_STOCK     
       INSERT INTO #TEMP_MULTIPLE_STOCK(STOCKOPEN_HIGHPRICE,STOCKCLOSE_LOWPRICE,Volume,TransactionDate)             
       EXEC (@SQLTEXT)     
           
       SET @AVGOPENCLOSEPRICE = 0      
       SELECT @AVGOPENCLOSEPRICE =(STOCKOPEN_HIGHPRICE + STOCKCLOSE_LOWPRICE)/2     
       FROM #TEMP_MULTIPLE_STOCK    
       WHERE Volume IN (SELECT  CASE WHEN UPPER(@TRADINGVOLUME) = 'HIGH' THEN  MAX(Volume) ELSE MIN(Volume) END FROM #TEMP_MULTIPLE_STOCK)    
                    
       INSERT INTO #TEMP_AVGPRICE(STOCKPRICE)    
       VALUES(@AVGOPENCLOSEPRICE)   
      END        
      ELSE     
      BEGIN     
       DELETE FROM #TEMP_MULTIPLE_STOCK            
       INSERT INTO #TEMP_AVGPRICE(STOCKPRICE,Volume,TransactionDate)    
       EXEC (@SQLTEXT)    
      END    
                        
      SELECT  @TRANS_DATE_PRICE = AVG(STOCKPRICE) FROM #TEMP_AVGPRICE       
     END    
     ELSE IF(@CALCULATE_TAX = 'rdoTentativeTax')    
     BEGIN     
      SET @EVENTDATE =(SELECT CONVERT(DATE,DATEADD(DAY, - @CALCUALTE_TAX_PRIOR_DAYS,@EVENTDATE)))     
          
       PRINT 'B1'    
       DELETE FROM #TEMP_NON_TRADING_DAYS    
       INSERT INTO #TEMP_NON_TRADING_DAYS    
       SELECT TOP 100 NonTradDay FROM NonTradingDays WHERE CONVERT(DATE, NonTradDay) <= CONVERT(DATE, @EVENTDATE) GROUP BY NonTradDay    
       ORDER BY NonTradDay DESC    
    
       SELECT @MNVAL = MIN(ID ),@MXVAL = MAX(ID) FROM #TEMP_NON_TRADING_DAYS     
    
       WHILE(@MNVAL <= @MXVAL)    
       BEGIN    
        IF ((SELECT NONTRADINGDATES FROM #TEMP_NON_TRADING_DAYS WHERE ID = @MNVAL) = @EVENTDATE)    
        BEGIN    
           SET @EVENTDATE =(SELECT CONVERT(DATE,DATEADD(DAY, - 1,@EVENTDATE)))         
        END     
        ELSE IF ((SELECT COUNT(FMVPriceID) FROM FMVSharePrices WHERE CONVERT(DATE, TransactionDate) = CONVERT(DATE,@EVENTDATE)) = 0)    
        BEGIN                
         SET @EVENTDATE =(SELECT CONVERT(DATE,DATEADD(DAY, - 1,@EVENTDATE)))     
        END    
        ELSE    
         BREAK    
        SET @MNVAL = @MNVAL + 1           
       END    
            
            
       IF( @Count > 1)       
       BEGIN    
        PRINT 'FOR MULTISELECT'    
        SET @STOCKEXCHANGECODE = NULL    
    
        SET @STOCKEXCHANGECODE = (SELECT StockExchange FROM FMVSharePrices WHERE StockExchange IN(SELECT * FROM dbo.FN_SPLIT_STRING(''+@ConcatString+'',','))AND CONVERT(DATE,TransactionDate) = CONVERT(DATE,''+ @EVENTDATE +'')    
        AND Volume IN (SELECT CASE WHEN UPPER(@TRADINGVOLUME) = 'HIGH' THEN  MAX(Volume) ELSE MIN(Volume) END AS MaxDateTime    
        FROM FMVSharePrices WHERE  StockExchange IN(SELECT * FROM dbo.FN_SPLIT_STRING(''+@ConcatString+'',',')) AND CONVERT(DATE,TransactionDate) = CONVERT(DATE,''+ @EVENTDATE +'')))               
       END       
    
       SET @SQLTEXT =  N'SELECT  ' + @STOCKPRICE + ' ,Volume,TransactionDate FROM FMVSharePrices WHERE StockExchange IN(SELECT * FROM dbo.FN_SPLIT_STRING('''+CASE WHEN @Count = 1 THEN @ConcatString ELSE  @STOCKEXCHANGECODE END+''','',''))AND CONVERT(DATE,TransactionDate) = CONVERT(DATE,'''+ @EVENTDATE +''')'     
       print @SQLTEXT    
    
       DELETE FROM #TEMP_AVGPRICE    
       DELETE FROM #TEMP_MULTIPLE_STOCK    
       IF(@STOCKPRICE = 'OpenPrice,ClosePrice' OR @STOCKPRICE = 'HighPrice,LowPrice')    
       BEGIN     
        INSERT INTO #TEMP_MULTIPLE_STOCK(STOCKOPEN_HIGHPRICE,STOCKCLOSE_LOWPRICE,Volume,TransactionDate)             
        EXEC (@SQLTEXT)     
            
        SET @AVGOPENCLOSEPRICE = 0      
        SELECT @AVGOPENCLOSEPRICE =(STOCKOPEN_HIGHPRICE + STOCKCLOSE_LOWPRICE)/2     
        FROM #TEMP_MULTIPLE_STOCK    
        WHERE Volume IN (SELECT  CASE WHEN UPPER(@TRADINGVOLUME) = 'HIGH' THEN  MAX(Volume) ELSE MIN(Volume) END FROM #TEMP_MULTIPLE_STOCK)    
                     
        INSERT INTO #TEMP_AVGPRICE(STOCKPRICE)    
        VALUES(@AVGOPENCLOSEPRICE)    
       END        
       ELSE     
       BEGIN            
        INSERT INTO #TEMP_AVGPRICE(STOCKPRICE,Volume,TransactionDate)    
        EXEC (@SQLTEXT)    
       END    
       SELECT  @TRANS_DATE_PRICE = AVG(STOCKPRICE) FROM #TEMP_AVGPRICE               
      END                     
       END   
    END     
   -- SECOND CASE --    
   ELSE IF(UPPER(@PRICEPERIODID) = 'RDOAVGOFDATEOFEVENT')    
   BEGIN    
    PRINT '2ND RDO'    
    SET @ConcatString = null      
    SET @Count = ((SELECT COUNT( * )FROM dbo.FN_SPLIT_STRING(@MSEID,',')))                             
    SELECT  @ConcatString = COALESCE(@ConcatString + ',', '') +     
      CASE STOCK_EXCHANGE_SYMBOL WHEN  'NSE'  THEN 'N' WHEN  'BSE'  THEN 'B' WHEN  'NYSE'  THEN 'N' ELSE '' END      
    FROM MST_STOCK_EXCHANGE                    
    WHERE CONVERT(VARCHAR(50), MSE_ID) IN(SELECT * FROM dbo.FN_SPLIT_STRING(@MSEID,','))                   
    
    IF(@TRANSACTIONDATE = 'GrantDate')               
     SET @EVENTDATE = CASE WHEN(@PRICEDAY = 'Prior Day' )THEN CASE WHEN(@CALCULATE_TAX = 'rdoTentativeTax') THEN @GRANTDATE ELSE DATEADD(D,-1,@GRANTDATE) END ELSE  @GRANTDATE END                  
    ELSE IF(@TRANSACTIONDATE = 'FinalVestingDate')           
     SET @EVENTDATE = CASE WHEN(@PRICEDAY = 'Prior Day' )THEN CASE WHEN(@CALCULATE_TAX = 'rdoTentativeTax')THEN @VESTINGDATE ELSE DATEADD(D,-1,@VESTINGDATE)END ELSE  @VESTINGDATE END                      
    ELSE IF(@TRANSACTIONDATE = 'ExerciseDate')    
     SET @EVENTDATE = CASE WHEN(@PRICEDAY = 'Prior Day' )THEN CASE WHEN(@CALCULATE_TAX = 'rdoTentativeTax') THEN @EXERCISE_DATE ELSE DATEADD(D,-1,@EXERCISE_DATE) END ELSE  @EXERCISE_DATE END     
    
    -- SET TENTATIVE/ACTUAL FLAG  --      
    IF(@ISTRADINGDAYS = 0)    
    BEGIN     
     SET @TAXFLAG = CASE WHEN ((SELECT COUNT(FMVPriceID) from FMVSharePrices WHERE CONVERT(DATE,TransactionDate) = CONVERT(DATE,@EVENTDATE)) = 0) THEN 'T' ELSE 'A' END                         
     SET @TAXFLAG_HEADER = CASE WHEN ((SELECT COUNT(FMVPriceID) from FMVSharePrices WHERE CONVERT(DATE,TransactionDate) = CONVERT(DATE,@EVENTDATE)) = 0) THEN 'T' ELSE 'A' END                    
    END    
    ELSE IF (@ISTRADINGDAYS = 1)    
    BEGIN         
     IF(@PRICEDAY = 'Prior Day' )    
     BEGIN    
      SET @TAXFLAG = 'A'    
      SET @TAXFLAG_HEADER = 'A'    
     END     
     ELSE IF(@PRICEDAY = 'Same Day' )    
     BEGIN             
       SET @TAXFLAG = CASE WHEN ((SELECT COUNT(FMVPriceID) from FMVSharePrices WHERE CONVERT(DATE,TransactionDate) = CONVERT(DATE,@EVENTDATE)) = 0) THEN 'T' ELSE 'A' END                  
      SET @TAXFLAG_HEADER = CASE WHEN ((SELECT COUNT(FMVPriceID) from FMVSharePrices WHERE CONVERT(DATE,TransactionDate) = CONVERT(DATE,@EVENTDATE)) = 0) THEN 'T' ELSE 'A' END                  
     END    
    END     
               
         IF(@CALCULATE_TAX = 'rdoTentativeTax')    
      BEGIN          
       SET @TAXFLAG = @TEMP_TAXFLAG     
       IF(@TEMP_TAXFLAG = 'A')    
       BEGIN                 
       IF NOT EXISTS(SELECT FMVPriceID FROM FMVSharePrices WHERE TransactionDate = CONVERT(DATE,@EVENTDATE))    
       BEGIN         
         SET @TAXFLAG = '0'    
       END          
       END    
           
        IF(@TEMP_TAXFLAG = 'T')            
         SET @EVENTDATE =(SELECT CONVERT(DATE,DATEADD(DAY, - @CALCUALTE_TAX_PRIOR_DAYS,@EVENTDATE)))    
    
      DELETE FROM #TEMP_NON_TRADING_DAYS    
      INSERT INTO #TEMP_NON_TRADING_DAYS    
      SELECT TOP 100 NonTradDay FROM NonTradingDays WHERE CONVERT(DATE, NonTradDay) <= CONVERT(DATE, @EVENTDATE )GROUP BY NonTradDay    
      ORDER BY NonTradDay DESC    
    
      SELECT @MNVAL = MIN(ID ),@MXVAL = MAX(ID) FROM #TEMP_NON_TRADING_DAYS     
                         
      WHILE(@MNVAL <= @MXVAL)    
      BEGIN                              
       IF ((SELECT NONTRADINGDATES FROM #TEMP_NON_TRADING_DAYS WHERE ID = @MNVAL) = @EVENTDATE)                 
       BEGIN             
        SET @EVENTDATE =(SELECT CONVERT(DATE,DATEADD(DAY, - 1,@EVENTDATE)))         
       END     
       ELSE IF  ((SELECT COUNT(FMVPriceID) FROM FMVSharePrices WHERE CONVERT(DATE, TransactionDate) = CONVERT(DATE, @EVENTDATE)) = 0)    
       BEGIN                
        SET @EVENTDATE =(SELECT CONVERT(DATE,DATEADD(DAY, - 1,@EVENTDATE)))     
       END    
       ELSE    
        BREAK    
       SET @MNVAL = @MNVAL + 1     
      END                
     END    
    
    INSERT INTO #TEMP_FILTER_CALENDERDAYS          
    SELECT * FROM FN_ACC_EXPLODE_DATES(CONVERT(date, dateadd(D,- CONVERT(INT, @PRICEDAYS),@EVENTDATE)), CONVERT(date, @EVENTDATE)) ORDER BY 1 desc;    
    
    SET @SQLQUERY ='SELECT TOP '+ CONVERT(VARCHAR(50), @PRICEDAYS)+' * FROM #TEMP_FILTER_CALENDERDAYS'      
    /*print @SQLQUERY*/    
    INSERT INTO #TEMP_CALENDERDAYS    
    EXEC sp_executesql @SQLQUERY    
                         
    SELECT @MAXVALUE = Max(id),@MINVALUE = MIN(id) FROM #TEMP_CALENDERDAYS                 
    SET @STARTDATE = (SELECT CALENDERDATES FROM #TEMP_CALENDERDAYS  WHERE id = @MAXVALUE)     
    SET @ENDATE = (SELECT CALENDERDATES FROM #TEMP_CALENDERDAYS  WHERE id = @MINVALUE)     
                   
    IF( @Count > 1)       
    BEGIN    
     PRINT 'FOR MULTISELECT'    
     SET @STOCKEXCHANGECODE = NULL    
     SET @STOCKEXCHANGECODE = (SELECT StockExchange FROM FMVSharePrices WHERE StockExchange IN(SELECT * FROM dbo.FN_SPLIT_STRING(''+@ConcatString+'',','))AND CONVERT(DATE,TransactionDate) = CONVERT(DATE,''+ @EVENTDATE +'')    
     AND Volume IN (SELECT CASE WHEN UPPER(@TRADINGVOLUME) = 'HIGH' THEN  MAX(Volume) ELSE MIN(Volume) END AS MaxDateTime    
     FROM FMVSharePrices WHERE  StockExchange IN(SELECT * FROM dbo.FN_SPLIT_STRING(''+@ConcatString+'',','))AND CONVERT(DATE,TransactionDate) = CONVERT(DATE,''+ @EVENTDATE +'')))                       
         
      IF ( ISNULL(@STOCKEXCHANGECODE, '') = '' )     
      BEGIN                    
    IF EXISTS (SELECT TOP 1 TransactionDate  FROM  FMVSharePrices where TransactionDate <=  CONVERT(DATE,''+ @EVENTDATE +'') ORDER BY TransactionDate DESC)                                      
    SET @TEMP_EVENTDATE =(SELECT TOP 1 TransactionDate  FROM  FMVSharePrices where TransactionDate <=  CONVERT(DATE,''+ @EVENTDATE +'') ORDER BY TransactionDate DESC)                                                     
    ELSE    
    SET @TEMP_EVENTDATE =(SELECT TOP 1 TransactionDate  FROM  FMVSharePrices where TransactionDate >=  CONVERT(DATE,''+ @EVENTDATE +''))                                       
               
     SET @STOCKEXCHANGECODE = (SELECT StockExchange FROM FMVSharePrices WHERE StockExchange IN(SELECT * FROM dbo.FN_SPLIT_STRING(''+@ConcatString+'',','))AND CONVERT(DATE,TransactionDate) = CONVERT(DATE,''+ @TEMP_EVENTDATE +'')    
    AND Volume IN (SELECT CASE WHEN UPPER(@TRADINGVOLUME) = 'HIGH' THEN  MAX(Volume) ELSE MIN(Volume) END AS MaxDateTime    
    FROM FMVSharePrices WHERE  StockExchange IN(SELECT * FROM dbo.FN_SPLIT_STRING(''+@ConcatString+'',','))AND CONVERT(DATE,TransactionDate) = CONVERT(DATE,''+ @TEMP_EVENTDATE +'')))                                       
    SET @EVENTDATE = @TEMP_EVENTDATE    
      END    
             /* Print @EVENTDATE*/    
             /*Print @STOCKEXCHANGECODE*/    
         
    END    
       
	SET @SQLTEXT = N'SELECT TOP '+ CONVERT(VARCHAR(50), @PRICEDAYS)+' ' + @STOCKPRICE + ' ,Volume,StockExchange,TransactionDate FROM FMVSharePrices WHERE StockExchange IN(SELECT * FROM dbo.FN_SPLIT_STRING('''+  CASE WHEN @Count = 1 THEN @ConcatString ELSE  @STOCKEXCHANGECODE END+''','',''))
    AND (CONVERT(DATE,TransactionDate) <= CONVERT(DATE,'''+  @ENDATE+''') AND CONVERT(DATE, TransactionDate) >=  CONVERT(DATE,'''+  @STARTDATE+''')) ORDER BY TransactionDate DESC'          
                     
     DELETE FROM #TEMP_AVGPRICE    
     IF(@STOCKPRICE = 'OpenPrice,ClosePrice' OR @STOCKPRICE = 'HighPrice,LowPrice')    
     BEGIN     
     DELETE FROM #TEMP_MULTIPLE_STOCK     
     INSERT INTO #TEMP_MULTIPLE_STOCK(STOCKOPEN_HIGHPRICE,STOCKCLOSE_LOWPRICE,Volume,StockExchange,TransactionDate)             
     EXEC (@SQLTEXT)     
            
     INSERT INTO #TEMP_AVGPRICE(STOCKPRICE)    
     SELECT (STOCKOPEN_HIGHPRICE + STOCKCLOSE_LOWPRICE)/2  FROM #TEMP_MULTIPLE_STOCK        
     END      
     ELSE     
     BEGIN            
     INSERT INTO #TEMP_AVGPRICE(STOCKPRICE,Volume,StockExchange,TransactionDate)    
     EXEC (@SQLTEXT)    
     END    
    
     SELECT  @TRANS_DATE_PRICE = (SELECT AVG(STOCKPRICE) AS FMVPRICE FROM #TEMP_AVGPRICE)                          
   END    
   --THIRD CASE --    
   ELSE IF(UPPER(@PRICEPERIODID) = 'RDOAVGOFCALENDERDAYSFORALL')     
   BEGIN    
    SET @ConcatString = Null      
    PRINT '3RD RDO'    
    SET @Count = ((SELECT COUNT( * )FROM dbo.FN_SPLIT_STRING(@MSEID,',')))                             
    SELECT  @ConcatString = COALESCE(@ConcatString + ',', '') +     
    CASE STOCK_EXCHANGE_SYMBOL   WHEN  'NSE'  THEN 'N'   WHEN  'BSE'  THEN 'B'    WHEN  'NYSE'  THEN 'N'ELSE '' END     
    FROM MST_STOCK_EXCHANGE                    
    WHERE CONVERT(VARCHAR(50), MSE_ID) IN(SELECT * FROM dbo.FN_SPLIT_STRING(@MSEID,','))                        
                 
    IF(@TRANSACTIONDATE = 'GrantDate')               
     SET @EVENTDATE = CASE WHEN(@PRICEDAY = 'Prior Day' )THEN CASE WHEN(@CALCULATE_TAX = 'rdoTentativeTax') THEN @GRANTDATE ELSE DATEADD(D,-1,@GRANTDATE) END ELSE  @GRANTDATE END                  
    ELSE IF(@TRANSACTIONDATE = 'FinalVestingDate')           
     SET @EVENTDATE = CASE WHEN(@PRICEDAY = 'Prior Day' )THEN CASE WHEN(@CALCULATE_TAX = 'rdoTentativeTax')THEN @VESTINGDATE ELSE DATEADD(D,-1,@VESTINGDATE)END ELSE  @VESTINGDATE END                      
    ELSE IF(@TRANSACTIONDATE = 'ExerciseDate')    
     SET @EVENTDATE = CASE WHEN(@PRICEDAY = 'Prior Day' )THEN CASE WHEN(@CALCULATE_TAX = 'rdoTentativeTax') THEN @EXERCISE_DATE ELSE DATEADD(D,-1,@EXERCISE_DATE) END ELSE  @EXERCISE_DATE END     
    
    -- SET TENTATIVE/ACTUAL FLAG  --           
    IF(@ISTRADINGDAYS = 0)    
    BEGIN     
     SET @TAXFLAG = CASE WHEN ((SELECT COUNT(FMVPriceID) from FMVSharePrices WHERE CONVERT(DATE,TransactionDate) = CONVERT(DATE,@EVENTDATE)) = 0) THEN 'T' ELSE 'A' END                    
     SET @TAXFLAG_HEADER = CASE WHEN ((SELECT COUNT(FMVPriceID) from FMVSharePrices WHERE CONVERT(DATE,TransactionDate) = CONVERT(DATE,@EVENTDATE)) = 0) THEN 'T' ELSE 'A' END                    
    END    
    ELSE IF (@ISTRADINGDAYS = 1)    
    BEGIN         
     IF(@PRICEDAY = 'Prior Day' )    
     BEGIN    
      SET @TAXFLAG_HEADER = 'A'    
      SET @TAXFLAG = 'A'     
     END     
     ELSE IF(@PRICEDAY = 'Same Day' )    
     BEGIN    
      SET @TAXFLAG = CASE WHEN ((SELECT COUNT(FMVPriceID) from FMVSharePrices WHERE CONVERT(DATE,TransactionDate) = CONVERT(DATE,@EVENTDATE)) = 0) THEN 'T' ELSE 'A' END                           
      SET @TAXFLAG_HEADER = CASE WHEN ((SELECT COUNT(FMVPriceID) from FMVSharePrices WHERE CONVERT(DATE,TransactionDate) = CONVERT(DATE,@EVENTDATE)) = 0) THEN 'T' ELSE 'A' END                  
     END    
    END     
             
       -----IF PRICE IS NOT AVAILABLE -----------                       
    
       IF(@CALCULATE_TAX = 'rdoTentativeTax')    
     BEGIN          
       SET @TAXFLAG = @TEMP_TAXFLAG     
       IF(@TEMP_TAXFLAG = 'A')    
       BEGIN                 
       IF NOT EXISTS(SELECT FMVPriceID FROM FMVSharePrices WHERE TransactionDate = CONVERT(DATE,@EVENTDATE))    
       BEGIN         
         SET @TAXFLAG = '0'    
       END          
       END    
           
        IF(@TEMP_TAXFLAG = 'T')            
         SET @EVENTDATE =(SELECT CONVERT(DATE,DATEADD(DAY, - @CALCUALTE_TAX_PRIOR_DAYS,@EVENTDATE)))                 
         
             
      DELETE FROM #TEMP_NON_TRADING_DAYS    
      INSERT INTO #TEMP_NON_TRADING_DAYS    
      SELECT TOP 100 NonTradDay FROM NonTradingDays WHERE CONVERT(DATE, NonTradDay) <= CONVERT(DATE, @EVENTDATE )GROUP BY NonTradDay    
      ORDER BY NonTradDay DESC    
    
      SELECT @MNVAL = MIN(ID ),@MXVAL = MAX(ID) FROM #TEMP_NON_TRADING_DAYS     
                         
      WHILE(@MNVAL <= @MXVAL)    
      BEGIN                              
       IF ((SELECT NONTRADINGDATES FROM #TEMP_NON_TRADING_DAYS WHERE ID = @MNVAL) = @EVENTDATE)                 
       BEGIN             
        SET @EVENTDATE =(SELECT CONVERT(DATE,DATEADD(DAY, - 1,@EVENTDATE)))         
       END     
       ELSE IF  ((SELECT COUNT(FMVPriceID) FROM FMVSharePrices WHERE  CONVERT(DATE,TransactionDate )= CONVERT(DATE, @EVENTDATE)) = 0)    
       BEGIN                
        SET @EVENTDATE =(SELECT CONVERT(DATE,DATEADD(DAY, - 1,@EVENTDATE)))     
       END    
       ELSE    
        BREAK    
       SET @MNVAL = @MNVAL + 1     
      END                 
       END    
              
    INSERT INTO #TEMP_FILTER_CALENDERDAYS          
    SELECT * FROM FN_ACC_EXPLODE_DATES(CONVERT(date, dateadd(D,- CONVERT(INT, @PRICEDAYS),@EVENTDATE)), CONVERT(date, @EVENTDATE)) ORDER BY 1 desc;    
    
    SET @SQLQUERY ='SELECT TOP '+ CONVERT(VARCHAR(50), @PRICEDAYS)+' * FROM #TEMP_FILTER_CALENDERDAYS'      
    
    INSERT INTO #TEMP_CALENDERDAYS    
    EXEC sp_executesql @SQLQUERY    
    
    SELECT @MAXVALUE = Max(id),@MINVALUE = MIN(id) FROM #TEMP_CALENDERDAYS                 
    SET @STARTDATE = (SELECT CALENDERDATES FROM #TEMP_CALENDERDAYS  WHERE id = @MAXVALUE)     
    SET @ENDATE = (SELECT CALENDERDATES FROM #TEMP_CALENDERDAYS  WHERE id = @MINVALUE)     
    
    IF(@Count = 1)    
    BEGIN                   
     SET @SQLTEXT = N'SELECT TOP '+ CONVERT(VARCHAR(50), @PRICEDAYS)+' ' + @STOCKPRICE + ' ,Volume,StockExchange,TransactionDate FROM FMVSharePrices WHERE StockExchange IN(SELECT * FROM dbo.FN_SPLIT_STRING('''+ @ConcatString +''','','')) AND (CONVERT(DATE
,TransactionDate) <=  CONVERT(DATE, '''+  @ENDATE+''') AND CONVERT(DATE,TransactionDate) >=  CONVERT(DATE,'''+  @STARTDATE+''')) ORDER BY TransactionDate DESC'                        
    END    
    ELSE    
    BEGIN           
     SET @SQLTEXT = N'SELECT   ' + @STOCKPRICE + ' ,Volume,StockExchange,TransactionDate FROM FMVSharePrices WHERE StockExchange IN(SELECT * FROM dbo.FN_SPLIT_STRING('''+ @ConcatString +''','','')) AND (CONVERT(DATE, TransactionDate) <= CONVERT(DATE, '''+
  @ENDATE+''') AND CONVERT(DATE,TransactionDate) >= CONVERT (DATE,'''+  @STARTDATE+'''))     
     AND Volume IN (SELECT CASE WHEN UPPER('''+@TRADINGVOLUME+''') = ''HIGH'' THEN  MAX(Volume) ELSE MIN(Volume)END FROM FMVSharePrices WHERE StockExchange IN(SELECT * FROM dbo.FN_SPLIT_STRING('''+ @ConcatString +''','','')) AND (  CONVERT(DATE, Transacti
onDate) <= CONVERT(DATE, '''+  @ENDATE+''') AND CONVERT(DATE, TransactionDate) >=  CONVERT(DATE, '''+  @STARTDATE+''')) GROUP BY TransactionDate)     
     ORDER BY TransactionDate DESC'     
    END    
    
    
    DELETE FROM #TEMP_AVGPRICE    
    IF(@STOCKPRICE = 'OpenPrice,ClosePrice' OR @STOCKPRICE = 'HighPrice,LowPrice')    
    BEGIN      
     PRINT 'multiple stock exchange'    
     DELETE FROM #TEMP_MULTIPLE_STOCK    
     INSERT INTO #TEMP_MULTIPLE_STOCK(STOCKOPEN_HIGHPRICE,STOCKCLOSE_LOWPRICE,Volume,StockExchange,TransactionDate)             
     EXEC (@SQLTEXT)     
    
     INSERT INTO #TEMP_AVGPRICE(STOCKPRICE)    
     SELECT (STOCKOPEN_HIGHPRICE + STOCKCLOSE_LOWPRICE)/2  FROM #TEMP_MULTIPLE_STOCK        
    END      
    ELSE     
    BEGIN            
     INSERT INTO #TEMP_AVGPRICE(STOCKPRICE,Volume,StockExchange,TransactionDate)    
     EXEC (@SQLTEXT)           
    END    
    
      SELECT  @TRANS_DATE_PRICE = (SELECT AVG(STOCKPRICE) AS FMVPRICE FROM #TEMP_AVGPRICE)                 
   END    
   --FOURTH CASE --       
   ELSE IF(UPPER(@PRICEPERIODID) = 'RDOAVGOFTRADINGDAYDATE')    
   BEGIN    
    PRINT '4TH CASE'    
    SET @ConcatString = Null    
    SET @Count = ((SELECT COUNT( * )FROM dbo.FN_SPLIT_STRING(@MSEID,',')))                             
    SELECT  @ConcatString = COALESCE(@ConcatString + ',', '') +     
    CASE STOCK_EXCHANGE_SYMBOL WHEN  'NSE'  THEN 'N' WHEN  'BSE'  THEN 'B'  WHEN  'NYSE'  THEN 'N' ELSE '' END      
    FROM MST_STOCK_EXCHANGE                    
    WHERE CONVERT(VARCHAR(50), MSE_ID) IN(SELECT * FROM dbo.FN_SPLIT_STRING(@MSEID,','))                   
    
    IF(@TRANSACTIONDATE = 'GrantDate')               
     SET @EVENTDATE = CASE WHEN(@PRICEDAY = 'Prior Day' )THEN CASE WHEN(@CALCULATE_TAX = 'rdoTentativeTax') THEN @GRANTDATE ELSE DATEADD(D,-1,@GRANTDATE) END ELSE  @GRANTDATE END                  
    ELSE IF(@TRANSACTIONDATE = 'FinalVestingDate')           
     SET @EVENTDATE = CASE WHEN(@PRICEDAY = 'Prior Day' )THEN CASE WHEN(@CALCULATE_TAX = 'rdoTentativeTax')THEN @VESTINGDATE ELSE DATEADD(D,-1,@VESTINGDATE)END ELSE  @VESTINGDATE END                      
    ELSE IF(@TRANSACTIONDATE = 'ExerciseDate')    
     SET @EVENTDATE = CASE WHEN(@PRICEDAY = 'Prior Day' )THEN CASE WHEN(@CALCULATE_TAX = 'rdoTentativeTax') THEN @EXERCISE_DATE ELSE DATEADD(D,-1,@EXERCISE_DATE) END ELSE  @EXERCISE_DATE END     
    
               
    -- SET TENTATIVE/ACTUAL FLAG  --      
    IF(@ISTRADINGDAYS = 0)    
    BEGIN    
     SET @TAXFLAG = CASE WHEN ((SELECT COUNT(FMVPriceID) from FMVSharePrices WHERE CONVERT(DATE,TransactionDate) = CONVERT(DATE,@EVENTDATE)) = 0) THEN 'T' ELSE 'A' END                     
     SET @TAXFLAG_HEADER = CASE WHEN ((SELECT COUNT(FMVPriceID) from FMVSharePrices WHERE CONVERT(DATE,TransactionDate) = CONVERT(DATE,@EVENTDATE)) = 0) THEN 'T' ELSE 'A' END                    
    END    
    ELSE IF (@ISTRADINGDAYS = 1)    
     BEGIN    
     IF(@PRICEDAY = 'Prior Day' )    
     BEGIN    
      SET @TAXFLAG_HEADER = 'A'    
      SET @TAXFLAG = 'A'    
     END     
     ELSE IF(@PRICEDAY = 'Same Day' )    
     BEGIN     
        SET @TAXFLAG = CASE WHEN ((SELECT COUNT(FMVPriceID) from FMVSharePrices WHERE CONVERT(DATE,TransactionDate) = CONVERT(DATE,@EVENTDATE)) = 0) THEN 'T' ELSE 'A' END                       
      SET @TAXFLAG_HEADER = CASE WHEN ((SELECT COUNT(FMVPriceID) from FMVSharePrices WHERE CONVERT(DATE,TransactionDate) = CONVERT(DATE,@EVENTDATE)) = 0) THEN 'T' ELSE 'A' END                  
     END    
    END     
    
                 
       IF(@CALCULATE_TAX = 'rdoTentativeTax')    
     BEGIN    
      SET @TAXFLAG = @TEMP_TAXFLAG     
       IF(@TEMP_TAXFLAG = 'A')    
       BEGIN                 
       IF NOT EXISTS(SELECT FMVPriceID FROM FMVSharePrices WHERE TransactionDate = CONVERT(DATE,@EVENTDATE))    
       BEGIN         
         SET @TAXFLAG = '0'    
       END          
       END    
           
        IF(@TEMP_TAXFLAG = 'T')            
         SET @EVENTDATE =(SELECT CONVERT(DATE,DATEADD(DAY, - @CALCUALTE_TAX_PRIOR_DAYS,@EVENTDATE)))    
         
      DELETE FROM #TEMP_NON_TRADING_DAYS    
      INSERT INTO #TEMP_NON_TRADING_DAYS    
      SELECT TOP 100 NonTradDay FROM NonTradingDays WHERE CONVERT(DATE, NonTradDay) <= CONVERT(DATE, @EVENTDATE )GROUP BY NonTradDay    
      ORDER BY NonTradDay DESC    
    
      SELECT @MNVAL = MIN(ID ),@MXVAL = MAX(ID) FROM #TEMP_NON_TRADING_DAYS     
                         
      WHILE(@MNVAL <= @MXVAL)    
      BEGIN                              
       IF ((SELECT NONTRADINGDATES FROM #TEMP_NON_TRADING_DAYS WHERE ID = @MNVAL) = @EVENTDATE)                 
       BEGIN             
        SET @EVENTDATE =(SELECT CONVERT(DATE,DATEADD(DAY, - 1,@EVENTDATE)))         
       END     
       ELSE IF  ((SELECT COUNT(FMVPriceID) FROM FMVSharePrices WHERE TransactionDate = @EVENTDATE) = 0)    
       BEGIN                
        SET @EVENTDATE =(SELECT CONVERT(DATE,DATEADD(DAY, - 1,@EVENTDATE)))     
       END    
       ELSE    
        BREAK    
       SET @MNVAL = @MNVAL + 1     
      END     
              
               
    END    
    IF( @Count > 1)       
    BEGIN    
     PRINT 'FOR MULTISELECT'    
     SET @STOCKEXCHANGECODE = NULL    
     SET @STOCKEXCHANGECODE = (SELECT StockExchange FROM FMVSharePrices WHERE StockExchange IN(SELECT * FROM dbo.FN_SPLIT_STRING(''+@ConcatString+'',','))AND CONVERT(DATE, TransactionDate) = CONVERT(DATE, ''+ @EVENTDATE +'')    
     AND Volume IN (SELECT CASE WHEN UPPER(@TRADINGVOLUME) = 'HIGH' THEN  MAX(Volume) ELSE MIN(Volume) END AS MaxDateTime    
     FROM FMVSharePrices WHERE  StockExchange IN(SELECT * FROM dbo.FN_SPLIT_STRING(''+@ConcatString+'',','))AND CONVERT(DATE, TransactionDate) =CONVERT(DATE, ''+ @EVENTDATE +'')))         
    END    
    
    SET @SQLQUERY = 'SELECT TOP '+ CONVERT(VARCHAR(50), @PRICEDAYS)+' TransactionDate FROM FMVSharePrices WHERE StockExchange IN(SELECT * FROM dbo.FN_SPLIT_STRING('''+CASE WHEN @Count = 1 THEN @ConcatString ELSE  @STOCKEXCHANGECODE END+''','','')) AND CONVERT(DATE, TransactionDate) <= CONVERT(DATE,'''+  @EVENTDATE+''' ) ORDER BY TransactionDate DESC'        
    PRINT @SQLQUERY    
        
    INSERT INTO #TEMP_TRADINGDAYS        
    EXEC (@SQLQUERY)      
    
    SELECT @MAXVALUE = Max(id),@MINVALUE = MIN(id) FROM #TEMP_TRADINGDAYS      
                 
    SET @STARTDATE = (SELECT TRADINGDATES FROM #TEMP_TRADINGDAYS  WHERE id = @MAXVALUE)     
    SET @ENDATE = (SELECT TRADINGDATES FROM #TEMP_TRADINGDAYS  WHERE id = @MINVALUE)           
    
    SET @SQLTEXT = N'SELECT TOP '+ CONVERT(VARCHAR(50), @PRICEDAYS)+' ' + @STOCKPRICE + ' ,Volume,StockExchange,TransactionDate FROM FMVSharePrices WHERE StockExchange IN(SELECT * FROM dbo.FN_SPLIT_STRING('''+CASE WHEN @Count = 1 THEN @ConcatString ELSE  
@STOCKEXCHANGECODE END+''','','')) AND ( CONVERT(DATE, TransactionDate) <= CONVERT(DATE, '''+  @ENDATE+''') AND CONVERT(DATE, TransactionDate )>=  CONVERT(DATE, '''+  @STARTDATE+''')) ORDER BY TransactionDate DESC'          
    -- PRINT  N'SELECT TOP '+ CONVERT(VARCHAR(50), @PRICEDAYS)+' ' + @STOCKPRICE + ' ,Volume FROM FMVSharePrices WHERE StockExchange IN(SELECT * FROM dbo.FN_SPLIT_STRING('''+@ConcatString+''','','')) AND TransactionDate <= '''+ @EVENTDATE+''' AND TransactionDate >=  CONVERT(date, dateadd(D, -'+ CONVERT(VARCHAR(50), @PRICEDAYS)+','''+ @EVENTDATE+''')) ORDER BY FMVPriceID DESC'       
    
    DELETE FROM #TEMP_AVGPRICE    
    IF(@STOCKPRICE = 'OpenPrice,ClosePrice' OR @STOCKPRICE = 'HighPrice,LowPrice')    
    BEGIN     
     DELETE FROM #TEMP_MULTIPLE_STOCK     
     INSERT INTO #TEMP_MULTIPLE_STOCK(STOCKOPEN_HIGHPRICE,STOCKCLOSE_LOWPRICE,Volume,StockExchange,TransactionDate)             
     EXEC (@SQLTEXT)        
              
     INSERT INTO #TEMP_AVGPRICE(STOCKPRICE)    
     SELECT (STOCKOPEN_HIGHPRICE + STOCKCLOSE_LOWPRICE)/2  FROM #TEMP_MULTIPLE_STOCK        
    END      
    ELSE     
    BEGIN            
     INSERT INTO #TEMP_AVGPRICE(STOCKPRICE,Volume,StockExchange,TransactionDate)    
     EXEC (@SQLTEXT)    
     END    
    
    SELECT  @TRANS_DATE_PRICE = (SELECT AVG(STOCKPRICE) AS FMVPRICE FROM #TEMP_AVGPRICE )     
   END    
   ----FIFTH CASE --    
   ELSE IF(UPPER(@PRICEPERIODID) = 'RDOAVGOFTRADINGALLDAY')      
   BEGIN    
    PRINT '5TH CASE'    
    SET @ConcatString = Null    
    SET @Count = ((SELECT COUNT( * )FROM dbo.FN_SPLIT_STRING(@MSEID,',')))                             
    SELECT  @ConcatString = COALESCE(@ConcatString + ',', '') +     
    CASE STOCK_EXCHANGE_SYMBOL WHEN  'NSE'  THEN 'N' WHEN  'BSE'  THEN 'B'    WHEN  'NYSE'  THEN 'N'ELSE '' END    
    FROM MST_STOCK_EXCHANGE                    
    WHERE CONVERT(VARCHAR(50), MSE_ID) IN(SELECT * FROM dbo.FN_SPLIT_STRING(@MSEID,','))                   
    
        
    IF(@TRANSACTIONDATE = 'GrantDate')               
     SET @EVENTDATE = CASE WHEN(@PRICEDAY = 'Prior Day' )THEN CASE WHEN(@CALCULATE_TAX = 'rdoTentativeTax') THEN @GRANTDATE ELSE DATEADD(D,-1,@GRANTDATE) END ELSE  @GRANTDATE END                  
    ELSE IF(@TRANSACTIONDATE = 'FinalVestingDate')           
     SET @EVENTDATE = CASE WHEN(@PRICEDAY = 'Prior Day' )THEN CASE WHEN(@CALCULATE_TAX = 'rdoTentativeTax')THEN @VESTINGDATE ELSE DATEADD(D,-1,@VESTINGDATE)END ELSE  @VESTINGDATE END                      
    ELSE IF(@TRANSACTIONDATE = 'ExerciseDate')    
     SET @EVENTDATE = CASE WHEN(@PRICEDAY = 'Prior Day' )THEN CASE WHEN(@CALCULATE_TAX = 'rdoTentativeTax') THEN @EXERCISE_DATE ELSE DATEADD(D,-1,@EXERCISE_DATE) END ELSE  @EXERCISE_DATE END     
    
    -- SET TENTATIVE/ACTUAL FLAG  --        
    IF(@ISTRADINGDAYS = 0)    
    BEGIN     
     SET @TAXFLAG = CASE WHEN ((SELECT COUNT(FMVPriceID) from FMVSharePrices WHERE CONVERT(DATE,TransactionDate) = CONVERT(DATE,@EVENTDATE)) = 0) THEN 'T' ELSE 'A' END                    
     SET @TAXFLAG_HEADER = CASE WHEN ((SELECT COUNT(FMVPriceID) from FMVSharePrices WHERE CONVERT(DATE,TransactionDate) = CONVERT(DATE,@EVENTDATE)) = 0) THEN 'T' ELSE 'A' END                    
    END    
    ELSE IF (@ISTRADINGDAYS = 1)    
    BEGIN    
     IF(@PRICEDAY = 'Prior Day' )    
     BEGIN    
      SET @TAXFLAG_HEADER = 'A'    
        SET @TAXFLAG = 'A'    
      END      
     ELSE IF(@PRICEDAY = 'Same Day' )    
     BEGIN    
     SET @TAXFLAG = CASE WHEN ((SELECT COUNT(FMVPriceID) from FMVSharePrices WHERE CONVERT(DATE,TransactionDate) = CONVERT(DATE,@EVENTDATE)) = 0) THEN 'T' ELSE 'A' END                         
      SET @TAXFLAG_HEADER = CASE WHEN ((SELECT COUNT(FMVPriceID) from FMVSharePrices WHERE CONVERT(DATE,TransactionDate) = CONVERT(DATE,@EVENTDATE)) = 0) THEN 'T' ELSE 'A' END                  
     END    
    END         
    
       
       IF(@CALCULATE_TAX = 'rdoTentativeTax')    
     BEGIN          
        SET @EVENTDATE =(SELECT CONVERT(DATE,DATEADD(DAY, - @CALCUALTE_TAX_PRIOR_DAYS,@EVENTDATE)))              
               
      DELETE FROM #TEMP_NON_TRADING_DAYS    
      INSERT INTO #TEMP_NON_TRADING_DAYS    
      SELECT TOP 100 NonTradDay FROM NonTradingDays WHERE CONVERT(DATE, NonTradDay) <= CONVERT(DATE, @EVENTDATE) GROUP BY NonTradDay    
      ORDER BY NonTradDay DESC    
    
      SELECT @MNVAL = MIN(ID ),@MXVAL = MAX(ID) FROM #TEMP_NON_TRADING_DAYS     
                         
      WHILE(@MNVAL <= @MXVAL)    
      BEGIN                              
       IF ((SELECT NONTRADINGDATES FROM #TEMP_NON_TRADING_DAYS WHERE ID = @MNVAL) = @EVENTDATE)                 
       BEGIN             
        SET @EVENTDATE =(SELECT CONVERT(DATE,DATEADD(DAY, - 1,@EVENTDATE)))         
       END     
       ELSE IF  ((SELECT COUNT(FMVPriceID) FROM FMVSharePrices WHERE CONVERT(DATE,TransactionDate) =  CONVERT(DATE, @EVENTDATE)) = 0)    
       BEGIN                
        SET @EVENTDATE =(SELECT CONVERT(DATE,DATEADD(DAY, - 1,@EVENTDATE)))     
       END    
       ELSE    
        BREAK    
       SET @MNVAL = @MNVAL + 1     
      END                            
     END    
    
    
    IF(@Count = 1)       
    BEGIN    
     SET @SQLQUERY = 'SELECT TOP '+ CONVERT(VARCHAR(50), @PRICEDAYS)+' TransactionDate FROM FMVSharePrices WHERE StockExchange IN(SELECT * FROM dbo.FN_SPLIT_STRING('''+@ConcatString+''','','')) AND CONVERT(DATE,TransactionDate) <= CONVERT(DATE,'''+  @EVENTDATE+''' ) ORDER BY TransactionDate DESC'          
     PRINT @SQLQUERY           
    END                    
    ELSE    
    BEGIN      
     SET @SQLQUERY = 'SELECT TOP '+ CONVERT(VARCHAR(50), @PRICEDAYS)+' TransactionDate FROM FMVSharePrices    
     WHERE StockExchange IN(SELECT * FROM dbo.FN_SPLIT_STRING('''+@ConcatString+''','',''))                 
     AND CONVERT(DATE,TransactionDate) <= CONVERT(DATE,'''+  @EVENTDATE+''') AND Volume IN (SELECT CASE WHEN UPPER('''+@TRADINGVOLUME+''') = ''HIGH'' THEN  MAX(Volume) ELSE MIN(Volume)END FROM  FMVSharePrices    
     WHERE StockExchange IN(SELECT * FROM dbo.FN_SPLIT_STRING('''+@ConcatString+''','','')) AND CONVERT(DATE,TransactionDate) <=CONVERT(DATE, '''+  @EVENTDATE+''') GROUP BY TransactionDate )           
     ORDER BY TransactionDate DESC'     
    END    
        
    INSERT INTO #TEMP_TRADINGDAYS     
    EXEC (@SQLQUERY)        
              
    SELECT @MAXVALUE = Max(id),@MINVALUE = MIN(id) FROM #TEMP_TRADINGDAYS                 
    SET @STARTDATE = (SELECT TRADINGDATES FROM #TEMP_TRADINGDAYS  WHERE id = @MAXVALUE)     
    SET @ENDATE = (SELECT TRADINGDATES FROM #TEMP_TRADINGDAYS  WHERE id = @MINVALUE)       
    
    IF(@Count = 1)       
    BEGIN    
     SET @SQLTEXT = N'SELECT TOP '+ CONVERT(VARCHAR(50), @PRICEDAYS)+' ' + @STOCKPRICE + ' ,Volume,StockExchange,TransactionDate FROM FMVSharePrices WHERE StockExchange IN(SELECT * FROM dbo.FN_SPLIT_STRING('''+@ConcatString+''','','')) AND (CONVERT(DATE, 
TransactionDate) <= CONVERT(DATE,'''+  @ENDATE+''') AND CONVERT(DATE, TransactionDate) >=  CONVERT(DATE,'''+  @STARTDATE+''')) ORDER BY TransactionDate DESC'               
    END       
    ELSE    
    BEGIN    
     --SET @SQLTEXT = N'SELECT TOP '+ CONVERT(VARCHAR(50), @PRICEDAYS)+' ' + @STOCKPRICE + ' ,Volume,TransactionDate FROM FMVSharePrices WHERE StockExchange IN(SELECT * FROM dbo.FN_SPLIT_STRING('''+@ConcatString+''','','')) AND (TransactionDate <= '''+  @ENDATE+''' AND TransactionDate >=  '''+  @STARTDATE+''') ORDER BY TransactionDate DESC'     
     SET @SQLTEXT = N'SELECT TOP '+ CONVERT(VARCHAR(50), @PRICEDAYS)+' ' + @STOCKPRICE + ' ,Volume,StockExchange,TransactionDate FROM FMVSharePrices WHERE StockExchange IN(SELECT * FROM dbo.FN_SPLIT_STRING('''+@ConcatString+''','','')) AND ( CONVERT(DATE,
TransactionDate) <= CONVERT(DATE, '''+  @ENDATE+''') AND CONVERT(DATE,TransactionDate) >= CONVERT(DATE, '''+  @STARTDATE+''') )    
     AND volume IN( SELECT CASE WHEN UPPER('''+@TRADINGVOLUME+''') = ''HIGH'' THEN  MAX(Volume) ELSE MIN(Volume)END AS Volume FROM FMVSharePrices WHERE StockExchange IN(SELECT * FROM dbo.FN_SPLIT_STRING('''+@ConcatString+''','','')) AND (CONVERT(DATE, Tra
nsactionDate) <= CONVERT(DATE,'''+  @ENDATE+''') AND CONVERT(DATE,TransactionDate) >=  CONVERT(DATE,'''+  @STARTDATE+'''))   GROUP BY TransactionDate  )    
     ORDER BY TransactionDate DESC'     
    
    END    
    PRINT @SQLTEXT            
    DELETE FROM #TEMP_AVGPRICE    
    IF(@STOCKPRICE = 'OpenPrice,ClosePrice' OR @STOCKPRICE = 'HighPrice,LowPrice')    
    BEGIN      
     PRINT 'MULTIPLE STOCK EXCHANGE'    
     DELETE FROM #TEMP_MULTIPLE_STOCK    
     INSERT INTO #TEMP_MULTIPLE_STOCK(STOCKOPEN_HIGHPRICE,STOCKCLOSE_LOWPRICE,Volume,StockExchange,TransactionDate)             
     EXEC (@SQLTEXT)     
    
     INSERT INTO #TEMP_AVGPRICE(STOCKPRICE)    
     SELECT (STOCKOPEN_HIGHPRICE + STOCKCLOSE_LOWPRICE)/2  FROM #TEMP_MULTIPLE_STOCK        
    END      
    ELSE     
    BEGIN          
     INSERT INTO #TEMP_AVGPRICE(STOCKPRICE,Volume,StockExchange,TransactionDate)    
     EXEC (@SQLTEXT)                   
    END    
    SELECT  @TRANS_DATE_PRICE = (SELECT AVG(STOCKPRICE) AS FMVPRICE FROM #TEMP_AVGPRICE )          
   END            
    END    
   /*CODE FOR UNLISTED*/    
    ELSE      
    BEGIN      
            IF(@TRANSACTIONDATE = 'GrantDate')               
     SET @EVENTDATE = CASE WHEN(@PRICEDAY = 'Prior Day' )THEN CASE WHEN(@CALCULATE_TAX = 'rdoTentativeTax') THEN @GRANTDATE ELSE DATEADD(D,-1,@GRANTDATE) END ELSE  @GRANTDATE END                  
    ELSE IF(@TRANSACTIONDATE = 'FinalVestingDate')           
     SET @EVENTDATE = CASE WHEN(@PRICEDAY = 'Prior Day' )THEN CASE WHEN(@CALCULATE_TAX = 'rdoTentativeTax')THEN @VESTINGDATE ELSE DATEADD(D,-1,@VESTINGDATE)END ELSE  @VESTINGDATE END                      
    ELSE IF(@TRANSACTIONDATE = 'ExerciseDate')    
     SET @EVENTDATE = CASE WHEN(@PRICEDAY = 'Prior Day' )THEN CASE WHEN(@CALCULATE_TAX = 'rdoTentativeTax') THEN @EXERCISE_DATE ELSE DATEADD(D,-1,@EXERCISE_DATE) END ELSE  @EXERCISE_DATE END     
    
               IF(@CALCULATE_TAX = 'rdoTentativeTax')    
      BEGIN     
      SET @EVENTDATE =(SELECT CONVERT(DATE,DATEADD(DAY, - @CALCUALTE_TAX_PRIOR_DAYS,@EVENTDATE)))    
      SET @TAXFLAG = 'A'    
      SET @TAXFLAG_HEADER = 'A'    
      END     
      ELSE    
      BEGIN    
                  IF((SELECT COUNT(1) from FMVForUnlisted where FMV_FromDate <= CONVERT(DATE, @EVENTDATE) and FMV_Todate >= CONVERT(DATE, @EVENTDATE))  = 0)    
         BEGIN    
                SET @TAXFLAG = 'T'    
         SET @TAXFLAG_HEADER = 'T'                
          END    
          ELSE     
          BEGIN    
       SET @TAXFLAG = 'A'    
       SET @TAXFLAG_HEADER = 'A'    
      END       
      END    
       
    --  FIRST CASE --    
         IF(UPPER(@PRICEPERIODID) = 'RDOPRICECONSIDERATIONDATE')     
         BEGIN    
                   SET @Is_SARPriceExists = 0        
             SET @TRANS_DATE_PRICE = 0             
               
                IF ((SELECT COUNT(*) as totalcount FROM FMVForUnlisted) > 0)     
                BEGIN     
                    
      SET @Is_SARPriceExists = (SELECT COUNT(1) from FMVForUnlisted where FMV_FromDate <= CONVERT(DATE, @EVENTDATE) and FMV_Todate >= CONVERT(DATE, @EVENTDATE))     
      IF(@Is_SARPriceExists = 0)     
      BEGIN                   
             
          SET @EVENTDATE =(SELECT TOP 1 FMV_Todate  FROM  FMVForUnlisted  ORDER BY FMV_Todate DESC)                    
      END    
                      
          END    
           
                   SET @TRANS_DATE_PRICE = (SELECT  FMV FROM FMVForUnlisted WHERE CONVERT(DATE,FMV_FromDate) <= CONVERT(DATE, @EVENTDATE) and CONVERT(DATE,FMV_Todate) >= CONVERT(DATE,@EVENTDATE))                          
         END    
         ELSE IF(UPPER(@PRICEPERIODID) = 'RDOAVGOFDATEOFEVENT')    
         BEGIN          
              DELETE FROM #TEMP_FILTER_CALENDERDAYS    
              DELETE FROM #TEMP_CALENDERDAYS    
                       
     INSERT INTO #TEMP_CALENDERDAYS    
     SELECT * FROM FN_ACC_EXPLODE_DATES(CONVERT(DATE, dateadd(D,- CONVERT(INT, 10),@EVENTDATE)), CONVERT(DATE, @EVENTDATE)) ORDER BY 1 desc;    
          
     SELECT @MAXVALUE = Max(id),@MINVALUE = MIN(id) FROM #TEMP_CALENDERDAYS                           
     SET @ENDATE = (SELECT CALENDERDATES FROM #TEMP_CALENDERDAYS  WHERE id = @MINVALUE)               
     IF EXISTS (SELECT 1 FROM FMVForUnlisted)     
     BEGIN         
     WHILE(@MINVALUE <= @MAXVALUE)    
     BEGIN    
    
        SET @STARTDATE = (SELECT CALENDERDATES FROM #TEMP_CALENDERDAYS  WHERE id = @MINVALUE)     
        INSERT INTO #TEMP_COMPARE_DATA (STOCKPRICE)    
        SELECT  FMV FROM FMVForUnlisted WHERE FMV_FromDate <= @STARTDATE and FMV_Todate >= @STARTDATE            
          
      SET @MINVALUE = @MINVALUE + 1           
     END         
     END              
       SET @TRANS_DATE_PRICE = 0    
       SELECT @TRANS_DATE_PRICE  = AVG(STOCKPRICE)  FROM #TEMP_COMPARE_DATA                   
             END      
                 
    END    
          
     INSERT INTO #TEMP_TRANS_DATE_DETAILS     
 (    
  INSTRUMENT_ID, EMPLOYEE_ID, GRANTOPTIONID, GRANTDATE, VESTINGDATE, EXERCISE_DATE,TRANS_DATE_VALUE,TAXFLAG, SAR_TRANS_DATE_ID    
 )    
 SELECT @INSTRUMENT_ID,@EMPLOYEE_ID,@GRANTOPTIONID,@GRANTDATE,@VESTINGDATE,@EXERCISE_DATE,@TRANS_DATE_PRICE,@TAXFLAG, @SAR_TRANS_DATE_ID    
     
         
    SET @MN_VALUE = @MN_VALUE + 1       
        
END    
   IF(ISNULL(@CalledFrom,'') <> 'SSRSReport')       
   BEGIN    
     SELECT ID, INSTRUMENT_ID, EMPLOYEE_ID, GRANTOPTIONID, GRANTDATE, VESTINGDATE, EXERCISE_DATE, dbo.FN_GET_COMPANY_DECIMAL_SETTING(TRANS_DATE_VALUE,'FMV')  AS TRANS_DATE_VALUE, TAXFLAG, SAR_TRANS_DATE_ID FROM #TEMP_TRANS_DATE_DETAILS     
   END    
   IF EXISTS (SELECT * FROM SYS.tables WHERE name = 'TEMP_TRANS_DATE_DETAILS')    
 DROP TABLE TEMP_TRANS_DATE_DETAILS    
     
    SELECT  ID ,INSTRUMENT_ID  ,EMPLOYEE_ID ,GRANTOPTIONID ,GRANTDATE ,VESTINGDATE,EXERCISE_DATE  ,TRANS_DATE_VALUE ,TAXFLAG , SAR_TRANS_DATE_ID     
  INTO TEMP_TRANS_DATE_DETAILS FROM #TEMP_TRANS_DATE_DETAILS    
 END TRY    
 BEGIN CATCH    
      DECLARE  @MAILBODY VARCHAR( MAX) ,@ERROR_NUMBER VARCHAR(50),@ERROR_SEVERITY VARCHAR(50) ,@ERROR_STATE VARCHAR(50),@ERROR_PROCEDURE VARCHAR(500),  
       @ERROR_LINE  VARCHAR(MAX),@ERROR_MESSAGE VARCHAR(MAX) ,@Subject_body NVARCHAR(250)         
      SELECT @ERROR_NUMBER = ERROR_NUMBER() ,@ERROR_SEVERITY = ERROR_SEVERITY() ,@ERROR_STATE = ERROR_STATE() ,@ERROR_PROCEDURE =  ERROR_PROCEDURE(), 
	   @ERROR_LINE =	ERROR_LINE(), @ERROR_MESSAGE = ERROR_MESSAGE() 			 
	  SET @MAILBODY = 'ERROR NUMBER -' +@ERROR_NUMBER+','+ 'ERROR SEVERITY -' +@ERROR_SEVERITY+','+ 'ERROR STATE -' +@ERROR_STATE+','+ 'ERROR PROCEDURE -' +@ERROR_PROCEDURE+','+ 'ERROR LINE -' +@ERROR_LINE+','+ 'ERROR MESSAGE -' +@ERROR_MESSAGE
	  SET @Subject_body='Error Occured on [Date:'+Convert(NVARCHAR(50),getdate())+']'
			
	  -- SEND MAIL --
	  DECLARE @tab CHAR(1) = CHAR(9)
	  EXECUTE 
				msdb.dbo.sp_send_dbmail 		
				@recipients = 'esopit@esopdirect.com', 		
				@subject = @Subject_body, 
				@body = @MAILBODY,		
				@body_format = 'HTML',
				@query = '', 
				@attach_query_result_as_file = 0,
				@query_attachment_filename = NULL,
				@query_result_separator = @tab,
				@query_result_no_padding = 1
  END CATCH    
        
    DROP TABLE #TEMP_FILTER_TRANS_DATE_DATA  --    
    DROP TABLE #TEMP_AVGPRICE  --    
    DROP TABLE #TEMP_TRANS_DATE_DETAILS    
    DROP TABLE #TEMP_CALENDERDAYS      
    DROP TABLE #TEMP_TD_EMPLOYEE_DETAILS    
    DROP TABLE #TEMP_FILTER_CALENDERDAYS        
    DROP TABLE #TEMP_MULTIPLE_STOCK     
    DROP TABLE #TEMP_TRADINGDAYS    
    DROP TABLE #TEMP_NON_TRADING_DAYS    
        
 SET NOCOUNT OFF;    
      
END  
GO
