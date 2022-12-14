/****** Object:  StoredProcedure [dbo].[PROC_NominationCRUD]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_NominationCRUD]
GO
/****** Object:  StoredProcedure [dbo].[PROC_NominationCRUD]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_NominationCRUD]
	@Action						CHAR(1),
	@IsNominationEnabledForEmp 	BIT,
	@IsEditableForEmp 			BIT,
	@IsAlertEnabledToEmp		BIT,
	@CompanyAddress 			NVARCHAR(500),
	@TextPart1					NVARCHAR(500),
	@TextPart2					NVARCHAR(500),
	@LastUpdatedBy				NVARCHAR(50)  
AS

BEGIN
	
	IF(@Action = 'R')
		SELECT 
			CASE WHEN CM.ISNOMINATIONENABLED = 1 AND NC.IsNominationEnabledForEmp = 1 THEN 1 ELSE 0 END IsNomineeEnabledByAdmin,
			NC.IsNominationEnabledForEmp,
			NC.IsEditableForEmp,
			NC.IsAlertEnabledToEmp,
			NC.CompanyAddress,
			NC.TextPart1,
			NC.TextPart2
		FROM 
			COMPANYMASTER CM
			CROSS JOIN NominationConfigurations NC 
		
	ELSE IF(@Action = 'U')
	BEGIN
		UPDATE 
			NominationConfigurations
		SET
			
		IsNominationEnabledForEmp 	= @IsNominationEnabledForEmp, 
		IsEditableForEmp 			= @IsEditableForEmp, 
		IsAlertEnabledToEmp			= @IsAlertEnabledToEmp, 
		CompanyAddress				= @CompanyAddress, 
		TextPart1					= @TextPart1, 
		TextPart2					= @TextPart2, 
		LastUpdatedBy				= LastUpdatedBy, 
		LastUpdatedOn 				= GETDATE()
		
		SELECT 1 AS OUT_PUT
	END
END



GO
