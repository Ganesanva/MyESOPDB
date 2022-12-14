/****** Object:  StoredProcedure [dbo].[PROC_GetGroupCompanyDetails]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetGroupCompanyDetails]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetGroupCompanyDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GetGroupCompanyDetails]
(
	@CompanyID VARCHAR(50)
)
AS 
BEGIN
	SET NOCOUNT ON
	/******************************************************/
		--Create New table For save group company setting
	/******************************************************/
	DECLARE @GROUPNAME VARCHAR(50)
	CREATE TABLE #GroupCompSetting 
	(
		CompanyName VARCHAR(100),
		IsActive	BIT,
		GroupName	VARCHAR(100),
		ModifiedBy	VARCHAR(100),
		ViewOn		BIT,	
	)
	INSERT INTO #GroupCompSetting (CompanyName,IsActive,ViewOn)
	SELECT	[CompanyName], 0 AS [IsActive], 0 AS [ViewOn]
	FROM	ESOPManager..LISTOF_ESOP_COMPANY
	
	-----------------------------------------------------------
	-- Update Group companies settings
    -----------------------------------------------------------
	--SELECT *
	--FROM #GroupCompSetting AS GrpComp
	--INNER JOIN ESOPManager..GroupCompanies AS Grp ON Grp.CompanyID = GrpComp.CompanyName
	--WHERE Grp.GroupName IN (SELECT GroupName from ESOPManager..GroupCompanies ) 
	-------------------------------------------------------------
				
	UPDATE GrpComp
	SET	GrpComp.IsActive=1,GrpComp.ViewOn = '', GrpComp.GroupName=Grp.GroupName, ModifiedBy=''
	FROM #GroupCompSetting AS GrpComp
			INNER JOIN ESOPManager..GroupCompanies AS Grp ON Grp.CompanyID = GrpComp.CompanyName
    WHERE Grp.GroupName IN (SELECT GroupName From ESOPManager..GroupCompanies )--WHERE CompanyID = @CompanyID) 
	
	SELECT @GROUPNAME = GroupName From #GroupCompSetting WHERE CompanyName = @CompanyID
	--PRINT @GROUPNAME    			
	-----------------------------------------------------------
	-- Select Group companies settings
	-----------------------------------------------------------			
	SELECT DISTINCT CompanyName, IsActive, GroupName, ModifiedBy, ViewOn FROM (
	SELECT	GRP.CompanyName,
			GRP.IsActive,
			GRP.GroupName,
			GRP.ModifiedBy,
			GRP.ViewOn 
	FROM	#GroupCompSetting	AS GRP	
	WHERE	GRP.CompanyName NOT IN( @CompanyID) 
	AND		(GRP.GroupName IN (@GROUPNAME) OR GRP.GroupName IS NULL)
	
	UNION 
	SELECT CompanyID,'1',GroupName,'','' 
	FROM ESOPManager..GroupCompanies 
	WHERE Groupcode in (SELECT  GroupCode FROM ESOPManager..GroupCompanies WHERE CompanyID = @CompanyID) ) GroupCompanyList

		
	SELECT DISTINCT GROUPNAME FROM ESOPManager..GroupCompanies
	--SELECT	GRP.CompanyName,
	--		GRP.IsActive,
	--		GRP.GroupName,
	--		GRP.ModifiedBy 
	--FROM	#GroupCompSetting	AS GRP	
	--WHERE	GRP.CompanyName NOT IN( @CompanyID) AND GRP.IsActive = 0
	
	DROP TABLE #GroupCompSetting
	SET NOCOUNT OFF
END
GO
