/****** Object:  StoredProcedure [dbo].[PROC_SelectMailType]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SelectMailType]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SelectMailType]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_SelectMailType]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT TypeId
		,[Description]
		,ShortName
	FROM MailTypeMaster

	SET NOCOUNT OFF;
END
GO
