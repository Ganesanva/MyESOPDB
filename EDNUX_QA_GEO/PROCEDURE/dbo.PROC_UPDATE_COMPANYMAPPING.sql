/****** Object:  StoredProcedure [dbo].[PROC_UPDATE_COMPANYMAPPING]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UPDATE_COMPANYMAPPING]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UPDATE_COMPANYMAPPING]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[PROC_UPDATE_COMPANYMAPPING]
   @IsResident INT ,
   @IsNonResident INT ,
   @IsForeignNational INT,
   @IsTaxApplicable VARCHAR(500),
   @MIT_ID INT
    
AS  
BEGIN

SET NOCOUNT ON;

	UPDATE COMPANY_INSTRUMENT_MAPPING
	SET IsResident = @IsResident,
	IsNonResident = @IsNonResident,
	IsForeignNational = @IsForeignNational,
	IsTaxApplicable = @IsTaxApplicable
	WHERE MIT_ID = @MIT_ID

SET NOCOUNT OFF;

END
GO
