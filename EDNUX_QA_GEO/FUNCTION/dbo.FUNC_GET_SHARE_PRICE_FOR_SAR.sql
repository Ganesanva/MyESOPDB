/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_SHARE_PRICE_FOR_SAR]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP FUNCTION IF EXISTS [dbo].[FUNC_GET_SHARE_PRICE_FOR_SAR]
GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_SHARE_PRICE_FOR_SAR]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FUNC_GET_SHARE_PRICE_FOR_SAR]
(
	-- Add the parameters for the function here
	@ExerciseDate DATETIME
)
RETURNS NUMERIC (18,6)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @SQL_QUERY VARCHAR(MAX) 
	DECLARE @NON_TRADING_DATE DATE
	DECLARE @NCOUNT INT
	SET @NCOUNT = 0
	
	WHILE (@NON_TRADING_DATE IS NULL)
	BEGIN
		
		SET @NCOUNT = @NCOUNT + 1
		--PRINT @NCOUNT
		
		SELECT @NON_TRADING_DATE = NonTradDay FROM NonTradingDays WHERE CONVERT(DATE,NonTradDay) = CONVERT(DATE, @ExerciseDate)
		GROUP BY NonTradDay
				
		IF(@NON_TRADING_DATE IS NOT NULL)
			BEGIN
				--PRINT 'NON TRADING DATE : ' + CONVERT(VARCHAR(100),@ExerciseDate)
				SET @ExerciseDate = @ExerciseDate - 1
				SET @NON_TRADING_DATE = NULL
				CONTINUE;
			END
		ELSE
			BEGIN
				--PRINT 'TRADING DATE : ' + CONVERT(VARCHAR(100),@ExerciseDate)
				SET @ExerciseDate = @ExerciseDate
				BREAK
			END				
	END
		
	--PRINT @ExerciseDate
	
	SET @SQL_QUERY = 
	(
		SELECT MAX(closeprice) AS shareprice FROM dbo.FMVSharePrices WHERE (Volume IN (SELECT MAX( Volume ) FROM dbo.FMVSharePrices WHERE PriceDate = @ExerciseDate) AND PriceDate = @ExerciseDate)
	)
	
	--Return the result of the function
	RETURN  @SQL_QUERY

END
GO
