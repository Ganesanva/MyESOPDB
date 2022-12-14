/****** Object:  Table [dbo].[ShExercisedOptions_Exception]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ShExercisedOptions_Exception]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ShExercisedOptions_Exception](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ExerciseId] [varchar](50) NULL,
	[PERQSTVALUE] [numeric](18, 6) NULL,
	[TentativePerqstValue] [numeric](18, 6) NULL,
 CONSTRAINT [PK__ShExerci__3214EC277B92F044] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
