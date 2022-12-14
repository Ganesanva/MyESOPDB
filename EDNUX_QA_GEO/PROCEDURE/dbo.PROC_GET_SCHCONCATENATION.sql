/****** Object:  StoredProcedure [dbo].[PROC_GET_SCHCONCATENATION]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_SCHCONCATENATION]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_SCHCONCATENATION]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_SCHCONCATENATION]
AS  
BEGIN
   
	SELECT LD.SchemeId,S.SchemeTitle,LD.UniqueCode,LD.Name,LD.SchConcatentionID,0 AS DeleteStatus 
			FROM Scheme S
			INNER JOIN ListingDocSchConcatenation LD ON S.SchemeId=LD.SchemeID
			ORDER BY UniqueCode
END
GO
