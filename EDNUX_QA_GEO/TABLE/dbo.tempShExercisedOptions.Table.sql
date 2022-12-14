/****** Object:  Table [dbo].[tempShExercisedOptions]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tempShExercisedOptions]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tempShExercisedOptions](
	[t_ExerciseId] [numeric](18, 0) NOT NULL,
	[ExercisedQuantity] [numeric](18, 0) NOT NULL,
	[ExercisePrice] [numeric](18, 2) NOT NULL,
	[ExerciseDate] [datetime] NOT NULL,
	[EmployeeID] [varchar](20) NOT NULL,
	[LockedInTill] [datetime] NULL,
	[ExercisableQuantity] [numeric](18, 0) NOT NULL,
	[GrantLegId] [numeric](18, 0) NOT NULL,
	[ExerciseNo] [numeric](18, 0) NULL,
	[PerqstValue] [numeric](18, 2) NULL,
	[PerqstPayable] [numeric](18, 2) NULL,
	[FMVPrice] [numeric](18, 2) NULL,
	[payrollcountry] [varchar](100) NULL,
	[IsMassUpload] [char](1) NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[Perq_Tax_rate] [numeric](18, 2) NULL,
	[t_ExerciseNo] [numeric](18, 0) NOT NULL,
	[GrantOptionId] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[t_ExerciseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
