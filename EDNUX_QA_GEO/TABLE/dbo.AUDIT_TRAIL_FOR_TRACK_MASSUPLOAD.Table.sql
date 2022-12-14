/****** Object:  Table [dbo].[AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD](
	[SRNO] [int] IDENTITY(1,1) NOT NULL,
	[Field] [nvarchar](200) NULL,
	[EmployeeId] [nvarchar](200) NULL,
	[EmployeeName] [nvarchar](200) NULL,
	[Status] [nvarchar](200) NULL,
	[CurrentDetails] [nvarchar](200) NULL,
	[FromDate] [date] NULL,
	[Moved To] [nvarchar](200) NULL,
	[From Date of Movement] [date] NULL,
	[IsError] [bit] NULL,
	[ErrorMessage] [nvarchar](200) NULL,
	[CREATED_BY] [nvarchar](200) NULL,
	[CREATED_ON] [datetime] NULL,
	[CURRENT_STATE_ID] [int] NULL,
	[MOVED_TO_STATE_ID] [int] NULL
) ON [PRIMARY]
END
GO
