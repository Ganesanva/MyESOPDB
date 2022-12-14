/****** Object:  UserDefinedTableType [dbo].[TYPE_WHAT_IF_ANANLYSIS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_WHAT_IF_ANANLYSIS]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_WHAT_IF_ANANLYSIS]    Script Date: 7/6/2022 1:40:55 PM ******/
CREATE TYPE [dbo].[TYPE_WHAT_IF_ANANLYSIS] AS TABLE(
	[ID] [nvarchar](200) NULL,
	[GRANTOPTIONID] [nvarchar](200) NULL,
	[GRANTEDOPTIONS] [nvarchar](200) NULL,
	[EXERCISABLEQUANTITY] [nvarchar](200) NULL,
	[GRANTDATE] [datetime] NULL,
	[EXERCISEPRICE] [nvarchar](200) NULL,
	[FINALEXPIRYDATE] [datetime] NULL,
	[OPTIONPRICE] [nvarchar](200) NULL,
	[SCHEMETITLE] [nvarchar](200) NULL,
	[OPTIONRATIOMULTIPLIER] [nvarchar](50) NULL,
	[OPTIONRATIODIVISOR] [nvarchar](50) NULL
)
GO
