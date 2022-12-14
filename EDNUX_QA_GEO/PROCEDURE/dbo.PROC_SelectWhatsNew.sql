/****** Object:  StoredProcedure [dbo].[PROC_SelectWhatsNew]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SelectWhatsNew]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SelectWhatsNew]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_SelectWhatsNew] @DisplayOrder VARCHAR(10) = NULL
AS
BEGIN
	SET @DisplayOrder = ISNULL(@DisplayOrder, '0');
	SET @DisplayOrder = CONVERT(INT, @DisplayOrder);
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	IF (@DisplayOrder > 0)
	BEGIN
		SELECT *
		FROM WhatsNew
		WHERE DisplayOrder = @DisplayOrder
	END
	ELSE
	BEGIN
		SELECT *
		FROM WhatsNew
		WHERE News <> ''
		ORDER BY DisplayOrder ASC
	END

	SET NOCOUNT OFF;
END
GO
