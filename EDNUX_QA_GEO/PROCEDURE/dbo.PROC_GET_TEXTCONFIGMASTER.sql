/****** Object:  StoredProcedure [dbo].[PROC_GET_TEXTCONFIGMASTER]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_TEXTCONFIGMASTER]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_TEXTCONFIGMASTER]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_TEXTCONFIGMASTER]
AS  
BEGIN
   
	SELECT  
	Name,
	AliasName 
	FROM ListingTextConfigMaster 
	ORDER BY LTextConfigID
	
END
GO
