/****** Object:  StoredProcedure [dbo].[PROC_GET_DELISTINGINFO]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_DELISTINGINFO]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_DELISTINGINFO]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_DELISTINGINFO]
AS  
BEGIN
   
	SELECT LstDocDelistingID, StockExchangesName,DelistingApprovalDate,0 AS DeleteStatus 
	FROM ListingDocDelistingInfo
	ORDER BY LstDocDelistingID
	
END
GO
