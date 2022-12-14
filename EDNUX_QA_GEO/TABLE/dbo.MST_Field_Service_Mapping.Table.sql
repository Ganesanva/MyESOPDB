/****** Object:  Table [dbo].[MST_Field_Service_Mapping]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MST_Field_Service_Mapping]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MST_Field_Service_Mapping](
	[MFSM_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[MS_Id] [bigint] NOT NULL,
	[MFM_Id] [bigint] NOT NULL,
	[DisplayFieldName] [nvarchar](250) NULL,
	[MappedFieldName] [nvarchar](200) NULL,
	[FieldSequenceNo] [int] NULL,
	[Descriptions] [nvarchar](max) NULL,
	[IsActive] [bit] NULL,
	[CREATED_BY] [nvarchar](50) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [nvarchar](50) NULL,
	[UPDATED_ON] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
