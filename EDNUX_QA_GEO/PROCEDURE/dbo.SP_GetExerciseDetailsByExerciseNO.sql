/****** Object:  StoredProcedure [dbo].[SP_GetExerciseDetailsByExerciseNO]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_GetExerciseDetailsByExerciseNO]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetExerciseDetailsByExerciseNO]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetExerciseDetailsByExerciseNO]
(
	@ExerciseNo VARCHAR(50)
)			 	
AS
BEGIN

	DECLARE @BonusType VARCHAR(10)
	 DECLARE @FaceValue VARCHAR(10)
     SELECT @FaceValue=FaceVaue FROM   companyparameters cp 
	SELECT @BonusType = DisplayAs FROM BonusSplitPolicy 

	SELECT gr.grantdate, gl.SchemeId as SchemeName, gl.grantoptionid,  
		CASE  WHEN  gr.Apply_SAR IS NULL THEN 'N'  ELSE  gr.Apply_SAR  END AS Apply_SAR,
		Convert(varchar, she.exercisedate ,101) AS exercisedate, 
		ISNULL(MAX(GR.EXERCISEPRICEINR),MAX(she.exerciseprice)) AS exerciseprice, SUM(she.exercisedquantity) AS optionsexercised ,
		CASE WHEN sc.CALCULATE_TAX = 'rdoTentativeTax' THEN ISNULL(she.TentativePerqstPayable,she.PerqstPayable)
		WHEN sc.CALCULATE_TAX = 'rdoActualTax' THEN she.PerqstPayable ELSE '' END AS PerqstPayable,
        
        CASE WHEN SC.MIT_ID = 6 AND SC.CALCULATE_TAX = 'rdoTentativeTax' THEN (ISNULL(she.TentShareAriseApprValue,she.ShareAriseApprValue) * @FaceValue )
	         WHEN SC.MIT_ID = 6 AND SC.CALCULATE_TAX = 'rdoActualTax' THEN (ISNULL(she.ShareAriseApprValue,0) * @FaceValue )	ELSE 
        (sum(she.exercisedquantity) * ISNULL(sum(GR.EXERCISEPRICEINR),sum(she.ExercisePrice) )) END as ExerciseAmount,

         CASE WHEN SC.MIT_ID = 6 AND SC.CALCULATE_TAX = 'rdoTentativeTax' THEN (ISNULL(she.TentShareAriseApprValue,she.ShareAriseApprValue) * @FaceValue )+ISNULL(she.TentativePerqstPayable,she.PerqstPayable)
	          WHEN SC.MIT_ID = 6 AND SC.CALCULATE_TAX = 'rdoActualTax' THEN (ISNULL(she.ShareAriseApprValue,0) * @FaceValue ) +ISNULL(she.PerqstPayable,0)
        
		WHEN SC.MIT_ID != 6 THEN  ((sum(she.exercisedquantity) * ISNULL(sum(GR.EXERCISEPRICEINR),sum(she.ExercisePrice) )) + SUM(ISNULL(CASE WHEN sc.CALCULATE_TAX = 'rdoTentativeTax' THEN ISNULL(she.TentativePerqstPayable,she.PerqstPayable)
		WHEN SC.MIT_ID != 6 AND sc.CALCULATE_TAX = 'rdoActualTax' THEN she.PerqstPayable ELSE 0 END,0))) END  as TotalAmount ,
		she.ExerciseId,@BonusType AS BonusType,sc.MIT_ID
	FROM 
		shexercisedoptions she 
	INNER JOIN grantleg gl ON she.grantlegserialnumber = gl.id 
	INNER JOIN 
	(
		SELECT grantoptionid, SUM(grantedoptions) optionsgranted FROM grantleg GROUP BY grantoptionid
	) gld ON gl.grantoptionid = gld.grantoptionid 
	INNER JOIN grantregistration gr ON gr.grantregistrationid = gl.grantregistrationid 
	INNER JOIN scheme sc ON sc.schemeid = gl.schemeid 
	WHERE  
		she.exerciseno = @ExerciseNo 
	GROUP BY 
		gr.grantdate, gl.grantoptionid, gl.schemeid, gl.grantoptionid, gl.grantlegid, SHE.PerqstPayable,
		SHE.TentativePerqstPayable, she.ExerciseId, she.exercisedate, gr.Apply_SAR, sc.CALCULATE_TAX,sc.MIT_ID,she.TentShareAriseApprValue,she.ShareAriseApprValue
END
GO
