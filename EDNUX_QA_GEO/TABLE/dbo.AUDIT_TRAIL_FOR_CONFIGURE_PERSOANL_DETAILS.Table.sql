/****** Object:  Table [dbo].[AUDIT_TRAIL_FOR_CONFIGURE_PERSOANL_DETAILS]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AUDIT_TRAIL_FOR_CONFIGURE_PERSOANL_DETAILS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AUDIT_TRAIL_FOR_CONFIGURE_PERSOANL_DETAILS](
	[ATCPD_ID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeField] [varchar](100) NULL,
	[Check_ToExercise] [char](1) NULL,
	[Check_Own] [char](1) NULL,
	[Check_Funding] [char](1) NULL,
	[Check_SellAll] [char](1) NULL,
	[Check_SellPartial] [char](1) NULL,
	[LastUpdatedBy] [varchar](100) NULL,
	[LastUpdatedOn] [datetime] NULL,
	[Check_Exercise] [char](1) NULL,
	[ADS_CHECK_OWN] [char](1) NULL,
	[ADS_CHECK_FUNDING] [char](1) NULL,
	[ADS_CHECK_SELLALL] [char](1) NULL,
	[ADS_CHECK_SELLPARTIAL] [char](1) NULL,
	[ADS_CHECK_EXERCISE] [char](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[ATCPD_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
