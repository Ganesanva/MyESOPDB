/****** Object:  StoredProcedure [dbo].[GET_AUDIT_EXERCISETRANSACTION_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GET_AUDIT_EXERCISETRANSACTION_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[GET_AUDIT_EXERCISETRANSACTION_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GET_AUDIT_EXERCISETRANSACTION_DETAILS]

AS	   
BEGIN
	SET NOCOUNT ON;	
		 SELECT  ExerciseNo as 'Exercise No',PayModeName as 'Payment mode as selected',REPLACE(CONVERT( CHAR(11), UPDATED_ON, 106 ),' ','/') as 'Date of payment mode reset',UPDATED_BY as 'Payment mode reset by' FROM AUDIT_EXERCISETRANSACTION_DETAILS Where  PayModeName IS NOT NULL  ORDER BY UPDATED_ON DESC
    SET NOCOUNT OFF;						
END
GO
