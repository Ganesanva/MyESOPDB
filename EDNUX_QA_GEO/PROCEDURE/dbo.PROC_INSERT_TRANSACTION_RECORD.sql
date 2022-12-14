/****** Object:  StoredProcedure [dbo].[PROC_INSERT_TRANSACTION_RECORD]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_INSERT_TRANSACTION_RECORD]
GO
/****** Object:  StoredProcedure [dbo].[PROC_INSERT_TRANSACTION_RECORD]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_INSERT_TRANSACTION_RECORD]

    @EmployeeID VARCHAR(50),
	@UserType varchar(100),
	@TableName varchar(100),
	@TableFieldName varchar(100),
	@OldValue varchar(500),
	@NewValue varchar(500),
	@TransactionDescription varchar(MAX),
	@TransactionDate datetime,
	@CategoryName nvarchar(100),
	@CreatedBy varchar(100),
	@CreatedOn datetime,
	@LastUpdatedBy varchar(100),
	@LastUpdatedOn datetime
AS
BEGIN

DECLARE @IsResult INT
DECLARE @CategoryID varchar(100)
SET @CategoryID=(SELECT CategoryID FROM CategoryMaster where CategoryName=@CategoryName)

 INSERT INTO [TransactionMaster]
           ([UserID]
           ,[UserType]
           ,[TableName]
           ,[TableFieldName]
           ,[OldValue]
           ,[NewValue]
           ,[TransactionDescription]
           ,[TransactionDate]
           ,[CategoryID]
           ,[CreatedBy]
           ,[CreatedOn]
           ,[LastUpdatedBy]
           ,[LastUpdatedOn])
     VALUES
           (@EmployeeID
           ,@UserType
           ,@TableName
           ,@TableFieldName
           ,@OldValue
           ,@NewValue
           ,@TransactionDescription
           ,@TransactionDate
           ,@CategoryID
           ,@CreatedBy
           ,@CreatedOn
           ,@LastUpdatedBy
           ,@LastUpdatedOn)
  SET @IsResult = @@ROWCOUNT

  	IF @IsResult > 0
			BEGIN			
			    SELECT * FROM TransactionMaster WHERE  UserID = @EmployeeID
			END
			ELSE
			BEGIN
			  SELECT 'F' AS [STATUS], CASE WHEN @@ERROR <> 0 THEN 'Error while save Transaction.' ELSE 'Record already exist.' END AS [MESSAGE]
			END
END
GO
