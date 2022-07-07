/****** Object:  Table [dbo].[AUDIT_EXERCISETRANSACTION_DETAILS]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AUDIT_EXERCISETRANSACTION_DETAILS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AUDIT_EXERCISETRANSACTION_DETAILS](
	[ExerciseNo] [nvarchar](100) NOT NULL,
	[PayModeName] [nvarchar](100) NULL,
	[UPDATED_BY] [nvarchar](100) NOT NULL,
	[UPDATED_ON] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
