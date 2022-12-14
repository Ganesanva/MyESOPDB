/****** Object:  StoredProcedure [dbo].[PROC_CUD_EMP_CONFIG]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CUD_EMP_CONFIG]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CUD_EMP_CONFIG]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_CUD_EMP_CONFIG]
(
	@EmployeeField	VARCHAR (100) = NULL,
	@DataField		VARCHAR (100) = NULL,
	@DISPLAY_NAME	VARCHAR (200) = NULL,
	@Action			VARCHAR (100),
	@ID				INT = NULL,
	@MIT_ID			INT
)
AS

BEGIN
	SET NOCOUNT ON;
	
	IF (UPPER(@Action) = 'UPDATE')
	BEGIN
		UPDATE 
			ConfigurePersonalDetails 
		SET 
			DISPLAY_NAME = @DISPLAY_NAME
		WHERE 
			ID = @ID
		
		if(@@Rowcount>0)
		BEGIN
				Select @ID AS ID,'Updated Successfully.' as MSG
		END
	END	
	
	ELSE IF(UPPER(@Action) = 'ADD')
	BEGIN
		
		IF NOT EXISTS( SELECT EmployeeField FROM configurepersonaldetails WHERE EmployeeField=@EmployeeField  )
		Begin
				INSERT INTO ConfigurePersonalDetails
				(
					EmployeeField,
					Associate_Control,
					DataField,
					DISPLAY_NAME,
					ISEDIT,
					MIT_ID
				)
				VALUES
				(
					@EmployeeField,
					'txt'+@EmployeeField,
					@DataField,
					@DISPLAY_NAME,
					1,
					@MIT_ID
				)
				IF(@@Rowcount>0)
				BEGIN
						SELECT @ID AS ID,'Added Successfully.' as MSG
				END
		END
		ELSE
		BEGIN
		
				SELECT '0' AS ID,'Selected custom field is already being used.' as MSG
		END
	END
	
	ELSE IF(UPPER(@Action) = 'DELETE')
	BEGIN
		DELETE FROM ConfigurePersonalDetails WHERE ID = @ID
		if(@@Rowcount>0)
			BEGIN
					SELECT @ID AS ID,'Deleted Successfully.' as MSG
			END
	END
END
GO
