/****** Object:  StoredProcedure [dbo].[PROC_SOPsUI_UPATE_BROKER_DETAILS]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [PROC_SOPsUI_UPATE_BROKER_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SOPsUI_UPATE_BROKER_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [PROC_SOPsUI_UPATE_BROKER_DETAILS] 
	
	@EMPLOYEE_ID NVARCHAR(100),
	@BROKER_DEP_TRUST_CMP_NAME NVARCHAR(100),
	@BROKER_DEP_TRUST_CMP_ID NVARCHAR(100),
	@BROKER_ELECT_ACC_NUMBER NVARCHAR(100),
	@ACTIVE NVARCHAR (10),
	@LAST_UPDATED_BY NVARCHAR(100),
	@TEMPLATE_NAME NVARCHAR(100)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	BEGIN TRY

		BEGIN TRANSACTION

		UPDATE 
			Employee_UserBrokerDetails 
		SET 
			BROKER_DEP_TRUST_CMP_NAME = @BROKER_DEP_TRUST_CMP_NAME, BROKER_DEP_TRUST_CMP_ID = @BROKER_DEP_TRUST_CMP_ID, 
			BROKER_ELECT_ACC_NUM = @BROKER_ELECT_ACC_NUMBER, 
			IS_ACTIVE = (CASE WHEN UPPER(@ACTIVE) = 'Y' THEN 1 WHEN UPPER(@ACTIVE) = 'N' THEN 0 ELSE NULL END),
			UPDATED_BY = @LAST_UPDATED_BY, UPDATED_ON = GETDATE() 
		WHERE 
			EMPLOYEE_ID = @EMPLOYEE_ID
		
		INSERT INTO AUDIT_SOPs_UI 
			(TEMPLATE_NAME, UPDATED_BY, UPDATED_ON, UNIQUE_IDENTIFIER_TEXT, UNIQUE_IDENTIFIER_VALE, COMMAND_EXECUATED, COMMAND_PARAMETER)
		VALUES
			(@TEMPLATE_NAME, @LAST_UPDATED_BY, GETDATE(), 'Employee ID', @EMPLOYEE_ID, 'PROC_SOPsUI_UPATE_BROKER_DETAILS', '@EXERCISED_ID, @BROKER_DEP_TRUST_CMP_NAME, @BROKER_DEP_TRUST_CMP_ID, @BROKER_ELECT_ACC_NUMBER, @LAST_UPDATED_BY, @TEMPLATE_NAME')
		
		COMMIT TRANSACTION

		SELECT 'SUCCESS' AS 'ErrorMessage'

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SELECT @@ERROR AS 'ErrorMessage'
	END CATCH

	SET NOCOUNT OFF;				
END
GO
