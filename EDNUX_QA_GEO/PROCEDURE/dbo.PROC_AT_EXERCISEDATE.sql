/****** Object:  StoredProcedure [dbo].[PROC_AT_EXERCISEDATE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_AT_EXERCISEDATE]
GO
/****** Object:  StoredProcedure [dbo].[PROC_AT_EXERCISEDATE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_AT_EXERCISEDATE]
AS
BEGIN
	SELECT '---ALL---' ExerciseDate
	
	UNION
	
	SELECT 
		DISTINCT 
		REPLACE(CONVERT(NVARCHAR,CAST(ExerciseDate AS DATETIME), 106),' ', '-') As ExerciseDate  
	FROM 
		AuditTrailAutoReverseOnlineEx 
	ORDER BY 
		ExerciseDate 
		DESC
END
GO
