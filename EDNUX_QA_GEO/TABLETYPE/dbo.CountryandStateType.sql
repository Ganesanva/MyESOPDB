/****** Object:  UserDefinedTableType [dbo].[CountryandStateType]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[CountryandStateType]
GO
/****** Object:  UserDefinedTableType [dbo].[CountryandStateType]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[CountryandStateType] AS TABLE(
	[PaymentMode] [nvarchar](200) NULL,
	[Type] [nvarchar](200) NULL,
	[Country] [nvarchar](50) NULL,
	[State] [nvarchar](200) NULL,
	[ProcessNote] [nvarchar](200) NULL
)
GO
