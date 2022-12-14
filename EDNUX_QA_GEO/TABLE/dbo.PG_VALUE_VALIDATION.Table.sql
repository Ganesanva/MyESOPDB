/****** Object:  Table [dbo].[PG_VALUE_VALIDATION]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PG_VALUE_VALIDATION]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PG_VALUE_VALIDATION](
	[PVV_ID] [int] IDENTITY(1,1) NOT NULL,
	[MIT_ID] [int] NOT NULL,
	[IS_PG_VALIDATION_ENABLED] [tinyint] NULL,
	[AMOUNT] [numeric](18, 2) NULL,
	[IS_PAY_MODE_HIDE] [tinyint] NULL,
	[IS_PAY_MODE_DISABLE] [tinyint] NULL,
	[VALIDATION_MESSAGE] [nvarchar](max) NULL,
	[PAYMENT_MODE_CONFIG_TYPE] [nvarchar](100) NULL,
	[CREATED_BY] [nvarchar](100) NULL,
	[CREATED_ON] [datetime] NULL,
	[UPDATED_BY] [nvarchar](100) NULL,
	[UPDATED_ON] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
