/****** Object:  StoredProcedure [dbo].[PROC_CUDCashlessPaymentMode]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CUDCashlessPaymentMode]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CUDCashlessPaymentMode]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[PROC_CUDCashlessPaymentMode]
(	
	@PaymentMode CHAR,
	@Result		 INT OUTPUT 
)
AS
BEGIN
	SET NOCOUNT ON
		DECLARE @SQLQuery VARCHAR(MAX),				
				@Error INT = 1 -- default value of error is '1' means no error.
		
		--Try/Catch block implement in sql query.		
		BEGIN TRY			
			SELECT @SQLQuery = 'UPDATE PaymentMaster SET IsEnable ='''+@PaymentMode+''',LastUpdatedBy=''CashlessModule'', LastUpdatedOn=GETDATE() WHERE ID=4'			
			--PRINT @SQLQuery
			EXEC(@SQLQuery)			
		END TRY
		BEGIN CATCH
			SELECT @Error = 0
		END CATCH
		
		--IF Record updated successfully it returns '1' ELSE it return '0'
		SELECT @Result = CASE WHEN (@Error=0) THEN 0 ELSE 1 END
		
	SET NOCOUNT OFF
END
GO
