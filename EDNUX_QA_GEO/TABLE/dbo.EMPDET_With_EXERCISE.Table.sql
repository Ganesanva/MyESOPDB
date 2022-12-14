/****** Object:  Table [dbo].[EMPDET_With_EXERCISE]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EMPDET_With_EXERCISE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EMPDET_With_EXERCISE](
	[Idt] [int] IDENTITY(1,1) NOT NULL,
	[ExerciseNo] [numeric](18, 0) NOT NULL,
	[DateOfJoining] [datetime] NULL,
	[Grade] [varchar](100) NULL,
	[EmployeeDesignation] [varchar](150) NULL,
	[EmployeePhone] [varchar](20) NULL,
	[EmployeeEmail] [varchar](100) NULL,
	[EmployeeAddress] [varchar](500) NULL,
	[PANNumber] [varchar](10) NULL,
	[ResidentialStatus] [char](1) NULL,
	[Insider] [char](1) NULL,
	[WardNumber] [varchar](15) NULL,
	[Department] [varchar](150) NULL,
	[Location] [varchar](200) NULL,
	[SBU] [varchar](200) NULL,
	[Entity] [varchar](200) NULL,
	[DPRecord] [varchar](50) NULL,
	[DepositoryName] [varchar](20) NULL,
	[DematAccountType] [varchar](15) NULL,
	[DepositoryParticipantNo] [varchar](150) NULL,
	[DepositoryIDNumber] [varchar](30) NULL,
	[ClientIDNumber] [varchar](16) NULL,
	[LastUpdatedby] [varchar](20) NULL,
	[LastUpdatedOn] [datetime] NULL,
	[Mobile] [varchar](20) NULL,
	[SecondaryEmailID] [varchar](500) NULL,
	[CountryName] [varchar](50) NULL,
	[COST_CENTER] [varchar](200) NULL,
	[BROKER_DEP_TRUST_CMP_NAME] [varchar](200) NULL,
	[BROKER_DEP_TRUST_CMP_ID] [varchar](200) NULL,
	[BROKER_ELECT_ACC_NUM] [varchar](200) NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__EMPDET_Wi__LastU__0D0FEE32]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EMPDET_With_EXERCISE] ADD  DEFAULT (getdate()) FOR [LastUpdatedOn]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__EMPDET_Wi__COST___638EB5B2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EMPDET_With_EXERCISE] ADD  DEFAULT (NULL) FOR [COST_CENTER]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__EMPDET_Wi__BROKE__6482D9EB]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EMPDET_With_EXERCISE] ADD  DEFAULT (NULL) FOR [BROKER_DEP_TRUST_CMP_NAME]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__EMPDET_Wi__BROKE__6576FE24]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EMPDET_With_EXERCISE] ADD  DEFAULT (NULL) FOR [BROKER_DEP_TRUST_CMP_ID]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__EMPDET_Wi__BROKE__666B225D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EMPDET_With_EXERCISE] ADD  DEFAULT (NULL) FOR [BROKER_ELECT_ACC_NUM]
END
GO
