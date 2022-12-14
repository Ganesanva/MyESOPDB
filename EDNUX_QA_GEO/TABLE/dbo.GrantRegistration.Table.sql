/****** Object:  Table [dbo].[GrantRegistration]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GrantRegistration]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GrantRegistration](
	[ApprovalId] [varchar](20) NOT NULL,
	[SchemeId] [varchar](50) NULL,
	[GrantApprovalId] [varchar](20) NOT NULL,
	[GrantRegistrationId] [varchar](20) NOT NULL,
	[ApprovalStatus] [varchar](1) NOT NULL,
	[GrantDate] [datetime] NOT NULL,
	[ExercisePrice] [numeric](18, 9) NULL,
	[IsPerformanceBasedIncluded] [char](10) NOT NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[Apply_SAR] [char](1) NULL,
	[Merchant_Code] [varchar](50) NULL,
	[Contributiion_Frequency] [varchar](50) NULL,
	[ContriBution_Period] [int] NULL,
	[MinContriAmt] [decimal](18, 2) NULL,
	[MaxContAmt] [decimal](18, 2) NULL,
	[ContributionMultiples] [decimal](18, 0) NULL,
	[StartDate] [datetime] NULL,
	[LastDate] [datetime] NULL,
	[BankIntRate] [decimal](18, 2) NULL,
	[IntrestAmtCalcAs] [varchar](50) NULL,
	[FirstMailFre] [int] NULL,
	[RemMailFre] [int] NULL,
	[NonPayAllow] [int] NULL,
	[EmailRemXDays] [int] NULL,
	[EmailCompCR] [varchar](50) NULL,
	[SpecificDate] [datetime] NULL,
	[CompoundIntFreq] [varchar](50) NULL,
	[AccountType] [varchar](50) NULL,
	[Apply_SAYE] [char](10) NULL,
	[ContristartDate] [datetime] NULL,
	[SARS_PRICE] [nvarchar](50) NULL,
	[ExercisePriceINR] [numeric](18, 2) NULL,
	[NoteDate] [datetime] NULL,
	[IsChkNote] [bit] NULL,
	[Note] [varchar](200) NULL,
 CONSTRAINT [PK_GrantRegistration] PRIMARY KEY CLUSTERED 
(
	[GrantRegistrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Index [GrantRegistration_GrantDate]    Script Date: 7/6/2022 1:57:37 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[GrantRegistration]') AND name = N'GrantRegistration_GrantDate')
CREATE NONCLUSTERED INDEX [GrantRegistration_GrantDate] ON [dbo].[GrantRegistration]
(
	[GrantDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [GrantRegistration_GrantRegistrationId]    Script Date: 7/6/2022 1:57:37 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[GrantRegistration]') AND name = N'GrantRegistration_GrantRegistrationId')
CREATE NONCLUSTERED INDEX [GrantRegistration_GrantRegistrationId] ON [dbo].[GrantRegistration]
(
	[GrantRegistrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantRegistration_GrantApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantRegistration]'))
ALTER TABLE [dbo].[GrantRegistration]  WITH CHECK ADD  CONSTRAINT [FK_GrantRegistration_GrantApproval] FOREIGN KEY([GrantApprovalId])
REFERENCES [dbo].[GrantApproval] ([GrantApprovalId])
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantRegistration_GrantApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantRegistration]'))
ALTER TABLE [dbo].[GrantRegistration] CHECK CONSTRAINT [FK_GrantRegistration_GrantApproval]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantRegistration_Scheme]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantRegistration]'))
ALTER TABLE [dbo].[GrantRegistration]  WITH CHECK ADD  CONSTRAINT [FK_GrantRegistration_Scheme] FOREIGN KEY([SchemeId])
REFERENCES [dbo].[Scheme] ([SchemeId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantRegistration_Scheme]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantRegistration]'))
ALTER TABLE [dbo].[GrantRegistration] CHECK CONSTRAINT [FK_GrantRegistration_Scheme]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantRegistration_ShareHolderApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantRegistration]'))
ALTER TABLE [dbo].[GrantRegistration]  WITH CHECK ADD  CONSTRAINT [FK_GrantRegistration_ShareHolderApproval] FOREIGN KEY([ApprovalId])
REFERENCES [dbo].[ShareHolderApproval] ([ApprovalId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantRegistration_ShareHolderApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantRegistration]'))
ALTER TABLE [dbo].[GrantRegistration] CHECK CONSTRAINT [FK_GrantRegistration_ShareHolderApproval]
GO
