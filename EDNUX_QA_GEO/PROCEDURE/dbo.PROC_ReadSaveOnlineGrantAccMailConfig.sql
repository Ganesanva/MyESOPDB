/****** Object:  StoredProcedure [dbo].[PROC_ReadSaveOnlineGrantAccMailConfig]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_ReadSaveOnlineGrantAccMailConfig]
GO
/****** Object:  StoredProcedure [dbo].[PROC_ReadSaveOnlineGrantAccMailConfig]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_ReadSaveOnlineGrantAccMailConfig]
(
	@IsReminderMail BIT = NULL,
	@DaysBefore VARCHAR(5) = NULL,
	@IsTillLastDate BIT = NULL,
	@UpdatedBy VARCHAR(50) = NULL,
	@Case VARCHAR(15)
)
AS  
BEGIN
	SET NOCOUNT ON;
	IF (UPPER(@Case)='UPDATE_DATA')
	BEGIN  
	
		UPDATE OnlineGrantAccMailConfig 
		SET 
			IsReminderMail = @IsReminderMail, 
			DaysBefore = @DaysBefore, 
			IsTillLastDate = @IsTillLastDate, 
			LastUpdatedOn = GETDATE(), 
			LastUpdatedBy = @UpdatedBy 
		WHERE OGAMCID = 1
		
		IF (@@ROWCOUNT > 0)
		BEGIN
			-- Maintain Audit trail.
			INSERT INTO OnlineGrantAccMailConfigAuditTrail 
				(IsReminderMail, DaysBefore, IsTillLastDate, LastUpdatedOn, LastUpdatedBy)
			VALUES 
				(@IsReminderMail,@DaysBefore,@IsTillLastDate,GETDATE(),@UpdatedBy)
			
			RETURN 1
		END
		
		ELSE
		BEGIN
			RETURN 0
		END
	END
	
	ELSE IF(UPPER(@Case)='READ_DATA')
	BEGIN
		SELECT IsReminderMail, DaysBefore, IsTillLastDate FROM OnlineGrantAccMailConfig
	END
	
END
GO
