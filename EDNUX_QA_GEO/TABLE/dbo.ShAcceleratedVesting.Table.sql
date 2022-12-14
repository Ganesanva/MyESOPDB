/****** Object:  Table [dbo].[ShAcceleratedVesting]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ShAcceleratedVesting]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ShAcceleratedVesting](
	[AcceleratedVestingDate] [datetime] NOT NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[SchemeId] [varchar](50) NULL,
	[AcceleratedVestingId] [numeric](18, 0) NOT NULL,
 CONSTRAINT [PK_ShAcceleratedVesting] PRIMARY KEY CLUSTERED 
(
	[AcceleratedVestingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
