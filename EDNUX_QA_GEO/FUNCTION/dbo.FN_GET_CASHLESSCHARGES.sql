/****** Object:  UserDefinedFunction [dbo].[FN_GET_CASHLESSCHARGES]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP FUNCTION IF EXISTS [dbo].[FN_GET_CASHLESSCHARGES]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GET_CASHLESSCHARGES]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_GET_CASHLESSCHARGES] 
(	
    @CompanyId			VARCHAR(20),
	@ExerciseDate		DATETIME,    
    @InstrumentTypeID	INT,
    @OptionsExercised	INT   
)
RETURNS NUMERIC(18, 2)
AS
BEGIN
  
		DECLARE @ChargesPaidByName VARCHAR(50), @CalulationBasedOnId INT, @PricePerOptionAmt FLOAT, @OnsellingPricePercent FLOAT,
               @CashlessChgsAmt DECIMAL(18, 2), @ClosingMarketPrice DECIMAL(18, 2)
               
        SELECT @ClosingMarketPrice = ClosePrice FROM SharePrices WHERE PriceDate = (SELECT MAX(PriceDate) FROM SharePrices)
        SET @CashlessChgsAmt = 0
                        
		SELECT  TOP(1) 
			@ChargesPaidByName = CPM.ChargesPaidByName,
			@CalulationBasedOnId = TC.CalulationBasedOnId,
			@PricePerOptionAmt = TC.PricePerOptionAmt,
			@OnsellingPricePercent = TC.OnsellingPricePercent
		FROM TrustGlobal..TrustCashlessDetails TC 
			INNER JOIN TrustGlobal..ChargePaidByMaster CPM ON TC.ChargesPaidByID = CPM.ChargesPaidByID  
			INNER JOIN TrustGlobal..Trust T  ON TC.TrustID = T.TrustID   
		WHERE TC.CompanyID= @companyId AND CONVERT (DATE, @ExerciseDate ) BETWEEN CONVERT (DATE,TC.FROMDATE) AND CONVERT (DATE,TC.TODATE) AND T.IsCashless = 1 
			AND TC.InstrumentTypeID = @InstrumentTypeID 
		ORDER BY TC.TrustCashlessID DESC
		         
        IF (UPPER(@ChargesPaidByName) = 'COMPANY')
        BEGIN          
            SET @CashlessChgsAmt = 0
        END
        ELSE IF (UPPER(@ChargesPaidByName) = 'EMPLOYEE')
        BEGIN
                IF (@CalulationBasedOnId = 1)
                BEGIN                                    
                    SET @CashlessChgsAmt = @OptionsExercised * @PricePerOptionAmt
                END
                ELSE IF (@CalulationBasedOnId = 2)
                BEGIN                                    
                    SET @CashlessChgsAmt = (@OptionsExercised * @ClosingMarketPrice * @OnsellingPricePercent) / 100
                END
        END
		
		RETURN @CashlessChgsAmt	
END

GO
