/****** Object:  StoredProcedure [dbo].[PROC_GET_EMP_PROFILE_PENDING_TASK_DETAILS]    Script Date: 7/8/2022 3:00:41 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_EMP_PROFILE_PENDING_TASK_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_EMP_PROFILE_PENDING_TASK_DETAILS]    Script Date: 7/8/2022 3:00:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_EMP_PROFILE_PENDING_TASK_DETAILS]  
	@LoginId NVARCHAR (50)
AS
BEGIN
	SET NOCOUNT ON;
		DECLARE @EmployeeID VARCHAR(50);
		DECLARE @DematDetails INT;

		SELECT @EmployeeID = EmployeeID FROM EmployeeMaster WHERE LoginID=@LoginId AND ISNULL(Deleted,0)=0
		
		SET @DematDetails=(SELECT count(*)
		FROM 
			   Employee_UserDematDetails EU INNER JOIN EmployeeMaster EM ON EU.EmployeeID=EM.EmployeeID
		WHERE
			(	EM.LoginID=@LoginId AND ISNULL(EM.Deleted,0)=0 and EU.IsActive='1'
				AND EU.EmployeeDematId IS NOT NULL
				AND EU.EmployeeID IS NOT NULL
				AND EU.DepositoryName IS NOT NULL
				AND EU.DepositoryParticipantName IS NOT NULL
				AND EU.ClientIDNumber IS NOT NULL
				AND EU.DematAccountType IS NOT NULL
				--AND EU.DepositoryIDNumber IS NOT NULL
				AND EU.DPRecord IS NOT NULL				
				AND EU.IsValidDematAcc IS NOT NULL))
	
		DECLARE @BrokerDetails INT;
	    SET @BrokerDetails=(SELECT count(*)
		 FROM
		   Employee_UserBrokerDetails EU INNER JOIN EmployeeMaster EM ON EU.EMPLOYEE_ID=EM.EmployeeID
		 WHERE
		   EM.LoginID= @LoginId
		    AND ISNULL(EM.Deleted,0)=0 AND IS_ACTIVE='1' 
		    AND EMPLOYEE_BROKER_ACC_ID IS NOT NULL
		    AND EMPLOYEE_ID IS NOT NULL		   
		    AND EU.BROKER_DEP_TRUST_CMP_NAME IS NOT NULL
		    AND EU.BROKER_DEP_TRUST_CMP_ID IS NOT NULL
		    AND EU.BROKER_ELECT_ACC_NUM IS NOT NULL
		  )
	    DECLARE @NomineeDetails int;
	    set @NomineeDetails=(SELECT count(*) FROM NomineeDetails WHERE UserID=@EmployeeID  AND IsActive = 1)

        DECLARE @ExerciseOption int;
		set @ExerciseOption=(SELECT count(*) FROM ShExercisedOptions  WHERE
		PaymentMode = NULL AND isFormGenerate=0 AND IS_UPLOAD_EXERCISE_FORM=NULL AND
		IS_UPLOAD_EXERCISE_FORM_ON= NULL AND IsAccepted = null and IsAcceptedOn= NULL AND EmployeeID= @EmployeeID )

		DECLARE @GrantAccept int;
		SET @GrantAccept=(SELECT count(*) FROM GrantAccMassUpload WHERE LetterAcceptanceStatus <> 'A' AND EmployeeID= @EmployeeID )

		SELECT  case when @DematDetails  <> 0 then 1 else 0 end as DematDetails,
		case when @BrokerDetails <> 0 then 1 else 0 end as BrokerDetails,
		case when @NomineeDetails <> 0 then 1 else 0 end as NomineeDetails,
		case when @ExerciseOption <> 0 then 1 else 0 end as ExerciseOption,
		case when @GrantAccept <> 0 then 1 else 0 end as GrantAccept


	DECLARE @IS_ADR_ENABLED INT
	SET @IS_ADR_ENABLED=(SELECT Top 1 (case WHEN CIM.IsActivatedAccount = 'B' THEN 1 ELSE 0 END) FROM  GrantOptions AS GOP
                        INNER JOIN Scheme AS SCH ON GOP.SchemeId =SCH.SchemeId
                        INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON MIT.MIT_ID = SCH.MIT_ID
                        INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON CIM.MIT_ID = MIT.MIT_ID
						INNER JOIN EmployeeMaster EM ON GOP.EmployeeID=EM.EmployeeID
						WHERE EM.LoginID=@LoginId AND EM.Deleted=0 AND CIM.IsActivatedAccount ='B' )


	DECLARE @IS_ESOP_ENABLED INT
	SET @IS_ESOP_ENABLED=(SELECT Top 1 (case WHEN CIM.IsActivatedAccount = 'D' THEN 1 ELSE 0 END) FROM  GrantOptions AS GOP
                        INNER JOIN Scheme AS SCH ON GOP.SchemeId =SCH.SchemeId
                        INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON MIT.MIT_ID = SCH.MIT_ID
                        INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON CIM.MIT_ID = MIT.MIT_ID
						INNER JOIN EmployeeMaster EM ON GOP.EmployeeID=EM.EmployeeID
						WHERE EM.LoginID= @LoginId AND EM.Deleted=0 AND CIM.IsActivatedAccount ='D' )

	
	DECLARE @IsPersonalDetailUpdated INT=0
	DECLARE @IsBrokerDetailUpdated INT=0
	DECLARE @IsDematDetailUpdated INT=0
	DECLARE @IsNominationUpdated INT=0
	
	SELECT @IsPersonalDetailUpdated=SUM(X.DateOfJoining + X.Grade + X.FathersName + X.CountryName + X.EmployeePhone + X.EmployeeEmail + X.EmployeeAddress + X.PANNumber + X.Department + X.ResidentialStatus +X.[Location] + X.Insider + X.SBU --+ X.WardNumber 
				+ X.Entity + X.COST_CENTER + X.TAX_IDENTIFIER_COUNTRY + X.TAX_IDENTIFIER_STATE 
				+ X.EmployeeDesignation )
				FROM 
				(
						SELECT
						CASE WHEN (LEN(ISNULL(DateOfJoining,''))=0 OR DateOfJoining  in('1900-01-01 00:00:00.000'))AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='DateOfJoining' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ESOP_ENABLED=1  THEN 1
						WHEN (LEN(ISNULL(DateOfJoining,''))=0 OR DateOfJoining  in('1900-01-01 00:00:00.000')) AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='DateOfJoining' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS DateOfJoining,

						CASE WHEN LEN(ISNULL(Grade,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='Grade' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ESOP_ENABLED=1  THEN 1
						WHEN LEN(ISNULL(Grade,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='Grade' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS Grade,

						CASE WHEN LEN(ISNULL(SecondaryEmailID,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='SecondaryEmailID' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ESOP_ENABLED=1  THEN 1
						WHEN LEN(ISNULL(SecondaryEmailID,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='SecondaryEmailID' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS FathersName,

						CASE WHEN LEN(ISNULL(CountryName,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='CountryName' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ESOP_ENABLED=1  THEN 1
						WHEN LEN(ISNULL(CountryName,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='CountryName' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS CountryName,

						CASE WHEN LEN(ISNULL(EmployeePhone,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='EmployeePhone' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ESOP_ENABLED=1  THEN 1
					    WHEN LEN(ISNULL(EmployeePhone,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='EmployeePhone' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS EmployeePhone,

						CASE WHEN LEN(ISNULL(EmployeeEmail,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='EmployeeEmail' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ESOP_ENABLED=1  THEN 1
						WHEN LEN(ISNULL(EmployeeEmail,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='EmployeeEmail' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS EmployeeEmail,

						CASE WHEN ((EmployeeAddress) IS NULL or EmployeeAddress='' or (EmployeeAddress)='null') AND  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='EmployeeAddress' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ESOP_ENABLED=1  THEN 1
						WHEN LEN(ISNULL(EmployeeAddress,''))=0 AND  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='EmployeeAddress' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS EmployeeAddress,

						CASE WHEN ((PANNumber) IS NULL  or PANNumber='' or (PANNumber)='null') AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='PANNumber' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ESOP_ENABLED=1  THEN 1
						WHEN LEN(ISNULL(PANNumber,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='PANNumber' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS PANNumber,

						CASE WHEN LEN(ISNULL(Department,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='Department' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ESOP_ENABLED=1  THEN 1
						WHEN LEN(ISNULL(Department,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='Department' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS Department,

						CASE WHEN ((ResidentialStatus) IS NULL or ResidentialStatus='' or ResidentialStatus='null') AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='ResidentialStatus' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ESOP_ENABLED=1  THEN 1
						WHEN LEN(ISNULL(ResidentialStatus,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='ResidentialStatus' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS ResidentialStatus,

						CASE WHEN LEN(ISNULL([Location],''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='Location' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ESOP_ENABLED=1  THEN 1
						WHEN LEN(ISNULL([Location],''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='Location' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS [Location],

						CASE WHEN LEN(ISNULL(Insider,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='Insider' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ESOP_ENABLED=1  THEN 1
						WHEN LEN(ISNULL(Insider,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='Insider' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS Insider,

						CASE WHEN LEN(ISNULL(SBU,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='SBU' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ESOP_ENABLED=1 THEN 1
						WHEN LEN(ISNULL(SBU,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='SBU' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS SBU,

						--CASE WHEN LEN(ISNULL(WardNumber,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='WardNumber' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0  THEN 1
						--ELSE 0
						--END AS WardNumber,

						CASE WHEN LEN(ISNULL(Entity,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='Entity' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ESOP_ENABLED=1 THEN 1
						WHEN LEN(ISNULL(Entity,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='Entity' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS Entity,

						CASE WHEN LEN(ISNULL(COST_CENTER,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE   CPD.Datafield='COST_CENTER' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ESOP_ENABLED=1  THEN 1
						WHEN LEN(ISNULL(COST_CENTER,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE   CPD.Datafield='COST_CENTER' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS COST_CENTER,

						CASE WHEN LEN(ISNULL(TAX_IDENTIFIER_COUNTRY,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE   CPD.Datafield='TAX_IDENTIFIER_COUNTRY' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ESOP_ENABLED=1  THEN 1
						WHEN LEN(ISNULL(TAX_IDENTIFIER_COUNTRY,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE   CPD.Datafield='TAX_IDENTIFIER_COUNTRY' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS TAX_IDENTIFIER_COUNTRY,

						CASE WHEN LEN(ISNULL(TAX_IDENTIFIER_STATE,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE   CPD.Datafield='TAX_IDENTIFIER_STATE' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ESOP_ENABLED=1  THEN 1
						WHEN LEN(ISNULL(TAX_IDENTIFIER_STATE,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE   CPD.Datafield='TAX_IDENTIFIER_STATE' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS TAX_IDENTIFIER_STATE,

						CASE WHEN LEN(ISNULL(EmployeeDesignation,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='EmployeeDesignation' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ESOP_ENABLED=1  THEN 1
						WHEN LEN(ISNULL(EmployeeDesignation,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='EmployeeDesignation' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS EmployeeDesignation

				FROM EmployeeMaster EM
				LEFT JOIN Employee_UserBrokerDetails EUB ON EM.EmployeeID=EUB.EMPLOYEE_ID AND ISNULL(EUB.IS_ACTIVE,0)=1
				LEFT JOIN Employee_UserDematDetails EUD ON EM.EmployeeID=EUD.EmployeeID AND ISNULL(EUD.IsActive,0)=1
				WHERE EM.EmployeeID=@EmployeeID
				
				)X



			 DECLARE @ISBROKER INT
             SET @ISBROKER =(SELECT Top 1 (case WHEN CIM.IsActivatedAccount = 'B' THEN 1 ELSE 0 END) FROM  GrantOptions AS GOP
                        INNER JOIN Scheme AS SCH ON GOP.SchemeId =SCH.SchemeId
                        INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON MIT.MIT_ID = SCH.MIT_ID
                        INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON CIM.MIT_ID = MIT.MIT_ID
						INNER JOIN EmployeeMaster EM ON GOP.EmployeeID=EM.EmployeeID
						WHERE EM.LoginID=@LoginId AND EM.Deleted=0 AND CIM.IsActivatedAccount ='B' )

			 Declare @Brokerrecordcount int
   
             SELECT @Brokerrecordcount=SUM( Y.BROKER_DEP_TRUST_CMP_NAME + Y.BROKER_DEP_TRUST_CMP_ID + Y.BROKER_ELECT_ACC_NUM)
	                FROM 
				      ( SELECT  
					   CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='BROKER_DEP_TRUST_CMP_NAME' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  
                                               THEN   CASE WHEN LEN(ISNULL(EUB.BROKER_DEP_TRUST_CMP_NAME,''))=0  THEN 1 
                                               ELSE 0 
                                               END ELSE  0
                                               END AS BROKER_DEP_TRUST_CMP_NAME,

					   CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='BROKER_DEP_TRUST_CMP_ID' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  
                                               THEN   CASE WHEN LEN(ISNULL(EUB.BROKER_DEP_TRUST_CMP_ID,''))=0  THEN 1 
                                               ELSE 0 
                                               END ELSE  0
                                               END AS BROKER_DEP_TRUST_CMP_ID,
						
						CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='BROKER_ELECT_ACC_NUM' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  
                                               THEN   CASE WHEN LEN(ISNULL(EUB.BROKER_ELECT_ACC_NUM,''))=0THEN 1 
                                               ELSE 0 
                                               END ELSE  0
											   END AS BROKER_ELECT_ACC_NUM

					   FROM Employee_UserBrokerDetails EUB
				        Right JOIN EmployeeMaster EM ON EM.EmployeeID=EUB.EMPLOYEE_ID AND ISNULL(EUB.IS_ACTIVE,0)=1
				        WHERE EM.EmployeeID=@EmployeeID) Y


            
						
			 SELECT @IsBrokerDetailUpdated=SUM( Y.BROKER_DEP_TRUST_CMP_NAME + Y.BROKER_DEP_TRUST_CMP_ID + Y.BROKER_ELECT_ACC_NUM)
	                FROM 
				      ( 
					  SELECT CASE WHEN LEN(ISNULL(EUB.BROKER_DEP_TRUST_CMP_NAME,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='BROKER_DEP_TRUST_CMP_NAME' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS BROKER_DEP_TRUST_CMP_NAME,

						CASE WHEN LEN(ISNULL(EUB.BROKER_DEP_TRUST_CMP_ID,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='BROKER_DEP_TRUST_CMP_ID' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS BROKER_DEP_TRUST_CMP_ID,

						CASE 	WHEN LEN(ISNULL(EUB.BROKER_ELECT_ACC_NUM,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='BROKER_ELECT_ACC_NUM' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS BROKER_ELECT_ACC_NUM

						FROM Employee_UserBrokerDetails EUB
				        Right JOIN EmployeeMaster EM ON EM.EmployeeID=EUB.EMPLOYEE_ID AND ISNULL(EUB.IS_ACTIVE,0)=1
				        WHERE EM.EmployeeID=@EmployeeID) Y

             Declare @Dematrecordcount int
   			 DECLARE @ISDEMAT INT
             SET @ISDEMAT=(SELECT TOP 1 (case WHEN CIM.IsActivatedAccount = 'D' THEN 1 ELSE 0 END) FROM  GrantOptions AS GOP
                        INNER JOIN Scheme AS SCH ON GOP.SchemeId =SCH.SchemeId
                        INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON MIT.MIT_ID = SCH.MIT_ID
                        INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON CIM.MIT_ID = MIT.MIT_ID
						INNER JOIN EmployeeMaster EM ON GOP.EmployeeID=EM.EmployeeID
						WHERE EM.LoginID=@LoginId AND EM.Deleted=0 AND CIM.IsActivatedAccount ='D')

		
						
            
             SELECT @Dematrecordcount=SUM( Z.DPRecord + Z.DepositoryName + Z.DematAccountType + 
			-- Z.DepositoryParticipantNo + 
			 Z.DepositoryIDNumber + Z.ClientIDNumber ) 
			FROM (
			   SELECT CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='DPRecord' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  
                                               THEN   CASE WHEN LEN(ISNULL(EUD.DPRecord,''))=0  THEN 1 
                                               ELSE 0 
                                               END ELSE  0
                                               END AS DPRecord,
			
						 CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='DepositoryName' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  
                                               THEN   CASE WHEN LEN(ISNULL(EUD.DepositoryName,''))=0  THEN 1 
                                               ELSE 0 
                                               END ELSE  0
                                               END AS DepositoryName,
						
						 CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='DematAccountType' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  
                                               THEN   CASE WHEN LEN(ISNULL(EUD.DematAccountType,''))=0  THEN 1 
                                               ELSE 0 
                                               END ELSE  0
                                               END AS DematAccountType,
						CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='DepositoryParticipantName' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  
                                               THEN   CASE WHEN LEN(ISNULL(EUD.DepositoryParticipantName,''))=0  THEN 1
                                               ELSE 0
                                               END ELSE  0
                                               END AS DepositoryParticipantName,
						--CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='DepositoryParticipantNo' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  
      --                                         THEN   CASE WHEN LEN(ISNULL(EUD.DepositoryParticipantNo,''))=0  THEN 0 
      --                                         ELSE 1 
      --                                         END ELSE  0
      --                                         END AS DepositoryParticipantNo,
						CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='DepositoryIDNumber' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  
                                               THEN   CASE WHEN LEN(ISNULL(EUD.DepositoryIDNumber,''))=0  THEN 1 
                                               ELSE 0 
                                               END ELSE  0
                                               END AS DepositoryIDNumber,

						CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='ClientIDNumber' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  
                                               THEN   CASE WHEN LEN(ISNULL(EUD.ClientIDNumber,''))=0  THEN 1 
                                               ELSE 0 
                                               END ELSE  0
                                               END AS ClientIDNumber

						FROM Employee_UserDematDetails EUD 
				        Right JOIN EmployeeMaster EM  ON EM.EmployeeID=EUD.EmployeeID AND ISNULL(EUD.IsActive,0)=1
				        WHERE EM.EmployeeID=@EmployeeID
						) Z

			 SELECT @IsDematDetailUpdated=SUM( Z.DPRecord + Z.DepositoryName + Z.DematAccountType + Z.DepositoryParticipantNo + Z.DepositoryIDNumber + Z.ClientIDNumber ) 
			FROM (
	          SELECT CASE WHEN LEN(ISNULL(EUD.DPRecord,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='DPRecord' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ESOP_ENABLED=1  THEN 1
						ELSE 0
						END AS DPRecord,

						CASE WHEN LEN(ISNULL(EUD.DepositoryName,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='DepositoryName' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ESOP_ENABLED=1  THEN 1
						ELSE 0
						END AS DepositoryName,

						CASE WHEN LEN(ISNULL(EUD.DematAccountType,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='DematAccountType' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ESOP_ENABLED=1  THEN 1
						ELSE 0
						END AS DematAccountType,

						CASE WHEN LEN(ISNULL(EUD.DepositoryParticipantName,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='DepositoryParticipantNo' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ESOP_ENABLED=1  THEN 1
						ELSE 0
						END AS DepositoryParticipantNo,

						CASE WHEN LEN(ISNULL(EUD.DepositoryIDNumber,''))=0 AND ISNULL(EUD.DepositoryIDNumber,'')='N' AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='DepositoryIDNumber' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ESOP_ENABLED=1  THEN 1
						ELSE 0
						END AS DepositoryIDNumber,

						CASE WHEN LEN(ISNULL(EUD.ClientIDNumber,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='ClientIDNumber' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ESOP_ENABLED=1  THEN 1
						ELSE 0
						END AS ClientIDNumber

						FROM Employee_UserDematDetails EUD 
				        Right JOIN EmployeeMaster EM  ON EM.EmployeeID=EUD.EmployeeID AND ISNULL(EUD.IsActive,0)=1
				        WHERE EM.EmployeeID=@EmployeeID
						) Z

	
		DECLARE @IsActiveNomination bit
		SELECT @IsActiveNomination=IsActive FROM MenuSubMenuUI_UX WHERE upper(MenuName)='Nominations' 
	
		if(@IsActiveNomination=1)
		BEGIN
		SELECT @IsNominationUpdated = CASE WHEN ISNULL((
						SELECT  SUM( CONVERT(INT, ROUND( ISNULL(PercentageOfShare,0),0))) from NomineeDetails AS ND  LEFT JOIN EmployeeMaster EM  ON EM.EmployeeID=ND.UserID AND ISNULL(ND.IsActive,0)=1
						WHERE EM.EmployeeID=@EmployeeID AND EM.Deleted =0 AND ISNUMERIC(PercentageOfShare) = 1
						),0) =100 THEN 0 ELSE 1 END
		END
		 
		
		Declare @Selectpaymentmode int;
		SET @Selectpaymentmode=(SELECT count(*) FROM ShExercisedOptions  WHERE
		ISNULL(PaymentMode,'') = '' AND ISNULL(isFormGenerate,0)=0 AND ISNULL(IS_UPLOAD_EXERCISE_FORM,0)=0 AND
	    ISNULL(IsAccepted,0) = null    AND EmployeeID= @EmployeeID )

		Declare @IS_EGRANTS_ENABLED  AS CHAR(1);
		SET @IS_EGRANTS_ENABLED = (SELECT IS_EGRANTS_ENABLED FROM CompanyMaster)
		Declare @GrantAcceptE int;
		SET @GrantAcceptE = 0;

		if(@IS_EGRANTS_ENABLED=1)
		BEGIN
		DECLARE @STATUS  AS VARCHAR(5)
	    SELECT @STATUS = ACSID FROM OGA_CONFIGURATIONS
		SET @GrantAcceptE=(SELECT COUNT(x.LetterAcceptanceStatusFlag) FROM  (SELECT CASE
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') NOT IN ('A','R') AND CONVERT(DATE,LASTACCEPTANCEDATE) < CONVERT(DATE,GETDATE()) THEN 'E' 
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'P' AND @STATUS = '4' THEN 'PA'
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'P' AND @STATUS <> '4' THEN 'PAR'
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'A' THEN 'A' 
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'R' THEN 'R'			
		    ELSE 'NULL' 
		END LetterAcceptanceStatusFlag FROM GrantAccMassUpload WHERE
		EmployeeID=@EmployeeID AND IsGlGenerated=1 AND MailSentStatus=1) X
		where  ISNULL(X.LetterAcceptanceStatusFlag,'') NOT IN ('A','R','E') )
		END

	
		Declare @ExerciseNow  int;
		DECLARE @IsActive bit
		SELECT @IsActive=IsActive FROM MenuSubMenuUI_UX WHERE upper(MenuName)='Exercise Options' 
	print @IsBrokerDetailUpdated 
	print'ss'
	print @IsDematDetailUpdated
	print @Dematrecordcount
 		if(@IsActive=1)
		BEGIN
		IF(@IS_EGRANTS_ENABLED=1)
			BEGIN
			SET @ExerciseNow=(SELECT count(GrantLeg.GrantOptionId) FROM GrantLeg
			INNER JOIN GrantOptions GOI on GOI.GrantOptionId=GrantLeg.GrantOptionId
			INNER JOIN SCHEME AS SCH ON GOI.SchemeId = Sch.SchemeId AND ISNULL(SCH.IS_AUTO_EXERCISE_ALLOWED,0) <> 1
			INNER JOIN GrantRegistration GR on GOI.GrantRegistrationId=GR.GrantRegistrationId 
			INNER JOIN GrantAccMassUpload AS GAM ON GAM.LetterCode = GrantLeg.GrantOptionId
			WHERE ISNULL(ExercisableQuantity,0)> 0 AND 
			GOI.EmployeeID= @EmployeeID AND  GAM.LetterAcceptanceStatus ='A'
			and GETDATE() >= GrantLeg.FinalVestingDate 
	    	and GETDATE() <= GrantLeg.FinalExpirayDate)
			END
		ELSE
			BEGIN
			SET @ExerciseNow=(SELECT count(GrantLeg.GrantOptionId) FROM GrantLeg
			INNER JOIN GrantOptions GOI on GOI.GrantOptionId=GrantLeg.GrantOptionId
			INNER JOIN SCHEME AS SCH ON GOI.SchemeId = Sch.SchemeId AND ISNULL(SCH.IS_AUTO_EXERCISE_ALLOWED,0) <> 1
			INNER JOIN GrantRegistration GR on GOI.GrantRegistrationId=GR.GrantRegistrationId WHERE ISNULL(ExercisableQuantity,0)> 0 AND 
			GOI.EmployeeID= @EmployeeID 
			and GETDATE() >= GrantLeg.FinalVestingDate 
		    and GETDATE() <= GrantLeg.FinalExpirayDate)
			END
		END
		ELSE
		BEGIN/* else part for profile pending*/
		SET @IsBrokerDetailUpdated=@Brokerrecordcount
		SET @IsDematDetailUpdated=@Dematrecordcount
		Set	@IsPersonalDetailUpdated=0
		CREATE TABLE #PersonalDetailUpdatedTEMP (
		DematDetails INT,
		BrokerDetails INT, 
		ProfilePer DECIMAL(3,0));
		INSERT  INTO #PersonalDetailUpdatedTEMP EXEC PROC_GET_EMP_PROFILE_CALCULATE_DETAILS @LoginId
		SET @IsPersonalDetailUpdated=( SELECT CASE WHEN ProfilePer < 100 THEN 1 ELSE 0 END  FROM #PersonalDetailUpdatedTEMP)
		drop  table #PersonalDetailUpdatedTEMP
		END


		Declare @Updatepaymentdetails  int;
		SET @Updatepaymentdetails=(SELECT count(TES.IS_ATTEMPTED) FROM TRANSACTIONS_EXERCISE_STEP TES
        INNER JOIN ShExercisedOptions SHE on SHE.ExerciseNo=TES.EXERCISE_NO
		WHERE ISNULL(EXERCISE_STEPID,0)=1 AND ISNULL(IS_ATTEMPTED,0)=0 and
		SHE.EmployeeID= @EmployeeID )

		Declare @Completeprocess  int;
		SET @Completeprocess=(SELECT count( *) FROM(SELECT DISTINCT  TES.EXERCISE_NO FROM TRANSACTIONS_EXERCISE_STEP TES
        INNER JOIN ShExercisedOptions SHE on SHE.ExerciseNo=TES.EXERCISE_NO
		WHERE( (ISNULL (EXERCISE_STEPID,0)=2 AND ISNULL(IS_ATTEMPTED,0)=0
		        ) or (ISNULL (EXERCISE_STEPID,0)=3 AND ISNULL(IS_ATTEMPTED,0)=0)
				   or(ISNULL (EXERCISE_STEPID,0)=5 AND ISNULL(IS_ATTEMPTED,0)=0))  and
		SHE.EmployeeID= @EmployeeID ) as a )
		
		
	

    	SELECT  CASE WHEN @IsPersonalDetailUpdated <> 0 THEN 1 ELSE 0 END AS UserProfileForExercise,
		CASE WHEN @IsBrokerDetailUpdated <> 0  THEN 1 ELSE 0 END AS BrokerForExercise,
        CASE WHEN @IsDematDetailUpdated <> 0 THEN 1 ELSE 0 END AS DematForExercise,
		CASE WHEN @IsNominationUpdated <> 0 THEN 1 ELSE 0 END AS NominationForExercise,
		CASE WHEN @GrantAcceptE <> 0 THEN 1 ELSE 0 END AS GrantAcceptE,
		CASE WHEN @Selectpaymentmode <> 0 THEN @Selectpaymentmode ELSE 0 END AS Selectpaymentmode,
		CASE WHEN @ExerciseNow <> 0 THEN 1 ELSE 0 END AS ExerciseNow,
		CASE WHEN @Updatepaymentdetails <> 0 THEN @Updatepaymentdetails ELSE 0 END AS Updatepaymentdetails,
		CASE WHEN @Completeprocess <> 0 THEN @Completeprocess ELSE 0 END AS Completeprocess,
	    (CASE WHEN @IsPersonalDetailUpdated <> 0 THEN 1 ELSE 0 END +
		CASE WHEN @IsBrokerDetailUpdated <> 0  THEN 1 ELSE 0 END +
         CASE WHEN @IsDematDetailUpdated <> 0 THEN 1 ELSE 0 END  +
		CASE WHEN @IsNominationUpdated <> 0 THEN 1 ELSE 0 END  +
		CASE WHEN @GrantAcceptE <> 0 THEN 1 ELSE 0 END  +
		
		CASE WHEN @ExerciseNow <> 0 THEN 1 ELSE 0 END   ) as TotalCount
	
	
SET NOCOUNT OFF;
END
GO
