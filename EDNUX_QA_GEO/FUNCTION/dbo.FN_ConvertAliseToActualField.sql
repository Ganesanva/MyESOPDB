/****** Object:  UserDefinedFunction [dbo].[FN_ConvertAliseToActualField]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP FUNCTION IF EXISTS [dbo].[FN_ConvertAliseToActualField]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_ConvertAliseToActualField]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_ConvertAliseToActualField] 
(
	@InputFormula VARCHAR(MAX)
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	 -- Replace with Service Tax on bank charges to STBC
      SET @InputFormula= REPLACE(@InputFormula, 'ServiceTaxonBankCharges','STBC')
	  -- Create temp table for getting autual and alise name 
	  DECLARE @TEMP TABLE
      (
            IDs INT IDENTITY(1,1),
            FieldName VARCHAR(50),
            AliseName VARCHAR(50)
      )

      INSERT INTO @TEMP  SELECT Field_Name,Alise_Name FROM FIELD_MASTER 
      
      DECLARE @Min INT,@Max INT
      SELECT @Min=MIN(IDs),@Max=MAX(IDs) FROM @TEMP
      DECLARE @TempFieldName VARCHAR(50),@TempAliseName VARCHAR(50)
      WHILE(@Min<=@Max) -- while loop for replace alise to actual field name
      BEGIN
      SELECT @TempAliseName=AliseName,@TempFieldName=FieldName FROM @TEMP WHERE IDs=@Min
      SET @InputFormula=REPLACE(@InputFormula,@TempAliseName,@TempFieldName)
      SET @Min=@Min+1
      END
      SET @InputFormula=REPLACE(@InputFormula,'STBC','Service tax on Bank Charges');
	  --Return result
	RETURN @InputFormula

END
GO
