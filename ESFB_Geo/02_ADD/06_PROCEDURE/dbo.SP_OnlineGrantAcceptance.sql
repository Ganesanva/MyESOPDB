-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'SP_OnlineGrantAcceptance')
BEGIN
DROP PROCEDURE SP_OnlineGrantAcceptance
END
GO

create    PROCEDURE [dbo].[SP_OnlineGrantAcceptance] 
	-- Add the parameters for the stored procedure here
	@DBName VARCHAR(50),
	@LinkedServer VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @USEDB VARCHAR(max) ='USE [' + @DBName +  ']'; 
    EXECUTE(@USEDB)

	DECLARE @StrInsertQuery AS VARCHAR(max);
	
	DECLARE @ClearDataQuery AS VARCHAR(max) = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[GrantAccMassUploadMaster]';
	EXEC(@ClearDataQuery);

	SET @ClearDataQuery = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[GrantAccMassUploadDetails]';
	EXEC(@ClearDataQuery);

	DECLARE @StrUpdateQuery AS VARCHAR(max);

	IF(OBJECT_ID(N'dbo.GrantAccMassUpload', N'U') IS NOT NULL)
    BEGIN
		SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[GrantAccMassUploadMaster](GAMUID,[EmployeeID], [SchemeName], 
		[LetterCode], [GrantDate], [GrantType], [NoOfOptions], [Currency], [ExercisePrice],
		[FirstVestDate], [NoOfVests], [VestingFrequency], [VestingPercentage], [Adjustment], [CompanyName],	[CompanyAddress],
		[LotNumber], [LastAcceptanceDate], [LetterAcceptanceStatus], [LetterAcceptanceDate], [GrantLetterName])
		(SELECT GAMUID,[EmployeeID], [SchemeName], 
		[LetterCode], [GrantDate], [GrantType], [NoOfOptions], [Currency], [ExercisePrice],
		[FirstVestDate], [NoOfVests], [VestingFrequency], [VestingPercentage], [Adjustment], [CompanyName],	[CompanyAddress],
		[LotNumber], [LastAcceptanceDate], [LetterAcceptanceStatus], [LetterAcceptanceDate], [GrantLetterName] FROM GrantAccMassUpload WITH (NOLOCK))';
		EXEC(@StrInsertQuery);

		SET @StrUpdateQuery = 'Update [' + @LinkedServer + '].[' + @DBName +  ']. [dbo].[GrantAccMassUploadMaster] 
		SET PushDate = ''' + CONVERT (CHAR (50), GetDate(), 121) +'''';
		EXEC(@StrUpdateQuery);
	END

	IF(OBJECT_ID(N'dbo.GrantAccMassUploadDet', N'U') IS NOT NULL)
    BEGIN
		SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[GrantAccMassUploadDetails](GAMUID,[LetterCode],[VestPeriod],
		[VestingDate],[NoOfOptions])(SELECT GAMUID,[LetterCode],[VestPeriod],[VestingDate],[NoOfOptions] FROM GrantAccMassUploadDet WITH (NOLOCK))';
		EXEC(@StrInsertQuery);

		SET @StrUpdateQuery = 'Update [' + @LinkedServer + '].[' + @DBName +  ']. [dbo].[GrantAccMassUploadDetails] 
		SET PushDate = ''' + CONVERT (CHAR (50), GetDate(), 121) +'''';
		EXEC(@StrUpdateQuery);
	END
END
GO

