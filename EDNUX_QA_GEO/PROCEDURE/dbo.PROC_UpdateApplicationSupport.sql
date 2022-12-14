/****** Object:  StoredProcedure [dbo].[PROC_UpdateApplicationSupport]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UpdateApplicationSupport]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UpdateApplicationSupport]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_UpdateApplicationSupport] @FromDate DATETIME
	,@ToDate DATETIME
	,@Cash VARCHAR(50)
	,@retValue INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE ApplicationSupport
	SET FromDate = @FromDate
		,ToDate = @ToDate
		,Cash = @Cash

	SET @retValue = @@ROWCOUNT;
	SET NOCOUNT OFF;
END
GO
