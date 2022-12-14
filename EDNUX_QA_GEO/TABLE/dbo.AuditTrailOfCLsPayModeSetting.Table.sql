/****** Object:  Table [dbo].[AuditTrailOfCLsPayModeSetting]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AuditTrailOfCLsPayModeSetting]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AuditTrailOfCLsPayModeSetting](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [varchar](50) NULL,
	[OldIsSAPayModeAllowed] [bit] NULL,
	[NewIsSAPayModeAllowed] [bit] NULL,
	[OldIsSPPayModeAllowed] [bit] NULL,
	[NewIsSPPayModeAllowed] [bit] NULL,
	[ModifiedBy] [varchar](50) NULL,
	[ModifiedOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
