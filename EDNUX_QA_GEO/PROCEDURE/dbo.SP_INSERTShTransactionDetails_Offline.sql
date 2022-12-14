/****** Object:  StoredProcedure [dbo].[SP_INSERTShTransactionDetails_Offline]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_INSERTShTransactionDetails_Offline]
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERTShTransactionDetails_Offline]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_INSERTShTransactionDetails_Offline](
@PANNumber VARCHAR(15),
@Nationality VARCHAR(100),
@ResidentialStatus VARCHAR(20),
@Location VARCHAR(100),
@Mobile VARCHAR(20),
@DPRecord VARCHAR(50),
@DepositoryName VARCHAR(200),
@DematACType VARCHAR(15),
@DepositoryParticipantName VARCHAR(200),
@DPIDNo VARCHAR(20),
@ClientNo VARCHAR(20),
@PaymentNameEX VARCHAR(100),
@DrawnOn DATETIME,
@BankName VARCHAR(200),
@PaymentNamePQ VARCHAR(100),
@PerqAmt_DrownOndate DATETIME,
@PerqAmt_BankName VARCHAR(200),
@MessageOut VARCHAR(10) OUTPUT,
@LoginId VARCHAR (50),
@Branch VARCHAR(200)=NULL,
@AccountNo VARCHAR(50)=NULL,
@IBANNo VARCHAR(100)=NULL,
@PerqAmt_Branch VARCHAR(200)=NULL,
@PerqAmt_BankAccountNumber VARCHAR(50) =NULL,
@IBANNoPQ VARCHAR(100) =NULL,
@ExerciseNo INT,
@CountryCode VARCHAR(50),
@SecondaryEmailID VARCHAR(500),
@ExAmtTypOfBnkAC VARCHAR(50),
@PeqTxTypOfBnkAC VARCHAR(50),
@CountryName VARCHAR(50),
@CostCenter VARCHAR(200) = NULL,
@BrokerDepTrustCmpName VARCHAR(200) = NULL,
@BrokerDepTrustCmpID VARCHAR(200) = NULL,
@BrokerElectAccNum VARCHAR(200) = NULL
	)			 	
AS
BEGIN

IF EXISTS(SELECT * FROM ShTransactionDetails WHERE ExerciseNo = @ExerciseNo)
BEGIN

UPDATE ShTransactionDetails SET

	PANNumber = @PANNumber,
	Nationality = @Nationality,
	ResidentialStatus = @ResidentialStatus,
	Location = @Location,
	Mobile = @Mobile,
	CountryCode = @CountryCode,
	DPRecord = @DPRecord,
	DepositoryName = @DepositoryName,
	DematACType = @DematACType,
	DepositoryParticipantName = @DepositoryParticipantName,
	DPIDNo = @DPIDNo,
	ClientNo = @ClientNo,
	PaymentNameEX = @PaymentNameEX,
	DrawnOn = @DrawnOn ,
	BankName = @BankName,
	PaymentNamePQ = @PaymentNamePQ ,
	PerqAmt_DrownOndate = @PerqAmt_DrownOndate ,
	PerqAmt_BankName = @PerqAmt_BankName,
	LastUpdatedBy = @LoginId,
	LastUpdatedOn = GETDATE(),
	Branch = @Branch,
	AccountNo = @AccountNo,
	IBANNo = @IBANNo,
	PerqAmt_Branch = @PerqAmt_Branch,
	PerqAmt_BankAccountNumber = @PerqAmt_BankAccountNumber,
	IBANNoPQ = @IBANNoPQ, 
	SecondaryEmailID=@SecondaryEmailID,
    ExAmtTypOfBnkAC = (case when (@ExAmtTypOfBnkAC = '---Select---' OR @ExAmtTypOfBnkAC = '') then null else @ExAmtTypOfBnkAC end) , 
    PeqTxTypOfBnkAC = (case when (@PeqTxTypOfBnkAC = '---Select---' OR @PeqTxTypOfBnkAC = '') then null else @PeqTxTypOfBnkAC end),
	CountryName=@CountryName,
	COST_CENTER = @CostCenter,
	BROKER_DEP_TRUST_CMP_NAME = @BrokerDepTrustCmpName,
	BROKER_DEP_TRUST_CMP_ID = @BrokerDepTrustCmpID,
	BROKER_ELECT_ACC_NUM= @BrokerElectAccNum
	
	WHERE ExerciseNo = @ExerciseNo

SET @MessageOut = '1'
 
END
ELSE
BEGIN 

INSERT INTO ShTransactionDetails
(
	PANNumber ,
	Nationality ,
	ResidentialStatus ,
	Location ,
	Mobile,
	CountryCode,
	DPRecord ,
	DepositoryName ,
	DematACType ,
	DepositoryParticipantName ,
	DPIDNo ,
	ClientNo ,
	PaymentNameEX ,
	DrawnOn ,
	BankName ,
	PaymentNamePQ ,
	PerqAmt_DrownOndate ,
	PerqAmt_BankName,
	LastUpdatedBy,
	LastUpdatedOn,
	Branch,
	AccountNo,
	IBANNo,
	PerqAmt_Branch,
	PerqAmt_BankAccountNumber,
	IBANNoPQ,
	ExerciseNo,
	SecondaryEmailID,
	ExAmtTypOfBnkAC, 
	PeqTxTypOfBnkAC,
	CountryName,
	COST_CENTER,
	BROKER_DEP_TRUST_CMP_NAME,
	BROKER_DEP_TRUST_CMP_ID,
	BROKER_ELECT_ACC_NUM
)
VALUES
(
	@PANNumber ,
	@Nationality ,
	@ResidentialStatus,
	@Location ,
	@Mobile ,
	@CountryCode,
	@DPRecord ,
	@DepositoryName ,
	@DematACType ,
	@DepositoryParticipantName ,
	@DPIDNo ,
	@ClientNo ,
	@PaymentNameEX ,
	@DrawnOn ,
	@BankName,
	@PaymentNamePQ ,
	@PerqAmt_DrownOndate ,
	@PerqAmt_BankName,
	@LoginId,
	GETDATE(),
	@Branch,
	@AccountNo,
	@IBANNo,
	@PerqAmt_Branch,
	@PerqAmt_BankAccountNumber,
	@IBANNoPQ,
	@ExerciseNo,
	@SecondaryEmailID,
	case when (@ExAmtTypOfBnkAC = '---Select---'  OR @ExAmtTypOfBnkAC = '') then null else @ExAmtTypOfBnkAC end, 
	case when (@PeqTxTypOfBnkAC = '---Select---'  OR @PeqTxTypOfBnkAC = '') then null else @PeqTxTypOfBnkAC end,
	@CountryName,
	@CostCenter,
	@BrokerDepTrustCmpName,
	@BrokerDepTrustCmpID,
	@BrokerElectAccNum
)

SET @MessageOut = '1'
 
END

END

IF @@ERROR <> 0
BEGIN
SET @MessageOut = 'Error'
END
GO
