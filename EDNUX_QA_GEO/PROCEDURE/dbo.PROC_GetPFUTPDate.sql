/****** Object:  StoredProcedure [dbo].[PROC_GetPFUTPDate]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetPFUTPDate]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetPFUTPDate]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetPFUTPDate]
AS
BEGIN
	SELECT REPLACE(CONVERT(VARCHAR(11), PFUTPDate, 106), ' ', '/') as PFUTPDate,PFUTPchkValue FROM CompanyParameters
END

GO
