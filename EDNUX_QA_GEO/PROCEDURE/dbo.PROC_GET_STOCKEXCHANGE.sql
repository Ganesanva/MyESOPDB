/****** Object:  StoredProcedure [dbo].[PROC_GET_STOCKEXCHANGE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_STOCKEXCHANGE]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_STOCKEXCHANGE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_STOCKEXCHANGE]
@CurrencyID INT	
AS
BEGIN
	SET NOCOUNT ON;	
			
	
	SELECT 
		MSE_ID, STOCK_EXCHANGE_SYMBOL 
	FROM MST_STOCK_EXCHANGE 
	WHERE 
		IS_ACTIVE = 1 AND CurrencyID = @CurrencyID
		   
  
	SET NOCOUNT OFF;	
END
GO
