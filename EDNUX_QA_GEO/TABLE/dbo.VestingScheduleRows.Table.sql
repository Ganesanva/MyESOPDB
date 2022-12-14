/****** Object:  Table [dbo].[VestingScheduleRows]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VestingScheduleRows]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[VestingScheduleRows](
	[VSRID] [int] IDENTITY(1,1) NOT NULL,
	[VSCID] [int] NOT NULL,
	[ROW_NAME] [varchar](150) NOT NULL,
	[VALUE] [varchar](150) NOT NULL,
	[FIELDS] [varchar](150) NULL,
	[UPDATED_BY] [varchar](50) NOT NULL,
	[UPDATED_ON] [datetime] NULL
) ON [PRIMARY]
END
GO
