/****** Object:  Table [dbo].[AuditTrail]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AuditTrail]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AuditTrail](
	[TransID] [varchar](20) NOT NULL,
	[TableName] [varchar](100) NOT NULL,
	[PK1] [varchar](20) NOT NULL,
	[PK2] [varchar](20) NOT NULL,
	[PK3] [varchar](20) NOT NULL,
	[PK4] [varchar](20) NOT NULL,
	[PK5] [varchar](20) NOT NULL,
	[PK6] [varchar](20) NOT NULL,
	[PK7] [varchar](20) NOT NULL,
	[PK8] [varchar](20) NOT NULL,
	[PK9] [varchar](20) NOT NULL,
	[PK10] [varchar](20) NOT NULL,
	[Action] [char](1) NOT NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[DataXML] [varchar](50) NULL,
 CONSTRAINT [PK_AuditTrail] PRIMARY KEY CLUSTERED 
(
	[TransID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
