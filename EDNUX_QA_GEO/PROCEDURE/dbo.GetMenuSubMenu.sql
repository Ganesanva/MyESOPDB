/****** Object:  StoredProcedure [dbo].[GetMenuSubMenu]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetMenuSubMenu]
GO
/****** Object:  StoredProcedure [dbo].[GetMenuSubMenu]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetMenuSubMenu]	
	@UserTypeId		INT,
	@UserID VARCHAR(50)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @Home NVARCHAR(300)
	DECLARE @UserName NVARCHAR(100)
	DECLARE @CompanyName NVARCHAR(300)
	DECLARE @Auto_ExerciseCount INT
	DECLARE @MenuID INT
	DECLARE @IS_EGRANTS_ENABLED AS CHAR(1)

	CREATE TABLE #TEMPGROUP (
		ID INT IDENTITY(1,1) NOT NULL,
		[Menu_id] int,
		[Submenu_id] int,
		[MenuName] varchar(200),
		[DisplayName] varchar(200),
		[MenuUrl] varchar(1000),
		[MenuSequence] int,
		[IsActive] int,
		[UserTypeId] int,
		[Position] VARCHAR(50)
	  )
	CREATE TABLE #TEMPC (
		ID INT IDENTITY(1,1) NOT NULL,
		CompanyID varchar(200)
	  )

	SET @Home='<a href="../Dashboard/EmployeeDashboard.aspx">Home</a>'

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
	WHERE GOP.EmployeeId  = @UserID
	--AND ISNULL(SCH.IS_AUTO_EXERCISE_ALLOWED,0) <> 1
	AND ISNULL(IS_AUTO_EXERCISE_ALLOWED, 0) = (CASE WHEN ISNULL((SELECT IS_ALLOW_AFTER_MODIFY FROM AUTO_EXERCISE_PAYMENT_CONFIG AS AEDM  WHERE AEDM.SCHEME_ID = Sch.SchemeId),0)>0 THEN 1 ELSE 0 END) 

	SELECT @MenuID=Menu_id FROM MenuSubMenu WHERE UPPER(MenuName)='EXERCISE NOW'

	SET @IS_EGRANTS_ENABLED = (SELECT IS_EGRANTS_ENABLED FROM CompanyMaster)

	DECLARE @EGRANTS_ENABLED_MENU INT
	
	IF EXISTS(SELECT Menu_id FROM MenuSubMenu WHERE UPPER(MenuName)='E-GRANTS' AND @IS_EGRANTS_ENABLED = 0)
	BEGIN
		 SELECT @EGRANTS_ENABLED_MENU=Menu_id FROM MenuSubMenu WHERE UPPER(MenuName)='E-GRANTS'
	END
	ELSE
	BEGIN
		 SET @EGRANTS_ENABLED_MENU=0
	END

	--START -> Get Group Companies
	DECLARE @MinIdt			INT,
			@MaxIdt			INT,
			@IndCompanyId	VARCHAR(100),
			@SqlString		NVARCHAR(2000),
			@UserCnt		INT
	DECLARE @CompanyID VARCHAR(100)
	DECLARE @Group_Enabled_Menu INT
	DECLARE @Groupcode INT
	DECLARE @MENU_URL VARCHAR(1000)

	SELECT @CompanyID = CompanyID FROM CompanyMaster

	--- Getting groupcode form GroupCompanies
	SELECT @Groupcode = GroupCode FROM ESOPManager..GroupCompanies WHERE CompanyID = @CompanyID

	---- insert the group companies in the temp table 	
	INSERT INTO #TEMPC (CompanyId)
	SELECT distinct CompanyID FROM ESOPManager..GroupCompanies WHERE Groupcode = @Groupcode AND CompanyID <> @CompanyID
	
	---- check if user exists in database, if yes insert to output in temp table 
	SELECT @MinIdt = MIN(ID), @MaxIdt = MAX(ID) FROM #TEMPC
	WHILE @MinIdt <= @MaxIdt
	BEGIN
		SELECT @IndCompanyId = CompanyId FROM #TEMPC WHERE ID = @MinIdt
		SET @MENU_URL = '../Employee/GroupCompany.aspx?CompanyID='+@IndCompanyId+''

		SELECT @SqlString=N'SELECT @UserCnt=count(*) FROM ' + @IndCompanyId + '..usermaster where (isuseractive = ''Y'' AND IsUserLocked=''N'') and userid = ' + CHAR(39) + @UserId + CHAR(39)
		EXEC sp_executesql @SqlString, N'@UserCnt varchar(max) output', @UserCnt output

		IF @UserCnt > 0
		BEGIN	
			INSERT INTO #TEMPGROUP(Menu_id, Submenu_id, MenuName, DisplayName, MenuUrl, MenuSequence, IsActive, UserTypeId, Position) 
			SELECT Menu_id + @MinIdt, Menu_id, @IndCompanyId, @IndCompanyId, @MENU_URL, @MinIdt, IsActive, UserTypeId, Position 
			FROM MenuSubMenu
			WHERE UPPER(MenuName) = 'Group Company'
		END
		SET @MinIdt = @MinIdt + 1
	END
	
	IF EXISTS(SELECT Menu_id FROM MenuSubMenu WHERE UPPER(MenuName) = 'Group Company' AND (@UserCnt = 0 OR @UserCnt IS NULL OR @UserCnt = ''))
	BEGIN
		 SELECT @Group_Enabled_Menu = Menu_id FROM MenuSubMenu WHERE UPPER(MenuName)='Group Company'
	END
	ELSE
	BEGIN
		 SET @Group_Enabled_Menu = 0
	END
	-- END -> Group Companies

	SELECT [Menu_id]
      ,[Submenu_id]
      ,[MenuName]
      ,[DisplayName]
      ,[MenuUrl]
      ,[MenuSequence]
      ,[IsActive]
      ,[UserTypeId]
	  ,[Position],
	  (
		SELECT TOP 1 
		CASE --WHEN M2.Menu_id=1 THEN 'Welcome '+ @UserName +' to '+@CompanyName
			 WHEN M2.Submenu_id=0 THEN @Home+' >> '+M2.DisplayName
			 WHEN M2.Submenu_id>0 THEN @Home+' >> '+(SELECT TOP 1 M3.DisplayName FROM MenuSubMenu M3 WHERE M3.Menu_id=M2.Submenu_id) +' >> ' +M1.DisplayName  END 
		FROM MenuSubMenu M2 WHERE M2.Menu_id=M1.Menu_id
	  ) AS BreadCrumbText
    FROM [dbo].[MenuSubMenu] M1
	WHERE UserTypeId = @UserTypeId and IsActive = 1 AND((@Auto_ExerciseCount=0 AND M1.Menu_id NOT IN(@MenuID)) OR @Auto_ExerciseCount>0 ) 
	AND M1.Menu_id NOT IN(@EGRANTS_ENABLED_MENU)
	AND  (M1.Menu_id NOT IN(@Group_Enabled_Menu))
	UNION
	SELECT Menu_id, Submenu_id, MenuName, DisplayName, MenuUrl, MenuSequence, IsActive, UserTypeId, Position, null 
	FROM #TEMPGROUP
	ORDER BY MenuSequence
	
END
GO
