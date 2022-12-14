/****** Object:  StoredProcedure [dbo].[PROC_RESETPWD]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_RESETPWD]
GO
/****** Object:  StoredProcedure [dbo].[PROC_RESETPWD]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[PROC_RESETPWD]
(
	@TYPE			NVARCHAR(30) =NULL,	
	@COMPANY_ID 	NVARCHAR(30) =NULL,	
	@USER_ID		NVARCHAR(20) =NULL,
	@USER_NAME		NVARCHAR(75) =NULL,
	@USER_PASSWORD	NVARCHAR(1000) =NULL,
	@EMAIL_ID		NVARCHAR(100)=NULL,
	@NEW_PASSWORD   NVARCHAR(1000)=NULL,
	@MAIL_DESCRIPTION	NVARCHAR(4000)=NULL,
	@MAIL_DELIVERED CHAR =NULL, 
	@RESULT			INT OUTPUT 
)	
AS
BEGIN
	DECLARE @MAILFORMAT		NVARCHAR(4000)=NULL
	SET NOCOUNT ON;		
	SET @RESULT = 0
		IF(@TYPE='IS_COMAPNY_EXIST')
		BEGIN
			SELECT NAME FROM SYS.DATABASES WHERE  NAME<>'MASTER' AND NAME = @COMPANY_ID
		END	
		
		IF(@TYPE='IS_USER_EXIST')
		BEGIN
			SELECT UserId, UserName, EmployeeId, RoleId, Grade, Department, Address, PhoneNo, EmailId, DateofJoining, ShowPopUps, ForcePwdChange,
				   InvalidLoginAttempt, LockedDate, IsUserLocked, IsUserActive, LastUpdatedBy, LastUpdatedOn, ISFUNDINGCCR 
			FROM   USERMASTER 
			WHERE  USERID = @USER_ID
		END	
		
		IF(@TYPE='GET_USER_EMP_INFO')
		BEGIN
			SELECT	UM.ROLEID AS ROLEID, UM.USERID AS USERID, EM.EMPLOYEEID AS EMPLOYEEID, 
					EM.LOGINID AS LOGINID, EM.EMPLOYEENAME AS EMPLOYEENAME,	EM.EMPLOYEENAME, 
					UM.EMAILID 
			FROM EMPLOYEEMASTER AS EM 
				LEFT JOIN  USERMASTER AS UM 
					ON EM.EMPLOYEEID =  UM.EMPLOYEEID  
			WHERE	UM.USERID = @USER_ID 
				AND UM.EMAILID=@EMAIL_ID 
				AND ISNULL(EM.CONFSTATUS,'') <>'N'
		END		
		
		IF(@TYPE='GET_USERVESTEDOPTIONS')
		BEGIN
			SELECT	SUM(GL.UNAPPROVEDEXERCISEQUANTITY) AS UNAPRQNT, 
					SUM(GL.EXERCISABLEQUANTITY) AS QNT, EM.DATEOFTERMINATION 
			FROM	GRANTLEG  AS GL 
					INNER JOIN GRANTOPTIONS AS GOP ON GL.GRANTOPTIONID = GOP.GRANTOPTIONID 
					INNER JOIN USERMASTER AS UM ON GOP.EMPLOYEEID = UM.EMPLOYEEID
					INNER JOIN EMPLOYEEMASTER AS EM ON EM.EMPLOYEEID = UM.EMPLOYEEID
			WHERE	UM.USERID = @USER_ID GROUP BY EM.DATEOFTERMINATION
		END
		
		IF(@TYPE='GET_RECIEVEREMAIL')
		BEGIN
		SELECT COMPANYEMAILID, SMPTSERVERIP, SMPTSERVERPORT FROM COMPANYMASTER
		END
		
		IF(@TYPE='GET_USER_EMAILID')
		BEGIN
			SELECT EMAILID FROM USERMASTER WHERE USERID = @USER_ID
		END
		
		IF(@TYPE='UPDATE_NEWPASSWORD')
		BEGIN
			BEGIN TRY
					
					UPDATE UserPassword SET UserPassword = @NEW_PASSWORD, LastUpdatedBy = @USER_ID, LastUpdatedOn = Getdate() WHERE UserId = @USER_ID
					DELETE FROM UserSecurityQuestion WHERE UserId = @USER_ID	
					
					SET @RESULT = 1
			END TRY
			BEGIN CATCH
					SET @RESULT = 0
			END CATCH
		END
		
		IF(@TYPE='UPDATE_USERACTIVEFLAG')
		BEGIN
			BEGIN TRY
				UPDATE UserMaster  SET IsUserActive='Y', InvalidLoginAttempt=0, IsUserLocked='N', ForcePwdChange='Y' WHERE UserId = @USER_ID
				SET @RESULT = 1
			END TRY
			BEGIN CATCH
					SET @RESULT = 0
			END CATCH
		END
		
		IF(@TYPE='GET_MAIL_FORMAT')
		BEGIN
			SET @MAILFORMAT = '
			<html>
				<body>
					<font face="Calibri" size="3">
						<p>Dear '+@USER_NAME+',</p>
						<p>We wish to inform you that you can access your ESOP related data @ 
						<a title="www.myesops.com" href="http://www.myesops.com">http://www.myesops.com</a> (Alternate Link:
						<a title="https://www.esopdirect.com/MyESOP/Login.aspx" href="https://www.esopdirect.com/MyESOP/Login.aspx">https://www.esopdirect.com/MyESOP/Login.aspx</a>)
						</p> 
						<p>Your login details have been reset.</p>
						<p>Your personalized login details are as follows:</p>

						<p><b>User ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </b>:   '+@USER_ID+'<br />
						<b>Password&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </b>: '+@USER_PASSWORD+' <br />
						<b>Company ID</b>&nbsp;&nbsp;&nbsp; :  '+@COMPANY_ID+' </p>
						<p><b>Please note that the User Id and Password are case sensitive.</b></p>
						<p>We recommend you to change your password immediately after first login for security reasons.</p>
						<p>Regards,<br/>
						ESOP Direct Team</p>
						<br/>						
					</font>
				</body>
			</html>'
			
			SELECT @MAILFORMAT AS MAILFORMAT
		END

	IF(@TYPE='GET_MAIL_FORMAT')
	BEGIN
		BEGIN TRY
				INSERT INTO MailerDB..ResetPasswordEmails 		
					VALUES(@COMPANY_ID, @EMAIL_ID, @USER_NAME, @USER_ID, @COMPANY_ID, null, null, 'Reset Password', @MAIL_DESCRIPTION, GETDATE(), @MAIL_DELIVERED)	
					SET @RESULT = 1
		END TRY
		BEGIN CATCH
					SET @RESULT = 0
		END CATCH		
	END	
	SET NOCOUNT OFF;		
END

 
GO
