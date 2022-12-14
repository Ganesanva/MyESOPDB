/****** Object:  StoredProcedure [dbo].[PROC_USER_LOGIN_HISTORY_REPORT]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_USER_LOGIN_HISTORY_REPORT]
GO
/****** Object:  StoredProcedure [dbo].[PROC_USER_LOGIN_HISTORY_REPORT]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_USER_LOGIN_HISTORY_REPORT] 
	@FromDate DATETIME = NULL,
	@ToDate DATETIME = NULL
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT
		ROW_NUMBER() over (order by ULH.LoginDate DESC ) AS 'SN', ULH.UserId, ULH.LoginDate, ULH.LogOutDate 
	FROM 
		UserLoginHistory AS ULH
	WHERE 
		CONVERT(DATE, ULH.LoginDate) >= CONVERT(DATE,@FromDate)  AND CONVERT(DATE, ULH.LoginDate) <= CONVERT(DATE,@ToDate)	
	ORDER BY 
		ULH.LoginDate DESC

	SET NOCOUNT OFF;

END
GO
