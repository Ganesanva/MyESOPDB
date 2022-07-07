/****** Object:  Table [dbo].[CancelledTrans]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CancelledTrans]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CancelledTrans](
	[CancelledTransID] [numeric](18, 0) NOT NULL,
	[ApprovalStatus] [varchar](1) NOT NULL,
	[CancellationDate] [datetime] NOT NULL,
	[CancellationReason] [varchar](200) NOT NULL,
	[CancelledQuantity] [numeric](18, 0) NOT NULL,
	[EmployeeID] [varchar](20) NOT NULL,
	[Action] [char](1) NOT NULL,
	[GrantOptionID] [varchar](100) NOT NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[GrantLegSerialNumber] [numeric](18, 0) NULL,
 CONSTRAINT [PK_CancelledTrans] PRIMARY KEY CLUSTERED 
(
	[CancelledTransID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
