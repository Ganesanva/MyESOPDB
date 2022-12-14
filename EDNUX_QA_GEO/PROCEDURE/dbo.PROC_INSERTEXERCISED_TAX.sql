/****** Object:  StoredProcedure [dbo].[PROC_INSERTEXERCISED_TAX]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_INSERTEXERCISED_TAX]
GO
/****** Object:  StoredProcedure [dbo].[PROC_INSERTEXERCISED_TAX]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_INSERTEXERCISED_TAX]    
    
 @EMPLOYEE_DETAILS  dbo.TYPE_INSERTEXERCISED_TAX READONLY,    
 @CREATED_BY varchar(50),    
 @UPDATED_BY varchar(50)    
      
AS    
BEGIN     
    
CREATE TABLE #TempExercise_Tax_Details    
(    
  EXERCISE_ID BIGINT,    
  GRANTLEGSERIALNO BIGINT,    
  EXERCISE_NO INT    
)    
    
DECLARE @ExerciseNO bigint,@RESIDENTIALID INT = 0    
SET @ExerciseNO = (SELECT DISTINCT EXERCISE_NO FROM @EMPLOYEE_DETAILS)    

    
INSERT INTO #TempExercise_Tax_Details ( EXERCISE_ID ,GRANTLEGSERIALNO ,EXERCISE_NO )    
SELECT ExerciseId,GrantLegSerialNumber ,ExerciseNo    
FROM ShExercisedOptions    
Where ExerciseNo =@ExerciseNO    

  SELECT @RESIDENTIALID =  RT.id FROM EmployeeMaster AS EM    
  INNER JOIN ResidentialType as RT     
  on RT.ResidentialStatus = EM.ResidentialStatus    
  WHERE EmployeeID = @CREATED_BY    
   
 INSERT INTO [EXERCISE_TAXRATE_DETAILS]    
           ([EXERCISE_NO]    
           ,[RESIDENT_ID]           
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
		,[TAXCALCULATION_BASEDON]  
		,[STOCKVALUE]  
		,[TENTATIVESTOCKVALUE]  
           )    
   
  
        SELECT CONVERT(NVARCHAR(50),  TTD.EXERCISE_ID ),
            NULL
           ,COUNTRYID              
           ,TAXHEADING    
           ,TAXRATE    
           ,SEQUENCENO    
           ,FMVVALUE     
		 ,TENTATIVEFMVVALUE     
		 ,PERQVALUE     
		 ,TENTATIVEPERQVALUE     
		 ,BASISOFTAXATION    
		 ,CASE WHEN (ISNULL(FMVVALUE,0)> 0) THEN  TAX_AMOUNT ELSE NULL END    
		 ,CASE WHEN (ISNULL(TENTATIVEFMVVALUE,0)> 0) THEN  TAX_AMOUNT ELSE NULL END    
		 ,ED.GRANTLEGSERIALNO    
		 ,FROM_DATE     
		 ,TO_DATE         
		   ,@CREATED_BY    
		   ,GETDATE()    
		   ,@UPDATED_BY    
		   ,GETDATE()                  
		  ,TAXCALCULATION_BASEDON  
		  ,STOCKVALUE  
		  ,TENTATIVESTOCKVALUE  
           FROM @EMPLOYEE_DETAILS ED     
            INNER JOIN #TempExercise_Tax_Details TTD              
           ON ED.GRANTLEGSERIALNO=TTD.GRANTLEGSERIALNO    
              
           
			UPDATE ETD
			SET 
			--ETD.TENTATIVETAXAMOUNT =sh.TentativePerqstPayable,
			ETD.TENTATIVEPERQVALUE=Sh.TentativePerqstValue,
			ETD.TAX_SEQ_NO=sh.TAX_SEQUENCENO
			--ETD.TAX_AMOUNT =sh.PerqstPayable,
		 --   ETD.PERQVALUE=Sh.PerqstValue
			FROM EXERCISE_TAXRATE_DETAILS ETD INNER JOIN ShExercisedOptions sh
			ON ETD.EXERCISE_NO=Sh.ExerciseId
			WHERE sh.EXERCISENO=@ExerciseNO
    
END
GO
