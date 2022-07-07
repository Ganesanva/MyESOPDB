/****** Object:  StoredProcedure [dbo].[PROC_SelectApplicationSupport]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SelectApplicationSupport]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SelectApplicationSupport]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_SelectApplicationSupport]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT FromDate
		,ToDate
		,Cash
	FROM ApplicationSupport

	SET NOCOUNT OFF;
END
GO
