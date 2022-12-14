/****** Object:  StoredProcedure [dbo].[GET_NOMNIEE_DETAILS_PENDINGFORAPPROVAL]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GET_NOMNIEE_DETAILS_PENDINGFORAPPROVAL]
GO
/****** Object:  StoredProcedure [dbo].[GET_NOMNIEE_DETAILS_PENDINGFORAPPROVAL]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GET_NOMNIEE_DETAILS_PENDINGFORAPPROVAL]

AS	   
BEGIN
	SET NOCOUNT ON;	
	         
	         
	BEGIN

	CREATE TABLE #TEMP_NOMINEE
	(		
		UserID				NVARCHAR(100),
	    PercentageOfShare   INT,
	)

	INSERT INTO #TEMP_NOMINEE(UserID,PercentageOfShare)

	SELECT NomineeDetails.UserId, SUM( Convert(int,NomineeDetails.PercentageOfShare)) AS PercentageOfShare FROM NomineeDetails GROUP BY NomineeDetails.UserId  HAVING SUM(Convert(int,NomineeDetails.PercentageOfShare))=100
	 
		SELECT EmployeeMaster.EmployeeID, EmployeeMaster.EmployeeName, 
				ROW_NUMBER()
				OVER (PARTITION BY ND.UserId ORDER BY ND.UserId) AS NomineeCount,ND.NomineeName,ND.PercentageOfShare,REPLACE(CONVERT(NVARCHAR,CAST(ND.NomineeDOB AS DATETIME), 106), ' ', '/') AS NomineeDOB, ND.NomineeAddress,
				ND.RelationOf_Nominee,ND.Nominee_PANNumber,ND.Nominee_EmailId,ND.Nominee_ContactNumber,ND.NameOfGuardian,
				CASE ND.GuardianDateOfBirth
					WHEN 'NA' THEN ' '
						ELSE REPLACE(CONVERT(NVARCHAR,CAST(ND.GuardianDateOfBirth AS DATETIME), 106), ' ', '/') 
					END AS GuardianDateOfBirth,ND.AddressOfGuardian,ND.RelationOf_Guardian,ND.Guardian_PANNumber,
	            ND.Guardian_EmailId,ND.Guardian_ContactNumber,REPLACE(CONVERT(NVARCHAR,CAST(ND.DateOfSubmissionOfForm AS DATETIME), 106), ' ', '/') AS DateOfSubmissionOfForm 
		  FROM  EmployeeMaster 
		  INNER JOIN NomineeDetails AS ND ON EmployeeMaster.EmployeeID = ND.UserId 
		  INNER JOIN  #TEMP_NOMINEE AS TN ON TN.UserID=EmployeeMaster.EmployeeID
		  WHERE 
			    ND.ApprovalStatus = 'P'  

													
 
	END
    SET NOCOUNT OFF;						
END
GO
