/****** Object:  StoredProcedure [dbo].[PROC_GETPUPSCHEMELIST]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GETPUPSCHEMELIST]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GETPUPSCHEMELIST]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GETPUPSCHEMELIST]
AS
BEGIN	
	SELECT	DISTINCT SC.SchemeId
	FROM	ShExercisedOptions SHE
			INNER JOIN GrantLeg GL
				ON GL.ID = SHE.GrantLegSerialNumber
			INNER JOIN GrantOptions GOPs
				ON GOPs.GrantOptionId = GL.GrantOptionId
			INNER JOIN GrantRegistration GR
				ON GR.GrantRegistrationId = GL.GrantRegistrationId
			INNER JOIN Scheme SC
				ON SC.SchemeId = GL.SchemeId 
			INNER JOIN EmployeeMaster EM
				ON EM.EmployeeID = GOPs.EmployeeId
	WHERE	UPPER(SHE.CASH)='PUP' 
	AND		SC.IsPUPEnabled=1 
	AND		SC.PUPExedPayoutProcess=1  
END
GO
