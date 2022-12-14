/****** Object:  StoredProcedure [dbo].[PROC_INSERT_DELISTINGINFO]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_INSERT_DELISTINGINFO]
GO
/****** Object:  StoredProcedure [dbo].[PROC_INSERT_DELISTINGINFO]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_INSERT_DELISTINGINFO]
 @DelistingInfoType dbo.DelistingInfoType READONLY,
 @CreatedBy VARCHAR(100),
 @Result INT OUT
AS  
BEGIN
    SET @Result=0
    IF EXISTS (SELECT 1 FROM ListingDocDelistingInfo)
    BEGIN
		DELETE FROM ListingDocDelistingInfo
    END
    IF EXISTS(SELECT 1 FROM @DelistingInfoType)
    BEGIN
    INSERT INTO ListingDocDelistingInfo(StockExchangesName,DelistingApprovalDate,CreatedBy,CreatedOn)
			  SELECT StockExchangesName,DelistingApprovalDate,@CreatedBy,GETDATE() FROM @DelistingInfoType WHERE DeleteStatus=0
	END		  
		SET @Result=1
END
GO
