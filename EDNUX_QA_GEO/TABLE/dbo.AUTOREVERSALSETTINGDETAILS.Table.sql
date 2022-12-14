/****** Object:  Table [dbo].[AUTOREVERSALSETTINGDETAILS]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AUTOREVERSALSETTINGDETAILS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AUTOREVERSALSETTINGDETAILS](
	[ARSDID] [int] IDENTITY(1,1) NOT NULL,
	[Isactivated] [bit] NOT NULL,
	[ColumnsToBeconsidered] [varchar](max) NOT NULL,
	[Formula] [varchar](max) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [varchar](50) NULL,
	[LastUpdatedOn] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__AUTOREVER__Isact__5D36BDDE]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AUTOREVERSALSETTINGDETAILS] ADD  DEFAULT ((0)) FOR [Isactivated]
END
GO
