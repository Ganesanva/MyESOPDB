DROP PROCEDURE IF EXISTS [dbo].[PROC_UpdateSinglePayModeStatus]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UpdateSinglePayModeStatus]    Script Date: 18-07-2022 16:35:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_UpdateSinglePayModeStatus] @IsSinglePayModeAllowed BIT = NULL
	,@LastUpdatedBy VARCHAR(20) = NULL
	,@CDSLSettings TINYINT = NULL
	,@HeaderForExerciseAmount VARCHAR(1000) = NULL
	,@AccountNoForExerciseAmount VARCHAR(20) = NULL
	,@HeaderForPerquisiteTax VARCHAR(1000) = NULL
	,@AccountNoForPerquisiteTax VARCHAR(20) = NULL
	,@EnableNominee CHAR = NULL
	,@EmpEditNominee CHAR = NULL
	,@SendMailToEmp CHAR = NULL
	,@NominationText VARCHAR(MAX) = NULL
	,@NominationAddress VARCHAR(MAX) = NULL
	,@NominationTextNote VARCHAR(MAX) = NULL
	,@IncludeAcSlipOnExFrm BIT = NULL
	,@BypassBankSelection BIT = NULL
	,@Is_Show_SharesAllowed TINYINT = NULL
	,@Is_Show_CashLayout TINYINT = NULL
	,@IsNomineeAutoApproval BIT =NULL
	,@AllowMaxNominee INT = 1
	,@EnableRelationWithEmp CHAR = NULL
	,@EnableNomineePANNo CHAR = NULL
	,@EnableGuardianRelation CHAR = NULL
	,@EnableGUardianPANNo CHAR = NULL
	 
	,@EnableNomineeEmailId CHAR = NULL
	,@EnableNomineeContactNo CHAR = NULL
	,@EnableNomineeAdharNo CHAR = NULL
	,@EnableNomineeSIDNo  CHAR = NULL
	,@EnableNomineeOther1 CHAR = NULL
	,@EnableNomineeOther2 CHAR = NULL
	,@EnableNomineeOther3 CHAR = NULL
	,@EnableNomineeOther4 CHAR = NULL
	,@EnableGuardianEmailId CHAR = NULL
	,@EnableGuardianContactNo CHAR = NULL
	,@EnableGuardianAdharNo CHAR = NULL
	,@EnableGuardianSIDNo  CHAR = NULL
	,@EnableGuardianOther1 CHAR = NULL
	,@EnableGuardianOther2 CHAR = NULL
	,@EnableGuardianOther3 CHAR = NULL
	,@EnableGuardianOther4 CHAR = NULL
	,@retValue INT OUTPUT 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE CompanyParameters
	SET IsSinglePayModeAllowed = ISNULL(@IsSinglePayModeAllowed, IsSinglePayModeAllowed)
		,LastUpdatedBy = ISNULL(@LastUpdatedBy, LastUpdatedBy)
		,LastUpdatedOn = GETDATE()
		,CDSLSettings = ISNULL(@CDSLSettings, CDSLSettings)
		,HeaderForExerciseAmount = ISNULL(@HeaderForExerciseAmount, HeaderForExerciseAmount)
		,AccountNoForExerciseAmount = ISNULL(@AccountNoForExerciseAmount, AccountNoForExerciseAmount)
		,HeaderForPerquisiteTax = ISNULL(@HeaderForPerquisiteTax, HeaderForPerquisiteTax)
		,AccountNoForPerquisiteTax = ISNULL(@AccountNoForPerquisiteTax, AccountNoForPerquisiteTax)
		,EnableNominee = ISNULL(@EnableNominee, EnableNominee)
		,EmpEditNominee = ISNULL(@EmpEditNominee, EmpEditNominee)
		,SendMailToEmp = ISNULL(@SendMailToEmp, SendMailToEmp)
		,NominationText = ISNULL(@NominationText, NominationText)
		,NominationAddress = ISNULL(@NominationAddress, NominationAddress)
		,NominationTextNote = ISNULL(@NominationTextNote, NominationTextNote)
		,IncludeAcSlipOnExFrm = ISNULL(@IncludeAcSlipOnExFrm, IncludeAcSlipOnExFrm)
		,BypassBankSelection = ISNULL(@BypassBankSelection, BypassBankSelection)
		,IS_SHOW_SHAREALLOTED=ISNULL(@Is_Show_SharesAllowed,IS_SHOW_SHAREALLOTED)
		,IS_SHOW_CASHPAYOUT=ISNULL(@Is_Show_CashLayout,IS_SHOW_CASHPAYOUT)
		,IsNomineeAutoApproval = ISNULL(@IsNomineeAutoApproval, IsNomineeAutoApproval)
		,AllowMaxNominee = @AllowMaxNominee 		
		,EnableRelationWithEmp = @EnableRelationWithEmp 
		,EnableNomineePANNo = @EnableNomineePANNo 
		,EnableGuardianRelation = @EnableGuardianRelation
		,EnableGUardianPANNo = @EnableGUardianPANNo 
		,EnableNomineeEmailId =	@EnableNomineeEmailId      
		,EnableNomineeContactNo= @EnableNomineeContactNo   
		,EnableNomineeAdharNo =	@EnableNomineeAdharNo      
		,EnableNomineeSIDNo  =	@EnableNomineeSIDNo        
		,EnableNomineeOther1 =	@EnableNomineeOther1       
		,EnableNomineeOther2 =	@EnableNomineeOther2       
		,EnableNomineeOther3 =	@EnableNomineeOther3       
		,EnableNomineeOther4 =	@EnableNomineeOther4       
		,EnableGuardianEmailId = @EnableGuardianEmailId    
		,EnableGuardianContactNo= @EnableGuardianContactNo 
		,EnableGuardianAdharNo = @EnableGuardianAdharNo     
		,EnableGuardianSIDNo  =	@EnableGuardianSIDNo        
		,EnableGuardianOther1 =	@EnableGuardianOther1       
		,EnableGuardianOther2 =	@EnableGuardianOther2       
		,EnableGuardianOther3 =	@EnableGuardianOther3       
		,EnableGuardianOther4 =	@EnableGuardianOther4       

SET @retValue = @@ROWCOUNT;
	SET NOCOUNT OFF;
END
GO


