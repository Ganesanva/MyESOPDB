
If exists (
select 'X'
from sys.triggers 
where name = 'TRIG_CashExercisedData'
and is_disabled = 1
)
begin
Enable TRIGGER [dbo].TRIG_CashExercisedData
ON [dbo].CashExercisedData
end


If exists (
select 'X'
from sys.triggers 
where name = 'TRG_AUDIT_COMPANY_PARAMETERS'
and is_disabled = 1
)
begin
Enable TRIGGER [dbo].TRG_AUDIT_COMPANY_PARAMETERS
ON [dbo].CompanyParameters
end


If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='CompanyMaster'
			and CONSTRAINT_NAME = 'fk_CM_BaseCurrency'
			)
begin
ALTER TABLE CompanyMaster
CHECK CONSTRAINT fk_CM_BaseCurrency;
end


If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='DematSettings'
			and CONSTRAINT_NAME = 'FK__DematSett__Emplo__703EA55A'
			)
begin
ALTER TABLE DematSettings
CHECK CONSTRAINT FK__DematSett__Emplo__703EA55A;
end


If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='EmployeeAcceptance'
			and CONSTRAINT_NAME = 'FK_EmployeeAcceptance_EmployeeMaster'
			)
begin
ALTER TABLE EmployeeAcceptance
CHECK CONSTRAINT FK_EmployeeAcceptance_EmployeeMaster;
end


If exists (
select 'X'
from sys.triggers 
where name = 'UpdateEmployeeDetails'
and is_disabled = 1
)
begin
Enable TRIGGER [dbo].UpdateEmployeeDetails
ON [dbo].EmployeeMaster
end

If exists (
select 'X'
from sys.triggers 
where name = 'UPDATE_IN_EMP_MASTER'
and is_disabled = 1
)
begin
Enable TRIGGER [dbo].UPDATE_IN_EMP_MASTER
ON [dbo].[EmployeeMaster]
end



If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='Exercised'
			and CONSTRAINT_NAME = 'FK_Exercise_GrantLeg'
			)
begin
ALTER TABLE Exercised
CHECK CONSTRAINT FK_Exercise_GrantLeg;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantDistributedLegs'
			and CONSTRAINT_NAME = 'FK_GrantDistributedLegs_GrantApproval'
			)
begin
ALTER TABLE GrantDistributedLegs
CHECK CONSTRAINT FK_GrantDistributedLegs_GrantApproval;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantDistributedLegs'
			and CONSTRAINT_NAME = 'FK_GrantDistributedLegs_GrantRegistration'
			)
begin
ALTER TABLE GrantDistributedLegs
CHECK CONSTRAINT FK_GrantDistributedLegs_GrantRegistration;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantDistributedLegs'
			and CONSTRAINT_NAME = 'FK_GrantDistributedLegs_Scheme'
			)
begin
ALTER TABLE GrantDistributedLegs
CHECK CONSTRAINT FK_GrantDistributedLegs_Scheme;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantDistributedLegs'
			and CONSTRAINT_NAME = 'FK_GrantDistributedLegs_ShareHolderApproval'
			)
begin
ALTER TABLE GrantDistributedLegs
CHECK CONSTRAINT FK_GrantDistributedLegs_ShareHolderApproval;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantDistribution'
			and CONSTRAINT_NAME = 'FK_GrantDistribution_GrantApproval'
			)
begin
ALTER TABLE GrantDistribution
CHECK CONSTRAINT FK_GrantDistribution_GrantApproval;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantDistribution'
			and CONSTRAINT_NAME = 'GrantDistributedLegs'
			)
begin
ALTER TABLE GrantDistribution
CHECK CONSTRAINT FK_GrantDistribution_GrantApproval;
end


If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantDistribution'
			and CONSTRAINT_NAME = 'FK_GrantDistribution_GrantRegistration'
			)
begin
ALTER TABLE GrantDistribution
CHECK CONSTRAINT FK_GrantDistribution_GrantRegistration;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantDistribution'
			and CONSTRAINT_NAME = 'FK_GrantDistribution_Scheme'
			)
begin
ALTER TABLE GrantDistribution
CHECK CONSTRAINT FK_GrantDistribution_Scheme;
end


If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantDistribution'
			and CONSTRAINT_NAME = 'FK_GrantDistribution_ShareHolderApproval'
			)
