/****** Object:  StoredProcedure [dbo].[PROC_SOPsUI_UPDATE_GRANT_EXPIRY_DETAILS]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SOPsUI_UPDATE_GRANT_EXPIRY_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SOPsUI_UPDATE_GRANT_EXPIRY_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_SOPsUI_UPDATE_GRANT_EXPIRY_DETAILS] 
	
	@GRANT_OPTION_ID NVARCHAR(100),
	@GRANT_LEG_ID NVARCHAR(10),
	@VESTING_TYPE NVARCHAR(1),
	@EXPIRY_DATE DATE,
	@LAST_UPDATED_BY NVARCHAR(100),
	@TEMPLATE_NAME NVARCHAR(100)
AS
BEGIN

	SET NOCOUNT ON;
	
	BEGIN TRY

		BEGIN TRANSACTION
		
		UPDATE 
			GrantLeg SET FinalExpirayDate = @EXPIRY_DATE, LastUpdatedBy = @LAST_UPDATED_BY, LastUpdatedOn = GETDATE()
		WHERE 
			(GrantOptionId = @GRANT_OPTION_ID) AND (CONVERT(VARCHAR(10), GrantLegId) = @GRANT_LEG_ID) AND (VestingType = @VESTING_TYPE)

		INSERT INTO AUDIT_SOPs_UI 
			(TEMPLATE_NAME, UPDATED_BY, UPDATED_ON, UNIQUE_IDENTIFIER_TEXT, UNIQUE_IDENTIFIER_VALE, COMMAND_EXECUATED, COMMAND_PARAMETER)
		VALUES
			(@TEMPLATE_NAME, @LAST_UPDATED_BY, GETDATE(), 'Grant Option Id, Grant Leg ID', @GRANT_OPTION_ID +', '+@GRANT_LEG_ID, 'PROC_SOPsUI_UPDATE_GRANT_EXPIRY_DETAILS', '@GRANT_OPTION_ID, @GRANT_LEG_ID, @VESTING_TYPE, @EXPIRY_DATE, @LAST_UPDATED_BY, @TEMPLATE_NAME')
				 
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
