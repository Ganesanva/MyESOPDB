/****** Object:  StoredProcedure [dbo].[PROC_SelectRolePriviledgeForCR]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SelectRolePriviledgeForCR]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SelectRolePriviledgeForCR]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_SelectRolePriviledgeForCR] @UserId VARCHAR(20) = ''
	,@Name VARCHAR(255) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT AM.ActionId
	FROM ActionMaster AS AM WITH (NOLOCK)
	INNER JOIN ScreenActions AS SA WITH (NOLOCK) ON SA.ActionId = AM.ActionId
	INNER JOIN ScreenMaster AS SM WITH (NOLOCK) ON SM.ScreenId = SA.ScreenId
	INNER JOIN RolePrivileges AS RP WITH (NOLOCK) ON RP.ScreenActionId = SA.ScreenActionId
	INNER JOIN RoleMaster AS RM WITH (NOLOCK) ON RM.RoleId = RP.RoleId
	INNER JOIN UserMaster AS UM WITH (NOLOCK) ON UM.RoleId = RM.RoleId
	WHERE (UM.UserId = @UserId)
		AND (UPPER(SM.NAME) = @Name)

	SET NOCOUNT OFF;
END
GO
