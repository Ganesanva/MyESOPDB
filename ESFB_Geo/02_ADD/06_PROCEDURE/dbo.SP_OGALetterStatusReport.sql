-- Author: <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'SP_OGALetterStatusReport')
BEGIN
DROP PROCEDURE SP_OGALetterStatusReport
END
GO

create    PROCEDURE [dbo].[SP_OGALetterStatusReport]
-- Add the parameters for the stored procedure here
@DBName VARCHAR(50),
@LinkedServer VARCHAR(50),
@PartialDataPush BIT = 0
AS
BEGIN
SET NOCOUNT ON; DECLARE @USEDB VARCHAR(max) ='USE [' + @DBName + ']';
EXECUTE(@USEDB) DECLARE @StrInsertQuery AS VARCHAR(max);
DECLARE @ClearDataQuery AS VARCHAR(max);
DECLARE @StrUpdateQuery AS VARCHAR(max);
IF(@PartialDataPush = 1)
BEGIN
SET @ClearDataQuery = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName + '].[dbo].[P_OGALetterStatusReport]';
EXEC(@ClearDataQuery); SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[P_OGALetterStatusReport]([SRNO], [GAMUID], [EmployeeID], [EmployeeName], [SchemeName], [LetterCode], [GrantDate], [GrantType], [TotalOptions],
[Currency], [ExercisePrice], [FirstVestDate], [NoOfVests], [VestingFrequency], [VestingPercentage], [Adjustment],
[CompanyName], [CompanyAddress], [LotNumber], [LastAcceptanceDate], [LetterAcceptanceStatus], [LetterAcceptanceDate],
[IP_ADDRESS], [GrantLetterName], [MailSentStatus], [MailSentDate], [VestPeriod], [VestingDate], [NoOfOptions], [IsGlGenerated])
SELECT
DENSE_RANK() OVER (ORDER BY GAMU.EmployeeID,GAMU.LetterCode ) AS SRNO, GAMU.GAMUID,
GAMU.EmployeeID, EM.EmployeeName, GAMU.SchemeName, GAMU.LetterCode, GAMU.GrantDate, GAMU.GrantType, GAMU.NoOfOptions AS TOTAL_OPTIONS, GAMU.Currency, GAMU.ExercisePrice,
GAMU.FirstVestDate, GAMU.NoOfVests, GAMU.VestingFrequency, GAMU.VestingPercentage, GAMU.Adjustment, GAMU.CompanyName, GAMU.CompanyAddress,
GAMU.LotNumber, GAMU.LastAcceptanceDate,
CASE
WHEN GAMU.LetterAcceptanceStatus = ''P'' AND (SELECT ACSID FROM OGA_CONFIGURATIONS) = ''4'' THEN ''Pending for Acceptance''
WHEN GAMU.LetterAcceptanceStatus = ''P'' AND (SELECT ACSID FROM OGA_CONFIGURATIONS) <> ''4'' THEN ''Pending for Acceptance/Rejection''
WHEN GAMU.LetterAcceptanceStatus = ''R'' THEN ''Rejected''
WHEN GAMU.LetterAcceptanceStatus = ''A'' THEN ''Accepted''
ELSE ''No Action Taken'' END LetterAcceptanceStatus, GAMU.LetterAcceptanceDate,
CASE WHEN GAMU.LetterAcceptanceDate IS NULL THEN
''''
ELSE
(SELECT TOP 1 UL.IP_ADDRESS from UserLoginHistory UL WHERE UL.ORGANIZATION = ''OGA'' AND UL.UserId = EM.LoginID AND (CONVERT(DATETIME, UL.LoginDate) <= CONVERT(DATETIME, GAMU.LetterAcceptanceDate) AND CONVERT(DATETIME, ISNULL(UL.LogOutDate, GAMU.LetterAcceptanceDate)) >= CONVERT(DATETIME, GAMU.LetterAcceptanceDate)) ORDER BY UL.Idt DESC)
END
AS IP_ADDRESS,
GAMU.GrantLetterName, GAMU.MailSentStatus, GAMU.MailSentDate, GAMUD.VestPeriod,
GAMUD.VestingDate, GAMUD.NoOfOptions,
CASE WHEN GAMU.IsGlGenerated = 1 THEN ''Yes'' ELSE ''No'' END IsGlGenerated
FROM GrantAccMassUpload AS GAMU
INNER JOIN GrantAccMassUploadDet AS GAMUD ON GAMU.GAMUID = GAMUD.GAMUID
INNER JOIN EmployeeMaster AS EM ON GAMU.EmployeeID = EM.EmployeeID';
EXEC(@StrInsertQuery); SET @StrUpdateQuery = 'Update [' + @LinkedServer + '].[' + @DBName + ']. [dbo].[P_OGALetterStatusReport]
SET PushDate = ''' + CONVERT (CHAR (10), GetDate(), 126) +'''';
EXEC(@StrUpdateQuery);
END
ELSE
BEGIN
SET @ClearDataQuery = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName + '].[dbo].[OGALetterStatusReport]';
EXEC(@ClearDataQuery); SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[OGALetterStatusReport]([SRNO], [GAMUID], [EmployeeID], [EmployeeName], [SchemeName], [LetterCode], [GrantDate], [GrantType], [TotalOptions],
[Currency], [ExercisePrice], [FirstVestDate], [NoOfVests], [VestingFrequency], [VestingPercentage], [Adjustment],
[CompanyName], [CompanyAddress], [LotNumber], [LastAcceptanceDate], [LetterAcceptanceStatus], [LetterAcceptanceDate],
[IP_ADDRESS], [GrantLetterName], [MailSentStatus], [MailSentDate], [VestPeriod], [VestingDate], [NoOfOptions], [IsGlGenerated])
SELECT
DENSE_RANK() OVER (ORDER BY GAMU.EmployeeID,GAMU.LetterCode ) AS SRNO, GAMU.GAMUID,
GAMU.EmployeeID, EM.EmployeeName, GAMU.SchemeName, GAMU.LetterCode, GAMU.GrantDate, GAMU.GrantType, GAMU.NoOfOptions AS TOTAL_OPTIONS, GAMU.Currency, GAMU.ExercisePrice,
GAMU.FirstVestDate, GAMU.NoOfVests, GAMU.VestingFrequency, GAMU.VestingPercentage, GAMU.Adjustment, GAMU.CompanyName, GAMU.CompanyAddress,
GAMU.LotNumber, GAMU.LastAcceptanceDate,
CASE
WHEN GAMU.LetterAcceptanceStatus = ''P'' AND (SELECT ACSID FROM OGA_CONFIGURATIONS) = ''4'' THEN ''Pending for Acceptance''
WHEN GAMU.LetterAcceptanceStatus = ''P'' AND (SELECT ACSID FROM OGA_CONFIGURATIONS) <> ''4'' THEN ''Pending for Acceptance/Rejection''
WHEN GAMU.LetterAcceptanceStatus = ''R'' THEN ''Rejected''
WHEN GAMU.LetterAcceptanceStatus = ''A'' THEN ''Accepted''
ELSE ''No Action Taken'' END LetterAcceptanceStatus, GAMU.LetterAcceptanceDate,
CASE WHEN GAMU.LetterAcceptanceDate IS NULL THEN
''''
ELSE
(SELECT TOP 1 UL.IP_ADDRESS from UserLoginHistory UL WHERE UL.ORGANIZATION = ''OGA'' AND UL.UserId = EM.LoginID AND (CONVERT(DATETIME, UL.LoginDate) <= CONVERT(DATETIME, GAMU.LetterAcceptanceDate) AND CONVERT(DATETIME, ISNULL(UL.LogOutDate, GAMU.LetterAcceptanceDate)) >= CONVERT(DATETIME, GAMU.LetterAcceptanceDate)) ORDER BY UL.Idt DESC)
END
AS IP_ADDRESS,
GAMU.GrantLetterName, GAMU.MailSentStatus, GAMU.MailSentDate, GAMUD.VestPeriod,
GAMUD.VestingDate, GAMUD.NoOfOptions,
CASE WHEN GAMU.IsGlGenerated = 1 THEN ''Yes'' ELSE ''No'' END IsGlGenerated
FROM GrantAccMassUpload AS GAMU
INNER JOIN GrantAccMassUploadDet AS GAMUD ON GAMU.GAMUID = GAMUD.GAMUID
INNER JOIN EmployeeMaster AS EM ON GAMU.EmployeeID = EM.EmployeeID';
EXEC(@StrInsertQuery); SET @StrUpdateQuery = 'Update [' + @LinkedServer + '].[' + @DBName + ']. [dbo].[OGALetterStatusReport]
SET PushDate = ''' + CONVERT (CHAR (10), GetDate(), 126) +'''';
EXEC(@StrUpdateQuery);
END
END
GO

