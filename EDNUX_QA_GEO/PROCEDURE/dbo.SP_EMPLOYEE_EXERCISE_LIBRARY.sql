/****** Object:  StoredProcedure [dbo].[SP_EMPLOYEE_EXERCISE_LIBRARY]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_EMPLOYEE_EXERCISE_LIBRARY]
GO
/****** Object:  StoredProcedure [dbo].[SP_EMPLOYEE_EXERCISE_LIBRARY]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_EMPLOYEE_EXERCISE_LIBRARY] 
	@EMPLOYEEID as nvarchar(100) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @SQL_QUERY VARCHAR(MAX);
	DECLARE @SQL_WHERE VARCHAR(100);
	
	IF (@EMPLOYEEID <> '')
		BEGIN
			SET @SQL_WHERE = ' WHERE EMPLOYEEID = ' + CHAR(39) + @EMPLOYEEID + CHAR(39)
		END
	ELSE
		SET @SQL_WHERE = ''

	SET @SQL_QUERY = 
	'
	SELECT * FROM 
	(
		SELECT ''Pending for Allotment'' as ExStatus,	GL.SchemeId, GL.GrantRegistrationId , GL.GrantOptionId, GL.GrantLegId, CASE WHEN GL.VestingType = ''P'' THEN ''Performance Based'' ELSE ''Time Based'' END VestingType,
				EM.EmployeeID, EM.EmployeeName,
				SHEX.ExerciseNo, SHEX.ExerciseId, SHEX.ExerciseDate, NULL SharesIssuedDate, SHEX.ExercisedQuantity, PM.PayModeName, SHEX.Perq_Tax_rate, SHEX.PerqstPayable, SHEX.PerqstValue
		FROM 
			GrantLeg GL 
			INNER JOIN ShExercisedOptions SHEX ON SHEX.GrantLegSerialNumber = GL.ID
			INNER JOIN PaymentMaster PM ON PM.PaymentMode = SHEX.PaymentMode
			INNER JOIN EmployeeMaster EM ON EM.EmployeeID = SHEX.EmployeeID
		UNION
		SELECT ''Exericse Alloted'' as ExStatus,	GL.SchemeId, GL.GrantRegistrationId , GL.GrantOptionId, GL.GrantLegId, CASE WHEN GL.VestingType = ''P'' THEN ''Performance Based'' ELSE ''Time Based'' END VestingType,
				EM.EmployeeID, EM.EmployeeName,
				EX.ExerciseNo, EX.ExercisedId, EX.ExercisedDate, EX.SharesIssuedDate,  EX.ExercisedQuantity, PM.PayModeName, EX.Perq_Tax_rate, EX.PerqstPayable, EX.PerqstValue
		FROM 
			GrantLeg GL 
			INNER JOIN Exercised EX ON EX.GrantLegSerialNumber = GL.ID
			INNER JOIN PaymentMaster PM ON PM.PaymentMode = EX.PaymentMode
			INNER JOIN GrantOptions GOP ON GOP.GrantOptionId = GL.GrantOptionId
			INNER JOIN EmployeeMaster EM ON EM.EmployeeID = GOP.EmployeeID	
	) 
	FINAL_OUTPUT
	'
	
	
	EXECUTE (@SQL_QUERY + @SQL_WHERE + ' ORDER BY EMPLOYEEID')
END	
GO
