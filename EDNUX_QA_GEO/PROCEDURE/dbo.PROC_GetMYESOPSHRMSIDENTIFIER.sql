/****** Object:  StoredProcedure [dbo].[PROC_GetMYESOPSHRMSIDENTIFIER]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetMYESOPSHRMSIDENTIFIER]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetMYESOPSHRMSIDENTIFIER]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetMYESOPSHRMSIDENTIFIER]
AS
BEGIN
	SELECT 
		HRMS_LOGINID,
		MYESOPS_LOGINID
	FROM 
		MYESOPS_HRMS_IDENTIFIER
END
GO
