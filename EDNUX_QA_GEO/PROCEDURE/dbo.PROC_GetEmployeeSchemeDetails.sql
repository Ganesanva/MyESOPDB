/****** Object:  StoredProcedure [dbo].[PROC_GetEmployeeSchemeDetails]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetEmployeeSchemeDetails]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetEmployeeSchemeDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetEmployeeSchemeDetails]

@EmployeeId VARCHAR(20),
@retValue INT OUTPUT 

AS
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT @retValue = COUNT(*)
		 FROM GrantOptions AS GOP INNER JOIN SCHEME AS SCH ON GOP.SchemeId = Sch.SchemeId
	WHERE GOP.EmployeeId = @EmployeeId
	AND ISNULL(SCH.IS_AUTO_EXERCISE_ALLOWED,0) <> 1
	
	
	SET NOCOUNT OFF;
END
GO
