/****** Object:  StoredProcedure [dbo].[PROC_SAVE_PREVESTING_IN_AUDIT_DATA]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].PROC_SAVE_PREVESTING_IN_AUDIT_DATA
GO
/****** Object:  StoredProcedure [dbo].[PROC_SAVE_PREVESTING_IN_AUDIT_DATA]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_SAVE_PREVESTING_IN_AUDIT_DATA] 
(
	@ExerciseId NUMERIC(18)
)
AS
BEGIN	

	SET NOCOUNT ON;
		DECLARE	@CompanyID VARCHAR(20)

		SELECT @CompanyID = CompanyID FROM CompanyParameters
		
		IF NOT EXISTS (SELECT * FROM AuditData WHERE (ExerciseId = @ExerciseId))
		
		BEGIN 
		
		   	INSERT INTO AuditData
		   	(
  				ExerciseId, ExerciseNo, FMV, PaymentDateTime, ExerciseAmount, TaxRate, PerqVal, PerqTax, MarketPrice, PaymentMode, LoginHistoryId, CashlessChgsAmt
		  	)
			SELECT 
				ExerciseId, ExerciseNO, TentativeFMVPrice,
				GL.FinalVestingDate/*+ CAST(GETDATE() AS TIME)*/, --In SQL 2019 standard version it's supporting but in SQL 2019 developer it's throwing error
				 ExercisePrice * SH.ExercisedQuantity, 
				Perq_Tax_rate,TentativePerqstValue ,
				TentativePerqstPayable, 
				(SELECT TOP 1 ClosePrice FROM SharePrices WHERE PriceDate = (SELECT MAX(PriceDate) FROM SharePrices)),
				PaymentMode, 0, 
				(SELECT TOP 1 dbo.FN_GET_CASHLESSCHARGES(@CompanyID, GL.FinalVestingDate, MIT_ID, SH.ExercisedQuantity))
			FROM 
				ShExercisedOptions  AS SH
				INNER JOIN GrantLeg AS GL ON GL.ID = SH.GrantLegSerialNumber
				WHERE (LEN(ISNULL(PaymentMode, '')) <> 0)  AND SH.ExerciseId = @ExerciseId
				
		END
		ELSE
		BEGIN
		      UPDATE AuditData SET Paymentmode = (SELECT Paymentmode FROM ShExercisedOptions WHERE ExerciseId = @ExerciseId)
		 
		END 
	
END


