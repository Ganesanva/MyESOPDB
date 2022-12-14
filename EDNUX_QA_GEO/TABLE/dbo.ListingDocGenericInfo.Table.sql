/****** Object:  Table [dbo].[ListingDocGenericInfo]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListingDocGenericInfo]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ListingDocGenericInfo](
	[LstDocGenInfoID] [int] IDENTITY(1,1) NOT NULL,
	[Place] [nvarchar](500) NULL,
	[KindOfSecurity] [nvarchar](500) NULL,
	[ISINNumber] [nvarchar](500) NULL,
	[AuthourizedSignName] [nvarchar](500) NULL,
	[AuthorizedSingDesig] [nvarchar](500) NULL,
	[TelephoneNo] [nvarchar](500) NULL,
	[FaxNumber] [nvarchar](500) NULL,
	[EmailID] [nvarchar](500) NULL,
	[CreatedBy] [varchar](100) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [varchar](100) NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_ListingDocGenericInfo] PRIMARY KEY CLUSTERED 
(
	[LstDocGenInfoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
