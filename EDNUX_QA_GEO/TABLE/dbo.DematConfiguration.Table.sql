/****** Object:  Table [dbo].[DematConfiguration]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DematConfiguration]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DematConfiguration](
	[DC_ID] [bigint] IDENTITY(1,1) NOT NULL,
	[IsMandatory] [bit] NULL,
	[IsRequired] [bit] NULL,
	[IsDematValidation] [bit] NULL,
	[IsAllowToEditDemat] [bit] NULL,
	[IsRemainderMail] [bit] NULL,
	[FrequencyInDays] [nvarchar](10) NULL,
	[SendIntimation] [nvarchar](max) NULL,
	[CREATED_BY] [nvarchar](50) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [nvarchar](50) NULL,
	[UPDATED_ON] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
