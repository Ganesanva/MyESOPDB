/****** Object:  StoredProcedure [dbo].[PROC_SAVE_EMPDETL_ONEXERCISE]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SAVE_EMPDETL_ONEXERCISE]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SAVE_EMPDETL_ONEXERCISE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_SAVE_EMPDETL_ONEXERCISE] 
		@ExerciseNo numeric (18,0),	
		@LoginId varchar(20)	
AS
BEGIN
	DECLARE @bl_Exercise BIT
	SELECT @bl_Exercise=CASE WHEN  EXISTS (SELECT * FROM PaymentMaster WHERE Exerciseform_Submit ='N')THEN  1 ELSE 0 END
	IF @bl_Exercise=1 
		 BEGIN 
			PRINT 'SAVE DETAILS' 
			INSERT INTO EMPDET_With_EXERCISE 
							(ExerciseNo,DateOfJoining,Grade,EmployeeDesignation ,EmployeePhone ,EmployeeEmail ,EmployeeAddress ,PANNumber ,
							 ResidentialStatus,Insider,WardNumber ,Department ,Location ,SBU ,Entity ,DPRecord ,DepositoryName ,DematAccountType ,
						     DepositoryParticipantNo ,DepositoryIDNumber ,ClientIDNumber ,LastUpdatedby,Mobile, SecondaryEmailID, CountryName, COST_CENTER, BROKER_DEP_TRUST_CMP_NAME, BROKER_DEP_TRUST_CMP_ID, BROKER_ELECT_ACC_NUM )

		   select @ExerciseNo,DateOfJoining,Grade,EmployeeDesignation ,EmployeePhone ,EmployeeEmail ,EmployeeAddress ,PANNumber ,
				  ResidentialStatus,Insider,WardNumber ,Department ,Location ,SBU ,Entity ,DPRecord ,DepositoryName ,DematAccountType ,
				  DepositoryParticipantNo ,DepositoryIDNumber ,ClientIDNumber,@LoginId,Mobile, SecondaryEmailID, CountryName, COST_CENTER, BROKER_DEP_TRUST_CMP_NAME, BROKER_DEP_TRUST_CMP_ID, BROKER_ELECT_ACC_NUM  from EmployeeMaster where LoginID=@LoginId AND DELETED=0
		END
		
	BEGIN --UPDATE THE NEGATIVE VALUE OF PerqstValue AND PerqstPayable TO 0 AND ADD THE SAME IN THE RESPECIVE EXERCISE NO.
	SELECT 
		ExerciseNo, PerqstValue, PerqstPayable 
	INTO 
		#ShExercisedOptions 
	FROM 
		ShExercisedOptions
	WHERE 
		PerqstValue < 0 AND PerqstPayable < 0 AND ExerciseNo = @ExerciseNo

	UPDATE SHEX 
		SET 
			SHEX.PerqstValue  = CASE WHEN SHEX.PerqstValue > 0 THEN (SHEX.PerqstValue + INSD.PerqstValue) WHEN SHEX.PerqstValue < 0 THEN 0 END,
			SHEX.PerqstPayable = CASE WHEN SHEX.PerqstPayable > 0 THEN (SHEX.PerqstPayable + INSD.PerqstPayable) WHEN SHEX.PerqstPayable < 0 THEN 0 END
	FROM 
		ShExercisedOptions SHEX 
		INNER JOIN #ShExercisedOptions INSD ON SHEX.ExerciseNo = INSD.ExerciseNo	

	DROP TABLE #ShExercisedOptions	
	END
END
GO
