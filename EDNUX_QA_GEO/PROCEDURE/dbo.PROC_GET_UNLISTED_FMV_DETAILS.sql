/****** Object:  StoredProcedure [dbo].[PROC_GET_UNLISTED_FMV_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_UNLISTED_FMV_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_UNLISTED_FMV_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[PROC_GET_UNLISTED_FMV_DETAILS] 
 	 
AS
BEGIN

SET NOCOUNT ON;

	BEGIN
		 
		 SELECT 
			CASE WHEN Scheme_Id IS NULL THEN  'NA' ELSE Scheme_Id END AS 'Scheme Id',
		    CASE WHEN GrantRegistration_Id IS NULL THEN  'NA'  ELSE GrantRegistration_Id END AS 'Grant registration id',
		    FMV AS 'FMV', 
		    REPLACE(CONVERT(VARCHAR(11),FMV_FromDate ,106), ' ','-') AS 'FMV Valid From Date',
		    REPLACE(CONVERT(VARCHAR(11),FMV_Todate ,106), ' ','-') AS 'FMV Valid To Date',
		    CreatedBy AS 'Uploaded By',Updatedon AS 'Updated On'
		 FROM 
		    FMVForUnlisted
         ORDER BY FMV_Todate ASC

	END   
SET NOCOUNT OFF;
END
GO
