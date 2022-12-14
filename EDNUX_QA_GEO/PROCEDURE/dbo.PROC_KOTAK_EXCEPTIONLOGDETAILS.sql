/****** Object:  StoredProcedure [dbo].[PROC_KOTAK_EXCEPTIONLOGDETAILS]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_KOTAK_EXCEPTIONLOGDETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_KOTAK_EXCEPTIONLOGDETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_KOTAK_EXCEPTIONLOGDETAILS]

AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT [ExceptionID], [ExMessage], [ExceptionStack], [ExceptionSource], [ExceptionType], [ExceptionBy], [OccuredOn] FROM ExceptionLog ORDER BY [OccuredOn] DESC
	
	SET NOCOUNT OFF;
END
 

 
GO
