/****** Object:  StoredProcedure [dbo].[SP_UPDATETRANACTION_DETAILS_ONLINE]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_UPDATETRANACTION_DETAILS_ONLINE]
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATETRANACTION_DETAILS_ONLINE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_UPDATETRANACTION_DETAILS_ONLINE](
@PANNumber VARCHAR(15),
@Nationality VARCHAR(100),
@ResidentialStatus VARCHAR(20),
@Location VARCHAR(100),
@CountryCode VARCHAR(50),
@Mobile VARCHAR(20),
@DPRecord VARCHAR(50),
@DepositoryName VARCHAR(200),
@DematACType VARCHAR(15),
@DepositoryParticipantName VARCHAR(200),
@DPIDNo VARCHAR(20),
@ClientNo VARCHAR(20),
@OutMessage VARCHAR(10) OUTPUT,
@ExerciseNo INT,
@LoginId VARCHAR(50)
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
LastUpdatedBy = @LoginId,
LastUpdatedOn = GETDATE()
WHERE ExerciseNo = @ExerciseNo

SET @OutMessage = '1'
 
END



if @@ERROR <> 0
BEGIN
SET @OutMessage = 'Error'
END

END
GO
