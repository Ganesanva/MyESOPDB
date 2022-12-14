/****** Object:  StoredProcedure [dbo].[PROC_GetFMVSharePrices]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetFMVSharePrices]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetFMVSharePrices]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GetFMVSharePrices] 
@SharePriceOption char,
@dateSharePrice datetime,
@ExchangeType char,
@Result INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;   
	
	IF @SharePriceOption='1'
		BEGIN
			SET @Result=(SELECT ClosePrice AS shareprice  FROM dbo.FMVSharePrices  WHERE PriceDate = @dateSharePrice AND  StockExchange =@ExchangeType)
		END
	ELSE IF @SharePriceOption='2'
		BEGIN
			SET @Result=(SELECT ((ISNULL( ClosePrice ,0)+ ISNULL( OpenPrice ,0))/2) AS shareprice  FROM dbo.FMVSharePrices  WHERE PriceDate =@dateSharePrice AND  StockExchange =@ExchangeType)
		END
	ELSE IF @SharePriceOption='3'
		BEGIN
			SET @Result=(SELECT MAX(closeprice) AS shareprice FROM dbo.FMVSharePrices WHERE Volume IN (SELECT MAX( Volume ) FROM dbo.FMVSharePrices WHERE PriceDate = @dateSharePrice ) and PriceDate = @dateSharePrice)
		END
	ELSE IF @SharePriceOption='4'
		BEGIN
			SET @Result=(SELECT ((ISNULL( ClosePrice ,0)+ ISNULL( OpenPrice ,0))/2) AS shareprice  FROM dbo.FMVSharePrices  WHERE Volume IN (SELECT MAX( Volume ) FROM dbo.FMVSharePrices WHERE PriceDate =@dateSharePrice) and PriceDate =@dateSharePrice)
		END
		
IF @Result IS NULL
	BEGIN
		SET @Result=0
	END
	SELECT  @Result AS Result
END
GO
