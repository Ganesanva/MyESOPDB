/****** Object:  StoredProcedure [dbo].[PROC_CheckPUPMenusInScreenAction]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CheckPUPMenusInScreenAction]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CheckPUPMenusInScreenAction]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_CheckPUPMenusInScreenAction]
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Note Varchar(800) = ' '
	
	CREATE TABLE #temp 
	(
		Note varchar(500)
	)
	--Check any PUP menu is activated before deactivating PUP Functionality.
	IF EXISTS(	SELECT 'Record In Main Table'
					FROM Scheme SC
					WHERE SC.IsPUPEnabled = 1 
				UNION
				SELECT  'Record In Shadow'
						FROM ShScheme SSC
						WHERE SSC.IsPUPEnabled = 1 
			 )
	BEGIN
		SELECT @Note =  'Please deactive PUP Setting for Schemes.'
	END
	
	--Check any PUP menu is activated before deactivating PUP Functionality.
	IF EXISTS(	SELECT RolePrivilegeId,RoleId 
				FROM RolePrivileges  RP
					INNER JOIN ScreenActions SA
						On SA.ScreenActionId = RP.ScreenActionId
					INNER JOIN ScreenMaster SM
						On SA.ScreenId = SM.ScreenId
				WHERE SM.Name in ( 'PUP Value Report','PUP Value and Payout Upload',
								   'PUP Online Exercise Transaction List',	'PUP Online Exercise Approval',
								   'PUP Grant Summary and Value Report','PUP Exercise Report'))
	BEGIN
		SELECT @Note = @Note +'  ' +'Please deactivate PUP Links from Manage Role Tab.'
	END
	
	IF (LEN(@Note) > 0)
	BEGIN
		INSERT INTO #temp SELECT @Note
		SELECT [Note] FROM #temp
	END
	
	IF EXISTS 
			(        
				SELECT *        
				FROM tempdb.dbo.sysobjects        
				WHERE ID = OBJECT_ID(N'tempdb..#TEMP')        
			)        
		 BEGIN        
			DROP TABLE #temp						
		 END 
	-- Reset SET NOCOUNT to OFF
	SET NOCOUNT OFF;
END
GO
