DROP PROCEDURE IF EXISTS [dbo].[PROC_CHK_PERSONAL_DETAILS_CONFIG_CASHLESS_811]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CHK_PERSONAL_DETAILS_CONFIG_CASHLESS_811]    Script Date: 18-07-2022 12:25:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PROC_CHK_PERSONAL_DETAILS_CONFIG_CASHLESS_811] 
@loginid VARCHAR(100), 
@companyid VARCHAR(100),
@MessageOut VARCHAR(1000) OUTPUT,
@IsADSType BIT
As
BEGIN
	DECLARE @datafield VARCHAR(50)
	DECLARE @Employeefield VARCHAR(50)
	DECLARE @datavalue varchar(500)
	DECLARE @cur cursor 
	DECLARE @Message varchar(1000)
	DECLARE @STR NVARCHAR(2000)
	DECLARE @MINIDT INT,
			@MAXIDT INT
	
	CREATE TABLE #TEMP (IDT INT IDENTITY(1,1), DATAFIELD VARCHAR(500), EMPLOYEEFIELD VARCHAR(500))
	
	SET @Message = ''
	IF (@IsADSType = 1)
	BEGIN
		SET @STR=N'INSERT INTO #TEMP (DATAFIELD, EMPLOYEEFIELD) SELECT CASE WHEN(DATAFIELD=''BROKER_DEP_TRUST_CMP_NAME'') THEN ''EUBD.''+Datafield 
	WHEN(DATAFIELD=''BROKER_DEP_TRUST_CMP_ID'') THEN ''EUBD.''+Datafield
	WHEN(DATAFIELD=''BROKER_ELECT_ACC_NUM'') THEN ''EUBD.''+Datafield 
	WHEN(DATAFIELD=''DPRecord'') THEN ''EUDD.''+Datafield
	WHEN(DATAFIELD=''DepositoryName'') THEN ''EUDD.''+Datafield
	WHEN(DATAFIELD=''DematAccountType'') THEN ''EUDD.''+Datafield
	WHEN(DATAFIELD=''DepositoryParticipantNo'') THEN ''EUDD.DepositoryParticipantName''
	WHEN(DATAFIELD=''DepositoryIDNumber'') THEN ''EUDD.''+Datafield
	WHEN(DATAFIELD=''ClientIDNumber'') THEN ''EUDD.''+Datafield ELSE Datafield END  AS Datafield,EmployeeField FROM ConfigurePersonalDetails WHERE  MIT_ID is null AND ADS_Check_Exercise = '+ char(39) + 'Y' + char(39)
	END
	ELSE
	BEGIN
		SET @STR=N'INSERT INTO #TEMP (DATAFIELD, EMPLOYEEFIELD) SELECT  CASE WHEN(DATAFIELD=''BROKER_DEP_TRUST_CMP_NAME'') THEN ''EUBD.''+Datafield 
	WHEN(DATAFIELD=''BROKER_DEP_TRUST_CMP_ID'') THEN ''EUBD.''+Datafield
	WHEN(DATAFIELD=''BROKER_ELECT_ACC_NUM'') THEN ''EUBD.''+Datafield 
	WHEN(DATAFIELD=''DPRecord'') THEN ''EUDD.''+Datafield
	WHEN(DATAFIELD=''DepositoryName'') THEN ''EUDD.''+Datafield
	WHEN(DATAFIELD=''DematAccountType'') THEN ''EUDD.''+Datafield
	WHEN(DATAFIELD=''DepositoryParticipantNo'') THEN ''EUDD.DepositoryParticipantName''
	WHEN(DATAFIELD=''DepositoryIDNumber'') THEN ''EUDD.''+Datafield
	WHEN(DATAFIELD=''ClientIDNumber'') THEN ''EUDD.''+Datafield 
	ELSE Datafield END  AS Datafield,EmployeeField FROM CONFIGUREPERSONALDETAILS WHERE  MIT_ID is null AND Check_Exercise='+ char(39)+  'Y' +char(39)
	END
	--Print @STR
	EXEC (@STR)
	
	/*select * from #TEMP*/
	SELECT @MINIDT = MIN(IDT), @MAXIDT = MAX(IDT) FROM #TEMP
	DECLARE @DEPOSITORYNAME VARCHAR(20)
	SET @DEPOSITORYNAME = ''
	DECLARE @DEPOSITORYNUM VARCHAR(20)
	SET @DEPOSITORYNUM = ''
	WHILE @MINIDT <= @MAXIDT
	BEGIN
		SELECT @datafield = DATAFIELD, @Employeefield = EMPLOYEEFIELD FROM #TEMP WHERE IDT = @MINIDT
		
		SELECT @STR=N'SELECT @datavalue = ' + @datafield + ' FROM employeemaster  Left join Employee_UserDematDetails EUDD ON EUDD.EmployeeID=employeemaster.EmployeeID AND EUDD.IsActive=1 Left join Employee_UserBrokerDetails EUBD ON EUBD.EMPLOYEE_ID=employeemaster.EmployeeID AND EUBD.IS_ACTIVE=1 WHERE employeemaster.Deleted = 0 AND LoginID = ' + CHAR(39) + @loginid + CHAR(39)
		
		EXEC sp_executesql @STR, N'@datavalue varchar(max) output', @datavalue output
		
		
		IF @DATAFIELD= 'EUDD.DepositoryName' --'DepositoryName'
		BEGIN 
		
			IF @DATAVALUE='C' 
			BEGIN
				SET @DEPOSITORYNAME = 'C'
			END
			IF @DATAVALUE='N' 
			BEGIN
				SET @DEPOSITORYNUM = 'N'
			END

		END		
		
        IF (@DATAVALUE IS NULL OR @DATAVALUE='')
		BEGIN
			IF (@DATAFIELD='DepositoryIDNumber' OR @DEPOSITORYNAME ='C')
			BEGIN
				SET @STR = N'SELECT @DEPOSITORYNAME = EUDD.DepositoryName FROM employeemaster EM Inner join Employee_UserDematDetails EUDD ON EUDD.EmployeeID=EM.EmployeeID AND EUDD.IsActive=1 WHERE employeemaster.Deleted = 0 AND LoginID = ' + CHAR(39) + @loginid + CHAR(39)
				Print @STR
				EXEC sp_executesql @STR, N'@DEPOSITORYNAME varchar(max) output', @DEPOSITORYNAME output
				IF @DEPOSITORYNAME = 'C' 
					PRINT 'SKIP'
				ELSE
					SET @MESSAGE=@MESSAGE + @DATAFIELD + ','
				
			END
			ELSE IF(@DATAFIELD='DepositoryName' OR @DEPOSITORYNUM='N')
			BEGIN
						
				/*PRINT 'SKIP'				*/
				SET @MESSAGE=@MESSAGE + @EMPLOYEEFIELD + ','
				
			END
			ELSE
			BEGIN
				
				SET @MESSAGE=@MESSAGE + @EMPLOYEEFIELD + ','
			END
			
		END

		IF @DATAFIELD='DateOfJoining'
		BEGIN 
		
			IF ( CONVERT(VARCHAR(10), Convert(DateTime,@DATAVALUE), 101) = '01/01/1900') 
			BEGIN
				SET @MESSAGE = @MESSAGE + @EMPLOYEEFIELD + ','
			END
		END 
		 
		SET @MINIDT = @MINIDT + 1
	END	

	--==Demat/Broker Validation By Personal details configuration
	IF(ISNULL(@Message,'') <> '')
	BEGIN
		SET @MESSAGE ='Please update '+ @Message
	END
	
	--==Demat Validation By CR [Valid/Invalid - Approve]
	IF(ISNULL(@Message,'') = '' AND @IsADSType <> 1)
	BEGIN
		DECLARE @IS_DEMAT_VALIDATION BIT
		DECLARE @ApproveStatus VARCHAR(5)
		SELECT @IS_DEMAT_VALIDATION = IsDematValidation FROM DematConfiguration
		SELECT @ApproveStatus = ApproveStatus FROM Employee_UserDematDetails EU INNER JOIN EmployeeMaster EM ON EU.EmployeeId = EM.EmployeeID WHERE EM.LoginId=@LoginId AND Deleted =0 AND EU.IsActive=1
		IF(@IS_DEMAT_VALIDATION = 1 AND @ApproveStatus = 'P')
		BEGIN
			SET @Message ='';
		    SET @Message = 'Demat details as updated in not validated. Please contact the administrator for same.'
		END
	END
	
	IF @Message <> ''
	BEGIN
		IF RIGHT(@Message, 1) = ','
		BEGIN
			SET @Message = LEFT(@Message, LEN(@Message) - 1)
		END
	END
	SET @MessageOut = @Message
END
GO


