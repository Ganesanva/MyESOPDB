/****** Object:  Table [dbo].[VestingScheduleColumns]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VestingScheduleColumns]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[VestingScheduleColumns](
	[VSCID] [int] IDENTITY(1,1) NOT NULL,
	[COLUMN_NAME] [varchar](150) NOT NULL,
	[COLUMN_TYPE] [varchar](150) NOT NULL,
	[HEADER_TEXT] [varchar](150) NOT NULL,
	[FIELDS] [varchar](150) NULL,
	[UPDATED_BY] [varchar](50) NOT NULL,
	[UPDATED_ON] [datetime] NULL
) ON [PRIMARY]
END
GO
