/****** Object:  StoredProcedure [dbo].[PROC_InsertIntoSendMailIdList]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_InsertIntoSendMailIdList]
GO
/****** Object:  StoredProcedure [dbo].[PROC_InsertIntoSendMailIdList]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_InsertIntoSendMailIdList] @TypeId INT
	,@DisplayName VARCHAR(50)
	,@EmailAddress VARCHAR(50)
	,@TOorCC CHAR(10)
	,@CreatedBy VARCHAR(100)
	,@CreatedOn DATETIME
	,@retValue INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO SendMailIdList (
		TypeId
		,DisplayName
		,EmailAddress
		,TOorCC
		,CreatedBy
		,CreatedOn
		)
	VALUES (
		@TypeId
		,@DisplayName
		,@EmailAddress
		,@TOorCC
		,@CreatedBy
		,@CreatedOn
		)

	SET @retValue = @@ROWCOUNT;
	SET NOCOUNT OFF;
END
GO
