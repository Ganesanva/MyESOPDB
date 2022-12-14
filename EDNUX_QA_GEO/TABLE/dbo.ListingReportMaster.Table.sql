/****** Object:  Table [dbo].[ListingReportMaster]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListingReportMaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ListingReportMaster](
	[LstReportID] [int] IDENTITY(1,1) NOT NULL,
	[ReportName] [varchar](100) NULL,
	[Format] [varchar](50) NULL,
 CONSTRAINT [PK_ListingReportMaster] PRIMARY KEY CLUSTERED 
(
	[LstReportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