begin
ALTER TABLE GrantDistribution
CHECK CONSTRAINT FK_GrantDistribution_ShareHolderApproval;
end


If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantLeg'
			and CONSTRAINT_NAME = 'chk_BonusSplitCancelledQuantity'
			)
begin
ALTER TABLE GrantLeg
CHECK CONSTRAINT chk_BonusSplitCancelledQuantity;
end


If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantLeg'
			and CONSTRAINT_NAME = 'chk_BonusSplitExercisedQuantity'
			)
begin
ALTER TABLE GrantLeg
CHECK CONSTRAINT chk_BonusSplitExercisedQuantity;
end


If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantLeg'
			and CONSTRAINT_NAME = 'chk_BonusSplitQuantity'
			)
begin
ALTER TABLE GrantLeg
CHECK CONSTRAINT chk_BonusSplitQuantity;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantLeg'
			and CONSTRAINT_NAME = 'chk_CancelledQuantity'
			)
begin
ALTER TABLE GrantLeg
CHECK CONSTRAINT chk_CancelledQuantity;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantLeg'
			and CONSTRAINT_NAME = 'chk_ExercisableQuantity'
			)
begin
ALTER TABLE GrantLeg
CHECK CONSTRAINT chk_ExercisableQuantity;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantLeg'
			and CONSTRAINT_NAME = 'chk_GrantedQuantity'
			)
begin
ALTER TABLE GrantLeg
CHECK CONSTRAINT chk_GrantedQuantity;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantLeg'
			and CONSTRAINT_NAME = 'chk_LapsedQuantity'
			)
begin
ALTER TABLE GrantLeg
CHECK CONSTRAINT chk_LapsedQuantity;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantLeg'
			and CONSTRAINT_NAME = 'chk_SplitCancelledQuantity'
			)
begin
ALTER TABLE GrantLeg
CHECK CONSTRAINT chk_SplitCancelledQuantity;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantLeg'
			and CONSTRAINT_NAME = 'chk_SplitExercisedQuantity'
			)
begin
ALTER TABLE GrantLeg
CHECK CONSTRAINT chk_SplitExercisedQuantity;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantLeg'
			and CONSTRAINT_NAME = 'chk_SplitQuantity'
			)
begin
ALTER TABLE GrantLeg
CHECK CONSTRAINT chk_SplitQuantity;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantLeg'
			and CONSTRAINT_NAME = 'chk_UnapprovedExerciseQuantity'
			)
begin
ALTER TABLE GrantLeg
CHECK CONSTRAINT chk_UnapprovedExerciseQuantity;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantLeg'
			and CONSTRAINT_NAME = 'chk_UnvestedQuantity'
			)
begin
ALTER TABLE GrantLeg
CHECK CONSTRAINT chk_UnvestedQuantity;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantLeg'
			and CONSTRAINT_NAME = 'FK_GrantLeg_GrantApproval'
			)
begin
ALTER TABLE GrantLeg
CHECK CONSTRAINT FK_GrantLeg_GrantApproval;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantLeg'
			and CONSTRAINT_NAME = 'FK_GrantLeg_GrantDistributedLegs'
			)
begin
ALTER TABLE GrantLeg
CHECK CONSTRAINT FK_GrantLeg_GrantDistributedLegs;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantLeg'
			and CONSTRAINT_NAME = 'FK_GrantLeg_Scheme'
			)
begin
ALTER TABLE GrantLeg
CHECK CONSTRAINT FK_GrantLeg_Scheme;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantLeg'
			and CONSTRAINT_NAME = 'FK_GrantLeg_ShareHolderApproval'
			)
begin
ALTER TABLE GrantLeg
CHECK CONSTRAINT FK_GrantLeg_ShareHolderApproval;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantOptions'
			and CONSTRAINT_NAME = 'FK_GrantOptions_GrantApproval'
			)
begin
ALTER TABLE GrantOptions
CHECK CONSTRAINT FK_GrantOptions_GrantApproval;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantOptions'
			and CONSTRAINT_NAME = 'FK_GrantOptions_MassUpload'
			)
begin
ALTER TABLE GrantOptions
CHECK CONSTRAINT FK_GrantOptions_MassUpload;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantOptions'
			and CONSTRAINT_NAME = 'FK_GrantOptions_Scheme'
			)
