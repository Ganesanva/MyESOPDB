/****** Object:  StoredProcedure [dbo].[Load_CancellationDetails_rpt]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Load_CancellationDetails_rpt]
GO
/****** Object:  StoredProcedure [dbo].[Load_CancellationDetails_rpt]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Geopits
-- Create date: 2021-09-12
-- Description:	Power BI Reporting
-- =============================================

create   PROCEDURE [dbo].[Load_CancellationDetails_rpt] 
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
    DECLARE @ClearDataQuery AS VARCHAR (MAX) = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName + '].[dbo].[CancellationDetails_rpt]';
    EXECUTE (@ClearDataQuery);
    IF (@ESOPVersion = 'Global')
        BEGIN
            SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[CancellationDetails_rpt]   (Expr1,GrantOptionId,GrantDate,VestingDate,	
FinalVestingDate,FinalExpirayDate,ExpirayDate,CancelledDate,Expr2,EmployeeID,EmployeeName,DateOfTermination,SchemeTitle,GrantRegistrationId,	
OptionRatioDivisor,OptionRatioMultiplier,GrantLegSerialNumber,CancelledQuantity,CancellationReason,Status,VestedUnVested,OptionsCancelled,Flag,Note,PANnumber,RowInsrtDttm,RowUpdtDttm)
				EXECUTE [dbo].[GetCancellationDetails_rpt] ';
            EXECUTE (@StrInsertQuery);
        END
    ELSE
        BEGIN
		 CREATE TABLE #CANCELDETAILS (
                Expr1                   [numeric](18, 0),
				GrantOptionId           [varchar](100),
				GrantDate	            [datetime], 
				VestingDate	            [datetime],
				FinalVestingDate        [datetime],	
				FinalExpirayDate        [datetime],
				ExpirayDate	            [datetime],
				CancelledDate	        [datetime],
				Expr2	                [varchar](100),
				EmployeeID              [varchar](20),
				EmployeeName	        [varchar](75),
				DateOfTermination       DATETIME,	
				SchemeTitle	            [varchar](50),
				GrantRegistrationId	    [varchar](20),
				OptionRatioDivisor	    [numeric](18, 0),
				OptionRatioMultiplier   [numeric](18, 0),
				GrantLegSerialNumber    [numeric](18, 0),
				CancelledQuantity	    [numeric](18, 0),
				CancellationReason	    [varchar](100),
				Status	                [varchar](10),
				VestedUnVested	        [varchar](15),
				OptionsCancelled	    [numeric](18, 2),
				Flag	                [numeric](18, 0),
				Note                    [varchar](15), 
				PANnumber               [varchar](10),
				RowInsrtDttm			DATETIME,
				RowUpdtDttm				DATETIME     

            );
            SET @StrInsertQuery = 'INSERT INTO #CANCELDETAILS (Expr1,GrantOptionId,GrantDate,VestingDate,	
FinalVestingDate,FinalExpirayDate,ExpirayDate,CancelledDate,Expr2,EmployeeID,EmployeeName,DateOfTermination,SchemeTitle,GrantRegistrationId,	
OptionRatioDivisor,OptionRatioMultiplier,GrantLegSerialNumber,CancelledQuantity,CancellationReason,Status,VestedUnVested,OptionsCancelled,Flag,Note,PANnumber,RowInsrtDttm,RowUpdtDttm)
				 EXECUTE [dbo].[GetCancellationDetails_rpt] ';
            PRINT (@StrInsertQuery);
            EXECUTE (@StrInsertQuery);
            SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[CancellationDetails_rpt]   
			(Expr1,GrantOptionId,GrantDate,VestingDate,FinalVestingDate,FinalExpirayDate,ExpirayDate,CancelledDate,Expr2,EmployeeID,EmployeeName,DateOfTermination,SchemeTitle,GrantRegistrationId,
			OptionRatioDivisor,OptionRatioMultiplier,GrantLegSerialNumber,CancelledQuantity,CancellationReason,Status,VestedUnVested,OptionsCancelled,Flag,Note,PANnumber,RowInsrtDttm,RowUpdtDttm)
			SELECT Expr1,GrantOptionId,GrantDate,VestingDate,FinalVestingDate,FinalExpirayDate,ExpirayDate,CancelledDate,Expr2,EmployeeID,EmployeeName,DateOfTermination,SchemeTitle,
			GrantRegistrationId,OptionRatioDivisor,OptionRatioMultiplier,GrantLegSerialNumber,CancelledQuantity,CancellationReason,Status,VestedUnVested,OptionsCancelled,Flag,Note,PANnumber,RowInsrtDttm,RowUpdtDttm FROM #CANCELDETAILS';
            PRINT (@StrInsertQuery);
            EXECUTE (@StrInsertQuery);
        END
    --DECLARE @StrUpdateQuery AS VARCHAR (MAX) = 'Update [' + @LinkedServer + '].[' + @DBName + '].[dbo].[PersonalStatusReport] SET PushDate = ''' + CONVERT (VARCHAR (50), CONVERT (CHAR (10), GetDate(), 126)) + '''';
    --EXECUTE (@StrUpdateQuery);
END
GO
