/****** Object:  StoredProcedure [dbo].[PROC_PRE_GRANT_VALIDATION]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_PRE_GRANT_VALIDATION]
GO
/****** Object:  StoredProcedure [dbo].[PROC_PRE_GRANT_VALIDATION]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_PRE_GRANT_VALIDATION]
	-- Add the parameters for the stored procedure here
	@CASE VARCHAR(50)
AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- INTERFERING WITH SELECT STATEMENTS.
	
	SET NOCOUNT ON;

    IF(UPPER(@CASE) = 'VALIDATE_EMPLOYEE')
	BEGIN
		SELECT EmployeeID, EmployeeName FROM EmployeeMaster WHERE (Deleted = 0)
	END
	
	IF(UPPER(@CASE) = 'VALIDATE_LETTER_CODE')
	BEGIN
		SELECT DISTINCT LetterCode FROM GrantAccMassUpload
	END
END
GO
