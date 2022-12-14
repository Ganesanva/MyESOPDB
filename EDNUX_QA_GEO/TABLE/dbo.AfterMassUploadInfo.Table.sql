/****** Object:  Table [dbo].[AfterMassUploadInfo]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AfterMassUploadInfo]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AfterMassUploadInfo](
	[MassUploadID] [numeric](18, 0) NOT NULL,
	[Type] [varchar](50) NOT NULL,
	[InitiatedBy] [varchar](50) NOT NULL,
	[InitiatedDate] [datetime] NOT NULL,
	[UploadedDate] [datetime] NOT NULL,
	[UploadedTime] [datetime] NOT NULL,
 CONSTRAINT [PK_AfterMassUploadInfo] PRIMARY KEY CLUSTERED 
(
	[MassUploadID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
