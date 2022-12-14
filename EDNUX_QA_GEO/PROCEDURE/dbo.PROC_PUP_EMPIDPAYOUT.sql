/****** Object:  StoredProcedure [dbo].[PROC_PUP_EMPIDPAYOUT]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_PUP_EMPIDPAYOUT]
GO
/****** Object:  StoredProcedure [dbo].[PROC_PUP_EMPIDPAYOUT]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_PUP_EMPIDPAYOUT]
AS
BEGIN
	SELECT '---ALL---' 
		AS EMPLOYEEID
	UNION ALL
	SELECT 
		DISTINCT EMPLOYEEID 
			FROM GrantOptions GOP
			INNER JOIN Scheme Sch 
			ON GOP.SchemeId = Sch.SchemeId
		WHERE Sch.IsPUPEnabled = 1 and Sch.PUPExedPayoutProcess <>1 
			ORDER BY EmployeeId
END
GO
