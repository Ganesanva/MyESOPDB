/****** Object:  Table [dbo].[Audit_Exercise_Details_Modify]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Audit_Exercise_Details_Modify]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Audit_Exercise_Details_Modify](
	[AEDM_ID] [int] IDENTITY(1,1) NOT NULL,
	[EMPLOYEEID] [nvarchar](100) NULL,
	[ExerciseNO] [nvarchar](50) NULL,
	[ActionName] [nvarchar](250) NULL,
	[Is_Allow_Modify] [bit] NULL,
	[Counter] [bigint] NULL,
	[IsActive] [bit] NULL,
	[CREATED_BY] [nvarchar](100) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [nvarchar](100) NOT NULL,
	[UPDATED_ON] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AEDM_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
