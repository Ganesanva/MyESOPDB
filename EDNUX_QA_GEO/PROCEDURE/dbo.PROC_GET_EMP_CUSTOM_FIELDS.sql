/****** Object:  StoredProcedure [dbo].[PROC_GET_EMP_CUSTOM_FIELDS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_EMP_CUSTOM_FIELDS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_EMP_CUSTOM_FIELDS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_EMP_CUSTOM_FIELDS]
	@PARAM 	NVARCHAR(20) 	= NULL,
	@ID		INT 			= NULL
AS

BEGIN
	
	SET NOCOUNT ON;

	IF(@PARAM = 'ALL_CUST_FIELDS')
	BEGIN
		SELECT 
			ECF_ID, FIELD_NAME 
		FROM 
			EMP_CUSTOM_FIELDS
	END
	
	ELSE IF(@PARAM = 'SEL_CUST_FIELDS')
	BEGIN
		SELECT 
			EmployeeField, Datafield, DISPLAY_NAME 
		FROM 
			ConfigurePersonalDetails 
		WHERE 
			ID = @ID
	END
	
	SET NOCOUNT OFF;
END
GO