begin
ALTER TABLE GrantOptions
CHECK CONSTRAINT FK_GrantOptions_Scheme;
end
If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantOptions'
			and CONSTRAINT_NAME = 'FK_GrantOptions_ShareHolderApproval'
			)
begin
ALTER TABLE GrantOptions
CHECK CONSTRAINT FK_GrantOptions_ShareHolderApproval;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantRegistration'
			and CONSTRAINT_NAME = 'FK_GrantRegistration_GrantApproval'
			)
begin
ALTER TABLE GrantRegistration
CHECK CONSTRAINT FK_GrantRegistration_GrantApproval;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantRegistration'
			and CONSTRAINT_NAME = 'FK_GrantRegistration_Scheme'
			)
begin
ALTER TABLE GrantRegistration
CHECK CONSTRAINT FK_GrantRegistration_Scheme;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantRegistration'
			and CONSTRAINT_NAME = 'FK_GrantRegistration_ShareHolderApproval'
			)
begin
ALTER TABLE GrantRegistration
CHECK CONSTRAINT FK_GrantRegistration_ShareHolderApproval;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='LapseTrans'
			and CONSTRAINT_NAME = 'FK_LapseTrans_EmployeeMaster'
			)
begin
ALTER TABLE LapseTrans
CHECK CONSTRAINT FK_LapseTrans_EmployeeMaster;
end


If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='LapseTrans'
			and CONSTRAINT_NAME = 'FK_LapseTrans_GrantLeg'
			)
begin
ALTER TABLE LapseTrans
CHECK CONSTRAINT FK_LapseTrans_GrantLeg;
end


If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='NewMessageTo'
			and CONSTRAINT_NAME = 'FK_NewMessageTo_EmployeeMaster'
			)
begin
ALTER TABLE NewMessageTo
CHECK CONSTRAINT FK_NewMessageTo_EmployeeMaster;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='NominationDetails'
			and CONSTRAINT_NAME = 'FK__Nominatio__UserI__27F8EE98'
			)
begin
ALTER TABLE NominationDetails
CHECK CONSTRAINT FK__Nominatio__UserI__27F8EE98;
end


If exists (
select 'X'
from sys.triggers 
where name = 'TRG_AUDIT_OGA_CONFIGURATIONS'
and is_disabled = 1
)
begin
Enable TRIGGER [dbo].TRG_AUDIT_OGA_CONFIGURATIONS
ON [dbo].OGA_CONFIGURATIONS
end

If exists (
select 'X'
from sys.triggers 
where name = 'TrigUpdatePaymentMaster'
and is_disabled = 1
)
begin
Enable TRIGGER [dbo].TrigUpdatePaymentMaster
ON [dbo].PaymentMaster
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='PaymentSlipDetails'
			and CONSTRAINT_NAME = 'FK__PaymentSl__Exerc__3AA1AEB8'
			)
begin
ALTER TABLE PaymentSlipDetails
CHECK CONSTRAINT FK__PaymentSl__Exerc__3AA1AEB8;
end


If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='PerformanceBasedGrant'
			and CONSTRAINT_NAME = 'FK_PerformanceBasedGrant_EmployeeMaster'
			)
begin
ALTER TABLE PerformanceBasedGrant
CHECK CONSTRAINT FK_PerformanceBasedGrant_EmployeeMaster;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='PerformanceBasedGrant'
			and CONSTRAINT_NAME = 'FK_PerformanceBasedGrant_Scheme'
			)
begin
ALTER TABLE PerformanceBasedGrant
CHECK CONSTRAINT FK_PerformanceBasedGrant_Scheme;
end

If exists (
select 'X'
from sys.triggers 
where name = 'TRIG_UPDATE_PAYMENT_MASTER'
and is_disabled = 1
)
begin
Enable TRIGGER [dbo].TRIG_UPDATE_PAYMENT_MASTER
ON [dbo].[ResidentialPaymentMode]
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='RoleMaster'
			and CONSTRAINT_NAME = 'FK_RoleMaster_UserType'
			)
begin
ALTER TABLE RoleMaster
CHECK CONSTRAINT FK_RoleMaster_UserType;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='Scheme'
			and CONSTRAINT_NAME = 'FK_Scheme_ShareHolderApproval'
			)
