/****** Object:  UserDefinedTableType [dbo].[MANAGE_MERCHANTCODE_UPLOAD_TYPE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[MANAGE_MERCHANTCODE_UPLOAD_TYPE]
GO
/****** Object:  UserDefinedTableType [dbo].[MANAGE_MERCHANTCODE_UPLOAD_TYPE]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[MANAGE_MERCHANTCODE_UPLOAD_TYPE] AS TABLE(
	[GRANTREGISTRATIONID] [varchar](50) NULL,
	[Entity] [varchar](200) NULL,
	[MerchantCode] [varchar](100) NULL
)
GO
