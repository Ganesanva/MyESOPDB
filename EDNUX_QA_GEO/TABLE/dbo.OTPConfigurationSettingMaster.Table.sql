/****** Object:  Table [dbo].[OTPConfigurationSettingMaster]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OTPConfigurationSettingMaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OTPConfigurationSettingMaster](
	[OTPConfigurationSettingMasterID] [int] IDENTITY(1,1) NOT NULL,
	[OTPConfigurationTypeID] [int] NULL,
	[OTPExpirationTimeInSeconds] [int] NULL,
	[OTPDigits] [int] NULL,
	[AttemptAllowed] [int] NULL,
	[IsOTPResendButtonEnable] [bit] NULL,
	[IsAlphaNumeric] [bit] NULL,
	[IsActive] [bit] NULL,
	[CREATED_BY] [nvarchar](100) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [nvarchar](100) NOT NULL,
	[UPDATED_ON] [datetime] NOT NULL,
	[IsChkOTPForSecondary] [bit] NULL,
	[OTPConfigurationFieldID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[OTPConfigurationSettingMasterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__OTPConfig__IsOTP__2991C0B0]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OTPConfigurationSettingMaster] ADD  DEFAULT ((0)) FOR [IsOTPResendButtonEnable]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__OTPConfig__IsAct__2A85E4E9]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OTPConfigurationSettingMaster] ADD  DEFAULT ((0)) FOR [IsActive]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__OTPConfig__OTPCo__2B7A0922]') AND parent_object_id = OBJECT_ID(N'[dbo].[OTPConfigurationSettingMaster]'))
ALTER TABLE [dbo].[OTPConfigurationSettingMaster]  WITH CHECK ADD FOREIGN KEY([OTPConfigurationTypeID])
REFERENCES [dbo].[OTPConfigurationTypeMaster] ([OTPConfigurationTypeID])
GO
