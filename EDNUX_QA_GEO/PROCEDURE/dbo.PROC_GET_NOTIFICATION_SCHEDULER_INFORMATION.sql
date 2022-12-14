/****** Object:  StoredProcedure [dbo].[PROC_GET_NOTIFICATION_SCHEDULER_INFORMATION]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_NOTIFICATION_SCHEDULER_INFORMATION]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_NOTIFICATION_SCHEDULER_INFORMATION]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_NOTIFICATION_SCHEDULER_INFORMATION]
(
	@NOTIFICATION_TYPE		NVARCHAR(10) = NULL,
	@VESTING_DATE           NVARCHAR(25) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	  IF (@NOTIFICATION_TYPE = '1')
	  BEGIN
	      SELECT DISTINCT X.UserId, X.UserName
		  FROM
		  (
		  SELECT DISTINCT UserId, UM.UserName FROM GrantLeg AS GL
						INNER JOIN GrantOptions AS GOP ON GL.GrantOptionId = GOP.GrantOptionId 
						INNER JOIN Scheme AS SC ON SC.SchemeId = GL.SchemeId
						INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON CIM.MIT_ID = SC.MIT_ID
					    INNER JOIN UserMaster AS UM ON GOP.EmployeeId = UM.EmployeeId 
						INNER JOIN EmployeeMaster AS EM ON EM.EmployeeID = UM.EmployeeId
						INNER JOIN RoleMaster AS RM ON UM.RoleId = RM.RoleId 
						INNER JOIN UserType AS UT ON RM.UserTypeId = UT.UserTypeId 
					    --INNER JOIN Employee_UserDematDetails AS EUD ON EUD.EmployeeID = EM.EmployeeId  
						WHERE EM.Deleted =0 AND UT.UserTypeId =3 AND UM.IsUserActive='Y' AND CIM.MIT_ID NOT IN (3,4) AND
						EM.EmployeeId NOT IN (select EmployeeId from Employee_UserDematDetails where IsActive=1 )
		  UNION 
	      SELECT DISTINCT UserId, UM.UserName FROM GrantLeg AS GL
						INNER JOIN GrantOptions AS GOP ON GL.GrantOptionId = GOP.GrantOptionId 
						INNER JOIN Scheme AS SC ON SC.SchemeId = GL.SchemeId
						INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON CIM.MIT_ID = SC.MIT_ID
					    INNER JOIN UserMaster AS UM ON GOP.EmployeeId = UM.EmployeeId 
						INNER JOIN EmployeeMaster AS EM ON EM.EmployeeID = UM.EmployeeId
						INNER JOIN RoleMaster AS RM ON UM.RoleId = RM.RoleId 
						INNER JOIN UserType AS UT ON RM.UserTypeId = UT.UserTypeId 
					    INNER JOIN Employee_UserDematDetails AS EUD ON EUD.EmployeeID = EM.EmployeeId  
						WHERE EM.Deleted =0 AND UT.UserTypeId =3 AND UM.IsUserActive='Y' AND CIM.MIT_ID NOT IN (3,4)
						AND (LEN(ISNULL(EUD.DepositoryName,''))= 0 OR LEN(ISNULL(EUD.DematAccountType,''))= 0
						OR LEN(ISNULL(EUD.DepositoryParticipantName,''))= 0 OR LEN(ISNULL(EUD.ClientIDNumber,''))= 0						
						OR LEN(ISNULL(EUD.DPRecord,''))= 0 OR
						ISNULL(CASE WHEN LEN(ISNULL(EUD.DepositoryName,'')) > 0 AND EUD.DepositoryName ='N' THEN LEN(ISNULL(EUD.DepositoryIDNumber,''))
						ElSE 1 END ,'') = 0)
						--ORDER by UserId ASC
			)X ORDER by X.UserId ASC
	  END
	  ELSE
	  IF (@NOTIFICATION_TYPE = '2')
	  BEGIN
	      SELECT DISTINCT UserId, CONVERT(varchar,LastAcceptanceDate,106) AS LastAcceptanceDate FROM GrantLeg AS GL  --, LetterAcceptanceStatus, letterAcceptanceDate, LastAcceptanceDate
					INNER JOIN GrantOptions AS GOP ON GL.GrantOptionId = GOP.GrantOptionId 
					INNER JOIN UserMaster AS UM ON GOP.EmployeeId = UM.EmployeeId 
					INNER JOIN EmployeeMaster AS EM ON EM.EmployeeID = UM.EmployeeId
					INNER JOIN RoleMaster AS RM ON UM.RoleId = RM.RoleId 
					INNER JOIN UserType AS UT ON RM.UserTypeId = UT.UserTypeId 
					INNER JOIN GrantAccMassUpload AS GAMU ON GAMU.EmployeeID = UM.EmployeeId
					WHERE LetterAcceptanceStatus ='P' and letterAcceptanceDate is null and  EM.Deleted =0 and UT.UserTypeId =3
						  AND UM.IsUserActive='Y' AND MailSentStatus = 1 AND CONVERT(DATE, LastAcceptanceDate) >= CONVERT(DATE, GETDATE())
					ORDER by UserId ASC
	  END
	  ELSE
	  IF (@NOTIFICATION_TYPE = '3')
	  BEGIN
	      SELECT DISTINCT X.UserId, x.UserName
		  FROM
		  (
		  
	      SELECT DISTINCT UM.UserId , UM.UserName 
				FROM UserMaster AS UM INNER JOIN EmployeeMaster AS EM ON EM.EmployeeID = UM.EmployeeId				
				WHERE EM.Deleted =0 AND UM.IsUserActive='Y' AND
				EM.EmployeeId NOT IN (select UserID from NomineeDetails where IsActive=1)
				GROUP BY UM.UserId , UM.UserName				
		  UNION 
		  SELECT DISTINCT UM.UserId , UM.UserName --, sum( convert(int, round( isnull(PercentageOfShare,0),0)))
				FROM UserMaster AS UM INNER JOIN EmployeeMaster AS EM ON EM.EmployeeID = UM.EmployeeId
				INNER JOIN NomineeDetails AS ND ON ND.UserID = UM.EmployeeId
				WHERE EM.Deleted =0 AND UM.IsUserActive='Y' AND ISNUMERIC(PercentageOfShare) = 1
				GROUP BY UM.UserId , UM.UserName
				HAVING sum( convert(int, round( isnull(PercentageOfShare,0),0))) <100
				--ORDER BY UM.UserId ASC
			)X ORDER BY X.UserId ASC
	  END
	  ELSE
	  IF ((@NOTIFICATION_TYPE = '4' OR @NOTIFICATION_TYPE = '5') AND @VESTING_DATE IS NOT NULL)
	  BEGIN
	      SELECT DISTINCT UserId, UM.UserName FROM GrantLeg AS GL
						INNER JOIN VestingPeriod AS VP ON  GL.GrantLegId = VP.vestingperiodno 
						INNER JOIN GrantOptions AS GOP ON GL.GrantOptionId = GOP.GrantOptionId 
						INNER JOIN UserMaster AS UM ON GOP.EmployeeId = UM.EmployeeId 
						INNER JOIN EmployeeMaster AS EM ON EM.EmployeeID = UM.EmployeeId
						INNER JOIN RoleMaster AS RM ON UM.RoleId = RM.RoleId 
						INNER JOIN UserType AS UT ON RM.UserTypeId = UT.UserTypeId 
						INNER JOIN ShExercisedOptions AS SHE ON GL.ID = SHE.GrantLegSerialNumber 
						INNER JOIN GrantAccMassUpload AS GAMU ON GAMU.EmployeeID = UM.EmployeeId
						WHERE CONVERT(DATE, GL.finalvestingdate) BETWEEN CONVERT(date,GETDATE()) AND  CONVERT(date, DATEADD(DAY, 120, GETDATE())) AND  CONVERT(DATE, GL.finalvestingdate) < CONVERT(DATE, ExpiryDate)
						AND CONVERT(DATE, GL.finalvestingdate) = CONVERT(DATE, @VESTING_DATE) AND EM.Deleted =0 AND UM.IsUserActive='Y' AND UT.UserTypeId =3
						AND ((CONVERT(DATE, GETDATE())  < CONVERT(DATE, SHE.ExerciseDate) AND SHE.IsAutoExercised = 2) OR
		                    (CONVERT(DATE, GETDATE())  = CONVERT(DATE, SHE.ExerciseDate) AND SHE.IsAutoExercised = 1)) AND ISNULL(SHE.PaymentMode,'')=''
						order by UserId asc
	  END
	  ELSE
	  IF ((@NOTIFICATION_TYPE = '4' OR @NOTIFICATION_TYPE = '5') AND @VESTING_DATE IS NULL)
	  BEGIN	     
			SELECT distinct CONVERT(DATE, GL.finalvestingdate) as VestingDate FROM GrantLeg AS GL
					INNER JOIN VestingPeriod AS VP ON  GL.GrantLegId = VP.vestingperiodno 
					INNER JOIN GrantOptions AS GOP ON GL.GrantOptionId = GOP.GrantOptionId 
					INNER JOIN UserMaster AS UM ON GOP.EmployeeId = UM.EmployeeId 
					INNER JOIN EmployeeMaster AS EM ON EM.EmployeeID = UM.EmployeeId
					INNER JOIN GrantAccMassUpload AS GAMU ON GAMU.EmployeeID = UM.EmployeeId
					INNER JOIN ShExercisedOptions AS SHE ON GL.ID = SHE.GrantLegSerialNumber 
					WHERE CONVERT(DATE, GL.finalvestingdate) BETWEEN CONVERT(date,GETDATE()) AND  CONVERT(date, DATEADD(DAY, 120, GETDATE())) AND  CONVERT(DATE, GL.finalvestingdate) < CONVERT(DATE, ExpiryDate)
					order by CONVERT(DATE, GL.finalvestingdate) asc
	  END
		
	SET NOCOUNT OFF;
END
GO
