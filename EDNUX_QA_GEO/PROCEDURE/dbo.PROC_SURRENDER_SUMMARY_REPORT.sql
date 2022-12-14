/****** Object:  StoredProcedure [dbo].[PROC_SURRENDER_SUMMARY_REPORT]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SURRENDER_SUMMARY_REPORT]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SURRENDER_SUMMARY_REPORT]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_SURRENDER_SUMMARY_REPORT]	
	@ACTION	CHAR(50),
	@EMPLOYEE_ID AS VARCHAR(50) = '',
	@APPLICATION_DATE AS VARCHAR(20) = ''
	
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY

		--CR LOGIN FILTER FOR EMPID
		IF @ACTION = 'CR_F_EMPID'
		BEGIN
			SELECT '---All Employees---' EmployeeID UNION
			SELECT DISTINCT EmployeeID FROM BuyBackOptions ORDER BY EmployeeID
		END

		--CR LOGIN FILTER FOR APPLICATION DATE
		ELSE IF @ACTION = 'CR_F_APPLN_DATE'
		BEGIN
			SELECT '---All---' ApplicationDate UNION
			SELECT DISTINCT REPLACE(CONVERT(VARCHAR(12), ApplicationDate, 106),' ','/') ApplicationDate FROM BuyBackOptions
		END

		--READ FOR CR LOGIN
		ELSE IF @ACTION = 'CR_R'
		BEGIN
			DECLARE @WHERE_CLAUSE VARCHAR(500)
			SET @WHERE_CLAUSE = ''

			IF (@EMPLOYEE_ID <> '' AND @EMPLOYEE_ID <> '---All Employees---')
				SET @WHERE_CLAUSE = ' AND BBO.EmployeeID =' + CHAR(39) + @EMPLOYEE_ID + CHAR(39)

			IF (@APPLICATION_DATE <> '' AND @APPLICATION_DATE <> '---All---')
				SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' AND CONVERT(DATE, BBO.ApplicationDate) =' + CHAR(39) + CONVERT(VARCHAR(15), CONVERT(DATE, @APPLICATION_DATE)) + CHAR(39)
			
			
			PRINT @WHERE_CLAUSE
			EXEC('
			SELECT 
				EM.EmployeeName, EM.EmployeeAddress, ISNULL(EM.Mobile,'''') AS Mobile, ISNULL(EM.LWD, '''') AS LWD, 
				BBO.ApplicationID, BBO.EmployeeID, BBO.EmployeeStatus, BBO.ApplicationDate, BBO.NoOfOptionsApplied, 
				CONVERT(NUMERIC(18,2), BBO.SettlementPrice) AS SettlementPrice, CONVERT(NUMERIC(18,2), BBO.GrossValuePayable) AS GrossValuePayable, 
				BBO.NameInBankRecord, BBO.BankName, BBO.BankAddress, BBO.BankAccountNumber, BBO.BankIFSCCode, 
				BBO.PANNumber, BBO.AadhaarNumber, BBO.IsFileUploaded 
			FROM 
				BuyBackOptions BBO 
				INNER JOIN EmployeeMaster EM ON EM.EmployeeID = BBO.EmployeeID WHERE EM.Deleted = 0 ' 
			+ @WHERE_CLAUSE)
		END

	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE()
	END CATCH
	
	SET NOCOUNT OFF;
END
GO
