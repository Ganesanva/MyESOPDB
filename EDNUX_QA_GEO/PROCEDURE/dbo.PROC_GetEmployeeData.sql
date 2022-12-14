/****** Object:  StoredProcedure [dbo].[PROC_GetEmployeeData]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetEmployeeData]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetEmployeeData]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GetEmployeeData] 
	@EmployeeId VARCHAR (20) 
AS
BEGIN
	SET NOCOUNT ON;   
	SELECT EmployeeID,EmployeeName,EmployeeEmail, EmployeeAddress,EmployeePhone FROM EmployeeMaster 
	WHERE EmployeeID = @EmployeeId
END
GO
