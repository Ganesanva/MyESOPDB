/****** Object:  UserDefinedTableType [dbo].[PRE_GRANTDATA_DELETION]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[PRE_GRANTDATA_DELETION]
GO
/****** Object:  UserDefinedTableType [dbo].[PRE_GRANTDATA_DELETION]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[PRE_GRANTDATA_DELETION] AS TABLE(
	[Letter_Code] [varchar](50) NULL
)
GO
