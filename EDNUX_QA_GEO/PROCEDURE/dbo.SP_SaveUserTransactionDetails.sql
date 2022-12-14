/****** Object:  StoredProcedure [dbo].[SP_SaveUserTransactionDetails]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_SaveUserTransactionDetails]
GO
/****** Object:  StoredProcedure [dbo].[SP_SaveUserTransactionDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_SaveUserTransactionDetails] 
	-- Add the parameters for the stored procedure here
	(
		    @LOGINID AS VARCHAR (40) = NULL,
			@DOJ AS DATETIME = NULL,
			@GRADE	AS VARCHAR (150) = NULL,
			@SecondaryEmailID AS	VARCHAR	(500) = NULL,
			@COUNTRYNAME AS VARCHAR	(50) = NULL,
			@PHONENO AS	VARCHAR	(40) = NULL,
			@EMAILID AS	VARCHAR	(100) = NULL,
			@ADDRESS AS	VARCHAR	(500) = NULL,
			@EMPLOYEENAME AS VARCHAR(20) = NULL,
			
			@PANNO	AS	VARCHAR	(40) = NULL,
			@DEPARTMENT AS	VARCHAR	(150) = NULL,
			@RESDENTSTATAUS	AS VARCHAR	(20) = NULL,
			@LOCATION AS VARCHAR (100) = NULL,
			@INSIDER AS	VARCHAR	(40) = NULL,
			@SBU AS	VARCHAR	(200)= NULL,
			@WARDNUMBER AS	VARCHAR	(40) = NULL,
			@ENTITY	AS	VARCHAR	 (200) = NULL,
			@COST_CENTER AS	VARCHAR	(200) = NULL,
			@TAX_IDENTIFIER_STATE AS NVARCHAR (200) = NULL,
			@TAX_IDENTIFIER_COUNTRY AS NVARCHAR	(200) = NULL,
			
			@Nationality VARCHAR(100) = NULL,
			@DPRecord VARCHAR(50) = NULL,
			@DepositoryName VARCHAR(200) = NULL,
			@DematACType VARCHAR(15) = NULL,
			@DepositoryParticipantName VARCHAR(200) = NULL,
			@DPIDNo VARCHAR(20) = NULL,
			@ClientNo VARCHAR(20) = NULL,
			@PaymentNameEX VARCHAR(100) = NULL,
			@DrawnOn DATETIME =NULL,
			@BankName VARCHAR(200) = NULL,
			@PaymentNamePQ VARCHAR(100) = NULL,
			@PerqAmt_DrownOndate DATETIME = NULL,
			@PerqAmt_BankName VARCHAR(200) = NULL,
			@MessageOut VARCHAR(10)=NULL OUTPUT,
			@Branch VARCHAR(200)=NULL,
			@AccountNo VARCHAR(50)=NULL,
			@IBANNo VARCHAR(100)=NULL,
			@PerqAmt_Branch VARCHAR(200)=NULL,
			@PerqAmt_BankAccountNumber VARCHAR(50) =NULL,
			@IBANNoPQ VARCHAR(100) =NULL,
			@ExerciseNo numeric(18,9) = null,
			@CountryCode VARCHAR(50) = NULL,
			@ExAmtTypOfBnkAC VARCHAR(100) = NULL,
            @PeqTxTypOfBnkAC VARCHAR(100) = NULL,
			@BrokerDepTrustCmpName VARCHAR(200) = NULL,
            @BrokerDepTrustCmpID VARCHAR(200) = NULL,
            @BrokerElectAccNum VARCHAR(200) = NULL,

			@SUCCESSFUL BIT=NULL OUTPUT,
			@DESIGNATION VARCHAR(200) = NULL,			
			@IFSCCode VARCHAR(200) = NULL,
			@BankAccountHolderName VARCHAR(200) = NULL,
			@BankBranchAddress VARCHAR(200) = NULL,
			@PaymentMode VARCHAR(100) = NULL,
			@FATHERSNAME VARCHAR(500) = NULL
	)
AS
BEGIN
    SET NOCOUNT ON;
		
	BEGIN TRY
		BEGIN TRANSACTION

		    UPDATE EmployeeMaster SET Nationality=@Nationality WHERE LoginID=@LOGINID
			/*
			BEGIN
				EXEC SP_UPDATEUSERNEWDETAILS @LOGINID,@DOJ,@GRADE,@SecondaryEmailID,@COUNTRYNAME,@PHONENO,@EMAILID,@ADDRESS,@EMPLOYEENAME, @DESIGNATION				
			END
			BEGIN 
				EXEC SP_UPDATEOTHERNEWDETAILS @LOGINID,@PANNO,@DEPARTMENT,@RESDENTSTATAUS,@LOCATION,@INSIDER,@SBU,@WARDNUMBER,@ENTITY,@COST_CENTER,@TAX_IDENTIFIER_STATE,@TAX_IDENTIFIER_COUNTRY,@EMPLOYEENAME
			END
			*/
			IF(@PaymentMode = 'W' OR @PaymentMode = 'R'  OR @PaymentMode = 'Q'  OR @PaymentMode = 'D'  OR @PaymentMode = 'I' OR @PaymentMode = 'N' OR @PaymentMode = 'X' ) 
			BEGIN	
			    EXEC SP_INSERTShTransactionDetails_Offline @PANNO, @Nationality,@RESDENTSTATAUS ,@LOCATION,@PHONENO,@DPRecord,@DepositoryName,@DematACType,@DepositoryParticipantName,@DPIDNo,@ClientNo,@PaymentNameEX,@DrawnOn,@BankName,@PaymentNamePQ,@PerqAmt_DrownOndate,@PerqAmt_BankName,@MessageOut,@LOGINID,@Branch,@AccountNo,@IBANNo,@PerqAmt_Branch,@PerqAmt_BankAccountNumber,@IBANNoPQ,@ExerciseNo,@CountryCode,@SecondaryEmailID,@ExAmtTypOfBnkAC,@PeqTxTypOfBnkAC,@COUNTRYNAME,@COST_CENTER,@BrokerDepTrustCmpName,@BrokerDepTrustCmpID,@BrokerElectAccNum 					
			END
			IF(@PaymentMode = 'A' OR @PaymentMode = 'P') 
			BEGIN
				EXEC PROC_INSERTShTransactionDetails_Cashless @PANNO, @Nationality, @RESDENTSTATAUS, @LOCATION,@PHONENO, @DPRecord,@DepositoryName,@DematACType,@DepositoryParticipantName,@DPIDNo,@ClientNo,@MessageOut,@LOGINID ,@BankAccountHolderName, @BankName,@Branch, @BankBranchAddress, @AccountNo,@ExAmtTypOfBnkAC , @IFSCCode, @IBANNo, @ExerciseNo,@CountryCode, NULL, NULL, NULL, NULL,  @SecondaryEmailID, @COUNTRYNAME,@BrokerDepTrustCmpName,@BrokerDepTrustCmpID,@BrokerElectAccNum 					
			END
			BEGIN
				EXEC PROC_UPDATE_EMP_DETAILS_WITH_EXERCISE @ExerciseNo,@LOGINID
			END

		  SET @SUCCESSFUL=1

		  IF (@SUCCESSFUL=1)
		  BEGIN		    
			  IF EXISTS(SELECT 1 from TRANSACTIONS_EXERCISE_STEP WHERE EXERCISE_NO = @ExerciseNo)
	          BEGIN	     
					UPDATE TES SET IS_ATTEMPTED = 1 , UPDATED_BY = SHEX.EmployeeID , UPDATED_ON = GETDATE()
					FROM TRANSACTIONS_EXERCISE_STEP TES INNER JOIN ShExercisedOptions SHEX 
					ON TES.EXERCISE_NO = SHEX.ExerciseNo 
					WHERE EXERCISE_NO = @ExerciseNo AND EXERCISE_STEPID = 2

					UPDATE ShExercisedOptions SET isFormGenerate=0 WHERE ExerciseNo=@ExerciseNo
	          END
		  END

		COMMIT TRANSACTION
     END TRY

	 BEGIN CATCH
		ROLLBACK TRANSACTION
    		SET @SUCCESSFUL=0
	 END CATCH

	SET NOCOUNT OFF;	
		
END
GO
