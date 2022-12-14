/****** Object:  Table [dbo].[NominationDetails]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NominationDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[NominationDetails](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [varchar](20) NULL,
	[Nameof_Nominee1] [varchar](50) NULL,
	[Addressof_Nominee1] [varchar](750) NULL,
	[DateofBirth_Nominee1] [varchar](50) NULL,
	[Percentageofshare_Nominee1] [varchar](50) NULL,
	[NameOfGuardian_Nominee1] [varchar](50) NULL,
	[AddressOfGuardian_Nominee1] [varchar](750) NULL,
	[Nameof_Nominee2] [varchar](50) NULL,
	[Addressof_Nominee2] [varchar](750) NULL,
	[DateofBirth_Nominee2] [varchar](50) NULL,
	[Percentageofshare_Nominee2] [varchar](50) NULL,
	[NameOfGuardian_Nominee2] [varchar](50) NULL,
	[AddressOfGuardian_Nominee2] [varchar](750) NULL,
	[Nameof_Nominee3] [varchar](50) NULL,
	[Addressof_Nominee3] [varchar](750) NULL,
	[DateofBirth_Nominee3] [varchar](50) NULL,
	[Percentageofshare_Nominee3] [varchar](50) NULL,
	[NameOfGuardian_Nominee3] [varchar](50) NULL,
	[AddressOfGuardian_Nominee3] [varchar](750) NULL,
	[ApprovalStatus] [char](1) NULL,
	[DateOfSubmissionOfForm] [varchar](50) NULL,
	[LastUpdatedBy] [varchar](20) NULL,
	[LastUpdatedOn] [datetime] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Nominatio__UserI__27F8EE98]') AND parent_object_id = OBJECT_ID(N'[dbo].[NominationDetails]'))
ALTER TABLE [dbo].[NominationDetails]  WITH CHECK ADD  CONSTRAINT [FK__Nominatio__UserI__27F8EE98] FOREIGN KEY([UserId])
REFERENCES [dbo].[EmployeeMaster] ([EmployeeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Nominatio__UserI__27F8EE98]') AND parent_object_id = OBJECT_ID(N'[dbo].[NominationDetails]'))
ALTER TABLE [dbo].[NominationDetails] CHECK CONSTRAINT [FK__Nominatio__UserI__27F8EE98]
GO
