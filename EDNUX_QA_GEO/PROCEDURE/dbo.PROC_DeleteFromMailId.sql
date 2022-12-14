/****** Object:  StoredProcedure [dbo].[PROC_DeleteFromMailId]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_DeleteFromMailId]
GO
/****** Object:  StoredProcedure [dbo].[PROC_DeleteFromMailId]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_DeleteFromMailId] @Id INT
	,@retValue INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE
	FROM SendMailIdList
	WHERE Id = @Id

	SET @retValue = @@ROWCOUNT;
	SET NOCOUNT OFF;
END
GO
