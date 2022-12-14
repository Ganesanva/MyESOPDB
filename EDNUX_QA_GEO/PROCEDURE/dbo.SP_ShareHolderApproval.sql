/****** Object:  StoredProcedure [dbo].[SP_ShareHolderApproval]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_ShareHolderApproval]
GO
/****** Object:  StoredProcedure [dbo].[SP_ShareHolderApproval]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Vrushali Kamthe
-- Create date: 2018-12-14	
-- Description:	This procedures brings data from ShareHolderApproval table and inserts it into ShareHolderApprovalData table on linked server
-- Update date: 24-06-2022
-- Description: AvailableShares Update for Pool Balance Report
--				AvailableShares =(Number Of Shares - OptionsGranted) + (OptionsCancelled + OptionsLapsed)
-- =============================================
CREATE   PROCEDURE [dbo].[SP_ShareHolderApproval]
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
	DECLARE @ClearDataQuery AS VARCHAR(max) = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[ShareHolderApprovalData]' ;
	EXEC(@ClearDataQuery);

	CREATE TABLE #AvailableSharesTBL (SchemeName VARCHAR(500), ApprovalId VARCHAR(200) NULL
		,NumberOfShares INT DEFAULT 0,AvailableShares INT, OptionsGranted INT, OptionsCancelled INT, OptionsLapsed INT)
	DECLARE @NumberOfShares INT=0

	DECLARE @strUpdateQuery1 AS VARCHAR(MAX);
	SET @strUpdateQuery1 =CONCAT('
	INSERT INTO #AvailableSharesTBL
	(SchemeName, OptionsGranted , OptionsCancelled , OptionsLapsed )'
	,'SELECT SchemeName, SUM(OptionsGranted) , SUM(OptionsCancelled) , SUM(OptionsLapsed)  FROM [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[GrantConsolidatedReport] GROUP BY SchemeName' )
	EXECUTE (@strUpdateQuery1)

	UPDATE #AvailableSharesTBL
	SET ApprovalId = SD.ApprovalID, NumberOfShares = SHA.NumberOfShares
	, AvailableShares = (SHA.NumberOfShares - OptionsGranted) + (OptionsCancelled + OptionsLapsed)
	FROM #AvailableSharesTBL TD
	INNER JOIN (SELECT DISTINCT GL.ApprovalId, GL.SchemeId 
	FROM GrantLeg GL) SD
	ON TD.SchemeName = SD.SchemeId
	LEFT OUTER JOIN ShareHolderApproval SHA
	ON SD.ApprovalId = SHA.ApprovalId

	SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[ShareHolderApprovalData](ApprovalId, ApprovalDate, NumberOfShares, AvailableShares, AdditionalShares)
	(SELECT ApprovalId, ApprovalDate, NumberOfShares, AvailableShares, AdditionalShares	FROM ShareHolderApproval WITH (NOLOCK))';

	EXEC(@StrInsertQuery);

	SET @strUpdateQuery1 =CONCAT('UPDATE [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[ShareHolderApprovalData]'
		,' SET AvailableShares = SD.AvailableShares '
		, ' FROM [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[ShareHolderApprovalData] TD '
		, ' INNER JOIN #AvailableSharesTBL SD'
		, ' ON SD.ApprovalId = TD.ApprovalId')

	EXEC(@strUpdateQuery1);

	 DECLARE @StrUpdateQuery AS VARCHAR(max) = 'Update [' + @LinkedServer + '].[' + @DBName +  ']. [dbo].[ShareHolderApprovalData] 
	 SET PushDate = ''' + CONVERT (CHAR (50), GetDate(), 121) +'''';
	 EXEC(@StrUpdateQuery);

END

GO
