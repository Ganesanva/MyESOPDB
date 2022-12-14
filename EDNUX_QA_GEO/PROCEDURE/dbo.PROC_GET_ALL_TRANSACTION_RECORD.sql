/****** Object:  StoredProcedure [dbo].[PROC_GET_ALL_TRANSACTION_RECORD]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_ALL_TRANSACTION_RECORD]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_ALL_TRANSACTION_RECORD]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_ALL_TRANSACTION_RECORD]
    @EmployeeID VARCHAR(100)
AS
BEGIN
	SELECT  
		   [TransactionID]
		  ,[UserID]
		  ,[UserType]
		  ,[TableName]
		  ,[TableFieldName]
		  ,[OldValue]
		  ,[NewValue]
		  ,[TransactionDescription]
		  ,[TransactionDate]
		  ,[CategoryName]      
		  ,[CreatedBy]
		  ,[CreatedOn]
		  ,[LastUpdatedBy]
		  ,[LastUpdatedOn]

	FROM   [TransactionMaster] INNER JOIN
    CategoryMaster ON  TransactionMaster.CategoryID=CategoryMaster.CategoryID 
    
	where UserID=@EmployeeID 
	 

END
GO
