/****** Object:  StoredProcedure [dbo].[PROC_GET_TAX_CALCULATION_TYPE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_TAX_CALCULATION_TYPE]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_TAX_CALCULATION_TYPE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_TAX_CALCULATION_TYPE]
(
	@SCHEME_ID NVARCHAR(100)
)
AS
BEGIN
	   SET NOCOUNT ON;			
		
	   SELECT CALCULATE_TAX FROM Scheme WHERE SCHEMEID = @SCHEME_ID
		
	   SET NOCOUNT OFF;	
END
GO
