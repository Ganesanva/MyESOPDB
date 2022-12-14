/****** Object:  StoredProcedure [dbo].[PROC_ExecuteMultipleQueries]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_ExecuteMultipleQueries]
GO
/****** Object:  StoredProcedure [dbo].[PROC_ExecuteMultipleQueries]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_ExecuteMultipleQueries] @Query NVARCHAR(MAX)
	,@retValue INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	EXEC (@Query)

	SET @retValue = 1;
	SET NOCOUNT OFF;
END
GO
