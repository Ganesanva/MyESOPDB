/****** Object:  StoredProcedure [dbo].[PROC_InsertUpdateWhatsNew]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_InsertUpdateWhatsNew]
GO
/****** Object:  StoredProcedure [dbo].[PROC_InsertUpdateWhatsNew]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_InsertUpdateWhatsNew] @News VARCHAR(200) = NULL
	,@DisplayOrder VARCHAR(10) = NULL
	,@Action CHAR = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	IF (@Action = 'I')
	BEGIN
		INSERT INTO WhatsNew (
			DisplayOrder
			,News
			)
		VALUES (
			@DisplayOrder
			,@News
			)
	END
	ELSE IF (@Action = 'U')
	BEGIN
		UPDATE WhatsNew
		SET News = @News
		WHERE DisplayOrder = @DisplayOrder
	END

	SET NOCOUNT OFF;
END
GO
