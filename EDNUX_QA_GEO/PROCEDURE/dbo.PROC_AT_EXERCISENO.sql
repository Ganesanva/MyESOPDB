/****** Object:  StoredProcedure [dbo].[PROC_AT_EXERCISENO]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_AT_EXERCISENO]
GO
/****** Object:  StoredProcedure [dbo].[PROC_AT_EXERCISENO]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_AT_EXERCISENO]
AS
BEGIN
	SELECT '---ALL---' Sh_ExerciseNo
	
	UNION
	
	SELECT  
		DISTINCT 
		(CONVERT(VARCHAR,Sh_ExerciseNo))as Sh_ExerciseNo  
	FROM 
		AuditTrailAutoReverseOnlineEx  
	ORDER BY  
		Sh_ExerciseNo 
		ASC
End

GO
