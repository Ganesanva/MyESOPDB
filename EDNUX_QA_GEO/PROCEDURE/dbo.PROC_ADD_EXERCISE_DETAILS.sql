/****** Object:  StoredProcedure [dbo].[PROC_ADD_EXERCISE_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_ADD_EXERCISE_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_ADD_EXERCISE_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_ADD_EXERCISE_DETAILS]
(
	 @ExercisedQuantity NUMERIC (18),
	 @GrantLegSerialNumber NUMERIC (18) = NULL ,
	 @ExercisePrice NUMERIC (18,2) ,
	 @ExerciseId    BIGINT ,
	 @ExercisableQuantity NUMERIC (18),
	 @LastUpdatedBy VARCHAR (20),
	 @GrantLegId NUMERIC (18),
	 @EmployeeID   VARCHAR (20) ,
	 @PaymentMode BIGINT  ,
	 @ExerciseAmount NUMERIC(18,2),
	 @MIT_ID      INT ,
	 @TentativeFMVPrice NUMERIC (18,6),
	 @TentativePerqstValue NUMERIC (18,6),
	 @TentativePerqstPayable NUMERIC (18,6),
	 @Action VARCHAR(10),
	 @id int output
)
 AS
 BEGIN
	SET NOCOUNT ON;

	DECLARE @PaymentModeName VARCHAR(2)	
	SELECT @PaymentModeName = PaymentMode FROM PaymentMaster WHERE Id = @PaymentMode
	    
 	IF (@Action ='Add')
 	BEGIN
	  	INSERT INTO EmpPrePaySelection (  ExercisedQuantity, GrantLegSerialNumber ,  ExercisePrice,ExercisableQuantity,LastUpdatedBy,LastUpdatedOn,MIT_ID,GrantLegId,  EmployeeID, PaymentMode,ExerciseAmountPayable ,TentativeFMVPrice, TentativePerqstValue,TentativePerqstPayable,CreatedBy,CreatedOn) 
  		VALUES ( @ExercisedQuantity, @GrantLegSerialNumber ,@ExercisePrice,@ExercisableQuantity,@LastUpdatedBy,getdate(),@MIT_ID,@GrantLegId,  @EmployeeID, @PaymentMode,@ExerciseAmount ,@TentativeFMVPrice, @TentativePerqstValue,@TentativePerqstPayable,@EmployeeID,getdate());
  		
	  	INSERT INTO AUDIT_TRIAL_EMPPREPAYSELECTION (  ExercisedQuantity, GrantLegSerialNumber ,  ExercisePrice,ExercisableQuantity,LastUpdatedBy,LastUpdatedOn,MIT_ID,GrantLegId,  EmployeeID, PaymentMode,ExerciseAmountPayable ,TentativeFMVPrice, TentativePerqstValue,TentativePerqstPayable,CreatedBy,CreatedOn) 
  		VALUES ( @ExercisedQuantity, @GrantLegSerialNumber ,@ExercisePrice,@ExercisableQuantity,@LastUpdatedBy,getdate(),@MIT_ID,@GrantLegId,  @EmployeeID, @PaymentMode,@ExerciseAmount ,@TentativeFMVPrice, @TentativePerqstValue,@TentativePerqstPayable,@EmployeeID,getdate());
  	END 
	ELSE IF (UPPER(@Action) ='EDIT')
 	BEGIN
 	 	
	  	UPDATE EmpPrePaySelection SET  ExercisedQuantity = @ExercisedQuantity,ExercisePrice=@ExercisePrice,ExercisableQuantity=@ExercisableQuantity,LastUpdatedBy=@LastUpdatedBy,LastUpdatedOn=getdate(),GrantLegId=@GrantLegId,  EmployeeID=@EmployeeID, PaymentMode=@PaymentMode,TentativeFMVPrice=@TentativeFMVPrice, TentativePerqstValue=@TentativePerqstValue,TentativePerqstPayable=@TentativePerqstPayable
	  	WHERE EPPS_ID =  @ExerciseId    
	  	/* Insert For Audit Trail*/
 		INSERT INTO AUDIT_TRIAL_EMPPREPAYSELECTION (  ExercisedQuantity, GrantLegSerialNumber ,  ExercisePrice,ExercisableQuantity,LastUpdatedBy,LastUpdatedOn,MIT_ID,GrantLegId,  EmployeeID, PaymentMode,ExerciseAmountPayable ,TentativeFMVPrice, TentativePerqstValue,TentativePerqstPayable) 
  		VALUES ( @ExercisedQuantity, @GrantLegSerialNumber ,@ExercisePrice,@ExercisableQuantity,@LastUpdatedBy,getdate(),@MIT_ID,@GrantLegId,  @EmployeeID, @PaymentMode,@ExerciseAmount ,@TentativeFMVPrice, @TentativePerqstValue,@TentativePerqstPayable);
  	END 
  	SET @id=(SELECT MAX(EPPS_ID) FROM EMPPREPAYSELECTION  )
    RETURN  @id

	SET NOCOUNT OFF;
END
GO
