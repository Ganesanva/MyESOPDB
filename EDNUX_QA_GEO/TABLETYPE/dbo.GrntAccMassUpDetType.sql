/****** Object:  UserDefinedTableType [dbo].[GrntAccMassUpDetType]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[GrntAccMassUpDetType]
GO
/****** Object:  UserDefinedTableType [dbo].[GrntAccMassUpDetType]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[GrntAccMassUpDetType] AS TABLE(
	[LetterCode] [varchar](100) NULL,
	[VesgingPercentage] [numeric](18, 9) NULL,
	[VestingPeriodId] [int] NULL,
	[VestingDate] [datetime] NULL,
	[NoOfOptions] [numeric](18, 9) NULL,
	[Field1] [varchar](max) NULL,
	[Field2] [varchar](max) NULL,
	[Field3] [varchar](max) NULL,
	[Field4] [varchar](max) NULL,
	[Field5] [varchar](max) NULL,
	[Field6] [varchar](max) NULL,
	[Field7] [varchar](max) NULL,
	[Field8] [varchar](max) NULL,
	[Field9] [varchar](max) NULL,
	[Field10] [varchar](max) NULL,
	[VestingType] [varchar](2) NULL
)
GO
