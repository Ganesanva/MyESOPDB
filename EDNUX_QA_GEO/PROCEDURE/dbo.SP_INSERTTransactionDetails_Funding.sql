/****** Object:  StoredProcedure [dbo].[SP_INSERTTransactionDetails_Funding]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_INSERTTransactionDetails_Funding]
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERTTransactionDetails_Funding]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_INSERTTransactionDetails_Funding](
@PANNumber VARCHAR(15),
@Nationality VARCHAR(100),
@ResidentialStatus VARCHAR(20),
@Location VARCHAR(100),
@Mobile VARCHAR(20),
@MessageOut VARCHAR(10) OUTPUT,
@LoginId VARCHAR (50),
@ExerciseNo INT,
@CountryCode VARCHAR(50),
@DDNo VARCHAR(20),
@BankName VARCHAR(5),
@DDDate DATETIME,
@DDNoPQ VARCHAR(20),
@BankNamePQ VARCHAR(5),
@DDDatePQ DATETIME,
@SecondaryEmailID VARCHAR(500),
@CountryName VARCHAR(50)
	)			 	
AS
BEGIN

IF EXISTS(SELECT * FROM TransactionDetails_Funding WHERE ExerciseNo = @ExerciseNo)
BEGIN

UPDATE TransactionDetails_Funding SET

	PANNumber = @PANNumber,
	Nationality = @Nationality,
	ResidentialStatus = @ResidentialStatus,
	Location = @Location,
	Mobile = @Mobile,
	CountryCode = @CountryCode,
	LastUpdatedOn = GETDATE(),
	LastUpdatedBy = @LoginId,
	DDNo = @DDNo,
	BankName = @BankName,
	DDDate = DDDate,
	DDNoPQ = @DDNoPQ,
	BankNamePQ = @BankNamePQ,
	DDDatePQ = DDDatePQ,
	SecondaryEmailID=@SecondaryEmailID,
	CountryName=@CountryName
	WHERE ExerciseNo = @ExerciseNo


SET @MessageOut = '1'
 
END
ELSE
BEGIN 

INSERT INTO TransactionDetails_Funding
(
	PANNumber ,
	Nationality ,
	ResidentialStatus ,
	Location ,
	Mobile,
	CountryCode,
	LastUpdatedBy,
	LastUpdatedOn,
	ExerciseNo,
	DDNo,
	BankName,
	DDDate,
	DDNoPQ,
	BankNamePQ,
	DDDatePQ,
	SecondaryEmailID,
	CountryName
)
VALUES
(
	@PANNumber ,
	@Nationality ,
	@ResidentialStatus,
	@Location ,
	@Mobile ,
	@CountryCode,
	@LoginId,
	GETDATE(),
	@ExerciseNo,
	@DDNo,
	@BankName,
	@DDDate,
	@DDNoPQ,
	@BankNamePQ,
	@DDDatePQ,
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
