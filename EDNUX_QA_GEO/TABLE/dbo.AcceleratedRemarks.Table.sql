/****** Object:  Table [dbo].[AcceleratedRemarks]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AcceleratedRemarks]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AcceleratedRemarks](
	[ArId] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[ArAcceleratedVestingId] [numeric](18, 0) NOT NULL,
	[ArGrantDate] [datetime] NULL,
	[ArGrantRegid] [varchar](20) NULL,
	[ArEmployeeId] [varchar](20) NULL,
	[ArGrantoptionid] [varchar](100) NULL,
	[ArRemarks] [varchar](100) NULL,
	[ArIsShadow] [varchar](1) NULL,
	[ArLevel] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ArId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
