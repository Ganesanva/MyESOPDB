/****** Object:  StoredProcedure [dbo].[PROC_GETPUP_ONLINE_EXED_TRANSLIST]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GETPUP_ONLINE_EXED_TRANSLIST]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GETPUP_ONLINE_EXED_TRANSLIST]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GETPUP_ONLINE_EXED_TRANSLIST]
(
	@EMPLOYEE_ID NVARCHAR(MAX),
	@SCHEME_ID	NVARCHAR(MAX)
)
AS
BEGIN
	SELECT	SHE.ExerciseId [Exercise Id],
			SHE.ExerciseNo [Exercise No],
			EM.EmployeeID [Employee ID],
			EM.EmployeeName [Employee Name],
			CONVERT(DATE,SHE.ExerciseDate) AS  [Exercise Date] ,
			SC.SchemeId [Plan Name],
			CONVERT(DATE,GR.GrantDate) [Grant Date],
			SHE.ExercisedQuantity [PUP Options exercised],
			SHE.FMVPrice [Settled at Price / Payout Prices /PUP FMV],
			she.PerqstValue [Payout value],
			0 [Perquisite value],
			ISNULL(SHE.PerqstPayable,0) [Perquisite tax],
			CASE WHEN ValidationStatus='N' 
					THEN ''
				 ELSE ValidationStatus 
			END [Update Payout],
			SHE.LotNumber [Lot Number],
			CASE WHEN UPPER(SHE.PAYMENTMODE)='X' THEN 'Not Applicable' END [PAYMENTMODE],
			SHE.ISFORMGENERATE
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
	AND		SHE.LotNumber IS NULL		
	ORDER BY EM.EMPLOYEEID ASC, EM.EMPLOYEENAME
END
GO
