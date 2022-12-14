/****** Object:  Table [dbo].[UserNotificationDetails]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserNotificationDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserNotificationDetails](
	[UND_ID] [int] IDENTITY(1,1) NOT NULL,
	[NTF_SCH_ID] [int] NOT NULL,
	[UserId] [varchar](50) NOT NULL,
	[NTF_DESCRIPTION] [nvarchar](max) NULL,
	[UND_RECEIVE_DATE] [datetime] NULL,
	[UND_VIEW_DATE] [datetime] NULL,
	[UND_STATUS] [tinyint] NULL,
	[CREATED_BY] [nvarchar](50) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [nvarchar](50) NULL,
	[UPDATED_ON] [datetime] NULL,
 CONSTRAINT [PK_UserNotificationDetails] PRIMARY KEY CLUSTERED 
(
	[UND_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
