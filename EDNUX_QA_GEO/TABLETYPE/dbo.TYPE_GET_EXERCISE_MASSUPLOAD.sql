/****** Object:  UserDefinedTableType [dbo].[TYPE_GET_EXERCISE_MASSUPLOAD]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_GET_EXERCISE_MASSUPLOAD]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_GET_EXERCISE_MASSUPLOAD]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[TYPE_GET_EXERCISE_MASSUPLOAD] AS TABLE(
	[ID] [nvarchar](100) NULL,
	[GrantOptionId] [nvarchar](100) NULL,
	[ExercisableQuantity] [numeric](18, 0) NULL,
	[ExercisePrice] [numeric](18, 6) NULL,
	[ExercisedQuantity] [numeric](18, 0) NULL,
	[GrantLegId] [nvarchar](10) NULL,
	[LotNumber] [varchar](20) NULL,
	[EmployeeID] [nvarchar](100) NULL,
	[ExerciseDate] [datetime] NULL,
	[DateOfAllotment] [datetime] NULL
)
GO
