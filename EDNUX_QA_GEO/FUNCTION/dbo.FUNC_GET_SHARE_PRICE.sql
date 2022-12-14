/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_SHARE_PRICE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP FUNCTION IF EXISTS [dbo].[FUNC_GET_SHARE_PRICE]
GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_SHARE_PRICE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FUNC_GET_SHARE_PRICE]
(
	-- Add the parameters for the function here
	@ExerciseDate DATETIME
)
RETURNS NUMERIC (18,6)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @SharePriceDate DATETIME
	DECLARE @PerqCalcOn VARCHAR(10)
	DECLARE @PerqCalcDay VARCHAR(10)
	DECLARE @SharePriceOption VARCHAR(10)
	DECLARE @ExchangeType VARCHAR(10)
	DECLARE @TRADINGNONTRAIDDAY VARCHAR(5)
	DECLARE @SQL_QUERY VARCHAR(MAX) 
	
	IF((SELECT ListedYN FROM CompanyParameters) = 'N')
		BEGIN
			-- GET FMV FOR UNLISTED COMPANY
			SET @SQL_QUERY = (SELECT FMV FROM FMVForUnlisted WHERE CONVERT(DATE,@ExerciseDate) BETWEEN CONVERT(DATE,FMV_FromDate) AND CONVERT(DATE,FMV_Todate))
		END
	ELSE
		BEGIN
			-- GET FMV FOR LISTED COMPANY
			
			SELECT @ExchangeType = ISNULL(PreqTax_ExchangeType,''), @SharePriceOption = ISNULL(PreqTax_Shareprice,''), @PerqCalcOn = ISNULL( PreqTax_Calculateon,''),
			@PerqCalcDay = ISNULL(prqustcalcon,'') FROM companyparameters
			--PRINT 'ExchangeType : '+ @ExchangeType + ' SharePriceOption : '+ @SharePriceOption + ' PerqCalcOn : '+ @PerqCalcOn + ' PerqCalcDay : '+ @PerqCalcDay
			
			SET @TRADINGNONTRAIDDAY = 'TRD'
			
			-- IF QUERY GIVE OUTOPUT THEN CONSIDER AS NON TRADING DAY OTHER WISE TRADING DAY
			IF((SELECT COUNT(*) AS NonTradeDay FROM NonTradingDays WHERE CONVERT(DATE,NonTradDay) = CONVERT(DATE,@ExerciseDate)) > 0)
			BEGIN
				SET @ExerciseDate = 
				(SELECT MAX(PriceDate) AS PriceDate FROM SharePrices WHERE CONVERT(DATE,PriceDate) < CONVERT(DATE,@ExerciseDate)) 
				SET @TRADINGNONTRAIDDAY = 'NTRD'
				--PRINT 'WHEN NON TRADING DAY EXERCISDE DATE ' + CONVERT(VARCHAR(100),@ExerciseDate)
				 			
			END
			
			--PRINT @TRADINGNONTRAIDDAY
			--PRINT 'EXERCISDE DATE ' + CONVERT(VARCHAR(100),@ExerciseDate)				
			--PRINT @SharePriceOption
			
			IF(@SharePriceOption = '1')
				BEGIN
					--PRINT 'CASE 1 EXECUATED'
					-- GET CLOSING PRICE AS PER PERQUSITE STOCK EXCHANGE TYPE
					SET @SQL_QUERY = (SELECT ClosePrice AS SharePrice FROM dbo.FMVSharePrices 
					WHERE (CONVERT(DATE,PriceDate) = CONVERT(DATE, @ExerciseDate)) AND (StockExchange = @ExchangeType))
				END
			ELSE IF(@SharePriceOption = '2')
				BEGIN
					--PRINT 'CASE 2 EXECUATED'
					-- GET AVG OF CLOSEPRICE AND OPENPRICE AS PER THE PERQUISITE STOCK EXCHANGE TYPE
					IF(@TRADINGNONTRAIDDAY = 'TRD')
						BEGIN
							SET @SQL_QUERY = (SELECT ((ISNULL(ClosePrice,0) + ISNULL(OpenPrice,0))/2) AS SharePrice FROM dbo.FMVSharePrices 
							WHERE (CONVERT(DATE,PriceDate) = CONVERT(DATE, @ExerciseDate)) AND (StockExchange = @ExchangeType))
						END
					ELSE
						BEGIN
							SET @SQL_QUERY = (SELECT ISNULL(ClosePrice,0) AS SharePrice FROM dbo.FMVSharePrices 
							WHERE (CONVERT(DATE,PriceDate) = CONVERT(DATE, @ExerciseDate)) AND (StockExchange = @ExchangeType))
						END
				END
			ELSE IF(@SharePriceOption = '3')
				BEGIN
					--PRINT 'CASE 3 EXECUATED'
					-- GET CLOSING PRICE WHERE STOCK IS HIGHEST TRADED
					SET @SQL_QUERY = (SELECT MAX(ClosePrice) AS SharePrice FROM dbo.FMVSharePrices 
					WHERE Volume IN (SELECT MAX(Volume) FROM dbo.FMVSharePrices WHERE (CONVERT(DATE,PriceDate) = CONVERT(DATE, @ExerciseDate))) 
					AND (CONVERT(DATE, PriceDate) = CONVERT(DATE, @ExerciseDate)))
				END
			ELSE IF(@SharePriceOption = '4')
				BEGIN
					--PRINT 'CASE 4 EXECUATED'
					-- GET AVG OF CLOSING ,OPENING PRICE WHERE STOCK IS HIGHEST TRADED					
					IF(@TRADINGNONTRAIDDAY = 'TRD')
						BEGIN
							SET @SQL_QUERY = (SELECT ((ISNULL(ClosePrice,0) + ISNULL(OpenPrice,0))/2) AS SharePrice FROM dbo.FMVSharePrices  
							WHERE Volume IN (SELECT MAX(Volume) FROM dbo.FMVSharePrices WHERE (CONVERT(DATE,PriceDate) = CONVERT(DATE, @ExerciseDate))) 
							AND (CONVERT(DATE,PriceDate) = CONVERT(DATE, @ExerciseDate)))
						END
					ELSE
						BEGIN
							IF(@PerqCalcDay = 'P')
								BEGIN
									SET @SQL_QUERY = (SELECT ((ISNULL(ClosePrice ,0) + ISNULL(OpenPrice,0))/2) AS SharePrice FROM dbo.FMVSharePrices 
									WHERE Volume IN (SELECT MAX( Volume ) FROM dbo.FMVSharePrices WHERE (CONVERT(DATE,PriceDate) = CONVERT(DATE, @ExerciseDate))) 
									AND (CONVERT(DATE,PriceDate) = CONVERT(DATE, @ExerciseDate)))
								END
							ELSE
								BEGIN
									SET @SQL_QUERY = (SELECT ISNULL(ClosePrice,0) AS SharePrice FROM dbo.FMVSharePrices  
									WHERE Volume IN (SELECT MAX( Volume ) FROM dbo.FMVSharePrices WHERE (CONVERT(DATE,PriceDate) = CONVERT(DATE, @ExerciseDate))) 
									AND (CONVERT(DATE,PriceDate) = CONVERT(DATE, @ExerciseDate)))
								END
						END
				END	

		END
	
	--Return the result of the function
	RETURN  @SQL_QUERY

END
GO
