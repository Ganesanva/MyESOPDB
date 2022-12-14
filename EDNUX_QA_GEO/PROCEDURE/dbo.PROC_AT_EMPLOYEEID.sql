/****** Object:  StoredProcedure [dbo].[PROC_AT_EMPLOYEEID]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_AT_EMPLOYEEID]
GO
/****** Object:  StoredProcedure [dbo].[PROC_AT_EMPLOYEEID]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_AT_EMPLOYEEID]
AS
BEGIN
	SELECT '---ALL---' EmployeeID
	
	UNION

	SELECT  
		DISTINCT 
		(CONVERT(VARCHAR,EmployeeID))as EmployeeID  
	FROM 
		AuditTrailAutoReverseOnlineEx 
	ORDER BY 
		EmployeeID 
		ASC
END
GO
