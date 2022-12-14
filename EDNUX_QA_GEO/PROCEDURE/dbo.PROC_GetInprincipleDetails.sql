/****** Object:  StoredProcedure [dbo].[PROC_GetInprincipleDetails]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetInprincipleDetails]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetInprincipleDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GetInprincipleDetails] 
@UserId varchar(20)
AS
BEGIN
	SET NOCOUNT ON;   
		SELECT a.GrantRegistrationid,a.ExercisePrice, b.EmployeeId, b.GrantedOptions ,  
			SUM(c.ExercisableQuantity) AS ExercisableQuantity, SUM(c.UnapprovedExerciseQuantity) UnapprovedExerciseQuantity,  
			SUM(ISNULL(c.ExercisedQuantity,0)) AS ExercisedQuantity , SUM(ISNULL(c.ExercisableQuantity,0)*a.ExercisePrice) AS exerciseAmount ,  
			0 AS PerQuisiteAmount, 0 AS TotalAmount, SUM(c.UnvestedQuantity) AS UnvestedQuantity  
		FROM GrantRegistration  a 
			LEFT OUTER JOIN GrantOptions   b ON a. GrantRegistrationid = b.GrantRegistrationId   
			LEFT OUTER JOIN GrantLeg c ON c.GrantOptionId   =  b.GrantOptionId  
		WHERE b.EmployeeId = @UserId
		GROUP  BY a.GrantRegistrationid,a.ExercisePrice, b.EmployeeId, b.GrantedOptions 

		SELECT ISNULL(ExercisedQuantity,0) AS ExercisedQuantity, ISNULL(ExercisePrice,0) AS ExercisePrice, 
			ISNULL(PerqstPayable,0) AS PerqstPayable   
		FROM ShExercisedOptions  
		WHERE PaymentMode = 'F' AND ExerciseNo in(
			SELECT Sh_ExerciseNo  
			FROM Transaction_Details_Funding  
			WHERE MarginOrFunding = 'M' 
			AND  BankReferenceNo IS NULL  
			AND Payment_status IS NULL ) 
		AND EmployeeID= @UserId 
END
GO
