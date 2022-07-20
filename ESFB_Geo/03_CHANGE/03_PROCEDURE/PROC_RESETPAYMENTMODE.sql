DROP PROCEDURE IF EXISTS [dbo].[PROC_RESETPAYMENTMODE]
GO
/****** Object:  StoredProcedure [dbo].[PROC_RESETPAYMENTMODE]    Script Date: 18-07-2022 15:22:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PROC_RESETPAYMENTMODE]
(
	@ExerciseId NVARCHAR(500),
	@PaymentModeId NVARCHAR(500),
	@UpdatedBy NVARCHAR(500)
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
	
		INSERT 
			#TEMPPAYMENTIDS(id,PaymentModeName)
		SELECT 
			id,PaymentMode FROM PaymentMaster  WHERE Id IN (SELECT [ITEM] FROM FN_SPLIT_STRING(@PaymentModeId, ',') WHERE [ITEM] IS NOT NULL AND [ITEM] <>'')
	
	
	/*****************************************************************************************************************************/
	
	/*****************************to get seprate vaule from string by ',' comma*********************************************/
	INSERT 
			#TEMPEXERCISEIDS(ExerciseNumber)
			SELECT * FROM FN_SPLIT_STRING(@ExerciseId, ',') WHERE [ITEM] IS NOT NULL and [ITEM] <>''
	
	/*****************************************************************************************************************************/	
	/*****************************to update ShExercisedOptions payment mode as per ExerciseId*************************************/
	DECLARE @PREPAYMENTMODE NVARCHAR(100)
	SELECT 
	    @PREPAYMENTMODE= PM.PayModeName 
		  FROM 
		   ShExercisedOptions SH 
	INNER JOIN 
		#TEMPEXERCISEIDS TE ON SH.ExerciseNo=TE.ExerciseNumber 
	INNER JOIN 
		PaymentMaster AS PM ON PM.PaymentMode=SH.PaymentMode

	UPDATE TE
	SET PREVIOUS_PAYMENTMODE=SH.PaymentMode,ExerciseId=SH.ExerciseId,TE.MIT_ID=SH.MIT_ID
	FROM ShExercisedOptions SH INNER JOIN #TEMPEXERCISEIDS TE ON SH.ExerciseNo=TE.ExerciseNumber 

	INSERT INTO AUDIT_EXERCISETRANSACTION_DETAILS(ExerciseNo,PayModeName,UPDATED_BY,UPDATED_ON) VALUES(REPLACE(@ExerciseId,',',''),@PREPAYMENTMODE,@UpdatedBy,GETDATE())
	
	UPDATE Sh 
		SET  Sh.isFormGenerate=0,Sh.IS_UPLOAD_EXERCISE_FORM=0,Sh.IS_UPLOAD_EXERCISE_FORM_ON=null, Sh.PaymentMode = ISNULL(TPM.PaymentModeName,Null),Sh.IsAccepted=0,Sh.IsAcceptedOn=NULL,Sh.ExerciseFormReceived='N',
		sh.CALCULATE_TAX = (CASE WHEN ((TPM.PaymentModeName = 'P' OR TPM.PaymentModeName = 'A') AND sh.CALCULATE_TAX = 'rdoActualTax') THEN 'rdoTentativeTax' 
		WHEN (TPM.PaymentModeName = 'N' AND CONVERT(DATE, sh.ExerciseDate) > CONVERT(DATE, GETDATE()) AND sh.CALCULATE_TAX = 'rdoTentativeTax') THEN 'rdoActualTax'
		ELSE sh.CALCULATE_TAX END)
	FROM 
		ShExercisedOptions AS Sh
	INNER JOIN 
		#TEMPEXERCISEIDS AS TEX on TEX.ExerciseNumber = Sh.ExerciseNo
	LEFT JOIN 
		#TEMPPAYMENTIDS AS TPM on TPM.RowId = TEX.RowId
	/*****************************************************************************************************************************/

	/*Update steps*/
	UPDATE TEX
	SET TEX.FORM_TYPE= (SELECT dbo.FN_GET_FORM_TYPE(TPM.id, TEX.MIT_ID,TEX.ExerciseNumber))
	FROM #TEMPEXERCISEIDS AS TEX 
	INNER JOIN 
		#TEMPPAYMENTIDS AS TPM on TPM.RowId = TEX.RowId
	
		Print 'test1'
	 IF EXISTS(SELECT 1 FROM TRANSACTIONS_EXERCISE_STEP TES INNER JOIN #TEMPEXERCISEIDS AS TEX on TES.EXERCISE_NO= TEX.ExerciseNumber)
	 BEGIN	     
	 Print 'Update step'
		 UPDATE TES SET IS_ATTEMPTED =CASE WHEN(EXERCISE_STEPID=1 )THEN 0
		 --WHEN(Form_TYPE<>'MSSB' AND EXERCISE_STEPID=2  AND IS_ATTEMPTED=1 ) THEN 0 
		 WHEN( EXERCISE_STEPID=2  )THEN 0  
		 WHEN(EXERCISE_STEPID=3)THEN 0
		 WHEN(EXERCISE_STEPID=4) THEN 0
		 WHEN(EXERCISE_STEPID=5) THEN 0
		 ELSE 0 END , 

		ISATTEMPTED_ON= CASE WHEN(EXERCISE_STEPID=1 )THEN GETDATE() 
		 --WHEN(Form_TYPE<>'MSSB' AND EXERCISE_STEPID=2  AND IS_ATTEMPTED=1 ) THEN 0 
		 WHEN(EXERCISE_STEPID=2  )THEN GETDATE()  
		 WHEN(EXERCISE_STEPID=3 )THEN GETDATE() 
		 WHEN(EXERCISE_STEPID=4 )THEN GETDATE()
		 WHEN(EXERCISE_STEPID=5 )THEN GETDATE() 
		 ELSE GETDATE() END,
		 UPLOAD_TYPE=NULL, 
		UPDATED_BY = SHEX.EmployeeID , 
		UPDATED_ON = GETDATE()
		 FROM TRANSACTIONS_EXERCISE_STEP TES 
		 INNER JOIN ShExercisedOptions SHEX ON TES.EXERCISE_NO = SHEX.ExerciseNo
		 INNER JOIN #TEMPEXERCISEIDS AS TEX on TEX.ExerciseNumber = SHEX.ExerciseNo	 AND EXERCISE_STEPID in(1,2,3,4,5) 
		 WHERE (ISNULL(SHEX.PaymentMode,'') = '' OR SHEX.MIT_ID = 5 OR SHEX.MIT_ID = 7)
	 END	
	/*****************************************************************************************************************************/
	Print 'test2'
	/*****************************************************************************************************************************/
	/*Previous payment mode data deletion for Offline payment mode */
	Delete 	FROM ShTransactionDetails
	WHERE ExerciseNo in (SELECT ExerciseNumber FROM #TEMPEXERCISEIDS WHERE ExerciseNumber IN ( 	SELECT * FROM FN_SPLIT_STRING(@ExerciseId, ',') WHERE [ITEM] IS NOT NULL AND [ITEM] <>'') ) 

	/* Previous payment mode data deletion  for Sell All & Sell partial*/
	Delete 	FROM TransactionDetails_CashLess
	WHERE ExerciseNo in (SELECT ExerciseNumber FROM #TEMPEXERCISEIDS WHERE ExerciseNumber IN ( 	SELECT * FROM FN_SPLIT_STRING(@ExerciseId, ',') WHERE [ITEM] IS NOT NULL AND [ITEM] <>'') ) 

	/* Previous payment mode data deletion  for Online*/
	Delete 	FROM Transaction_Details
	WHERE Sh_ExerciseNo in (SELECT ExerciseNumber FROM #TEMPEXERCISEIDS WHERE ExerciseNumber IN ( 	SELECT * FROM FN_SPLIT_STRING(@ExerciseId, ',') WHERE [ITEM] IS NOT NULL AND [ITEM] <>'') )
	
	/* Previous payment mode data deletion  for Funding*/
	Delete 	FROM TransactionDetails_Funding
	WHERE ExerciseNo in (SELECT ExerciseNumber FROM #TEMPEXERCISEIDS WHERE ExerciseNumber IN ( 	SELECT * FROM FN_SPLIT_STRING(@ExerciseId, ',')WHERE [ITEM] IS NOT NULL AND [ITEM] <>'') )

	/* Previous payment Selection date deletion*/
	Delete 	FROM PaymentSelectionDate
	WHERE ExerciseNo in (SELECT ExerciseNumber FROM #TEMPEXERCISEIDS WHERE ExerciseNumber IN ( 	SELECT * FROM FN_SPLIT_STRING(@ExerciseId, ',')WHERE [ITEM] IS NOT NULL AND [ITEM] <>'') )

	Select * from #TEMPEXERCISEIDS
	/*Upload Receipt data deletion for Offline payment mode */
	DELETE FROM MST_DOCUMENT_UPLOAD_MASTER_DETAILS
	where Exercise_NO in(SELECT ExerciseNumber FROM #TEMPEXERCISEIDS)

	
	/*****************************To save Data in Audit Data as per ExerciseId*************************************/
	    DECLARE	@CompanyID VARCHAR(20)
		SELECT @CompanyID = CompanyID FROM CompanyParameters

		IF NOT EXISTS (SELECT * FROM AuditData AD INNER JOIN #TEMPEXERCISEIDS AS TEX on AD.ExerciseNo= TEX.ExerciseNumber)
		BEGIN 
			
				Print 'Do nothing'
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
			LEFT JOIN 
				#TEMPPAYMENTIDS AS TPM on TPM.RowId = TEX.RowId
		END

	/*****************************drop temp table*************************************/
	DROP TABLE #TEMPEXERCISEIDS
	DROP TABLE #TEMPPAYMENTIDS
	/********************************************************************************/
	SET NOCOUNT OFF;
END	
GO


