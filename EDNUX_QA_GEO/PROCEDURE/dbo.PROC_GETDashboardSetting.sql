/****** Object:  StoredProcedure [dbo].[PROC_GETDashboardSetting]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GETDashboardSetting]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GETDashboardSetting]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GETDashboardSetting]
AS

BEGIN
	SELECT ID, Name, URL, DisplayAs, ViewOnDashboard FROM EmployeeRoleMaster WHERE [ViewOnDashboard] = 0
END
GO
