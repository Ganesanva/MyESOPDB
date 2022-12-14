/****** Object:  Table [dbo].[ExerciseSARDetails]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ExerciseSARDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ExerciseSARDetails](
	[ExerciseSARid] [int] IDENTITY(1,1) NOT NULL,
	[Status] [char](1) NOT NULL,
	[ExercsiedQuantity] [numeric](18, 0) NULL,
	[FMV_SAR] [numeric](18, 2) NULL,
	[FaceValue] [numeric](18, 2) NULL,
	[SharesIssued] [numeric](18, 0) NULL,
	[PerqValue] [numeric](18, 2) NULL,
	[Stockappreciation] [numeric](18, 2) NULL,
 CONSTRAINT [PK_ExerciseSARDetails] PRIMARY KEY CLUSTERED 
(
	[ExerciseSARid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ExerciseS__Statu__4183B671]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ExerciseSARDetails] ADD  DEFAULT ('S') FOR [Status]
END
GO
