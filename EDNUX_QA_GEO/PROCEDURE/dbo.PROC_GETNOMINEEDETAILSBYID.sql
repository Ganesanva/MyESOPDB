/****** Object:  StoredProcedure [dbo].[PROC_GETNOMINEEDETAILSBYID]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GETNOMINEEDETAILSBYID]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GETNOMINEEDETAILSBYID]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GETNOMINEEDETAILSBYID]
	-- Add the parameters for the stored procedure here
	(
	@EmployeeId AS VARCHAR(50)
	)
AS
	
BEGIN
		SET NOCOUNT ON;
		SELECT @EmployeeId = EmployeeID FROM EmployeeMaster WHERE LoginId = @EmployeeId AND Deleted = 0
		SELECT 	
			[NomineeId], 
			[UserID] ,
			[NomineeName] ,
			[NomineeDOB],
			[PercentageOfShare], 
			[NomineeAddress], 
			[NameOfGuardian] ,
			[AddressOfGuardian] ,
			[GuardianDateOfBirth], 
			[RelationOf_Nominee],
			[Nominee_PANNumber],
			[Nominee_EmailId],
			[Nominee_ContactNumber], 
			[Nominee_ADHARNumber],
			[Nominee_SIDNumber],
			[Nominee_Other1],
			[Nominee_Other2],
			[Nominee_Other3],
			[Nominee_Other4],			
			[RelationOf_Guardian],
			[Guardian_PANNumber],
			[Guardian_EmailId],
			[Guardian_ContactNumber],
			[Guardian_ADHARNumber],
			[Guardian_SIDNumber],
			[Guardian_Other1],
			[Guardian_Other2],
			[Guardian_Other3],
			[Guardian_Other4]
	 
		FROM 
			NomineeDetails
		WHERE
			 UserID=@EmployeeId
			 And IsActive = 1
	   


	SET NOCOUNT OFF;
    
	
END
GO
