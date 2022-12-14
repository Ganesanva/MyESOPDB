/****** Object:  Table [dbo].[MST_PAYMENT_MODE_DISCLAIMER]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MST_PAYMENT_MODE_DISCLAIMER]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MST_PAYMENT_MODE_DISCLAIMER](
	[MST_DisclaimerID] [int] IDENTITY(1,1) NOT NULL,
	[RPMID] [int] NOT NULL,
	[DisclaimerNote] [nvarchar](max) NULL,
	[ActualDisclaimerText] [nvarchar](max) NULL,
	[TentativeDisclaimerText] [nvarchar](max) NULL,
	[Is_ShowPaymentConfirmRecipt] [bit] NULL,
	[Is_ShowTaxConfirmRecipt] [bit] NULL,
	[CREATED_BY] [nvarchar](100) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [nvarchar](100) NOT NULL,
	[UPDATED_ON] [datetime] NOT NULL,
	[Is_ShowCMLCopy] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[MST_DisclaimerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
