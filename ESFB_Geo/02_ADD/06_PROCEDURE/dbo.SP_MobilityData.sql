-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'SP_MobilityData')
BEGIN
DROP PROCEDURE SP_MobilityData
END
GO

create    PROCEDURE [dbo].[SP_MobilityData] 
	-- Add the parameters for the stored procedure here
	@DBName VARCHAR(50),
	@LinkedServer VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @USEDB VARCHAR(max) ='USE [' + @DBName +  ']'; 
    EXECUTE(@USEDB)

	DECLARE @StrInsertQuery AS VARCHAR(max);
	
	DECLARE @ClearDataQuery AS VARCHAR(max) = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[MobilityData]';
	EXEC(@ClearDataQuery);
	
	IF(OBJECT_ID(N'dbo.AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD', N'U') IS NOT NULL)
    BEGIN
		SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[MobilityData]([SRNO],[Field],[EmployeeId],[EmployeeName],
		[Status],[CurrentDetails],[FromDate],[Moved To],[From Date of Movement])
		(SELECT [SRNO],[Field],[EmployeeId],[EmployeeName],	[Status],[CurrentDetails],[FromDate],[Moved To],[From Date of Movement] FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD WITH (NOLOCK))';
		EXEC(@StrInsertQuery);

		DECLARE @StrUpdateQuery AS VARCHAR(max) = 'Update [' + @LinkedServer + '].[' + @DBName +  ']. [dbo].[MobilityData] 
		SET PushDate = ''' + CONVERT (CHAR (50), GetDate(), 121) +'''';
		EXEC(@StrUpdateQuery);
	END
END
GO

