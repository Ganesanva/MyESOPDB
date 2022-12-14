/****** Object:  StoredProcedure [dbo].[PROC_GET_EMP_DETAILS_WITH_EXERCISE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_EMP_DETAILS_WITH_EXERCISE]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_EMP_DETAILS_WITH_EXERCISE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GET_EMP_DETAILS_WITH_EXERCISE] 
		@ExerciseNo VARCHAR(50),	
		@LoginId 	VARCHAR(20)	
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @bl_Exercise VARCHAR(50),
			@PaymentMode VARCHAR(10),
			@Exerciseform_Submit VARCHAR(10)
	
	    --PRINT('A')
	SELECT  @PaymentMode =  PaymentMode FROM ShExercisedOptions WHERE Exerciseno =@ExerciseNo
		--Print('PaymentMode  '+ @PaymentMode)
	SELECT  @Exerciseform_Submit = Exerciseform_Submit FROM PaymentMaster WHERE PaymentMode =@PaymentMode
		--Print('Exerciseform_Submit  '+ @Exerciseform_Submit)
	IF(@Exerciseform_Submit = 'Y')
		BEGIN
			--Print('B1')
			SELECT [EmployeeID],[LoginID],[EmployeeName],[EmployeeDesignation],[EmployeeAddress],[EmployeePhone],[DateOfJoining],[DateOfTermination],
				   [Insider],[ResidentialStatus],[PANNumber],[WardNumber],[DematAccountType],[DepositoryIDNumber],[DepositoryParticipantNo],[ClientIDNumber],
				   [EmployeeEmail],[Grade],[Department],[DepositoryName],[BackOutTermination],[IsMailSent],[SBU],[Entity],[AccountNo],[NewEmployeeId],[Location],
				   [ConfStatus],[LastUpdatedBy],[LastUpdatedOn],[ApprovalStatus],[Deleted],[ReasonForTermination],[Remarks],[IsAssociated],[LWD],[Confirmn_Dt],
				   [payrollcountry],[tax_slab],[Mobile],[DPRecord],[PerqAmt_ChequeNo],[PerqAmt_DrownOndate],[PerqAmt_WireTransfer],[PerqAmt_BankName],[PerqAmt_Branch],
				   [PerqAmt_BankAccountNumber],[Branch],[AssociatedDate],[SecondaryEmailID],CountryMaster.[CountryName],[COST_CENTER],[BROKER_DEP_TRUST_CMP_NAME],[BROKER_DEP_TRUST_CMP_ID],[BROKER_ELECT_ACC_NUM] 
			FROM EmployeeMaster LEFT OUTER JOIN CountryMaster ON EmployeeMaster.CountryName=CountryMaster.CountryAliasName
			WHERE LoginID = @LoginId AND DELETED=0 
		END
	ELSE
		BEGIN
				--Print('B2')
			SELECT @bl_Exercise=CASE WHEN  EXISTS (SELECT * FROM EMPDET_With_EXERCISE WHERE ExerciseNo = @ExerciseNo)THEN  1 ELSE 0 END
			IF @bl_Exercise=1
				BEGIN
				--PRINT('B3')
					SELECT	Idt,ExerciseNo,DateOfJoining,Grade,EmployeeDesignation,EmployeePhone,EmployeeEmail,EmployeeAddress,
							PANNumber, ResidentialStatus,Insider,WardNumber,Department,Location,SBU,Entity,DPRecord,
							DepositoryName,DematAccountType,DepositoryParticipantNo,DepositoryIDNumber,ClientIDNumber,
							LastUpdatedby,LastUpdatedOn,Mobile,SecondaryEmailID,
							(SELECT CountryName from EmployeeMaster where LoginID=@LoginId AND DELETED=0)[CountryName],
							COST_CENTER, BROKER_DEP_TRUST_CMP_NAME, BROKER_DEP_TRUST_CMP_ID, BROKER_ELECT_ACC_NUM
					FROM EMPDET_With_EXERCISE WHERE ExerciseNo = @ExerciseNo
				END
			ELSE
				BEGIN
				--PRINT('B4')
					SELECT [EmployeeID],[LoginID],[EmployeeName],[EmployeeDesignation],[EmployeeAddress],[EmployeePhone],
						   [DateOfJoining],[DateOfTermination], [Insider],[ResidentialStatus],[PANNumber],[WardNumber],
						   [DematAccountType],[DepositoryIDNumber],[DepositoryParticipantNo],[ClientIDNumber],
						   [EmployeeEmail],[Grade],[Department],[DepositoryName],[BackOutTermination],[IsMailSent],[SBU],
						   [Entity],[AccountNo],[NewEmployeeId],[Location],[ConfStatus],[LastUpdatedBy],[LastUpdatedOn],
						   [ApprovalStatus],[Deleted],[ReasonForTermination],[Remarks],[IsAssociated],[LWD],[Confirmn_Dt],
						   [payrollcountry],[tax_slab],[Mobile],[DPRecord],[PerqAmt_ChequeNo],[PerqAmt_DrownOndate],
						   [PerqAmt_WireTransfer],[PerqAmt_BankName],[PerqAmt_Branch],[PerqAmt_BankAccountNumber],[Branch],
						   [AssociatedDate],[SecondaryEmailID],CountryMaster.[CountryName],[COST_CENTER],[BROKER_DEP_TRUST_CMP_NAME],[BROKER_DEP_TRUST_CMP_ID],[BROKER_ELECT_ACC_NUM] 
					 FROM EmployeeMaster LEFT OUTER JOIN CountryMaster ON EmployeeMaster.CountryName=CountryMaster.CountryAliasName
					 WHERE LoginID = @LoginId AND DELETED=0
				END
		END
	SET NOCOUNT OFF							
END
GO
