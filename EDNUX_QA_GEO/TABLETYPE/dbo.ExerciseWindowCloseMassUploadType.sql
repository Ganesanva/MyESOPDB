/****** Object:  UserDefinedTableType [dbo].[ExerciseWindowCloseMassUploadType]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[ExerciseWindowCloseMassUploadType]
GO
/****** Object:  UserDefinedTableType [dbo].[ExerciseWindowCloseMassUploadType]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[ExerciseWindowCloseMassUploadType] AS TABLE(
	[FromDate] [datetime] NULL,
	[ToDate] [datetime] NULL,
	[ISNonTradingDay] [varchar](1) NULL,
	[FromTime] [time](7) NULL,
	[ToTime] [time](7) NULL,
	[IsError] [varchar](10) NULL,
	[Remark] [varchar](200) NULL
)
GO
