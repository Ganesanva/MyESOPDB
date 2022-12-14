/****** Object:  Table [dbo].[ResidentialType]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ResidentialType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ResidentialType](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ResidentialStatus] [char](1) NOT NULL,
	[Description] [varchar](100) NULL,
	[CreatedBy] [varchar](100) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [varchar](100) NULL,
	[LastUpdatedOn] [datetime] NULL,
UNIQUE NONCLUSTERED 
(
	[ResidentialStatus] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Residenti__Creat__078C1F06]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ResidentialType] ADD  DEFAULT ('Admin') FOR [CreatedBy]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Residenti__Creat__0880433F]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ResidentialType] ADD  DEFAULT (getdate()) FOR [CreatedOn]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Residenti__LastU__09746778]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ResidentialType] ADD  DEFAULT ('Admin') FOR [LastUpdatedBy]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Residenti__LastU__0A688BB1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ResidentialType] ADD  DEFAULT (getdate()) FOR [LastUpdatedOn]
END
GO
