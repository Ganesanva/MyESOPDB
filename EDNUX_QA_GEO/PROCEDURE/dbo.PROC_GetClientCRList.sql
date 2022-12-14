/****** Object:  StoredProcedure [dbo].[PROC_GetClientCRList]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetClientCRList]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetClientCRList]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[PROC_GetClientCRList]
AS
BEGIN
	SET NOCOUNT ON
		SELECT  UserId, UserName, PhoneNo, EmailId FROM UserMaster WHERE UPPER(RoleId) NOT IN ('EMPLOYEE', 'ADMIN') And IsUserActive='Y'
	SET NOCOUNT OFF
END
GO
