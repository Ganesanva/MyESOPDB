/****** Object:  Table [dbo].[Mapping_EmpMaster_ConfigDtls]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Mapping_EmpMaster_ConfigDtls]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Mapping_EmpMaster_ConfigDtls](
	[EMCM_ID] [int] IDENTITY(1,1) NOT NULL,
	[ConfigDetails_Fields] [varchar](100) NULL,
	[EmployeeMaster_Fields] [varchar](100) NULL,
	[OUTPUT_FIELD] [varchar](100) NULL
) ON [PRIMARY]
END
GO