begin
ALTER TABLE Scheme
CHECK CONSTRAINT FK_Scheme_ShareHolderApproval;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='Scheme'
			and CONSTRAINT_NAME = 'FK_Scheme_ShareHolderApproval'
			)
begin
ALTER TABLE Scheme
CHECK CONSTRAINT FK_Scheme_ShareHolderApproval;
end

If exists (
select 'X'
from sys.triggers 
where name = 'TrgNAPaymentSetting'
and is_disabled = 1
)
begin
Enable TRIGGER [dbo].TrgNAPaymentSetting
ON [dbo].[Scheme]
end

If exists (
select 'X'
from sys.triggers 
where name = 'TRIG_AUDIT_SCHEME'
and is_disabled = 1
)
begin
Enable TRIGGER [dbo].TRIG_AUDIT_SCHEME
ON [dbo].[Scheme]
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='ScreenMaster'
			and CONSTRAINT_NAME = 'FK_ScreenMaster_MainManuMaster'
			)
begin
ALTER TABLE ScreenMaster
CHECK CONSTRAINT FK_ScreenMaster_MainManuMaster;
end


If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='ShExercisedOptions'
			and CONSTRAINT_NAME = 'FK_ExercisedSARDetails_ShExerciseOptions'
			)
begin
ALTER TABLE ShExercisedOptions
CHECK CONSTRAINT FK_ExercisedSARDetails_ShExerciseOptions;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='ShExercisedOptions'
			and CONSTRAINT_NAME = 'FK_GrantLegSerialNumber'
			)
begin
ALTER TABLE ShExercisedOptions
CHECK CONSTRAINT FK_GrantLegSerialNumber;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='ShGrantDistribution'
			and CONSTRAINT_NAME = 'FK_ShGrantDistribution_GrantApproval'
			)
begin
ALTER TABLE ShGrantDistribution
CHECK CONSTRAINT FK_ShGrantDistribution_GrantApproval;
end
If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='ShGrantDistribution'
			and CONSTRAINT_NAME = 'FK_ShGrantDistribution_GrantRegistration'
			)
begin
ALTER TABLE ShGrantDistribution
CHECK CONSTRAINT FK_ShGrantDistribution_GrantRegistration;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='ShGrantDistribution'
			and CONSTRAINT_NAME = 'FK_ShGrantDistribution_Scheme'
			)
begin
ALTER TABLE ShGrantDistribution
CHECK CONSTRAINT FK_ShGrantDistribution_Scheme;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='ShGrantDistribution'
			and CONSTRAINT_NAME = 'FK_ShGrantDistribution_ShareHolderApproval'
			)
begin
ALTER TABLE ShGrantDistribution
CHECK CONSTRAINT FK_ShGrantDistribution_ShareHolderApproval;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='ShGrantOptions'
			and CONSTRAINT_NAME = 'FK_ShGrantOptions_GrantApproval'
			)
begin
ALTER TABLE ShGrantOptions
CHECK CONSTRAINT FK_ShGrantOptions_GrantApproval;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='ShGrantOptions'
			and CONSTRAINT_NAME = 'FK_ShGrantOptions_MassUpload'
			)
begin
ALTER TABLE ShGrantOptions
CHECK CONSTRAINT FK_ShGrantOptions_MassUpload;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='ShGrantOptions'
			and CONSTRAINT_NAME = 'FK_ShGrantOptions_Scheme'
			)
begin
ALTER TABLE ShGrantOptions
CHECK CONSTRAINT FK_ShGrantOptions_Scheme;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='ShGrantOptions'
			and CONSTRAINT_NAME = 'FK_ShGrantOptions_ShareHolderApproval'
			)
begin
ALTER TABLE ShGrantOptions
CHECK CONSTRAINT FK_ShGrantOptions_ShareHolderApproval;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='ShGrantRegistration'
			and CONSTRAINT_NAME = 'FK_ShGrantRegistration_GrantApproval'
			)
begin
ALTER TABLE ShGrantRegistration
CHECK CONSTRAINT FK_ShGrantRegistration_GrantApproval;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='ShGrantRegistration'
			and CONSTRAINT_NAME = 'FK_ShGrantRegistration_Scheme'
			)
begin
ALTER TABLE ShGrantRegistration
CHECK CONSTRAINT FK_ShGrantRegistration_Scheme;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='ShGrantRegistration'
			and CONSTRAINT_NAME = 'FK_ShGrantRegistration_ShareHolderApproval'
			)
