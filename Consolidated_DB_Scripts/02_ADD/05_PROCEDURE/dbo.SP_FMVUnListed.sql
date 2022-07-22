-- =============================================
-- Author:		Vrushali Kamthe	
-- Create date: 2018-10-09
-- Description:	This procedure brings data from FMVForUnlisted table and inserts it into LinkedFMVForUnlisted table on linked server
-- =============================================
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'SP_FMVUnListed')
BEGIN
DROP PROCEDURE SP_FMVUnListed
END
GO

create    PROCEDURE [dbo].[SP_FMVUnListed]
	-- Add the parameters for the stored procedure here
		@DBName VARCHAR(50),
		@LinkedServer VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @USEDB VARCHAR(max) ='USE [' + @DBName +  ']'; 
    EXECUTE(@USEDB)

	DECLARE @StrInsertQuery AS VARCHAR(max);
	
	DECLARE @ClearDataQuery AS VARCHAR(max) = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[LinkedFMVForUnlisted]';
	EXEC(@ClearDataQuery);

	SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[LinkedFMVForUnlisted](FMV, FMV_FromDate, FMV_Todate, CreatedBy, Updatedon)
	(SELECT FMV, FMV_FromDate, FMV_Todate, CreatedBy, Updatedon FROM FMVForUnlisted WITH (NOLOCK))';
	EXEC(@StrInsertQuery);

	 DECLARE @StrUpdateQuery AS VARCHAR(max) = 'Update [' + @LinkedServer + '].[' + @DBName +  ']. [dbo].[LinkedFMVForUnlisted] 
	 SET PushDate = ''' + CONVERT (CHAR (50), GetDate(), 121) +'''';
	 EXEC(@StrUpdateQuery);
END
GO

