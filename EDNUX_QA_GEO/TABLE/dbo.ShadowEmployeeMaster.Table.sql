/****** Object:  Table [dbo].[ShadowEmployeeMaster]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ShadowEmployeeMaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ShadowEmployeeMaster](
	[EmployeeID] [varchar](20) NOT NULL,
	[LoginID] [varchar](20) NOT NULL,
	[EmployeeName] [varchar](75) NULL,
	[EmployeeDesignation] [varchar](200) NULL,
	[EmployeeAddress] [varchar](500) NULL,
	[EmployeePhone] [varchar](20) NULL,
	[DateOfJoining] [datetime] NULL,
	[DateOfTermination] [datetime] NULL,
	[Insider] [char](1) NULL,
	[ResidentialStatus] [char](1) NULL,
	[PANNumber] [varchar](10) NULL,
	[WardNumber] [varchar](50) NULL,
	[DematAccountType] [varchar](15) NULL,
	[DepositoryIDNumber] [varchar](8) NULL,
	[DepositoryParticipantNo] [varchar](150) NULL,
	[ClientIDNumber] [varchar](16) NULL,
	[EmployeeEmail] [varchar](100) NULL,
	[Grade] [varchar](200) NULL,
	[Department] [varchar](200) NULL,
	[DepositoryName] [varchar](20) NULL,
	[BackOutTermination] [char](1) NULL,
	[Action] [char](1) NULL,
	[IsMassUpload] [char](1) NULL,
	[SBU] [varchar](200) NULL,
	[Entity] [varchar](200) NULL,
	[AccountNo] [varchar](20) NULL,
	[ConfStatus] [char](1) NULL,
	[LastUpdatedBy] [varchar](20) NULL,
	[LastUpdatedOn] [datetime] NULL,
	[IsAssociated] [char](1) NULL,
	[NewEmployeeId] [varchar](50) NULL,
	[Location] [varchar](200) NULL,
	[Deleted] [char](1) NULL,
	[ReasonForTermination] [numeric](18, 0) NULL,
	[LWD] [datetime] NULL,
	[Confirmn_Dt] [datetime] NULL,
	[tax_slab] [numeric](18, 2) NULL,
	[DPRecord] [varchar](50) NULL,
	[SecondaryEmailID] [varchar](500) NULL,
	[CountryName] [varchar](50) NULL,
	[COST_CENTER] [varchar](200) NULL,
	[BROKER_DEP_TRUST_CMP_NAME] [varchar](200) NULL,
	[BROKER_DEP_TRUST_CMP_ID] [varchar](200) NULL,
	[BROKER_ELECT_ACC_NUM] [varchar](200) NULL,
	[FROM_DATE] [date] NULL,
	[Nationality] [varchar](100) NULL,
	[State] [varchar](100) NULL,
	[TransferDate] [smalldatetime] NULL,
	[CompanyName] [varchar](50) NULL,
	[LongLeave] [varchar](1) NULL,
	[LongLeaveFrom] [smalldatetime] NULL,
	[LongLeaveTo] [smalldatetime] NULL,
	[VestingDateExtension] [numeric](18, 2) NULL,
	[TAX_IDENTIFIER_COUNTRY] [nvarchar](200) NULL,
	[TAX_IDENTIFIER_STATE] [nvarchar](200) NULL,
	[Field1] [nvarchar](200) NULL,
	[Field2] [nvarchar](200) NULL,
	[Field3] [nvarchar](200) NULL,
	[Field4] [nvarchar](200) NULL,
	[Field5] [nvarchar](200) NULL,
	[Field6] [nvarchar](200) NULL,
	[Field7] [nvarchar](200) NULL,
	[Field8] [nvarchar](200) NULL,
	[Field9] [nvarchar](200) NULL,
	[Field10] [nvarchar](200) NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShadowEmp__Confi__0697FACD]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShadowEmployeeMaster] ADD  DEFAULT (NULL) FOR [Confirmn_Dt]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShadowEmp__COST___5A054B78]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShadowEmployeeMaster] ADD  DEFAULT (NULL) FOR [COST_CENTER]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShadowEmp__BROKE__5AF96FB1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShadowEmployeeMaster] ADD  DEFAULT (NULL) FOR [BROKER_DEP_TRUST_CMP_NAME]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShadowEmp__BROKE__5BED93EA]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShadowEmployeeMaster] ADD  DEFAULT (NULL) FOR [BROKER_DEP_TRUST_CMP_ID]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShadowEmp__BROKE__5CE1B823]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShadowEmployeeMaster] ADD  DEFAULT (NULL) FOR [BROKER_ELECT_ACC_NUM]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShadowEmp__FROM___22800C64]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShadowEmployeeMaster] ADD  DEFAULT (NULL) FOR [FROM_DATE]
END
GO
