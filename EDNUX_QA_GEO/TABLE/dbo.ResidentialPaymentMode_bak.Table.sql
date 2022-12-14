/****** Object:  Table [dbo].[ResidentialPaymentMode_bak]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ResidentialPaymentMode_bak]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ResidentialPaymentMode_bak](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ResidentialType_Id] [int] NOT NULL,
	[PaymentMaster_Id] [int] NOT NULL,
	[ProcessNote] [nvarchar](max) NULL,
	[LastUpdatedBy] [varchar](100) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[ExerciseFormText1] [nvarchar](max) NULL,
	[ExerciseFormText2] [nvarchar](max) NULL,
	[isActivated] [char](1) NULL,
	[ADS_EX_FORM_TEXT_1] [varchar](max) NULL,
	[ADS_EX_FORM_TEXT_2] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
