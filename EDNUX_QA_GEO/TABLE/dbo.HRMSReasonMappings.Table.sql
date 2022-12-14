/****** Object:  Table [dbo].[HRMSReasonMappings]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HRMSReasonMappings]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[HRMSReasonMappings](
	[HRMSID] [int] IDENTITY(1,1) NOT NULL,
	[ExitCode] [varchar](150) NOT NULL,
	[ReasonForTermination] [numeric](18, 0) NOT NULL,
	[Description] [varchar](200) NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
	[UpdatedOn] [datetime] NULL,
	[IsSeparatedMark] [tinyint] NULL,
 CONSTRAINT [PK_HRMS_REASON_MAPPINGS] PRIMARY KEY CLUSTERED 
(
	[HRMSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [uc_ExitCode] UNIQUE NONCLUSTERED 
(
	[ExitCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__HRMSReaso__IsSep__55E08030]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HRMSReasonMappings] ADD  DEFAULT ((1)) FOR [IsSeparatedMark]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__HRMSReaso__Reaso__7DB89C09]') AND parent_object_id = OBJECT_ID(N'[dbo].[HRMSReasonMappings]'))
ALTER TABLE [dbo].[HRMSReasonMappings]  WITH CHECK ADD FOREIGN KEY([ReasonForTermination])
REFERENCES [dbo].[ReasonForTermination] ([ID])
GO
