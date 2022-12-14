/****** Object:  StoredProcedure [dbo].[PROC_CRUD_HRMSSETTINGS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CRUD_HRMSSETTINGS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CRUD_HRMSSETTINGS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_CRUD_HRMSSETTINGS]
	@Action AS CHAR(1),
	@UniqueIdentifier AS VARCHAR(20)=Null,
	@AlertBeforeNoOfDaysForPerfVesting AS VARCHAR(10)=Null,
	@UpdatedBy AS NVARCHAR(50)=Null
	
AS
BEGIN
	IF (@Action = 'U')
	BEGIN
			
		UPDATE	HRMSSettings				
		SET		[UniqueIdentifier] = @UniqueIdentifier, 
				AlertBeforeNoOfDaysForPerfVesting = @AlertBeforeNoOfDaysForPerfVesting,
				UpdatedBy = @UpdatedBy,
				UpdatedOn  = GETDATE()
	END 
	ELSE IF (@Action = 'R')
	BEGIN
		SELECT 
			HRMSSettingsID,
			[UniqueIdentifier],
			AlertBeforeNoOfDaysForPerfVesting 
		FROM 
			HRMSSettings
	END 
END
GO
