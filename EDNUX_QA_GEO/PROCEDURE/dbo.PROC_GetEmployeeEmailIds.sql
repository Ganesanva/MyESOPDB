/****** Object:  StoredProcedure [dbo].[PROC_GetEmployeeEmailIds]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetEmployeeEmailIds]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetEmployeeEmailIds]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[PROC_GetEmployeeEmailIds]
(
	@EmployeeId VARCHAR(100)
)
AS
BEGIN
	SET NOCOUNT ON
		DECLARE @SQLQuery VARCHAR(MAX)
		SET @SQLQuery = 'SELECT EmployeeID,EmployeeName,EmployeeEmail FROM EmployeeMaster WHERE EmployeeId='''+@EmployeeId+''''
		EXEC @SQLQuery
	SET NOCOUNT OFF
END
GO
