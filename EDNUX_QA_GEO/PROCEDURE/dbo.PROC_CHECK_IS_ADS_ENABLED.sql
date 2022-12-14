/****** Object:  StoredProcedure [dbo].[PROC_CHECK_IS_ADS_ENABLED]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CHECK_IS_ADS_ENABLED]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CHECK_IS_ADS_ENABLED]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	
CREATE PROCEDURE [dbo].[PROC_CHECK_IS_ADS_ENABLED]

AS
BEGIN
		SET NOCOUNT ON;	
		
		DECLARE @IS_ADS_ENABLED TINYINT = 0
		
		SELECT
			@IS_ADS_ENABLED = '1' 
		FROM
			MST_INSTRUMENT_TYPE MIT 
			INNER JOIN MST_COM_CODE MCC ON MIT.INSTRUMENT_GROUP = MCC.MCC_ID
			INNER JOIN COMPANY_INSTRUMENT_MAPPING CIM ON CIM.MIT_ID = MIT.MIT_ID
		WHERE
			 MCC.CODE_NAME='ADR' AND CIM.IS_ENABLED = '1'
			 
			 SELECT @IS_ADS_ENABLED AS IS_ADS_ENABLED
		
		SET NOCOUNT OFF;	

END
GO
