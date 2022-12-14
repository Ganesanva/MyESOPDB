/****** Object:  StoredProcedure [dbo].[GET_NOMNIEE_DETAILS_APPROVED]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GET_NOMNIEE_DETAILS_APPROVED]
GO
/****** Object:  StoredProcedure [dbo].[GET_NOMNIEE_DETAILS_APPROVED]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GET_NOMNIEE_DETAILS_APPROVED]
@Consider INT = NULL ,
@FromDate DATETIME = NULL,
@ToDate DATETIME = NULL

AS	   
BEGIN
	SET NOCOUNT ON;	
	IF(@Consider = 1)
	BEGIN
		 SELECT 
				 EM.EmployeeID, EM.EmployeeName, ROW_NUMBER() OVER (PARTITION BY ND.UserId ORDER BY ND.UserId) AS NomineeCount,
				 ND.NomineeName,ND.PercentageOfShare,REPLACE(CONVERT(NVARCHAR,CAST(ND.NomineeDOB AS DATETIME), 106), ' ', '/') AS NomineeDOB, ND.NomineeAddress,ND.RelationOf_Nominee,ND.Nominee_PANNumber,ND.Nominee_EmailId,ND.Nominee_ContactNumber,
				 ND.NameOfGuardian,ND.NameOfGuardian, 
				 CASE ND.GuardianDateOfBirth
					WHEN 'NA' THEN ' '
						ELSE REPLACE(CONVERT(NVARCHAR,CAST(ND.GuardianDateOfBirth AS DATETIME), 106), ' ', '/') 
					END AS GuardianDateOfBirth
				 ,ND.AddressOfGuardian,ND.RelationOf_Guardian,ND.Guardian_PANNumber,ND.Guardian_EmailId,ND.Guardian_ContactNumber,
				  REPLACE(CONVERT(NVARCHAR,CAST(ND.DateOfSubmissionOfForm AS DATETIME), 106), ' ', '/') AS DateOfSubmissionOfForm 
           FROM  EmployeeMaster AS EM INNER JOIN 
                 NomineeDetails AS ND ON EM.EmployeeID = ND.UserId where ND.ApprovalStatus = 'A'
			AND  (CONVERT(DATE, ND.DateOfSubmissionOfForm) BETWEEN  @FromDate  AND  @ToDate)  
	END	
	ELSE
	BEGIN
		SELECT 
				 EM.EmployeeID, EM.EmployeeName, ROW_NUMBER() OVER (PARTITION BY ND.UserId ORDER BY ND.UserId) AS NomineeCount,
				 ND.NomineeName,ND.PercentageOfShare,REPLACE(CONVERT(NVARCHAR,CAST(ND.NomineeDOB AS DATETIME), 106), ' ', '/') AS NomineeDOB, 
				 ND.NomineeAddress,ND.RelationOf_Nominee,ND.Nominee_PANNumber,ND.Nominee_EmailId,ND.Nominee_ContactNumber,
				 ND.NameOfGuardian,ND.NameOfGuardian,
				 CASE ND.GuardianDateOfBirth
					WHEN 'NA' THEN ' '
						ELSE REPLACE(CONVERT(NVARCHAR,CAST(ND.GuardianDateOfBirth AS DATETIME), 106), ' ', '/') 
					END AS GuardianDateOfBirth,ND.AddressOfGuardian,ND.RelationOf_Guardian,ND.Guardian_PANNumber,ND.Guardian_EmailId,ND.Guardian_ContactNumber,
				 REPLACE(CONVERT(NVARCHAR,CAST(ND.DateOfSubmissionOfForm AS DATETIME), 106), ' ', '/') AS DateOfSubmissionOfForm 
           FROM  EmployeeMaster AS EM INNER JOIN 
                 NomineeDetails AS ND ON EM.EmployeeID = ND.UserId where ND.ApprovalStatus = 'A'
	END
    SET NOCOUNT OFF;								
END
GO
