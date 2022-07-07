/****** Object:  StoredProcedure [dbo].[PROC_GET_BlockGrantRegId]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_BlockGrantRegId]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_BlockGrantRegId]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GET_BlockGrantRegId]				
AS
BEGIN
	SELECT GRANTREGISTRATIONID FROM BLOCKEDGRANTREGISTERID WHERE GETDATE() BETWEEN TODATE AND FROMDATE GROUP BY GRANTREGISTRATIONID
END
GO
