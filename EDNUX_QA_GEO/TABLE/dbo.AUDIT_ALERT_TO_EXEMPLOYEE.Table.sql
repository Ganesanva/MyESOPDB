/****** Object:  Table [dbo].[AUDIT_ALERT_TO_EXEMPLOYEE]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AUDIT_ALERT_TO_EXEMPLOYEE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AUDIT_ALERT_TO_EXEMPLOYEE](
	[AUDIT_ID] [int] IDENTITY(1,1) NOT NULL,
	[EMPLOYEEID] [varchar](20) NULL,
	[ISMAILSENT] [bit] NULL,
	[MAIL_SUBJECT] [varchar](1000) NULL,
	[MAIL_BODY] [varchar](max) NULL,
	[LASTUPDATEDBY] [varchar](20) NULL,
	[LASTUPDATEDON] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[AUDIT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
