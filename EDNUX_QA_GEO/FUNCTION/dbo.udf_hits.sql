/****** Object:  UserDefinedFunction [dbo].[udf_hits]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP FUNCTION IF EXISTS [dbo].[udf_hits]
GO
/****** Object:  UserDefinedFunction [dbo].[udf_hits]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[udf_hits]
	(@PageName VARCHAR(100)) RETURNS VARCHAR(500)
	AS
	BEGIN
		DECLARE @loctemp varchar(500)
		SELECT @loctemp=COALESCE(@loctemp + ' / ', '')+ Name FROM ScreenMaster
		INNER JOIN PageLogHits on
		PageLogHits.PageName = 
		reverse((SUBSTRING (reverse(ScreenURL),CHARINDEX ('.',REVERSE (screenurl)),abs(CHARINDEX('/',reverse(ScreenURL))-CHARINDEX ('.',REVERSE (screenurl)))) ))+'aspx'
		WHERE PageName=@PageName
		RETURN (@loctemp)
	END
GO
