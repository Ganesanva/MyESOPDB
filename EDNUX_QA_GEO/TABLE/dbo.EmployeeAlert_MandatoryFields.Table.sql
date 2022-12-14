/****** Object:  Table [dbo].[EmployeeAlert_MandatoryFields]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeAlert_MandatoryFields]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EmployeeAlert_MandatoryFields](
	[EAMF_ID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[IS_SEND_MAIL_ALERT] [bit] NULL,
	[REMINDER_DAYS] [int] NULL,
	[LAST_UPDATED_BY] [varchar](100) NULL,
	[LAST_UPDATED_ON] [datetime] NULL,
	[SENT_MAIL_ON] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[EAMF_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
