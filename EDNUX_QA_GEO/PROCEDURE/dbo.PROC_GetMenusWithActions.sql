/****** Object:  StoredProcedure [dbo].[PROC_GetMenusWithActions]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetMenusWithActions]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetMenusWithActions]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetMenusWithActions]  
	@RoleId VARCHAR(300)  
AS  
BEGIN  
	SET NOCOUNT ON;  

	DECLARE @IS_EGRANTS_ENABLED INT
	SELECT
		 @IS_EGRANTS_ENABLED=ISNULL(IS_EGRANTS_ENABLED,0) 
	From CompanyMaster 
	
	SELECT A.MenuSequence, 
		   CASE WHEN M.MENUGROUPNAME IS NULL THEN M.defaultpage ELSE MainMenuName END AS 'defaultpage', 
		   name, 
		   (SELECT B.screenactionid 
			FROM   screenactions B 
			WHERE  B.screenid = A.screenid 
				   AND B.actionid = 1)                                 AS 
		   "ViewControl",
		    
		   (SELECT DISTINCT 1 
			FROM   roleprivileges C 
			WHERE  C.roleid = @RoleId 
				   AND C.screenactionid = (SELECT B.screenactionid 
										   FROM   screenactions B 
										   WHERE  B.screenid = A.screenid 
												  AND B.actionid = 1)) AS 
		   "ViewRights", 
		   (SELECT B.screenactionid 
			FROM   screenactions B 
			WHERE  B.screenid = A.screenid 
				   AND B.actionid = 2)                                 AS 
		   "AddControl", 
		   (SELECT DISTINCT 1 
			FROM   roleprivileges C 
			WHERE  C.roleid = @RoleId 
				   AND C.screenactionid = (SELECT B.screenactionid 
										   FROM   screenactions B 
										   WHERE  B.screenid = A.screenid 
												  AND B.actionid = 2)) AS 
		   "AddRights", 
		   (SELECT B.screenactionid 
			FROM   screenactions B 
			WHERE  B.screenid = A.screenid 
				   AND B.actionid = 3)                                 AS 
		   "UpdateControl", 
		   (SELECT DISTINCT 1 
			FROM   roleprivileges C 
			WHERE  C.roleid = @RoleId 
				   AND C.screenactionid = (SELECT B.screenactionid 
										   FROM   screenactions B 
										   WHERE  B.screenid = A.screenid 
												  AND B.actionid = 3)) AS 
		   "UpdateRights", 
		   (SELECT B.screenactionid 
			FROM   screenactions B 
			WHERE  B.screenid = A.screenid 
				   AND B.actionid = 4)                                 AS 
		   "DeleteControl", 
		   (SELECT DISTINCT 1 
			FROM   roleprivileges C 
			WHERE  C.roleid = @RoleId 
				   AND C.screenactionid = (SELECT B.screenactionid 
										   FROM   screenactions B 
										   WHERE  B.screenid = A.screenid 
												  AND B.actionid = 4)) AS 
		   "DeleteRights", 
		   (SELECT B.screenactionid 
			FROM   screenactions B 
			WHERE  B.screenid = A.screenid 
				   AND B.actionid = 5)                                 AS 
		   "ApproveControl", 
		   (SELECT DISTINCT 1 
			FROM   roleprivileges C 
			WHERE  C.roleid = @RoleId 
				   AND C.screenactionid = (SELECT B.screenactionid 
										   FROM   screenactions B 
										   WHERE  B.screenid = A.screenid 
												  AND B.actionid = 5)) AS 
		   "ApproveRights", 
		   (SELECT B.screenactionid 
			FROM   screenactions B 
			WHERE  B.screenid = A.screenid 
				   AND B.actionid = 6)                                 AS 
		   "DisapproveControl", 
		   (SELECT DISTINCT 1 
			FROM   roleprivileges C 
			WHERE  C.roleid = @RoleId 
				   AND C.screenactionid = (SELECT B.screenactionid 
										   FROM   screenactions B 
										   WHERE  B.screenid = A.screenid 
												  AND B.actionid = 6)) AS 
		   "DisapproveRights",A.ScreenId, M.MENUGROUPNAME
	FROM   screenmaster A 
		   INNER JOIN mainmenumaster M 
				   ON M.mainmenuid = A.mainmenuid 
	WHERE  A.usertypeid = 2  AND ((@IS_EGRANTS_ENABLED=0 AND MENUGROUPNAME IS NULL) OR @IS_EGRANTS_ENABLED=1)
	ORDER  BY M.mainmenuid,A.MenuSequence

	IF(@IS_EGRANTS_ENABLED = 0)
	BEGIN	
			
		/*UNCHECK OR DELETE THE ROLE PRIVILEGES RECORD FOR CR e-Grants UPDATE IS UNCHECKED*/
		IF EXISTS (SELECT SM.* FROM RolePrivileges AS RP INNER JOIN ScreenActions AS SA ON RP.ScreenActionId = SA.ScreenActionId
				INNER JOIN ScreenMaster As SM ON SA.ScreenId = SM.ScreenId
				INNER JOIN MainMenuMaster AS MMM ON SM.MainMenuId=MMM.MainMenuId WHERE UPPER(MMM.MENUGROUPNAME)='e-Grants')
		BEGIN
				
			DELETE FROM 
				RolePrivileges 
			WHERE 
				ScreenActionId IN 
				(
					SELECT 
						DISTINCT SA.ScreenActionId 
					FROM 
						RolePrivileges AS RP 
						INNER JOIN ScreenActions AS SA ON RP.ScreenActionId= SA.ScreenActionId
						INNER JOIN ScreenMaster As SM ON SA.ScreenId= SM.ScreenId 
						INNER JOIN MainMenuMaster AS MMM ON MMM.MainMenuId=SM.MainMenuId
					WHERE 
						UPPER(MMM.MENUGROUPNAME) = 'e-Grants'
				)		
		END
	END			
END       
GO
