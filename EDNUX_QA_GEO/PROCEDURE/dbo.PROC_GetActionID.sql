/****** Object:  StoredProcedure [dbo].[PROC_GetActionID]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetActionID]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetActionID]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetActionID] @UserId VARCHAR(20) = ''
	,@ScreenId NUMERIC(9, 0) = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT Actionid
	FROM ScreenActions
	WHERE ScreenId = @ScreenId
		AND ScreenActionId IN (
			SELECT ScreenActionId
			FROM RolePrivileges
			WHERE RoleId = (
					SELECT RoleId
					FROM UserMaster
					WHERE UserId = @UserId
					)
			)

	SET NOCOUNT OFF;
END
GO
