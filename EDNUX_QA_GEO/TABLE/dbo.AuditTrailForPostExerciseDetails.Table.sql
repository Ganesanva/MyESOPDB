/****** Object:  Table [dbo].[AuditTrailForPostExerciseDetails]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AuditTrailForPostExerciseDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AuditTrailForPostExerciseDetails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ExerciseId] [int] NULL,
	[PreviousFMVPrice] [numeric](18, 2) NULL,
	[CurrentFMVPrice] [numeric](18, 2) NULL,
	[PreviousPQTax] [numeric](18, 6) NULL,
	[CurrentPQTax] [numeric](18, 6) NULL,
	[PreviousPQValue] [numeric](18, 6) NULL,
	[CurrentPQValue] [numeric](18, 6) NULL,
	[PreviousCGT] [numeric](18, 2) NULL,
	[CurrentCGT] [numeric](18, 2) NULL,
	[PreviousLastUpdatedBy] [varchar](40) NULL,
	[CurrentLastUpdatedBy] [varchar](40) NULL,
	[PreviousLastUpdatedOn] [datetime] NULL,
	[CurrentLastUpdatedOn] [datetime] NULL,
	[CurrentPQTaxRate] [numeric](18, 6) NULL,
	[PreviousPQTaxRate] [numeric](18, 6) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
