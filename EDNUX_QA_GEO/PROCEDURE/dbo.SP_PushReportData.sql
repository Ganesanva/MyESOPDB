/****** Object:  StoredProcedure [dbo].[SP_PushReportData]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_PushReportData]
GO
/****** Object:  StoredProcedure [dbo].[SP_PushReportData]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
			-- Data Push On New Quick Report Server 
			-- 23-06-2022

-- =============================================
CREATE     PROCEDURE [dbo].[SP_PushReportData]
@DBName VARCHAR (50), @LinkedServer VARCHAR (50), @REPORT VARCHAR (256)='All', @STATUS VARCHAR (20)='All', @FROMDATE DATETIME=NULL, @TODATE DATETIME=NULL, @APPROVALID VARCHAR (100)=NULL, @ACTION VARCHAR (50)='POOL', @EMPLOYEEID VARCHAR (50)='---All Employees---', @SCHEMEID VARCHAR (MAX)='---All Schemes---', @ACTIVITY CHAR='A',
@ESOPVersion VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @PUSHDATAQUERY AS VARCHAR (256);
	PRINT 'Start1'

	IF(@DBName IS NULL OR @LinkedServer IS NULL)
	BEGIN
		PRINT 'Database Name and Linked Server are needed to execute the migration.';
		return;
	END
	PRINT 'Start2'
    IF (@FROMDATE IS NULL)
        BEGIN
            SET @FROMDATE = '1990-01-01 00:00:00 AM';
            PRINT @FROMDATE;
        END
    IF (@TODATE IS NULL)
        BEGIN
            SET @TODATE = CONVERT (VARCHAR (50), CONVERT (CHAR (10), GetDate(), 126));
            PRINT @TODATE;
        END

	declare @DBVersion nvarchar(50)
	declare @s nvarchar(4000)
 PRINT 'Start3'
	set @s = N'select @var = DBVersion From ESOPManager..CompanyList Where CName = ''' + @DBName + '''';
	execute sp_executesql @s, N'@var varchar(50) output', @var = @DBVersion output
 PRINT 'Start4'
	print @DBVersion
	IF(@DBVersion = 'Global')
	BEGIN
		SET @ESOPVersion = @DBVersion;
	END

    DECLARE @USEDB AS VARCHAR (MAX);
    IF (@REPORT = 'All')
        BEGIN
            SET @USEDB = 'USE [' + @DBName + ']';
            EXECUTE (@USEDB);

            SET @PUSHDATAQUERY = 'EXECUTE SP_Master_Report_Data @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer 
			+ ''', @FromDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FROMDATE, 23)) 
			+ ''', @ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @TODATE, 23)) 
			+ ''', @ReportName = ''All''';
			IF(@ESOPVersion = 'Global') BEGIN SET @PUSHDATAQUERY = @PUSHDATAQUERY + ', @ESOPVersion = ''Global''';  END
            print @PUSHDATAQUERY
			EXECUTE (@PUSHDATAQUERY);
            PRINT '1. MASTER DATA PUSHED';
			

			SET @PUSHDATAQUERY = 'EXECUTE SP_Cancellation_Report @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer 
					+ ''', @FromDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FROMDATE, 23)) 
					+ ''', @ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @TODATE, 23)) + '''';
			IF(@ESOPVersion = 'Global') BEGIN SET @PUSHDATAQUERY = @PUSHDATAQUERY + ', @ESOPVersion = ''Global''';  END
            EXECUTE (@PUSHDATAQUERY);
			PRINT '2. CANCELLATION REPORT PUSHED';

            SET @PUSHDATAQUERY = 'EXECUTE SP_LapseReport @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer 
					+ ''', @FromDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FROMDATE, 23)) 
					+ ''', @ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @TODATE, 23)) + '''';
			IF(@ESOPVersion = 'Global') BEGIN SET @PUSHDATAQUERY = @PUSHDATAQUERY + ', @ESOPVersion = ''Global''';  END
            EXECUTE (@PUSHDATAQUERY);
            PRINT '3. LAPSE REPORT PUSHED';

            SET @PUSHDATAQUERY = 'EXECUTE SP_ExerciseReport @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer 
					+ ''', @FromDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FROMDATE, 23)) 
					+ ''', @ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @TODATE, 23)) 
					+ '''';
			IF(@ESOPVersion = 'Global') BEGIN SET @PUSHDATAQUERY = @PUSHDATAQUERY + ', @ESOPVersion = ''Global''';  END
            EXECUTE (@PUSHDATAQUERY);
            PRINT '4. EXERCISE REPORT PUSHED';
            
			SET @PUSHDATAQUERY = 'EXECUTE SP_User_Login_History_Report @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer 
					+ ''', @FromDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FROMDATE, 23)) 
					+ ''', @ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @TODATE, 23)) + '''';
            print @PUSHDATAQUERY
			EXECUTE (@PUSHDATAQUERY);
            PRINT '5. USER LOGIN HISTORY REPORT PUSHED';

			SET @PUSHDATAQUERY = 'EXECUTE SP_PersonalStatusReport @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer 
					+ ''', @Status = ''' + @STATUS + '''';
			IF(@ESOPVersion = 'Global') BEGIN SET @PUSHDATAQUERY = @PUSHDATAQUERY + ', @ESOPVersion = ''Global''';  END
            print @PUSHDATAQUERY
			EXECUTE (@PUSHDATAQUERY);
            PRINT '6. PERSONAL STATUS REPORT PUSHED';

            SET @APPROVALID = ' ';
            SET @PUSHDATAQUERY = 'EXECUTE SP_PoolBalanceReport @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer 
							+ '''';
			IF(@ESOPVersion = 'Global') BEGIN SET @PUSHDATAQUERY = @PUSHDATAQUERY + ', @ESOPVersion = ''Global''';  END
            EXECUTE (@PUSHDATAQUERY);
            PRINT '7. POOL BALANCE REPORT PUSHED';
            
			SET @PUSHDATAQUERY = 'EXECUTE SP_OnlineTransactionReport @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer 
					+ ''', @Employeeid =  ''' + @EMPLOYEEID + ''', @SchemeId = ''' + @SCHEMEID + ''', @Activity = ''' + @ACTIVITY + '''';
			IF(@ESOPVersion = 'Global') BEGIN SET @PUSHDATAQUERY = @PUSHDATAQUERY + ', @ESOPVersion = ''Global''';  END
            EXECUTE (@PUSHDATAQUERY);
            PRINT '8. OTR PUSHED';
            
			SET @PUSHDATAQUERY = 'EXECUTE SP_SchemeDetailParameters @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer + '''';
			IF(@ESOPVersion = 'Global') BEGIN SET @PUSHDATAQUERY = @PUSHDATAQUERY + ', @ESOPVersion = ''Global''';  END
            EXECUTE (@PUSHDATAQUERY);
            PRINT '9. SCHEME PARAMETERS PUSHED';

            SET @PUSHDATAQUERY = 'EXECUTE SP_GrantRegistrationParameters @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer + '''';
			IF(@ESOPVersion = 'Global') BEGIN SET @PUSHDATAQUERY = @PUSHDATAQUERY + ', @ESOPVersion = ''Global''';  END
            EXECUTE (@PUSHDATAQUERY);
            PRINT '10. GRANT REGISTRATION PARAMETERS PUSHED';

            SET @PUSHDATAQUERY = 'EXECUTE SP_StockPrice @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer + '''';
            EXECUTE (@PUSHDATAQUERY);
            PRINT '11. STOCK PRICE PARAMETERS PUSHED';

            SET @PUSHDATAQUERY = 'EXECUTE SP_FMVUnListed @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer + '''';
            EXECUTE (@PUSHDATAQUERY);
            PRINT '12. FMVUNLISTED PUSHED';

            SET @PUSHDATAQUERY = 'EXECUTE SP_CorporateActionParameter @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer + '''';
            EXECUTE (@PUSHDATAQUERY);
            PRINT '13. CORPORATE ACTION PARAMETERS PUSHED';

            SET @PUSHDATAQUERY = 'EXECUTE SP_ShareRegister @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer + '''';
			IF(@ESOPVersion = 'Global') BEGIN SET @PUSHDATAQUERY = @PUSHDATAQUERY + ', @ESOPVersion = ''Global''';  END
            EXECUTE (@PUSHDATAQUERY);
            PRINT '14. SHARE REGISTER PUSHED';

            SET @PUSHDATAQUERY = 'EXECUTE SP_SubShareRegMaster ''' + @DBName + ''', ''' + @LinkedServer + '''';
			IF(@ESOPVersion = 'Global') BEGIN SET @PUSHDATAQUERY = @PUSHDATAQUERY + ', @ESOPVersion = ''Global''';  END
            --EXECUTE (@PUSHDATAQUERY);
            PRINT '15. SUBSHAREREGMASTER PUSHED';

            SET @PUSHDATAQUERY = 'EXECUTE SP_OGALetterStatusReport ''' + @DBName + ''', ''' + @LinkedServer + '''';
            EXECUTE (@PUSHDATAQUERY);
			PRINT '16. Online Grant Acceptance PUSHED';
			
            SET @PUSHDATAQUERY = 'EXECUTE SP_MobilityData ''' + @DBName + ''', ''' + @LinkedServer + '''';
            EXECUTE (@PUSHDATAQUERY);
			PRINT '17. Mobility Data PUSHED';

            SET @PUSHDATAQUERY = 'EXECUTE SP_FairValueCalculation ''' + @DBName + ''', ''' + @LinkedServer + '''';
            EXECUTE (@PUSHDATAQUERY);
			PRINT '18. Fair Value Calculation PUSHED';

			SET @PUSHDATAQUERY = 'EXECUTE SP_GrantLeg ''' + @DBName + ''', ''' + @LinkedServer + '''';
            EXECUTE (@PUSHDATAQUERY);
			PRINT '19. Grant Leg Data PUSHED';

			SET @PUSHDATAQUERY = 'EXECUTE SP_SchemeSeparationRule @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer + '''';
			IF(@ESOPVersion = 'Global') BEGIN SET @PUSHDATAQUERY = @PUSHDATAQUERY + ', @ESOPVersion = ''Global''';  END
            EXECUTE (@PUSHDATAQUERY);
            PRINT '20. SCHEME SEPARATION RULE DATA PUSHED';

			SET @PUSHDATAQUERY = 'EXECUTE SP_ShareHolderApproval ''' + @DBName + ''', ''' + @LinkedServer + '''';
            EXECUTE (@PUSHDATAQUERY);
            PRINT '21. SHARE HOLDER APPROVAL DATA PUSHED';

			SET @PUSHDATAQUERY = 'EXECUTE SP_VestwiseReport_Split @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer 
					+ ''', @FromDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FROMDATE, 23)) 
					+ ''', @ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @TODATE, 23)) + '''';
			IF(@ESOPVersion = 'Global') BEGIN SET @PUSHDATAQUERY = @PUSHDATAQUERY + ', @ESOPVersion = ''Global''';  END
            EXECUTE (@PUSHDATAQUERY);
			PRINT '22. VESTWISE REPORT SPLIT VIEW PUSHED';

			SET @PUSHDATAQUERY = 'EXECUTE SP_GetExerciseReportSplitView @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer 
					+ ''', @FromDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FROMDATE, 23)) 
					+ ''', @ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @TODATE, 23)) + '''';
			IF(@ESOPVersion = 'Global') BEGIN SET @PUSHDATAQUERY = @PUSHDATAQUERY + ', @ESOPVersion = ''Global''';  END
            EXECUTE (@PUSHDATAQUERY);
			PRINT '23. EXERCISE REPORT SPLIT VIEW PUSHED';

			-- Data Push On New Quick Report Server 
			-- 
			IF (@LinkedServer ='QUICKREPORT')
			BEGIN
				DECLARE @FilePath AS VARCHAR (256);
				SET @FilePath='F:\QuickReport\ETLBatchFiles\' + @DBName+'.bat'
				SET @PUSHDATAQUERY = 'INSERT INTO ['+ @LinkedServer+'].[ESOPAnalyticsNew].[dbo].[DataPushStatus]
				(ClientName, CurrentStatus, BatchFilePath) VALUES ('+''''+ @DBName+''''+', 0,'+''''+ @FilePath+''''+')'
				PRINT (@PUSHDATAQUERY)
				 EXECUTE (@PUSHDATAQUERY);
			END

			-- DELETE DUPLICATE RECORDS ON QUICK REPORT SERVER FROM TRANSFORMED TABLES
			SET @PUSHDATAQUERY = 'EXECUTE SP_Delete_QRDuplicateData @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer 
					+ ''', @FromDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FROMDATE, 23)) 
					+ ''', @ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @TODATE, 23)) + '''';
			PRINT 'DUPLICATE DATA DELETE..';
			PRINT(@PUSHDATAQUERY);
			EXECUTE(@PUSHDATAQUERY);
        END
    ELSE
        BEGIN
		PRINT 'IN ELSE';
		DECLARE @VersionParameterNeeded int;
		SET @VersionParameterNeeded = 0;

            SET @USEDB = 'USE [' + @DBName + ']';
            EXECUTE (@USEDB);
			 IF (@REPORT = 'SplitVestwiseReport')
                BEGIN
					PRINT 'VESTWISE REPORT SPLIT VIEW';
                    SET @PUSHDATAQUERY = 'EXECUTE SP_VestwiseReport_Split @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer 
					+ ''', @FromDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FROMDATE, 23)) 
					+ ''', @ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @TODATE, 23)) + '''';
					SET @VersionParameterNeeded = 1;
					PRINT(@PUSHDATAQUERY);
                    EXECUTE (@PUSHDATAQUERY);
                END
				 IF (@REPORT = 'SplitExerciseReport')
                BEGIN
					PRINT 'EXERCISE REPORT SPLIT VIEW';
                    SET @PUSHDATAQUERY = 'EXECUTE SP_GetExerciseReportSplitView @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer 
					+ ''', @FromDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FROMDATE, 23)) 
					+ ''', @ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @TODATE, 23)) + '''';
					SET @VersionParameterNeeded = 1;
					PRINT(@PUSHDATAQUERY);
                    EXECUTE (@PUSHDATAQUERY);
                END
            IF (@REPORT = 'GrantConsolidatedReport')
                BEGIN
                    SET @PUSHDATAQUERY = 'EXECUTE SP_Master_Report_Data @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer + ''', @FromDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FROMDATE, 23)) + ''', 
					@ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @TODATE, 23)) + ''', @ReportName = ''GrantConsolidatedReport''';
                    SET @VersionParameterNeeded = 1;
					EXECUTE (@PUSHDATAQUERY);
                END
            IF (@REPORT = 'GrantSummaryReport')
                BEGIN
                    SET @PUSHDATAQUERY = 'EXECUTE SP_Master_Report_Data ''' + @DBName + ''', ''' + @LinkedServer + ''', ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FROMDATE, 23)) + ''', ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @TODATE, 23)) + ''', ''GrantSummaryReport''';
                    PRINT @PUSHDATAQUERY;
					 SET @VersionParameterNeeded = 1;
                    EXECUTE (@PUSHDATAQUERY);
                END
			IF (@REPORT = 'OnlyPersonalStatusReport')
                BEGIN
                    SET @PUSHDATAQUERY = 'EXECUTE SP_EDAnalytics_PersonalStatusReport @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer + ''', @FromDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FROMDATE, 23)) 
					+ ''', @ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @TODATE, 23)) 
					+ ''', @Status = ''' + @STATUS + '''';
                    SET @VersionParameterNeeded = 1;
					PRINT @PUSHDATAQUERY;
                    EXECUTE (@PUSHDATAQUERY);
                END
            IF (@REPORT = 'VestwiseReport')
                BEGIN
                    SET @PUSHDATAQUERY = 'EXECUTE SP_Master_Report_Data @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer + ''', @FromDate = ''' 
					+ CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FROMDATE, 23)) + ''', @ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @TODATE, 23)) + 
					''', @ReportName = ''VestwiseReport''';
                    PRINT @PUSHDATAQUERY;
					SET @VersionParameterNeeded = 1;
                    EXECUTE (@PUSHDATAQUERY);
                END
            IF (@REPORT = 'CancellationReport')
                BEGIN
					PRINT 'CANCELLATION REPORT';
                    SET @PUSHDATAQUERY = 'EXECUTE SP_Cancellation_Report @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer 
					+ ''', @FromDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FROMDATE, 23)) 
					+ ''', @ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @TODATE, 23)) + '''';
					SET @VersionParameterNeeded = 1;
					PRINT(@PUSHDATAQUERY);
                    EXECUTE (@PUSHDATAQUERY);
                END
            IF (@REPORT = 'LapseReport')
                BEGIN
                    SET @PUSHDATAQUERY = 'EXECUTE SP_LapseReport @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer 
					+ ''', @FromDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FROMDATE, 23)) 
					+ ''', @ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @TODATE, 23)) + '''';
					SET @VersionParameterNeeded = 1;
                    PRINT @PUSHDATAQUERY;
                   EXECUTE (@PUSHDATAQUERY);
                END
            IF (@REPORT = 'UserLoginHistoryReport')
                BEGIN
                    SET @PUSHDATAQUERY = 'EXECUTE SP_User_Login_History_Report @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer 
					+ ''', @FromDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FROMDATE, 23)) 
					+ ''', @ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @TODATE, 23)) + '''';
                    PRINT @PUSHDATAQUERY;
                    EXECUTE (@PUSHDATAQUERY);
                END
            IF (@REPORT = 'ExerciseReport')
                BEGIN
                    SET @PUSHDATAQUERY = 'EXECUTE SP_ExerciseReport @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer 
					+ ''', @FromDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FROMDATE, 23)) 
					+ ''', @ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @TODATE, 23)) 
					+ '''';
					SET @VersionParameterNeeded = 1;
                    PRINT @PUSHDATAQUERY;
                   EXECUTE (@PUSHDATAQUERY);
                END
            IF (@REPORT = 'PersonalStatusReport')
                BEGIN
                    SET @PUSHDATAQUERY = 'EXECUTE SP_PersonalStatusReport @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer 
					+ ''', @Status = ''' + @STATUS + '''';
                    SET @VersionParameterNeeded = 1;
					PRINT @PUSHDATAQUERY;
                   EXECUTE (@PUSHDATAQUERY);
                END
            IF (@REPORT = 'PoolBalanceReport')
                BEGIN
                            SET @PUSHDATAQUERY = 'EXECUTE SP_PoolBalanceReport @DBName =''' + @DBName + ''',  @LinkedServer = ''' + @LinkedServer 
							+ '''';
							SET @VersionParameterNeeded = 1;
                            PRINT (@PUSHDATAQUERY);
                    PRINT @PUSHDATAQUERY;
                   EXECUTE (@PUSHDATAQUERY);
                END
            IF (@REPORT = 'OnlineTransactionReport')
                BEGIN
                    SET @PUSHDATAQUERY = 'EXECUTE SP_OnlineTransactionReport @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer 
					+ ''', @Employeeid =  ''' + @EMPLOYEEID + ''', @SchemeId = ''' + @SCHEMEID + ''', @Activity = ''' + @ACTIVITY + '''';
                    SET @VersionParameterNeeded = 1;
					PRINT @PUSHDATAQUERY;
                   EXECUTE (@PUSHDATAQUERY);
                END
            IF (@REPORT = 'SchemeDetailsParameter')
                BEGIN
                    SET @PUSHDATAQUERY = 'EXECUTE SP_SchemeDetailParameters @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer + '''';
                    SET @VersionParameterNeeded = 1;
					PRINT @PUSHDATAQUERY;
                   EXECUTE (@PUSHDATAQUERY);
                END
            IF (@REPORT = 'GrantRegistrationParameter')
                BEGIN
                    SET @PUSHDATAQUERY = 'EXECUTE SP_GrantRegistrationParameters @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer + '''';
                    SET @VersionParameterNeeded = 1;
					PRINT @PUSHDATAQUERY;
                   EXECUTE (@PUSHDATAQUERY);
                END
            IF (@REPORT = 'StockPrice')
                BEGIN
                    SET @PUSHDATAQUERY = 'EXECUTE SP_StockPrice @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer + '''';
                    PRINT @PUSHDATAQUERY;
                   EXECUTE (@PUSHDATAQUERY);
                END
            IF (@REPORT = 'FMVUnListed')
                BEGIN
                    SET @PUSHDATAQUERY = 'EXECUTE SP_FMVUnListed @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer + '''';
                    PRINT @PUSHDATAQUERY;
                   EXECUTE (@PUSHDATAQUERY);
                END
            IF (@REPORT = 'CorporateActionParameter')
                BEGIN
                    SET @PUSHDATAQUERY = 'EXECUTE SP_CorporateActionParameter @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer + '''';
                    PRINT @PUSHDATAQUERY;
                   EXECUTE (@PUSHDATAQUERY);
                END
            IF (@REPORT = 'TrustShareRegister')
                BEGIN
                    SET @PUSHDATAQUERY = 'EXECUTE SP_ShareRegister @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer + '''';
                    SET @VersionParameterNeeded = 1;
					PRINT @PUSHDATAQUERY;
                   EXECUTE (@PUSHDATAQUERY);
                END
            IF (@REPORT = 'TrustSubShare')
                BEGIN
                    SET @PUSHDATAQUERY = 'EXECUTE SP_SubShareRegMaster ''' + @DBName + ''', ''' + @LinkedServer + '''';
					SET @VersionParameterNeeded = 1;
                    PRINT @PUSHDATAQUERY;
                   EXECUTE (@PUSHDATAQUERY);
                END
			
			 IF (@REPORT = 'OnlineGrantAcceptance')
                BEGIN
                    SET @PUSHDATAQUERY = 'EXECUTE SP_OnlineGrantAcceptance ''' + @DBName + ''', ''' + @LinkedServer + '''';
                    PRINT @PUSHDATAQUERY;
                   EXECUTE (@PUSHDATAQUERY);
                END
			
			 IF (@REPORT = 'MobilityData')
                BEGIN
                    SET @PUSHDATAQUERY = 'EXECUTE SP_MobilityData ''' + @DBName + ''', ''' + @LinkedServer + '''';
                    PRINT @PUSHDATAQUERY;
                   EXECUTE (@PUSHDATAQUERY);
                END

			 IF (@REPORT = 'FairValueCalculation')
                BEGIN
                    SET @PUSHDATAQUERY = 'EXECUTE SP_FairValueCalculation ''' + @DBName + ''', ''' + @LinkedServer + '''';
                    PRINT @PUSHDATAQUERY;
                   EXECUTE (@PUSHDATAQUERY);
                END
			IF (@REPORT = 'GrantLeg')
                BEGIN
                    SET @PUSHDATAQUERY = 'EXECUTE SP_GrantLeg ''' + @DBName + ''', ''' + @LinkedServer + '''';
                    PRINT @PUSHDATAQUERY;
                   EXECUTE (@PUSHDATAQUERY);
				END
			IF (@REPORT = 'SchemeSeparationRule')
                BEGIN
                    SET @PUSHDATAQUERY = 'EXECUTE SP_SchemeSeparationRule @DBName = ''' + @DBName + ''', @LinkedServer = ''' + @LinkedServer + '''';
                    SET @VersionParameterNeeded = 1;
					PRINT @PUSHDATAQUERY;
                   EXECUTE (@PUSHDATAQUERY);
                END
			IF (@REPORT = 'ShareHolderApproval')
                BEGIN
                    SET @PUSHDATAQUERY = 'EXECUTE SP_ShareHolderApproval ''' + @DBName + ''', ''' + @LinkedServer + '''';
                    PRINT @PUSHDATAQUERY;
                   EXECUTE (@PUSHDATAQUERY);
				END
			IF((@VersionParameterNeeded = 1) AND (@ESOPVersion IS NOT NULL))
					BEGIN
						SET @PUSHDATAQUERY = @PUSHDATAQUERY + ', @ESOPVersion = ''Global''';
					END
			EXECUTE (@PUSHDATAQUERY);
			SET @VersionParameterNeeded = 0;
        END
END

GO
