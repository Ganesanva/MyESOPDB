/****** Object:  StoredProcedure [dbo].[PROC_GET_UPLOAD_DOCUMENT_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_UPLOAD_DOCUMENT_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_UPLOAD_DOCUMENT_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_UPLOAD_DOCUMENT_DETAILS]

	
AS
BEGIN

	SET NOCOUNT ON;

	 Select top 1 * from UploadDetails Where IsDeleted=0 AND CategoryID=4  Order By LastUpdatedOn DESC
END
GO
