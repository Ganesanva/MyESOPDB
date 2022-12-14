/****** Object:  StoredProcedure [dbo].[PROC_VALIDATE_PAYMENT_MODES]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_VALIDATE_PAYMENT_MODES]
GO
/****** Object:  StoredProcedure [dbo].[PROC_VALIDATE_PAYMENT_MODES]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_VALIDATE_PAYMENT_MODES]
(
	 @PYMENTMODE_DETAILS   dbo.TYPE_PYMENTMODE_DETAILS READONLY
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @LOGIN_ID	NVARCHAR(100), @MIT_ID	INT,@PAYMENTTYPE NVARCHAR(MAX),@RESIDENTTYPE NVARCHAR(10),
	@GRANT_DATE DATETIME ,@VESTING_DATE DATETIME ,@EXERCISE_DATE DateTime ,@PaymentTypeID NVARCHAR(MAX)
	
	CREATE TABLE #TblEXERCISE_DETAILS
	(
		SR_NO				INT IDENTITY(1,1),
		LOGIN_ID			NVARCHAR(100),
		MIT_ID				BIGINT,
		PAYMENTTYPE			NVARCHAR(MAX),
		RESIDENTTYPE		NVARCHAR(MAX),
		GRANT_DATE			DATETIME,
		VESTING_DATE		DATETIME,
		EXERCISE_DATE		DATETIME
	)
	
	CREATE TABLE #TblEVENT_OF_INCIDENCE
	(
		SR_NO			 INT IDENTITY(1,1),
		EVENTOFINCIDENCE INT
	)
	
	INSERT INTO #TblEXERCISE_DETAILS (LOGIN_ID,MIT_ID,PAYMENTTYPE,RESIDENTTYPE, GRANT_DATE, VESTING_DATE, EXERCISE_DATE)
	SELECT LOGIN_ID,MIT_ID,PAYMENTTYPE,RESIDENTTYPE, GRANT_DATE, VESTING_DATE, EXERCISE_DATE
	FROM @PYMENTMODE_DETAILS
	--Select * From #TblEXERCISE_DETAILS
	DECLARE @SR_NO INT, @TOTAL_ROWS INT ,@SQL_QUERY AS VARCHAR(MAX)
	SELECT @TOTAL_ROWS = MAX(SR_NO) FROM #TblEXERCISE_DETAILS
			SET @SR_NO = 1		
			SET @SQL_QUERY = ''
			
	WHILE @SR_NO <= @TOTAL_ROWS
	BEGIN
		
		SELECT	
				@LOGIN_ID		=LOGIN_ID,
				@MIT_ID			=MIT_ID,
				@PAYMENTTYPE	=PAYMENTTYPE,
				@RESIDENTTYPE	=RESIDENTTYPE,
				@EXERCISE_DATE	= EXERCISE_DATE,
				@GRANT_DATE		= GRANT_DATE,
				@VESTING_DATE	= VESTING_DATE,
				@EXERCISE_DATE	= EXERCISE_DATE
		FROM 
				#TblEXERCISE_DETAILS WHERE SR_NO = @SR_NO
					
		DECLARE @PAYMENTMODE_BASED_ON NVARCHAR(50)
				SELECT @PAYMENTMODE_BASED_ON = PAYMENTMODE_BASED_ON FROM COMPANY_INSTRUMENT_MAPPING WHERE MIT_ID = @MIT_ID
				
		IF (@PAYMENTMODE_BASED_ON = 'RDOCOUNTRY')
		BEGIN	
				
			/* Change for  event of incidence*/
				DECLARE @Event_OF_INCIDENCE_ID NVARCHAR(50)
				DECLARE @Country_Name NVARCHAR(250)	
				DECLARE @EventOfIncidence NVARCHAR(50)	
				DECLARE @INCIDENCEDATE DATETIME
																
				DECLARE @Emp_ID NVARCHAR(50), @Country_ID NVARCHAR(50)	        
				SELECT @Emp_ID=EmployeeID FROM EmployeeMaster WHERE LOGINID=@Login_ID
				INSERT INTO #TblEVENT_OF_INCIDENCE (EVENTOFINCIDENCE)
				EXEC PROC_GET_EVENTOFINCIDENCE @MIT_ID,@EXERCISE_DATE
				SELECT @Event_OF_INCIDENCE_ID =EVENTOFINCIDENCE FROM #TblEVENT_OF_INCIDENCE	
				WHERE  SR_NO = @SR_NO		 
				SELECT @EventOfIncidence = CODE_NAME FROM MST_COM_CODE  WHERE MCC_ID = @Event_OF_INCIDENCE_ID	
				
				print @EventOfIncidence
				
				IF(@EventOfIncidence = 'Grant Date')    
					SET  @INCIDENCEDATE = @GRANT_DATE                 
				ELSE IF(@EventOfIncidence = 'Vesting Date')     
					SET  @INCIDENCEDATE = @VESTING_DATE    
				ELSE IF(@EventOfIncidence = 'Exercise Date')    
					SET  @INCIDENCEDATE = @EXERCISE_DATE
				--select @INCIDENCEDATE as incidence
				print @INCIDENCEDATE
				print @Emp_ID
				IF EXISTS(SELECT * FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD WHERE EmployeeId=@Emp_ID AND UPPER(Field) =UPPER('Tax Identifier Country') AND [From Date of Movement] <= CONVERT(date, @INCIDENCEDATE))
				BEGIN
				
					
					SELECT @Country_ID=ID FROM CountryMaster
					WHERE CountryName IN(SELECT TOP(1) [Moved To] FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD WHERE EmployeeId=@Emp_ID AND UPPER(Field) =UPPER('Tax Identifier Country') AND [From Date of Movement] <= CONVERT(date, @INCIDENCEDATE) ORDER BY SRNO DESC )		
					
					
				END
				ELSE
				BEGIN	
								
					SELECT @Country_ID=ID FROM CountryMaster
					WHERE CountryAliasName in(SELECT CountryName FROM EmployeeMaster WHERE EmployeeId=@Emp_ID )		
				END
				
				print @Country_ID
				IF LEN(@SQL_QUERY) > 0
				BEGIN
					SET @SQL_QUERY = @SQL_QUERY + ' INTERSECT '
				END
		
				SET @SQL_QUERY = @SQL_QUERY + 
				'
				SELECT 
					PaymentMaster.PaymentMode,PaymentMaster.Parentid,PaymentMaster.PayModeName, ResidentialType.ResidentialStatus, ResidentialPaymentMode.ProcessNote, ResidentialPaymentMode.isActivated
					,ISNULL(ResidentialPaymentMode.IsValidatedDematAcc,0) AS IsValidatedDematAcc, ISNULL(ResidentialPaymentMode.IsValidatedBankAcc,0) AS IsValidatedBankAcc,ResidentialPaymentMode.DYNAMIC_FORM, PaymentMaster.Id
					,ISNULL(ResidentialPaymentMode.IsUpdatedDematAcc, 0) AS IsUpdatedDematAcc
				FROM 
					ResidentialPaymentMode 
					INNER JOIN ResidentialType ON ResidentialPaymentMode.ResidentialType_Id = ResidentialType.id 
					INNER JOIN PaymentMaster ON ResidentialPaymentMode.PaymentMaster_Id = PaymentMaster.Id 
					INNER JOIN COUNTRY_PAYMENTMODE_MAPPING CPM ON CPM.RPM_ID=ResidentialPaymentMode.id AND CPM.COUNTRY_ID=' + @Country_ID + '
					AND ResidentialPaymentMode.isactivated = ''Y'' 
					AND ResidentialPaymentMode.MIT_ID=' + CONVERT(VARCHAR(5), @MIT_ID) + ' and CPM.ACTIVE=1
				WHERE 
					isActivated=''Y'' and ResidentialPaymentMode.MIT_ID = ' + CONVERT(VARCHAR(5), @MIT_ID) + '
				'
			
	END
	ELSE IF (@PAYMENTMODE_BASED_ON = 'RDORESIDENTSTATUS')
	BEGIN
		
		DECLARE @ResidentStatus NVARCHAR(50)	        
		SELECT @ResidentStatus=ResidentialStatus FROM EmployeeMaster WHERE LOGINID=@Login_ID
		if(isnull(@ResidentStatus,'')='')
		BEGIN
			SET @ResidentStatus='R'
		END

		IF LEN(@SQL_QUERY) > 0
		BEGIN
			SET @SQL_QUERY = @SQL_QUERY + ' INTERSECT '
		END
				
		SET @SQL_QUERY = @SQL_QUERY +
		'
		SELECT 
			PaymentMaster.PaymentMode,PaymentMaster.Parentid,PaymentMaster.PayModeName, CONVERT(NVARCHAR(MAX), ResidentialPaymentMode.ProcessNote) AS ProcessNote, ResidentialPaymentMode.isActivated
			,ISNULL(ResidentialPaymentMode.IsValidatedDematAcc,0) AS IsValidatedDematAcc, ISNULL(ResidentialPaymentMode.IsValidatedBankAcc,0) AS IsValidatedBankAcc,ResidentialPaymentMode.DYNAMIC_FORM, PaymentMaster.Id
			,ISNULL(ResidentialPaymentMode.IsUpdatedDematAcc, 0) AS IsUpdatedDematAcc
		FROM  ResidentialPaymentMode 
			INNER JOIN PaymentMaster ON ResidentialPaymentMode.PaymentMaster_Id = PaymentMaster.Id INNER JOIN ResidentialType RM ON RM.ID=ResidentialPaymentMode.ResidentialType_Id
		WHERE 
			isActivated=''Y'' and ResidentialPaymentMode.MIT_ID = ' + CONVERT(VARCHAR(5), @MIT_ID) + ' AND UPPER(PAYMENT_MODE_CONFIG_TYPE) = ''Resident'' AND RM.ResidentialStatus='''+@ResidentStatus+'''
		'
	
	END
	ELSE
	BEGIN
		IF LEN(@SQL_QUERY) > 0
		BEGIN
			SET @SQL_QUERY = @SQL_QUERY + ' INTERSECT '
		END
				
		SET @SQL_QUERY = @SQL_QUERY +
		'
		SELECT 
			PaymentMaster.PaymentMode,PaymentMaster.Parentid,PaymentMaster.PayModeName, CONVERT(NVARCHAR(MAX), ResidentialPaymentMode.ProcessNote) AS ProcessNote, ResidentialPaymentMode.isActivated
			,ISNULL(ResidentialPaymentMode.IsValidatedDematAcc,0) AS IsValidatedDematAcc, ISNULL(ResidentialPaymentMode.IsValidatedBankAcc,0) AS IsValidatedBankAcc,ResidentialPaymentMode.DYNAMIC_FORM, PaymentMaster.Id
		    ,ISNULL(ResidentialPaymentMode.IsUpdatedDematAcc, 0) AS IsUpdatedDematAcc
		FROM  ResidentialPaymentMode 
			INNER JOIN PaymentMaster ON ResidentialPaymentMode.PaymentMaster_Id = PaymentMaster.Id 
		WHERE 
			isActivated=''Y'' and ResidentialPaymentMode.MIT_ID = ' + CONVERT(VARCHAR(5), @MIT_ID) + ' AND UPPER(PAYMENT_MODE_CONFIG_TYPE) = ''COMPANY''
		'
	END
	
		SET @SR_NO = @SR_NO + 1
	END
	
	/*print 	@SQL_QUERY*/
	EXEC (@SQL_QUERY)
	
	SET NOCOUNT OFF;
END
GO
