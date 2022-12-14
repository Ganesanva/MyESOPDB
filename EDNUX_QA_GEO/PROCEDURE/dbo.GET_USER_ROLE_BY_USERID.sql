/****** Object:  StoredProcedure [dbo].[GET_USER_ROLE_BY_USERID]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GET_USER_ROLE_BY_USERID]
GO
/****** Object:  StoredProcedure [dbo].[GET_USER_ROLE_BY_USERID]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GET_USER_ROLE_BY_USERID]
	@UserType     INT,
	@UserId       VARCHAR(50)
	
AS  
BEGIN

	SET NOCOUNT ON
		
	SELECT 
		RM.Name 
	FROM 
		RoleMaster AS RM
		INNER JOIN UserType AS UT ON RM.UserTypeId = UT.UserTypeId 
		INNER JOIN UserMaster AS UM ON UM.RoleId=RM.RoleId 
	WHERE 
		(UT.UserTypeId = @UserType) AND (UM.UserId=@UserId)

	SET NOCOUNT OFF;	
END
GO
