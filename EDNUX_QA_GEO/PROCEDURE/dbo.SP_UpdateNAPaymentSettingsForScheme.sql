/****** Object:  StoredProcedure [dbo].[SP_UpdateNAPaymentSettingsForScheme]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_UpdateNAPaymentSettingsForScheme]
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateNAPaymentSettingsForScheme]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_UpdateNAPaymentSettingsForScheme]
(
	@NAPaymentMode NAPaymentModeSettingType READONLY,
	@UserId VARCHAR(50),
	@MIT_ID INT = NULL,
	@Result TINYINT OUTPUT
	
)
AS 
BEGIN
	DECLARE @Min INT,
			@Max INT,
			@SchemeId VARCHAR(50),
			@IsPaymentReqStatus TINYINT,
			@DBIsPaymentReqStatus BIT,
			@Count INT = 0
			
	SELECT @Min=Min(SettingId),@Max=Max(SettingId)  FROM @NAPaymentMode
	-------------------------------------------------------------------
	WHILE(@Min<=@Max)
		BEGIN
			SELECT @SchemeId = SchemeId, @IsPaymentReqStatus = IsPaymentModeRequired FROM @NAPaymentMode WHERE SettingId = @MIN
			SELECT @DBIsPaymentReqStatus = IsPaymentModeRequired FROM Scheme where SchemeId=@SchemeId						
			IF(@DBIsPaymentReqStatus<>@IsPaymentReqStatus)
			BEGIN
				UPDATE SCHEME SET IsPaymentModeRequired = @IsPaymentReqStatus, PaymentModeEffectiveDate = CONVERT(DATE,GETDATE() + 1),LastUpdatedOn=GETDATE(),LastUpdatedBy=@UserId WHERE SchemeId = @SchemeId AND MIT_ID = @MIT_ID 
				SET @Count = @Count + 1
			END
			
			SET @MIN = @MIN + 1
			
		END
	-------------------------------------------------------------------
	IF(@Count > 0)
		BEGIN
			-- RESULT 1 = SUCCESSFUL
			SET @Result = 1	
		END	
	ELSE
		BEGIN
			-- RESULT 2 = UNSUCCESSFUL
			SET @RESULT = 0
		END
END
GO
