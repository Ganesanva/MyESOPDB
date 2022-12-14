/****** Object:  StoredProcedure [dbo].[PROC_DEMAT_VALIDATION_MAIL_CR]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_DEMAT_VALIDATION_MAIL_CR]
GO
/****** Object:  StoredProcedure [dbo].[PROC_DEMAT_VALIDATION_MAIL_CR]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_DEMAT_VALIDATION_MAIL_CR]
(
	@EmployeeId VARCHAR(50) = NULL	
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @RecordCount INT, @CR_EMAILID NVARCHAR(MAX), @MailBody NVARCHAR(MAX), @COMPANY_EMAIL_ID NVARCHAR(50),
			@MailBodyHTMLTable NVARCHAR(MAX),@MailSubject NVARCHAR(500), @UpdatedOn datetime,@MaxMsgId BIGINT, @CC_TO NVARCHAR(100),
			@IsDematValidation bit, @IsRemainderMail bit, @FrequencyInDays NVARCHAR(20), @SendIntimationMailId NVARCHAR(MAX),
			@CountData int, @EMPID NVARCHAR(100), @EMPNAME NVARCHAR(100) , @EmpDetails NVARCHAR(MAX), @ResultData NVARCHAR(MAX)
			
	SELECT @IsDematValidation = IsDematValidation, @IsRemainderMail= IsRemainderMail, @FrequencyInDays =FrequencyInDays, @SendIntimationMailId = SendIntimation 
	FROM DematConfiguration
	
	IF(@IsDematValidation = 1 AND @IsRemainderMail = 1 AND @FrequencyInDays > 0 AND ISNULL(@SendIntimationMailId,'') <>'')
	BEGIN	     

		  SELECT @MailSubject = MailSubject, @MailBody = MailBody FROM MailMessages WHERE UPPER(Formats) = 'DEMATVALIDATIONALERTTOCRFORAPPROVAL'		  
		  SELECT @COMPANY_EMAIL_ID = CompanyEmailID FROM CompanyParameters
		  SELECT @CountData = count(distinct EmployeeId) from  Employee_UserDematDetails WHERE ApproveStatus='P' AND IsActive = 1 AND DATEDIFF(DAY, UPDATED_ON, GETDATE()) > @FrequencyInDays
		  
		  SET @EmpDetails = '<p>Employee Id / No.: {1} </p> <p>Employee name: {2}</p>'

		  CREATE TABLE #TEMP_EMPLIST (SrNo INT, EmpId VARCHAR(20), EmpName VARCHAR(50))
		  INSERT INTO #TEMP_EMPLIST (SrNo, EmpId, EmpName)
		  SELECT DISTINCT DENSE_RANK() OVER (ORDER BY EM.EmployeeId ASC), EM.EmployeeId, EM.EmployeeName
          FROM EMPLOYEEMASTER EM INNER JOIN Employee_UserDematDetails EUD ON EM.EmployeeID = EUD.EmployeeID 
          WHERE EM.deleted = 0 AND ApproveStatus='P' AND EUD.IsActive = 1 AND DATEDIFF(DAY, EUD.UPDATED_ON, GETDATE()) > @FrequencyInDays

		  -- Employee Details for apporval
		  WHILE @CountData > 0
		  BEGIN   
		     SELECT @EMPID = EmpId, @EMPNAME = EmpName FROM #TEMP_EMPLIST where SrNo = (@CountData)   
		     SET @ResultData =  REPLACE(REPLACE(@EmpDetails,'{1}',@EMPID), '{2}',@EMPNAME) 
		     print @ResultData
		     SET @CountData = @CountData - 1;
		  END

		  -- Insert into MailerDB
		  SET @MaxMsgId = (SELECT ISNULL(MAX(MessageID),0) + 1 AS MessageID FROM MailerDB..MailSpool)
		  select * from [MailerDB].[dbo].[MailSpool]
		  INSERT INTO [MailerDB].[dbo].[MailSpool]
				([MessageID], [From], [To], [Subject], [Description],  [Cc], [enablereadreceipt], [deliveryNotify], [Bcc], [FailureSendMailAttempt], [CreatedOn])
				SELECT @MaxMsgId, @COMPANY_EMAIL_ID, @SendIntimationMailId, @MailSubject, REPLACE(@MailBody,'{0}',@ResultData) , @CC_TO, 'N', 'N', @COMPANY_EMAIL_ID, NULL, GETDATE() 
				WHERE (LEN(@MailSubject)>0) AND (LEN(@SendIntimationMailId)>0) AND (LEN(@COMPANY_EMAIL_ID) > 0)
	
	      DROP TABLE #TEMP_EMPLIST
	END

	SET NOCOUNT OFF
END
GO
