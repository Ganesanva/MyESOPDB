/****** Object:  StoredProcedure [dbo].[PROC_GET_EXERCISE_SUMMARY]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_EXERCISE_SUMMARY]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_EXERCISE_SUMMARY]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_EXERCISE_SUMMARY]
(
	@USER_ID		VARCHAR(20)	
)
AS
BEGIN    
	SET NOCOUNT ON; 
		
		
					SELECT 1 AS ExerciseSummaryID,
					'Prevested' as DisplayName ,
					ISNULL((
						SELECT ISNULL(COUNT(DISTINCT EXERCISENO),0) 
						FROM shexercisedoptions SHE 
						WHERE (CONVERT(date, GETDATE())  < CONVERT(date, SHE.ExerciseDate) 
						AND SHE.IsAutoExercised = 2) and ISNULL(PaymentMode ,'')='' AND EmployeeID=@USER_ID
						GROUP BY EmployeeID
					 ),0) AS  DisplayValue
					 

				 UNION

				 SELECT 2 AS ExerciseSummaryID,
					'Auto Exercise' as DisplayName,
					ISNULL((
						SELECT ISNULL(COUNT(DISTINCT EXERCISENO),0) 
						FROM shexercisedoptions SHE 
						WHERE (CONVERT(date, GETDATE())  = CONVERT(date, SHE.ExerciseDate) AND SHE.IsAutoExercised = 1) 
						AND ISNULL(PaymentMode ,'')='' AND EmployeeID=@USER_ID group by EmployeeID
					),0) AS  Displayvalue
					

				 UNION

				 SELECT 3 AS ExerciseSummaryID,
					'In Progress' as DisplayName ,
					ISNULL((
						 SELECT ISNULL(COUNT(DISTINCT EXERCISENO),0) 
						 FROM shexercisedoptions SHE 
						 WHERE ISNULL(PaymentMode ,'')<>'' 
						 AND  (ISNULL(IsFormGenerate,0)=0 or ISNULL(IS_UPLOAD_EXERCISE_FORM,0)=0 
						 AND ISNULL(IsAccepted,0)=0) AND EmployeeID=@USER_ID group by EmployeeID
					 ),0)as DisplayValue
					 

				 UNION

				 SELECT 4 AS ExerciseSummaryID,
					'Completed' as DisplayName,
					ISNULL((
							SELECT ISNULL(COUNT(DISTINCT EXERCISENO),0)  
							from shexercisedoptions SHE where ISNULL(PaymentMode ,'')<>'' and  (ISNULL(IsFormGenerate,0)=1 
							AND ISNULL(IS_UPLOAD_EXERCISE_FORM,0)=1 And ISNULL(IsAccepted,0)=1) AND EmployeeID=@USER_ID group by EmployeeID
					),0) as DisplayValue
					
				
				 UNION

				 SELECT 5 AS ExerciseSummaryID,
				 'Total Value' as DisplayName,
					ISNULL(( SELECT CAST(SUM (ExercisedQuantity * ISNULL(exerciseprice,0))  AS NUMERIC(18,2)) + CAST(SUM(ISNULL(perqstpayable,0)) AS NUMERIC(18,2))
							 from shexercisedoptions WHERE EmployeeID=@USER_ID 
							 GROUP BY EmployeeID
					 ),0)AS DisplayValue
					

         	 SET NOCOUNT OFF;    
END
GO
