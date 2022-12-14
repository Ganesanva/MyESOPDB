/****** Object:  Table [dbo].[ShGrantRegistration]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ShGrantRegistration]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ShGrantRegistration](
	[ApprovalId] [varchar](20) NOT NULL,
	[SchemeId] [varchar](50) NULL,
	[GrantApprovalId] [varchar](20) NOT NULL,
	[GrantRegistrationId] [varchar](20) NOT NULL,
	[GrantDate] [datetime] NOT NULL,
	[ExercisePrice] [numeric](18, 2) NULL,
	[IsPerformanceBasedIncluded] [char](10) NOT NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[Action] [char](1) NOT NULL,
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
	[AdjustResidueInTimeOrPerformance] [char](1) NOT NULL,
	[NoteDate] [datetime] NULL,
	[IsChkNote] [bit] NULL,
	[Note] [varchar](200) NULL,
 CONSTRAINT [PK_ShGrantRegistration] PRIMARY KEY CLUSTERED 
(
	[GrantRegistrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShGrantRe__Adjus__75A40FA3]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShGrantRegistration] ADD  DEFAULT ('T') FOR [AdjustResidueInTimeOrPerformance]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShGrantRegistration_GrantApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShGrantRegistration]'))
ALTER TABLE [dbo].[ShGrantRegistration]  WITH CHECK ADD  CONSTRAINT [FK_ShGrantRegistration_GrantApproval] FOREIGN KEY([GrantApprovalId])
REFERENCES [dbo].[GrantApproval] ([GrantApprovalId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShGrantRegistration_GrantApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShGrantRegistration]'))
ALTER TABLE [dbo].[ShGrantRegistration] CHECK CONSTRAINT [FK_ShGrantRegistration_GrantApproval]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShGrantRegistration_Scheme]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShGrantRegistration]'))
ALTER TABLE [dbo].[ShGrantRegistration]  WITH CHECK ADD  CONSTRAINT [FK_ShGrantRegistration_Scheme] FOREIGN KEY([SchemeId])
REFERENCES [dbo].[Scheme] ([SchemeId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShGrantRegistration_Scheme]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShGrantRegistration]'))
ALTER TABLE [dbo].[ShGrantRegistration] CHECK CONSTRAINT [FK_ShGrantRegistration_Scheme]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShGrantRegistration_ShareHolderApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShGrantRegistration]'))
ALTER TABLE [dbo].[ShGrantRegistration]  WITH CHECK ADD  CONSTRAINT [FK_ShGrantRegistration_ShareHolderApproval] FOREIGN KEY([ApprovalId])
REFERENCES [dbo].[ShareHolderApproval] ([ApprovalId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShGrantRegistration_ShareHolderApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShGrantRegistration]'))
ALTER TABLE [dbo].[ShGrantRegistration] CHECK CONSTRAINT [FK_ShGrantRegistration_ShareHolderApproval]
GO
