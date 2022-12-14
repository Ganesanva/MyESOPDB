/****** Object:  Table [dbo].[MST_Document_Upload_Master_Details]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MST_Document_Upload_Master_Details]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MST_Document_Upload_Master_Details](
	[MDUMD_ID] [int] IDENTITY(1,1) NOT NULL,
	[MDUM_ID] [int] NOT NULL,
	[Exercise_NO] [nvarchar](20) NULL,
	[IS_UPLOADED] [int] NULL,
	[IS_UPLOADED_ON] [datetime] NULL,
	[EmployeeID] [varchar](20) NULL,
	[CREATED_BY] [nvarchar](100) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [nvarchar](100) NOT NULL,
	[UPDATED_ON] [datetime] NOT NULL,
	[IsOnCloud] [bit] NULL,
	[FilePath] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[MDUMD_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
