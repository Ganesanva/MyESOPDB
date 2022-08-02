DROP PROCEDURE [dbo].[PROC_GET_PAYMENT_MODES]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PROC_GET_PAYMENT_MODES] 
(
	 @LoginID			NVARCHAR(100), 
	 @MIT_ID			INT,
	 @PaymentType		NVARCHAR(MAX),
	 @ResidentType		NVARCHAR(10),
	 @GRANT_DATE		DATETIME = NULL,
	 @VESTING_DATE		DATETIME = NULL,
	 @EXERCISE_DATE		DateTime = NULL ,
	 @ExerciseNo		INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @PaymentTypeID NVARCHAR(MAX)
	    
	SET @PaymentTypeID  = (CASE 
								WHEN UPPER(@PaymentType) = 'CASH' THEN '3' 
								WHEN UPPER(@PaymentType) = 'CASH AND CASHLESS' THEN '3,9,10'  
								WHEN UPPER(@PaymentType) = 'CASHLESS' THEN '9,10' 
						  END)

	DECLARE @PAYMENTMODE_BASED_ON NVARCHAR(50)	
	SELECT @PAYMENTMODE_BASED_ON = PAYMENTMODE_BASED_ON FROM COMPANY_INSTRUMENT_MAPPING WHERE MIT_ID = @MIT_ID		
	
	DECLARE @IsDematEnable BIT
        SET @IsDematEnable = (SELECT 1 FROM COMPANY_INSTRUMENT_MAPPING WHERE IsActivatedAccount = 'D' and MIT_ID = @MIT_ID)	
	
	CREATE TABLE #TblEXERCISE_DETAILS
	(
		SR_NO				INT IDENTITY(1,1),
		EXERCISE_NO			INT,
		GRANT_DATE			DATETIME,
		VESTING_DATE		DATETIME,
		EXERCISE_DATE		DATETIME
	)
	/*Print @PAYMENTMODE_BASED_ON*/
	IF (UPPER(@PAYMENTMODE_BASED_ON) = 'RDOCOUNTRY')
	BEGIN	
			/* Get Grant Date,Vesting Date,Exercise Date From Exercise No*/			
			IF(@ExerciseNo IS NOT NULL)
			BEGIN
				INSERT INTO #TblEXERCISE_DETAILS
				(EXERCISE_NO, GRANT_DATE, VESTING_DATE, EXERCISE_DATE)
				SELECT SH.ExerciseNo, GR.GrantDate,GL.FinalVestingDate,sh.ExerciseDate
				FROM ShExercisedOptions SH INNER JOIN GrantLeg GL
				ON GL.ID=SH.GrantLegSerialNumber
				INNER JOIN GrantRegistration GR ON GR.GrantRegistrationId=GL.GrantRegistrationId
				WHERE SH.ExerciseNo=@ExerciseNo
								
				SELECT TOP(1) @GRANT_DATE=GRANT_DATE,@VESTING_DATE=VESTING_DATE,@EXERCISE_DATE=EXERCISE_DATE
				FROM #TblEXERCISE_DETAILS
			END
			ELSE
			BEGIN
				INSERT INTO #TblEXERCISE_DETAILS
				(GRANT_DATE, VESTING_DATE, EXERCISE_DATE)
				SELECT @GRANT_DATE, @VESTING_DATE, @EXERCISE_DATE
			END
	
	        DECLARE @Emp_ID NVARCHAR(50), @Country_ID NVARCHAR(50)
	        
			SELECT @Emp_ID=EmployeeID FROM EmployeeMaster WHERE LoginID=@LoginID
			
			/* Change for  event of incidence*/
			DECLARE @Event_OF_INCIDENCE_ID NVARCHAR(50)
			DECLARE @Country_Name NVARCHAR(250)	
			DECLARE @EventOfIncidence NVARCHAR(50)	
			DECLARE @INCIDENCEDATE DATETIME
			DECLARE @SR_NO INT, @TOTAL_ROWS INT
			DECLARE @SQL_QUERY AS VARCHAR(MAX)
			CREATE TABLE #TblEVENT_OF_INCIDENCE
			(
				EVENTOFINCIDENCE INT
			)
			
			SELECT @TOTAL_ROWS = MAX(SR_NO) FROM #TblEXERCISE_DETAILS
			SET @SR_NO = 1		
			SET @SQL_QUERY = ''
			WHILE @SR_NO <= @TOTAL_ROWS
			BEGIN
				IF(@ExerciseNo IS NOT NULL)
				BEGIN
					SELECT 
						@EXERCISE_DATE = EXERCISE_DATE,
						@GRANT_DATE = GRANT_DATE,
						@VESTING_DATE = VESTING_DATE,
						@EXERCISE_DATE = EXERCISE_DATE
					FROM 
						#TblEXERCISE_DETAILS WHERE SR_NO = @SR_NO
				END
				
				SELECT @Event_OF_INCIDENCE_ID =dbo.FN_GET_EVENTOFINCIDENCE(@MIT_ID,@EXERCISE_DATE)										
				SELECT @EventOfIncidence = CODE_NAME FROM MST_COM_CODE  WHERE MCC_ID = @Event_OF_INCIDENCE_ID
				

				IF(@EventOfIncidence = 'Grant Date')    
					SET  @INCIDENCEDATE = @GRANT_DATE                 
				ELSE IF(@EventOfIncidence = 'Vesting Date')     
					SET  @INCIDENCEDATE = @VESTING_DATE    
				ELSE IF(@EventOfIncidence = 'Exercise Date')    
					SET  @INCIDENCEDATE = @EXERCISE_DATE
				
				IF EXISTS(SELECT * FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD WHERE EmployeeId=@LoginID AND UPPER(Field) =UPPER('Tax Identifier Country') AND [From Date of Movement] <= CONVERT(date, @INCIDENCEDATE))
				BEGIN
					SELECT @Country_ID=ID FROM CountryMaster
					WHERE CountryName in(SELECT top(1) [Moved To] FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD WHERE EmployeeId=@LoginID AND UPPER(Field) =UPPER('Tax Identifier Country') AND [From Date of Movement] <= CONVERT(date, @INCIDENCEDATE) ORDER BY SRNO DESC )		
				END
				ELSE
				BEGIN					
					SELECT @Country_ID=ID FROM CountryMaster
					WHERE CountryAliasName in(SELECT CountryName FROM EmployeeMaster WHERE EmployeeId=@LoginID )		
				END
				
				IF LEN(@SQL_QUERY) > 0
				BEGIN
					SET @SQL_QUERY = @SQL_QUERY + ' INTERSECT '
				END
		
				SET @SQL_QUERY = @SQL_QUERY + 
				'
				SELECT 
					PaymentMaster.PaymentMode,PaymentMaster.Parentid,PaymentMaster.PayModeName, ResidentialType.ResidentialStatus, ResidentialPaymentMode.ProcessNote, ResidentialPaymentMode.isActivated ,PaymentMaster.Id,,MST_PAYMENT_MODE_DISCLAIMER.DisclaimerNote,
					MST_PAYMENT_MODE_DISCLAIMER.ActualDisclaimerText,MST_PAYMENT_MODE_DISCLAIMER.TentativeDisclaimerText,MST_PAYMENT_MODE_DISCLAIMER.Is_ShowPaymentConfirmRecipt,MST_PAYMENT_MODE_DISCLAIMER.Is_ShowTaxConfirmRecipt,ResidentialPaymentMode.DECLARATION,
					MCC.MCC_ID,MCC.CODE_NAME
					,ISNULL(IsValidatedDematAcc, 0) AS IsValidatedDematAcc, ISNULL(IsValidatedBankAcc, 0) AS IsValidatedBankAcc,  ResidentialPaymentMode.MIT_ID,ResidentialPaymentMode.IsOneProcessFlow, ISNULL(IsUpdatedDematAcc, 0) AS IsUpdatedDematAcc,Acknowledgement
					,(CASE WHEN @IsDematEnable = ''1'' AND ISNULL(MST_PAYMENT_MODE_DISCLAIMER.Is_ShowCMLCopy,0) = 1 THEN 1 ELSE 0 END) AS Is_ShowCMLCopy
				FROM 
					ResidentialPaymentMode 					
					INNER JOIN ResidentialType ON ResidentialPaymentMode.ResidentialType_Id = ResidentialType.id 
					INNER JOIN PaymentMaster ON ResidentialPaymentMode.PaymentMaster_Id = PaymentMaster.Id 
					INNER JOIN COUNTRY_PAYMENTMODE_MAPPING CPM ON CPM.RPM_ID=ResidentialPaymentMode.id AND CPM.COUNTRY_ID=' + @Country_ID + '
					AND ResidentialPaymentMode.isactivated = ''Y'' 
					AND ResidentialPaymentMode.MIT_ID=' + CONVERT(VARCHAR(5), @MIT_ID) + ' and CPM.ACTIVE=1
					LEFT JOIN MST_PAYMENT_MODE_DISCLAIMER ON ResidentialPaymentMode.Id=MST_PAYMENT_MODE_DISCLAIMER.RPMID
					LEFT JOIN MST_COM_CODE MCC ON MCC.MCCG_ID=ISNULL(ResidentialPaymentMode.DYNAMIC_FORM,1048) AND MCC.MCCG_ID=111
				WHERE 
					isActivated=''Y'' and ResidentialPaymentMode.MIT_ID = ' + CONVERT(VARCHAR(5), @MIT_ID) + '
				'
				SET @SR_NO = @SR_NO + 1
				
			END
			
			EXEC(@SQL_QUERY)
	END
	ELSE IF (UPPER(@PAYMENTMODE_BASED_ON) = 'RDORESIDENTSTATUS')
	BEGIN	
		
			
		
		IF EXISTS(SELECT PaymentMaster.PaymentMode, PaymentMaster.Id
				FROM ResidentialPaymentMode 
					INNER JOIN ResidentialType ON ResidentialPaymentMode.ResidentialType_Id = ResidentialType.id  AND ResidentialType.ResidentialStatus=@ResidentType
					INNER JOIN PaymentMaster ON ResidentialPaymentMode.PaymentMaster_Id = PaymentMaster.Id
					LEFT JOIN MST_PAYMENT_MODE_DISCLAIMER ON ResidentialPaymentMode.Id=MST_PAYMENT_MODE_DISCLAIMER.RPMID 
				WHERE 
				ResidentialType.ResidentialStatus= @ResidentType and isActivated='Y' and ResidentialPaymentMode.MIT_ID = @MIT_ID AND PAYMENT_MODE_CONFIG_TYPE = 'RESIDENT'																		
			)
		BEGIN
			
				SELECT  PaymentMaster.PaymentMode,PaymentMaster.Parentid,PaymentMaster.PayModeName, ResidentialType.ResidentialStatus, ResidentialPaymentMode.ProcessNote, ResidentialPaymentMode.isActivated,PaymentMaster.Id ,MST_PAYMENT_MODE_DISCLAIMER.DisclaimerNote,
						MST_PAYMENT_MODE_DISCLAIMER.ActualDisclaimerText,MST_PAYMENT_MODE_DISCLAIMER.TentativeDisclaimerText,MST_PAYMENT_MODE_DISCLAIMER.Is_ShowPaymentConfirmRecipt,MST_PAYMENT_MODE_DISCLAIMER.Is_ShowTaxConfirmRecipt,ResidentialPaymentMode.DECLARATION
						,MCC.MCC_ID,MCC.CODE_NAME
						,ISNULL(IsValidatedDematAcc, 0) AS IsValidatedDematAcc, ISNULL(IsValidatedBankAcc, 0) AS IsValidatedBankAcc, ResidentialPaymentMode.MIT_ID,ResidentialPaymentMode.IsOneProcessFlow,  ISNULL(IsUpdatedDematAcc, 0) AS IsUpdatedDematAcc,Acknowledgement
						,Cast((CASE WHEN @IsDematEnable = 1 AND ISNULL(MST_PAYMENT_MODE_DISCLAIMER.Is_ShowCMLCopy,0) = 1 THEN 1 ELSE 0 END) as bit)AS Is_ShowCMLCopy
				FROM  ResidentialPaymentMode 
					  INNER JOIN ResidentialType ON ResidentialPaymentMode.ResidentialType_Id = ResidentialType.id  AND ResidentialType.ResidentialStatus=@ResidentType
					  INNER JOIN PaymentMaster ON ResidentialPaymentMode.PaymentMaster_Id = PaymentMaster.Id 
					  LEFT JOIN MST_PAYMENT_MODE_DISCLAIMER ON ResidentialPaymentMode.Id=MST_PAYMENT_MODE_DISCLAIMER.RPMID
					  LEFT JOIN MST_COM_CODE MCC ON MCC.MCCG_ID=ISNULL(ResidentialPaymentMode.DYNAMIC_FORM,1048) AND MCC.MCCG_ID=111
				WHERE 
					ResidentialType.ResidentialStatus= @ResidentType and isActivated='Y' and ResidentialPaymentMode.MIT_ID = @MIT_ID AND PAYMENT_MODE_CONFIG_TYPE = 'RESIDENT'																		
		
		END
		ELSE
		BEGIN
			-- Company Level
			SELECT 
			PaymentMaster.PaymentMode,PaymentMaster.Parentid,PaymentMaster.PayModeName, 'Company' AS ResidentialStatus, ResidentialPaymentMode.ProcessNote, ResidentialPaymentMode.isActivated ,PaymentMaster.Id,MST_PAYMENT_MODE_DISCLAIMER.DisclaimerNote,
			MST_PAYMENT_MODE_DISCLAIMER.ActualDisclaimerText,MST_PAYMENT_MODE_DISCLAIMER.TentativeDisclaimerText,MST_PAYMENT_MODE_DISCLAIMER.Is_ShowPaymentConfirmRecipt,MST_PAYMENT_MODE_DISCLAIMER.Is_ShowTaxConfirmRecipt,ResidentialPaymentMode.DECLARATION
			,MCC.MCC_ID,MCC.CODE_NAME
			,ISNULL(IsValidatedDematAcc, 0) AS IsValidatedDematAcc, ISNULL(IsValidatedBankAcc, 0) AS IsValidatedBankAcc, ResidentialPaymentMode.MIT_ID,ResidentialPaymentMode.IsOneProcessFlow, ISNULL(IsUpdatedDematAcc, 0) AS IsUpdatedDematAcc,Acknowledgement
			,Cast((CASE WHEN @IsDematEnable = 1 AND ISNULL(MST_PAYMENT_MODE_DISCLAIMER.Is_ShowCMLCopy,0) = 1 THEN 1 ELSE 0 END) as bit) AS Is_ShowCMLCopy
			FROM  ResidentialPaymentMode 
			--INNER JOIN ResidentialType ON ResidentialPaymentMode.ResidentialType_Id = ResidentialType.id 
			INNER JOIN PaymentMaster ON ResidentialPaymentMode.PaymentMaster_Id = PaymentMaster.Id 
			LEFT JOIN MST_PAYMENT_MODE_DISCLAIMER ON ResidentialPaymentMode.Id=MST_PAYMENT_MODE_DISCLAIMER.RPMID
			LEFT JOIN MST_COM_CODE MCC ON MCC.MCCG_ID=ISNULL(ResidentialPaymentMode.DYNAMIC_FORM,1048) AND MCC.MCCG_ID=111
			WHERE 
			 isActivated='Y' and ResidentialPaymentMode.MIT_ID = @MIT_ID AND PAYMENT_MODE_CONFIG_TYPE = 'COMPANY'
		
		END
		/*
		SELECT 
			PaymentMaster.PaymentMode,PaymentMaster.Parentid,PaymentMaster.PayModeName, ResidentialType.ResidentialStatus, ResidentialPaymentMode.ProcessNote, ResidentialPaymentMode.isActivated 
		FROM  ResidentialPaymentMode 
			INNER JOIN ResidentialType ON ResidentialPaymentMode.ResidentialType_Id = ResidentialType.id 
			INNER JOIN PaymentMaster ON ResidentialPaymentMode.PaymentMaster_Id = PaymentMaster.Id 
		WHERE 
			ResidentialType.ResidentialStatus= @ResidentType and isActivated='Y' and ResidentialPaymentMode.MIT_ID = @MIT_ID AND PAYMENT_MODE_CONFIG_TYPE = 'RESIDENT'																		
			*/
	END
	ELSE
	BEGIN	
		SELECT 
			PaymentMaster.PaymentMode,PaymentMaster.Parentid,PaymentMaster.PayModeName, 'Company' AS ResidentialStatus, ResidentialPaymentMode.ProcessNote, ResidentialPaymentMode.isActivated ,PaymentMaster.Id,MST_PAYMENT_MODE_DISCLAIMER.DisclaimerNote,
			MST_PAYMENT_MODE_DISCLAIMER.ActualDisclaimerText,MST_PAYMENT_MODE_DISCLAIMER.TentativeDisclaimerText,MST_PAYMENT_MODE_DISCLAIMER.Is_ShowPaymentConfirmRecipt,MST_PAYMENT_MODE_DISCLAIMER.Is_ShowTaxConfirmRecipt,ResidentialPaymentMode.DECLARATION
			,MCC.MCC_ID,MCC.CODE_NAME
			,ISNULL(IsValidatedDematAcc, 0) AS IsValidatedDematAcc, ISNULL(IsValidatedBankAcc, 0) AS IsValidatedBankAcc, ResidentialPaymentMode.MIT_ID,ResidentialPaymentMode.IsOneProcessFlow, ISNULL(IsUpdatedDematAcc, 0) AS IsUpdatedDematAcc,Acknowledgement
		        ,Cast((CASE WHEN @IsDematEnable = 1 AND ISNULL(MST_PAYMENT_MODE_DISCLAIMER.Is_ShowCMLCopy,0) = 1 THEN 1 ELSE 0 END) as bit) AS Is_ShowCMLCopy
		FROM  ResidentialPaymentMode 
			--INNER JOIN ResidentialType ON ResidentialPaymentMode.ResidentialType_Id = ResidentialType.id 
			INNER JOIN PaymentMaster ON ResidentialPaymentMode.PaymentMaster_Id = PaymentMaster.Id 
			LEFT JOIN MST_PAYMENT_MODE_DISCLAIMER ON ResidentialPaymentMode.Id=MST_PAYMENT_MODE_DISCLAIMER.RPMID
			LEFT JOIN MST_COM_CODE MCC ON MCC.MCCG_ID=ISNULL(ResidentialPaymentMode.DYNAMIC_FORM,1048) AND MCC.MCCG_ID=111
		WHERE 
			 isActivated='Y' and ResidentialPaymentMode.MIT_ID = @MIT_ID AND PAYMENT_MODE_CONFIG_TYPE = 'COMPANY'
	END
	SET NOCOUNT OFF;
END

GO


