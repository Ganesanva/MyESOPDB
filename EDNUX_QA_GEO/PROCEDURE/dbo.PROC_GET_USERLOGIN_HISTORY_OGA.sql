/****** Object:  StoredProcedure [dbo].[PROC_GET_USERLOGIN_HISTORY_OGA]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_USERLOGIN_HISTORY_OGA]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_USERLOGIN_HISTORY_OGA]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_USERLOGIN_HISTORY_OGA]
	@LoginDateFrom AS DATE,
	@LoginDateTo AS DATE
AS  
BEGIN  
   
 SET NOCOUNT ON;  
	SELECT  
		UL.[UserId],
		UL.[LoginDate],  
		UL.[LogOutDate],  
		UL.[IP_ADDRESS]  
	FROM 
		UserLoginHistory UL
		INNER JOIN UserMaster UM ON UL.UserId = UM.UserId
		INNER JOIN RoleMaster RM ON RM.RoleId = UM.RoleId 
	WHERE 
		UL.ORGANIZATION = 'OGA'	
		AND RM.UserTypeId = 3 
		AND (CONVERT(DATE, [LoginDate]) >= CONVERT(DATE, @LoginDateFrom) AND CONVERT(DATE, [LoginDate]) <= CONVERT(DATE, @LoginDateTo))
 
 SET NOCOUNT OFF;   
END  
GO
