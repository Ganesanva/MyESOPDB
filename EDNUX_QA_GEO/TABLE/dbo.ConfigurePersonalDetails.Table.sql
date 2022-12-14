/****** Object:  Table [dbo].[ConfigurePersonalDetails]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ConfigurePersonalDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ConfigurePersonalDetails](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeField] [varchar](100) NOT NULL,
	[Check_ToEmp] [char](1) NULL,
	[Check_ToExercise] [char](1) NULL,
	[Associate_Control] [varchar](100) NULL,
	[Datafield] [varchar](100) NULL,
	[Check_Own] [char](1) NULL,
	[Check_Funding] [char](1) NULL,
	[Check_SellAll] [char](1) NULL,
	[Check_SellPartial] [char](1) NULL,
	[LastUpdatedBy] [varchar](100) NULL,
	[LastUpdatedOn] [datetime] NULL,
	[Check_Exercise] [char](1) NOT NULL,
	[Check_DematSettings] [varchar](1) NULL,
	[CHECK_BROKERSETTINGS] [varchar](1) NULL,
	[ADS_CHECK_OWN] [char](1) NULL,
	[ADS_CHECK_FUNDING] [char](1) NULL,
	[ADS_CHECK_SELLALL] [char](1) NULL,
	[ADS_CHECK_SELLPARTIAL] [char](1) NULL,
	[ADS_CHECK_EXERCISE] [char](1) NULL,
	[DISPLAY_NAME] [nvarchar](200) NULL,
	[ISEDIT] [bit] NULL,
	[MIT_ID] [int] NULL,
	[ExerciseNow_Field_Show] [char](1) NULL,
	[reConfirmation] [char](1) NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Configure__Check__6E8B6712]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ConfigurePersonalDetails] ADD  DEFAULT ('Y') FOR [Check_ToEmp]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Configure__Check__6F7F8B4B]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ConfigurePersonalDetails] ADD  DEFAULT ('Y') FOR [Check_Own]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Configure__Check__7073AF84]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ConfigurePersonalDetails] ADD  DEFAULT ('Y') FOR [Check_Funding]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Configure__Check__7167D3BD]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ConfigurePersonalDetails] ADD  DEFAULT ('Y') FOR [Check_SellAll]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Configure__Check__725BF7F6]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ConfigurePersonalDetails] ADD  DEFAULT ('Y') FOR [Check_SellPartial]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Configure__LastU__73501C2F]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ConfigurePersonalDetails] ADD  DEFAULT ('admin') FOR [LastUpdatedBy]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Configure__LastU__74444068]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ConfigurePersonalDetails] ADD  DEFAULT ('10-Feb-2012') FOR [LastUpdatedOn]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Configure__Check__1881A0DE]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ConfigurePersonalDetails] ADD  DEFAULT ('N') FOR [Check_Exercise]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Configure__Exerc__383B0EB0]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ConfigurePersonalDetails] ADD  DEFAULT ('Y') FOR [ExerciseNow_Field_Show]
END
GO
