/****** Object:  StoredProcedure [dbo].[PROC_EmpAlert_MandatoryFields]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_EmpAlert_MandatoryFields]
GO
/****** Object:  StoredProcedure [dbo].[PROC_EmpAlert_MandatoryFields]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_EmpAlert_MandatoryFields]
	
	@TYPE				VARCHAR(20),
	@IS_MAIL_SEND		BIT =0,
	@REMINDER_DAYS		INT =0,
	@LAST_UPDATED_BY	VARCHAR(100)=NULL
	
AS
BEGIN
	
	IF(@TYPE='INSERT_DATA')
	BEGIN
	
		INSERT INTO EmployeeAlert_MandatoryFields (IS_SEND_MAIL_ALERT,REMINDER_DAYS,LAST_UPDATED_BY,LAST_UPDATED_ON) VALUES (@IS_MAIL_SEND,@REMINDER_DAYS,@LAST_UPDATED_BY,GETDATE())
		
		IF(@@ERROR > 0)
		BEGIN
			DECLARE @MSG VARCHAR(300)
			SET @MSG= 'Error occurred while inserting record.'
		END
		ELSE
		BEGIN
			SET @MSG='Data saved successfully.'
		END
			SELECT @MSG AS Result
	END
	
	IF(@TYPE='READ') 
	BEGIN
		SELECT IS_SEND_MAIL_ALERT,REMINDER_DAYS FROM EMPLOYEEALERT_MANDATORYFIELDS WHERE EAMF_ID=(SELECT MAX(EAMF_ID) FROM EmployeeAlert_MandatoryFields)
	END
	

	
END
GO
