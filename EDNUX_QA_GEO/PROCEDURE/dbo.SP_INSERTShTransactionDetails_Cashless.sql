/****** Object:  StoredProcedure [dbo].[SP_INSERTShTransactionDetails_Cashless]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_INSERTShTransactionDetails_Cashless]
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERTShTransactionDetails_Cashless]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_INSERTShTransactionDetails_Cashless](

@PanNumber VARCHAR(15),
@Nationality VARCHAR(100),
@ResidentialStatus VARCHAR(20),
@Location VARCHAR(100),
@MobileNumber VARCHAR(50),
@DPRecord VARCHAR(50),
@DepositoryName VARCHAR(50),
@DematAcType VARCHAR(15),
@DPName VARCHAR(50),
@DPId VARCHAR(20),
@ClientId VARCHAR(20),
@MessageOut VARCHAR(10) OUTPUT,
@LoginId VARCHAR (50),
@EmployeeName VARCHAR(200),
@BankName VARCHAR(200),
@BankBranchName VARCHAR(200),
@BankBranchAddress VARCHAR(200),
@BankAccountNo varchar(200),
@AccountType VARCHAR(200),
@IFSCCode VARCHAR(200),
@IBANNo VARCHAR(200),
@ExerciseNo INT,
@CountryCode VARCHAR(50),
@CorrespondentBankName varchar(50),
@CorrespondentBankAddress varchar(150),
@CorrespondentBankAccNo varchar(50)  ,
@CorrespondentBankSwiftCodeABA varchar(50),
@SecondaryEmailID VARCHAR(500),
@CountryName VARCHAR(50)
      )                      
AS
BEGIN

IF EXISTS(SELECT * FROM TransactionDetails_CashLess WHERE ExerciseNo = @ExerciseNo)
BEGIN

UPDATE TransactionDetails_CashLess SET

	PanNumber = @PanNumber,
	Nationality = @Nationality,
	ResidentialStatus = @ResidentialStatus,
	Location = @Location,
	MobileNumber = @MobileNumber,
	CountryCode = @CountryCode,
	DPRecord = @DPRecord,
	DepositoryName = @DepositoryName,
	DematACType = @DematACType,
	DPName = @DPName,
	DPId = @DPId,
	ClientId = @ClientId,
	EmployeeName = @EmployeeName,
	BankName = @BankName,
	BankBranchName = @BankBranchName,
	BankBranchAddress = @BankBranchAddress,
	BankAccountNo = @BankAccountNo,
	AccountType = @AccountType,
	IFSCCode = @IFSCCode,
	IBANNo = @IBANNo,
	LastUpdatedBy = @LoginId,
	LastUpdatedOn = GETDATE(),
	CorrespondentBankName  = @CorrespondentBankName ,
	CorrespondentBankAddress = @CorrespondentBankAddress ,
	CorrespondentBankAccNo  = @CorrespondentBankAccNo ,
	CorrespondentBankSwiftCodeABA  = @CorrespondentBankSwiftCodeABA,
	SecondaryEmailID=@SecondaryEmailID,
	CountryName=@CountryName
  WHERE ExerciseNo = @ExerciseNo

SET @MessageOut = '1'
 
END
ELSE
BEGIN 

INSERT INTO TransactionDetails_CashLess
(
	PanNumber ,
	Nationality ,
	ResidentialStatus ,
	Location ,
	MobileNumber,
	CountryCode,
	DPRecord ,
	DepositoryName ,
	DematACType ,
	DPName ,
	DPId ,
	ClientId ,
	EmployeeName,
	BankName,
	BankBranchName,
	BankBranchAddress,
	BankAccountNo,
	AccountType,
	IFSCCode,
	IBANNo,
	LastUpdatedBy,
	LastUpdatedOn,
	ExerciseNo,
	CorrespondentBankName,
	CorrespondentBankAddress,
	CorrespondentBankAccNo,
	CorrespondentBankSwiftCodeABA,
	SecondaryEmailID,
	CountryName
)
VALUES
(
	@PanNumber,
	@Nationality ,
	@ResidentialStatus,
	@Location ,
	@MobileNumber ,
	@CountryCode,
	@DPRecord ,
	@DepositoryName ,
	@DematACType ,
	@DPName,
	@DPId ,
	@ClientId ,
	@EmployeeName,
	@BankName,
	@BankBranchName,
	@BankBranchAddress,
	@BankAccountNo,
	@AccountType,
	@IFSCCode,
	@IBANNo,
	@LoginId,
	GETDATE(),

	@ExerciseNo,
	@CorrespondentBankName ,
	@CorrespondentBankAddress ,
	@CorrespondentBankAccNo ,
	@CorrespondentBankSwiftCodeABA,
	@SecondaryEmailID,
	@CountryName
)

SET @MessageOut = '1'
 
END

END

if @@ERROR <> 0
BEGIN
SET @MessageOut = 'Error'
END
GO
