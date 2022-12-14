/****** Object:  Table [dbo].[HRMSMappingsValues]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HRMSMappingsValues]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[HRMSMappingsValues](
	[HRMSMappingsValID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[HRMSMappingsFldID] [numeric](18, 0) NOT NULL,
	[MyESOPsValue] [varchar](100) NULL,
	[MyESOPsActualMappedValue] [varchar](100) NULL,
	[InputValue] [varchar](100) NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
	[UpdatedOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[HRMSMappingsValID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__HRMSMappi__HRMSM__76177A41]') AND parent_object_id = OBJECT_ID(N'[dbo].[HRMSMappingsValues]'))
ALTER TABLE [dbo].[HRMSMappingsValues]  WITH CHECK ADD FOREIGN KEY([HRMSMappingsFldID])
REFERENCES [dbo].[HRMSMappingsFields] ([HRMSMappingsFldID])
GO
