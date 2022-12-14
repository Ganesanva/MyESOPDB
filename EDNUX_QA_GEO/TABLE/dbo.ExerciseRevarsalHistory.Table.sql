/****** Object:  Table [dbo].[ExerciseRevarsalHistory]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ExerciseRevarsalHistory]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ExerciseRevarsalHistory](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ExerciseID] [int] NULL,
	[EXerciseNO] [int] NULL,
	[ExerciseDate] [datetime] NULL,
	[ExercisedQuantity] [int] NULL,
	[RevarsalDate] [datetime] NULL,
	[RevarsalReason] [varchar](100) NULL,
	[LastUpdatedBy] [varchar](50) NULL,
	[LastUpdatedOn] [datetime] NULL
) ON [PRIMARY]
END
GO
