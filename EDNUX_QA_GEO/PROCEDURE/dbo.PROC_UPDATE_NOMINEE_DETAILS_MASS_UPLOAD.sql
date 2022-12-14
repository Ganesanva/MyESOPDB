/****** Object:  StoredProcedure [dbo].[PROC_UPDATE_NOMINEE_DETAILS_MASS_UPLOAD]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UPDATE_NOMINEE_DETAILS_MASS_UPLOAD]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UPDATE_NOMINEE_DETAILS_MASS_UPLOAD]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_UPDATE_NOMINEE_DETAILS_MASS_UPLOAD]
	@UserID NVARCHAR(100),
	@tblDetails dbo.TYPE_NOMINEE_DETAILS_APPROVAL READONLY
AS  
BEGIN
	
	SET NOCOUNT ON

	DECLARE @ACC_STATUS INT
	DECLARE @TOTAL_ROWCOUNT INT=0

	CREATE TABLE #TEMP_NOMINATION
	(
		UserID				NVARCHAR(100),
	    DateofApproval      NVARCHAR(100)
	)

	CREATE TABLE #TEMP_INVALIDDATA
	(
	    UserID				NVARCHAR(100),
	    DateofApproval      NVARCHAR(100),
		REMARK            NVARCHAR(200)
	)

	INSERT INTO #TEMP_NOMINATION(UserID,DateofApproval)
	SELECT EmployeeID,DateofApproval FROM @tblDetails WHERE CONVERT(datetime,DateofApproval)<GETDATE()


	INSERT INTO #TEMP_INVALIDDATA(UserID,DateofApproval,REMARK)
	SELECT EmployeeID,DateofApproval,'Approval date should less then or equal to  todays date' FROM @tblDetails WHERE CONVERT(datetime,DateofApproval)>=GETDATE()

	IF EXISTS (SELECT UserID  FROM #TEMP_NOMINATION)
	BEGIN
	UPDATE 
				NomineeDetails 
			SET               			
				ApprovalStatus = 'A',
				DateOfSubmissionOfForm= TEMP.DateofApproval,
				UPDATED_BY = @UserID,
				UPDATED_ON = GETDATE()												
			FROM 
				NomineeDetails 
				INNER JOIN #TEMP_NOMINATION AS TEMP ON NomineeDetails.UserID = TEMP.UserID
	END

     IF EXISTS (SELECT UserID  FROM #TEMP_INVALIDDATA)
	 BEGIN
			SELECT DISTINCT UserID,DateofApproval,REMARK FROM #TEMP_INVALIDDATA
	 END
	 ELSE
	 BEGIN
			SELECT '1' AS 'UserID', '' AS 'DateofApproval', 'SUCCESS' AS 'REMARK' 
	        
	 END
	
	        
	
	SET NOCOUNT OFF;	
	DROP TABLE #TEMP_NOMINATION
	DROP TABLE #TEMP_INVALIDDATA
END
GO
