-- =============================================
-- Author:		Vrushali Kamthe
-- Create date: 2018-10-09
-- Description:	This procedure fetches data from SubShareRegMaster table and inserts it into LinkedSubShareRegMaster table on Linked Server
-- =============================================
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'SP_SubShareRegMaster')
BEGIN
DROP PROCEDURE SP_SubShareRegMaster
END
GO

create    PROCEDURE [dbo].[SP_SubShareRegMaster]
	-- Add the parameters for the stored procedure here
		@DBName VARCHAR(50),
		@LinkedServer VARCHAR(50),
		@ESOPVersion VARCHAR(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	    SET NOCOUNT ON;
    DECLARE @TRUSTGLOBALDBNAME AS VARCHAR (50);
    SET @TRUSTGLOBALDBNAME = 'TrustGlobal';
    DECLARE @TRUSTDBNAME AS VARCHAR (50);
    SET @TRUSTDBNAME = 'Trust';

	DECLARE @USEDB VARCHAR(max) ='USE [' + @DBName +  ']'; 
    --EXECUTE(@USEDB)

	DECLARE @USETRUST AS VARCHAR (50) = 'USE [' + @DBName + ']';
	DECLARE @StrInsertQuery AS VARCHAR (MAX);

	DECLARE @ClearDataQuery AS VARCHAR(max) = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[LinkedSubShareRegMaster]';
	EXEC(@ClearDataQuery);

    IF (@ESOPVersion = 'Global')
    BEGIN
		SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[LinkedSubShareRegMaster](SubShareRegID, RegID, SeqID, 
		CompanyID, SchemeID, GrantRegID, ExercisePrice, ClosingBal, CreatedOn, CreatedBy, InstrumentTypeID, SelectionFilter)
		(SELECT SubShareRegID,	RegID, SeqID, CompanyID, SchemeID, GrantRegID, ExercisePrice, ClosingBal, CreatedOn, CreatedBy,	InstrumentTypeID, 
		SelectionFilter FROM [' + @TRUSTGLOBALDBNAME + ']..[SubShareRegMaster] WITH (NOLOCK) where CompanyID = ''' + @DBName + ''')';
		EXEC(@StrInsertQuery);
	 END
	 ELSE
	 BEGIN
		SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[LinkedSubShareRegMaster](SubShareRegID, RegID, SeqID, 
		CompanyID, SchemeID, GrantRegID, ExercisePrice, ClosingBal, CreatedOn, CreatedBy)
		(SELECT SubShareRegID,	RegID, SeqID, CompanyID, SchemeID, GrantRegID, ExercisePrice, ClosingBal, CreatedOn, CreatedBy 
		FROM [' + @TRUSTDBNAME + ']..[SubShareRegMaster] WITH (NOLOCK) where CompanyID = ''' + @DBName + ''')';
		EXEC(@StrInsertQuery);
	 END

	DECLARE @StrUpdateQuery AS VARCHAR(max) = 'Update [' + @LinkedServer + '].[' + @DBName +  ']. [dbo].[LinkedSubShareRegMaster] 
	SET PushDate = ''' + CONVERT (CHAR (50), GetDate(), 121) +'''';
	EXEC(@StrUpdateQuery);

END
GO

