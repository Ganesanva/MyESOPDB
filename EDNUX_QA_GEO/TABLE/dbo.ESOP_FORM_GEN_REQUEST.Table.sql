/****** Object:  Table [dbo].[ESOP_FORM_GEN_REQUEST]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ESOP_FORM_GEN_REQUEST]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ESOP_FORM_GEN_REQUEST](
	[REQUEST_ID] [int] IDENTITY(1,1) NOT NULL,
	[EXERCISE_NO] [numeric](18, 0) NULL,
	[EMPLOYEEID] [varchar](100) NULL,
	[ISPROCESSED] [int] NULL,
	[ISPROCESSEDON] [datetime] NULL,
	[CREATED_BY] [nvarchar](100) NULL,
	[CREATED_ON] [datetime] NULL,
	[UPDATED_BY] [nvarchar](100) NULL,
	[UPDATED_ON] [datetime] NULL
) ON [PRIMARY]
END
GO
