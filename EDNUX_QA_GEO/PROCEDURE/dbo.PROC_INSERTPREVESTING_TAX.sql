/****** Object:  StoredProcedure [dbo].[PROC_INSERTPREVESTING_TAX]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_INSERTPREVESTING_TAX]
GO
/****** Object:  StoredProcedure [dbo].[PROC_INSERTPREVESTING_TAX]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_INSERTPREVESTING_TAX]

	@EMPLOYEE_DETAILS  dbo.TYPE_INSERTEXERCISED_TAX READONLY,
	@CREATED_BY varchar(50),
	@UPDATED_BY varchar(50)
		
AS
BEGIN	

	CREATE Table #TempExercise_Tax_Details
	(
		EPPS_ID BIGINT,
		GrantLegSerialNumber BIGINT,
	    EXERCISE_NO INT
	)

	DECLARE @ExerciseNO BIGINT
	
	SET @ExerciseNO = (SELECT DISTINCT EXERCISE_NO FROM @EMPLOYEE_DETAILS)

	INSERT INTO #TempExercise_Tax_Details (	EPPS_ID ,GrantLegSerialNumber  )
	
	SELECT 
		 EPPS_ID, GrantLegSerialNumber 
	FROM
		 EMPPREPAYSELECTION
	Where EPPS_ID =@ExerciseNO

  	IF NOT EXISTS(SELECT 1 FROM PREVESTING_TAXRATE_DETAILS WHERE EPPS_ID = @ExerciseNO) 
	
    BEGIN  
    
	INSERT INTO [PREVESTING_TAXRATE_DETAILS]
           ([EPPS_ID]       
           ,[COUNTRY_ID]         
           ,[Tax_Title]
           ,[TAX_RATE]
           ,[TAX_SEQ_NO]          
    	   ,[FMVVALUE]
		   ,[TENTATIVEFMVVALUE] 
		   ,[PERQVALUE] 
		   ,[TENTATIVEPERQVALUE] 
		   ,[BASISOFTAXATION]
		   ,[TAX_AMOUNT]
		   ,TENTATIVETAXAMOUNT		   
		   ,[GRANTLEGSERIALNO]
		   ,[FROM_DATE]
		   ,[TO_DATE]
           ,[CREATED_BY]
           ,[CREATED_ON]
           ,[UPDATED_BY]
           ,[UPDATED_ON]
           )
    SELECT CONVERT(NVARCHAR(50),  TTD.EPPS_ID )         
           ,COUNTRYID          
           ,TAXHEADING
           ,TAXRATE
           ,SEQUENCENO
           ,FMVVALUE
		   ,TENTATIVEFMVVALUE 
		   ,PERQVALUE 
		   ,TENTATIVEPERQVALUE 
		   ,BASISOFTAXATION
		   ,TAX_AMOUNT 
		   ,TAX_AMOUNT
		   ,ED.GRANTLEGSERIALNO
		   ,FROM_DATE 
		   ,TO_DATE 
           ,@CREATED_BY
           ,GETDATE()
           ,@UPDATED_BY
           ,GETDATE()          
           FROM @EMPLOYEE_DETAILS ED INNER JOIN #TempExercise_Tax_Details TTD          
           ON ED.GRANTLEGSERIALNO=TTD.GrantLegSerialNumber
	END           
               
END


GO
