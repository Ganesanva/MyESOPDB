/****** Object:  StoredProcedure [dbo].[UpdateDematDetailsforShareRegister]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[UpdateDematDetailsforShareRegister]
GO
/****** Object:  StoredProcedure [dbo].[UpdateDematDetailsforShareRegister]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****************************************************************    
Procedure	: [UpdateDematDetailsforShareRegister]    
Create By	: Chetan Tembhre
Created On	: 3 Sep 2013 
Description	: Update Demat Details
Modified By : Santosh P
Modified On : 28-Jan-2014
Description : This procedure use for update demat details against Exercise Number.
			  DECLARE @R INT EXEC UpdateDematDetailsforShareRegister  '5451','KPITC','Nehatank',NULL,NULL, @R OUTPUT SELECT @R
****************************************************************/    
CREATE PROCEDURE [dbo].[UpdateDematDetailsforShareRegister]    
(
   @ExerciseNo NVARCHAR(100), 
   @DPID VARCHAR(50),
   @ClientID VARCHAR(50),
   @DepositoryParticipantName VARCHAR(150),
   @DepositoryName VARCHAR(10),
   @Result INT = 0 OUTPUT 
 )
 AS 
 BEGIN
 DECLARE	@PaymentMode VARCHAR(10),
			@TempDepositoryName VARCHAR(10)
			 
			
 SET @TempDepositoryName= CASE WHEN @DepositoryName='CDSL' THEN 'C' ELSE 'N' END
  
 --This could be B for Broker OR D for Depository
 DECLARE @ActionType AS CHAR(1) = (SELECT RIGHT(@ExerciseNo,1))
 
 DECLARE @reversed VARCHAR(100)
 SET @reversed = REVERSE(@ExerciseNo)
 SET @ExerciseNo= REVERSE(SUBSTRING(@reversed, CHARINDEX('~', @reversed)+ 2, 100))
 
 SELECT @PaymentMode=PaymentMode FROM ShExercisedOptions WHERE ExerciseNo=@ExerciseNo

 IF (@PaymentMode='A') OR (@PaymentMode='P')
	BEGIN 
	     UPDATE TransactionDetails_CashLess 
	     SET	DepositoryName=@TempDepositoryName,
				DPId=@DPID,
				ClientId=@ClientID,
				DPRecord=@DepositoryParticipantName 
		WHERE	ExerciseNo =@ExerciseNo
		
	END 
	 
 ELSE 
 BEGIN 
       IF (@ActionType = 'B')
	      BEGIN
			UPDATE   ShTransactionDetails 
			SET		 BROKER_DEP_TRUST_CMP_ID=@DepositoryParticipantName,
					 BROKER_DEP_TRUST_CMP_NAME=@DepositoryName,
					 BROKER_ELECT_ACC_NUM=@ClientID
			WHERE	 ExerciseNo=@ExerciseNo
		  END
	  ELSE		  		  
			BEGIN 
			  UPDATE ShTransactionDetails 
			  SET	DepositoryName=@TempDepositoryName,
					DPIDNo=@DPID,
					ClientNo=@ClientID,
					DepositoryParticipantName=@DepositoryParticipantName 
			 WHERE	ExerciseNo=@ExerciseNo
		   END
  END
   
	IF (@ActionType = 'B')
	BEGIN
	UPDATE   EMPDET_With_EXERCISE 
	SET		 BROKER_DEP_TRUST_CMP_ID=@DepositoryParticipantName,
	         BROKER_DEP_TRUST_CMP_NAME=@DepositoryName,
	         BROKER_ELECT_ACC_NUM=@ClientID
	 WHERE	 ExerciseNo=@ExerciseNo
	
		--select * from EMPDET_With_EXERCISE
	END
	ELSE IF (@ActionType = 'D')
	BEGIN
	UPDATE	EMPDET_With_EXERCISE 
	SET		DEPOSITORYNAME=@ClientID,
			DEPOSITORYPARTICIPANTNO=@DepositoryName,
			DEPOSITORYIDNUMBER=@DPID
	WHERE	ExerciseNo=@ExerciseNo
		
	END
	
	
    --for success it return 1 other wise 0.
  IF(@@ROWCOUNT <>0)
	SET @Result = 1
  ELSE
	SET @Result = 0	
 END

GO
