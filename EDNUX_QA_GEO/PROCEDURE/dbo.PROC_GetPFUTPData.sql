/****** Object:  StoredProcedure [dbo].[PROC_GetPFUTPData]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetPFUTPData]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetPFUTPData]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetPFUTPData]
(	
	@EmployeeId VARCHAR(20)		
)

AS
SET NOCOUNT ON

BEGIN

DECLARE @PFUTPDate VARCHAR(20), @ICount INT

SET @PFUTPDate = (SELECT CONVERT(VARCHAR(10),PFUTPDate,101) from CompanyParameters)

IF	(@PFUTPDate IS NOT NULL)
BEGIN
  SET @ICount =  
		(
			SELECT 
				COUNT(ID) 
			FROM 
				Exercised AS EX 
				INNER JOIN GrantLeg AS GL ON (EX.GrantLegSerialNumber = GL.ID)
				INNER JOIN GrantOptions AS GOP ON (GL.GrantOptionId = GOP.GrantOptionId)
			WHERE 
				CONVERT(DATE,EX.ExercisedDate) <= CONVERT(DATE, @PFUTPDate)
				AND GOP.EmployeeId = @EmployeeId 
		)
END
	SELECT @ICount
END  


GO
