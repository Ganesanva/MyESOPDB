/****** Object:  UserDefinedTableType [dbo].[TYPE_DEMAT_AND_BANKACC_STATUS_MASSUPLOAD]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_DEMAT_AND_BANKACC_STATUS_MASSUPLOAD]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_DEMAT_AND_BANKACC_STATUS_MASSUPLOAD]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[TYPE_DEMAT_AND_BANKACC_STATUS_MASSUPLOAD] AS TABLE(
	[Sr.No] [int] NULL,
	[Employee Id] [varchar](20) NULL,
	[Demat Id] [bigint] NULL,
	[Status] [nvarchar](10) NULL
)
GO
