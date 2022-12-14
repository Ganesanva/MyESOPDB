/****** Object:  StoredProcedure [dbo].[PROC_GetDisbursmentData]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetDisbursmentData]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetDisbursmentData]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GetDisbursmentData] 
	@ExerciseNo numeric,
	@EmployeeId varchar(20)
AS
BEGIN
	SET NOCOUNT ON;   
	
	SELECT ShExercisedOptions.ExercisedQuantity AS Quantity , ShExercisedOptions.ExerciseNo AS ExercisedNo, 
		ISNULL(GrantRegistration.ExercisePrice ,0) AS  ExercisePrice ,EmployeeMaster.EmployeeID, 
		EmployeeMaster.EmployeeName ,
		0 AS TotalAmount, 0 AS Tax,    
		Employeemaster.EmployeeEmail AS Email,employeemaster.EmployeePhone AS Contact, 
		EmployeeMaster.AccountNo AS AccountNo, EmployeeMaster.ResidentialStatus AS Nationality 	
	FROM ShExercisedOptions  
		INNER JOIN GrantLeg ON 	ShExercisedOptions.GrantLegSerialNumber = GrantLeg.ID 
		INNER JOIN  GrantOptions ON GrantLeg.GrantOptionId  = GrantOptions.GrantOptionId 
		INNER JOIN  GrantRegistration ON   GrantOptions.GrantRegistrationId= GrantRegistration.GrantRegistrationId 
		INNER JOIN EmployeeMaster ON  EmployeeMaster.EmployeeID = GrantOptions.EmployeeId 
		INNER JOIN  Transaction_Details_Funding b ON  ShExercisedOptions.ExerciseNo  =    b.Sh_ExerciseNo 
	WHERE ShExercisedOptions.PaymentMode = 'F' AND b.MarginOrFunding='M' AND  ISNULL(CONVERT(VARCHAR,b.Payment_status,120),'NULL')  = 'NULL'  
		AND  ISNULL(CONVERT(VARCHAR,b.Transaction_Status,120),'NULL')  = 'NULL' 
		AND EmployeeMaster.EmployeeID = @EmployeeId AND ExerciseNo=@ExerciseNo
END
GO
