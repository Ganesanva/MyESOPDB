/****** Object:  Table [dbo].[GrantAccMassUploadDet]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GrantAccMassUploadDet]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GrantAccMassUploadDet](
	[GAMUDETID] [int] IDENTITY(1,1) NOT NULL,
	[GAMUID] [int] NOT NULL,
	[LetterCode] [varchar](100) NULL,
	[VestPeriod] [int] NULL,
	[VestingDate] [datetime] NULL,
	[NoOfOptions] [numeric](18, 0) NULL,
	[Field1] [varchar](max) NULL,
	[Field2] [varchar](max) NULL,
	[Field3] [varchar](max) NULL,
	[Field4] [varchar](max) NULL,
	[Field5] [varchar](max) NULL,
	[Field6] [varchar](max) NULL,
	[Field7] [varchar](max) NULL,
	[Field8] [varchar](max) NULL,
	[Field9] [varchar](max) NULL,
	[Field10] [varchar](max) NULL,
	[VestingType] [varchar](2) NULL,
 CONSTRAINT [PK_GrantAccMassUploadDet] PRIMARY KEY CLUSTERED 
(
	[GAMUDETID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
