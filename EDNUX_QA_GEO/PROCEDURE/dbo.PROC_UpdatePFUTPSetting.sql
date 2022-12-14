/****** Object:  StoredProcedure [dbo].[PROC_UpdatePFUTPSetting]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UpdatePFUTPSetting]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UpdatePFUTPSetting]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_UpdatePFUTPSetting]
(
	@LastUpdatedBy VARCHAR(50),
	@LastUpdatedOn DATETIME,
	@PFUTPDate VARCHAR(20),
	@retValue INT OUTPUT
)
AS
BEGIN
	BEGIN TRY
		UPDATE CompanyParameters 
		SET 
			LastUpdatedBy = @LastUpdatedBy, 
			LastUpdatedOn = @LastUpdatedOn,	
			PFUTPDate=@PFUTPDate			
		
		SET	@retValue = 1
		
	END TRY
	
	BEGIN CATCH	
		SET	@retValue = 0	
	END CATCH		
END
GO
