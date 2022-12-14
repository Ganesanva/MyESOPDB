/****** Object:  StoredProcedure [dbo].[GradeWiseOptnsRpt]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GradeWiseOptnsRpt]
GO
/****** Object:  StoredProcedure [dbo].[GradeWiseOptnsRpt]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GradeWiseOptnsRpt]	
AS
BEGIN
	SELECT  
			CASE WHEN EMP.Grade = '' THEN '-' ELSE EMP.Grade END Grade, 
			SUM((GL.GrantedOptions * SCH.OptionRatioDivisor)/SCH.OptionRatioMultiplier) as GrantedOptions, 
			SUM((GL.LapsedQuantity * SCH.OptionRatioDivisor)/SCH.OptionRatioMultiplier) as LapsedQuantity 
	FROM	EmployeeMaster EMP 
			INNER JOIN GrantOptions GOP ON GOP.EmployeeId = EMP.EmployeeID 
			INNER JOIN GrantLeg GL ON GL.GrantOptionId = GOP.GrantOptionId 
			INNER JOIN Scheme SCH ON SCH.SchemeId = GL.SchemeId 
			
	GROUP BY EMP.Grade 

	ORDER BY EMP.Grade ASC
END
GO
