/****** Object:  Table [dbo].[DeviceTokenInfo]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeviceTokenInfo]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DeviceTokenInfo](
	[DeviceTokenId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](50) NOT NULL,
	[DeviceTokenKey] [nvarchar](500) NOT NULL,
	[IsActive] [tinyint] NULL,
	[CREATED_BY] [nvarchar](50) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [nvarchar](50) NULL,
	[UPDATED_ON] [datetime] NULL
) ON [PRIMARY]
END
GO
