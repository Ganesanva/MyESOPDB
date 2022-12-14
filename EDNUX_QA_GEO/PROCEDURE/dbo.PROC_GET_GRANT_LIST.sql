/****** Object:  StoredProcedure [dbo].[PROC_GET_GRANT_LIST]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_GRANT_LIST]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_GRANT_LIST]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PROC_GET_GRANT_LIST]
AS
BEGIN
DECLARE @CompanyEmail VARCHAR(100)
	DECLARE @CompanyEmailDisplayName VARCHAR(100)

	SELECT @CompanyEmail = CompanyEmailID, @CompanyEmailDisplayName = CompanyEmailDisplayName FROM CompanyParameters

	SELECT GGL.GRANTLETTER_ID, GGL.GAMUID, GGL.TEMPLATE_NAME, GGL.ACTION,GGL.ISPROCESSD,
	       REPLACE(CONVERT(VARCHAR,(CONVERT(DATE,GGL.ISPROCESSEDON,106)),106),' ', '-') AS ISPROCESSEDON,GGL.TEXT_MAIL_TO,GGL.TEXT_MAIL_CC,GGL.TEXT_MAIL_BCC,
		   GAMU.Adjustment,GAMU.CompanyAddress,GAMU.CompanyName,GAMU.Currency,GAMU.EmployeeID,GAMU.ExercisePrice,
		   REPLACE(CONVERT(VARCHAR,(CONVERT(DATE,GAMU.FirstVestDate,106)),106),' ', '-') AS FirstVestDate, 
		   REPLACE(CONVERT(VARCHAR,(CONVERT(DATE,GAMU.GrantDate,106)),106),' ', '-') AS GrantDate,GAMU.GrantType,
		   REPLACE(CONVERT(VARCHAR,(CONVERT(DATE,GAMU.LastAcceptanceDate,106)),106),' ', '-') AS LastAcceptanceDate,
		  
		   GAMU.LetterCode,GAMU.LotNumber,GAMU.MailSentStatus,GAMU.NoOfOptions,GAMU.NoOfVests,GAMU.SchemeName,GAMU.VestingFrequency,
		   GAMU.VestingPercentage,GAMU.VestingType,GAMU.Field1,GAMU.Field2,GAMU.Field3,GAMU.Field4,GAMU.Field5,GAMU.Field6,GAMU.Field7,
		   GAMU.Field8,GAMU.Field9,GAMU.Field10,
		   EM.AccountNo,EM.Confirmn_Dt,EM.CompanyName,EM.CountryName,EM.ConfStatus,EM.ClientIDNumber, 
		   REPLACE(CONVERT(VARCHAR,(CONVERT(DATE,EM.DateOfJoining,106)),106),' ', '-') AS DateOfJoining,
		   REPLACE(CONVERT(VARCHAR,(CONVERT(DATE,EM.DateOfTermination,106)),106),' ', '-') AS DateOfTermination,EM.DematAccountType,EM.Department,EM.DepositoryIDNumber,EM.DepositoryName,EM.DepositoryParticipantNo,
		   EM.DPRecord,EM.EmployeeAddress,EM.EmployeeDesignation,EM.EmployeeEmail,EM.EmployeeName,EM.EmployeePhone,EM.Entity,
		   Em.SecondaryEmailID as FathersName,EM.Grade,EM.Insider,EM.Location,EM.LoginID,EM.LWD,EM.PANNumber,EM.ReasonForTermination,EM.ResidentialStatus,
		   EM.SBU,EM.tax_slab,EM.WardNumber, @CompanyEmail AS CompanyEmail, @CompanyEmailDisplayName AS CompanyEmailDisplayName,GGL.ISATTACHMENT AS ISATTACHMENT,
	       CASE  WHEN GAMU.LetterAcceptanceStatus = 'P' THEN '' WHEN GAMU.LetterAcceptanceStatus = 'A' THEN 'Accepted'
           WHEN GAMU.LetterAcceptanceStatus = 'R' THEN 'Rejected' ELSE GAMU.LetterAcceptanceStatus END
           AS LetterAcceptanceStatus,Format(GAMU.LetterAcceptanceDate,'dd/MMM/yyyy HH:mm tt') AS LetterAcceptanceDate
	FROM GENERATE_GRANT_LETTER GGL
	JOIN GrantAccMassUpload GAMU ON GGL.GAMUID = GAMU.GAMUID
	JOIN EmployeeMaster EM ON GAMU.EmployeeID = EM.EmployeeID And Deleted=0
	WHERE GGL.ISPROCESSD = 0
		
END

GO
