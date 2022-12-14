/****** Object:  Table [dbo].[HRMSMappingsFields]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HRMSMappingsFields]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[HRMSMappingsFields](
	[HRMSMappingsFldID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[MyESOPsFields] [varchar](100) NULL,
	[InputFields] [varchar](100) NULL,
	[IsAuditMaintained] [bit] NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
	[UpdatedOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[HRMSMappingsFldID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__HRMSMappi__IsAud__316D4A39]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HRMSMappingsFields] ADD  DEFAULT ((0)) FOR [IsAuditMaintained]
END
GO
