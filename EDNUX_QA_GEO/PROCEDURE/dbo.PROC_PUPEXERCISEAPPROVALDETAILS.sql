/****** Object:  StoredProcedure [dbo].[PROC_PUPEXERCISEAPPROVALDETAILS]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_PUPEXERCISEAPPROVALDETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_PUPEXERCISEAPPROVALDETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_PUPEXERCISEAPPROVALDETAILS]
(
	@LOTNUMBER VARCHAR(50)
)
AS
BEGIN
	SELECT	SHE.ExerciseId [Exercise Id],
				SHE.ExerciseNo [Exercise No],
				EM.EmployeeID [Employee ID],
				EM.EmployeeName [Employee Name],
				CONVERT(DATE,SHE.ExerciseDate) AS  [Exercise Date] ,
				SC.SchemeId [Plan Name],
				GR.GrantRegistrationID [Grant Registration ID],
				GOPs.GrantOptionId [Grant Option Id],
				CONVERT(DATE,GR.GrantDate) [Grant Date],
				SHE.ExercisedQuantity [PUP Options exercised],
				GR.ExercisePrice [Exercise Price], 		
				SHE.FMVPrice [Settled at Price / Payout Prices /PUP FMV],
				0 [Payout value],
				SHE.PerqstValue [Perquisite value],
				SHE.PerqstPayable [Perquisite tax],
				SHE.ValidationStatus [Update Payout],
				SHE.LotNumber [Lot Number],
				SHE.PaymentMode [PAYMENTMODE]
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
		WHERE	LotNumber=@LOTNUMBER
		AND		UPPER(SHE.CASH)='PUP' 
		AND		SC.IsPUPEnabled=1 
		AND		SC.PUPExedPayoutProcess=1		
		ORDER BY EM.EMPLOYEEID ASC, EM.EMPLOYEENAME
END
GO
