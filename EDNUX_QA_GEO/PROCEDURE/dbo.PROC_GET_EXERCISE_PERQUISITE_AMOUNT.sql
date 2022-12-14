/****** Object:  StoredProcedure [dbo].[PROC_GET_EXERCISE_PERQUISITE_AMOUNT]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_EXERCISE_PERQUISITE_AMOUNT]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_EXERCISE_PERQUISITE_AMOUNT]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_EXERCISE_PERQUISITE_AMOUNT]
(	
	@Exercise_No	VARCHAR(10)	
)
 AS
 BEGIN
	SET NOCOUNT ON;
	DECLARE @FaceValue INT 

	SELECT @FaceValue=FaceVaue FROM COMPANYPARAMETERS CP 
	
	SELECT
		 CASE WHEN SCH.MIT_ID = 6 AND SHE.CALCULATE_TAX = 'rdoTentativeTax' THEN (ISNULL(SUM(SHE.TentShareAriseApprValue),SUM(SHE.ShareAriseApprValue)) * @FaceValue )
		 WHEN SCH.MIT_ID = 6 AND SHE.CALCULATE_TAX = 'rdoActualTax' THEN (ISNULL(SUM(SHE.ShareAriseApprValue),0) * @FaceValue )	 ELSE 			   
		 SUM(SHE.ExercisedQuantity * ExercisePrice) END AS  ExerciseAmount,SUM(PerqstPayable) AS PerqusiteTax 
	FROM 
		 ShExercisedOptions AS SHE 
		 INNER JOIN GRANTLEG AS GL ON SHE.GRANTLEGSERIALNUMBER = GL.ID 
		 INNER JOIN SCHEME AS SCH  ON GL.SCHEMEID = SCH.SCHEMEID  
		 WHERE ExerciseNo=@Exercise_No
	GROUP BY SCH.MIT_ID,SHE.CALCULATE_TAX
	SET NOCOUNT OFF;
END

GO
