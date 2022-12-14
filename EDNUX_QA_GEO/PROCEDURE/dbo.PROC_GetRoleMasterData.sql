/****** Object:  StoredProcedure [dbo].[PROC_GetRoleMasterData]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetRoleMasterData]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetRoleMasterData]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetRoleMasterData]    
	@RoleId VARCHAR(300)
AS 
BEGIN  
	SET NOCOUNT ON;  
	SELECT Name, Description FROM RoleMaster WHERE (UserTypeId = 2) AND (Name = @RoleId)
END    
GO
