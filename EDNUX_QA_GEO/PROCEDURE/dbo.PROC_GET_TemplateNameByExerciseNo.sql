/****** Object:  StoredProcedure [dbo].[PROC_GET_TemplateNameByExerciseNo]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_TemplateNameByExerciseNo]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_TemplateNameByExerciseNo]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PROC_GET_TemplateNameByExerciseNo] 
	(
	 @ExerciseNo VarChar(20)
	)
AS
	
BEGIN
		SET NOCOUNT ON;

	 SELECT TOP(1) TEMPLATE_NAME FROM COUNTRY_WISE_PAYMENT_MODE CWPM
	 INNER JOIN SHEXERCISEDOPTIONS SH ON CWPM.MIT_ID = SH.MIT_ID
	 INNER JOIN PAYMENTMASTER PM ON PM.PAYMENTMODE = SH.PAYMENTMODE
	 WHERE CWPM.PAYMENTMASTER_ID 
	 IN (SELECT TOP(1) PM.ID FROM 
	 SHEXERCISEDOPTIONS SH INNER JOIN PAYMENTMASTER PM ON PM.PAYMENTMODE = ISNULL(NULLIF(SH.PAYMENTMODE, ''), 'X')
	 WHERE EXERCISENO =  @ExerciseNo)

	SET NOCOUNT OFF;
    
	
END
GO
