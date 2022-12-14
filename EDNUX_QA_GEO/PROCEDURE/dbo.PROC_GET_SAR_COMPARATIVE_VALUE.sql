/****** Object:  StoredProcedure [dbo].[PROC_GET_SAR_COMPARATIVE_VALUE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_SAR_COMPARATIVE_VALUE]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_SAR_COMPARATIVE_VALUE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_SAR_COMPARATIVE_VALUE]
(	
	@EMP_COMPARATIVE_DETAILS dbo.TYPE_SAR_COMPARATIVE_VALUE READONLY,
	@CalledFrom VARCHAR(50) = NULL
)	
AS
BEGIN
	SET NOCOUNT ON;		
  
	DECLARE
			
			@TRANSACTIONDATE NVARCHAR(1000), @INSTRUMENT_ID BIGINT, @EMPLOYEE_ID VARCHAR(50), @GRANTOPTIONID VARCHAR(50), @GRANTDATE VARCHAR(200),
			@VESTINGDATE VARCHAR(200), @EXERCISE_DATE  DATETIME, @MN_VALUE INT, @MX_VALUE INT, @TAXFLAG CHAR(1), @SCHEME_ID  NVARCHAR(100), @EXERCISE_PRICE NUMERIC(18, 9),
		    @SCFC_ID BIGINT, @PERCENT_VALUE_1 NUMERIC(18, 6), @PERCENT_VALUE_ON_1 BIGINT, @PERCENT_VALUE_2 NUMERIC(18, 6), @PERCENT_VALUE_ON_2 BIGINT, 
		    @ON_LEVEL VARCHAR(15), @ON_LEVEL_VALUE NUMERIC(18, 6), @APPLY_MAX_CAP TINYINT, @CONSIDER NVARCHAR(50), @MSE_ID_1 BIGINT, @MSE_ID_2 BIGINT,
	        @SAR_TRANS_DATE_ID_1 BIGINT, @SAR_TRANS_DATE_ID_2 BIGINT, @CalculatedValue_1 NUMERIC(18, 6), @CalculatedValue_2 NUMERIC(18, 6), @CalculatedValue_3 NUMERIC(18, 6),
	        @CalculatedResult_1 NUMERIC(18, 6), @CalculatedResult_2 NUMERIC(18, 6), @CalculatedResult_3 NUMERIC(18, 6), @CalculatedApplyMaxValue NUMERIC(18, 6),
	        @FinalSARResult NUMERIC(18, 6), @ClosePrice_1 NUMERIC(18, 2), @ClosePrice_2 NUMERIC(18, 2),  @TaxFlag_1 CHAR(1), @TaxFlag_2 CHAR(1), @TaxFlag_3 CHAR(1),
	        @ApplyMaxTaxFlag CHAR(1), @TradeDayType VARCHAR(15)       
            
     DECLARE  
         @BasePrice INT = 1016,
	     @BASEDONTRANSDATEFORMULA INT = 1017,
	     @ClosingMarketPrice_Exercise INT = 1018,
	     @ClosingMarketPrice_Grant INT = 1019,
	     @ClosingMarketPrice_Vesting INT = 1020,
	     @VestingDateCodeId INT = 1001,
         @ExerciseDateCodeId INT = 1002,
         @GrantDateCodeId INT = 1003,
         @AllotmentDateCodeId INT = 1004,
         @TransactionDateId INT

     CREATE TABLE #TEMP_COMP_EMPLOYEE_DETAILS
     (  
        ID INT IDENTITY(1,1) NOT NULL,INSTRUMENT_ID	BIGINT ,EMPLOYEE_ID  VARCHAR(50) ,GRANTDATE  VARCHAR(200) ,VESTINGDATE VARCHAR(200), EXERCISE_DATE  DATETIME, EXERCISE_PRICE NUMERIC(18, 9), SCHEME_ID NVARCHAR(100), GRANTOPTIONID NVARCHAR(100)
     )     
     CREATE TABLE #TEMP_SAR_SETTLEMENT_DETAILS
     (  
        ID INT IDENTITY(1,1) NOT NULL,INSTRUMENT_ID	BIGINT ,EMPLOYEE_ID  VARCHAR(50), GRANTDATE  VARCHAR(200) ,VESTINGDATE VARCHAR(200),	EXERCISE_DATE  DATETIME, SAR_SETTLEMENT_VALUE  DECIMAL(18,4) NULL,TAXFLAG CHAR(1) NULL, EXERCISE_PRICE NUMERIC(18, 9), SCHEME_ID NVARCHAR(100), GRANTOPTIONID NVARCHAR(100)
     )  
     
     INSERT INTO #TEMP_COMP_EMPLOYEE_DETAILS 
	 (
	    INSTRUMENT_ID, EMPLOYEE_ID, GRANTDATE, VESTINGDATE, EXERCISE_DATE, EXERCISE_PRICE, SCHEME_ID, GRANTOPTIONID 
	 )
	 SELECT INSTRUMENT_ID, EMPLOYEE_ID, GRANTDATE,VESTINGDATE, EXERCISE_DATE, EXERCISE_PRICE, SCHEME_ID, GRANTOPTIONID
	 FROM @EMP_COMPARATIVE_DETAILS


 BEGIN TRY
 
  SELECT @MN_VALUE = MIN(ID ),@MX_VALUE = MAX(ID) FROM #TEMP_COMP_EMPLOYEE_DETAILS  	
  WHILE(@MN_VALUE <= @MX_VALUE)
  BEGIN
		SELECT @INSTRUMENT_ID = INSTRUMENT_ID, @EMPLOYEE_ID = EMPLOYEE_ID, @GRANTDATE = GRANTDATE, @VESTINGDATE=VESTINGDATE, @EXERCISE_DATE = EXERCISE_DATE, @EXERCISE_PRICE = EXERCISE_PRICE, @SCHEME_ID = SCHEME_ID, @GRANTOPTIONID = GRANTOPTIONID
		FROM #TEMP_COMP_EMPLOYEE_DETAILS  WHERE ID = @MN_VALUE   	
	  
	    SET @SCFC_ID = 0
	    SET @CalculatedValue_1 = 0
	    SET @CalculatedValue_2 = 0
		SET @CalculatedValue_3 = 0
	    SET @CalculatedResult_1 = 0
	    SET @CalculatedResult_2 = 0
	    SET @CalculatedResult_3 = 0
	    SET @CalculatedApplyMaxValue = 0
	    SET @FinalSARResult = 0
	    SET @ClosePrice_1 = 0
	    SET @ClosePrice_2 = 0		
	     	
 	    SELECT TOP 1 @TransactionDateId = TRANS_DATE_ID FROM SAR_COMPARE_FORMULA_CNFG WHERE SCHEME_ID = @SCHEME_ID AND MIT_ID = @INSTRUMENT_ID
			  AND ((CONVERT(DATE, APPLICABLE_FROM_DATE) <= CONVERT(DATE,@EXERCISE_DATE)) AND (CONVERT(DATE, ISNULL(APPLICABLE_TO_DATE, GETDATE())) >=  CONVERT(DATE,@EXERCISE_DATE)))	
			  AND IS_TRADINGDAYS = 1 ORDER BY SCFC_ID DESC
                     
		IF(@TransactionDateId = @VestingDateCodeId)
				SET @TransactionDate = @VESTINGDATE
		ELSE IF(@TransactionDateId = @ExerciseDateCodeId)
				SET @TransactionDate = @EXERCISE_DATE
		ELSE IF(@TransactionDateId = @GrantDateCodeId)
				SET @TransactionDate = @GRANTDATE
    
    
         IF((SELECT COUNT(*) AS NonTradeDay FROM NonTradingDays WHERE CONVERT(DATE,NonTradDay) = CONVERT(DATE,@TransactionDate)) > 0)
	     BEGIN 
	       -- FOR NON TRADING DAY	       
	       SELECT TOP 1 @SCFC_ID = SCFC_ID, @PERCENT_VALUE_1 = PERCENT_VALUE_1, @PERCENT_VALUE_ON_1 = PERCENT_VALUE_ON_1, @PERCENT_VALUE_2 = PERCENT_VALUE_2, @PERCENT_VALUE_ON_2 = PERCENT_VALUE_ON_2, @ON_LEVEL = ON_LEVEL, @ON_LEVEL_VALUE = ON_LEVEL_VALUE, 
                @APPLY_MAX_CAP = APPLY_MAX_CAP, @CONSIDER = CONSIDER , @MSE_ID_1 = MSE_ID_1, @MSE_ID_2 = MSE_ID_2, @SAR_TRANS_DATE_ID_1 = SAR_TRANS_DATE_ID_1, @SAR_TRANS_DATE_ID_2 = SAR_TRANS_DATE_ID_2, @TradeDayType = 'NonTradeDay'     
           FROM SAR_COMPARE_FORMULA_CNFG WHERE SCHEME_ID = @SCHEME_ID AND MIT_ID = @INSTRUMENT_ID
				  AND ((CONVERT(DATE, APPLICABLE_FROM_DATE) <= CONVERT(DATE,@EXERCISE_DATE)) AND (CONVERT(DATE, ISNULL(APPLICABLE_TO_DATE, GETDATE())) >=  CONVERT(DATE,@EXERCISE_DATE)))	
				  AND IS_TRADINGDAYS = 0 ORDER BY SCFC_ID DESC
	     
	     END
	     ELSE
	     BEGIN
	      -- FOR TRADING DAY	  
	       SELECT TOP 1 @SCFC_ID = SCFC_ID, @PERCENT_VALUE_1 = PERCENT_VALUE_1, @PERCENT_VALUE_ON_1 = PERCENT_VALUE_ON_1, @PERCENT_VALUE_2 = PERCENT_VALUE_2, @PERCENT_VALUE_ON_2 = PERCENT_VALUE_ON_2, @ON_LEVEL = ON_LEVEL, @ON_LEVEL_VALUE = ON_LEVEL_VALUE, 
                @APPLY_MAX_CAP = APPLY_MAX_CAP, @CONSIDER = CONSIDER , @MSE_ID_1 = MSE_ID_1, @MSE_ID_2 = MSE_ID_2, @SAR_TRANS_DATE_ID_1 = SAR_TRANS_DATE_ID_1, @SAR_TRANS_DATE_ID_2 = SAR_TRANS_DATE_ID_2, @TradeDayType = 'TradeDay'     
           FROM SAR_COMPARE_FORMULA_CNFG WHERE SCHEME_ID = @SCHEME_ID AND MIT_ID = @INSTRUMENT_ID
				  AND ((CONVERT(DATE, APPLICABLE_FROM_DATE) <= CONVERT(DATE,@EXERCISE_DATE)) AND (CONVERT(DATE, ISNULL(APPLICABLE_TO_DATE, GETDATE())) >=  CONVERT(DATE,@EXERCISE_DATE)))	
				  AND IS_TRADINGDAYS = 1 ORDER BY SCFC_ID DESC				  
	     END
    
         IF(@SCFC_ID > 0)
         BEGIN             
         -------------------------------------------- First Condition -------------------------------------------------------------------
         
             IF(ISNULL(@PERCENT_VALUE_ON_1, '') != '' AND @PERCENT_VALUE_ON_1 > 0)
             BEGIN
             
				 IF(@PERCENT_VALUE_ON_1 = @BasePrice)
				 BEGIN
				    -- Base Price  
				   SET @CalculatedValue_1 = @EXERCISE_PRICE
				   SET @TaxFlag_1 = 'A'       
				 END
				 ELSE IF(@PERCENT_VALUE_ON_1 = @BASEDONTRANSDATEFORMULA)
				 BEGIN
					  -- Based on Transcation date formula										
					
					  DECLARE @TYPE_SAR_TRANSACTION_DATE_1 dbo.TYPE_SAR_TRANSACTION_DATE
					  DELETE  FROM @TYPE_SAR_TRANSACTION_DATE_1
			           
					  INSERT INTO @TYPE_SAR_TRANSACTION_DATE_1		 
					  SELECT INSTRUMENT_ID, EMPLOYEE_ID, GRANTOPTIONID, GRANTDATE, VESTINGDATE, EXERCISE_DATE, ISNULL(@SAR_TRANS_DATE_ID_1,0) AS SAR_TRANS_DATE_ID FROM #TEMP_COMP_EMPLOYEE_DETAILS WHERE ID = @MN_VALUE
		              
					  EXEC PROC_GET_SAR_TRANS_DATE_VALUE @EMPLOYEE_TRANS_DETAILS = @TYPE_SAR_TRANSACTION_DATE_1, @CalledFrom = 'SSRSReport'
		               
					  SELECT TOP 1 @CalculatedValue_1 = TRANS_DATE_VALUE, @TaxFlag_1 = TAXFLAG FROM TEMP_TRANS_DATE_DETAILS
		              
					  IF EXISTS (SELECT * FROM SYS.tables WHERE name = 'TEMP_TRANS_DATE_DETAILS')
							DROP TABLE TEMP_TRANS_DATE_DETAILS					
					
				 END
				 ELSE IF(@PERCENT_VALUE_ON_1 = @ClosingMarketPrice_Exercise)
				 BEGIN
					-- Closing market price on date of exercise
		            
					IF EXISTS(SELECT ClosePrice FROM FMVSharePrices WHERE StockExchange IN (SELECT TOP 1 CASE STOCK_EXCHANGE_SYMBOL 
									WHEN 'NSE'  THEN 'N' 
									WHEN 'BSE'  THEN 'B' 
									WHEN 'NYSE'  THEN 'N'         
							   ELSE ''               
							   END AS StockExchange
							   FROM MST_STOCK_EXCHANGE WHERE MSE_ID = @MSE_ID_1)            
									AND TransactionDate = @EXERCISE_DATE)
					   BEGIN
							   SELECT @ClosePrice_1 = ClosePrice , @TaxFlag_1 = 'A' FROM FMVSharePrices WHERE StockExchange IN (SELECT TOP 1 CASE STOCK_EXCHANGE_SYMBOL 
											WHEN 'NSE'  THEN 'N' 
											WHEN 'BSE'  THEN 'B' 
											WHEN 'NYSE'  THEN 'N'         
									   ELSE ''               
									   END AS StockExchange
									   FROM MST_STOCK_EXCHANGE WHERE MSE_ID = @MSE_ID_1)            
											AND TransactionDate = @EXERCISE_DATE
					   END
					   ELSE
					   BEGIN
							   SELECT TOP 1 @ClosePrice_1 = ClosePrice, @TaxFlag_1 = 'T' FROM FMVSharePrices WHERE StockExchange IN (SELECT TOP 1 CASE STOCK_EXCHANGE_SYMBOL 
													WHEN 'NSE'  THEN 'N' 
													WHEN 'BSE'  THEN 'B' 
													WHEN 'NYSE'  THEN 'N'         
											   ELSE ''               
											   END AS StockExchange
											   FROM MST_STOCK_EXCHANGE WHERE MSE_ID = @MSE_ID_1)            
													AND TransactionDate <= @EXERCISE_DATE ORDER BY TransactionDate DESC								  
					   END
			           
					   IF(@ClosePrice_1 IS NOT NULL)
					   BEGIN
							SET @CalculatedValue_1 = @ClosePrice_1 
					   END
					   ELSE
							SET @CalculatedValue_1 = 0            
		            
		              
				 END
				 ELSE IF(@PERCENT_VALUE_ON_1 = @ClosingMarketPrice_Grant)
				 BEGIN
					-- Closing market price on date of grant
					IF EXISTS(SELECT ClosePrice FROM FMVSharePrices WHERE StockExchange IN (SELECT TOP 1 CASE STOCK_EXCHANGE_SYMBOL 
									WHEN 'NSE'  THEN 'N' 
									WHEN 'BSE'  THEN 'B' 
									WHEN 'NYSE'  THEN 'N'         
							   ELSE ''               
							   END AS StockExchange
							   FROM MST_STOCK_EXCHANGE WHERE MSE_ID = @MSE_ID_1)            
									AND TransactionDate = @GRANTDATE)
					   BEGIN
							   SELECT @ClosePrice_1 = ClosePrice , @TaxFlag_1 = 'A' FROM FMVSharePrices WHERE StockExchange IN (SELECT TOP 1 CASE STOCK_EXCHANGE_SYMBOL 
											WHEN 'NSE'  THEN 'N' 
											WHEN 'BSE'  THEN 'B' 
											WHEN 'NYSE'  THEN 'N'         
									   ELSE ''               
									   END AS StockExchange
									   FROM MST_STOCK_EXCHANGE WHERE MSE_ID = @MSE_ID_1)            
											AND TransactionDate = @GRANTDATE
					   END
					   ELSE
					   BEGIN
							   SELECT TOP 1 @ClosePrice_1 = ClosePrice, @TaxFlag_1 = 'T' FROM FMVSharePrices WHERE StockExchange IN (SELECT TOP 1 CASE STOCK_EXCHANGE_SYMBOL 
													WHEN 'NSE'  THEN 'N' 
													WHEN 'BSE'  THEN 'B' 
													WHEN 'NYSE'  THEN 'N'         
											   ELSE ''               
											   END AS StockExchange
											   FROM MST_STOCK_EXCHANGE WHERE MSE_ID = @MSE_ID_1)            
													AND TransactionDate <= @GRANTDATE ORDER BY TransactionDate DESC								  
					   END
			           
					   IF(@ClosePrice_1 IS NOT NULL)
					   BEGIN
							SET @CalculatedValue_1 = @ClosePrice_1 
					   END
					   ELSE
							SET @CalculatedValue_1 = 0    
				 END
				 ELSE IF(@PERCENT_VALUE_ON_1 = @ClosingMarketPrice_Vesting)
				 BEGIN
					-- Closing market price on date of vesting
		                      
					   IF EXISTS(SELECT ClosePrice FROM FMVSharePrices WHERE StockExchange IN (SELECT TOP 1 CASE STOCK_EXCHANGE_SYMBOL 
									WHEN 'NSE'  THEN 'N' 
									WHEN 'BSE'  THEN 'B' 
									WHEN 'NYSE'  THEN 'N'         
							   ELSE ''               
							   END AS StockExchange
							   FROM MST_STOCK_EXCHANGE WHERE MSE_ID = @MSE_ID_1)            
									AND TransactionDate = @VESTINGDATE)
					   BEGIN
							   SELECT @ClosePrice_1 = ClosePrice , @TaxFlag_1 = 'A' FROM FMVSharePrices WHERE StockExchange IN (SELECT TOP 1 CASE STOCK_EXCHANGE_SYMBOL 
											WHEN 'NSE'  THEN 'N' 
											WHEN 'BSE'  THEN 'B' 
											WHEN 'NYSE'  THEN 'N'         
									   ELSE ''               
									   END AS StockExchange
									   FROM MST_STOCK_EXCHANGE WHERE MSE_ID = @MSE_ID_1)            
											AND TransactionDate = @VESTINGDATE
					   END
					   ELSE
					   BEGIN
							   SELECT TOP 1 @ClosePrice_1 = ClosePrice, @TaxFlag_1 = 'T' FROM FMVSharePrices WHERE StockExchange IN (SELECT TOP 1 CASE STOCK_EXCHANGE_SYMBOL 
													WHEN 'NSE'  THEN 'N' 
													WHEN 'BSE'  THEN 'B' 
													WHEN 'NYSE'  THEN 'N'         
											   ELSE ''               
											   END AS StockExchange
											   FROM MST_STOCK_EXCHANGE WHERE MSE_ID = @MSE_ID_1)            
													AND TransactionDate <= @VESTINGDATE ORDER BY TransactionDate DESC								  
					   END
			           
					   IF(@ClosePrice_1 IS NOT NULL)
					   BEGIN
							SET @CalculatedValue_1 = @ClosePrice_1 
					   END
					   ELSE
							SET @CalculatedValue_1 = 0 
		             
				 END         
		         
				 SET @CalculatedResult_1 = ((@PERCENT_VALUE_1 * @CalculatedValue_1) / 100)  
			 
			 END 
			 ELSE
			 BEGIN
			     SET @CalculatedResult_1 = NULL
			     SET @TaxFlag_1 = 'A'  
			 END      
	         
			 ----------------------------------------- Second Condition ---------------------------------------------------------------------
	         
	         IF(ISNULL(@PERCENT_VALUE_ON_2, '') != '' AND @PERCENT_VALUE_ON_2 > 0)
	         BEGIN
	        
				 IF(@PERCENT_VALUE_ON_2 = @BasePrice)
				 BEGIN
				   -- Base Price  
				   SET @CalculatedValue_2 = @EXERCISE_PRICE  
				   SET @TaxFlag_2 = 'A'        
				 END
				 ELSE IF(@PERCENT_VALUE_ON_2 = @BASEDONTRANSDATEFORMULA)
				 BEGIN
					-- Based on Transcation date formula
					  DECLARE @TYPE_SAR_TRANSACTION_DATE_2 dbo.TYPE_SAR_TRANSACTION_DATE
					  DELETE  FROM @TYPE_SAR_TRANSACTION_DATE_2
			           
					  INSERT INTO @TYPE_SAR_TRANSACTION_DATE_2		 
					  SELECT INSTRUMENT_ID, EMPLOYEE_ID, GRANTOPTIONID, GRANTDATE, VESTINGDATE, EXERCISE_DATE, ISNULL(@SAR_TRANS_DATE_ID_1,0) AS SAR_TRANS_DATE_ID FROM #TEMP_COMP_EMPLOYEE_DETAILS WHERE ID = @MN_VALUE
		              
					  EXEC PROC_GET_SAR_TRANS_DATE_VALUE @EMPLOYEE_TRANS_DETAILS = @TYPE_SAR_TRANSACTION_DATE_2, @CalledFrom = 'SSRSReport'
		               
					  SELECT TOP 1 @CalculatedValue_1 = TRANS_DATE_VALUE, @TaxFlag_1 = TAXFLAG FROM TEMP_TRANS_DATE_DETAILS
		              
					  IF EXISTS (SELECT * FROM SYS.tables WHERE name = 'TEMP_TRANS_DATE_DETAILS')
							DROP TABLE TEMP_TRANS_DATE_DETAILS	
				 END
				 ELSE IF(@PERCENT_VALUE_ON_2 = @ClosingMarketPrice_Exercise)
				 BEGIN
					-- Closing market price on date of exercise
		            
					IF EXISTS(SELECT ClosePrice FROM FMVSharePrices WHERE StockExchange IN (SELECT TOP 1 CASE STOCK_EXCHANGE_SYMBOL 
									WHEN 'NSE'  THEN 'N' 
									WHEN 'BSE'  THEN 'B' 
									WHEN 'NYSE'  THEN 'N'         
							   ELSE ''               
							   END AS StockExchange
							   FROM MST_STOCK_EXCHANGE WHERE MSE_ID = @MSE_ID_2)            
									AND TransactionDate = @EXERCISE_DATE)
					   BEGIN
							   SELECT @ClosePrice_2 = ClosePrice , @TaxFlag_2 = 'A' FROM FMVSharePrices WHERE StockExchange IN (SELECT TOP 1 CASE STOCK_EXCHANGE_SYMBOL 
											WHEN 'NSE'  THEN 'N' 
											WHEN 'BSE'  THEN 'B' 
											WHEN 'NYSE'  THEN 'N'         
									   ELSE ''               
									   END AS StockExchange
									   FROM MST_STOCK_EXCHANGE WHERE MSE_ID = @MSE_ID_2)            
											AND TransactionDate = @EXERCISE_DATE
					   END
					   ELSE
					   BEGIN
							   SELECT TOP 1 @ClosePrice_2 = ClosePrice, @TaxFlag_2 = 'T' FROM FMVSharePrices WHERE StockExchange IN (SELECT TOP 1 CASE STOCK_EXCHANGE_SYMBOL 
													WHEN 'NSE'  THEN 'N' 
													WHEN 'BSE'  THEN 'B' 
													WHEN 'NYSE'  THEN 'N'         
											   ELSE ''               
											   END AS StockExchange
											   FROM MST_STOCK_EXCHANGE WHERE MSE_ID = @MSE_ID_2)            
													AND TransactionDate <= @EXERCISE_DATE ORDER BY TransactionDate DESC
					   END
			           
					   IF(@ClosePrice_2 IS NOT NULL)
					   BEGIN
							SET @CalculatedValue_2 = @ClosePrice_2 					
					   END
					   ELSE
					   BEGIN
							SET @CalculatedValue_2 = 0 					
					   END            
		              
				 END
				 ELSE IF(@PERCENT_VALUE_ON_2 = @ClosingMarketPrice_Grant)
				 BEGIN
					-- Closing market price on date of grant
					IF EXISTS(SELECT ClosePrice FROM FMVSharePrices WHERE StockExchange IN (SELECT TOP 1 CASE STOCK_EXCHANGE_SYMBOL 
									WHEN 'NSE'  THEN 'N' 
									WHEN 'BSE'  THEN 'B' 
									WHEN 'NYSE'  THEN 'N'         
							   ELSE ''               
							   END AS StockExchange
							   FROM MST_STOCK_EXCHANGE WHERE MSE_ID = @MSE_ID_2)            
									AND TransactionDate = @GRANTDATE)
					   BEGIN
							   SELECT @ClosePrice_2 = ClosePrice , @TaxFlag_2 = 'A' FROM FMVSharePrices WHERE StockExchange IN (SELECT TOP 1 CASE STOCK_EXCHANGE_SYMBOL 
											WHEN 'NSE'  THEN 'N' 
											WHEN 'BSE'  THEN 'B' 
											WHEN 'NYSE'  THEN 'N'         
									   ELSE ''               
									   END AS StockExchange
									   FROM MST_STOCK_EXCHANGE WHERE MSE_ID = @MSE_ID_2)            
											AND TransactionDate = @GRANTDATE
					   END
					   ELSE
					   BEGIN
							   SELECT TOP 1 @ClosePrice_2 = ClosePrice, @TaxFlag_2 = 'T' FROM FMVSharePrices WHERE StockExchange IN (SELECT TOP 1 CASE STOCK_EXCHANGE_SYMBOL 
													WHEN 'NSE'  THEN 'N' 
													WHEN 'BSE'  THEN 'B' 
													WHEN 'NYSE'  THEN 'N'         
											   ELSE ''               
											   END AS StockExchange
											   FROM MST_STOCK_EXCHANGE WHERE MSE_ID = @MSE_ID_2)            
													AND TransactionDate <= @GRANTDATE ORDER BY TransactionDate DESC
					   END
			           
					   IF(@ClosePrice_2 IS NOT NULL)
					   BEGIN
							SET @CalculatedValue_2 = @ClosePrice_2 					
					   END
					   ELSE
					   BEGIN
							SET @CalculatedValue_2 = 0 					
					   END
		           
		              
				 END
				 ELSE IF(@PERCENT_VALUE_ON_2 = @ClosingMarketPrice_Vesting)
				 BEGIN
					-- Closing market price on date of vesting
					IF EXISTS(SELECT ClosePrice FROM FMVSharePrices WHERE StockExchange IN (SELECT TOP 1 CASE STOCK_EXCHANGE_SYMBOL 
									WHEN 'NSE'  THEN 'N' 
									WHEN 'BSE'  THEN 'B' 
									WHEN 'NYSE'  THEN 'N'         
							   ELSE ''               
							   END AS StockExchange
							   FROM MST_STOCK_EXCHANGE WHERE MSE_ID = @MSE_ID_2)            
									AND TransactionDate = @VESTINGDATE)
					   BEGIN
							   SELECT @ClosePrice_2 = ClosePrice , @TaxFlag_2 = 'A' FROM FMVSharePrices WHERE StockExchange IN (SELECT TOP 1 CASE STOCK_EXCHANGE_SYMBOL 
											WHEN 'NSE'  THEN 'N' 
											WHEN 'BSE'  THEN 'B' 
											WHEN 'NYSE'  THEN 'N'         
									   ELSE ''               
									   END AS StockExchange
									   FROM MST_STOCK_EXCHANGE WHERE MSE_ID = @MSE_ID_2)            
											AND TransactionDate = @VESTINGDATE
					   END
					   ELSE
					   BEGIN
							   SELECT TOP 1 @ClosePrice_2 = ClosePrice, @TaxFlag_2 = 'T' FROM FMVSharePrices WHERE StockExchange IN (SELECT TOP 1 CASE STOCK_EXCHANGE_SYMBOL 
													WHEN 'NSE'  THEN 'N' 
													WHEN 'BSE'  THEN 'B' 
													WHEN 'NYSE'  THEN 'N'         
											   ELSE ''               
											   END AS StockExchange
											   FROM MST_STOCK_EXCHANGE WHERE MSE_ID = @MSE_ID_2)            
													AND TransactionDate <= @VESTINGDATE ORDER BY TransactionDate DESC
					   END
			           
					   IF(@ClosePrice_2 IS NOT NULL)
					   BEGIN
							SET @CalculatedValue_2 = @ClosePrice_2 					
					   END
					   ELSE
					   BEGIN
							SET @CalculatedValue_2 = 0 					
					   END
				 END         
		         
				 SET @CalculatedResult_2 = ((@PERCENT_VALUE_2 * @CalculatedValue_2) / 100) 
				
			 END
	         ELSE
			 BEGIN
			     SET @CalculatedResult_2 = NULL
			     SET @TaxFlag_2 = 'A'  
			 END 
			---------------------------------------------------- Third Condition --------------------------------------------------------------- 
	       
	         IF(ISNULL(@ON_LEVEL, '') != '')
	         BEGIN
				 IF(UPPER(@ON_LEVEL) = 'SCHEMELEVEL')
				 BEGIN
					SET @CalculatedValue_3 = @ON_LEVEL_VALUE
					SET @TaxFlag_3 = 'A'   
				 END
				 ELSE IF(UPPER(@ON_LEVEL) = 'GRANTLEVEL')
				 BEGIN
					SET @CalculatedValue_3 = ( SELECT TOP 1 CASE WHEN ISNULL(SARS_PRICE, '') = '' THEN 0 ELSE SARS_PRICE END AS SARS_PRICE 
					                           FROM GrantRegistration gr INNER JOIN GrantOptions gop ON gop.GrantRegistrationId = gr.GrantRegistrationId 
											   WHERE gop.GrantOptionId = @GRANTOPTIONID) 
					SET @TaxFlag_3 = 'A'   
				 END
		         
				 SET @CalculatedResult_3 = @CalculatedValue_3
				 
			 END
		     ELSE
			 BEGIN
			     SET @CalculatedResult_3 = NULL
			     SET @TaxFlag_3 = 'A'  
			 END
	         
		   ------------------------------------------------------ Apply Max Cap -------------------------------------------------------------
	         
			 IF(@APPLY_MAX_CAP = 1)
			 BEGIN
				 -- Consider Higher Or Lower from first two condition and apply max cap on third
	                          
				 IF(UPPER(@CONSIDER) = 'Higher')
				 BEGIN
					 SELECT @CalculatedApplyMaxValue = MAX(v) FROM (VALUES (@CalculatedResult_1), (@CalculatedResult_2)) AS value(v) WHERE v IS NOT NULL;
					 
					 IF (@CalculatedResult_1 > @CalculatedResult_2)				 					
						 SET @ApplyMaxTaxFlag = @TaxFlag_1				 
					 ELSE				 					
						 SET @ApplyMaxTaxFlag = @TaxFlag_2	
				 END 
				 ELSE IF(UPPER(@CONSIDER) = 'LOWER')
				 BEGIN
					 SELECT @CalculatedApplyMaxValue = MIN(v) FROM (VALUES (@CalculatedResult_1), (@CalculatedResult_2)) AS value(v) WHERE v IS NOT NULL;
					 
					 IF (@CalculatedResult_1 < @CalculatedResult_2)				 					
						SET @ApplyMaxTaxFlag = @TaxFlag_1				 
					 ELSE				 					
						SET @ApplyMaxTaxFlag = @TaxFlag_2			
				 END 
				 ELSE
				 BEGIN             
					SET @CalculatedApplyMaxValue = 0
					SET @ApplyMaxTaxFlag = 'A'
				 END
	            
				 SELECT @FinalSARResult = MIN(v) FROM (VALUES (@CalculatedApplyMaxValue), (@CalculatedResult_3)) AS value(v) WHERE v IS NOT NULL;
	             
				 IF (@CalculatedApplyMaxValue < @CalculatedResult_3)				 					
						SET @TAXFLAG = @ApplyMaxTaxFlag				 
					 ELSE				 					
						SET @TAXFLAG = @TaxFlag_3            
	 
			 END
			 ELSE
			 BEGIN
				 -- Consider Higher Or Lower all three conditions.      
	             
				 IF(UPPER(@CONSIDER) = 'HIGHER')
				 BEGIN
					 SELECT @FinalSARResult = MAX(v) FROM (VALUES (@CalculatedResult_1), (@CalculatedResult_2), (@CalculatedResult_3)) AS value(v) WHERE v IS NOT NULL;
					 				  
					 IF (@CalculatedResult_1 > @CalculatedResult_2)
					 BEGIN
						IF (@CalculatedResult_1 > @CalculatedResult_3)
						   SET @TAXFLAG = @TaxFlag_1					
						ELSE
						   SET @TAXFLAG = @TaxFlag_3					
					 END
					 ELSE
					 BEGIN
						IF (@CalculatedResult_2 > @CalculatedResult_3)
							SET @TAXFLAG = @TaxFlag_2
						ELSE
							SET @TAXFLAG = @TaxFlag_3
					 END       
					 
				 END IF(UPPER(@CONSIDER) = 'LOWER')
				 BEGIN
					 SELECT @FinalSARResult = MIN(v) FROM (VALUES (@CalculatedResult_1), (@CalculatedResult_2), (@CalculatedResult_3)) AS value(v) WHERE v IS NOT NULL;
					 
					 IF (@CalculatedResult_1 < @CalculatedResult_2)
					 BEGIN
						IF (@CalculatedResult_1 < @CalculatedResult_3)
						   SET @TAXFLAG = @TaxFlag_1					
						ELSE
						   SET @TAXFLAG = @TaxFlag_3					
					 END
					 ELSE
					 BEGIN
						IF (@CalculatedResult_2 < @CalculatedResult_3)
							SET @TAXFLAG = @TaxFlag_2
						ELSE
							SET @TAXFLAG = @TaxFlag_3
					 END
					 
				 END 
				 ELSE
				 BEGIN
					 IF(@CalculatedResult_1 != 0)
					 BEGIN
						  SET @FinalSARResult = @CalculatedResult_1  
						  SET @TAXFLAG = @TaxFlag_1
					 END                 
					 ELSE IF(@CalculatedResult_2 != 0)
					 BEGIN
						  SET @FinalSARResult = @CalculatedResult_2
						  SET @TAXFLAG = @TaxFlag_2
					 END
					 ELSE IF(@CalculatedResult_3 != 0)
					 BEGIN
						  SET @FinalSARResult = @CalculatedResult_3
						  SET @TAXFLAG = @TaxFlag_3
					 END
				 END
			 END   
		   
		 END
		 ELSE
		 BEGIN
		   SET @FinalSARResult = NULL
		   SET @TAXFLAG = NULL
		 END
		 
		 IF(@TradeDayType = 'NonTradeDay')
			SET @TAXFLAG = 'A'
		   
		 INSERT INTO #TEMP_SAR_SETTLEMENT_DETAILS 
		 (
		   INSTRUMENT_ID, EMPLOYEE_ID, GRANTDATE, VESTINGDATE, EXERCISE_DATE, SAR_SETTLEMENT_VALUE, TAXFLAG, EXERCISE_PRICE, SCHEME_ID, GRANTOPTIONID
		 )
		 SELECT @INSTRUMENT_ID,@EMPLOYEE_ID, @GRANTDATE,@VESTINGDATE,@EXERCISE_DATE, @FinalSARResult, @TAXFLAG, @EXERCISE_PRICE, @SCHEME_ID, @GRANTOPTIONID
		  
		 SET @MN_VALUE = @MN_VALUE + 1	
		 
END

 	
   IF(ISNULL(@CalledFrom,'') <> 'SSRSReport')	  
   BEGIN
    SELECT ID, INSTRUMENT_ID, EMPLOYEE_ID, GRANTDATE, VESTINGDATE, EXERCISE_DATE, SAR_SETTLEMENT_VALUE, TAXFLAG, EXERCISE_PRICE, SCHEME_ID, GRANTOPTIONID FROM #TEMP_SAR_SETTLEMENT_DETAILS
   END
   
   
   
	IF EXISTS (SELECT * FROM SYS.tables WHERE name = 'TEMP_SAR_SETTLEMENT_DETAILS')
		DROP TABLE TEMP_SAR_SETTLEMENT_DETAILS
	
    
	SELECT 
		ID, INSTRUMENT_ID, EMPLOYEE_ID, GRANTDATE, VESTINGDATE, EXERCISE_DATE, SAR_SETTLEMENT_VALUE, TAXFLAG, EXERCISE_PRICE, 
		SCHEME_ID, GRANTOPTIONID
 	INTO 
		TEMP_SAR_SETTLEMENT_DETAILS 
	FROM 
		#TEMP_SAR_SETTLEMENT_DETAILS


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
    
 
     DROP TABLE #TEMP_COMP_EMPLOYEE_DETAILS
     DROP TABLE #TEMP_SAR_SETTLEMENT_DETAILS  
     
	SET NOCOUNT OFF;
		
END
GO
