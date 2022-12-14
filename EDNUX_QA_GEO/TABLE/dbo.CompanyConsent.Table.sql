/****** Object:  Table [dbo].[CompanyConsent]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyConsent]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CompanyConsent](
	[EmployeeID] [varchar](20) NULL,
	[AcceptanceDate] [datetime] NULL,
	[LastUpdatedBy] [varchar](20) NULL,
	[LastUpdatedOn] [datetime] NULL,
	[Category] [nvarchar](40) NULL,
	[CountryAliasName] [nvarchar](10) NULL,
	[CountryName] [nvarchar](50) NULL,
	[ECAD] [int] IDENTITY(1,1) NOT NULL,
	[Date of change in category] [nvarchar](50) NULL,
 CONSTRAINT [PK_CompanyConsent_ECAD] PRIMARY KEY CLUSTERED 
(
	[ECAD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
