/****** Object:  StoredProcedure [dbo].[PROC_GetEmailList]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetEmailList]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetEmailList]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PROC_GetEmailList]
	@UserIds VARCHAR(MAX)
AS
BEGIN
	CREATE TABLE #USERIDLIST
	(
		UserId VARCHAR(150)	
	)
	
	INSERT INTO #USERIDLIST
	SELECT [PARAM] FROM fn_MVParam(@UserIds, ',')
	
	DECLARE @EmailIds VARCHAR(MAX)
	
	SELECT 
		@EmailIds = COALESCE(@EmailIds,'') + EmailId + ','
	FROM 
		UserMaster INNER JOIN #USERIDLIST ON #USERIDLIST.UserID = UserMaster.UserId
	
	SELECT RTRIM(LTRIM(SUBSTRING(@EmailIds, 1, LEN(@EmailIds) - 1))) as EmailList
	
END
GO
