/****** Object:  StoredProcedure [dbo].[PROC_ChekExerciseWindowCloseRule]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_ChekExerciseWindowCloseRule]
GO
/****** Object:  StoredProcedure [dbo].[PROC_ChekExerciseWindowCloseRule]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[PROC_ChekExerciseWindowCloseRule]
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @Count INT,	@Message VARCHAR(100)='Exercise can not be done between '

	SELECT @Count = COUNT(id) from ApplicationSupport WHERE GETDATE() BETWEEN FromDate AND ToDate
	
	IF @Count > 0
	BEGIN
		PRINT @Count
		SELECT fromdate, ToDate, @Count AS Result, @Message +''+CONVERT(VARCHAR(10),DATEPART(DD, FromDate)) +'/'+CONVERT(VARCHAR(10),DATEPART(MM, FromDate))+'/'+CONVERT(VARCHAR(10),DATEPART(YY, FromDate))+'-' +CONVERT(VARCHAR(10),DATEPART(HH, FromDate)) +':'+ CONVERT(VARCHAR(10),DATEPART(MINUTE, FromDate)) +' hrs (IST) '+ +'and '+ CONVERT(VARCHAR(10),DATEPART(DD, Todate))+'/'+CONVERT(VARCHAR(10),DATEPART(MM, Todate))+'/'+CONVERT(VARCHAR(10),DATEPART(YY, Todate))+'-' + CONVERT(VARCHAR(10),DATEPART(HH, Todate)) +':'+ CONVERT(VARCHAR(10),DATEPART(MINUTE, Todate)) +'  hrs (IST).  Please write to helpdesk@esopdirect.com for any query.' AS DisplayMessage FROM ApplicationSupport WHERE GETDATE() BETWEEN FromDate AND ToDate		
	END
	ELSE
	BEGIN
		PRINT @Count
		SELECT TOP 1 id, fromdate, ToDate, 0 AS Result FROM ApplicationSupport WHERE CONVERT(DATE,GETDATE()) BETWEEN CONVERT(DATE,FromDate) AND CONVERT(date,ToDate) ORDER BY ID DESC
	END
			
   	SET NOCOUNT OFF

END



GO
