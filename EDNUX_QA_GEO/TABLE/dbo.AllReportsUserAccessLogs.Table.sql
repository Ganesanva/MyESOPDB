/****** Object:  Table [dbo].[AllReportsUserAccessLogs]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AllReportsUserAccessLogs]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AllReportsUserAccessLogs](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [varchar](50) NULL,
	[UserName] [varchar](50) NULL,
	[ReportName] [varchar](50) NULL,
	[FileName] [varchar](50) NULL,
	[DateandTime] [datetime] NULL,
	[IPAddress] [varchar](50) NULL,
 CONSTRAINT [PK_AllReportsUserAccessLogs] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
