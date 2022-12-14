DROP FUNCTION IF EXISTS [dbo].[FN_GET_COMPANY_DECIMAL_SETTING]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GET_COMPANY_DECIMAL_SETTING]    Script Date: 18-07-2022 21:00:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[FN_GET_COMPANY_DECIMAL_SETTING]
(
      @ROUNDING_VALUE NVARCHAR(50),
      @ROUNDING_PARAM NVARCHAR(50)
)
RETURNS FLOAT
AS      
BEGIN
		DECLARE @SQL_QUERY FLOAT
		DECLARE @ROUNDING_PLACE_VALUE INT 
		DECLARE @ROUNDING_PLACE_PARM VARCHAR(1)
				
		IF(UPPER(@ROUNDING_PARAM) =UPPER('EXERCISEPRICE'))
		BEGIN
			SELECT @ROUNDING_PLACE_VALUE= ISNULL(RoundupPlace_ExercisePrice,0) , @ROUNDING_PLACE_PARM = ISNULL(RoundingParam_ExercisePrice,'') FROM CompanyParameters		
		END
		ELSE IF(UPPER(@ROUNDING_PARAM) =UPPER('EXERCISEAMOUNT'))
		BEGIN
			SELECT @ROUNDING_PLACE_VALUE= ISNULL(RoundupPlace_ExerciseAmount,0) , @ROUNDING_PLACE_PARM = ISNULL(RoundingParam_ExerciseAmount,'') FROM CompanyParameters		
		END
		ELSE IF(UPPER(@ROUNDING_PARAM) =UPPER('FMV'))
		BEGIN
			SELECT @ROUNDING_PLACE_VALUE= ISNULL(RoundupPlace_FMV,0), @ROUNDING_PLACE_PARM = ISNULL(RoundingParam_FMV,'') FROM CompanyParameters
		END
		ELSE IF(UPPER(@ROUNDING_PARAM) =UPPER('TAXAMT'))
		BEGIN
			/*For perquisite Payable tax*/
			SELECT @ROUNDING_PLACE_VALUE= ISNULL(RoundupPlace_TaxAmt,0), @ROUNDING_PLACE_PARM = ISNULL(RoundingParam_Taxamt,'') FROM CompanyParameters
		END
		ELSE IF(UPPER(@ROUNDING_PARAM) =UPPER('TAXVALUE'))
		BEGIN
			/*For perquisite value*/
			SELECT @ROUNDING_PLACE_VALUE= ISNULL(RoundupPlace_TaxableVal,0), @ROUNDING_PLACE_PARM = ISNULL(RoundingParam_TaxableVal,'') FROM CompanyParameters
		END
		ELSE
		BEGIN
			SET @ROUNDING_PLACE_VALUE= 0 SET @ROUNDING_PLACE_PARM='N'
		END
		
		
		IF(UPPER(@ROUNDING_PLACE_PARM) = 'N')
		BEGIN				
			SET @SQL_QUERY =
			(SELECT 
			(CASE WHEN ABS(CONVERT(NUMERIC(18,9), @ROUNDING_VALUE) - ROUND(CONVERT(NUMERIC(18,9), @ROUNDING_VALUE), @ROUNDING_PLACE_VALUE, 1)) * POWER(10, @ROUNDING_PLACE_VALUE + 1) = 6 
				THEN 
					ROUND(CONVERT(NUMERIC(18,9), @ROUNDING_VALUE), @ROUNDING_PLACE_VALUE, 
						CASE WHEN CONVERT(INT, ROUND(ABS(CONVERT(NUMERIC(18,9), @ROUNDING_VALUE)) * POWER(10, @ROUNDING_PLACE_VALUE), 0, 1)) % 2 = 1 
						THEN 
							0 
						ELSE 
							1 
						END)
				ELSE 
					ROUND(CONVERT(NUMERIC(18,9), @ROUNDING_VALUE), @ROUNDING_PLACE_VALUE)
				END)) 		
		END
		ELSE IF(UPPER(@ROUNDING_PLACE_PARM) = 'C')
		BEGIN			
			SET @SQL_QUERY = 
			 (	
				--CASE WHEN ABS(CONVERT(NUMERIC(18,9),@ROUNDING_VALUE) - ROUND(CONVERT(NUMERIC(18,9),@ROUNDING_VALUE), @ROUNDING_PLACE_VALUE, 1)) * POWER(10, @ROUNDING_PLACE_VALUE+1) = 6 
				--	THEN CEILING(CONVERT(NUMERIC(18,9),@ROUNDING_VALUE) * Power(10,@ROUNDING_PLACE_VALUE))/POWER(10, @ROUNDING_PLACE_VALUE)
				--   ELSE ROUND(CONVERT(NUMERIC(18,9),@ROUNDING_VALUE), @ROUNDING_PLACE_VALUE)
				--END
				CEILING(CONVERT(NUMERIC(18,9),@ROUNDING_VALUE) * Power(10,@ROUNDING_PLACE_VALUE))/POWER(10, @ROUNDING_PLACE_VALUE)
			 )
		END
		ELSE IF(UPPER(@ROUNDING_PLACE_PARM) = 'F')
		BEGIN	
			SET @SQL_QUERY = 
			(		
				--CASE WHEN ABS(CONVERT(NUMERIC(18,9),@ROUNDING_VALUE)- ROUND(CONVERT(NUMERIC(18,9),@ROUNDING_VALUE), @ROUNDING_PLACE_VALUE, 1)) * POWER(10, @ROUNDING_PLACE_VALUE+1) = 6 
				--		THEN FLOOR(CONVERT(NUMERIC(18,9),@ROUNDING_VALUE) * POWER(10,@ROUNDING_PLACE_VALUE))/POWER(10, @ROUNDING_PLACE_VALUE)
				--	ELSE ROUND( @ROUNDING_VALUE, @ROUNDING_PLACE_VALUE)
				--END
				FLOOR(CONVERT(NUMERIC(18,9),@ROUNDING_VALUE) * POWER(10,@ROUNDING_PLACE_VALUE))/POWER(10, @ROUNDING_PLACE_VALUE)
			)
		END
		
		RETURN @SQL_QUERY

END
GO


