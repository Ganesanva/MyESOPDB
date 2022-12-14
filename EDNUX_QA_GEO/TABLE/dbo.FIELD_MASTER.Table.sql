/****** Object:  Table [dbo].[FIELD_MASTER]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FIELD_MASTER]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[FIELD_MASTER](
	[Field_Id] [int] IDENTITY(1,1) NOT NULL,
	[Field_Name] [varchar](200) NULL,
	[Table_Name] [varchar](200) NULL,
	[Db_Column_Name] [varchar](200) NULL,
	[LastUpdated_By] [varchar](50) NULL,
	[LastUpdated_On] [datetime] NULL,
	[Alise_Name] [varchar](50) NULL
) ON [PRIMARY]
END
GO
