/****** Object:  StoredProcedure [dbo].[SP_UpdateShTransactionDetails_DD]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_UpdateShTransactionDetails_DD]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateShTransactionDetails_DD]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[SP_UpdateShTransactionDetails_DD](
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
@BankName VARCHAR(50),
@PaymentNamePQ VARCHAR(100),
@PerqAmt_DrownOndate DATETIME,
@PerqAmt_BankName VARCHAR(50),
@MessageOut VARCHAR(10) OUTPUT,
@LoginId VARCHAR (50)

	)			 	
AS
BEGIN

INSERT INTO ShTransactionDetails
(
PANNumber ,
Nationality ,
ResidentialStatus ,
Location ,
Mobile,
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
LastUpdatedOn
)
VALUES
(
@PANNumber ,
@Nationality ,
@ResidentialStatus,
@Location ,
@Mobile ,
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
GETDATE()
)

SET @MessageOut = '1'
END

if @@ERROR <> 0
BEGIN
SET @MessageOut = '0'
END
GO
