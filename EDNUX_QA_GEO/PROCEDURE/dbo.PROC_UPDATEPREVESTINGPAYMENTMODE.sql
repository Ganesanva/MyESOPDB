/****** Object:  StoredProcedure [dbo].[PROC_UPDATEPREVESTINGPAYMENTMODE]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UPDATEPREVESTINGPAYMENTMODE]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UPDATEPREVESTINGPAYMENTMODE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_UPDATEPREVESTINGPAYMENTMODE]
(
	@ExerciseId nvarchar(500),
	@PaymentModeId nvarchar(500)
)
AS
BEGIN
	
	SET NOCOUNT ON;
	--WE ARE ADDING EXTRA COMMA (,) HERE FOR USE IN WHILE TO GET ALL PARAMTERE IN TABLE FOR SAVE
	SET @ExerciseId = @ExerciseId  +','
	SET @PaymentModeId = @PaymentModeId +','
	/* create temp table to save Exercise id's from string to seprate row by ',' */
	CREATE TABLE #TEMPPAYMENTIDS(RowId int identity(1,1),id int,PaymentModeName char)

	/* create temp table to save Payment Mode id's from array to seprate row */
	CREATE TABLE #TEMPEXERCISEIDS(RowId int identity(1,1),ExerciseId int,ExerciseNumber NVARCHAR(50),PREVIOUS_PAYMENTMODE NVARCHAR(5),MIT_ID BIGINT,FORM_TYPE NVARCHAR(50))

	/*****************************to get seprate vaule from string by ',' comma*********************************************/
	DECLARE @pos INT
	DECLARE @len INT
	DECLARE @PaymentMode_Value int
	SET @pos = 0
	SET @len = 0
	WHILE CHARINDEX(',', @PaymentModeId, @pos+1)>0
	BEGIN
		SET @len = CHARINDEX(',', @PaymentModeId, @pos+1) - @pos
		SET @PaymentMode_Value = SUBSTRING(@PaymentModeId, @pos, @len)
    
		INSERT 
			#TEMPPAYMENTIDS(id,PaymentModeName)
		SELECT 
			id,PaymentMode FROM PaymentMaster  WHERE Id = CONVERT(int,@PaymentMode_Value)
	
		SET @pos = CHARINDEX(',', @PaymentModeId, @pos+@len) +1	
	END
	/*****************************************************************************************************************************/
	
	/*****************************to get seprate vaule from string by ',' comma*********************************************/
	DECLARE @pos1 INT
	DECLARE @len1 INT
	DECLARE @ExerciseId_value int 
	SET @pos1 = 0
	SET @len1 = 0

	WHILE CHARINDEX(',', @ExerciseId, @pos1+1)>0
	BEGIN
		SET @len1 = CHARINDEX(',', @ExerciseId, @pos1+1) - @pos1
		SET @ExerciseId_value = SUBSTRING(@ExerciseId, @pos1, @len1)
            
		INSERT 
			#TEMPEXERCISEIDS(ExerciseNumber)
		SELECT 
			CONVERT(int,@ExerciseId_value)    

	    SET @pos1 = CHARINDEX(',', @ExerciseId, @pos1+@len1) +1	
	END  
	/*****************************************************************************************************************************/	
	/*****************************to update ShExercisedOptions payment mode as per ExerciseId*************************************/
	UPDATE TE
	SET PREVIOUS_PAYMENTMODE=SH.PaymentMode,ExerciseId=SH.ExerciseId,TE.MIT_ID=SH.MIT_ID
	FROM ShExercisedOptions SH INNER JOIN #TEMPEXERCISEIDS TE ON SH.ExerciseNo=TE.ExerciseNumber 
	
	UPDATE Sh 
		SET isFormGenerate=0,IS_UPLOAD_EXERCISE_FORM=0,IS_UPLOAD_EXERCISE_FORM_ON=null, Sh.PaymentMode = TPM.PaymentModeName,
		sh.CALCULATE_TAX = (CASE WHEN ((TPM.PaymentModeName = 'P' OR TPM.PaymentModeName = 'A') AND sh.CALCULATE_TAX = 'rdoActualTax') THEN 'rdoTentativeTax' 
		WHEN (TPM.PaymentModeName = 'N' AND CONVERT(DATE, sh.ExerciseDate) > CONVERT(DATE, GETDATE()) AND sh.CALCULATE_TAX = 'rdoTentativeTax') THEN 'rdoActualTax'
		ELSE sh.CALCULATE_TAX END)
	FROM 
		ShExercisedOptions AS Sh
	INNER JOIN 
		#TEMPEXERCISEIDS AS TEX on TEX.ExerciseNumber = Sh.ExerciseNo
	INNER JOIN 
		#TEMPPAYMENTIDS AS TPM on TPM.RowId = TEX.RowId
	/*****************************************************************************************************************************/
	/*Update steps*/
	UPDATE TEX
	SET TEX.FORM_TYPE= (SELECT dbo.FN_GET_FORM_TYPE(TPM.id, TEX.MIT_ID,TEX.ExerciseNumber))
	FROM #TEMPEXERCISEIDS AS TEX 
	INNER JOIN 
		#TEMPPAYMENTIDS AS TPM on TPM.RowId = TEX.RowId

	 IF EXISTS(SELECT 1 FROM TRANSACTIONS_EXERCISE_STEP TES INNER JOIN #TEMPEXERCISEIDS AS TEX on TES.EXERCISE_NO= TEX.ExerciseNumber)
	 BEGIN	     
		 UPDATE TES SET IS_ATTEMPTED =CASE WHEN(EXERCISE_STEPID=1 )THEN 1 
		 --WHEN(Form_TYPE<>'MSSB' AND EXERCISE_STEPID=2  AND IS_ATTEMPTED=1 ) THEN 0 
		 WHEN(Form_TYPE='MSSB' AND EXERCISE_STEPID=2 AND (SHEX.PaymentMode='A' OR SHEX.PaymentMode='P')  )THEN 1  ELSE 0 END , 
		ISATTEMPTED_ON= CASE WHEN(EXERCISE_STEPID=1 )THEN GETDATE() 
		 --WHEN(Form_TYPE<>'MSSB' AND EXERCISE_STEPID=2  AND IS_ATTEMPTED=1 ) THEN 0 
		 WHEN(Form_TYPE='MSSB' AND EXERCISE_STEPID=2 AND (SHEX.PaymentMode='A' OR SHEX.PaymentMode='P')  )THEN GETDATE()  ELSE 0 END
		, UPDATED_BY = SHEX.EmployeeID , UPDATED_ON = GETDATE()
		 FROM TRANSACTIONS_EXERCISE_STEP TES 
		 INNER JOIN ShExercisedOptions SHEX ON TES.EXERCISE_NO = SHEX.ExerciseNo
		 INNER JOIN #TEMPEXERCISEIDS AS TEX on TEX.ExerciseNumber = SHEX.ExerciseNo	 AND EXERCISE_STEPID in(1,2) 
		 WHERE (ISNULL(SHEX.PaymentMode,'') <> '' OR SHEX.MIT_ID = 5 OR SHEX.MIT_ID = 7)
	 END	
	/*****************************************************************************************************************************/
	/*****************************************************************************************************************************/
	/*Previous payment mode data deletion for Offline payment mode */
	Delete 	FROM ShTransactionDetails
	WHERE ExerciseNo in (SELECT ExerciseNumber FROM #TEMPEXERCISEIDS WHERE PREVIOUS_PAYMENTMODE IN ('W') ) 

	/*Upload Receipt data deletion for Offline payment mode */
	DELETE FROM MST_DOCUMENT_UPLOAD_MASTER_DETAILS
	where Exercise_NO in(SELECT ExerciseNumber FROM #TEMPEXERCISEIDS)

	
	/*****************************To save Data in Audit Data as per ExerciseId*************************************/
	    DECLARE	@CompanyID VARCHAR(20)
		SELECT @CompanyID = CompanyID FROM CompanyParameters

		IF NOT EXISTS (SELECT * FROM AuditData AD INNER JOIN #TEMPEXERCISEIDS AS TEX on AD.ExerciseNo= TEX.ExerciseNumber)
		BEGIN 
		   	INSERT INTO AuditData
		   	(
  				ExerciseId, ExerciseNo, FMV, PaymentDateTime, ExerciseAmount, TaxRate, PerqVal, PerqTax, MarketPrice, PaymentMode, LoginHistoryId, CashlessChgsAmt
		  	)
			SELECT 
				SH.ExerciseId, ExerciseNO, TentativeFMVPrice,
				GL.FinalVestingDate + CAST(GETDATE() AS TIME),
				ExercisePrice * SH.ExercisedQuantity, 
				Perq_Tax_rate,TentativePerqstValue ,
				TentativePerqstPayable, 
				(SELECT TOP 1 ClosePrice FROM SharePrices WHERE PriceDate = (SELECT MAX(PriceDate) FROM SharePrices)),
				PaymentMode, 0, 
				(SELECT TOP 1 dbo.FN_GET_CASHLESSCHARGES(@CompanyID, GL.FinalVestingDate, SH.MIT_ID, SH.ExercisedQuantity))
			FROM 
				ShExercisedOptions  AS SH
				INNER JOIN 
				#TEMPEXERCISEIDS AS TEX on TEX.ExerciseNumber = SH.ExerciseNo
				INNER JOIN 
			    #TEMPPAYMENTIDS AS TPM on TPM.RowId = TEX.RowId
				INNER JOIN GrantLeg AS GL ON GL.ID = SH.GrantLegSerialNumber
				WHERE (LEN(ISNULL(PaymentMode, '')) <> 0)  AND SH.ExerciseNo=TEX.ExerciseNumber
		END

		ELSE
	
		BEGIN
			UPDATE AD 
				SET AD.Paymentmode= SHE.Paymentmode
			FROM 
				AuditData AS AD
			INNER JOIN 
				ShExercisedOptions AS SHE on AD.ExerciseNo = SHE.ExerciseNo
			INNER JOIN 
				#TEMPEXERCISEIDS AS TEX on TEX.ExerciseNumber = She.ExerciseNo
			INNER JOIN 
				#TEMPPAYMENTIDS AS TPM on TPM.RowId = TEX.RowId
		END

	/*****************************drop temp table*************************************/
	DROP TABLE #TEMPEXERCISEIDS
	DROP TABLE #TEMPPAYMENTIDS
	/********************************************************************************/
	SET NOCOUNT OFF;
END	
GO
