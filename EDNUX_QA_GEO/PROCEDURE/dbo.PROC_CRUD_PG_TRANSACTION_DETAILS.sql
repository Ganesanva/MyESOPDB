/****** Object:  StoredProcedure [dbo].[PROC_CRUD_PG_TRANSACTION_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CRUD_PG_TRANSACTION_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CRUD_PG_TRANSACTION_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[PROC_CRUD_PG_TRANSACTION_DETAILS]	
	@ExerciseNo int = NULL,
	@Action CHAR(1) ,
	@OUT_ERROR_MESSAGES VARCHAR(500) OUTPUT ,
	@TYPE_PROC_TRANSACTION_DETAILS  dbo.TYPE_PROC_TRANSACTION_DETAILS READONLY
AS	   
BEGIN
	SET NOCOUNT ON;
    
	DECLARE @Merchant_Code varchar(100),
			@GRANTOPTIONID VARCHAR(100), 
			@MAXSEQUENCENO VARCHAR(20);
	
	SET @Merchant_Code =(SELECT Merchant_Code FROM PaymentGatewayParameters) 
	
	IF(@Merchant_Code = null)
	BEGIN
	SELECT 
		@GRANTOPTIONID = GL.GrantOptionId 
	FROM 
		 GrantLeg  GL
	JOIN ShExercisedOptions SHO  ON GL.ID = SHO.GrantLegSerialNumber
	WHERE 
		(SHO.ExerciseNo = @ExerciseNo)	
	
	CREATE TABLE #TEMP_GET_MERCHANT_CODE
	(
		MERCHANT_CODE VARCHAR(200)
	)

	INSERT INTO #TEMP_GET_MERCHANT_CODE (MERCHANT_CODE)
	EXEC PROC_GetMerchantCodeForTransaction @ExerciseNo,null
	
	SET @Merchant_Code =(SELECT MERCHANT_CODE FROM #TEMP_GET_MERCHANT_CODE) 
	
	END
	
	IF @Action = 'R' 
    BEGIN
		 
            SELECT  
		  		SH.EmployeeID, EM.EMPLOYEENAME, SH.ExerciseNo, CONVERT(varchar, SH.ExerciseDate,101) as ExerciseDate, SUM(SH.ExercisedQuantity*SH.ExercisePrice) AS ExercisedAmount,
		  		SUM(SH.ExercisedQuantity) AS ExercisedQuantity, SUM(SH.PerqstPayable) AS PerqstPayable, TTD.BankReferenceNo, TTD.Item_Code,
		  		TTD.Amount, CONVERT(varchar,TTD.Transaction_Date,101) as Transaction_Date , TTD.TPSLTransID, TTD.UniqueTransactionNo, PBM.BankName, PBM.BankID, SH.PaymentMode,
				CASE  WHEN TTD.Payment_status ='S' THEN 'Paid' WHEN TTD.Payment_status ='F' THEN 'Pending' ELSE '' END AS Payment_status
		     FROM 
		  	    ShExercisedOptions SH 
		  	    INNER JOIN EMPLOYEEMASTER EM ON SH.EMPLOYEEID=EM.EMPLOYEEID 
		  	    INNER JOIN Transaction_Details TTD ON SH.ExerciseNo=TTD.Sh_ExerciseNo 
		  	    LEFT JOIN paymentbankmaster PBM ON PBM.BankID=TTD.bankid
			  
		  WHERE 
		  	SH.ExerciseNo=@ExerciseNo 
		  GROUP BY  
		  	SH.EmployeeID, EM.EMPLOYEENAME, SH.ExerciseNo, SH.ExerciseDate, TTD.BankReferenceNo, TTD.Payment_status, TTD.Item_Code, TTD.Amount,
		  	TTD.Transaction_Date, TTD.Transaction_Status, TTD.ActionType, TTD.TPSLTransID, TTD.UniqueTransactionNo, PBM.BankName, TTD.Payment_status, SH.PaymentMode, PBM.BankID
	END
	ELSE IF @Action = 'U'
	BEGIN 
		
		IF ((SELECT COUNT(Sh_ExerciseNo) FROM Transaction_Details WHERE Sh_ExerciseNo = @ExerciseNo) > 0)
			BEGIN  
	    
			BEGIN TRANSACTION	/* ===== INSERT INTO TRANSACTION_DETAILS_AUDIT TABLE ===== */	

			   BEGIN TRY

				       INSERT INTO  Audit_Transaction_Details
			               (
				            MerchantreferenceNo, OpreationStatus, BankReferenceNo, Merchant_Code, Sh_ExerciseNo, TransactionType, Amount, Item_Code, Payment_status, 
				            Transaction_Status, Transaction_Date, Tax_Amount, [Failure Reson], ErrorCode, transactionfees, FailureReson, ExerciseNo, BankAccountNo,
				            DPRecord, DepositoryName, DematAcType, DPName, DPId, ClientId, PanNumber, Nationality, ResidentialStatus, [Location], MobileNumber,		
				            CountryCode, [STATUS], ActionType, TPSLTransID, UniqueTransactionNo, LastUpdatedBy, LastUpdated, SecondaryEmailID, CountryName,
				            IS_MAIL_SENT, COST_CENTER, BROKER_DEP_TRUST_CMP_NAME, BROKER_DEP_TRUST_CMP_ID, BROKER_ELECT_ACC_NUM, bankid          
			               )
		                        
			           SELECT 
			            	MerchantreferenceNo, 'U', TD.BankReferenceNo, TD.Merchant_Code,Sh_ExerciseNo, TD.TransactionType, TD.Amount, TPTD.Item_Code, TD.Payment_status, 
			            	TD.Transaction_Status, TD.Transaction_Date, TD.Tax_Amount, TD.[Failure Reson], TD.ErrorCode, TD.transactionfees, TD.FailureReson, TD.ExerciseNo, TD.BankAccountNo, 
			            	TD.DPRecord, TD.DepositoryName, TD.DematAcType, TD.DPName, TD.DPId, TD.ClientId, TD.PanNumber, TD.Nationality, TD.ResidentialStatus, TD.[Location], TD.MobileNumber,
			            	TD.CountryCode, TD.[STATUS], TD.ActionType, TD.TPSLTransID, TD.UniqueTransactionNo, TPTD.LastUpdatedBy, TPTD.LastUpdated, TD.SecondaryEmailID, TD.CountryName,
			            	TD.IS_MAIL_SENT, TD.COST_CENTER, TD.BROKER_DEP_TRUST_CMP_NAME, TD.BROKER_DEP_TRUST_CMP_ID, TD.BROKER_ELECT_ACC_NUM, TD.bankid  
			            FROM
			            	@TYPE_PROC_TRANSACTION_DETAILS AS TPTD	
			            	INNER JOIN Transaction_Details AS TD ON TD.Sh_ExerciseNo = TPTD.ExerciseNo
					    
					    	
					    UPDATE 
							Transaction_Details 
						SET
				    		BankReferenceNo       = TPTD.BankReferenceNo,  
							Payment_status        ='S',           
	                        Transaction_Status    ='Y',                  
				    		UniqueTransactionNo   = TPTD.UniqueTransactionNo,        
				    		Transaction_Date      =cast( TPTD.Transaction_Date as datetime),
				    		Item_Code             = TPTD.Item_Code,
				    		TPSLTransID           = TPTD.TPSLTransID,
				    		bankid                = TPTD.bankid,           
				    		LastUpdatedBy         = TPTD.LastUpdatedBy,             
				    		LastUpdated	          = TPTD.LastUpdated           
					    FROM 									
					    	@TYPE_PROC_TRANSACTION_DETAILS TPTD	
					    	INNER JOIN Transaction_Details AS Transaction_Details 
							ON Transaction_Details.Sh_ExerciseNo = TPTD.ExerciseNo 	
							
								       --UPDATE QUERY WRITE HERE FIRST
					UPDATE 
						ShExercisedOptions 
					SET  
						PaymentMode = 'N' 
					WHERE 
						ExerciseNo = @ExerciseNo

					    COMMIT TRANSACTION  
						SET @OUT_ERROR_MESSAGES='Payment transaction status updated successfully for Exercise No.'+ CONVERT(varchar(100), @ExerciseNo);
					    END TRY
					    BEGIN CATCH			
		     		    	ROLLBACK TRANSACTION
					    SET @OUT_ERROR_MESSAGES=ERROR_MESSAGE();	
					    END CATCH 	 	  	 
		END
			ELSE
		BEGIN
			BEGIN TRANSACTION	/* ===== INSERT INTO TRANSACTION_DETAILS_AUDIT TABLE ===== */			
				BEGIN TRY
					    INSERT INTO TRANSACTION_DETAILS 
					      (
			   		        MERCHANTREFERENCENO, BankReferenceNo, Merchant_Code, SH_EXERCISENO, AMOUNT, ITEM_CODE, [Payment_status], [Transaction_Status], FailureReson, TRANSACTION_DATE, 
							LASTUPDATEDBY, LASTUPDATED, TAX_AMOUNT, [STATUS], [ActionType], [UniqueTransactionNo], DPRECORD, DEPOSITORYNAME, DEMATACTYPE, DPID, CLIENTID, PANNUMBER, RESIDENTIALSTATUS, LOCATION, DPNAME, COUNTRYNAME, TPSLTransID, bankid
					      )    
					SELECT 
						TOP 1 (select MAX(merchantreferenceno)+1 from Transaction_Details) AS [MERCHANTREFERENCENO], TPTD.BankReferenceNo,@Merchant_Code AS [Merchant_Code],SHE.ExerciseNo AS [SH_ExerciseNo],  
						SUM(SHE.ExercisedQuantity*SHE.ExercisePrice) AS [Amount],TPTD.Item_Code,'S' AS [Payment_Status], 'Y' AS [Transaction_Status],'Transaction is Successful' AS[FailureReson],
						TPTD.TRANSACTION_DATE,TPTD.LastUpdatedBy AS [LastUpdatedBy],TPTD.LastUpdated,SUM(SHE.PerqstPayable) AS [TaxAmount], 'S' AS [STATUS], 'P' AS [ActionType],TPTD.UniqueTransactionNo,EM.DPRecord,
						EM.DepositoryName,EM.DematAccountType,EM.DepositoryIDNumber, EM.ClientIDNumber,EM.PANNumber,EM.ResidentialStatus,EM.Location,EM.DepositoryParticipantNo,EM.CountryName,TPTD.TPSLTransID,TPTD.bankid
						
					FROM	 
						SHEXERCISEDOPTIONS SHE 
		       				INNER JOIN  EmployeeMaster EM   ON  EM.EmployeeID = SHE.EmployeeID 
 	             			INNER JOIN  @TYPE_PROC_TRANSACTION_DETAILS TPTD ON  SHE.ExerciseNo=TPTD.ExerciseNo  
					WHERE 
						SHE.EXERCISENO = @ExerciseNo
					GROUP BY 
						TPTD.BankReferenceNo, SHE.ExerciseNo, TPTD.TRANSACTION_DATE, SHE.EmployeeID, TPTD.LastUpdatedBy,TPTD.LastUpdated, TPTD.UniqueTransactionNo, EM.DPRecord, EM.DepositoryName, EM.DematAccountType, EM.DepositoryIDNumber,
						EM.ClientIDNumber, EM.PANNumber, EM.ResidentialStatus, EM.Location, EM.DepositoryParticipantNo, EM.CountryName, TPTD.TPSLTransID, TPTD.bankid, TPTD.Item_Code
                       
					       --UPDATE QUERY WRITE HERE FIRST
					UPDATE 
						ShExercisedOptions 
					SET  
						PaymentMode = 'N' 
					WHERE 
						ExerciseNo = @ExerciseNo
			      
				    INSERT INTO Audit_Transaction_Details
			        (
			           MerchantreferenceNo, OpreationStatus, BankReferenceNo, Merchant_Code, Sh_ExerciseNo, TransactionType, Amount, Item_Code, Payment_status, 
			           Transaction_Status, Transaction_Date, Tax_Amount, [Failure Reson], ErrorCode, transactionfees, FailureReson, ExerciseNo, BankAccountNo,
			           DPRecord, DepositoryName, DematAcType, DPName, DPId, ClientId, PanNumber, Nationality, ResidentialStatus, [Location], MobileNumber,		
			           CountryCode, [STATUS], ActionType, TPSLTransID, UniqueTransactionNo, LastUpdatedBy, LastUpdated, SecondaryEmailID, CountryName,
			           IS_MAIL_SENT, COST_CENTER, BROKER_DEP_TRUST_CMP_NAME, BROKER_DEP_TRUST_CMP_ID, BROKER_ELECT_ACC_NUM, bankid          
		             )
		           	SELECT 
		        	   MerchantreferenceNo, 'I', TD.BankReferenceNo, TD.Merchant_Code,Sh_ExerciseNo, TD.TransactionType, TD.Amount, TPTD.Item_Code, TD.Payment_status, 
		        	   TD.Transaction_Status, TD.Transaction_Date, TD.Tax_Amount, TD.[Failure Reson], TD.ErrorCode, TD.transactionfees, TD.FailureReson, TD.ExerciseNo, TD.BankAccountNo, 
		        	   TD.DPRecord, TD.DepositoryName, TD.DematAcType, TD.DPName, TD.DPId, TD.ClientId, TD.PanNumber, TD.Nationality, TD.ResidentialStatus, TD.[Location], TD.MobileNumber,
		        	   TD.CountryCode, TD.[STATUS], TD.ActionType, TD.TPSLTransID, TD.UniqueTransactionNo, TPTD.LastUpdatedBy, TPTD.LastUpdated, TD.SecondaryEmailID, TD.CountryName,
		        	   TD.IS_MAIL_SENT, TD.COST_CENTER, TD.BROKER_DEP_TRUST_CMP_NAME, TD.BROKER_DEP_TRUST_CMP_ID, TD.BROKER_ELECT_ACC_NUM, TD.bankid  
					FROM
		        	   @TYPE_PROC_TRANSACTION_DETAILS AS TPTD	
		        	   INNER JOIN Transaction_Details AS TD ON TD.Sh_ExerciseNo = TPTD.ExerciseNo

					   SET @MAXSEQUENCENO  = (SELECT MAX(merchantreferenceno) FROM Transaction_Details)
					   
					   UPDATE SequenceTable set SequenceNo= @MAXSEQUENCENO WHERE Seq1 ='MerchantReferenceNo'

					COMMIT TRANSACTION 
						SET @OUT_ERROR_MESSAGES='Payment transaction status updated successfully for Exercise No.'+ CONVERT(varchar(100), @ExerciseNo);
				END TRY
		
				BEGIN CATCH			
				ROLLBACK TRANSACTION	
					SET @OUT_ERROR_MESSAGES=ERROR_MESSAGE();		
				END CATCH  	 
		END
	     		  
    END	
	ELSE IF (@Action = 'D')
	BEGIN
		BEGIN TRANSACTION				
		    
			 BEGIN TRY
			        INSERT INTO Audit_Transaction_Details
			          (
				         MerchantreferenceNo, OpreationStatus, BankReferenceNo, Merchant_Code, Sh_ExerciseNo, TransactionType, Amount, Item_Code, Payment_status, 
				         Transaction_Status, Transaction_Date, Tax_Amount, [Failure Reson], ErrorCode, transactionfees, FailureReson, ExerciseNo, BankAccountNo,
				         DPRecord, DepositoryName, DematAcType, DPName, DPId, ClientId, PanNumber, Nationality, ResidentialStatus, [Location], MobileNumber,		
				         CountryCode, [STATUS], ActionType, TPSLTransID, UniqueTransactionNo, LastUpdatedBy, LastUpdated, SecondaryEmailID, CountryName,
				         IS_MAIL_SENT, COST_CENTER, BROKER_DEP_TRUST_CMP_NAME, BROKER_DEP_TRUST_CMP_ID, BROKER_ELECT_ACC_NUM, bankid          
			          )
			        SELECT 
				         MerchantreferenceNo, 'D', TD.BankReferenceNo, TD.Merchant_Code,Sh_ExerciseNo, TD.TransactionType, TD.Amount, TPTD.Item_Code, TD.Payment_status, 
				         TD.Transaction_Status, TD.Transaction_Date, TD.Tax_Amount, TD.[Failure Reson], TD.ErrorCode, TD.transactionfees, TD.FailureReson, TD.ExerciseNo, TD.BankAccountNo, 
				         TD.DPRecord, TD.DepositoryName, TD.DematAcType, TD.DPName, TD.DPId, TD.ClientId, TD.PanNumber, TD.Nationality, TD.ResidentialStatus, TD.[Location], TD.MobileNumber,
				         TD.CountryCode, TD.[STATUS], TD.ActionType, TD.TPSLTransID, TD.UniqueTransactionNo, TPTD.LastUpdatedBy, TPTD.LastUpdated, TD.SecondaryEmailID, TD.CountryName,
				         TD.IS_MAIL_SENT, TD.COST_CENTER, TD.BROKER_DEP_TRUST_CMP_NAME, TD.BROKER_DEP_TRUST_CMP_ID, TD.BROKER_ELECT_ACC_NUM, TD.bankid  
			        FROM
				    @TYPE_PROC_TRANSACTION_DETAILS AS TPTD	
				    INNER JOIN Transaction_Details AS TD ON TD.Sh_ExerciseNo = TPTD.ExerciseNo
		                        
			-- UPDATE QUERY WRITE HERE FIRST
			         UPDATE 
				         ShExercisedOptions 
			         SET 
				         PaymentMode = NULL ,isFormGenerate=0,IsAccepted=0,IS_UPLOAD_EXERCISE_FORM=0,
						 IsAcceptedOn=null,IS_UPLOAD_EXERCISE_FORM_ON=null
			         WHERE 
				        ExerciseNo = @ExerciseNo
		
			 /* USE jOIN FOR UPDATE DETAILS */
			 	
			--DELETE 
			        DELETE FROM Transaction_Details WHERE Sh_ExerciseNo = @ExerciseNo
					update TRANSACTIONS_EXERCISE_STEP set IS_ATTEMPTED=0  WHERE EXERCISE_NO = @ExerciseNo
					DELETE FROM PaymentSelectionDate where ExerciseNo = @ExerciseNo
			/* USE jOIN FOR UPDATE DETAILS */

			COMMIT TRANSACTION
			       SET @OUT_ERROR_MESSAGES='Payment transaction reversed successfully for Exercise No.'+ CONVERT(varchar(100), @ExerciseNo);
		   END TRY
		   BEGIN CATCH	
		     	
			ROLLBACK TRANSACTION
					SET @OUT_ERROR_MESSAGES=ERROR_MESSAGE();
		   END CATCH 
		 		  		
   END										
   SET NOCOUNT OFF;						
End
GO
