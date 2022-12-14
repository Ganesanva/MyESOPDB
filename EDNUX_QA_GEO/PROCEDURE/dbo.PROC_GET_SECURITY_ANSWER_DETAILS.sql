/****** Object:  StoredProcedure [dbo].[PROC_GET_SECURITY_ANSWER_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_SECURITY_ANSWER_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_SECURITY_ANSWER_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_SECURITY_ANSWER_DETAILS]
	@LOGIN_ID VARCHAR(50) = NULL,
	@PARM VARCHAR(50) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	IF(UPPER(@PARM) = 'GET_ANSWERS_COUNT')
	BEGIN
		SELECT 
			COUNT(SQM.SecurityQuestionId)
		FROM SecurityQuestionMaster AS SQM
		INNER JOIN UserSecurityQuestion AS USQ ON USQ.SecurityQuestionId = SQM.SecurityQuestionId
		WHERE (USQ.UserId = @LOGIN_ID AND USQ.SecurityAnswer <> '') 
	END	
	ELSE IF(UPPER(@PARM) = 'GET_QUE_ANS_DETAILS')
	BEGIN
	
		CREATE TABLE #TEMP_SECURITY_QUESTION
		(
			TSQID INT NOT NULL,
			SECURITY_QUESTION VARCHAR(500) NOT NULL,
			SECURITY_ANSWER VARCHAR(500) NULL,
			IsAuthenticationModeSet BIT,
			AuthenticationModeID TINYINT
		)		
		
		INSERT INTO #TEMP_SECURITY_QUESTION (TSQID, SECURITY_QUESTION)
		SELECT SecurityQuestionId, Question FROM SecurityQuestionMaster
				
		UPDATE TSQ SET TSQ.SECURITY_ANSWER = USQ.SecurityAnswer, IsAuthenticationModeSet = USQ.IsAuthenticationModeSet , AuthenticationModeID = USQ.AuthenticationModeID
		FROM #TEMP_SECURITY_QUESTION AS TSQ
		INNER JOIN SecurityQuestionMaster AS SQM ON SQM.SecurityQuestionId = TSQ.TSQID
		INNER JOIN UserSecurityQuestion AS USQ ON USQ.SecurityQuestionId = SQM.SecurityQuestionId
		WHERE (USQ.UserId = @LOGIN_ID)		
		
		SELECT TSQID, SECURITY_QUESTION, SECURITY_ANSWER, IsAuthenticationModeSet, AuthenticationModeID FROM #TEMP_SECURITY_QUESTION ORDER BY TSQID ASC 		
	END
	ELSE IF(UPPER(@PARM) = 'GET_RANDOM_QUESTIONS')
	BEGIN
		SELECT SQM.*, USQ.*
		FROM 
			  SecurityQuestionMaster SQM INNER JOIN 
			  (SELECT TOP 2 SECURITYQUESTIONID FROM SecurityQuestionMaster ORDER BY NEWID()) SQM_INNER ON SQM_INNER.SECURITYQUESTIONID = SQM.SECURITYQUESTIONID
			  INNER JOIN UserSecurityQuestion USQ ON USQ.SECURITYQUESTIONID = SQM.SECURITYQUESTIONID
		WHERE USQ.USERID = @LOGIN_ID
	END
	ELSE IF(UPPER(@PARM) = 'GET_GOOGLE_AUTH')
	BEGIN
		SELECT 
			TOP 1 IsAuthenticationModeSet, AuthenticationModeID 		
		FROM 
			  UserSecurityQuestion USQ
		WHERE 
			USQ.USERID = @LOGIN_ID
	END
		
    ELSE IF(UPPER(@PARM) = 'GET_SECURITY_QUES_ANSWER')
	BEGIN
		SELECT SQM.Question, USQ.SecurityAnswer 
		FROM UserSecurityQuestion as USQ
		INNER JOIN SecurityQuestionMaster AS SQM 
		ON USQ.SecurityQuestionId = SQM.SecurityQuestionId
		WHERE USQ.UserId = (SELECT UserId FROM UserMaster  WHERE UPPER(RoleId) <> 'ADMIN' and IsUserActive ='Y' and UserId = @LOGIN_ID)
	END

	SET NOCOUNT OFF;	
END
GO
