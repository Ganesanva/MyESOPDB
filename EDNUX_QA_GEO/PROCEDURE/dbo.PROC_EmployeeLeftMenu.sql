/****** Object:  StoredProcedure [dbo].[PROC_EmployeeLeftMenu]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_EmployeeLeftMenu]
GO
/****** Object:  StoredProcedure [dbo].[PROC_EmployeeLeftMenu]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_EmployeeLeftMenu] 
	
AS
BEGIN
	SET NOCOUNT ON;

    SELECT MMM.MainMenuId AS ID, MMM.MainMenuName AS NAME,MMM.MainMenuName AS DisplayAs, MMM.MainMenuId, MMM.MainMenuName, Show AS IsActive FROM MainMenuMaster MMM WHERE UserTypeId = 3

	SELECT ERM.ID, ERM.Name, ERM.DisplayAs, ERM.MainMenuID, MMM.MainMenuName, ERM.Show AS IsActive FROM EmployeeRoleMaster ERM INNER JOIN MainMenuMaster MMM ON ERM.MainMenuID = MMM.MainMenuId INNER JOIN ScreenMaster SM ON UPPER(ERM.Name) = UPPER(SM.Name) WHERE SM.UserTypeId = 3 ORDER BY SM.MainMenuId, SM.MenuSequence
END
GO
