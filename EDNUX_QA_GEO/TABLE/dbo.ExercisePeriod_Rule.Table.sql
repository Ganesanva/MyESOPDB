/****** Object:  Table [dbo].[ExercisePeriod_Rule]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ExercisePeriod_Rule]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ExercisePeriod_Rule](
	[Apply_AllEmp] [char](1) NULL,
	[Exceptnl_EmpSet] [varchar](500) NULL,
	[LastUpdatedBy] [varchar](50) NULL,
	[LastUpdatedOn] [datetime] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ExerciseP__Apply__469D7149]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ExercisePeriod_Rule] ADD  DEFAULT ('A') FOR [Apply_AllEmp]
END
GO
