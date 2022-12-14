/****** Object:  StoredProcedure [dbo].[PROC_IsPUPGrantOptionsAvailable]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_IsPUPGrantOptionsAvailable]
GO
/****** Object:  StoredProcedure [dbo].[PROC_IsPUPGrantOptionsAvailable]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[PROC_IsPUPGrantOptionsAvailable]
(
	@EmployeeId VARCHAR(100)= NULL	
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Query NVARCHAR(500),	
			@Parameter NVARCHAR(300),
			@Count INT
			
	SET @Parameter	= N'@Count1 INT output'
	SET @QUERY		= N'SELECT @Count1 = COUNT(1) 
							FROM Scheme SC 
								INNER JOIN GrantOptions GOPs 
									ON GOPs.SchemeId = SC.SchemeId 
							WHERE SC.IsPUPEnabled = 1 AND GOPs.EmployeeId=(Select EmployeeId From UserMaster Where UserId='''+@EmployeeId+''')'
	EXEC SP_EXECUTESQL @QUERY,@Parameter,@Count OUTPUT
	
	PRINT @Query	
	PRINT @Count
	IF(@Count > 0) 		
		SELECT 1 Result
	ELSE 
		SELECT 0 Result
	SET NOCOUNT OFF
END
GO
