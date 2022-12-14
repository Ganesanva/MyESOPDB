/****** Object:  StoredProcedure [dbo].[PROC_BLOCK_USER]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_BLOCK_USER]
GO
/****** Object:  StoredProcedure [dbo].[PROC_BLOCK_USER]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_BLOCK_USER]
	@USER_ID VARCHAR(100) = NULL,
	@STATUS VARCHAR(1) = NULL
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @USERID VARCHAR(100), @USER_NAME VARCHAR(1000), @USER_TYPE VARCHAR(500), @IS_USER_LOCKED VARCHAR(1), 
			@FORCE_PWD_CHANGE VARCHAR(1), @INSIDER VARCHAR(1),
			@ERROR_MESSAGE VARCHAR(1000), @MAX_LOGIN_HIT_SET INT, @MAX_LOGIN_HIT_USER INT 

	SELECT 
		@USERID = UM.UserId, @USER_NAME = UM.UserName, @USER_TYPE = UT.UserTypeName, @IS_USER_LOCKED = UM.IsUserLocked, 
		@FORCE_PWD_CHANGE = UM.ForcePwdChange, @INSIDER = ISNULL(EM.Insider,'N'), @MAX_LOGIN_HIT_USER = InvalidLoginAttempt
	FROM UserMaster AS UM
	INNER JOIN UserPassword AS UP ON UM.UserId = UP.UserId 
	INNER JOIN RoleMaster AS RM ON UM.RoleId = RM.RoleId 
	INNER JOIN UserType AS UT ON RM.UserTypeId = UT.UserTypeId 
	LEFT OUTER JOIN EmployeeMaster EM on EM.LoginID = UM.UserId AND EM.Deleted = '0' 
	WHERE (UM.UserId = @USER_ID) AND (UM.IsUserActive = 'Y') 
		
	/* GET MAX LOGIN HIT */
	
	SELECT @MAX_LOGIN_HIT_SET = maxLoginAttempts FROM CompanyMaster
	
	/* 
		PRINT '@USERID : '+ @USERID
		PRINT '@USER_NAME : '+ @USER_NAME
		PRINT '@USER_TYPE : '+ @USER_TYPE
		PRINT '@IS_USER_LOCKED : '+ @IS_USER_LOCKED
		PRINT '@FORCE_PWD_CHANGE : '+ @FORCE_PWD_CHANGE
		PRINT '@INSIDER : '+ @INSIDER		
		PRINT '@MAX_LOGIN_HIT_SET : '+ CONVERT(VARCHAR(10), @MAX_LOGIN_HIT_SET)
	*/
	
	BEGIN TRY
			
		IF((LEN(@USERID) > 0) AND (@STATUS = 0) AND (@MAX_LOGIN_HIT_SET > @MAX_LOGIN_HIT_USER))
			BEGIN
			
				/* GET COMPANY LEVEL DETAILS */	
				SELECT 'S' AS [STATUS], 'SUCCESS' AS [MESSAGE]
				
				/*
					IF SUCCESSFUL LOING UPDATE LOGIN ATTEMPTED ZERO
				*/
				
				UPDATE UserMaster SET InvalidLoginAttempt = 0 WHERE (UserId = @USERID)
									
			END
		ELSE
			BEGIN
				
				/* 
					INCREMENT INVALID LOGIN ATTEMPTS
					PRINT 'INCREMENT INVALID LOGIN ATTEMPTS' 
				*/
				 
				UPDATE UserMaster SET InvalidLoginAttempt = InvalidLoginAttempt + 1 WHERE (UserId = @USER_ID)
				
				/* 
					LOCK USER IF INVALID ATTTEMPS ARE CROSS THE LIMIT				
					PRINT 'LOCK USER IF INVALID ATTTEMPS ARE CROSS THE LIMIT'
				*/	
				
				DECLARE @MAX_LOGIN_ATTEMPTS INT 
				SELECT @MAX_LOGIN_ATTEMPTS = maxLoginAttempts FROM CompanyMaster
				
				UPDATE UserMaster SET IsUserLocked = 'Y' WHERE (UserId = @USER_ID) AND (InvalidLoginAttempt >= @MAX_LOGIN_ATTEMPTS)					
				
				SELECT  
					@MAX_LOGIN_HIT_USER = InvalidLoginAttempt
				FROM UserMaster AS UM
				INNER JOIN UserPassword AS UP ON UM.UserId = UP.UserId 
				INNER JOIN RoleMaster AS RM ON UM.RoleId = RM.RoleId 
				INNER JOIN UserType AS UT ON RM.UserTypeId = UT.UserTypeId 
				LEFT OUTER JOIN EmployeeMaster EM on EM.LoginID = UM.UserId AND EM.Deleted = '0' 
				WHERE (UM.UserId = @USER_ID)
				
				PRINT '@MAX_LOGIN_HIT_USER : '+ CONVERT(VARCHAR(10), @MAX_LOGIN_HIT_USER)
				
				IF ((@IS_USER_LOCKED = 'Y') AND (@MAX_LOGIN_HIT_SET <= @MAX_LOGIN_HIT_USER))
					BEGIN
						SELECT 'F' AS [STATUS], 'User is locked.<br/> Your login attempts are exceeded. <br/>Please reset your password.' AS [MESSAGE]
					END
				ELSE
					BEGIN
						SELECT 'F' AS [STATUS], 'You have made '+CONVERT(VARCHAR(1),@MAX_LOGIN_HIT_USER)+' unsuccessful attempt(s). The maximum retry attempts allowed for login are '+CONVERT(VARCHAR(10), @MAX_LOGIN_HIT_SET)+'.' AS [MESSAGE], CONVERT(VARCHAR(1), @MAX_LOGIN_HIT_USER) AS FailedAttempt , CONVERT(VARCHAR(10), @MAX_LOGIN_HIT_SET) AS MaxLoginAttempt
					END
			END		
			
	END TRY
	BEGIN CATCH
		
	END CATCH
		
	SET NOCOUNT OFF;  
   
END  
GO
