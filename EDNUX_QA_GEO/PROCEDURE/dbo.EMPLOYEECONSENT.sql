/****** Object:  StoredProcedure [dbo].[EMPLOYEECONSENT]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[EMPLOYEECONSENT]
GO
/****** Object:  StoredProcedure [dbo].[EMPLOYEECONSENT]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[EMPLOYEECONSENT] 
	-- Add the parameters for the stored procedure here
	@EmployeeID		VARCHAR(20),
	@Action         VARCHAR(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @retValue int, @msg NVARCHAR(256), @isConsent int

    IF(@Action = 'R')
		BEGIN

			IF EXISTS(Select 1 from companymaster where IS_CONSENT_SET = 1)
				BEGIN
					SET @isConsent = 1	

					SET @msg = (Select consent_Message from companymaster where IS_CONSENT_SET = 1)

					IF EXISTS(SELECT 1 FROM CompanyConsent WHERE EmployeeID = @EmployeeID)
						BEGIN
							SET @retValue = 0
							SET @msg = ''
						END
					ELSE
						BEGIN
							SET @retValue = 1
						END
				END
			ELSE
				BEGIN
					SET @isConsent = 0
					SET @retValue =0
				END
		END
	ELSE IF (@Action = 'A')
		BEGIN
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
			END
		END
	
	SELECT @retValue AS IsConsent, @msg AS ConsentMsg
END

GO
