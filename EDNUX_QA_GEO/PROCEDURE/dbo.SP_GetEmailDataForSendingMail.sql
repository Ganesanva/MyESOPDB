/****** Object:  StoredProcedure [dbo].[SP_GetEmailDataForSendingMail]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_GetEmailDataForSendingMail]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetEmailDataForSendingMail]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetEmailDataForSendingMail]
(
	@ExerciseNo int
)
AS
BEGIN
	SELECT 
			Ex.EmployeeID,
			Em.EmployeeName,
			Em.EmployeeEmail,
			SUM(Ex.ExercisedQuantity) ExercisedQuantity,
			CONVERT(DATE,Ex.ExerciseDate) ExerciseDate,
			Ex.ExerciseNo,
			(SELECT CompanyEmailID FROM CompanyMaster) AS CompanyEmailId
	FROM ShExercisedOptions Ex
	INNER JOIN EmployeeMaster EM
	ON  EM.EmployeeID = Ex.EmployeeID
	WHERE Ex.ExerciseNo=@ExerciseNo
	GROUP BY 
		Ex.ExerciseNo,
		Ex.EmployeeID,
		Em.EmployeeName,
		Em.EmployeeEmail,
		CONVERT(DATE,Ex.ExerciseDate)
END
GO
