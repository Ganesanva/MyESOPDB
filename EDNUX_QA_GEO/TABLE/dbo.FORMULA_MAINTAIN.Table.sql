/****** Object:  Table [dbo].[FORMULA_MAINTAIN]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FORMULA_MAINTAIN]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[FORMULA_MAINTAIN](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FORMULA] [varchar](1000) NULL,
	[COMPANYID] [varchar](50) NULL,
	[RESI_STATUS] [char](1) NULL,
	[ALIAS_NAME] [varchar](20) NULL,
	[LASTUPDATEDBY] [varchar](20) NULL,
	[LASTUPDATEDON] [datetime] NULL
) ON [PRIMARY]
END
GO
