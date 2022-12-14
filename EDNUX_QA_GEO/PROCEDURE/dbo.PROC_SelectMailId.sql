/****** Object:  StoredProcedure [dbo].[PROC_SelectMailId]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SelectMailId]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SelectMailId]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_SelectMailId]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT SendMailIdList.Id
		,MailTypeMaster.[Description]
		,SendMailIdList.DisplayName
		,SendMailIdList.EmailAddress
		,SendMailIdList.TOorCC
	FROM MailTypeMaster
	INNER JOIN SendMailIdList ON MailTypeMaster.TypeId = SendMailIdList.TypeId
	ORDER BY [Description]
		,TOorCC

	SET NOCOUNT OFF;
END
GO
