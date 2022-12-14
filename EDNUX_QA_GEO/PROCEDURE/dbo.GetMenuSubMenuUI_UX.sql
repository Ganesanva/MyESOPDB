/****** Object:  StoredProcedure [dbo].[GetMenuSubMenuUI_UX]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetMenuSubMenuUI_UX]
GO
/****** Object:  StoredProcedure [dbo].[GetMenuSubMenuUI_UX]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetMenuSubMenuUI_UX]
	@UserTypeId		INT,
	@UserID VARCHAR(50)
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @UserName NVARCHAR(100)
	DECLARE @CompanyName NVARCHAR(300)
	DECLARE @Auto_ExerciseCount INT
	DECLARE @MenuID INT
	DECLARE @IS_EGRANTS_ENABLED AS CHAR(1)

	SELECT @UserID=EmployeeID FROM EmployeeMaster WHERE LoginID=@UserID AND Deleted = 0

	IF @UserTypeId=3
	BEGIN
		SELECT @UserName=EmployeeName FROM EmployeeMaster WHERE EmployeeID=@UserID AND Deleted = 0
	END
	ELSE
	BEGIN
		SELECT @UserName=UserName FROM UserMaster WHERE EmployeeID=@UserID
	END

	SELECT @CompanyName=CompanyName FROM CompanyMaster

	/*Hide Exercise Menu for Auto Exercise Employee*/
	SELECT @Auto_ExerciseCount=COUNT(*) FROM GrantOptions AS GOP INNER JOIN SCHEME AS SCH ON GOP.SchemeId = Sch.SchemeId
	WHERE GOP.EmployeeId = @UserID
	AND ISNULL(SCH.IS_AUTO_EXERCISE_ALLOWED,0) <> 1

	SELECT @MenuID=Menu_id FROM MenuSubMenuUI_UX WHERE UPPER(MenuName)='Exercise Options'

	SET @IS_EGRANTS_ENABLED = (SELECT IS_EGRANTS_ENABLED FROM CompanyMaster)

	DECLARE @EGRANTS_ENABLED_MENU INT
	
	IF EXISTS(SELECT Menu_id FROM MenuSubMenuUI_UX WHERE UPPER(MenuName)='Grants' AND @IS_EGRANTS_ENABLED=0)
	BEGIN
		 SELECT @EGRANTS_ENABLED_MENU=Menu_id FROM MenuSubMenuUI_UX WHERE UPPER(MenuName)='Grants'
	END
	ELSE
	BEGIN
		 SET @EGRANTS_ENABLED_MENU=0
	END

	DECLARE @ISDEMAT INT
	SET @ISDEMAT =0
	SET @ISDEMAT = CASE WHEN (SELECT TOP 1 (CASE WHEN CIM.IsActivatedAccount = 'D' THEN 1 ELSE 0 END) FROM  GrantOptions AS GOP
                        INNER JOIN Scheme AS SCH ON GOP.SchemeId =SCH.SchemeId
                        INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON MIT.MIT_ID = SCH.MIT_ID
                        INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON CIM.MIT_ID = MIT.MIT_ID
						INNER JOIN EmployeeMaster EM ON GOP.EmployeeID=EM.EmployeeID
						WHERE EM.EmployeeID=@UserID AND EM.Deleted=0 AND CIM.IsActivatedAccount ='D')>0 THEN 1 ELSE 0 END
    PRINT @ISDEMAT

	DECLARE @ISBROKER INT
	SET @ISBROKER =0
    SET @ISBROKER = CASE WHEN (select top 1 (case WHEN CIM.IsActivatedAccount = 'B' THEN 1 ELSE 0 END) FROM  GrantOptions AS GOP
                        INNER JOIN Scheme AS SCH ON GOP.SchemeId =SCH.SchemeId
                        INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON MIT.MIT_ID = SCH.MIT_ID
                        INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON CIM.MIT_ID = MIT.MIT_ID
						INNER JOIN EmployeeMaster EM ON GOP.EmployeeID=EM.EmployeeID
						WHERE EM.EmployeeID=@UserID AND EM.Deleted=0 AND CIM.IsActivatedAccount ='B')>0 THEN 1 ELSE 0 END
     PRINT @ISBROKER
    /*
    SET @ISDEMAT=(SELECT CASE WHEN (COUNT (MIT_ID))>0 THEN 1 ELSE 0 END FROM COMPANY_INSTRUMENT_MAPPING WHERE MIT_ID in (1,2,5) )

    DECLARE @ISBROKER INT
    SET @ISBROKER =(SELECT CASE WHEN (COUNT (MIT_ID))>0 THEN 1 ELSE 0 END FROM COMPANY_INSTRUMENT_MAPPING WHERE MIT_ID  in (3,4) )
	*/

	 IF EXISTS((select 1 from DeferredCashGrant where EmployeeId NOT IN(select EmployeeId from GrantOptions) AND EmployeeId = @UserID GROUP BY EmployeeId))
        BEGIN
         UPDATE [MenuSubMenuUI_UX] set  IsActive = 0 WHERE UPPER(MenuName) IN('GRANTS','REPORTS','COMPANY DOCS','HELP & GLOSSARY')
        END
        ELSE
        BEGIN
         UPDATE [MenuSubMenuUI_UX] set  IsActive = 1 WHERE UPPER(MenuName) IN('GRANTS','REPORTS','COMPANY DOCS','HELP & GLOSSARY')
        END

		update  [MenuSubMenuUI_UX] set  IsActive=@ISDEMAT where Menu_id=(SELECT Menu_id FROM MenuSubMenuUI_UX WHERE UPPER(MenuName)='Demat Details')
		update  [MenuSubMenuUI_UX] set  IsActive=@ISBROKER where Menu_id=(SELECT Menu_id FROM MenuSubMenuUI_UX WHERE UPPER(MenuName)='Broker Details')
		update  [MenuSubMenuUI_UX] set  IsActive= 1 where Menu_id=(SELECT Menu_id FROM MenuSubMenuUI_UX WHERE UPPER(MenuName)='DEFERRED CASH PLAN') AND @UserID IN(SELECT EmployeeId FROM DeferredCashGrant)
		update  [MenuSubMenuUI_UX] set  IsActive=0 where Menu_id=(SELECT Menu_id FROM MenuSubMenuUI_UX WHERE UPPER(MenuName)='DEFERRED CASH PLAN') AND @UserID NOT IN(SELECT EmployeeId FROM DeferredCashGrant)
		
	
	SELECT [Menu_id]
      ,[Submenu_id]
      ,[MenuName]
      ,[DisplayName]
      ,[MenuUrl]
      ,[MenuSequence]
      ,[IsActive]
      ,[UserTypeId]
      ,[Position]
      ,[IsShownOnDashboard]
      ,[root]
      ,[icon]
      ,[bullet]
	 
    FROM [dbo].[MenuSubMenuUI_UX] M1
	WHERE UserTypeId = @UserTypeId and IsActive = 1 AND((@Auto_ExerciseCount=0 AND M1.Menu_id NOT IN(@MenuID)) OR @Auto_ExerciseCount>0 ) 
	AND M1.Menu_id NOT IN(@EGRANTS_ENABLED_MENU) 
	order by   [Submenu_id],MenuSequence asc


END
GO
