/****** Object:  StoredProcedure [dbo].[PROC_GET_RESIDENTIAL_STATUS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_RESIDENTIAL_STATUS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_RESIDENTIAL_STATUS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GET_RESIDENTIAL_STATUS]

  @UserId NVARCHAR(50) = NULL
 
AS
BEGIN
	
	SET NOCOUNT ON;
		
		SELECT RESIDENTIALSTATUS FROM EMPLOYEEMASTER WHERE LoginID=@UserId

	SET NOCOUNT OFF;
END
GO
