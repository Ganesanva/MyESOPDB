/****** Object:  Table [dbo].[MST_EMP_CONSENT_DISCLARATION]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MST_EMP_CONSENT_DISCLARATION]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MST_EMP_CONSENT_DISCLARATION](
	[ECD_ID] [int] IDENTITY(1,1) NOT NULL,
	[EEFCA] [nvarchar](40) NULL,
	[ECT] [nvarchar](40) NULL,
	[ECST] [nvarchar](40) NULL,
	[EU_EmployeeMsg] [nvarchar](max) NULL,
	[Non_EUEmployeeMsg] [nvarchar](max) NULL,
	[CompanyLevelMsg] [nvarchar](max) NULL,
	[Is_Selected] [bit] NULL,
	[LastUpdatedBy] [nvarchar](20) NULL,
	[LastUpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_MST_EMP_CONSENT_DISCLARATION_ECD_ID] PRIMARY KEY CLUSTERED 
(
	[ECD_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
