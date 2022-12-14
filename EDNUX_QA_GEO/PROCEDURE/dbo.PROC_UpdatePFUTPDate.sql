/****** Object:  StoredProcedure [dbo].[PROC_UpdatePFUTPDate]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UpdatePFUTPDate]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UpdatePFUTPDate]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_UpdatePFUTPDate]
(	
	@LastUpdatedBy VARCHAR(20),
	@PFUTPDate DATETIME,
	@PFUTPchkValue BIT,
	@retValue INT OUTPUT
)
AS
SET NOCOUNT ON

BEGIN
	BEGIN TRY
	IF(@PFUTPchkValue = 1)
	BEGIN
			UPDATE CompanyParameters
			SET 
				PFUTPDate = CONVERT(DATE, @PFUTPDate),
				LastUpdatedBy = @LastUpdatedBy,
				LastUpdatedOn = GETDATE(),
				PFUTPchkValue = @PFUTPchkValue
			SET @retValue = 1
			END
	ELSE
		BEGIN
			
			UPDATE CompanyParameters
			SET 
				PFUTPDate = NULL,
				LastUpdatedBy = @LastUpdatedBy,
				LastUpdatedOn = GETDATE(),
				PFUTPchkValue = @PFUTPchkValue
			SET @retValue = 1
		END
	END TRY

	BEGIN CATCH
		SET @retValue = 0
	END CATCH
END  
GO
