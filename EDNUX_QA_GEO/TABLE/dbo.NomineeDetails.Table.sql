/****** Object:  Table [dbo].[NomineeDetails]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NomineeDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[NomineeDetails](
	[NomineeId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [nvarchar](20) NOT NULL,
	[NomineeName] [varchar](50) NULL,
	[NomineeDOB] [varchar](50) NULL,
	[PercentageOfShare] [nvarchar](50) NULL,
	[NomineeAddress] [varchar](500) NULL,
	[NameOfGuardian] [nvarchar](50) NULL,
	[AddressOfGuardian] [varchar](500) NULL,
	[GuardianDateOfBirth] [varchar](50) NULL,
	[IsActive] [bit] NULL,
	[CREATED_BY] [nvarchar](100) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [nvarchar](100) NOT NULL,
	[UPDATED_ON] [datetime] NOT NULL,
	[ApprovalStatus] [char](1) NULL,
	[DateOfSubmissionOfForm] [varchar](50) NULL,
	[RelationOf_Nominee] [varchar](50) NULL,
	[Nominee_PANNumber] [nvarchar](12) NULL,
	[Nominee_EmailId] [varchar](50) NULL,
	[Nominee_ContactNumber] [nvarchar](50) NULL,
	[Nominee_ADHARNumber] [nvarchar](12) NULL,
	[Nominee_SIDNumber] [nvarchar](50) NULL,
	[Nominee_Other1] [nvarchar](50) NULL,
	[Nominee_Other2] [nvarchar](50) NULL,
	[Nominee_Other3] [nvarchar](50) NULL,
	[Nominee_Other4] [nvarchar](50) NULL,
	[RelationOf_Guardian] [varchar](50) NULL,
	[Guardian_PANNumber] [nvarchar](12) NULL,
	[Guardian_EmailId] [varchar](50) NULL,
	[Guardian_ContactNumber] [nvarchar](50) NULL,
	[Guardian_ADHARNumber] [nvarchar](12) NULL,
	[Guardian_SIDNumber] [nvarchar](50) NULL,
	[Guardian_Other1] [nvarchar](50) NULL,
	[Guardian_Other2] [nvarchar](50) NULL,
	[Guardian_Other3] [nvarchar](50) NULL,
	[Guardian_Other4] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[NomineeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
