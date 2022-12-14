/****** Object:  StoredProcedure [dbo].[PROC_GetCompanyList_811]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetCompanyList_811]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetCompanyList_811]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetCompanyList_811]
	@ModuleName	VARCHAR(50)
AS
BEGIN
	
	SET NOCOUNT ON;	

	IF(UPPER(@ModuleName) = 'TASKSHEDULAR')
		BEGIN
			SELECT CompanyList.CName FROM ESOPManager..CompanyList WHERE IsActivatedForTS = 1 AND VersionNumber = '8.1.1' ORDER BY CName ASC
		END
	Else  	
		BEGIN
			SELECT CompanyList.CName FROM ESOPManager..CompanyList Order by CName 
		END
	
	SET NOCOUNT OFF;
END
GO
