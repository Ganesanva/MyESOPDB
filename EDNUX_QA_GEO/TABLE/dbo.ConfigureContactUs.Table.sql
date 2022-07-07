/****** Object:  Table [dbo].[ConfigureContactUs]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ConfigureContactUs]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ConfigureContactUs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](300) NOT NULL,
	[EmailId] [varchar](50) NULL
) ON [PRIMARY]
END
GO
