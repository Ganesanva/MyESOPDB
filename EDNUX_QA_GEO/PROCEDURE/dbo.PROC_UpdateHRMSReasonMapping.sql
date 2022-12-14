/****** Object:  StoredProcedure [dbo].[PROC_UpdateHRMSReasonMapping]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UpdateHRMSReasonMapping]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UpdateHRMSReasonMapping]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_UpdateHRMSReasonMapping]

	@ExitCode AS VARCHAR(150),
	@ReasonForTermination AS VARCHAR(10),
	@IsSeparatedMark AS TINYINT,
	@IsDeleted AS CHAR,
	@CreatedBy AS VARCHAR(50),
	@UpdatedBy AS VARCHAR(50)
AS
BEGIN
    
	IF(@IsDeleted = 1)
		BEGIN
			--PRINT 'DELETE'
			DELETE FROM HRMSReasonMappings WHERE ExitCode = @ExitCode AND ReasonForTermination = @ReasonForTermination
		END
	ELSE
		BEGIN
			IF EXISTS(SELECT ExitCode, ReasonForTermination FROM HRMSReasonMappings 
					WHERE ExitCode = @ExitCode AND ReasonForTermination = @ReasonForTermination)
				BEGIN
					--PRINT 'UPDATE'
					UPDATE HRMSReasonMappings 
					SET
						ExitCode = @ExitCode, 
						ReasonForTermination = @ReasonForTermination,
						IsSeparatedMark = @IsSeparatedMark,
						UpdatedBy = @UpdatedBy,
						UpdatedOn  = GETDATE(), 
						CreatedOn  = GETDATE()
					WHERE ExitCode = @ExitCode AND ReasonForTermination = @ReasonForTermination 
				END     
			ELSE
				BEGIN
					--PRINT 'INSERT'
					INSERT INTO HRMSReasonMappings	 	 
						(ExitCode, ReasonForTermination, IsSeparatedMark, CreatedBy, CreatedOn, UpdatedBy, UpdatedOn)
					VALUES
						(@ExitCode, @ReasonForTermination, @IsSeparatedMark, @CreatedBy, GETDATE(), @UpdatedBy, GETDATE())
				END
		END		
END
GO
