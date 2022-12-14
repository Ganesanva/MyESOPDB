/****** Object:  Table [dbo].[MassUpload]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MassUpload]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MassUpload](
	[MassUploadID] [numeric](18, 0) NOT NULL,
	[Type] [varchar](100) NOT NULL,
	[InitiatedBy] [varchar](50) NOT NULL,
	[InitiatedDate] [datetime] NOT NULL,
	[FilePath] [varchar](200) NOT NULL,
	[ScheduledDate] [datetime] NULL,
	[ScheduledTime] [datetime] NULL,
	[Status] [char](1) NULL,
	[ErrorMessage] [varchar](1000) NULL,
 CONSTRAINT [PK_MassUpload] PRIMARY KEY CLUSTERED 
(
	[MassUploadID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
