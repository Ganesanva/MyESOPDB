/****** Object:  StoredProcedure [dbo].[SP_FILL_TAX_HEADINGS]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_FILL_TAX_HEADINGS]
GO
/****** Object:  StoredProcedure [dbo].[SP_FILL_TAX_HEADINGS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_FILL_TAX_HEADINGS]
(
	@INSTRUMENT_ID	BIGINT
)
AS
BEGIN
	
	SET NOCOUNT ON;	
	
	BEGIN
		SELECT 
			MTH_ID,TAX_HEADING 
		FROM 
			MST_TAX_RATE_TITLE TRSC 
		WHERE 
			TRSC.MIT_ID=@INSTRUMENT_ID 
	END
	
	SET NOCOUNT OFF		
END
GO
