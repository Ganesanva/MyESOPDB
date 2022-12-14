/****** Object:  Table [dbo].[ShShareHolderApproval]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ShShareHolderApproval]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ShShareHolderApproval](
	[ApprovalId] [varchar](20) NOT NULL,
	[ApprovalDate] [datetime] NOT NULL,
	[ApprovalTitle] [varchar](50) NOT NULL,
	[Description] [varchar](100) NULL,
	[NumberOfShares] [numeric](18, 0) NULL,
	[AdditionalShares] [numeric](18, 0) NULL,
	[ValidUptoDate] [datetime] NOT NULL,
	[AvailableShares] [numeric](18, 0) NOT NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[Action] [char](1) NOT NULL,
	[ValidityType] [varchar](20) NULL,
	[IsCoverSAR] [bit] NULL
) ON [PRIMARY]
END
GO
