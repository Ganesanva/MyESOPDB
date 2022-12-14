/****** Object:  StoredProcedure [dbo].[PROC_EXERCISE_MENU_ENABLEDISENABLE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_EXERCISE_MENU_ENABLEDISENABLE]
GO
/****** Object:  StoredProcedure [dbo].[PROC_EXERCISE_MENU_ENABLEDISENABLE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_EXERCISE_MENU_ENABLEDISENABLE] 

	@Name NVARCHAR(100),
	@IsChecked  bit
AS
BEGIN
	IF(@IsChecked = 1)
		BEGIN
		   UPDATE EmployeeRoleMaster SET ViewOnDashboard = 1 WHERE [Name] = @Name     
		END
	ELSE
		BEGIN
		   UPDATE EmployeeRoleMaster SET ViewOnDashboard = 0 WHERE [Name] = @Name  
		END 
END
GO
