/****** Object:  StoredProcedure [dbo].[PROC_GET_SAR_STOCK_APPRECIATION]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_SAR_STOCK_APPRECIATION]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_SAR_STOCK_APPRECIATION]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_SAR_STOCK_APPRECIATION]
(	
	@EMPLOYEE_SAR_APPRECIATION dbo.TYPE_SAR_STOCK_APPRECIATION READONLY,
	@CalledFrom VARCHAR(50) = NULL	
)	
AS
BEGIN  
SET NOCOUNT ON;    
    
 DECLARE   
  @INSTRUMENT_ID BIGINT ,@EMPLOYEE_ID  VARCHAR(50),@GRANTOPTIONID VARCHAR(50) ,@GRANTDATE  VARCHAR(200) ,@VESTINGDATE VARCHAR(200),   
  @MN_VALUE INT,@MX_VALUE INT, @FORMULA NVARCHAR(MAX),@EXERCISEPRICE DECIMAL(18,4), @OPTIONVESTED  NUMERIC(18,9), @FACEVAUE NUMERIC(18,9),  
  @FMV_VALUE NUMERIC(18,9),@EXERCISE_PRICE NUMERIC(18,9), @APPRECIATION_FORMULA NVARCHAR(MAX), @OPTIONEXERCISED  NUMERIC(18,9),  
  @SQL NVARCHAR(MAX),@STOCK_APPRECIATION_VALUE FLOAT,@EXERCISEDATE DATETIME,@EMPLOYEE_STATUS INT , @EMPLOYEEID VARCHAR(50), @EVENTOFINCIDENCE INT,  
  @SCHEMEID  NVARCHAR(100), @SETTLEMENT_PRICE NUMERIC(18,9), @TAXFLAG CHAR(1), @TaxFlagSettlementPrice CHAR(1), @TaxFlagFMV CHAR(1),  
        @ClosePriceVsestNSESday NUMERIC(18, 2), @TaxFlagVsestNSESday CHAR(1), @ClosePriceVsestNSEPday NUMERIC(18, 2), @TaxFlagVsestNSEPday CHAR(1),  
  @ClosePriceVsestBSESday NUMERIC(18, 2), @TaxFlagVsestBSESday CHAR(1), @ClosePriceVsestBSEPday NUMERIC(18, 2), @TaxFlagVsestBSEPday CHAR(1),  
  @ClosePriceVsestNYSESday NUMERIC(18, 2), @TaxFlagVsestNYSESday CHAR(1), @ClosePriceVsestNYSEPday NUMERIC(18, 2), @TaxFlagVsestNYSEPday CHAR(1),   
  @ClosePriceVsestHKSday NUMERIC(18, 2), @TaxFlagVsestHKSday CHAR(1), @ClosePriceVsestHKPday NUMERIC(18, 2), @TaxFlagVsestHKPday CHAR(1),    
  @ClosePriceVsestSHSday NUMERIC(18, 2), @TaxFlagVsestSHSday CHAR(1), @ClosePriceVsestSHPday NUMERIC(18, 2), @TaxFlagVsestSHPday CHAR(1),  
  @ClosePriceGrantNSESday NUMERIC(18, 2), @TaxFlagGrantNSESday CHAR(1), @ClosePriceGrantNSEPday NUMERIC(18, 2), @TaxFlagGrantNSEPday CHAR(1),   
  @ClosePriceGrantBSESday NUMERIC(18, 2), @TaxFlagGrantBSESday CHAR(1), @ClosePriceGrantBSEPday NUMERIC(18, 2), @TaxFlagGrantBSEPday CHAR(1),    
  @ClosePriceGrantNYSESday NUMERIC(18, 2), @TaxFlagGrantNYSESday CHAR(1), @ClosePriceGrantNYSEPday NUMERIC(18, 2), @TaxFlagGrantNYSEPday CHAR(1),   
  @ClosePriceGrantHKSday NUMERIC(18, 2), @TaxFlagGrantHKSday CHAR(1), @ClosePriceGrantHKPday NUMERIC(18, 2), @TaxFlagGrantHKPday CHAR(1),     
  @ClosePriceGrantSHSday NUMERIC(18, 2), @TaxFlagGrantSHSday CHAR(1), @ClosePriceGrantSHPday NUMERIC(18, 2), @TaxFlagGrantSHPday CHAR(1),  
  @ClosePriceExNSESday NUMERIC(18, 2), @TaxFlagExNSESday CHAR(1), @ClosePriceExNSEPday NUMERIC(18, 2), @TaxFlagExNSEPday CHAR(1),    
  @ClosePriceExBSESday NUMERIC(18, 2), @TaxFlagExBSESday CHAR(1), @ClosePriceExBSEPday NUMERIC(18, 2), @TaxFlagExBSEPday CHAR(1),    
  @ClosePriceExNYSESday NUMERIC(18, 2), @TaxFlagExNYSESday CHAR(1), @ClosePriceExNYSEPday NUMERIC(18, 2), @TaxFlagExNYSEPday CHAR(1),   
  @ClosePriceExHKSday NUMERIC(18, 2), @TaxFlagExHKSday CHAR(1), @ClosePriceExHKPday NUMERIC(18, 2), @TaxFlagExHKPday CHAR(1),  
  @ClosePriceExSHSday NUMERIC(18, 2), @TaxFlagExSHSday CHAR(1), @ClosePriceExSHPday NUMERIC(18, 2), @TaxFlagExSHPday CHAR(1), @TransactionDate NVARCHAR(1000),  
  @TransactionDateId INT, @VestingDateCodeId INT = 1001, @ExerciseDateCodeId INT = 1002, @GrantDateCodeId INT = 1003  
     ,@FMV_TEMPFLAG CHAR (1),@TAXFLAG_HEADER CHAR(1)  
      ,@SETVALUE varchar(max),@PRICE_DAY VARCHAR (500),@INCIDANCE_DATE VARCHAR (500),@TRADING_DAY VARCHAR(500),@INCIDANCE_DATE_VALUE DATETIME,@CLOSING_PRICE  DECIMAL(18,4),@Is_FMVExists INT,@TEMP_EXERCISEID BIGINT
	  --@RatioMultiplier BIGINT,@RatioDivisor BIGINT 
	  
 DECLARE @TAXFLAG_LIST TABLE (TAXFLAG CHAR(1))  
    
  -- CREATE TEMP TABLE --  
 CREATE TABLE #TEMP_APP_EMPLOYEE_DETAILS  
 (    
  ID INT IDENTITY(1,1) NOT NULL, INSTRUMENT_ID BIGINT , EMPLOYEE_ID  VARCHAR(50), EXERCISE_PRICE  NUMERIC(18,9 ), OPTION_VESTED NUMERIC(18,9),  
  OPTION_EXERCISED NUMERIC(18,9), EXERCISE_DATE DATETIME, GRANTOPTIONID VARCHAR(50) NULL ,GRANTDATE VARCHAR(200) NULL,VESTINGDATE VARCHAR(200) NULL ,TEMP_EXERCISEID BIGINT NULL 
 )   
           
 CREATE TABLE #TEMP_APPRECIATION_DETAILS  
 (  
  ID INT IDENTITY(1,1) NOT NULL,INSTRUMENT_ID BIGINT ,EMPLOYEE_ID  VARCHAR(50),EXERCISE_PRICE NUMERIC(18,9),OPTION_VESTED NUMERIC(18,9),  
  EXERCISE_DATE DATETIME,STOCK_APPRECIATION_VALUE NUMERIC(18,9),EVENTOFINCIDENCE INT,OPTION_EXERCISED NUMERIC(18,9),GRANTOPTIONID VARCHAR(50) NULL,  
  GRANTDATE  VARCHAR(200) NUll,VESTINGDATE VARCHAR(200) NULL, TAXFLAG CHAR(1),TAXFLAG_HEADER CHAR(1) NULL,TEMP_EXERCISEID BIGINT NULL   
 )  
  
 CREATE TABLE #TEMP_APP_FORMULA  
 (  
  FORMULA_DESC NVARCHAR(MAX), EVENTOFINCIDENCE INT  
 )   
   
 CREATE TABLE #TEMP_SPLIT_DATA  
 (  
  FORMULA_SPLIT_DESC NVARCHAR(MAX)     
 )    
   
  CREATE TABLE #TEMP_FORMULA_DATA_1  
 (  
  ITEM_ID INT IDENTITY(1,1) NOT NULL,ITEM VARCHAR(500)  
 )     
                    
     CREATE TABLE #TEMP_SPLIT_FORMULA  
    (  
  FORMULA_SPLIT_DESC NVARCHAR(MAX)     
    )               
           
 BEGIN TRY   
   -- INSERT VALUE INTO TEMP TABLE --  
 INSERT INTO #TEMP_APP_EMPLOYEE_DETAILS   
 (  
  INSTRUMENT_ID, EMPLOYEE_ID, EXERCISE_PRICE, OPTION_VESTED, OPTION_EXERCISED,EXERCISE_DATE,  
  GRANTOPTIONID ,GRANTDATE ,VESTINGDATE ,TEMP_EXERCISEID  
 )  
 SELECT   
  INSTRUMENT_ID, EMPLOYEE_ID, EXERCISE_PRICE, OPTION_VESTED, OPTION_EXERCISED, EXERCISE_DATE,  
  GRANTOPTIONID, GRANTDATE, VESTINGDATE ,TEMP_EXERCISEID  
 FROM @EMPLOYEE_SAR_APPRECIATION  
   
 SELECT @MN_VALUE = MIN(ID),@MX_VALUE = MAX(ID) FROM #TEMP_APP_EMPLOYEE_DETAILS   
 WHILE(@MN_VALUE <= @MX_VALUE)  
 BEGIN    
     
        DELETE FROM @TAXFLAG_LIST  
        -------------------------------------- Set Default Value ----------------------------------------------------------------   
  SELECT @ClosePriceVsestNSESday = 0, @TaxFlagVsestNSESday = '', @ClosePriceVsestNSEPday = 0, @TaxFlagVsestNSEPday = '',   
      @ClosePriceVsestBSESday = 0, @TaxFlagVsestBSESday = '', @ClosePriceVsestBSEPday = 0, @TaxFlagVsestBSEPday = '',   
      @ClosePriceVsestNYSESday = 0, @TaxFlagVsestNYSESday = '', @ClosePriceVsestNYSEPday = 0, @TaxFlagVsestNYSEPday = '',   
      @ClosePriceVsestHKSday = 0, @TaxFlagVsestHKSday = '', @ClosePriceVsestHKPday = 0, @TaxFlagVsestHKPday = '',   
      @ClosePriceVsestSHSday = 0, @TaxFlagVsestSHSday = '', @ClosePriceVsestSHPday = 0, @TaxFlagVsestSHPday = '',   
      @ClosePriceGrantNSESday = 0, @TaxFlagGrantNSESday = '', @ClosePriceGrantNSEPday = 0, @TaxFlagGrantNSEPday = '',   
      @ClosePriceGrantBSESday = 0, @TaxFlagGrantBSESday = '', @ClosePriceGrantBSEPday = 0, @TaxFlagGrantBSEPday = '',     
      @ClosePriceGrantNYSESday = 0, @TaxFlagGrantNYSESday = '',@ClosePriceGrantNYSEPday = 0, @TaxFlagGrantNYSEPday = '',   
      @ClosePriceGrantHKSday = 0, @TaxFlagGrantHKSday = '', @ClosePriceGrantHKPday = 0, @TaxFlagGrantHKPday = '',   
      @ClosePriceGrantSHSday = 0, @TaxFlagGrantSHSday = '', @ClosePriceGrantSHPday = 0, @TaxFlagGrantSHPday = '',   
      @ClosePriceExNSESday = 0, @TaxFlagExNSESday = '', @ClosePriceExNSEPday = 0, @TaxFlagExNSEPday = '',    
      @ClosePriceExBSESday = 0, @TaxFlagExBSESday = '', @ClosePriceExBSEPday = 0, @TaxFlagExBSEPday = '',    
      @ClosePriceExNYSESday = 0, @TaxFlagExNYSESday = '', @ClosePriceExNYSEPday = 0, @TaxFlagExNYSEPday = '',  
      @ClosePriceExHKSday = 0, @TaxFlagExHKSday = '', @ClosePriceExHKPday = 0, @TaxFlagExHKPday = '',  
      @ClosePriceExSHSday = 0, @TaxFlagExSHSday = '', @ClosePriceExSHPday = 0, @TaxFlagExSHPday = '',   
      @TaxFlagSettlementPrice = '', @TaxFlagFMV = ''  
        
  SELECT   
   @EXERCISEPRICE = EXERCISE_PRICE, @OPTIONVESTED = OPTION_VESTED, @OPTIONEXERCISED = OPTION_EXERCISED,   
   @EMPLOYEE_ID = EMPLOYEE_ID,@INSTRUMENT_ID = INSTRUMENT_ID,@EXERCISEDATE = EXERCISE_DATE,  
   @GRANTOPTIONID = GRANTOPTIONID ,@GRANTDATE = GRANTDATE ,@VESTINGDATE = VESTINGDATE, @TEMP_EXERCISEID= TEMP_EXERCISEID
  FROM #TEMP_APP_EMPLOYEE_DETAILS   
  WHERE ID = @MN_VALUE  
            
  SET @SCHEMEID = (SELECT SchemeId FROM GrantOptions WHERE GrantOptionId = @GRANTOPTIONID)  
  -- SELECT  @RatioMultiplier = OptionRatioMultiplier,@RatioDivisor = OptionRatioDivisor FROM Scheme WHERE SchemeId = @SCHEMEID  
   
  -- Get Face Value --    
  SELECT @FACEVAUE = FaceVaue FROM CompanyParameters   
    
  DELETE FROM #TEMP_APP_FORMULA  
         
  SELECT TOP 1   
   @TransactionDateId = TRANS_DATE_ID   
  FROM APPERCIATION_FORMULA_CONFIG AS AFC                
  WHERE ((CONVERT(DATE, AFC.APPLICABLE_FROM_DATE) <= CONVERT(DATE,@EXERCISEDATE)) AND (CONVERT(DATE, ISNULL(AFC.APPLICABLE_TO_DATE, GETDATE())) >=  CONVERT(DATE,@EXERCISEDATE)))                            
   AND MIT_ID = @INSTRUMENT_ID AND SCHEME_ID = @SCHEMEID  AND IS_TRADINGDAYS = 1 ORDER BY AFC_ID DESC  
  
  IF(@TransactionDateId = @VestingDateCodeId)  
   SET @TransactionDate = @VESTINGDATE  
  ELSE IF(@TransactionDateId = @ExerciseDateCodeId)  
   SET @TransactionDate = @EXERCISEDATE  
  ELSE IF(@TransactionDateId = @GrantDateCodeId)  
   SET @TransactionDate = @GRANTDATE  
         
  IF((SELECT COUNT(*) AS NonTradeDay FROM NonTradingDays WHERE CONVERT(DATE,NonTradDay) = CONVERT(DATE,@TransactionDate)) > 0)  
  BEGIN   
   -- FOR NON TRADING DAY  
   INSERT INTO #TEMP_APP_FORMULA  
   (  
    FORMULA_DESC, EVENTOFINCIDENCE  
   )   
   SELECT TOP 1   
    FORMULA_DESCRIPTION, TRANS_DATE_ID   
   FROM APPERCIATION_FORMULA_CONFIG AS AFC                
   WHERE ((CONVERT(DATE, AFC.APPLICABLE_FROM_DATE) <= CONVERT(DATE,@EXERCISEDATE)) AND (CONVERT(DATE, ISNULL(AFC.APPLICABLE_TO_DATE, GETDATE())) >=  CONVERT(DATE,@EXERCISEDATE)))                                  
    AND MIT_ID = @INSTRUMENT_ID AND SCHEME_ID = @SCHEMEID AND IS_TRADINGDAYS = 0 ORDER BY AFC_ID DESC  
  END  
  ELSE  
  BEGIN  
   -- FOR TRADING DAY  
   INSERT INTO #TEMP_APP_FORMULA  
   (  
    FORMULA_DESC, EVENTOFINCIDENCE  
   )   
   SELECT TOP 1   
    FORMULA_DESCRIPTION, TRANS_DATE_ID   
   FROM APPERCIATION_FORMULA_CONFIG AS AFC                
   WHERE ((CONVERT(DATE, AFC.APPLICABLE_FROM_DATE) <= CONVERT(DATE,@EXERCISEDATE)) AND (CONVERT(DATE, ISNULL(AFC.APPLICABLE_TO_DATE, GETDATE())) >=  CONVERT(DATE,@EXERCISEDATE)))                                  
    AND MIT_ID = @INSTRUMENT_ID AND SCHEME_ID = @SCHEMEID AND IS_TRADINGDAYS = 1 ORDER BY AFC_ID DESC  
  END  
       
  SELECT TOP 1  
    @FORMULA =  FORMULA_DESC, @APPRECIATION_FORMULA = FORMULA_DESC, @EVENTOFINCIDENCE =  EVENTOFINCIDENCE        
  FROM   
    #TEMP_APP_FORMULA  
                
        ----------------------------------------- Settlement Price ----------------------------------------------------------------------
  IF EXISTS(SELECT FORMULA_DESC FROM #TEMP_APP_FORMULA WHERE FORMULA_DESC  LIKE '%@Settlement Price@%')  
  BEGIN     
    
   DECLARE @TYPE_SAR_SETTLEMENT_PRICE dbo.TYPE_SAR_SETTLEMENT_PRICE  
   DELETE FROM @TYPE_SAR_SETTLEMENT_PRICE  
     
   INSERT INTO @TYPE_SAR_SETTLEMENT_PRICE   
   SELECT   
    @INSTRUMENT_ID, @EMPLOYEE_ID, CONVERT(DATE,@GRANTDATE), CONVERT(DATE,@VESTINGDATE), CONVERT(DATE,@EXERCISEDATE), @EXERCISEPRICE, @SCHEMEID, @GRANTOPTIONID    
   EXEC PROC_GET_SAR_SETTELEMENT_PRICCE @TYPE_SAR_SETTLEMENT_PRICE, @CalledFrom = 'SSRSReport'   
     
   SELECT @SETTLEMENT_PRICE = SAR_SETTLEMENT_VALUE, @TaxFlagSettlementPrice = TAXFLAG FROM TEMP_SAR_SETTLEMENT_FINAL_DETAILS  
   -- BELOW LINE IS ADDED FOR RATIOMULTIPLIER/DIVISOR ENAHNCEMENT ---			
  -- SET @FMV_VALUE = dbo.FN_GET_FINAL_FMV(@SETTLEMENT_PRICE,@RatioMultiplier,@RatioDivisor,@OPTIONEXERCISED,'FMV')
  Print 'Recived table settlement price ****************************'
   IF EXISTS (SELECT * FROM SYS.tables WHERE name = 'TEMP_SAR_SETTLEMENT_FINAL_DETAILS')  
    DROP TABLE TEMP_SAR_SETTLEMENT_FINAL_DETAILS  
  
   SET @APPRECIATION_FORMULA = REPLACE( @APPRECIATION_FORMULA, '@Settlement Price@', ISNULL(dbo.FN_GET_COMPANY_DECIMAL_SETTING(@SETTLEMENT_PRICE,'FMV'),0))  
  
   INSERT INTO @TAXFLAG_LIST VALUES (@TaxFlagSettlementPrice)     
     
  END  
      
     ----------------------------------------- Face Value ---------------------------------------------------------------------------  
  IF EXISTS(SELECT FORMULA_DESC FROM #TEMP_APP_FORMULA WHERE FORMULA_DESC  LIKE '%@Face Value@%')  
  BEGIN  
   SET @APPRECIATION_FORMULA = REPLACE( @APPRECIATION_FORMULA, '@Face Value@', ISNULL(@FACEVAUE,0) )     
   INSERT INTO @TAXFLAG_LIST VALUES ('A')       
  END   
     
     ----------------------------------------- Base Value ---------------------------------------------------------------------------  
  IF EXISTS(SELECT FORMULA_DESC FROM #TEMP_APP_FORMULA WHERE FORMULA_DESC  LIKE '%@Base Price@%')  
  BEGIN  
   SET @APPRECIATION_FORMULA = REPLACE( @APPRECIATION_FORMULA, '@Base Price@', ISNULL(@EXERCISEPRICE,0))   
   INSERT INTO @TAXFLAG_LIST VALUES ('A')     
  END   
     
  ----------------------------------------- SARs Exercised ----------------------------------------------------------------------  
  IF EXISTS(SELECT FORMULA_DESC FROM #TEMP_APP_FORMULA WHERE FORMULA_DESC  LIKE '%@SARs Exercised@%')  
  BEGIN  
   SET @APPRECIATION_FORMULA = REPLACE( @APPRECIATION_FORMULA, '@SARs Exercised@', ISNULL(@OPTIONEXERCISED,0))   
   INSERT INTO @TAXFLAG_LIST VALUES ('A')      
  END   
     
  ----------------------------------------- SARs Vested -------------------------------------------------------------------------  
  IF EXISTS(SELECT FORMULA_DESC FROM #TEMP_APP_FORMULA WHERE FORMULA_DESC  LIKE '%@SARs Vested@%')  
  BEGIN  
   SET @APPRECIATION_FORMULA = REPLACE( @APPRECIATION_FORMULA, '@SARs Vested@', ISNULL(@OPTIONVESTED,0))   
   INSERT INTO @TAXFLAG_LIST VALUES ('A')    
  END  
      
  ----------------------------------------- FMV ---------------------------------------------------------------------------------  
  IF EXISTS(SELECT FORMULA_DESC FROM #TEMP_APP_FORMULA WHERE FORMULA_DESC  LIKE '%@FMV@%')  
  BEGIN  
   SET @FMV_VALUE = 0  
   DECLARE @TYPE_FMV_VALUE dbo.TYPE_FMV_VALUE  
   DELETE  FROM @TYPE_FMV_VALUE  
  
  Print 'Step3*************************'
   INSERT INTO @TYPE_FMV_VALUE       
   SELECT   
    @INSTRUMENT_ID, @EMPLOYEE_ID, @GRANTOPTIONID, CONVERT(DATE,@GRANTDATE), CONVERT(DATE,@VESTINGDATE), CONVERT(DATE,@EXERCISEDATE) ,'T'  
   EXEC PROC_GET_FMV_VALUE @EMPLOYEE_DETAILS = @TYPE_FMV_VALUE, @CalledFrom = 'SSRSReport'  
   SELECT @FMV_VALUE = FMV_VALUE, @TaxFlagFMV = TAXFLAG,@FMV_TEMPFLAG = TAXFLAG_HEADER FROM TEMP_FMV_DETAILS  

   Print 'Step4*************************'
  
   IF EXISTS (SELECT * FROM SYS.tables WHERE name = 'TEMP_FMV_DETAILS')  
    DROP TABLE TEMP_FMV_DETAILS  
  
   SET @APPRECIATION_FORMULA = REPLACE( @APPRECIATION_FORMULA, '@FMV@', ISNULL(@FMV_VALUE,0))   
  
   INSERT INTO @TAXFLAG_LIST VALUES (@TaxFlagFMV)    
  END  
  /* print @APPRECIATION_FORMULA*/  
   
     ---- CHANGES DONE FOR EQUITY SETTLE ----  
  IF EXISTS(SELECT FORMULA_DESC FROM #TEMP_APP_FORMULA WHERE FORMULA_DESC   LIKE '%CLOSING%')  
  BEGIN  
    SELECT @APPRECIATION_FORMULA = FORMULA_DESC FROM #TEMP_APP_FORMULA  
                
    DELETE FROM #TEMP_SPLIT_FORMULA  
    INSERT INTO #TEMP_SPLIT_FORMULA (FORMULA_SPLIT_DESC)  
    SELECT '@'+ Item +'@' FROM dbo.FN_SPLIT_STRING(@APPRECIATION_FORMULA,'@')  
     
     -- SPLIT A FORMULA --  
     SELECT TOP 1 @SETVALUE  =  FORMULA_SPLIT_DESC FROM #TEMP_SPLIT_FORMULA WHERE FORMULA_SPLIT_DESC LIKE '%@Closing%'  
  
   -- INSER SPLIT VALUES INTO TEMP TABLE --       
   DELETE FROM #TEMP_FORMULA_DATA_1                     
   INSERT INTO #TEMP_FORMULA_DATA_1(ITEM)  
   SELECT TOP 3 Item FROM  DBO.[FN_SPLIT_STRING](@SETVALUE,'�') WHERE Item <> REPLACE(' @ ','','') and Item <>  ''   
     AND LEN(Item) >  1    
     ORDER BY ROW_NUMBER() OVER (ORDER BY (SELECT 100)) DESC  
  
     SET @PRICE_DAY =  (SELECT TOP 1 ITEM FROM #TEMP_FORMULA_DATA_1 )  
        SET @INCIDANCE_DATE = (SELECT TOP 1 ITEM FROM #TEMP_FORMULA_DATA_1 ORDER BY ITEM_ID DESC )  
        SET @TRADING_DAY  = (SELECT TOP 1   ITEM   FROM #TEMP_FORMULA_DATA_1 WHERE ITEM_ID = 2 )  
  
   SET @TRADING_DAY = CASE WHEN @TRADING_DAY = 'NSE' THEN 'N'   
         WHEN @TRADING_DAY = 'BSE' THEN 'B'   
         WHEN @TRADING_DAY = 'NYSE' THEN 'N'            
          END  
          
     
            IF(UPPER(LTRIM(@INCIDANCE_DATE)) = ('@CLOSING MARKET PRICE ON DATE OF EXERCISE'))  
             BEGIN                                        
    SET @INCIDANCE_DATE_VALUE = CASE WHEN(UPPER(@PRICE_DAY) = 'PRIOR DAY' )THEN DATEADD(D,-1,@EXERCISEDATE)  ELSE @EXERCISEDATE END                             
          END  
          IF(UPPER(LTRIM(@INCIDANCE_DATE)) = '@CLOSING MARKET PRICE ON DATE OF GRANT')  
          BEGIN              
           SET @INCIDANCE_DATE_VALUE = CASE WHEN(UPPER(@PRICE_DAY) = 'PRIOR DAY' )THEN CONVERT(DATE, DATEADD(D,-1,@GRANTDATE))  ELSE CONVERT(DATE,@GRANTDATE) END      
          END  
          IF(UPPER(LTRIM(@INCIDANCE_DATE)) = '@CLOSING MARKET PRICE ON DATE OF VEST')  
          BEGIN   
     
            SET @INCIDANCE_DATE_VALUE = CASE WHEN(UPPER(@PRICE_DAY) = 'PRIOR DAY' )THEN CONVERT(DATE,DATEADD(D,-1,@VESTINGDATE))  ELSE CONVERT(DATE,@VESTINGDATE) END   
          END  
          -- IF PRICE IS AVAILABLE IN FMVSHARE PRICE TABLE --  
             IF EXISTS(SELECT FMVPriceID from FMVSharePrices where  TransactionDate = CONVERT(DATE, @INCIDANCE_DATE_VALUE))   
             BEGIN                          
              SET @CLOSING_PRICE = (SELECT ClosePrice FROM FMVSharePrices WHERE TransactionDate =  CONVERT(DATE,@INCIDANCE_DATE_VALUE ) AND  StockExchange = @TRADING_DAY)  
                
       END  
       ELSE  
       BEGIN      
    -- IF PRICE IS NOT  AVAILABLE IN FMVSHARE PRICE TABLE --          
    SET @Is_FMVExists = (SELECT FMVPriceID from FMVSharePrices where  TransactionDate = CONVERT(DATE, @INCIDANCE_DATE_VALUE))  
    IF( ISNULL(@Is_FMVExists ,0) = '')   
    BEGIN   
        IF  EXISTS((SELECT TOP 1 TransactionDate  FROM  FMVSharePrices where TransactionDate <= CONVERT(DATE, @INCIDANCE_DATE_VALUE)  AND  StockExchange = @TRADING_DAY ORDER BY TransactionDate DESC))  
        BEGIN  
          SET @INCIDANCE_DATE_VALUE =(SELECT TOP 1 TransactionDate  FROM  FMVSharePrices where TransactionDate <= CONVERT(DATE, @INCIDANCE_DATE_VALUE)  AND  StockExchange = @TRADING_DAY ORDER BY TransactionDate DESC )                       
        END  
        ELSE  
        BEGIN  
         SET @INCIDANCE_DATE_VALUE =(SELECT TOP 1 TransactionDate  FROM  FMVSharePrices where TransactionDate >= CONVERT(DATE, @INCIDANCE_DATE_VALUE)  AND  StockExchange = @TRADING_DAY  )                       
        END                             
        SET @INCIDANCE_DATE_VALUE =(SELECT TOP 1 TransactionDate  FROM  FMVSharePrices where TransactionDate <= CONVERT(DATE, @INCIDANCE_DATE_VALUE)  AND  StockExchange = @TRADING_DAY ORDER BY TransactionDate DESC )                       
     SET @CLOSING_PRICE =(SELECT ClosePrice FROM FMVSharePrices WHERE TransactionDate =  CONVERT(DATE,@INCIDANCE_DATE_VALUE) AND  StockExchange = @TRADING_DAY)                                    
    END     
        END  
          
         IF EXISTS(SELECT FORMULA_SPLIT_DESC FROM #TEMP_SPLIT_FORMULA WHERE FORMULA_SPLIT_DESC like '%@Closing%')  
     BEGIN    
  
      SET @APPRECIATION_FORMULA  = REPLACE(@APPRECIATION_FORMULA, (SELECT FORMULA_SPLIT_DESC FROM #TEMP_SPLIT_FORMULA WHERE FORMULA_SPLIT_DESC like '%@Closing Market Price on date of exercise  �NSE� �Prior Day� @%'), @CLOSING_PRICE )  
       END    
   END  
   ---- CHANGES DONE FOR EQUITY SETTLE END ----  
     
  IF EXISTS(SELECT TAXFLAG FROM @TAXFLAG_LIST WHERE TAXFLAG = 'T')  
  BEGIN  
   SET @TAXFLAG = 'T'  
      SET @TAXFLAG_HEADER =  @FMV_TEMPFLAG  
  END  
  ELSE  
  BEGIN IF((SELECT COUNT(TAXFLAG) FROM @TAXFLAG_LIST) > 0)  
   SET @TAXFLAG = 'A'  
   SET @TAXFLAG_HEADER = @FMV_TEMPFLAG  
  END  
    Print 'Appreciation Formula'
	Print @APPRECIATION_FORMULA
  SET @SQL = N'set @STOCK_APPRECIATION_VALUE = ' + REPLACE(@APPRECIATION_FORMULA, '''','')  
  EXEC sp_executesql @SQL, N'@STOCK_APPRECIATION_VALUE float output', @STOCK_APPRECIATION_VALUE OUT  
			          
  INSERT INTO #TEMP_APPRECIATION_DETAILS  
  (  
   INSTRUMENT_ID, EMPLOYEE_ID, STOCK_APPRECIATION_VALUE, EVENTOFINCIDENCE, EXERCISE_PRICE, OPTION_VESTED, EXERCISE_DATE,   
   OPTION_EXERCISED, GRANTOPTIONID, GRANTDATE ,VESTINGDATE, TAXFLAG,TAXFLAG_HEADER ,TEMP_EXERCISEID  
  )  
  SELECT   
   @INSTRUMENT_ID, @EMPLOYEE_ID, @STOCK_APPRECIATION_VALUE, @EVENTOFINCIDENCE, @EXERCISEPRICE, @OPTIONVESTED, @EXERCISEDATE,  
   @OPTIONEXERCISED, @GRANTOPTIONID, @GRANTDATE, @VESTINGDATE, @TAXFLAG,@TAXFLAG_HEADER,@TEMP_EXERCISEID     
  
  SET @MN_VALUE = @MN_VALUE + 1            
        
 END      
  
 IF(ISNULL(@CalledFrom,'') <> 'SSRSReport')   
 BEGIN                 
  SELECT   
   ID,INSTRUMENT_ID,EMPLOYEE_ID,EXERCISE_PRICE,OPTION_VESTED,EXERCISE_DATE,EVENTOFINCIDENCE,OPTION_EXERCISED,  
   GRANTOPTIONID,GRANTDATE,VESTINGDATE, STOCK_APPRECIATION_VALUE,TAXFLAG,TAXFLAG_HEADER,TEMP_EXERCISEID        
  FROM #TEMP_APPRECIATION_DETAILS  
 END                   
  
 IF EXISTS (SELECT * FROM SYS.tables WHERE name = 'TEMP_STOCK_APPRECIATION_DETAILS')  
  DROP TABLE TEMP_STOCK_APPRECIATION_DETAILS  
  Print 'TEMP_STOCK_APPRECIATION_DETAILS Droped'
 SELECT   
  ID, INSTRUMENT_ID, EMPLOYEE_ID, EXERCISE_PRICE, OPTION_VESTED, EXERCISE_DATE, EVENTOFINCIDENCE,  
  OPTION_EXERCISED, GRANTOPTIONID, GRANTDATE, VESTINGDATE, STOCK_APPRECIATION_VALUE,TAXFLAG,TAXFLAG_HEADER,TEMP_EXERCISEID  
 INTO TEMP_STOCK_APPRECIATION_DETAILS  
 FROM #TEMP_APPRECIATION_DETAILS  
   
   Print 'TEMP_STOCK_APPRECIATION_DETAILS Created'
             
END TRY  
BEGIN CATCH  
 DECLARE    
  @MAILBODY VARCHAR( MAX) ,@ERROR_NUMBER VARCHAR(50),@ERROR_SEVERITY VARCHAR(50) ,@ERROR_STATE VARCHAR(50),@ERROR_PROCEDURE VARCHAR(500),  
  @ERROR_LINE  VARCHAR(MAX),@ERROR_MESSAGE VARCHAR(MAX),@Subject_body NVARCHAR(250)  
  
 SELECT   
  @ERROR_NUMBER = ERROR_NUMBER() ,@ERROR_SEVERITY = ERROR_SEVERITY() ,@ERROR_STATE = ERROR_STATE() ,@ERROR_PROCEDURE =  ERROR_PROCEDURE(),   
  @ERROR_LINE = ERROR_LINE(), @ERROR_MESSAGE = ERROR_MESSAGE()   
    
 SET @MAILBODY = 'ERROR NUMBER -' +@ERROR_NUMBER+','+ 'ERROR SEVERITY -' +@ERROR_SEVERITY+','+ 'ERROR STATE -' +@ERROR_STATE+','+ 'ERROR PROCEDURE -' +@ERROR_PROCEDURE+','+ 'ERROR LINE -' +@ERROR_LINE+','+ 'ERROR MESSAGE -' +@ERROR_MESSAGE  
 SET @Subject_body='Error Occured on [Date:'+Convert(NVARCHAR(50),getdate())+']'  
  
 -- SEND MAIL --  
 --DECLARE @tab CHAR(1) = CHAR(9)  
 --EXECUTE   
 -- msdb.dbo.sp_send_dbmail     
 -- @recipients = 'esopit@esopdirect.com',     
 -- @subject = @Subject_body,   
 -- @body = @MAILBODY,    
 -- @body_format = 'HTML',  
 -- @query = '',   
 -- @attach_query_result_as_file = 0,  
 -- @query_attachment_filename = NULL,  
 -- @query_result_separator = @tab,  
 -- @query_result_no_padding = 1  
                   
END CATCH  
        
 DROP TABLE #TEMP_APP_EMPLOYEE_DETAILS  
 DROP TABLE #TEMP_APP_FORMULA  
 DROP TABLE #TEMP_APPRECIATION_DETAILS  
  
 SET NOCOUNT OFF;  
    
END  
GO
