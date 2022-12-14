/****** Object:  Table [dbo].[MST_Summary_Column_Setting]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MST_Summary_Column_Setting]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MST_Summary_Column_Setting](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DisplayColumnName] [nvarchar](max) NULL,
	[DataColumnName] [nvarchar](max) NULL,
	[Level] [nvarchar](max) NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [varchar](30) NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [varchar](30) NULL,
	[UpdatedOn] [datetime] NULL,
	[SequenceNo] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
