/****** Object:  StoredProcedure [dbo].[PROC_GET_ALL_TAX_REPORT_DATA]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_ALL_TAX_REPORT_DATA]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_ALL_TAX_REPORT_DATA]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_ALL_TAX_REPORT_DATA] 

	@EmployeeId NVARCHAR (200),
	@ExerciseId NVARCHAR (200) 
	
AS
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT 
		EX.ExerciseId,GR.GrantDate,EX.ExercisedQuantity,EX.ExercisePrice,
		CONVERT(VARCHAR,EX.ExerciseDate,103) AS ExerciseDate,		
		CASE WHEN EX.FMVPrice IS NULL THEN EX.TentativeFMVPrice ELSE EX.FMVPrice END AS FMV,
		CASE WHEN EX.FMVPrice IS NULL THEN EX.TentativePerqstPayable ELSE EX.PerqstPayable END AS PerqPayable,
		CASE WHEN EX.FMVPrice IS NULL THEN EX.TentativePerqstValue ELSE EX.PerqstValue END AS PerqValue,
		EX.Perq_Tax_rate, EX.Cash, EM.TAX_IDENTIFIER_COUNTRY, EM.TAX_IDENTIFIER_STATE, EM.ResidentialStatus
	FROM 
		ShExercisedOptions EX 
		INNER JOIN GrantLeg GL ON EX.GrantLegSerialNumber = GL.ID
		INNER JOIN GrantRegistration GR ON GR.GrantRegistrationId = GL.GrantRegistrationId
		INNER JOIN grantoptions GOP ON GL.grantoptionid = GOP.grantoptionid
		INNER JOIN EmployeeMaster EM ON EM.EmployeeID = GOP.EmployeeId
	WHERE
		GOP.EmployeeId = @EmployeeId AND ExerciseId = @ExerciseId
		
	SET NOCOUNT OFF;
END
GO
