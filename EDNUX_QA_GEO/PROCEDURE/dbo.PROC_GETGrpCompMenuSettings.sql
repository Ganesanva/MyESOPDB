/****** Object:  StoredProcedure [dbo].[PROC_GETGrpCompMenuSettings]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GETGrpCompMenuSettings]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GETGrpCompMenuSettings]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GETGrpCompMenuSettings]
AS
BEGIN
	SELECT	CASE WHEN VwMenuForGrpCompany='1|1|1' THEN 'ADMIN|CR|EMPLOYEE'
				 WHEN VwMenuForGrpCompany='1|1|0' THEN 'ADMIN|CR|0'
				 WHEN VwMenuForGrpCompany='1|0|1' THEN 'ADMIN|0|EMPLOYEE'
				 WHEN VwMenuForGrpCompany='1|0|0' THEN 'ADMIN|0|0'
				 
				 WHEN VwMenuForGrpCompany='0|1|1' THEN '0|CR|EMPLOYEE'
				 WHEN VwMenuForGrpCompany='0|1|0' THEN '0|CR|0'
				 WHEN VwMenuForGrpCompany='0|0|1' THEN '0|0|EMPLOYEE'
				 WHEN VwMenuForGrpCompany='0|0|0' THEN '0|0|0'
			END [VwMenuForGrpCompany]
	FROM	CompanyMaster	
END
GO
