/****** Object:  StoredProcedure [dbo].[PROC_GetEmployeedataForLst]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetEmployeedataForLst]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetEmployeedataForLst]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetEmployeedataForLst]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT EmployeeDtlsLst
	FROM NomineeDetailsLst

	SET NOCOUNT OFF;
END
GO
