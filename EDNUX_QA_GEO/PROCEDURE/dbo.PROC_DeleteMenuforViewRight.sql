/****** Object:  StoredProcedure [dbo].[PROC_DeleteMenuforViewRight]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_DeleteMenuforViewRight]
GO
/****** Object:  StoredProcedure [dbo].[PROC_DeleteMenuforViewRight]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_DeleteMenuforViewRight]  
	@RoleId VARCHAR(300)  
AS  
BEGIN
      
	SET NOCOUNT ON;  

	CREATE TABLE #TEMPGetMenusWithActions
		 (
			MenuSequence NUMERIC(18,0),	defaultpage NVARCHAR(MAX),	name NVARCHAR(MAX),	ViewControl NUMERIC(18,0),	ViewRights  NVARCHAR(MAX),	AddControl  NVARCHAR(MAX),	
			AddRights  NVARCHAR(MAX),UpdateControl  NVARCHAR(MAX), UpdateRights  NVARCHAR(MAX), DeleteControl  NVARCHAR(MAX), DeleteRights  NVARCHAR(MAX), ApproveControl  NVARCHAR(MAX),	
			ApproveRights  NVARCHAR(MAX), DisapproveControl  NVARCHAR(MAX), DisapproveRights  NVARCHAR(MAX), ScreenId NUMERIC(18,0), MENUGROUPNAME NVARCHAR(MAX)   	 
		 )
	INSERT INTO  #TEMPGetMenusWithActions 
		(
			MenuSequence, defaultpage, name, ViewControl, ViewRights, AddControl, AddRights, UpdateControl,	UpdateRights,
			DeleteControl, DeleteRights, ApproveControl, ApproveRights, DisapproveControl, DisapproveRights, ScreenId, MENUGROUPNAME
		)
    EXEC PROC_GetMenusWithActions  @RoleId
	 
	

	IF EXISTS( SELECT * from #TEMPGetMenusWithActions  TEMP WHERE ISNULL(TEMP.ViewRights,'') ='' AND  UPPER(TEMP.MENUGROUPNAME) = 'E-GRANTS')
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
						INNER JOIN #TEMPGetMenusWithActions AS TEMP_GMA ON SA.ScreenId=TEMP_GMA.ScreenId
						INNER JOIN ScreenMaster AS SM ON SA.ScreenId= SM.ScreenId
						INNER JOIN MainMenuMaster AS MMM ON MMM.MainMenuId=SM.MainMenuId
						WHERE
						ISNULL(TEMP_GMA.ViewRights,'') ='' AND  UPPER(TEMP_GMA.MENUGROUPNAME) = 'E-GRANTS'		
				)
	    SELECT 1 AS RESULT
		END
	ELSE
	  BEGIN
	    SELECT 0 AS RESULT
	  END
		DROP TABLE #TEMPGetMenusWithActions		
END        
GO
