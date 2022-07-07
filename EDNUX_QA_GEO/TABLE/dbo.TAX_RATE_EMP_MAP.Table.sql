/****** Object:  Table [dbo].[TAX_RATE_EMP_MAP]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TAX_RATE_EMP_MAP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TAX_RATE_EMP_MAP](
	[TREP_ID] [bigint] IDENTITY(1,1) NOT NULL,
	[TRSC_ID] [bigint] NULL,
	[Employee_ID] [nvarchar](50) NULL,
	[TAXRATE_LIVE_EMPLOYEE] [decimal](18, 9) NULL,
	[TAXRATE_SEPRATED_EMPLOYEE] [decimal](18, 9) NULL,
	[CREATED_BY] [nvarchar](100) NULL,
	[CREATED_ON] [datetime] NULL,
	[UPDATED_BY] [nvarchar](100) NULL,
	[UPDATED_ON] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[TREP_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
