/****** Object:  StoredProcedure [dbo].[PROC_UPDATE_GRANT_ACC_MASS_UPLOAD]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UPDATE_GRANT_ACC_MASS_UPLOAD]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UPDATE_GRANT_ACC_MASS_UPLOAD]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_UPDATE_GRANT_ACC_MASS_UPLOAD]
	@LoginUserID VARCHAR(50),
	@CompanyID VARCHAR(50),
	@tblDetails dbo.OGA_TYPE_LAST_ACC_DATE_STATUS READONLY
AS  
BEGIN
	
	SET NOCOUNT ON

	DECLARE @ACC_STATUS INT
	DECLARE @TOTAL_ROWCOUNT INT=0

	CREATE TABLE #TEMP_USR_ERROR_MESSAGES
	(
		ERROR_ID			INT IDENTITY(1,1) not null,
		LETTER_CODE         NVARCHAR(100),
	    [ERROR_MESSAGE]     NVARCHAR(100),
	)

	--FIRST ERROR CONDITION 
	INSERT INTO #TEMP_USR_ERROR_MESSAGES 
	(
		LETTER_CODE, [ERROR_MESSAGE]
	)
	SELECT 
		LetterCode, 'Employee ID should not be null.' 
	FROM 
		@tblDetails
	WHERE  
		(LEN(ISNULL(EMPLOYEE_ID, '')) = 0) 
									

	--2nd ERROR CONDITION 
	INSERT INTO #TEMP_USR_ERROR_MESSAGES  
	(
		LETTER_CODE, [ERROR_MESSAGE]
    )                                
	SELECT 
		LetterCode, 'Letter Code should not be null.'  
	FROM  
		@tblDetails
	WHERE 
		(LEN(ISNULL(LETTERCODE, '')) = 0) 
								

	--3rd ERROR CONDITION 
	INSERT INTO #TEMP_USR_ERROR_MESSAGES 
	(
		LETTER_CODE, [ERROR_MESSAGE]
    )
    SELECT 
		LetterCode, 'Status should not be null.'  
	FROM 
		@tblDetails
	WHERE  
		(LEN(ISNULL([STATUS], '')) = 0)
	

	--4th ERROR CONDITION 
	INSERT INTO #TEMP_USR_ERROR_MESSAGES 
	(
		LETTER_CODE, [ERROR_MESSAGE]
    )                                 
	SELECT 
		LetterCode,'Last Acceptance date  should not be null.'  
	FROM 
		@tblDetails
	WHERE 
		(LEN(ISNULL(LASTACCTDATE, '')) = 0)
								 
	
	--5th ERROR CONDITION     
	INSERT INTO #TEMP_USR_ERROR_MESSAGES 
	(
		LETTER_CODE, [ERROR_MESSAGE]
    )                                  
	SELECT 
		LetterCode,'Incorrect Data Please Check Status A and R , Date of action should  not null.'  
	FROM 
		@tblDetails
	WHERE 
		(STATUS IN ('A','R')) AND (LEN(ISNULL(DATEOFACTION, '')) = 0) 
								 

	--6th ERROR CONDITION 
    INSERT INTO #TEMP_USR_ERROR_MESSAGES 
	(
		LETTER_CODE, [ERROR_MESSAGE]
    )                                  
	SELECT  
		TEMP.LETTERCODE, 'Record Not Match'  
	FROM  
		@tblDetails AS TEMP  
		INNER JOIN GrantAccMassUpload ON GrantAccMassUpload.EmployeeID = TEMP.EMPLOYEE_ID 
	WHERE (GrantAccMassUpload.LetterCode = TEMP.LETTERCODE ) AND ([STATUS] NOT IN ('A','R','N','P'))
								 
    
	--7 th ERROR CONDITION 
	 INSERT INTO #TEMP_USR_ERROR_MESSAGES 
	 (
	     LETTER_CODE,[ERROR_MESSAGE]
     )
     SELECT 
		 TEMP.LETTERCODE,'Last Acceptance Date must be greater then Grant date.'  
	 FROM 
	     @tblDetails AS TEMP  
		INNER JOIN GrantAccMassUpload ON GrantAccMassUpload.EmployeeID = TEMP.EMPLOYEE_ID 
	  WHERE (GrantAccMassUpload.LetterCode = TEMP.LETTERCODE) AND  (GrantAccMassUpload.GrantDate > CAST(CAST(TEMP.LASTACCTDATE as date) AS datetime))


   -- 8 th ERROR CONDITION 
	 INSERT INTO #TEMP_USR_ERROR_MESSAGES 
	 (
	     LETTER_CODE,[ERROR_MESSAGE]
     )
     SELECT 
		 TEMP.LETTERCODE,'Letter Acceptance status must be P then only update Last Acceptance date '  
	 FROM 
	     @tblDetails AS TEMP  
		INNER JOIN GrantAccMassUpload ON GrantAccMassUpload.EmployeeID = TEMP.EMPLOYEE_ID 
	  WHERE (GrantAccMassUpload.LetterCode = TEMP.LETTERCODE) AND ((TEMP.STATUS IN('A','R')) AND ((GrantAccMassUpload.LastAcceptanceDate) != CONVERT(DATE,TEMP.LASTACCTDATE)))
	

	
	IF NOT EXISTS (SELECT ERROR_ID  FROM #TEMP_USR_ERROR_MESSAGES)
		BEGIN
			UPDATE 
				GrantAccMassUpload 
			SET               			
				LetterAcceptanceStatus = STATUS,
				LetterAcceptanceDate= 
				CASE
					WHEN TEMP.STATUS ='A' THEN CONVERT(DATE,TEMP.DATEOFACTION)
					WHEN TEMP.STATUS ='R' THEN CONVERT(DATE,TEMP.DATEOFACTION) 
					WHEN TEMP.STATUS ='P' THEN NULL
					WHEN TEMP.STATUS ='N' THEN NULL  
				ELSE
					NULL
				END,						
				LastAcceptanceDate = CONVERT(DATE,TEMP.LASTACCTDATE),
				LastUpdatedBy = @LoginUserID,
				LastUpdatedOn = GETDATE()												
			FROM 
				GrantAccMassUpload 
				INNER JOIN @tblDetails AS TEMP ON GrantAccMassUpload.EmployeeID = TEMP.EMPLOYEE_ID 
				AND GrantAccMassUpload.LetterCode = TEMP.LETTERCODE AND STATUS in ('A','R','N','P')
	
			SELECT '1' AS 'SR. NO.', '' AS 'LETTER CODE', 'SUCCESS' AS 'RESULT' 

		END
	ELSE
		BEGIN		
			SELECT ERROR_ID AS 'SR. NO.', LETTER_CODE AS 'LETTER CODE', [ERROR_MESSAGE] AS 'RESULT' FROM #TEMP_USR_ERROR_MESSAGES
		END
	
	SET NOCOUNT OFF;	
	
	DROP TABLE #TEMP_USR_ERROR_MESSAGES
END
GO
