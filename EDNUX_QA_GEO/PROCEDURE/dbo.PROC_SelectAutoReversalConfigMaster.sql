/****** Object:  StoredProcedure [dbo].[PROC_SelectAutoReversalConfigMaster]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SelectAutoReversalConfigMaster]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SelectAutoReversalConfigMaster]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_SelectAutoReversalConfigMaster] 
AS
BEGIN
 SET nocount ON; 
	SELECT * FROM [AutoReversalConfigMaster]
END
GO
