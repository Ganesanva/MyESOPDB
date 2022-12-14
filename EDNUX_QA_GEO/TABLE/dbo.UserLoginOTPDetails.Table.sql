/****** Object:  Table [dbo].[UserLoginOTPDetails]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserLoginOTPDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserLoginOTPDetails](
	[OTPDetailsID] [int] IDENTITY(1,1) NOT NULL,
	[OTPConfigurationSettingMasterID] [int] NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[MobileNo] [nvarchar](20) NULL,
	[EmailID] [nvarchar](100) NULL,
	[OTPCode] [nvarchar](20) NULL,
	[OTPSentOn] [datetime] NULL,
	[OTPExpiredOn] [datetime] NULL,
	[IsValidated] [bit] NULL,
	[CREATED_BY] [nvarchar](100) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [nvarchar](100) NOT NULL,
	[UPDATED_ON] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[OTPDetailsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__UserLogin__IsVal__3132E278]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[UserLoginOTPDetails] ADD  DEFAULT ((0)) FOR [IsValidated]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__UserLogin__OTPCo__322706B1]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserLoginOTPDetails]'))
ALTER TABLE [dbo].[UserLoginOTPDetails]  WITH CHECK ADD FOREIGN KEY([OTPConfigurationSettingMasterID])
REFERENCES [dbo].[OTPConfigurationSettingMaster] ([OTPConfigurationSettingMasterID])
GO
