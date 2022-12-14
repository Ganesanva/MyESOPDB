/****** Object:  StoredProcedure [dbo].[PROC_CUDGoogleAuth]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CUDGoogleAuth]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CUDGoogleAuth]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_CUDGoogleAuth]
	@ACTION CHAR(1),
	@LOGIN_ID VARCHAR(50) = NULL,
	@IsAuthenticationModeSet INT,
	@AuthenticationModeID INT,
	@Result INT OUT
AS
BEGIN
	SET NOCOUNT ON;
	SET @Result = 0
	--@IsAuthenticationModeSet is not used as of now. However this might be required in future.
	IF(UPPER(@ACTION) = 'U')
	BEGIN
		IF NOT EXISTS(SELECT UserId FROM UserSecurityQuestion WHERE UserId = @LOGIN_ID)
		BEGIN
			INSERT INTO UserSecurityQuestion 
			SELECT @LOGIN_ID AS USERID, SecurityQuestionId, '', @IsAuthenticationModeSet, (SELECT AuthenticationModeID FROM CompanyMaster) FROM SecurityQuestionMaster
		END
		UPDATE 
			UserSecurityQuestion 
		SET 
			IsAuthenticationModeSet = @IsAuthenticationModeSet 
		WHERE 
			UserId = @LOGIN_ID
			
		SET @Result = 1
	END	
		
	RETURN @Result
	
	SET NOCOUNT OFF;	
END
GO
