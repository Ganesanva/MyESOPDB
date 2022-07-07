/****** Object:  StoredProcedure [dbo].[PROC_GET_STOCKEXCHANGE_LIST]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_STOCKEXCHANGE_LIST]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_STOCKEXCHANGE_LIST]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_STOCKEXCHANGE_LIST]
	
AS
BEGIN
	SET NOCOUNT ON;	
			   
    SELECT 
		MSE_ID, STOCK_EXCHANGE_SYMBOL ,CurrencyID
	FROM 
		MST_STOCK_EXCHANGE 
	WHERE 
		IS_ACTIVE = 1

	SET NOCOUNT OFF;	
END
GO
