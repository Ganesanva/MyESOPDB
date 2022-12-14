/****** Object:  StoredProcedure [dbo].[PROC_GET_USER_LIST]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_USER_LIST]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_USER_LIST]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_USER_LIST]
( 
		@USER_TYPE NVarChar(50) = NULL		
)
AS
BEGIN
	 SET NOCOUNT ON;
		IF(UPPER(@USER_TYPE) = 'ADMIN')
		BEGIN
				SELECT * FROM UserMaster  WHERE UPPER(RoleId) <> 'ADMIN' and IsUserActive ='Y' order by UserId
		END
		IF(UPPER(@USER_TYPE) = 'CR')
		BEGIN
				SELECT * FROM UserMaster WHERE UPPER(RoleId) = 'EMPLOYEE' and IsUserActive ='Y' order by UserId
		END
	 SET NOCOUNT OFF;	
END
GO
