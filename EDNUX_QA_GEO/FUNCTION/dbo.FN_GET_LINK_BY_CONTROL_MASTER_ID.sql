/****** Object:  UserDefinedFunction [dbo].[FN_GET_LINK_BY_CONTROL_MASTER_ID]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP FUNCTION IF EXISTS [dbo].[FN_GET_LINK_BY_CONTROL_MASTER_ID]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GET_LINK_BY_CONTROL_MASTER_ID]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_GET_LINK_BY_CONTROL_MASTER_ID]
(
      @CONTROLMASTERID INT,
      @USER_ID NVARCHAR(20)
     
)
RETURNS NVARCHAR(MAX)
AS      
BEGIN
		DECLARE @UrlID INT
		DECLARE @UrlAliase NVARCHAR(100)
		DECLARE @Url NVARCHAR(300)
		DECLARE @RTN_LINK_HTML NVARCHAR(MAX)=''
		DECLARE @Percentage INT
		DECLARE @UrlIDNominee INT=0
		DECLARE @UrlIDAcceptGrant INT=0
		DECLARE @PendingAcceptGrantCnt INT=0
		DECLARE @IsPersonalDetailUpdated INT=0
		DECLARE @URLPersonalDetailUpdated INT=0
		DECLARE @CNT INT=0
		DECLARE @IS_EGRANTS_ENABLED AS CHAR(1)
		SET @IS_EGRANTS_ENABLED = (SELECT IS_EGRANTS_ENABLED FROM CompanyMaster)

		DECLARE @IS_ADR_ENABLED INT
		SET @IS_ADR_ENABLED=(SELECT CASE WHEN (COUNT (MIT_ID))>0 THEN 1 ELSE 0 END FROM COMPANY_INSTRUMENT_MAPPING WHERE MIT_ID in (3,4) )
		-- Resolved Issue for Association EmployeeID 
		SET @USER_ID=(SELECT Employeeid FROM EmployeeMaster WHERE LoginID=@USER_ID AND Deleted=0)
		-- Insert statements for procedure here

		--*******IF Percentage = 100% then exclude from result
		SELECT @Percentage=SUM(CAST(PercentageOfShare AS DECIMAL)) FROM NomineeDetails WHERE UserID=@USER_ID AND ISNULL(IsActive,0)=1
		GROUP BY UserID
		IF @CONTROLMASTERID=17
		BEGIN

			IF EXISTS(SELECT * FROM MENUSUBMENU WHERE UPPER(MENUNAME)='NOMINATION' AND ISACTIVE=1)
			BEGIN
				SELECT @UrlAliase=URL_ALIASE,@Url=[URL]
				FROM DASHBOARD_WIDGETS_URLS_MAPPING
				WHERE CONTROL_MASTER_ID=17 AND URL LIKE '%../Employee/Nomination.aspx%'

				IF ISNULL(@Percentage,0)=100
				BEGIN
					SET @RTN_LINK_HTML = @RTN_LINK_HTML + '<div style="padding:5px 10px" class="col-sm-6"><a id="lnkNomination" href="'+@Url+'" class="btn btn-success btn-ToDO btn-sm" title="Green indicates: Completed Activities">'+@UrlAliase+'</a></div>'
				END
				ELSE
				BEGIN
					SET @RTN_LINK_HTML = @RTN_LINK_HTML + '<div style="padding:5px 10px" class="col-sm-6"><a id="lnkNomination" href="'+@Url+'" class="btn btn-gradient btn-ToDO btn-sm" title="Red indicates Pending Activities">'+@UrlAliase+'</a></div>'
				END
			END
			--******************************************************************************************************

        	--*******Employee MyDocuments
		    
		     
		     	IF EXISTS(SELECT * FROM MENUSUBMENU WHERE UPPER(MENUNAME)='My Document' AND ISACTIVE=1)
		     	BEGIN
		     		SELECT @UrlAliase=URL_ALIASE,@Url=[URL]
		     		FROM DASHBOARD_WIDGETS_URLS_MAPPING
		     		WHERE CONTROL_MASTER_ID=17 AND URL LIKE '%../Employee/MyDocument.aspx%'
		     
		     		IF ISNULL(@Percentage,0)=100
		     		BEGIN
		     			SET @RTN_LINK_HTML = @RTN_LINK_HTML + '<div style="padding:5px 10px" class="col-sm-6"><a id="lnkMyDocument" href="'+@Url+'" class="btn btn-success btn-ToDO btn-sm" title="Green indicates: Completed Activities">'+@UrlAliase+'</a></div>'
		     		END
		     		ELSE
		     		BEGIN
		     			SET @RTN_LINK_HTML = @RTN_LINK_HTML + '<div style="padding:5px 10px" class="col-sm-6"><a id="lnkMyDocument" href="'+@Url+'" class="btn btn-gradient btn-ToDO btn-sm" title="Red indicates Pending Activities">'+@UrlAliase+'</a></div>'
		     		END
		     	
		     	End
			--******************************************************************************************************



			--******************************************************************************************************
				SELECT @IsPersonalDetailUpdated=SUM(X.DateOfJoining + X.Grade + X.FathersName + X.CountryName + X.EmployeePhone + X.EmployeeEmail + X.EmployeeAddress + X.PANNumber + X.Department + X.ResidentialStatus +X.[Location] + X.Insider + X.SBU --+ X.WardNumber 
				+ X.Entity + X.COST_CENTER + X.TAX_IDENTIFIER_COUNTRY + X.TAX_IDENTIFIER_STATE + X.EmployeeDesignation + X.BROKER_DEP_TRUST_CMP_NAME + X.BROKER_DEP_TRUST_CMP_ID + X.BROKER_ELECT_ACC_NUM + X.DPRecord + X.DepositoryName + X.DematAccountType + X.DepositoryParticipantNo + X.DepositoryIDNumber + X.ClientIDNumber )
				FROM 
				(
						SELECT
						CASE WHEN LEN(ISNULL(DateOfJoining,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='DateOfJoining' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=0  THEN 1
						WHEN LEN(ISNULL(DateOfJoining,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='DateOfJoining' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS DateOfJoining,

						CASE WHEN LEN(ISNULL(Grade,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='Grade' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=0  THEN 1
						WHEN LEN(ISNULL(Grade,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='Grade' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS Grade,

						CASE WHEN LEN(ISNULL(FathersName,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='FathersName' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=0  THEN 1
						WHEN LEN(ISNULL(FathersName,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='FathersName' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS FathersName,

						CASE WHEN LEN(ISNULL(CountryName,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='CountryName' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=0  THEN 1
						WHEN LEN(ISNULL(CountryName,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='CountryName' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS CountryName,

						CASE WHEN LEN(ISNULL(EmployeePhone,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='EmployeePhone' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=0  THEN 1
						WHEN LEN(ISNULL(EmployeePhone,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='EmployeePhone' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS EmployeePhone,

						CASE WHEN LEN(ISNULL(EmployeeEmail,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='EmployeeEmail' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=0  THEN 1
						WHEN LEN(ISNULL(EmployeeEmail,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='EmployeeEmail' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS EmployeeEmail,

						CASE WHEN LEN(ISNULL(EmployeeAddress,''))=0 AND  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='EmployeeAddress' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=0  THEN 1
						WHEN LEN(ISNULL(EmployeeAddress,''))=0 AND  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='EmployeeAddress' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS EmployeeAddress,

						CASE WHEN LEN(ISNULL(PANNumber,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='PANNumber' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=0  THEN 1
						WHEN LEN(ISNULL(PANNumber,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='PANNumber' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS PANNumber,

						CASE WHEN LEN(ISNULL(Department,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='Department' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=0  THEN 1
						WHEN LEN(ISNULL(Department,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='Department' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS Department,

						CASE WHEN LEN(ISNULL(ResidentialStatus,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='ResidentialStatus' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=0  THEN 1
						WHEN LEN(ISNULL(ResidentialStatus,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='ResidentialStatus' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS ResidentialStatus,

						CASE WHEN LEN(ISNULL([Location],''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='Location' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=0  THEN 1
						WHEN LEN(ISNULL([Location],''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='Location' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS [Location],

						CASE WHEN LEN(ISNULL(Insider,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='Insider' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=0  THEN 1
						WHEN LEN(ISNULL(Insider,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='Insider' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS Insider,

						CASE WHEN LEN(ISNULL(SBU,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='SBU' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=0 THEN 1
						WHEN LEN(ISNULL(SBU,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='SBU' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS SBU,

						--CASE WHEN LEN(ISNULL(WardNumber,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='WardNumber' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0  THEN 1
						--ELSE 0
						--END AS WardNumber,

						CASE WHEN LEN(ISNULL(Entity,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='Entity' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=0 THEN 1
						WHEN LEN(ISNULL(Entity,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='Entity' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS Entity,

						CASE WHEN LEN(ISNULL(COST_CENTER,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE   CPD.Datafield='COST_CENTER' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=0  THEN 1
						WHEN LEN(ISNULL(COST_CENTER,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE   CPD.Datafield='COST_CENTER' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS COST_CENTER,

						CASE WHEN LEN(ISNULL(TAX_IDENTIFIER_COUNTRY,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE   CPD.Datafield='TAX_IDENTIFIER_COUNTRY' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=0  THEN 1
						WHEN LEN(ISNULL(TAX_IDENTIFIER_COUNTRY,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE   CPD.Datafield='TAX_IDENTIFIER_COUNTRY' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS TAX_IDENTIFIER_COUNTRY,

						CASE WHEN LEN(ISNULL(TAX_IDENTIFIER_STATE,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE   CPD.Datafield='TAX_IDENTIFIER_STATE' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=0  THEN 1
						WHEN LEN(ISNULL(TAX_IDENTIFIER_STATE,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE   CPD.Datafield='TAX_IDENTIFIER_STATE' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS TAX_IDENTIFIER_STATE,

						CASE WHEN LEN(ISNULL(EmployeeDesignation,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='EmployeeDesignation' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=0  THEN 1
						WHEN LEN(ISNULL(EmployeeDesignation,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='EmployeeDesignation' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS EmployeeDesignation,

						CASE WHEN LEN(ISNULL(EUB.BROKER_DEP_TRUST_CMP_NAME,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='BROKER_DEP_TRUST_CMP_NAME' AND CPD.CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=0  THEN 1
						WHEN LEN(ISNULL(EUB.BROKER_DEP_TRUST_CMP_NAME,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='BROKER_DEP_TRUST_CMP_NAME' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS BROKER_DEP_TRUST_CMP_NAME,

						CASE WHEN LEN(ISNULL(EUB.BROKER_DEP_TRUST_CMP_ID,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='BROKER_DEP_TRUST_CMP_ID' AND CPD.CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=0  THEN 1
						WHEN LEN(ISNULL(EUB.BROKER_DEP_TRUST_CMP_ID,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='BROKER_DEP_TRUST_CMP_ID' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS BROKER_DEP_TRUST_CMP_ID,

						CASE WHEN LEN(ISNULL(EUB.BROKER_ELECT_ACC_NUM,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='BROKER_ELECT_ACC_NUM' AND CPD.CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=0  THEN 1
						WHEN LEN(ISNULL(EUB.BROKER_ELECT_ACC_NUM,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='BROKER_ELECT_ACC_NUM' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS BROKER_ELECT_ACC_NUM,

						CASE WHEN LEN(ISNULL(EUD.DPRecord,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='DPRecord' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=0  THEN 1
						WHEN LEN(ISNULL(EUD.DPRecord,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='DPRecord' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS DPRecord,

						CASE WHEN LEN(ISNULL(EUD.DepositoryName,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='DepositoryName' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=0  THEN 1
						WHEN LEN(ISNULL(EUD.DepositoryName,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='DepositoryName' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS DepositoryName,

						CASE WHEN LEN(ISNULL(EUD.DematAccountType,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='DematAccountType' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=0  THEN 1
						WHEN LEN(ISNULL(EUD.DematAccountType,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='DematAccountType' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS DematAccountType,

						CASE WHEN LEN(ISNULL(EUD.DepositoryParticipantName,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='DepositoryParticipantNo' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=0  THEN 1
						WHEN LEN(ISNULL(EUD.DepositoryParticipantName,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='DepositoryParticipantNo' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS DepositoryParticipantNo,

						CASE WHEN LEN(ISNULL(EUD.DepositoryIDNumber,''))=0 AND ISNULL(EUD.DepositoryIDNumber,'')='N' AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='DepositoryIDNumber' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=0  THEN 1
						WHEN LEN(ISNULL(EUD.DepositoryIDNumber,''))=0 AND ISNULL(EUD.DepositoryIDNumber,'')='N' AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='DepositoryIDNumber' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS DepositoryIDNumber,

						CASE WHEN LEN(ISNULL(EUD.ClientIDNumber,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='ClientIDNumber' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=0  THEN 1
						WHEN LEN(ISNULL(EUD.ClientIDNumber,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='ClientIDNumber' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL)>0 AND @IS_ADR_ENABLED=1  THEN 1
						ELSE 0
						END AS ClientIDNumber


				FROM EmployeeMaster EM
				LEFT JOIN Employee_UserBrokerDetails EUB ON EM.EmployeeID=EUB.EMPLOYEE_ID AND ISNULL(EUB.IS_ACTIVE,0)=1
				LEFT JOIN Employee_UserDematDetails EUD ON EM.EmployeeID=EUD.EmployeeID AND ISNULL(EUD.IsActive,0)=1
				WHERE EM.EmployeeID=@USER_ID
				
				)X

				SELECT @UrlAliase=URL_ALIASE,@Url=[URL]
				FROM DASHBOARD_WIDGETS_URLS_MAPPING
				WHERE CONTROL_MASTER_ID=17 AND ISNULL(ISACTIVE,0)=1 AND URL LIKE '%../Employee/UserProfile.aspx%'

				IF @IsPersonalDetailUpdated=0
				BEGIN
					--SELECT @URLPersonalDetailUpdated=Url_ID
					--FROM DASHBOARD_WIDGETS_URLS_MAPPING
					--WHERE CONTROL_MASTER_ID=17 AND URL LIKE '%../Employee/UserProfile.aspx%'

					SET @RTN_LINK_HTML = @RTN_LINK_HTML + '<div style="padding:5px 10px" class="col-sm-6"><a id="lnkProfile" href="'+@Url+'" class="btn btn-success btn-ToDO btn-sm" title="Green indicates: Completed Activities">'+@UrlAliase+'</a></div>'

				END
				ELSE
				BEGIN

					SET @RTN_LINK_HTML = @RTN_LINK_HTML + '<div style="padding:5px 10px" class="col-sm-6"><a id="lnkProfile" href="'+@Url+'" class="btn btn-gradient btn-ToDO btn-sm" title="Red indicates Pending Activities">'+@UrlAliase+'</a></div>'

				END
			
		--******************************************************************************************************
		---***********************IF Pending Grant Acceptance then exclude from result**************************
			SELECT @PendingAcceptGrantCnt=COUNT(*) FROM GrantAccMassUpload WHERE EmployeeID=@USER_ID AND ISNULL(LetterAcceptanceStatus,'')='P' AND CONVERT(DATE,LASTACCEPTANCEDATE) >= CONVERT(DATE,GETDATE())

			SELECT @UrlAliase=URL_ALIASE,@Url=[URL]
			FROM DASHBOARD_WIDGETS_URLS_MAPPING
			WHERE CONTROL_MASTER_ID=17 AND ISNULL(ISACTIVE,0)=1 AND URL LIKE '%../Employee/OnlineGrants.aspx%'

			IF  @IS_EGRANTS_ENABLED=1
			BEGIN
				IF @PendingAcceptGrantCnt=0
				BEGIN
					SET @RTN_LINK_HTML = @RTN_LINK_HTML + '<div style="padding:5px 10px" class="col-sm-6"><a id="lnkOGA" href="'+@Url+'" class="btn btn-success btn-ToDO btn-sm" title="Green indicates: Completed Activities">'+@UrlAliase+'</a></div>'
				END
				ELSE
				BEGIN
					SET @RTN_LINK_HTML = @RTN_LINK_HTML + '<div style="padding:5px 10px" class="col-sm-6"><a id="lnkOGA" href="'+@Url+'" class="btn btn-gradient btn-ToDO btn-sm" title="Red indicates Pending Activities">'+@UrlAliase+'</a></div>'
				END
			END
			
		END
		---*************************************************
		
		DECLARE DB_CURSOR CURSOR FOR 
		SELECT Url_ID,Url_Aliase,Url
		FROM DASHBOARD_WIDGETS_URLS_MAPPING
		WHERE CONTROL_MASTER_ID=@CONTROLMASTERID AND ISNULL(ISACTIVE,0)=1-- AND @CONTROLMASTERID=18 --AND Url_ID NOT IN(@UrlIDNominee,@UrlIDAcceptGrant,@URLPersonalDetailUpdated)

		OPEN db_cursor  
		FETCH NEXT FROM DB_CURSOR INTO @UrlID,@UrlAliase,@Url

		WHILE @@FETCH_STATUS = 0  
		BEGIN  
			--IF @CONTROLMASTERID=17
			--BEGIN
			--	SET @RTN_LINK_HTML=REPLACE(REPLACE(@RTN_LINK_HTML,'@UrlAliase',@UrlAliase),'@Url',@Url)
				
			--END
			
			IF @CONTROLMASTERID=18
			BEGIN
				SET @RTN_LINK_HTML =@RTN_LINK_HTML+'<div class="col-sm-12"><a id="lnkQP'+CAST(@CNT AS VARCHAR)+'" href="'+ @Url +'" class="btn btn-sm btn-QuickPick">'+@UrlAliase+'</a></div>'
			END

			SET @CNT=@CNT+1;

		FETCH NEXT FROM db_cursor INTO @UrlID,@UrlAliase,@Url 
		END 
		CLOSE db_cursor  
		DEALLOCATE db_cursor 
		
		
		IF @CONTROLMASTERID=17
		BEGIN
			IF LEN(@RTN_LINK_HTML)=0
			BEGIN
				SET @RTN_LINK_HTML='<div class="col-sm-12"><div><h5>Data not available.</h5></div></div>'
				
			END
		END
		ELSE
		BEGIN
			IF LEN(@RTN_LINK_HTML)=0
			BEGIN
				SET @RTN_LINK_HTML='<div class="col-sm-12"><div><h5>Data not available.</h5></div></div>'
			END
		END

		RETURN @RTN_LINK_HTML
END
GO
