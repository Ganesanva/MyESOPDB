/****** Object:  Table [dbo].[AuditTrailAllotmentListReversal]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AuditTrailAllotmentListReversal]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AuditTrailAllotmentListReversal](
	[AuditId] [bigint] IDENTITY(1,1) NOT NULL,
	[ExerciseNo] [varchar](20) NULL,
	[ExerciseId] [varchar](20) NULL,
	[AllotedUniqueId] [varchar](20) NULL,
	[AllotmentReversalDate] [datetime] NULL,
	[LastUpdatedBy] [varchar](100) NULL,
	[LastUpdatedDate] [datetime] NULL,
 CONSTRAINT [PK_AuditTrailAllotmentListReversal] PRIMARY KEY CLUSTERED 
(
	[AuditId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
