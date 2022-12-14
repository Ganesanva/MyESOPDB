/****** Object:  StoredProcedure [dbo].[PROC_GetEmployeeHomeBoxes]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetEmployeeHomeBoxes]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetEmployeeHomeBoxes]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetEmployeeHomeBoxes] @Show BIT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;
	SET @Show = ISNULL(@Show, 0);

	IF (@Show = 1)
	BEGIN
		SELECT *
		FROM EmployeeHomeBoxes
		WHERE Show = 1
		ORDER BY Position ASC
	END

	BEGIN
		SELECT *
		FROM EmployeeHomeBoxes
	END

	SET NOCOUNT OFF;
END
GO
