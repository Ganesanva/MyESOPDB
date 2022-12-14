/****** Object:  Table [dbo].[ShSchemeSeparationRule]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ShSchemeSeparationRule]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ShSchemeSeparationRule](
	[ApprovalId] [varchar](20) NOT NULL,
	[SchemeId] [varchar](50) NOT NULL,
	[SeperationRuleId] [numeric](18, 0) NOT NULL,
	[VestedOptionsLiveFor] [numeric](18, 0) NOT NULL,
	[IsVestingOfUnvestedOptions] [char](1) NOT NULL,
	[UnvestedOptionsLiveFor] [numeric](18, 0) NULL,
	[VestedOptionsLiveTillExercisePeriod] [char](1) NULL,
	[PeriodUnit] [char](1) NULL,
	[IsRuleBypassed] [char](1) NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[OthersReason] [varchar](30) NULL,
 CONSTRAINT [PK_ShSchemeSeparationRule] PRIMARY KEY CLUSTERED 
(
	[SchemeId] ASC,
	[SeperationRuleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShSchemeSeparationRule_ShareHolderApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShSchemeSeparationRule]'))
ALTER TABLE [dbo].[ShSchemeSeparationRule]  WITH CHECK ADD  CONSTRAINT [FK_ShSchemeSeparationRule_ShareHolderApproval] FOREIGN KEY([ApprovalId])
REFERENCES [dbo].[ShareHolderApproval] ([ApprovalId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShSchemeSeparationRule_ShareHolderApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShSchemeSeparationRule]'))
ALTER TABLE [dbo].[ShSchemeSeparationRule] CHECK CONSTRAINT [FK_ShSchemeSeparationRule_ShareHolderApproval]
GO
