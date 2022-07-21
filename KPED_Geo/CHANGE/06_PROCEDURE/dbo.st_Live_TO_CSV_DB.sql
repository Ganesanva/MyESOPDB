/****** Object:  StoredProcedure [dbo].[st_Live_TO_CSV_DB]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[st_Live_TO_CSV_DB]
GO
/****** Object:  StoredProcedure [dbo].[st_Live_TO_CSV_DB]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vidyadhar
-- Create date: 18-11-2021
-- Description:	Create st_Live_TO_CSV
-- =============================================

CREATE     PROCEDURE [dbo].[st_Live_TO_CSV_DB]
	@FromDate VARCHAR(500)=''
,	@ToDate	VARCHAR(500)=''
,	@Status VARCHAR(500) = ''
,	@SchemeId VARCHAR(500) =''
,	@DBName VARCHAR(200)=''
,	@FilePath VARCHAR(4000)=''
,	@FlipkartYN VARCHAR(1)='N'
AS
BEGIN
	;WITH M_LiveORSeparated_TO_CSV
	as
	(
	SELECT 
	'Scheme Name'			as 'Scheme Name'			
	,'Employee Id'			as 'Employee Id'			
	,'Employee Name'		as 'Employee Name'		
	,'Status'				as 'Status'				
	,'Grant Date'			as 'Grant Date'			
	,'Grant Leg Id'			as 'Grant Leg Id'			
	,'Grant Registration Id'as 'Grant Registration Id'
	,'Grant Option Id'		as 'Grant Option Id'		
	,'Options Granted'		as 'Options Granted'		
	,'Vesting Type'			as 'Vesting Type'			
	,'Vesting Date'			as 'Vesting Date'			
	,'Expiry Date'			as 'Expiry Date'			
	,'Exercise Price'		as 'Exercise Price'		
	,'Options Vested'		as 'Options Vested'		
	,'Pending For Approval'	as 'Pending For Approval'	
	,'Options UnVested'		as 'Options UnVested'		
	,'Options Exercised'	as 'Options Exercised'	
	,'Options Cancelled'	as 'Options Cancelled'	
	,'Options Lapsed'		as 'Options Lapsed'		
	,'Unvested Cancelled'	as 'Unvested Cancelled'	
	,'Vested Cancelled'		as 'Vested Cancelled'		
	,'ToDate'				as 'ToDate'	
	, 0						as ID
	UNION ALL
	SELECT SchemeId
	, EmployeeId
	, EmployeeName
	, Status
	, CONVERT(VARCHAR(500),GrantDate,106)			as	GrantDate
	, CONVERT(VARCHAR(500),GrantLegId)				as	GrantLegId
	, CONVERT(VARCHAR(500),GrantRegistrationId)		as	GrantRegistrationId
	, CONVERT(VARCHAR(500),GrantOptionId)			as	GrantOptionId
	, CONVERT(VARCHAR(500),OptionsGranted)			as	OptionsGranted
	, VestingType
	, CONVERT(VARCHAR(500),VestingDate,106)			as	VestingDate
	, CONVERT(VARCHAR(500),ExpirayDate,106)			as	ExpirayDate
	, CONVERT(VARCHAR(500),ExercisePrice)			as 'Exercise Price'
	, CONVERT(VARCHAR(500),OptionsVested)			as	OptionsVested
	, CONVERT(VARCHAR(500),0.00)						as 'Pending For Approval'
	, CONVERT(VARCHAR(500),OptionsUnVested)			as	OptionsUnVested
	, CONVERT(VARCHAR(500),OptionsExercised)			as	OptionsExercised
	, CONVERT(VARCHAR(500),OptionsCancelled)			as	OptionsCancelled
	, CONVERT(VARCHAR(500),OptionsLapsed)			as	OptionsLapsed
	, CONVERT(VARCHAR(500),UnvestedCancelled)		as	UnvestedCancelled
	, CONVERT(VARCHAR(500),VestedCancelled)			as	VestedCancelled
	, CONVERT(VARCHAR(500),GETDATE(),106)			as	ToDate
	, 1											as	ID
	FROM report_data_rpt 
	WHERE Status  NOT IN (CASE WHEN @FlipkartYN = 'N' THEN 'ALL' ELSE @Status END)		--Status  = @Status
	AND SchemeId NOT IN (CASE WHEN @FlipkartYN = 'N' THEN 'ALL' ELSE  @SchemeId END)	--AND SchemeId = @SchemeId
	AND CONVERT(date,GrantDate) BETWEEN CONVERT(date,@FromDate)   AND CONVERT(date,@ToDate)
	)
	SELECT *
	INTO ##LiveORSeparated_TO_CSV_DB
	FROM M_LiveORSeparated_TO_CSV
	ORDER BY ID
END
GO

