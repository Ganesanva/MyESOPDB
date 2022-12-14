/****** Object:  StoredProcedure [dbo].[PROC_CRUD_EMPLOYEE_CONSENT]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CRUD_EMPLOYEE_CONSENT]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CRUD_EMPLOYEE_CONSENT]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_CRUD_EMPLOYEE_CONSENT]
	@EmployeeID		VARCHAR(20),
	@Action         VARCHAR(10),
	@retValue		INT OUTPUT  
AS
BEGIN
	IF(@Action = 'R')
	BEGIN
		IF EXISTS(SELECT 1 FROM CompanyConsent WHERE EmployeeID = @EmployeeID)
		BEGIN
			SET @retValue = 1
		END
		ELSE
		BEGIN
			SET @retValue = 0
		END
	END
	ELSE IF (@Action = 'A')
	BEGIN
		IF NOT EXISTS(SELECT 1 FROM CompanyConsent WHERE EmployeeID = @EmployeeID)
		BEGIN
			INSERT INTO CompanyConsent
			(
				EmployeeID, AcceptanceDate, LastUpdatedBy, LastUpdatedOn
			)
			VALUES
			(
				@EmployeeID, GETDATE(), @EmployeeID, GETDATE()
			)
			SET @retValue = 1
		END
		
		/*save eula acceptance*/
		IF EXISTS (SELECT 1 FROM CompanyMaster where IS_EULA_SET=1)
		BEGIN
			IF EXISTS (SELECT 1 FROM UPLOADDETAILS UD INNER JOIN CATEGORYMASTER CM ON CM.CATEGORYID = UD.CATEGORYID AND UD.ISDELETED = '0'
						WHERE CM.CATEGORYID = (SELECT CATEGORYID FROM CATEGORYMASTER WHERE CATEGORYNAME='EULA'))
				BEGIN
					IF NOT EXISTS(SELECT 1 FROM EULA_ACCEPTANCE WHERE EmployeeID = @EmployeeID)
					BEGIN	
						/*(EmployeeID, Acceptance_Date, Category, CREATED_BY, CREATED_ON, UPDATED_BY, UPDATED_ON)*/
						INSERT INTO EULA_ACCEPTANCE
						SELECT @EmployeeID, GETDATE(),'EULA', @EmployeeID, GETDATE(), @EmployeeID, GETDATE()						
						SET @retValue = 1
					END
				END
		END
	END
	
	SELECT @retValue
END
GO
