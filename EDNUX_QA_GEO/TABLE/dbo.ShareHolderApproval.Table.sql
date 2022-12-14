/****** Object:  Table [dbo].[ShareHolderApproval]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ShareHolderApproval]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ShareHolderApproval](
	[ApprovalId] [varchar](20) NOT NULL,
	[Status] [varchar](1) NOT NULL,
	[ApprovalDate] [datetime] NOT NULL,
	[ApprovalTitle] [varchar](50) NOT NULL,
	[Description] [varchar](100) NULL,
	[NumberOfShares] [numeric](18, 0) NULL,
	[AdditionalShares] [numeric](18, 0) NULL,
	[ValidUptoDate] [datetime] NOT NULL,
	[AvailableShares] [numeric](18, 0) NOT NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[ValidityType] [varchar](20) NULL,
	[IsCoverSAR] [bit] NULL,
 CONSTRAINT [PK_ShareHolderApproval] PRIMARY KEY CLUSTERED 
(
	[ApprovalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
