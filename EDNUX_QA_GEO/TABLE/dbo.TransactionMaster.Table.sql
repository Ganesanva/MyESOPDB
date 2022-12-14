/****** Object:  Table [dbo].[TransactionMaster]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionMaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TransactionMaster](
	[TransactionID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [nvarchar](50) NOT NULL,
	[UserType] [varchar](100) NULL,
	[TableName] [varchar](100) NULL,
	[TableFieldName] [varchar](100) NULL,
	[OldValue] [varchar](500) NULL,
	[NewValue] [varchar](500) NULL,
	[TransactionDescription] [nvarchar](max) NULL,
	[TransactionDate] [datetime] NOT NULL,
	[CategoryID] [nvarchar](100) NULL,
	[CreatedBy] [varchar](100) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [varchar](100) NULL,
	[LastUpdatedOn] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
