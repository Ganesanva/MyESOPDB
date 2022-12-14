/****** Object:  Table [dbo].[PasswordConfig]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PasswordConfig]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PasswordConfig](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MinLength] [numeric](18, 0) NOT NULL,
	[MaxLength] [numeric](18, 0) NOT NULL,
	[MinAlphabets] [numeric](18, 0) NOT NULL,
	[MinNumbers] [numeric](18, 0) NOT NULL,
	[MinSplChar] [numeric](18, 0) NOT NULL,
	[MinUppercaseChar] [numeric](18, 0) NOT NULL,
	[CountOfPassHistory] [numeric](18, 0) NOT NULL,
	[PassValidity] [numeric](18, 0) NULL,
	[ExpiryReminder] [numeric](18, 0) NULL,
	[LastUpdatedOn] [datetime] NULL,
	[LastUpdatedBy] [varchar](50) NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PasswordConfig_MinLength]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PasswordConfig] ADD  CONSTRAINT [DF_PasswordConfig_MinLength]  DEFAULT ((0)) FOR [MinLength]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PasswordConfig_MaxLength]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PasswordConfig] ADD  CONSTRAINT [DF_PasswordConfig_MaxLength]  DEFAULT ((0)) FOR [MaxLength]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PasswordConfig_MinAlphabets]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PasswordConfig] ADD  CONSTRAINT [DF_PasswordConfig_MinAlphabets]  DEFAULT ((0)) FOR [MinAlphabets]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PasswordConfig_MinNumbers]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PasswordConfig] ADD  CONSTRAINT [DF_PasswordConfig_MinNumbers]  DEFAULT ((0)) FOR [MinNumbers]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PasswordConfig_MinSplChar]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PasswordConfig] ADD  CONSTRAINT [DF_PasswordConfig_MinSplChar]  DEFAULT ((0)) FOR [MinSplChar]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PasswordConfig_MinUppercaseChar]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PasswordConfig] ADD  CONSTRAINT [DF_PasswordConfig_MinUppercaseChar]  DEFAULT ((0)) FOR [MinUppercaseChar]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PasswordConfig_CountOfPassHistory]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PasswordConfig] ADD  CONSTRAINT [DF_PasswordConfig_CountOfPassHistory]  DEFAULT ((0)) FOR [CountOfPassHistory]
END
GO
