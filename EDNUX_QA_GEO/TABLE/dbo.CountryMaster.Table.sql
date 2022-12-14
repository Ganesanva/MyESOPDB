/****** Object:  Table [dbo].[CountryMaster]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CountryMaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CountryMaster](
	[ID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[CountryName] [varchar](50) NOT NULL,
	[CountryAliasName] [varchar](10) NOT NULL,
	[IsSelected] [int] NOT NULL,
	[Category] [nvarchar](10) NULL,
	[IS_MANDATORY_STATE] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CountryMa__IsSel__3F6663D5]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CountryMaster] ADD  DEFAULT ('0') FOR [IsSelected]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CountryMa__IS_MA__6A7BDC2D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CountryMaster] ADD  DEFAULT ((0)) FOR [IS_MANDATORY_STATE]
END
GO
