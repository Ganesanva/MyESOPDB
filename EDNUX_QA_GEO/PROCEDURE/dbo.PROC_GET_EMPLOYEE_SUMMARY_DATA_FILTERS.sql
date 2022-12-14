/****** Object:  StoredProcedure [dbo].[PROC_GET_EMPLOYEE_SUMMARY_DATA_FILTERS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_EMPLOYEE_SUMMARY_DATA_FILTERS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_EMPLOYEE_SUMMARY_DATA_FILTERS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_EMPLOYEE_SUMMARY_DATA_FILTERS] 
	@SchemeType NVARCHAR (10) = NULL

AS
BEGIN

 IF(@SchemeType = '0')
	BEGIN
	
	SELECT '---ALL SCHEMES---' AS SchemeId
	UNION ALL
	SELECT DISTINCT SchemeId FROM GrantLeg
	
	END
 ELSE IF(@SchemeType = '1')
	BEGIN
	SELECT '---ALL SCHEMES---' AS SchemeId
	UNION ALL
	SELECT 
		DISTINCT SchemeId
	FROM 
		GrantLeg
	WHERE 
	((CASE WHEN VestingType = 'P' AND IsPerfBased ='N' AND GrantedOptions <> (CancelledQuantity + ExercisedQuantity + ExercisableQuantity + UnapprovedExerciseQuantity + LapsedQuantity) THEN  GrantedOptions ELSE ExercisableQuantity END)  + UnapprovedExerciseQuantity) > 0

	END

END
GO
