IF NOT EXISTS (
		SELECT 'X'
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[LapseDetails_rpt]')
			AND type IN (N'U')
		)
BEGIN
	CREATE TABLE [dbo].[LapseDetails_rpt] (
		[SchemeTitle] [varchar](50) NOT NULL
		,[GrantDate] [datetime] NOT NULL
		,[GrantRegistration] [varchar](20) NULL
		,[ExercisePrice] [numeric](18, 2) NULL
		,[EmployeeID] [varchar](20) NOT NULL
		,[EmployeeName] [varchar](75) NULL
		,[GrantOpId] [varchar](100) NOT NULL
		,[Status] [datetime] NULL
		,[ExpiryDate] [datetime] NULL
		,[OptionsLapsed] [numeric](18, 0) NOT NULL
		,[Parent] [varchar](10) NULL
		,[CSFlag] [varchar](10) NULL
		,[PANNumber] [varchar](10) NULL
		,[RowInsrtDttm] [datetime] NULL
		,[RowUpdtDttm] [datetime] NULL
		) ON [PRIMARY]
END