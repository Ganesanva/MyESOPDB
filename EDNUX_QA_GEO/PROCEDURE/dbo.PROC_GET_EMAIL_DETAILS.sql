/****** Object:  StoredProcedure [dbo].[PROC_GET_EMAIL_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_EMAIL_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_EMAIL_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_EMAIL_DETAILS]
	@Action VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF(@Action = 'GetCRMailList')
	
		BEGIN
			SELECT UM.UserName, UM.EmailId FROM UserMaster AS UM
			INNER JOIN RoleMaster AS RM ON UM.RoleId = RM.RoleId
			WHERE RM.UserTypeId = 2 AND UM.IsUserActive = 'Y'
		END
		
	
	ELSE IF(@Action = 'GetFromMail')
	BEGIN
		SELECT CompanyEmailID AS MailFrom FROM CompanyParameters
	END
	
	SET NOCOUNT OFF;
END
GO
