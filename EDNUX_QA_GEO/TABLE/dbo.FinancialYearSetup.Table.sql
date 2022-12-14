/****** Object:  Table [dbo].[FinancialYearSetup]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FinancialYearSetup]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[FinancialYearSetup](
	[FYID] [int] IDENTITY(1,1) NOT NULL,
	[Quarter] [int] NULL,
	[Month] [date] NULL,
	[FromDate] [datetime] NULL,
	[ToDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[FYID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
