/****** Object:  UserDefinedFunction [dbo].[FN_GET_EXERCISE_STEP_STATUS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP FUNCTION IF EXISTS [dbo].[FN_GET_EXERCISE_STEP_STATUS]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GET_EXERCISE_STEP_STATUS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_GET_EXERCISE_STEP_STATUS](
    @EXERCISE_NO INT
)
RETURNS  
@TEMP_TABLE TABLE 
(
	EXERCISE_STEPID INT, DISPLAY_NAME VARCHAR(200)
)

BEGIN
		DECLARE @EXERCISE_STEPID INT;
		DECLARE @DISPLAY_NAME VARCHAR(200);
		IF EXISTS(SELECT EXERCISE_STEPID,DISPLAY_NAME FROM TRANSACTIONS_EXERCISE_STEP TES WHERE TES.EXERCISE_NO=@EXERCISE_NO)
		BEGIN
		set  @EXERCISE_STEPID=(select top 1
		CASE when isNull(PaymentMode ,'')='' THen '1' 
		else
		CASE when (isNull(PaymentMode ,'') = '' AND ISNULL(IsFormGenerate,0)=0 )  THen '1' 
		 WHEN (isNull(PaymentMode ,'')!='' AND ISNULL(IsFormGenerate,0)=0 )  THEN 
			CASE WHEN (ISNULL(PaymentMode ,'')='N') THEN (Select  CASE WHEN( COUNT(MerchantreferenceNo)>0) THEN '2' ELSE '1' END  
			FROM Transaction_Details WHERE Sh_ExerciseNo=@EXERCISE_NO AND BankReferenceNo IS Not Null)  
			WHEN (ISNULL(PaymentMode ,'')='Q' OR ISNULL(PaymentMode ,'')='D' OR ISNULL(PaymentMode ,'')='W' OR ISNULL(PaymentMode ,'')='R' OR ISNULL(PaymentMode ,'')='I' )
			--THEN (SELECT CASE WHEN( COUNT(ID)>0) THEN '2' ELSE '1' END FROM ShTransactionDetails WHERE ExerciseNo=#Temp_Online_Exercise_Details.ExerciseNo) ELSE '1' 
			THEN '2'
			ELSE 
			CASE WHEN (ISNULL(PaymentMode ,'')='X')  THEN '3' ELSE '1' END	
			END
		 when (ISNULL(PaymentMode ,'')<>'' AND ISNULL(IsFormGenerate,0)=0 )  THen '2' 
		 when (ISNULL(PaymentMode ,'')<>'' AND ISNULL(IsFormGenerate,0)=1 And isnull(IS_UPLOAD_EXERCISE_FORM,0)<>1 And isnull(IsAccepted,0)=0) THen '3' 
		 when (ISNULL(PaymentMode ,'')<>'' AND ISNULL(IsFormGenerate,0)=1 And isnull(IS_UPLOAD_EXERCISE_FORM,0)<>1 And isnull(IsAccepted,0)=1)  THen '4' 
		 when (ISNULL(PaymentMode ,'')<>'' AND ISNULL(IsFormGenerate,0)=1 And isnull(IS_UPLOAD_EXERCISE_FORM,0)=1 And isnull(IsAccepted,0)=1) THen '5'

		 ELse '0' END  END from ShExercisedOptions
		  where ExerciseNo = @EXERCISE_NO) 
		 if(@EXERCISE_STEPID >0 )
		
		 SELECT TOP 1 @DISPLAY_NAME=DISPLAY_NAME  
								FROM TRANSACTIONS_EXERCISE_STEP TES
								WHERE TES.EXERCISE_NO=@EXERCISE_NO 
								
								AND EXERCISE_STEPID= @EXERCISE_STEPID
								ORDER BY EXERCISE_STEPID ASC
								
				--IF EXISTS(	
					--			SELECT EXERCISE_STEPID,DISPLAY_NAME FROM TRANSACTIONS_EXERCISE_STEP TES 
					--			WHERE TES.EXERCISE_NO=@EXERCISE_NO AND ISNULL(IS_ATTEMPTED,0)=0
					--		 )
					--	BEGIN
					--			SELECT TOP 1 @EXERCISE_STEPID=EXERCISE_STEPID,@DISPLAY_NAME=DISPLAY_NAME  
					--			FROM TRANSACTIONS_EXERCISE_STEP TES
					--			WHERE TES.EXERCISE_NO=@EXERCISE_NO AND ISNULL(IS_ATTEMPTED,0)=0
					--			ORDER BY EXERCISE_STEPID ASC
					--	END
					--	ELSE
					--	BEGIN
					--			SET @EXERCISE_STEPID=-1;
					--			SET @DISPLAY_NAME='Allotment';
					--	END
		END
		ELSE
		BEGIN
				SET @EXERCISE_STEPID=0
				SET @DISPLAY_NAME='Select Payment Mode';
		END
		INSERT INTO @TEMP_TABLE	(EXERCISE_STEPID, DISPLAY_NAME)	VALUES (@EXERCISE_STEPID, @DISPLAY_NAME)	
    RETURN 
END;
GO
