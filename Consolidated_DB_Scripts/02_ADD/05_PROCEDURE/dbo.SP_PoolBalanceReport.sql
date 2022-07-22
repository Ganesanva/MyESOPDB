-- =============================================
-- Author:		VRUSHALI KAMTHE
-- Create date: 2018-10-05
-- Description:	It extracts data from PROC_GET_POOL_BALANCE_REPORT procedure and dumps it into PoolBalance table on Linked Server
-- =============================================
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'SP_PoolBalanceReport')
BEGIN
DROP PROCEDURE SP_PoolBalanceReport
END
GO

CREATE    PROCEDURE [dbo].[SP_PoolBalanceReport]
	-- Add the parameters for the stored procedure here
		@DBName VARCHAR(50),
		@LinkedServer VARCHAR(50),
		@ESOPVersion VARCHAR(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @USEDB VARCHAR(max) ='USE [' + @DBName +  ']'; 
    EXECUTE(@USEDB)

	DECLARE @StrInsertQuery AS VARCHAR(max);
	
	SET XACT_ABORT ON;

	DECLARE @ClearDataQuery AS VARCHAR(max) = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[PoolBalance]' ;
	EXEC(@ClearDataQuery);

    -- Insert statements for procedure here
		IF(@ESOPVersion = 'Global')
		BEGIN
		CREATE TABLE #PoolBalanceTemp(
	[SCHEMEID] [varchar](50) NULL,
	[SCHEMETITLE] [varchar](50) NULL,
	[ApprovalId] [varchar](20) NULL,
	[NOOFOPTIONSGRANTED] [numeric](18, 0) NULL,
	[EXERCISEDQUANTITY] [numeric](18, 0) NULL,
	[SHAREISSUE] [numeric](18, 6) NULL,
	[MIT_ID] [bigint] NULL,
	[IS_INSTRUMENT] [int] NULL
) 
			SET @StrInsertQuery = 'INSERT INTO #PoolBalanceTemp (SCHEMEID, SCHEMETITLE, ApprovalId, NOOFOPTIONSGRANTED,
							EXERCISEDQUANTITY, SHAREISSUE, MIT_ID, IS_INSTRUMENT)
							EXECUTE [dbo].[SP_PoolBalanceQR] '; --'' + @APPROVAL_ID + ''',''' + @ACTION + ''', ''' + @QRPARAMETER + '''';
							EXEC(@StrInsertQuery);

							SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[PoolBalance] (SCHEMEID, SCHEMETITLE, ApprovalId, NOOFOPTIONSGRANTED,
							EXERCISEDQUANTITY, SHAREISSUE, MIT_ID, IS_INSTRUMENT)
							SELECT SCHEMEID, SCHEMETITLE, ApprovalId, NOOFOPTIONSGRANTED,
							EXERCISEDQUANTITY, SHAREISSUE, MIT_ID, IS_INSTRUMENT FROM #PoolBalanceTemp';
							EXEC(@StrInsertQuery);

		END
		ELSE 
		BEGIN
			SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[PoolBalance] (SCHEMEID, SCHEMETITLE, ApprovalId, NOOFOPTIONSGRANTED,
							EXERCISEDQUANTITY)
							EXECUTE [dbo].[SP_PoolBalanceQR] ';-- + @APPROVAL_ID + ''',''' + @ACTION + ''', ''' + @QRPARAMETER + '''';
		END
	    PRINT(@StrInsertQuery);
		--EXEC(@StrInsertQuery);

	 DECLARE @StrUpdateQuery AS VARCHAR(max) = 'Update [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[PoolBalance] 
												SET PushDate = ''' + CONVERT (VARCHAR (50), CONVERT (CHAR (50), GetDate(), 121)) +'''';
	 EXEC(@StrUpdateQuery);
END
GO

