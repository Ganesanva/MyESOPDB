/****** Object:  View [dbo].[VW_GSR]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_GSR]'))
EXEC dbo.sp_executesql @statement = N'


-- =============================================
-- Author:		Vidyadhar
-- Create date: 18-11-2021
-- Description:	Create VW_GSR 
-- =============================================
CREATE       VIEW [dbo].[VW_GSR]
as
	
	SELECT ''Scheme Name'' as   ''Scheme Name''
	,''Grant Registration Id'' as   ''Grant Registration Id''
	,''Employee Id'' as   ''Employee Id''
	,''Employee Name'' as   ''Employee Name''
	,''PAN NUMBER'' as ''PAN Number''
	,''Grant Option Id'' as   ''Grant Option Id''
	,''Grant Date'' as   ''Grant Date''
	,''Exercise Price'' as   ''Exercise Price''
	,''Status'' as   Status
	,''Options Granted'' as    ''Options Granted''
	,''Options Vested'' as     ''Options Vested''
	,''Options UnVested'' as   ''Options UnVested''
	,''Options Exercised'' as  ''Options Exercised''
	,''Options Cancelled'' as  ''Options Cancelled''
	,''Options Lapsed'' as	 ''Options Lapsed''
	,''SBU'' as   SBU
	,''Entity'' as   Entity
	,''ToDate'' as   ToDate
	,''FromDate'' as   FromDate
	,''ParentNote'' as   ParentNote
	,''AccountNo'' as   AccountNo
	,''PushDate'' as   PushDate
	, 0 as Id
	UNION ALL
	SELECT SchemeId, GrantRegistrationId
	, CONVERT(VARCHAR(500),EmployeeId) as EmployeeId,EmployeeName
	, PANNumber
	, GrantOptionId
	, CONVERT(VARCHAR(500),CONVERT(Date,GrantDate)) as GrantDate
	, CONVERT(VARCHAR(500),ExercisePrice) as ExercisePrice, Status
	,CONVERT(VARCHAR(500),SUM(OptionsGranted)	) as ''Options Granted''	
	,CONVERT(VARCHAR(500),SUM(OptionsVested)		) as ''Options Vested''	
	,CONVERT(VARCHAR(500),SUM(OptionsUnVested)	) as ''Options UnVested''	
	,CONVERT(VARCHAR(500),SUM(OptionsExercised)	) as ''Options Exercised''	
	,CONVERT(VARCHAR(500),SUM(OptionsCancelled)	) as ''Options Cancelled''
	,CONVERT(VARCHAR(500),SUM(OptionsLapsed)		) as ''Options Lapsed''
	, SBU, Entity
	, CONVERT(VARCHAR(500),CONVERT(DATE,GETDATE())) as ToDate	
	, CONVERT(VARCHAR(500),''01-01-1900'') as FromDate
	, ParentNote, AccountNo
	, CONVERT(VARCHAR(500),CONVERT(DATE,GETDATE()))as PushDate
	, 1 as ID
	 FROM report_data_rpt
	 GROUP BY SchemeId, GrantRegistrationId
	, EmployeeId,EmployeeName, PANNumber, GrantOptionId 
	, GrantDate, ExercisePrice, Status, SBU, Entity, ParentNote, AccountNo
	


' 
GO
