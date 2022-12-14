/****** Object:  StoredProcedure [dbo].[PROC_CRUD_BuyBackOptions]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CRUD_BuyBackOptions]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CRUD_BuyBackOptions]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_CRUD_BuyBackOptions]	
	@TYPE_CRUD_BuyBackOptions		dbo.TYPE_CRUD_BuyBackOptions READONLY
	
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE 
			@ACTION AS CHAR(50),
			@ApplicationID AS INT

		SET @ApplicationID = -1
		SELECT @ACTION = [ACTION] FROM @TYPE_CRUD_BuyBackOptions

		--CREATE
		IF (@ACTION  = 'C')
		BEGIN
			SELECT @ApplicationID = ISNULL(MAX(ApplicationID),0) + 1 FROM BuyBackOptions
			INSERT INTO BuyBackOptions 
			(
				ApplicationID, EmployeeID, EmployeeStatus, ApplicationDate, NoOfOptionsApplied, SettlementPrice, GrossValuePayable, 
				NameInBankRecord, BankName, BankAddress, BankAccountNumber, BankIFSCCode, PANNumber, AadhaarNumber, 
				CreatedBy, CreatedOn, UpdatedBy, UpdatedOn
			)
				SELECT @ApplicationID, EmployeeID, EmployeeStatus, ApplicationDate, NoOfOptionsApplied, SettlementPrice, GrossValuePayable, 
				NameInBankRecord, BankName, BankAddress, BankAccountNumber, BankIFSCCode, PANNumber, AadhaarNumber, 
				UpdatedBy, UpdatedOn, UpdatedBy, UpdatedOn FROM @TYPE_CRUD_BuyBackOptions 
			
			EXEC ('SELECT * FROM BuyBackOptions WHERE ApplicationID = ' + @ApplicationID)
		END

		--UPDATE
		ELSE IF @ACTION = 'U'
		BEGIN
			SELECT @ApplicationID = ApplicationID FROM @TYPE_CRUD_BuyBackOptions

			UPDATE 
				BBO
			SET 
				BBO.NameInBankRecord = TBBO.NameInBankRecord, 
				BBO.BankName = TBBO.BankName, 
				BBO.BankAddress = TBBO.BankAddress, 
				BBO.BankAccountNumber = TBBO.BankAccountNumber, 
				BBO.BankIFSCCode = TBBO.BankIFSCCode, 
				BBO.PANNumber = TBBO.PANNumber, 
				BBO.AadhaarNumber = TBBO.AadhaarNumber, 
				BBO.UpdatedBy = TBBO.UpdatedBy, 
				BBO.UpdatedOn = GETDATE()
			FROM 
				BuyBackOptions BBO INNER JOIN @TYPE_CRUD_BuyBackOptions TBBO ON TBBO.ApplicationID = BBO.ApplicationID
			WHERE 
				BBO.ApplicationID = @ApplicationID
		END

		--READ FOR EMPLOYEE LOGIN
		ELSE IF @ACTION = 'EMP_R_Config'
		BEGIN
			DECLARE 
				@EmployeeStatus		AS VARCHAR(15),
				@SQL_QUERY			AS VARCHAR(500)

			SELECT @EmployeeStatus = UPPER(EmployeeStatus) FROM @TYPE_CRUD_BuyBackOptions
			
			SELECT * FROM BuyBackConfigurations

			SET @SQL_QUERY = ' SELECT ''Application Form'' AS TextField, ''Application Form'' AS ValueField '

			IF (@EmployeeStatus = 'SEPARATED')
			SET @SQL_QUERY = @SQL_QUERY + ' UNION ' + 
					' SELECT ''PAN Card'' AS TextField, ''PAN Card'' AS ValueField UNION
					SELECT ''Aadhaar Card'' AS TextField, ''Aadhaar Card'' AS ValueField UNION
					SELECT ''Cancelled Cheque'' AS TextField, ''Cancelled Cheque'' AS ValueField '
			EXEC (@SQL_QUERY)
		END

		--READ FOR EMPLOYEE LOGIN based on Applition ID
		ELSE IF @ACTION = 'EMP_R_ApplnNoWise'
		BEGIN
			SELECT @ApplicationID = ApplicationID FROM @TYPE_CRUD_BuyBackOptions

			SELECT 
				EM.EmployeeName, EM.EmployeeAddress, ISNULL(EM.Mobile,'') AS Mobile, ISNULL(REPLACE(CONVERT(VARCHAR(15), EM.LWD, 106),' ','/'),'') AS LWD, 
				BBO.ApplicationID, BBO.EmployeeID, BBO.EmployeeStatus, BBO.ApplicationDate, BBO.NoOfOptionsApplied, 
				CONVERT(NUMERIC(18,2), BBO.SettlementPrice) AS SettlementPrice, CONVERT(NUMERIC(18,2), BBO.GrossValuePayable) AS GrossValuePayable, 
				BBO.NameInBankRecord, BBO.BankName, BBO.BankAddress, BBO.BankAccountNumber, BBO.BankIFSCCode, 
				BBO.PANNumber, BBO.AadhaarNumber 
			FROM 
				BuyBackOptions BBO INNER JOIN @TYPE_CRUD_BuyBackOptions TBBO ON TBBO.ApplicationID = BBO.ApplicationID
				INNER JOIN EmployeeMaster EM ON EM.EmployeeID = BBO.EmployeeID WHERE EM.Deleted = 0
		END

		--READ FOR EMPLOYEE LOGIN to get all of that rescpective Emp ID
		ELSE IF @ACTION = 'EMP_R_EmpWise'
		BEGIN			
			SELECT BBO.* FROM BuyBackOptions BBO INNER JOIN @TYPE_CRUD_BuyBackOptions TBBO ON BBO.EmployeeID = TBBO.EmployeeID;
		END

		--UPDATE FILE UPLOAD
		ELSE IF @ACTION = 'EMP_FILE_UPLOAD'
		BEGIN
			SELECT @ApplicationID = ApplicationID FROM @TYPE_CRUD_BuyBackOptions

			IF (@ApplicationID = 0)
			BEGIN
				UPDATE 
					BBO
				SET 
					BBO.IsFileUploaded = Convert(BIT, TBBO.IsFileUploaded)
				FROM 
					BuyBackOptions BBO INNER JOIN @TYPE_CRUD_BuyBackOptions TBBO ON TBBO.EmployeeID = BBO.EmployeeID
			END
							
			ELSE
			BEGIN
				UPDATE 
					BBO
				SET 
					BBO.IsFileUploaded = Convert(BIT, TBBO.IsFileUploaded)
				FROM 
					BuyBackOptions BBO INNER JOIN @TYPE_CRUD_BuyBackOptions TBBO ON TBBO.ApplicationID = BBO.ApplicationID
				WHERE 
					BBO.ApplicationID = @ApplicationID
			END
		END

		--CR LOGIN FILTER FOR EMPID
		ELSE IF @ACTION = 'CR_F_EMPID'
		BEGIN
			SELECT DISTINCT EmployeeID FROM BuyBackOptions ORDER BY EmployeeID
		END

		--CR LOGIN FILTER FOR APPLICATION DATE
		ELSE IF @ACTION = 'CR_F_APPLN_DATE'
		BEGIN
			SELECT DISTINCT ApplicationDate FROM BuyBackOptions ORDER BY ApplicationDate
		END

		--READ FOR CR LOGIN
		ELSE IF @ACTION = 'CR_R'
		BEGIN
			SELECT 
				EM.EmployeeName, EM.EmployeeAddress, ISNULL(EM.Mobile,'') AS Mobile, ISNULL(EM.LWD, '') AS LWD, 
				BBO.ApplicationID, BBO.EmployeeID, BBO.EmployeeStatus, BBO.ApplicationDate, BBO.NoOfOptionsApplied, 
				CONVERT(NUMERIC(18,2), BBO.SettlementPrice) AS SettlementPrice, CONVERT(NUMERIC(18,2), BBO.GrossValuePayable) AS GrossValuePayable, 
				BBO.NameInBankRecord, BBO.BankName, BBO.BankAddress, BBO.BankAccountNumber, BBO.BankIFSCCode, 
				BBO.PANNumber, BBO.AadhaarNumber 
			FROM 
				BuyBackOptions BBO 
				INNER JOIN EmployeeMaster EM ON EM.EmployeeID = BBO.EmployeeID WHERE EM.Deleted = 0
		END

		--READ EX FORM TEXT1,2 AND 3
		ELSE IF @ACTION = 'EX_FORM_TEXT'
		BEGIN
			SELECT * FROM ResidentialPaymentMode RPM INNER JOIN PaymentMaster PM ON PM.Id = RPM.PaymentMaster_Id WHERE PM.PayModeName = 'Buy Back/Surrender'
		END

	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE()
	END CATCH
	
	SET NOCOUNT OFF;
END
GO
