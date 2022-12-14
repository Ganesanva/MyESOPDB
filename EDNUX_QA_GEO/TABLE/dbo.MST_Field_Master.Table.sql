/****** Object:  Table [dbo].[MST_Field_Master]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MST_Field_Master]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MST_Field_Master](
	[MFM_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[MS_Id] [bigint] NOT NULL,
	[FieldName] [nvarchar](100) NULL,
	[IsActive] [bit] NULL,
	[CREATED_BY] [nvarchar](50) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [nvarchar](50) NULL,
	[UPDATED_ON] [datetime] NULL
) ON [PRIMARY]
END
GO
