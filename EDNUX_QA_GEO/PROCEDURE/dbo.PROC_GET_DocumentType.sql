/****** Object:  StoredProcedure [dbo].[PROC_GET_DocumentType]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_DocumentType]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_DocumentType]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GET_DocumentType]
	@ModuleName	VARCHAR(50)
AS
BEGIN
IF(UPPER(@ModuleName) = 'DOCUMENTUPLOADONAZURETASKSHEDULAR')
		BEGIN
	SELECT * FROM 	MST_DOCUMENT_UPLOAD_MASTER
		END

END
GO
