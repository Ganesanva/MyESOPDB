/****** Object:  Table [dbo].[HRMSAuditTrails]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HRMSAuditTrails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[HRMSAuditTrails](
	[HRMSAuditTrailsID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[HRMSMappingsFldID] [numeric](18, 0) NULL,
	[OldValue] [varchar](500) NULL,
	[NewValue] [varchar](500) NULL,
	[EmployeeID] [varchar](20) NULL,
	[UpdatedOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[HRMSAuditTrailsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
