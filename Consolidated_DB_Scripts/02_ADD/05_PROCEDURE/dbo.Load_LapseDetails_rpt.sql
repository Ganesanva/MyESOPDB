/****** Object:  StoredProcedure [dbo].[Load_LapseDetails_rpt]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Load_LapseDetails_rpt]
GO
/****** Object:  StoredProcedure [dbo].[Load_LapseDetails_rpt]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Geopits
-- Create date: 2021-09-12
-- Description:	Power BI Reporting
-- =============================================

create   PROCEDURE [dbo].[Load_LapseDetails_rpt] 
	-- Add the parameters for the stored procedure here
	@DBName VARCHAR(50),
	@LinkedServer VARCHAR(50),
	@ESOPVersion VARCHAR (50)=NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @USEDB AS VARCHAR (MAX) = 'USE [' + @DBName + ']';
    EXECUTE (@USEDB);
    DECLARE @StrInsertQuery AS VARCHAR (MAX) = 'USE [' + @DBName + ']';
    SET XACT_ABORT ON;
    DECLARE @ClearDataQuery AS VARCHAR (MAX) = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName + '].[dbo].[LapseDetails_rpt]';
    EXECUTE (@ClearDataQuery);
    IF (@ESOPVersion = 'Global')
        BEGIN
            SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[LapseDetails_rpt]   
			(SchemeTitle
			,GrantDate
			,GrantRegistration
			,ExercisePrice
			,EmployeeID
			,EmployeeName
			,GrantOpId
			,Status
			,ExpiryDate
			,OptionsLapsed
			,Parent
			,CSFlag
			,PANnumber)
			EXECUTE [dbo].[LapseDetails_rpt] ';
            EXECUTE (@StrInsertQuery);
        END
    ELSE
        BEGIN
		 CREATE TABLE #LAPSEDETAILS (
                SchemeTitle             [varchar](50),
				GrantDate	            [datetime], 
				GrantRegistration       [varchar](20),
				ExercisePrice	        [numeric](18, 0),
				EmployeeID				[varchar](20),
				EmployeeName	        [varchar](75),
				GrantOpId               [varchar](100),
				Status					[datetime],
				ExpiryDate				[datetime],
				OptionsLapsed			[numeric](18, 0),
				Parent					[varchar](20),
				CSFlag					[varchar](20),
				PANnumber               [varchar](10),
				RowInsrtDttm			DATETIME,
				RowUpdtDttm				DATETIME     
				 );
            SET @StrInsertQuery = 'INSERT INTO #LAPSEDETAILS (
			 SchemeTitle
			,GrantDate
			,GrantRegistration
			,ExercisePrice
			,EmployeeID
			,EmployeeName
			,GrantOpId
			,Status
			,ExpiryDate
			,OptionsLapsed
			,Parent
			,CSFlag
			,PANnumber
			)
			 EXECUTE [dbo].[SP_LAPSE_REPORT_rpt] ';
            PRINT (@StrInsertQuery);
            EXECUTE (@StrInsertQuery);
            SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[LapseDetails_rpt]   
			(
			 SchemeTitle
			,GrantDate
			,GrantRegistration
			,ExercisePrice
			,EmployeeID
			,EmployeeName
			,GrantOpId
			,Status
			,ExpiryDate
			,OptionsLapsed
			,Parent
			,CSFlag
			,PANnumber
			,RowInsrtDttm
			,RowUpdtDttm
			)
			SELECT SchemeTitle
			,GrantDate
			,GrantRegistration
			,ExercisePrice
			,EmployeeID
			,EmployeeName
			,GrantOpId
			,Status
			,ExpiryDate
			,OptionsLapsed
			,Parent
			,CSFlag
			,PANnumber
			,getdate()
			,getdate()
			FROM #LAPSEDETAILS';
            PRINT (@StrInsertQuery);
            EXECUTE (@StrInsertQuery);
        END
    --DECLARE @StrUpdateQuery AS VARCHAR (MAX) = 'Update [' + @LinkedServer + '].[' + @DBName + '].[dbo].[PersonalStatusReport] SET PushDate = ''' + CONVERT (VARCHAR (50), CONVERT (CHAR (10), GetDate(), 126)) + '''';
    --EXECUTE (@StrUpdateQuery);
END
GO
