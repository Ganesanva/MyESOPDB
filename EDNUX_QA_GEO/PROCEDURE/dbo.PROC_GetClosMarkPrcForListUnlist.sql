/****** Object:  StoredProcedure [dbo].[PROC_GetClosMarkPrcForListUnlist]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetClosMarkPrcForListUnlist]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetClosMarkPrcForListUnlist]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[PROC_GetClosMarkPrcForListUnlist]
AS
BEGIN
	SET NOCOUNT ON
	
	DECLARE @SQLQuery VARCHAR(MAX),
			@ListedYN CHAR,
			@ClosingPrice Numeric(18,2),
			@PriceDate Date			
			
	SELECT  @ListedYN = ListedYN  
	FROM	CompanyParameters
	
	IF(@ListedYN='Y')
		BEGIN 
			SELECT	ISNULL (ClosePrice,0)AS ClosingPrice,
					CONVERT(DATE,PriceDate) PriceDate,
					'1' AS IsListed  
			FROM	SharePrices  
			WHERE	PriceDate = (SELECT MAX(PriceDate) FROM SharePrices)
		END
	ELSE
		BEGIN 
			SELECT	@ClosingPrice = ISNULL(FMV,0) 
			FROM	FMVForUnlisted 
			WHERE	CONVERT(DATE,GETDATE()) BETWEEN FMV_FromDate AND FMV_Todate 
			
			IF(@ClosingPrice=0)
				BEGIN
					SELECT	FMV AS ClosingPrice ,
							GETDATE () AS PriceDate, 
							'0' AS IsListed  
					FROM	FMVForUnlisted 
					WHERE	FMV_Todate 
								=(	
									SELECT MAX (FMV_Todate) 
									FROM FMVForUnlisted 
								 )
				END
			ELSE
				BEGIN
					SELECT	@ClosingPrice ClosingPrice,
							CONVERT(DATE,GETDATE()) PriceDate,
							'0' IsListed
				END
		END
		
	SET NOCOUNT OFF
END
GO