begin
ALTER TABLE ShGrantRegistration
CHECK CONSTRAINT FK_ShGrantRegistration_ShareHolderApproval;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='ShSchemeSeparationRule'
			and CONSTRAINT_NAME = 'FK_ShSchemeSeparationRule_ShareHolderApproval'
			)
begin
ALTER TABLE ShSchemeSeparationRule
CHECK CONSTRAINT FK_ShSchemeSeparationRule_ShareHolderApproval;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='ShTransactionDetails'
			and CONSTRAINT_NAME = 'fk_ExAmtTypOfBnkAC'
			)
begin
ALTER TABLE ShTransactionDetails
CHECK CONSTRAINT fk_ExAmtTypOfBnkAC;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='ShTransactionDetails'
			and CONSTRAINT_NAME = 'fk_PeqTxTypOfBnkAC'
			)
begin
ALTER TABLE ShTransactionDetails
CHECK CONSTRAINT fk_PeqTxTypOfBnkAC;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='STATUS_TAX_UPDATION'
			and CONSTRAINT_NAME = 'chk_UpdationMode'
			)
begin
ALTER TABLE STATUS_TAX_UPDATION
CHECK CONSTRAINT chk_UpdationMode;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='UploadDetails'
			and CONSTRAINT_NAME = 'FK_UploadDetails_CategoryMaster'
			)
begin
ALTER TABLE UploadDetails
CHECK CONSTRAINT FK_UploadDetails_CategoryMaster;
end

If exists (
select 'X'
from sys.triggers 
where name = 'AUDIT_CR_LOGIN'
and is_disabled = 1
)
begin
Enable TRIGGER [dbo].AUDIT_CR_LOGIN
ON [dbo].[UserLoginHistory]
end


If exists (
select 'X'
from sys.triggers 
where name = 'UPDATE_IN_USER_MASTER'
and is_disabled = 1
)
begin
Enable TRIGGER [dbo].UPDATE_IN_USER_MASTER
ON [dbo].[UserMaster]
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='UserPassword'
			and CONSTRAINT_NAME = 'FK_UserPassword_UserMaster'
			)
begin
ALTER TABLE UserPassword
CHECK CONSTRAINT FK_UserPassword_UserMaster;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='UserSecurityQuestion'
			and CONSTRAINT_NAME = 'FK_UserSecurityQuestion_SecurityQuestionMaster'
			)
begin
ALTER TABLE UserSecurityQuestion
CHECK CONSTRAINT FK_UserSecurityQuestion_SecurityQuestionMaster;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='VestingPeriod'
			and CONSTRAINT_NAME = 'FK_VestingPeriod_GrantApproval'
			)
begin
ALTER TABLE VestingPeriod
CHECK CONSTRAINT FK_VestingPeriod_GrantApproval;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='VestingPeriod'
			and CONSTRAINT_NAME = 'FK_VestingPeriod_Scheme'
			)
begin
ALTER TABLE VestingPeriod
CHECK CONSTRAINT FK_VestingPeriod_Scheme;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='VestingPeriod'
			and CONSTRAINT_NAME = 'FK_VestingPeriod_ShareHolderApproval'
			)
begin
ALTER TABLE VestingPeriod
CHECK CONSTRAINT FK_VestingPeriod_ShareHolderApproval;
end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='GrantLeg'
			and CONSTRAINT_NAME = 'chk_ExercisedQuantity'
			)
begin
ALTER TABLE GrantLeg
CHECK CONSTRAINT chk_ExercisedQuantity;
end



If exists (SELECT 'X'
			FROM sysindexes
			WHERE name='EMPMASTER_LOGINID'
			)
begin
drop index   EmployeeMaster.EMPMASTER_LOGINID

end

If exists (SELECT 'X'
			FROM sysindexes
			WHERE name='Scheme_MIT_ID'
			)
begin
drop index   Scheme.Scheme_MIT_ID

end

If exists (SELECT 'X'
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE TABLE_NAME='Cancelled'
			and CONSTRAINT_NAME = 'FK_Cancelled_CancelledTrans'
			)
begin
ALTER TABLE [dbo].[Cancelled] 
CHECK CONSTRAINT [FK_Cancelled_CancelledTrans];
end
