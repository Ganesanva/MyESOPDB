/****** Object:  StoredProcedure [dbo].[ConvertAliseToActualField]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ConvertAliseToActualField]
GO
/****** Object:  StoredProcedure [dbo].[ConvertAliseToActualField]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*--------------------------------------------------------------------------------------
Create By: Chetan Kumare Tembhre
Create Date: 08-Feb-2013
Description: Convert CGT alise formula field to actual field name
exec ConvertAliseToActualField '(SharesSold * AvgSellingPrice ) - ( AvgTransChargesPaid + AvgServiceTaxontransachargesPaid + AvgBrokerChargesPaid + AvgSerTaxonBrokerageChargesPaid + AvgSTTPaid + AvgSEBIFeePaid + AvgStampdutyPaid + CAFillings + ServiceTaxOnCAFillingFees + BankCharges + ServiceTaxonBankCharges ) - CASHLESSCHGS - ( SharesSold * FMV )'
--------------------------------------------------------------------------------------*/

CREATE PROC [dbo].[ConvertAliseToActualField]
@InputFormula VARCHAR(MAX)
AS
BEGIN
      -- Replace with Service Tax on bank charges to STBC
      SET @InputFormula= REPLACE(@InputFormula, 'ServiceTaxonBankCharges','STBC')
	  -- Create temp table for getting autual and alise name 
	  CREATE TABLE #TEMP
      (
            IDs INT IDENTITY(1,1),
            FieldName VARCHAR(50),
            AliseName VARCHAR(50)
      )

      INSERT INTO #TEMP  SELECT Field_Name,Alise_Name FROM FIELD_MASTER 
      
      DECLARE @Min INT,@Max INT
      SELECT @Min=MIN(IDs),@Max=MAX(IDs) FROM #TEMP
      DECLARE @TempFieldName VARCHAR(50),@TempAliseName VARCHAR(50)
      WHILE(@Min<=@Max) -- while loop for replace alise to actual field name
      BEGIN
      SELECT @TempAliseName=AliseName,@TempFieldName=FieldName FROM #TEMP WHERE IDs=@Min
      SET @InputFormula=REPLACE(@InputFormula,@TempAliseName,@TempFieldName)
      SET @Min=@Min+1
      END
      SET @InputFormula=REPLACE(@InputFormula,'STBC','Service tax on Bank Charges');
	  --Return result
      SELECT @InputFormula AS Result

END
GO
