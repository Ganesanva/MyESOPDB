/****** Object:  Table [dbo].[ListingDocSchConcatenation]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListingDocSchConcatenation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ListingDocSchConcatenation](
	[SchConcatentionID] [int] IDENTITY(1,1) NOT NULL,
	[SchemeID] [varchar](50) NOT NULL,
	[UniqueCode] [nvarchar](500) NOT NULL,
	[Name] [nvarchar](500) NOT NULL,
	[CreatedBy] [varchar](100) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_ListingDocSchConcatenation] PRIMARY KEY CLUSTERED 
(
	[SchConcatentionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
