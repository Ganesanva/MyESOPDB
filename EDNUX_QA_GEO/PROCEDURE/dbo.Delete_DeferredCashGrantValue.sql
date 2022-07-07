/****** Object:  StoredProcedure [dbo].[Delete_DeferredCashGrantValue]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Delete_DeferredCashGrantValue]
GO
/****** Object:  StoredProcedure [dbo].[Delete_DeferredCashGrantValue]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Delete_DeferredCashGrantValue]    
AS    
BEGIN 

	CREATE TABLE #TEMP_DELETE
	(
	ID bigint
	)
	INSERT INTO #TEMP_DELETE (ID)
	SELECT DISTINCT Id FROM DeferredCashGrant WHERE Action = 'D'


	

IF((SELECT COUNT(ID) FROM #TEMP_DELETE) > 0)
BEGIN
	DELETE FROM DeferredCashGrant WHERE Id IN (SELECT ID FROM #TEMP_DELETE)
END

DROP TABLE #TEMP_DELETE 
END
GO
