/****** Object:  StoredProcedure [dbo].[Load_report_data_rpt]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Load_report_data_rpt]
GO
/****** Object:  StoredProcedure [dbo].[Load_report_data_rpt]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Geopits
-- Create date: 2021-09-12
-- Description:	Power BI Reporting
-- =============================================

CREATE    PROCEDURE [dbo].[Load_report_data_rpt] 
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
    DECLARE @ClearDataQuery AS VARCHAR (MAX) = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName + '].[dbo].[report_data_rpt]';
    EXECUTE (@ClearDataQuery);
    IF (@ESOPVersion = 'Global')
        BEGIN
            SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[report_data_rpt]   (
			OptionsGranted,	
			OptionsVested,	
			OptionsExercised,	
			OptionsCancelled,	
			OptionsLapsed,	
			OptionsUnVested,	
			PendingForApproval,
			GrantOptionId,	
			GrantLegId,	
			SchemeId,	
			GrantRegistrationId,	
			EmployeeId,	
			EmployeeName,	
			SBU,	
			AccountNo,
			PANNumber,	
			Entity,
			Status,
			GrantDate,
			VestingType,
			ExercisePrice,
			VestingDate,
			ExpirayDate,	
			ParentNote,	
			UnvestedCancelled,
			VestedCancelled
			)
				EXECUTE [dbo].[SP_REPORT_DATA_rpt] ';
            EXECUTE (@StrInsertQuery);
        END
    ELSE
        BEGIN
		 CREATE TABLE #REPORTDATA (
                OptionsGranted			NUMERIC(18,0) ,
				OptionsVested			NUMERIC(18,0) ,
				OptionsExercised		NUMERIC(18,0) ,
				OptionsCancelled		NUMERIC(18,0) ,
				OptionsLapsed			NUMERIC(18,0) ,
				OptionsUnVested			NUMERIC(18,0) ,
				[Pending For Approval]	NUMERIC(18,0) ,
				GrantOptionId			VARCHAR (100) ,
				GrantLegId				DECIMAL(10,0) ,
				SchemeId				VARCHAR (50)  ,
				GrantRegistrationId		VARCHAR (20)  ,	
				EmployeeId				VARCHAR (20)  ,
				EmployeeName			VARCHAR (75)  ,
				SBU						VARCHAR (200) ,
				AccountNo				VARCHAR (20)  , 	
				PANNumber				VARCHAR (10)  ,
				Entity					VARCHAR (200) , 
				Status					VARCHAR (10)  ,
				GrantDate				DATETIME      ,
				[Vesting Type]			VARCHAR (200) ,					
				ExercisePrice			NUMERIC(18,2) ,
				VestingDate				DATETIME      ,	
				ExpirayDate				DATETIME      ,	
				[Parent Note]			VARCHAR (15)  ,					
				UnvestedCancelled		NUMERIC(18,0) ,				
				VestedCancelled			NUMERIC(18,0) 
            );
            SET @StrInsertQuery = 'INSERT INTO #REPORTDATA (
			    OptionsGranted,
				OptionsVested,	
				OptionsExercised,	
				OptionsCancelled,	
				OptionsLapsed,	
				OptionsUnVested,	
				[Pending For Approval],
				GrantOptionId,	
				GrantLegId,	
				SchemeId,	
				GrantRegistrationId,	
				EmployeeId,	
				EmployeeName,	
				SBU,	
				AccountNo,
				PANNumber,	
				Entity,
				Status,
				GrantDate,
				[Vesting Type],
				ExercisePrice,
				VestingDate,
				ExpirayDate,	
				[Parent Note],	
				UnvestedCancelled,
				VestedCancelled
				)
				 EXECUTE [dbo].[SP_REPORT_DATA_rpt] ';
            PRINT (@StrInsertQuery);
            EXECUTE (@StrInsertQuery);
            SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[report_data_rpt]   
			(	OptionsGranted,
				OptionsVested,	
				OptionsExercised,	
				OptionsCancelled,	
				OptionsLapsed,	
				OptionsUnVested,	
				PendingForApproval,
				GrantOptionId,	
				GrantLegId,	
				SchemeId,	
				GrantRegistrationId,	
				EmployeeId,	
				EmployeeName,	
				SBU,	
				AccountNo,
				PANNumber,	
				Entity,
				Status,
				GrantDate,
				VestingType,
				ExercisePrice,
				VestingDate,
				ExpirayDate,	
				ParentNote,	
				UnvestedCancelled,
				VestedCancelled,
				RowInsrtDttm,
				RowUpdtDttm
				)
				select OptionsGranted,
				OptionsVested,	
				OptionsExercised,	
				OptionsCancelled,	
				OptionsLapsed,	
				OptionsUnVested,	
				[Pending For Approval] as PendingForApproval,
				GrantOptionId,	
				GrantLegId,	
				SchemeId,	
				GrantRegistrationId,	
				EmployeeId,	
				EmployeeName,	
				SBU,	
				AccountNo,
				PANNumber,	
				Entity,
				Status,
				GrantDate,
				[Vesting Type] as VestingType,
				ExercisePrice,
				VestingDate,
				ExpirayDate,	
				[Parent Note] as ParentNote,	
				UnvestedCancelled,
   				VestedCancelled,
				getdate(),
				getdate()
			FROM #REPORTDATA';
            PRINT (@StrInsertQuery);
            EXECUTE (@StrInsertQuery);
        END
    --DECLARE @StrUpdateQuery AS VARCHAR (MAX) = 'Update [' + @LinkedServer + '].[' + @DBName + '].[dbo].[report_data_rpt] SET RowInsrtDttm = ''' + CONVERT (VARCHAR (50), CONVERT (CHAR (10), GetDate(), 126)) + ''',RowUpdtDttm = ''' + CONVERT (VARCHAR (50), CONVERT (CHAR (10), GetDate(), 126)) + '''';
    --EXECUTE (@StrUpdateQuery);
END
GO
