/****** Object:  StoredProcedure [dbo].[Proc_ListOfShareAllotment]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Proc_ListOfShareAllotment]
GO
/****** Object:  StoredProcedure [dbo].[Proc_ListOfShareAllotment]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author : Chetan Chopkar
-- Create date : 29 August 2013
-- Description : Sp created for List of share allotment
-- =============================================
-- EXEC Proc_ListOfShareAllotment 'UID-005'

CREATE PROCEDURE [dbo].[Proc_ListOfShareAllotment]
	-- Add the parameters for the stored procedure here
	@UniqueId VARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT ROW_NUMBER() OVER(ORDER BY EmployeeID ASC) AS RowNumber, EmployeeID, EmployeeName, EmployeeAddress, SUM(ExercisedQuantity) AS OptionsExercised, SUM(ExercisedQuantity) AS ShareIssued, ExercisePrice AS ExercisePrice,  SUM((ExercisedQuantity)*(ExercisePrice)) AS  ExerciseAmount, SUM(PerqstPayable) AS PerqstPayable, DepositoryParticipatoryName,  DepositoryIDNumber, ClientIDNumber, SchemeId, CONVERT(DATE, GrantDate) AS GrantDate, CONVERT(DATE, ExerciseDate) AS ExerciseDate , FMVPrice, ResidentialStatus, NameAsPerDPrecord, DepositoryName, DematACType, PANNumber, Nationality, Location, MobileNum, EmployeeEmail, CONVERT(DATE,GenerateAllotListUniqueIdDate) AS GenerateAllotListUniqueIdDate
	FROM
	(
	SELECT DISTINCT EM.EmployeeID, EM.EmployeeName, EM.EmployeeAddress, SEO.ExercisedQuantity, SEO.ExercisePrice, (SEO.PerqstPayable), 
	(CASE 
			  WHEN ((SEO.paymentmode = 'D' OR SEO.paymentmode = 'Q' OR SEO.paymentmode = 'R' OR SEO.paymentmode = 'W' OR SEO.paymentmode = 'I') AND (SHOFF.DepositoryParticipantName IS NOT NULL OR SHOFF.DepositoryParticipantName!='')) THEN SHOFF.DepositoryParticipantName
			  WHEN ((SEO.paymentmode = 'A' OR SEO.paymentmode = 'P') AND (SHCASH.DPName IS NOT NULL OR SHCASH.DPName!='')) THEN SHCASH.DPName
			  WHEN (SEO.paymentmode = 'N' AND (SHON.DPName IS NOT NULL OR SHON.DPName!='')) THEN SHON.DPName
			  ELSE (EM.DepositoryParticipantNo) 
	END) AS DepositoryParticipatoryName,

	(CASE 
			  WHEN ((SEO.paymentmode = 'D' OR SEO.paymentmode = 'Q' OR SEO.paymentmode = 'R' OR SEO.paymentmode = 'W' OR SEO.paymentmode = 'I') AND (SHOFF.DPIDNo IS NOT NULL OR SHOFF.DPIDNo!='')) THEN SHOFF.DPIDNo
			  WHEN ((SEO.paymentmode = 'A' OR SEO.paymentmode = 'P') AND (SHCASH.DPId IS NOT NULL OR SHCASH.DPId!='')) THEN SHCASH.DPId
			  WHEN (SEO.paymentmode = 'N' AND (SHON.DPId IS NOT NULL OR SHON.DPId!='')) THEN SHON.DPId
			  ELSE (EM.DepositoryIDNumber)
	END) AS  DepositoryIDNumber,      

	(CASE WHEN ((SEO.paymentmode = 'D' OR SEO.paymentmode = 'Q' OR SEO.paymentmode = 'R' OR SEO.paymentmode = 'W' OR SEO.paymentmode = 'I') AND (SHOFF.ClientNo IS NOT NULL OR SHOFF.ClientNo!='')) THEN SHOFF.ClientNo
			  WHEN ((SEO.paymentmode = 'A' OR SEO.paymentmode = 'P') AND (SHCASH.ClientId IS NOT NULL OR SHCASH.ClientId!='')) THEN SHCASH.ClientId
			  WHEN (SEO.paymentmode = 'N' AND (SHON.ClientId IS NOT NULL OR SHON.ClientId!='')) THEN SHON.ClientId
			  ELSE EM.ClientIDNumber
	END) AS  ClientIDNumber,
	GL.SchemeId, GR.GrantDate, SEO.ExerciseDate, SEO.FMVPrice, 
	(CASE 
			  WHEN EM.ResidentialStatus = 'R' THEN 'Resident Indian'
			  WHEN EM.ResidentialStatus = 'N' THEN 'Non Resident' 
			  WHEN EM.ResidentialStatus = 'F' then 'Foreign National' 
	END) AS ResidentialStatus,

	(CASE 
			  WHEN ((SEO.paymentmode = 'D' OR SEO.paymentmode = 'Q' OR SEO.paymentmode = 'R' OR SEO.paymentmode = 'W' OR SEO.paymentmode = 'I') AND (SHOFF.DPRecord IS NOT NULL OR SHOFF.DPRecord!='')) THEN SHOFF.DPRecord
			  WHEN ((SEO.paymentmode = 'A' OR SEO.paymentmode = 'P') AND (SHCASH.DPRecord IS NOT NULL OR SHCASH.DPRecord!='')) THEN SHCASH.DPRecord
			  WHEN (SEO.paymentmode = 'N' AND (SHON.DPRecord IS NOT NULL OR SHON.DPRecord!='')) THEN SHON.DPRecord
			  ELSE EM.DPRecord
	END) AS  NameAsPerDPrecord,

	(CASE 
			  WHEN ((SEO.paymentmode = 'D' OR SEO.paymentmode = 'Q' OR SEO.paymentmode = 'R' OR SEO.paymentmode = 'W' OR SEO.paymentmode = 'I') AND (SHOFF.DepositoryName IS NOT NULL OR SHOFF.DepositoryName!='')) THEN  
					   CASE WHEN SHOFF.DepositoryName='N' THEN 'NSDL'
							   WHEN SHOFF.DepositoryName='C' THEN 'CDSL'  
							 ELSE SHOFF.DepositoryName 
						END     
			  WHEN ((SEO.paymentmode = 'A' OR SEO.paymentmode = 'P') AND (SHCASH.DepositoryName IS NOT NULL OR SHCASH.DepositoryName!='')) THEN 
					   CASE WHEN SHCASH.DepositoryName='N' THEN 'NSDL'
										  WHEN SHCASH.DepositoryName='C' THEN 'CDSL'  
								 ELSE SHCASH.DepositoryName 
					   END 
			  WHEN (SEO.paymentmode = 'N' AND (SHON.DepositoryName IS NOT NULL OR SHON.DepositoryName!='')) THEN 
					   CASE WHEN SHON.DepositoryName='N' THEN 'NSDL'
										  WHEN SHON.DepositoryName='C' THEN 'CDSL'  
								 ELSE SHON.DepositoryName END 
			  ELSE 
					   CASE WHEN EM.DepositoryName='N' THEN 'NSDL'
										  WHEN EM.DepositoryName='C' THEN 'CDSL'  
								 ELSE EM.DepositoryName END 
	END) AS DepositoryName,

	(CASE 
			  WHEN ((SEO.paymentmode = 'D' OR SEO.paymentmode = 'Q' OR SEO.paymentmode = 'R' OR SEO.paymentmode = 'W' OR SEO.paymentmode = 'I') AND (SHOFF.DematACType IS NOT NULL OR SHOFF.DematACType!='')) THEN 
					   CASE WHEN SHOFF.DematACType='R' THEN 'Repatriable'
										  WHEN SHOFF.DematACType='N' THEN 'Non Repatriable'
								 ELSE SHOFF.DematACType 
					   END     
			  WHEN ((SEO.paymentmode = 'A' OR SEO.paymentmode = 'P') AND (SHCASH.DematAcType IS NOT NULL OR SHCASH.DematAcType!='')) THEN 
					   CASE WHEN SHCASH.DematAcType='R' THEN 'Repatriable'
										  WHEN SHCASH.DematAcType='N' THEN 'Non Repatriable'
										  ELSE SHCASH.DematAcType 
					   END   
			  WHEN (SEO.paymentmode = 'N' AND (SHON.DematAcType IS NOT NULL OR SHON.DematAcType!='')) THEN 
					   CASE WHEN SHON.DematAcType='R' THEN 'Repatriable'
										  WHEN SHON.DematAcType='N' THEN 'Non Repatriable'
								 ELSE SHON.DematAcType 
					   END 
			  ELSE 
					   CASE WHEN EM.DematAccountType='R' THEN 'Repatriable'
										  WHEN EM.DematAccountType='N' THEN 'Non Repatriable'
								 ELSE EM.DematAccountType 
					   END 
	END) AS  DematACType,     

	(CASE 
			  WHEN ((SEO.paymentmode = 'D' OR SEO.paymentmode = 'Q' OR SEO.paymentmode = 'R' OR SEO.paymentmode = 'W' OR SEO.paymentmode = 'I') AND (SHOFF.PANNumber IS NOT NULL)) THEN SHOFF.PANNumber
			  WHEN ((SEO.paymentmode = 'A' OR SEO.paymentmode = 'P') AND SHCASH.PanNumber IS NOT NULL ) THEN SHCASH.PanNumber
			  WHEN (SEO.paymentmode = 'F' AND (SHFUND.PanNumber IS NOT NULL OR SHFUND.PanNumber!='')) THEN SHFUND.PanNumber
			  WHEN (SEO.paymentmode = 'N' AND (SHON.PanNumber IS NOT NULL OR SHON.PanNumber!='')) THEN SHON.PanNumber
			  ELSE EM.PANNumber
	END) AS PANNumber,

	(CASE 
			  WHEN ((SEO.paymentmode = 'D' OR SEO.paymentmode = 'Q' OR SEO.paymentmode = 'R' OR SEO.paymentmode = 'W' OR SEO.paymentmode = 'I') AND (SHOFF.Nationality IS NOT NULL)) THEN SHOFF.Nationality
			  WHEN ((SEO.paymentmode = 'A' OR SEO.paymentmode = 'P') AND SHCASH.Location IS NOT NULL ) THEN SHCASH.Nationality
			  WHEN (SEO.paymentmode = 'F' AND (SHFUND.Nationality IS NOT NULL OR SHFUND.Nationality!='')) THEN SHFUND.Nationality
			  WHEN (SEO.paymentmode = 'N' AND (SHON.Nationality IS NOT NULL OR SHON.Nationality!='')) THEN SHON.Nationality
			  ELSE ''
	END) AS Nationality,

	(CASE 
			  WHEN ((SEO.paymentmode = 'D' OR SEO.paymentmode = 'Q' OR SEO.paymentmode = 'R' OR SEO.paymentmode = 'W' OR SEO.paymentmode = 'I') AND (SHOFF.Location IS NOT NULL)) THEN SHOFF.Location
			  WHEN ((SEO.paymentmode = 'A' OR SEO.paymentmode = 'P') AND SHCASH.Location IS NOT NULL ) THEN SHCASH.Location
			  WHEN (SEO.paymentmode = 'F' AND (SHFUND.Location IS NOT NULL OR SHFUND.Location!='')) THEN SHFUND.Location
			  WHEN (SEO.paymentmode = 'N' AND (SHON.Location IS NOT NULL OR SHON.Location!='')) THEN SHON.Location
			  ELSE EM.Location
	END) AS  Location,

	(CASE 
			  WHEN ((SEO.paymentmode = 'D' OR SEO.paymentmode = 'Q' OR SEO.paymentmode = 'R' OR SEO.paymentmode = 'W' OR SEO.paymentmode = 'I') AND (SHOFF.Mobile IS NOT NULL)) THEN SHOFF.Mobile
			  WHEN ((SEO.paymentmode = 'A' OR SEO.paymentmode = 'P') AND SHCASH.MobileNumber IS NOT NULL ) THEN SHCASH.MobileNumber
			  WHEN (SEO.paymentmode = 'F' AND (SHFUND.Mobile IS NOT NULL OR SHFUND.Mobile!='')) THEN SHFUND.Mobile
			  WHEN (SEO.paymentmode = 'N' AND (SHON.MobileNumber IS NOT NULL OR SHON.MobileNumber!='')) THEN SHON.MobileNumber
			  ELSE EM.EmployeePhone
	END) AS  MobileNum,
	EM.EmployeeEmail, SEO.GenerateAllotListUniqueIdDate
	FROM ShExercisedOptions AS SEO
	INNER JOIN GrantLeg GL ON SEO.GrantLegSerialNumber = GL.ID
	INNER JOIN GrantOptions GRO ON GL.grantoptionid = GRO.grantoptionid  
	INNER JOIN GrantRegistration AS GR ON GRO.GrantRegistrationId = GR.GrantRegistrationId
	INNER JOIN EmployeeMaster EM ON EM.EmployeeID = GRO.EmployeeID
	LEFT OUTER JOIN shtransactiondetails SHOFF ON SEO.ExerciseNo = SHOFF.ExerciseNo
	LEFT OUTER JOIN transactiondetails_funding SHFUND ON SEO.ExerciseNo = SHFUND.ExerciseNO
	LEFT OUTER JOIN transaction_details SHON ON SEO.ExerciseNo = SHON.exerciseno
	LEFT OUTER JOIN transactiondetails_cashless SHCASH ON SEO.ExerciseNo = SHCASH.ExerciseNo
	LEFT OUTER JOIN AuditTrailAllotmentListReversal AS AT ON SEO.GenerateAllotListUniqueId = AT.AllotedUniqueId
	WHERE (SEO.GenerateAllotListUniqueId = @UniqueId) 

	UNION

	SELECT DISTINCT EM.EmployeeID, EM.EmployeeName, EM.EmployeeAddress, EXER.ExercisedQuantity, EXER.ExercisedPrice, (EXER.PerqstPayable), 
	(CASE 
			  WHEN ((EXER.paymentmode = 'D' OR EXER.paymentmode = 'Q' OR EXER.paymentmode = 'R' OR EXER.paymentmode = 'W' OR EXER.paymentmode = 'I') AND (SHOFF.DepositoryParticipantName IS NOT NULL OR SHOFF.DepositoryParticipantName!='')) THEN SHOFF.DepositoryParticipantName
			  WHEN ((EXER.paymentmode = 'A' OR EXER.paymentmode = 'P') AND (SHCASH.DPName IS NOT NULL OR SHCASH.DPName!='')) THEN SHCASH.DPName
			  WHEN (EXER.paymentmode = 'N' AND (SHON.DPName IS NOT NULL OR SHON.DPName!='')) THEN SHON.DPName
			  ELSE (EM.DepositoryParticipantNo) 
	END) AS DepositoryParticipatoryName,

	(CASE 
			  WHEN ((EXER.paymentmode = 'D' OR EXER.paymentmode = 'Q' OR EXER.paymentmode = 'R' OR EXER.paymentmode = 'W' OR EXER.paymentmode = 'I') AND (SHOFF.DPIDNo IS NOT NULL OR SHOFF.DPIDNo!='')) THEN SHOFF.DPIDNo
			  WHEN ((EXER.paymentmode = 'A' OR EXER.paymentmode = 'P') AND (SHCASH.DPId IS NOT NULL OR SHCASH.DPId!='')) THEN SHCASH.DPId
			  WHEN (EXER.paymentmode = 'N' AND (SHON.DPId IS NOT NULL OR SHON.DPId!='')) THEN SHON.DPId
			  ELSE (EM.DepositoryIDNumber)
	END) AS  DepositoryIDNumber,      

	(CASE WHEN ((EXER.paymentmode = 'D' OR EXER.paymentmode = 'Q' OR EXER.paymentmode = 'R' OR EXER.paymentmode = 'W' OR EXER.paymentmode = 'I') AND (SHOFF.ClientNo IS NOT NULL OR SHOFF.ClientNo!='')) THEN SHOFF.ClientNo
			  WHEN ((EXER.paymentmode = 'A' OR EXER.paymentmode = 'P') AND (SHCASH.ClientId IS NOT NULL OR SHCASH.ClientId!='')) THEN SHCASH.ClientId
			  WHEN (EXER.paymentmode = 'N' AND (SHON.ClientId IS NOT NULL OR SHON.ClientId!='')) THEN SHON.ClientId
			  ELSE EM.ClientIDNumber
	END) AS  ClientIDNumber,
	GL.SchemeId, GR.GrantDate, EXER.ExercisedDate, EXER.FMVPrice, 
	(CASE 
			  WHEN EM.ResidentialStatus = 'R' THEN 'Resident Indian'
			  WHEN EM.ResidentialStatus = 'N' THEN 'Non Resident' 
			  WHEN EM.ResidentialStatus = 'F' then 'Foreign National' 
	END) AS ResidentialStatus,

	(CASE 
			  WHEN ((EXER.paymentmode = 'D' OR EXER.paymentmode = 'Q' OR EXER.paymentmode = 'R' OR EXER.paymentmode = 'W' OR EXER.paymentmode = 'I') AND (SHOFF.DPRecord IS NOT NULL OR SHOFF.DPRecord!='')) THEN SHOFF.DPRecord
			  WHEN ((EXER.paymentmode = 'A' OR EXER.paymentmode = 'P') AND (SHCASH.DPRecord IS NOT NULL OR SHCASH.DPRecord!='')) THEN SHCASH.DPRecord
			  WHEN (EXER.paymentmode = 'N' AND (SHON.DPRecord IS NOT NULL OR SHON.DPRecord!='')) THEN SHON.DPRecord
			  ELSE EM.DPRecord
	END) AS  NameAsPerDPrecord,

	(CASE 
			  WHEN ((EXER.paymentmode = 'D' OR EXER.paymentmode = 'Q' OR EXER.paymentmode = 'R' OR EXER.paymentmode = 'W' OR EXER.paymentmode = 'I') AND (SHOFF.DepositoryName IS NOT NULL OR SHOFF.DepositoryName!='')) THEN  
					   CASE WHEN SHOFF.DepositoryName='N' THEN 'NSDL'
							   WHEN SHOFF.DepositoryName='C' THEN 'CDSL'  
							 ELSE SHOFF.DepositoryName 
						END     
			  WHEN ((EXER.paymentmode = 'A' OR EXER.paymentmode = 'P') AND (SHCASH.DepositoryName IS NOT NULL OR SHCASH.DepositoryName!='')) THEN 
					   CASE WHEN SHCASH.DepositoryName='N' THEN 'NSDL'
										  WHEN SHCASH.DepositoryName='C' THEN 'CDSL'  
								 ELSE SHCASH.DepositoryName 
					   END 
			  WHEN (EXER.paymentmode = 'N' AND (SHON.DepositoryName IS NOT NULL OR SHON.DepositoryName!='')) THEN 
					   CASE WHEN SHON.DepositoryName='N' THEN 'NSDL'
										  WHEN SHON.DepositoryName='C' THEN 'CDSL'  
								 ELSE SHON.DepositoryName END 
			  ELSE 
					   CASE WHEN EM.DepositoryName='N' THEN 'NSDL'
										  WHEN EM.DepositoryName='C' THEN 'CDSL'  
								 ELSE EM.DepositoryName END 
	END) AS DepositoryName,

	(CASE 
			  WHEN ((EXER.paymentmode = 'D' OR EXER.paymentmode = 'Q' OR EXER.paymentmode = 'R' OR EXER.paymentmode = 'W' OR EXER.paymentmode = 'I') AND (SHOFF.DematACType IS NOT NULL OR SHOFF.DematACType!='')) THEN 
					   CASE WHEN SHOFF.DematACType='R' THEN 'Repatriable'
										  WHEN SHOFF.DematACType='N' THEN 'Non Repatriable'
								 ELSE SHOFF.DematACType 
					   END     
			  WHEN ((EXER.paymentmode = 'A' OR EXER.paymentmode = 'P') AND (SHCASH.DematAcType IS NOT NULL OR SHCASH.DematAcType!='')) THEN 
					   CASE WHEN SHCASH.DematAcType='R' THEN 'Repatriable'
										  WHEN SHCASH.DematAcType='N' THEN 'Non Repatriable'
										  ELSE SHCASH.DematAcType 
					   END   
			  WHEN (EXER.paymentmode = 'N' AND (SHON.DematAcType IS NOT NULL OR SHON.DematAcType!='')) THEN 
					   CASE WHEN SHON.DematAcType='R' THEN 'Repatriable'
										  WHEN SHON.DematAcType='N' THEN 'Non Repatriable'
								 ELSE SHON.DematAcType 
					   END 
			  ELSE 
					   CASE WHEN EM.DematAccountType='R' THEN 'Repatriable'
										  WHEN EM.DematAccountType='N' THEN 'Non Repatriable'
								 ELSE EM.DematAccountType 
					   END 
	END) AS  DematACType,     

	(CASE 
			  WHEN ((EXER.paymentmode = 'D' OR EXER.paymentmode = 'Q' OR EXER.paymentmode = 'R' OR EXER.paymentmode = 'W' OR EXER.paymentmode = 'I') AND (SHOFF.PANNumber IS NOT NULL)) THEN SHOFF.PANNumber
			  WHEN ((EXER.paymentmode = 'A' OR EXER.paymentmode = 'P') AND SHCASH.PanNumber IS NOT NULL ) THEN SHCASH.PanNumber
			  WHEN (EXER.paymentmode = 'F' AND (SHFUND.PanNumber IS NOT NULL OR SHFUND.PanNumber!='')) THEN SHFUND.PanNumber
			  WHEN (EXER.paymentmode = 'N' AND (SHON.PanNumber IS NOT NULL OR SHON.PanNumber!='')) THEN SHON.PanNumber
			  ELSE EM.PANNumber
	END) AS PANNumber,

	(CASE 
			  WHEN ((EXER.paymentmode = 'D' OR EXER.paymentmode = 'Q' OR EXER.paymentmode = 'R' OR EXER.paymentmode = 'W' OR EXER.paymentmode = 'I') AND (SHOFF.Nationality IS NOT NULL)) THEN SHOFF.Nationality
			  WHEN ((EXER.paymentmode = 'A' OR EXER.paymentmode = 'P') AND SHCASH.Location IS NOT NULL ) THEN SHCASH.Nationality
			  WHEN (EXER.paymentmode = 'F' AND (SHFUND.Nationality IS NOT NULL OR SHFUND.Nationality!='')) THEN SHFUND.Nationality
			  WHEN (EXER.paymentmode = 'N' AND (SHON.Nationality IS NOT NULL OR SHON.Nationality!='')) THEN SHON.Nationality
			  ELSE ''
	END) AS Nationality,

	(CASE 
			  WHEN ((EXER.paymentmode = 'D' OR EXER.paymentmode = 'Q' OR EXER.paymentmode = 'R' OR EXER.paymentmode = 'W' OR EXER.paymentmode = 'I') AND (SHOFF.Location IS NOT NULL)) THEN SHOFF.Location
			  WHEN ((EXER.paymentmode = 'A' OR EXER.paymentmode = 'P') AND SHCASH.Location IS NOT NULL ) THEN SHCASH.Location
			  WHEN (EXER.paymentmode = 'F' AND (SHFUND.Location IS NOT NULL OR SHFUND.Location!='')) THEN SHFUND.Location
			  WHEN (EXER.paymentmode = 'N' AND (SHON.Location IS NOT NULL OR SHON.Location!='')) THEN SHON.Location
			  ELSE EM.Location
	END) AS  Location,

	(CASE 
			  WHEN ((EXER.paymentmode = 'D' OR EXER.paymentmode = 'Q' OR EXER.paymentmode = 'R' OR EXER.paymentmode = 'W' OR EXER.paymentmode = 'I') AND (SHOFF.Mobile IS NOT NULL)) THEN SHOFF.Mobile
			  WHEN ((EXER.paymentmode = 'A' OR EXER.paymentmode = 'P') AND SHCASH.MobileNumber IS NOT NULL ) THEN SHCASH.MobileNumber
			  WHEN (EXER.paymentmode = 'F' AND (SHFUND.Mobile IS NOT NULL OR SHFUND.Mobile!='')) THEN SHFUND.Mobile
			  WHEN (EXER.paymentmode = 'N' AND (SHON.MobileNumber IS NOT NULL OR SHON.MobileNumber!='')) THEN SHON.MobileNumber
			  ELSE EM.EmployeePhone
	END) AS  MobileNum,
	EM.EmployeeEmail, EXER.GenerateAllotListUniqueIdDate
	FROM Exercised AS EXER
	INNER JOIN GrantLeg GL ON EXER.GrantLegSerialNumber = GL.ID
	INNER JOIN GrantOptions GRO ON GL.grantoptionid = GRO.grantoptionid  
	INNER JOIN GrantRegistration AS GR ON GRO.GrantRegistrationId = GR.GrantRegistrationId
	INNER JOIN EmployeeMaster EM ON EM.EmployeeID = GRO.EmployeeID
	LEFT OUTER JOIN shtransactiondetails SHOFF ON EXER.ExerciseNo = SHOFF.ExerciseNo
	LEFT OUTER JOIN transactiondetails_funding SHFUND ON EXER.ExerciseNo = SHFUND.ExerciseNO
	LEFT OUTER JOIN transaction_details SHON ON EXER.ExerciseNo = SHON.exerciseno
	LEFT OUTER JOIN transactiondetails_cashless SHCASH ON EXER.ExerciseNo = SHCASH.ExerciseNo
	LEFT OUTER JOIN AuditTrailAllotmentListReversal AS AT ON EXER.GenerateAllotListUniqueId = AT.AllotedUniqueId
	WHERE (EXER.GenerateAllotListUniqueId = @UniqueId) 
	) AS FINAL_DATA
	GROUP BY 
	EmployeeID, EmployeeName, EmployeeAddress, ExercisePrice, DepositoryParticipatoryName, DepositoryIDNumber, ClientIDNumber, SchemeId, CONVERT(DATE,GrantDate),  CONVERT(DATE,ExerciseDate), FMVPrice, ResidentialStatus, NameAsPerDPrecord, DepositoryName, DematACType, PANNumber, Nationality, Location, MobileNum, EmployeeEmail, CONVERT(DATE,GenerateAllotListUniqueIdDate)
END
GO
