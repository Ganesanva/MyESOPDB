/****** Object:  Table [dbo].[report_data_rpt]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[report_data_rpt]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[report_data_rpt](
	[OptionsGranted] [numeric](18, 0) NULL,
	[OptionsVested] [numeric](18, 0) NULL,
	[OptionsExercised] [numeric](18, 0) NULL,
	[OptionsCancelled] [numeric](18, 0) NULL,
	[OptionsLapsed] [numeric](18, 0) NULL,
	[OptionsUnVested] [numeric](18, 0) NULL,
	[PendingForApproval] [numeric](18, 0) NULL,
	[GrantOptionId] [varchar](100) NOT NULL,
	[GrantLegId] [decimal](10, 0) NOT NULL,
	[SchemeId] [varchar](50) NULL,
	[GrantRegistrationId] [varchar](20) NOT NULL,
	[EmployeeId] [varchar](20) NOT NULL,
	[EmployeeName] [varchar](75) NULL,
	[SBU] [varchar](200) NULL,
	[AccountNo] [varchar](20) NULL,
	[PANNumber] [varchar](10) NULL,
	[Entity] [varchar](200) NULL,
	[Status] [varchar](10) NULL,
	[GrantDate] [datetime] NOT NULL,
	[VestingType] [varchar](200) NULL,
	[ExercisePrice] [numeric](18, 2) NULL,
	[VestingDate] [datetime] NOT NULL,
	[ExpirayDate] [datetime] NOT NULL,
	[ParentNote] [varchar](15) NULL,
	[UnvestedCancelled] [numeric](18, 0) NOT NULL,
	[VestedCancelled] [numeric](18, 0) NOT NULL,
	[RowInsrtDttm] [datetime] NULL,
	[RowUpdtDttm] [datetime] NULL
) ON [PRIMARY]
END
GO
