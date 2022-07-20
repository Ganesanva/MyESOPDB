/****** Object:  Table [dbo].[MST_DEFERRED_CASH_GRANT]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MST_DEFERRED_CASH_GRANT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MST_DEFERRED_CASH_GRANT](
	[DCG_ID] [bigint] IDENTITY(1,1) NOT NULL,
	[DataColumnName] [nvarchar](500) NOT NULL,
	[DisplayColumnName] [nvarchar](500) NOT NULL,
	[IsActive] [tinyint] NULL,
	[SequenceNo] [tinyint] NULL,
	[CREATED_BY] [nvarchar](100) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [nvarchar](100) NOT NULL,
	[UPDATED_ON] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DCG_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__MST_DEFER__IsAct__21196E21]') AND type = 'D')
--BEGIN
--ALTER TABLE [dbo].[MST_DEFERRED_CASH_GRANT] ADD DEFAULT ((1)) FOR [IsActive]
--END
--GO

IF NOT EXISTS (SELECT 'X' 
				FROM sys.default_constraints
				where parent_object_id = object_id('MST_DEFERRED_CASH_GRANT')
			  )
BEGIN
ALTER TABLE [dbo].[MST_DEFERRED_CASH_GRANT] ADD  DEFAULT ((1)) FOR [IsActive]
END
GO

