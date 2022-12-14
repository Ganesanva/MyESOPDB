/****** Object:  StoredProcedure [dbo].[PROC_FMV_CONFIG_ISEXIST]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_FMV_CONFIG_ISEXIST]
GO
/****** Object:  StoredProcedure [dbo].[PROC_FMV_CONFIG_ISEXIST]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[PROC_FMV_CONFIG_ISEXIST]
(
 @PAGENAME				VARCHAR (100),
 @INSTRUMENT_ID			bigint
 
)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF(UPPER(@PAGENAME)='FMV')
	Begin
			SELECT TOP(1) CASE WHEN FFC_ID >0 THEN '1' ELSE '0' END  as ISExist ,FFC_ID FROM FMV_FORMULA_CONFIG WHERE Residential_ID is null And Country_ID is null And MIT_ID= @INSTRUMENT_ID  AND FORMULA_CONFIG_TYPE='' ORDER BY FFC_ID DESC 
	End
	
END
GO
