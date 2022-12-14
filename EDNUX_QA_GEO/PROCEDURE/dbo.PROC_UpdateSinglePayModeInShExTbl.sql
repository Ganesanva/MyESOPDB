/****** Object:  StoredProcedure [dbo].[PROC_UpdateSinglePayModeInShExTbl]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UpdateSinglePayModeInShExTbl]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UpdateSinglePayModeInShExTbl]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_UpdateSinglePayModeInShExTbl]
	@ExerciseNo		NUMERIC(18,0),
	@PaymentMode	CHAR(1)
AS
BEGIN
	 UPDATE ShExercisedOptions SET PaymentMode=@PaymentMode,isFormGenerate = 0,IS_UPLOAD_EXERCISE_FORM = NULL,IS_UPLOAD_EXERCISE_FORM_ON=NULL WHERE ExerciseNo=@ExerciseNo
	 --select PaymentMode from ShExercisedOptions where ExerciseNo=@ExerciseNo
	 Declare @PaymentID BIGINT 
	 SET @PaymentID=(Select ID FRom PaymentMaster Where PaymentMode=@PaymentMode)
	 IF EXISTS(SELECT 1 FROM TRANSACTIONS_EXERCISE_STEP WHERE EXERCISE_NO = @ExerciseNo)
	 BEGIN	     
		 UPDATE TES SET IS_ATTEMPTED = CASE WHEN(EXERCISE_STEPID=1 )THEN 1 
		 --WHEN(Form_TYPE<>'MSSB' AND EXERCISE_STEPID=2  AND IS_ATTEMPTED=1 ) THEN 0 
		 WHEN(dbo.FN_GET_FORM_TYPE(@PaymentID, SHEX.MIT_ID,@ExerciseNo)='MSSB' AND EXERCISE_STEPID=2 AND (SHEX.PaymentMode='A' OR SHEX.PaymentMode='P')  )THEN 1  ELSE 0 END , 
         ISATTEMPTED_ON = CASE WHEN(EXERCISE_STEPID=1 OR  EXERCISE_STEPID=2 )THEN GETDATE() 
		 --WHEN(Form_TYPE<>'MSSB' AND EXERCISE_STEPID=2  AND IS_ATTEMPTED=1 ) THEN 0 
		 WHEN(dbo.FN_GET_FORM_TYPE(@PaymentID, SHEX.MIT_ID,@ExerciseNo)='MSSB' AND EXERCISE_STEPID=2 AND (SHEX.PaymentMode='A' OR SHEX.PaymentMode='P')  )THEN GETDATE()  ELSE Null END,
		 UPDATED_BY = SHEX.EmployeeID , UPDATED_ON = GETDATE()
		 FROM TRANSACTIONS_EXERCISE_STEP TES INNER JOIN ShExercisedOptions SHEX 
		 ON TES.EXERCISE_NO = SHEX.ExerciseNo 
		 WHERE EXERCISE_NO = @ExerciseNo and EXERCISE_STEPID  in (1,2) and (ISNULL(SHEX.PaymentMode,'') <> '' OR SHEX.MIT_ID = 5 OR SHEX.MIT_ID = 7)
	 END


	 IF EXISTS(SELECT Id FROM PaymentSelectionDate where ExerciseNo = @ExerciseNo )
	 BEGIN
	     UPDATE PaymentSelectionDate SET Paymentdate  = CONVERT(date, GETDATE()) WHERE ExerciseNo  = @ExerciseNo
	 END
	 ELSE
	 BEGIN
	        INSERT INTO PaymentSelectionDate(ExerciseNo,PaymentMode,Paymentdate,UpdateBy,UpdatedOn)
            VALUES(@ExerciseNo,@PaymentMode, CONVERT(date, GETDATE()),'ADMIN',GETDATE())	
	 
	 END


	 DECLARE    @CompanyID VARCHAR(20)
        SELECT @CompanyID = CompanyID FROM CompanyParameters
		IF(@PaymentMode ='A' OR @PaymentMode='P')
		BEGIN
	 		IF NOT EXISTS (SELECT * FROM AuditData where ExerciseNo= @ExerciseNo)
		BEGIN 
		   	INSERT INTO AuditData
		   	(
  				ExerciseId, ExerciseNo, FMV, PaymentDateTime, ExerciseAmount, TaxRate, PerqVal, PerqTax, MarketPrice, PaymentMode, LoginHistoryId, CashlessChgsAmt
		  	)
			SELECT 
				SH.ExerciseId, ExerciseNO, TentativeFMVPrice,
				GL.FinalVestingDate + CONVERT(VARCHAR(19),cast(GL.FinalVestingDate as datetime) + cast(GETDATE() as datetime),121),
				-- + CAST(GETDATE() AS TIME),
				ExercisePrice * SH.ExercisedQuantity, 
				Perq_Tax_rate,TentativePerqstValue ,
				TentativePerqstPayable, 
				(SELECT TOP 1 ClosePrice FROM SharePrices WHERE PriceDate = (SELECT MAX(PriceDate) FROM SharePrices)),
				PaymentMode, 0, 
				(SELECT TOP 1 dbo.FN_GET_CASHLESSCHARGES(@CompanyID, GL.FinalVestingDate, SH.MIT_ID, SH.ExercisedQuantity))
			FROM 
				ShExercisedOptions  AS SH
				INNER JOIN GrantLeg AS GL ON GL.ID = SH.GrantLegSerialNumber
				WHERE (LEN(ISNULL(PaymentMode, '')) <> 0)  AND SH.ExerciseNo=@ExerciseNo
		END

		ELSE
	
		BEGIN
			UPDATE AD 
				SET AD.Paymentmode= SHE.Paymentmode
			FROM 
				AuditData AS AD
			INNER JOIN 
				ShExercisedOptions AS SHE on AD.ExerciseNo = SHE.ExerciseNo
			
		END
		END
END
GO
