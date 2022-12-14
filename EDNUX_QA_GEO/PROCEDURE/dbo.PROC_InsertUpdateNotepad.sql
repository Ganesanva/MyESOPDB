/****** Object:  StoredProcedure [dbo].[PROC_InsertUpdateNotepad]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_InsertUpdateNotepad]
GO
/****** Object:  StoredProcedure [dbo].[PROC_InsertUpdateNotepad]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_InsertUpdateNotepad] @UserId VARCHAR(50) = NULL
	,@Text VARCHAR(300) = NULL
	,@Action CHAR = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	IF (@Action = 'I')
	BEGIN
		INSERT INTO Notepad (
			UserId
			,[Text]
			)
		VALUES (
			@UserId
			,@Text
			)
	END
	ELSE IF (@Action = 'U')
	BEGIN
		UPDATE Notepad
		SET [Text] = @Text
		WHERE UserId = @UserId
	END

	SET NOCOUNT OFF;
END
GO
