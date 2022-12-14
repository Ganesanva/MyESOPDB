IF NOT EXISTS (
		SELECT 'X'
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[PersonalStatus_rpt]')
			AND type IN (N'U')
		)
BEGIN
	CREATE TABLE [dbo].[PersonalStatus_rpt] (
		[EmployeeID] [varchar](20) NOT NULL
		,[LoginID] [varchar](20) NOT NULL
		,[EmployeeName] [varchar](75) NULL
		,[CountryName] [varchar](50) NULL
		,[EmployeeDesignation] [varchar](200) NULL
		,[EmployeeEmail] [varchar](500) NULL
		,[DateOfJoining] [datetime] NULL
		,[Grade] [varchar](200) NULL
		,[Location] [varchar](200) NULL
		,[Status] [varchar](10) NULL
		,[DateOfTermination] [datetime] NULL
		,[ResidentialStatus] [varchar](200) NULL
		,[SBU] [varchar](200) NULL
		,[Entity] [varchar](200) NULL
		,[AccountNo] [varchar](20) NULL
		,[Department] [varchar](200) NULL
		,[PANNumber] [varchar](10) NULL
		,[DepositoryParticipantNo] [varchar](150) NULL
		,[DepositoryName] [varchar](20) NULL
		,[DepositoryIDNumber] [varchar](8) NULL
		,[ConfStatus] [char](1) NULL
		,[ClientIDNumber] [varchar](16) NULL
		,[WardNumber] [varchar](15) NULL
		,[EmployeeAddress] [varchar](500) NULL
		,[EmployeePhone] [varchar](20) NULL
		,[Insider] [char](1) NULL
		,[DematAccountType] [varchar](15) NULL
		,[LWD] [datetime] NULL
		,[ReasonForTermination] [varchar](500) NULL
		,[BROKER_DEP_TRUST_CMP_NAME] [varchar](200) NULL
		,[BROKER_DEP_TRUST_CMP_ID] [varchar](200) NULL
		,[BROKER_ELECT_ACC_NUM] [varchar](200) NULL
		,[COST_CENTER] [varchar](200) NULL
		,[RowInsrtDttm] [datetime] NULL
		,[RowUpdtDttm] [datetime] NULL
		) ON [PRIMARY]
END