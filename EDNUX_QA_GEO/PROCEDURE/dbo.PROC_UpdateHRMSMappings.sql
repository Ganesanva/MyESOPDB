/****** Object:  StoredProcedure [dbo].[PROC_UpdateHRMSMappings]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UpdateHRMSMappings]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UpdateHRMSMappings]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PROC_UpdateHRMSMappings]
	@MAPPING_TYPE				AS VARCHAR(15),
	@HRMSMappingsFldID			AS INT,
	@MyESOPsFldVal 				AS VARCHAR(100), 
	@MyESOPsActualFldVal 		AS VARCHAR(100), 
	@InputFldVal 				AS VARCHAR(100), 
	@IsAuditMaintained 			AS BIT,
	@IsDeleted					AS BIT,
	@CreatedBy					AS VARCHAR(50), 
	@UpdatedBy					AS VARCHAR(50)
AS
BEGIN

	IF(UPPER(@MAPPING_TYPE) = 'MAPPINGTYPEFLD')	
	BEGIN
		IF(@IsDeleted = 1)
		BEGIN
			DELETE FROM HRMSMappingsFields WHERE MyESOPsFields = @MyESOPsFldVal AND InputFields = @InputFldVal
		END
		
		ELSE
		BEGIN
			IF EXISTS(SELECT HRMSMappingsFldID FROM HRMSMappingsFields WHERE MyESOPsFields = @MyESOPsFldVal AND InputFields = @InputFldVal)
			BEGIN
				
				IF((SELECT IsAuditMaintained FROM HRMSMappingsFields WHERE MyESOPsFields = @MyESOPsFldVal AND InputFields = @InputFldVal) <> @IsAuditMaintained)
				BEGIN
					UPDATE HRMSMappingsFields 
					SET 
							IsAuditMaintained = @IsAuditMaintained,
							UpdatedBy = @UpdatedBy,
							UpdatedOn = GETDATE() + 1
					WHERE 
						MyESOPsFields = @MyESOPsFldVal AND 
						InputFields = @InputFldVal
				END
			END
			
			ELSE
			BEGIN
				INSERT INTO HRMSMappingsFields 
					(MyESOPsFields, InputFields, IsAuditMaintained, CreatedBy, CreatedOn, UpdatedBy, UpdatedOn)
				VALUES
					(@MyESOPsFldVal, @InputFldVal, @IsAuditMaintained, @CreatedBy, GETDATE(), @UpdatedBy, GETDATE() + 1)
			END
		END
	END
	
	ELSE IF(UPPER(@MAPPING_TYPE) = 'MAPPINGTYPEVAL')	
	BEGIN
		IF(@IsDeleted = 1)
		BEGIN
			DELETE FROM HRMSMappingsValues WHERE HRMSMappingsFldID = @HRMSMappingsFldID AND MyESOPsValue = @MyESOPsFldVal AND InputValue = @InputFldVal
		END
		
		ELSE
		BEGIN
			DECLARE @HRMSMappingsValID AS INT
			SET @HRMSMappingsValID = 0;
			SET @HRMSMappingsValID = (SELECT HRMSMappingsValID FROM HRMSMappingsValues WHERE HRMSMappingsFldID = @HRMSMappingsFldID AND MyESOPsValue = @MyESOPsFldVal AND InputValue = @InputFldVal) 
			
			IF (@HRMSMappingsValID > 0)
			BEGIN
				UPDATE HRMSMappingsValues 
				SET 
					HRMSMappingsFldID = @HRMSMappingsFldID,
					MyESOPsValue = @MyESOPsFldVal,
					MyESOPsActualMappedValue = @MyESOPsActualFldVal,
					InputValue = @InputFldVal,
					UpdatedBy = @UpdatedBy,
					UpdatedOn = GETDATE()
				WHERE 
					HRMSMappingsValID = @HRMSMappingsValID
					
			END
			
			ELSE
			BEGIN
				INSERT INTO HRMSMappingsValues
					(HRMSMappingsFldID, MyESOPsValue, MyESOPsActualMappedValue, InputValue, CreatedBy, CreatedOn, UpdatedBy, UpdatedOn)
				VALUES
					(@HRMSMappingsFldID, @MyESOPsFldVal, @MyESOPsActualFldVal, @InputFldVal, @CreatedBy, GETDATE(), @UpdatedBy, GETDATE()) 
			END
			
		END	
		
		
	END
END
GO
