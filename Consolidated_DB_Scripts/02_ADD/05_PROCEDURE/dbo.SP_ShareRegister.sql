-- =============================================
-- Author:		Vrushali Kamthe
-- Create date: 2018-10-09
-- Description:	This procedure fetches data from ShareRegister table and inserts it into LinkedShareRegister table on Linked Server
-- =============================================
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'SP_ShareRegister')
BEGIN
DROP PROCEDURE SP_ShareRegister
END
GO

create    PROCEDURE [dbo].[SP_ShareRegister]
	-- Add the parameters for the stored procedure here
	@DBName VARCHAR(50),
	@LinkedServer VARCHAR(50),
	@ESOPVersion VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @TRUSTGLOBALDBNAME AS VARCHAR (50);
    SET @TRUSTGLOBALDBNAME = 'TrustGlobal';
    DECLARE @TRUSTDBNAME AS VARCHAR (50);
    SET @TRUSTDBNAME = 'Trust';
    DECLARE @USEDB AS VARCHAR (MAX) = 'USE [' + @DBName + ']';
    DECLARE @USETRUST AS VARCHAR (50) = 'USE [' + @DBName + ']';
    DECLARE @StrInsertQuery AS VARCHAR (MAX) = 'USE [' + @DBName + ']';
    DECLARE @ClearDataQuery AS VARCHAR (MAX) = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName + '].[dbo].[LinkedShareRegister]';
    EXECUTE (@ClearDataQuery);
    IF (@ESOPVersion = 'Global')
        BEGIN
            SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[LinkedShareRegister](ShareRegisterID, TrustID, ClientId, 
			DateOfTransaction, Particular, NumberOfShares,	ClosingBalance,	TypeOfTransaction, Comments, ActiveStatus, DeleteStatus, CreatedOn, CreatedBy, 
			ModifiedOn, ModifiedBy)
			(SELECT ShareRegisterID, TrustID, ClientId, DateOfTransaction, Particular, NumberOfShares, ClosingBalance, TypeOfTransaction, Comments, ActiveStatus,
			DeleteStatus, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM [' + @TRUSTGLOBALDBNAME + ']..[ShareRegister] 
WITH (NOLOCK) where ClientId = ''' + @DBName + ''')';
            EXECUTE (@StrInsertQuery);
        END
    ELSE
        BEGIN
            PRINT 'IN MYESOPS';
            SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[LinkedShareRegister](ShareRegisterID, TrustID, ClientId, 
				DateOfTransaction, Particular, NumberOfShares,	ClosingBalance,	TypeOfTransaction, Comments, ActiveStatus, DeleteStatus, CreatedOn, CreatedBy, 
				ModifiedOn, ModifiedBy)
				(SELECT ShareRegisterID, TrustID, ClientId, DateOfTransaction, Particular, NumberOfShares, ClosingBalance, TypeOfTransaction, Comments, ActiveStatus,
				DeleteStatus, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy FROM [' + @TRUSTDBNAME + ']..[ShareRegister] 
WITH (NOLOCK) where ClientId = ''' + @DBName + ''')';
            PRINT (@StrInsertQuery);
            EXECUTE (@StrInsertQuery);
        END
    DECLARE @StrUpdateQuery AS VARCHAR (MAX) = 'Update [' + @LinkedServer + '].[' + @DBName + ']. [dbo].[LinkedShareRegister] 
		 SET PushDate = ''' + CONVERT (CHAR (50), GetDate(), 121) + '''';
    EXECUTE (@StrUpdateQuery);
END
GO

