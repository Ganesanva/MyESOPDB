/****** Object:  StoredProcedure [dbo].[PROC_GET_EMP_PROFILE_CALCULATE_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_EMP_PROFILE_CALCULATE_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_EMP_PROFILE_CALCULATE_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GET_EMP_PROFILE_CALCULATE_DETAILS] 
	@LoginId NVARCHAR (100)
AS  


BEGIN
       SET NOCOUNT ON;
       Declare      @EmployeeID NVARCHAR (100)

       set @EmployeeID=(Select Top 1  EmployeeID from EmployeeMaster WHERE Deleted=0 AND LoginID =@LoginId) 
       Declare @DematDetails int;
       set @DematDetails=(SELECT count(*)
             FROM 
                       Employee_UserDematDetails EU INNER JOIN EmployeeMaster EM ON EU.EmployeeID=EM.EmployeeID
             WHERE
                    (      EM.LoginID=@LoginId AND EM.Deleted=0 and EU.IsActive='1'
                           AND EU.EmployeeDematId IS NOT NULL
                           AND EU.EmployeeID IS NOT NULL
                           AND EU.DepositoryName IS NOT NULL
                           AND EU.DepositoryParticipantName IS NOT NULL
                           AND EU.ClientIDNumber IS NOT NULL
                           AND EU.DematAccountType IS NOT NULL
                           AND EU.DepositoryIDNumber IS NOT NULL
                           AND EU.DPRecord IS NOT NULL
                           --and EU.AccountName IS NOT NULL
                           AND EU.IsValidDematAcc IS NOT NULL))
       
       DECLARE @BrokerDetails int;
       SET @BrokerDetails=(SELECT count(*)
             FROM
                Employee_UserBrokerDetails EU INNER JOIN EmployeeMaster EM ON EU.EMPLOYEE_ID=EM.EmployeeID
             WHERE
                EM.LoginID= @LoginId
                AND EM.Deleted=0 AND IS_ACTIVE='1' 
                AND EMPLOYEE_BROKER_ACC_ID IS NOT NULL
                AND EMPLOYEE_ID IS NOT NULL
                --AND ACCOUNT_NAME IS NOT NULL
                AND EU.BROKER_DEP_TRUST_CMP_NAME IS NOT NULL
                AND EU.BROKER_DEP_TRUST_CMP_ID IS NOT NULL
                AND EU.BROKER_ELECT_ACC_NUM IS NOT NULL
               )

                                 DECLARE @totalcolu DECIMAL(2,0);
                                 DECLARE @pendingtotalcolu DECIMAL(2,0);

                                 SELECT  @totalcolu=sum( X.DateOfJoining + X.Grade + X.SecondaryEmailID + X.CountryName + X.EmployeePhone + X.EmployeeEmail + X.EmployeeAddress + X.PANNumber + X.Department + X.ResidentialStatus +X.[Location] + X.Insider + X.SBU --+ X.WardNumber 
                                               + X.Entity + X.COST_CENTER + X.TAX_IDENTIFIER_COUNTRY + X.TAX_IDENTIFIER_STATE 
                                               + X.EmployeeDesignation )
                                               FROM 
                                               (
                                                            SELECT
                                                            CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='DateOfJoining' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  THEN 1
                                                            ELSE 0
                                                            END AS DateOfJoining,

                                                            CASE WHEN (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='Grade' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  THEN 1
                                                            ELSE 0
                                                            END AS Grade,

                                                            CASE WHEN (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='SecondaryEmailID' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  THEN 1
                                                            ELSE 0
                                                            END AS SecondaryEmailID,

                                                            CASE WHEN (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='CountryName' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  THEN 1
                                                            ELSE 0
                                                            END AS CountryName,

                                                            CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='EmployeePhone' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  THEN 1
                                                            ELSE 0
                                                            END AS EmployeePhone,

                                                            CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='EmployeeEmail' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  THEN 1
                                                            ELSE 0
                                                            END AS EmployeeEmail,

                                                            CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='EmployeeAddress' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  THEN 1
                                                            ELSE 0
                                                            END AS EmployeeAddress,

                                                            CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='PANNumber' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  THEN 1
                                                            ELSE 0
                                                            END AS PANNumber,

                                                            CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='Department' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  THEN 1
                                                            ELSE 0
                                                            END AS Department,

                                                            CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='ResidentialStatus' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  THEN 1
                                                            ELSE 0
                                                            END AS ResidentialStatus,

                                                            CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='Location' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  THEN 1
                                                            ELSE 0
                                                            END AS [Location],

                                                            CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='Insider' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  THEN 1
                                                            ELSE 0
                                                            END AS Insider,

                                                            CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='SBU' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1 THEN 1
                                                            ELSE 0
                                                            END AS SBU,

                                                            --CASE WHEN LEN(ISNULL(WardNumber,''))=1 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='WardNumber' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  THEN 1
                                                            --ELSE 0
                                                            --END AS WardNumber,

                                                            CASE WHEN (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='Entity' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1 THEN 1
                                                            ELSE 0
                                                            END AS Entity,

                                                            CASE WHEN (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE   CPD.Datafield='COST_CENTER' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  THEN 1
                                                            ELSE 0
                                                            END AS COST_CENTER,

                                                            CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE   CPD.Datafield='TAX_IDENTIFIER_COUNTRY' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  THEN 1
                                                            ELSE 0
                                                            END AS TAX_IDENTIFIER_COUNTRY,

                                                            CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE   CPD.Datafield='TAX_IDENTIFIER_STATE' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  THEN 1
                                                            ELSE 0
                                                            END AS TAX_IDENTIFIER_STATE,

                                                            CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='EmployeeDesignation' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  THEN 1
                                                            ELSE 0
                                                            END AS EmployeeDesignation


                           
                                               )X  ;
           
       
                                 SELECT @pendingtotalcolu= sum( X.DateOfJoining + X.Grade + X.SecondaryEmailID + X.CountryName + X.EmployeePhone + X.EmployeeEmail + X.EmployeeAddress + X.PANNumber + X.Department + X.ResidentialStatus +X.[Location] + X.Insider + X.SBU --+ X.WardNumber 
                                 + X.Entity + X.COST_CENTER + X.TAX_IDENTIFIER_COUNTRY + X.TAX_IDENTIFIER_STATE 
                                 + X.EmployeeDesignation )
                                 FROM 
                                 (
                                               SELECT
                                               CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='DateOfJoining' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  
                                               THEN   CASE WHEN ( DateOfJoining IS NULL OR DateOfJoining='')  THEN 0 
                                               ELSE 1 
                                               END ELSE  0
                                               END AS DateOfJoining,

                                               CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='Grade' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  
                                               THEN   CASE WHEN LEN(ISNULL(Grade,''))=0  THEN 0 
                                               ELSE 1 
                                               END ELSE  0
                                               END AS Grade,

                                               CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='SecondaryEmailID' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  
                                               THEN   CASE WHEN LEN(ISNULL(SecondaryEmailID,''))=0  THEN 0 
                                               ELSE 1 
                                               END ELSE  0
                                               END AS SecondaryEmailID,

                                               CASE WHEN (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='CountryName' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  
                                               THEN   CASE WHEN LEN(ISNULL(CountryName,''))=0  THEN 0 
                                               ELSE 1 
                                               END ELSE  0
                                               END AS CountryName,

                                               CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='EmployeePhone' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1
                                               THEN  CASE WHEN  (EmployeePhone) IS NULL or (EmployeePhone)='' or (EmployeePhone)='null'   THEN 0 
                                               ELSE 1 
                                               END ELSE  0
                                               END AS EmployeePhone,

                                               CASE WHEN   (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='EmployeeEmail' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1 
                                               THEN  CASE WHEN  ((EmployeeEmail) IS NULL  or EmployeeEmail='' or (EmployeeEmail)='null')  THEN 0 
                                               ELSE 1 
                                               END ELSE  0
                                               END AS EmployeeEmail,

                                               CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='EmployeeAddress' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  
                                               THEN  CASE WHEN  ((EmployeeAddress) IS NULL  or EmployeeAddress='' or (EmployeeAddress)='null')  THEN 0 
                                               ELSE 1 
                                               END ELSE  0
                                               END AS EmployeeAddress,

                                               CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='PANNumber' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  
                                               THEN  CASE WHEN  ((PANNumber) IS NULL  or PANNumber='' or (PANNumber)='null')  THEN 0 
                                               ELSE 1 
                                               END ELSE  0
                                               END AS PANNumber,

                                               CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='Department' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  
                                               THEN  CASE WHEN  LEN(ISNULL(Department,''))=0 THEN 0 
                                               ELSE 1 
                                               END ELSE  0
                                               END AS Department,

                                               CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='ResidentialStatus' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1 
                                               THEN  CASE WHEN  ((ResidentialStatus) IS NULL or ResidentialStatus='' or ResidentialStatus='null')  THEN 0 
                                               ELSE 1 
                                               END ELSE  0
                                               END AS ResidentialStatus,

                                              CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='Location' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  
                                               THEN  CASE WHEN  LEN(ISNULL([Location],''))=0  THEN 0 
                                               ELSE 1 
                                               END ELSE  0
                                               END AS [Location],

                                               CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='Insider' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  
                                               THEN  CASE WHEN  LEN(ISNULL(Insider,''))=0  THEN 0 
                                               ELSE 1 
                                               END ELSE  0
                                               END AS Insider,

                                               CASE WHEN (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='SBU' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1 
                                               THEN  CASE WHEN  LEN(ISNULL(SBU,''))=0    THEN 0 
                                               ELSE 1 
                                               END ELSE  0
                                               END AS SBU,

                                               --CASE WHEN LEN(ISNULL(WardNumber,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='WardNumber' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  THEN 0
                                               --ELSE 1
                                               --END AS WardNumber,

                                               CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='Entity' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1 
                                               THEN  CASE WHEN  LEN(ISNULL(Entity,''))=0     THEN 0 
                                               ELSE 1 
                                               END ELSE  0
                                               END AS Entity,

                                               CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE   CPD.Datafield='COST_CENTER' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  
                                               THEN  CASE WHEN LEN(ISNULL(COST_CENTER,''))=0   THEN 0 
                                               ELSE 1 
                                               END ELSE  0
                                               END AS COST_CENTER,

                                               CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE   CPD.Datafield='TAX_IDENTIFIER_COUNTRY' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  
                                               THEN  CASE WHEN LEN(ISNULL(TAX_IDENTIFIER_COUNTRY,''))=0   THEN 0 
                                               ELSE 1 
                                               END ELSE  0
                                               END AS TAX_IDENTIFIER_COUNTRY,

                                               CASE WHEN  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE   CPD.Datafield='TAX_IDENTIFIER_STATE' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  
                                               THEN  CASE WHEN LEN(ISNULL(TAX_IDENTIFIER_STATE,''))=0   THEN 0 
                                               ELSE 1 
                                               END ELSE  0
                                               END AS TAX_IDENTIFIER_STATE,

                                               CASE WHEN   (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='EmployeeDesignation' AND CPD.Check_ToEmp='Y' AND CPD.MIT_ID IS NULL)=1  
                                               THEN  CASE WHEN LEN(ISNULL(EmployeeDesignation,''))=0 THEN 0 
                                               ELSE 1 
                                               END ELSE  0
                                               END AS EmployeeDesignation

                                 FROM EmployeeMaster EM
                                 WHERE EM.EmployeeID=@EmployeeID 
                           
                                 )X

                                 DECLARE @ProfilePer nvarchar(50)
                                 print @totalcolu print @pendingtotalcolu
                                 SET @ProfilePer=0
                                 IF(@totalcolu!=0)
                                 BEGIN
                                 SET @ProfilePer=(@pendingtotalcolu/@totalcolu)*100
                                 END
								  print @ProfilePer
								  IF(cast(@ProfilePer as decimal(3,0))=0) AND @totalcolu=0
								  BEGIN
								  SET @ProfilePer=100
								  END
                                 SELECT  CASE WHEN @DematDetails=1 then 1 else 0 end as DematDetails,
                                 CASE WHEN @BrokerDetails=1 then 1 else 0 end as BrokerDetails,cast(@ProfilePer as decimal(3,0)) as ProfilePer

       --SELECT  case when @DematDetails=1 then 1 else 0 end as DematDetails,
       --case when @BrokerDetails=1 then 1 else 0 end as BrokerDetails,
       --(CAST(( 
       --+ case when (EmployeePhone) IS NULL or (EmployeePhone)='' or (EmployeePhone)='null' then 0 else 1 end
       --+ case when (EmployeeAddress) IS NULL or EmployeeAddress='' or (EmployeeAddress)='null' then 0 else 1 end
       --+ case when (PANNumber) IS NULL  or PANNumber='' or (PANNumber)='null' then 0 else 1 end
       --+ case when (ResidentialStatus) IS NULL or ResidentialStatus='' or ResidentialStatus='null' then 0 else 1 end 
       -- )AS DECIMAL(2,0))/ 4)*100 as ProfilePer
--   FROM
       --     EmployeeMaster EM
       --     --LEFT OUTER JOIN CountryMaster ON EM.CountryName=CountryMaster.CountryAliasName
       --     --LEFT OUTER JOIN MASTER_LIST_FLD_VALUE AS MLFV_ENTITY ON  UPPER(EM.Entity) = UPPER(MLFV_ENTITY.FIELD_VALUE) AND MLFV_ENTITY.MLFN_ID = 3
       --     --LEFT OUTER JOIN MASTER_LIST_FLD_VALUE AS MLFV_CC ON  UPPER(EM.COST_CENTER) = UPPER(MLFV_CC.FIELD_VALUE) AND MLFV_CC.MLFN_ID = 5 
       --     --LEFT OUTER JOIN MASTER_LIST_FLD_VALUE AS MLFV_SBU ON  UPPER(EM.SBU) = UPPER(MLFV_SBU.FIELD_VALUE) AND MLFV_SBU.MLFN_ID = 2
       --     --LEFT OUTER JOIN MASTER_LIST_FLD_VALUE AS MLFV_LOCATION ON  UPPER(EM.Location) = UPPER(MLFV_LOCATION.FIELD_VALUE) AND MLFV_LOCATION.MLFN_ID = 1
       --     --LEFT OUTER JOIN MASTER_LIST_FLD_VALUE AS MLFV_DEPT ON  UPPER(EM.Department) = UPPER(MLFV_DEPT.FIELD_VALUE)  AND MLFV_DEPT.MLFN_ID = 4
       --WHERE
       --     LoginID = @LoginId AND Deleted=0

       
SET NOCOUNT OFF;
END

GO
