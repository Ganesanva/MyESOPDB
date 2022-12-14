/****** Object:  StoredProcedure [dbo].[SP_UPDATETRANSACTION_DETAILS_ONLINE]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_UPDATETRANSACTION_DETAILS_ONLINE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATETRANSACTION_DETAILS_ONLINE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_UPDATETRANSACTION_DETAILS_ONLINE](
@PANNumber VARCHAR(15),
@Nationality VARCHAR(100),
@ResidentialStatus VARCHAR(20),
@Location VARCHAR(100),
@CountryCode VARCHAR(50),
@MobileNumber VARCHAR(20),
@DPRecord VARCHAR(50),
@DepositoryName VARCHAR(200),
@DematACType VARCHAR(15),
@DPName VARCHAR(200),
@DPID VARCHAR(20),
@ClientID VARCHAR(20),
@ExerciseNo INT,
@LoginId VARCHAR(50),
@UTR VARCHAR(30),
@SecondaryEmailID VARCHAR(500),
@CountryName VARCHAR(50),
@OutMessage VARCHAR(10) OUTPUT,
@CostCenter VARCHAR(200) = NULL,
@BrokerDepTrustCmpName VARCHAR(200) = NULL,
@BrokerDepTrustCmpID VARCHAR(200) = NULL,
@BrokerElectAccNum VARCHAR(200) = NULL
      )                      
AS
BEGIN

IF EXISTS(SELECT * FROM Transaction_Details WHERE Sh_ExerciseNo = @ExerciseNo)
BEGIN

UPDATE Transaction_Details SET

	PANNumber = @PANNumber,
	Nationality = @Nationality,
	ResidentialStatus = @ResidentialStatus,
	Location = @Location,
	MobileNumber = @MobileNumber,
	CountryCode = @CountryCode,
	DPRecord = @DPRecord,
	DepositoryName = @DepositoryName,
	DematACType = @DematACType,
	DPName= @DPName,
	DPID = @DPID,
	ClientId = @ClientID,
	LastUpdatedBy = @LoginId,
	LastUpdated = GETDATE(),
	UniqueTransactionNo = @UTR,
	SecondaryEmailID=@SecondaryEmailID,
	CountryName=@CountryName,
	COST_CENTER = @CostCenter,
	BROKER_DEP_TRUST_CMP_NAME = @BrokerDepTrustCmpName,
	BROKER_DEP_TRUST_CMP_ID = @BrokerDepTrustCmpID,
	BROKER_ELECT_ACC_NUM= @BrokerElectAccNum
	WHERE Sh_ExerciseNo = @ExerciseNo and STATUS ='S'

SET @OutMessage = '1'
 
END



if @@ERROR <> 0
BEGIN
SET @OutMessage = 'Error'
END

END
GO
