/****** Object:  StoredProcedure [dbo].[PROC_ExNowChekExerciseWindowCloseRule]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_ExNowChekExerciseWindowCloseRule]
GO
/****** Object:  StoredProcedure [dbo].[PROC_ExNowChekExerciseWindowCloseRule]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_ExNowChekExerciseWindowCloseRule]
	
AS
BEGIN
SET NOCOUNT ON
	DECLARE @Count INT,
	@Message VARCHAR(100)='Exercise can not be done between '
	DECLARE @date DateTime 

	SET @date = GetDate()
	SELECT @Count = COUNT(id) 
	from ApplicationSupport 
	WHERE CONVERT(DATE,@date) BETWEEN CONVERT(DATE,FromDate) AND CONVERT(DATE,ToDate) AND ISNonTradingDay = 'N'	
	
	IF @Count = 0
	BEGIN
		IF EXISTS(select * from ApplicationSupport where @date BETWEEN CONVERT(datetime,FromDate) AND CONVERT(datetime,ToDate))
		BEGIN
		    SELECT TOP 1 id, 
			fromdate, 
			ToDate, 
			0 AS Result, 
			@Message +''+CONVERT(VARCHAR(10),DATEPART(DD, FromDate)) +'/'+CONVERT(VARCHAR(10),DATEPART(MM, FromDate))+'/'+CONVERT(VARCHAR(10),DATEPART(YY, FromDate))+'-' +CONVERT(VARCHAR(10),DATEPART(HH, FromDate)) +':'+ CONVERT(VARCHAR(10),DATEPART(MINUTE, FromDate)) +' hrs (IST) '+ +'and '+ CONVERT(VARCHAR(10),DATEPART(DD, Todate))+'/'+CONVERT(VARCHAR(10),DATEPART(MM, Todate))+'/'+CONVERT(VARCHAR(10),DATEPART(YY, Todate))+'-' + CONVERT(VARCHAR(10),DATEPART(HH, Todate)) +':'+ CONVERT(VARCHAR(10),DATEPART(MINUTE, Todate)) +'  hrs (IST) .' AS DisplayMessage 
		FROM ApplicationSupport 
		WHERE 		
		CONVERT(date,@date) = CONVERT(date,FromDate) ORDER BY ID DESC	
		END
		ELSE
		BEGIN
		    SELECT TOP 1 id, 
			fromdate, 
			ToDate, 
			1 AS Result, 
			'' AS DisplayMessage 
		FROM ApplicationSupport 
		WHERE 
		CONVERT(date,@date) = CONVERT(date,FromDate) ORDER BY ID DESC	
		END		
	END
	ELSE
	BEGIN
		IF EXISTS(select * from ApplicationSupport where @date BETWEEN CONVERT(datetime,FromDate) AND CONVERT(datetime,ToDate))
		BEGIN
		    SELECT TOP 1 id, 
			fromdate, 
			ToDate, 
			0 AS Result, 
			@Message +''+CONVERT(VARCHAR(10),DATEPART(DD, FromDate)) +'/'+CONVERT(VARCHAR(10),DATEPART(MM, FromDate))+'/'+CONVERT(VARCHAR(10),DATEPART(YY, FromDate))+'-' +CONVERT(VARCHAR(10),DATEPART(HH, FromDate)) +':'+ CONVERT(VARCHAR(10),DATEPART(MINUTE, FromDate)) +' hrs (IST) '+ +'and '+ CONVERT(VARCHAR(10),DATEPART(DD, Todate))+'/'+CONVERT(VARCHAR(10),DATEPART(MM, Todate))+'/'+CONVERT(VARCHAR(10),DATEPART(YY, Todate))+'-' + CONVERT(VARCHAR(10),DATEPART(HH, Todate)) +':'+ CONVERT(VARCHAR(10),DATEPART(MINUTE, Todate)) +'  hrs (IST) .' AS DisplayMessage 
		FROM ApplicationSupport 
		WHERE 		
		CONVERT(date,@date) = CONVERT(date,FromDate) ORDER BY ID DESC	
	
		END
		ELSE
		BEGIN
		
		    SELECT TOP 1 id, 
			fromdate, 
			ToDate, 
			1 AS Result, 
			'' AS DisplayMessage 
		FROM ApplicationSupport 
		WHERE 
		CONVERT(date,@date) = CONVERT(date,FromDate) ORDER BY ID DESC	
		END			
	END
	
   	SET NOCOUNT OFF
END
GO
