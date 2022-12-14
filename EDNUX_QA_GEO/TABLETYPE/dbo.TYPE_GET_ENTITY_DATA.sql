/****** Object:  UserDefinedTableType [dbo].[TYPE_GET_ENTITY_DATA]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_GET_ENTITY_DATA]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_GET_ENTITY_DATA]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[TYPE_GET_ENTITY_DATA] AS TABLE(
	[INSTRUMENT_ID] [bigint] NULL,
	[SCHEME_ID] [nvarchar](250) NULL,
	[EMPLOYEE_ID] [varchar](50) NULL,
	[GRANTOPTIONID] [varchar](50) NULL,
	[GRANTDATE] [datetime] NULL,
	[FIELDNAME] [nvarchar](250) NULL
)
GO
