/****** Object:  Table [dbo].[AuditTrailOfSchmePaymentSettings]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AuditTrailOfSchmePaymentSettings]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AuditTrailOfSchmePaymentSettings](
	[SettingId] [int] IDENTITY(1,1) NOT NULL,
	[SchemeId] [varchar](50) NOT NULL,
	[OldValueOfPaymentModeReq] [tinyint] NULL,
	[NEWValueOfPaymentModeReq] [tinyint] NULL,
	[OldEffectiveDate] [date] NULL,
	[NewEffectiveDate] [date] NULL,
	[LastUpdatedBy] [varchar](40) NULL,
	[LastUpdatedOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[SettingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
