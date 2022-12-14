/****** Object:  StoredProcedure [dbo].[PROC_SelectVestingDue]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SelectVestingDue]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SelectVestingDue]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_SelectVestingDue] @EmployeeId VARCHAR(20) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT GrantLeg.FinalVestingDate
	FROM GrantLeg
	INNER JOIN GrantOptions ON GrantLeg.GrantOptionId = GrantOptions.GrantOptionId
	WHERE GrantOptions.EmployeeId = @EmployeeId
	ORDER BY GrantLeg.FinalVestingDate ASC

	SET NOCOUNT OFF;
END
GO
