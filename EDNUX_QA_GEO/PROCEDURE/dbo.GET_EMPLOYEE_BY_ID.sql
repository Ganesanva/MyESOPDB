/****** Object:  StoredProcedure [dbo].[GET_EMPLOYEE_BY_ID]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GET_EMPLOYEE_BY_ID]
GO
/****** Object:  StoredProcedure [dbo].[GET_EMPLOYEE_BY_ID]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GET_EMPLOYEE_BY_ID]
	-- ADD THE PARAMETERS FOR THE STORED PROCEDURE HERE	
	@EMPLOYEE_STATUS NVARCHAR(5) NULL
AS
BEGIN

	IF(@EMPLOYEE_STATUS = 'A')
	BEGIN
		SELECT 
			EmployeeID
		FROM 
			EmployeeMaster 	
		WHERE 	
			(Deleted = 0)
		ORDER BY
			EmployeeID ASC
	END
	ELSE IF(@EMPLOYEE_STATUS = 'S')
	BEGIN
		SELECT 
			EmployeeID
		FROM 
			EmployeeMaster 
		WHERE 
			((DateOfTermination IS NOT NULL) AND (DateOfTermination <> '1900-01-01 00:00:00.000')) AND (Deleted = 0)
		ORDER BY
			EmployeeID ASC
	END
	ELSE
	BEGIN
		SELECT 
			EmployeeID
		FROM 
			EmployeeMaster 
		WHERE 
			((DateOfTermination IS NULL) OR (DateOfTermination = '1900-01-01 00:00:00.000')) AND (Deleted = 0)
		ORDER BY
			EmployeeID ASC
	END
END
GO
