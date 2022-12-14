/****** Object:  StoredProcedure [dbo].[PROC_SOPsUI_UPDATE_BANK_NAME]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SOPsUI_UPDATE_BANK_NAME]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SOPsUI_UPDATE_BANK_NAME]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_SOPsUI_UPDATE_BANK_NAME] 
	
	@EXERCISE_NUMBER NVARCHAR(100),
	@BANK_ID NVARCHAR(100),	
	@LAST_UPDATED_BY NVARCHAR(100),
	@TEMPLATE_NAME NVARCHAR(100)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	BEGIN TRY

		BEGIN TRANSACTION
		
		UPDATE 
			Transaction_Details 
		SET 
			bankid = @BANK_ID, LastUpdatedBy = @LAST_UPDATED_BY, LastUpdated = GETDATE() 
		WHERE 
			Sh_ExerciseNo = @EXERCISE_NUMBER
		
		INSERT INTO AUDIT_SOPs_UI 
			(TEMPLATE_NAME, UPDATED_BY, UPDATED_ON, UNIQUE_IDENTIFIER_TEXT, UNIQUE_IDENTIFIER_VALE, COMMAND_EXECUATED, COMMAND_PARAMETER)
		VALUES
			(@TEMPLATE_NAME, @LAST_UPDATED_BY, GETDATE(), 'Exercise Number', @EXERCISE_NUMBER, 'PROC_SOPsUI_UPDATE_BANK_NAME', '@EXERCISE_NUMBER, @BANK_ID, @LAST_UPDATED_BY, @TEMPLATE_NAME')
		
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
