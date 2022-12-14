/****** Object:  StoredProcedure [dbo].[PROC_GETNOMINEEDETAILS]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GETNOMINEEDETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GETNOMINEEDETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GETNOMINEEDETAILS]
	
	(@NomineeID AS INT )
AS
BEGIN
		SET NOCOUNT ON;
SELECT 
		[NomineeId], 
	    [UserID] ,
	    [NomineeName] ,
	    [NomineeDOB],
	    [PercentageOfShare], 
	    [NomineeAddress], 
	    [NameOfGuardian] ,
	    [AddressOfGuardian] ,
	    [GuardianDateOfBirth] 
FROM 
		NomineeDetails
WHERE
	 NomineeId=@NomineeID
	 AND IsActive = 1



		SET NOCOUNT OFF;
END
GO
