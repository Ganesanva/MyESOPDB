/****** Object:  StoredProcedure [dbo].[PROC_GET_ALLOTMENT_DATE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_ALLOTMENT_DATE]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_ALLOTMENT_DATE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_ALLOTMENT_DATE]
	
AS	
BEGIN

	SELECT DISTINCT (REPLACE(CONVERT(VARCHAR(15), SharesIssuedDate,106),' ','-')) AS  AllotmentDate,Ex.SharesIssuedDate 
		   FROM Exercised Ex ORDER BY Ex.SharesIssuedDate 

END
GO
