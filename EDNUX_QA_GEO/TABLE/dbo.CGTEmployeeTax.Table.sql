/****** Object:  Table [dbo].[CGTEmployeeTax]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CGTEmployeeTax]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CGTEmployeeTax](
	[CGT_ID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [varchar](20) NULL,
	[CGTWithPAN] [numeric](18, 6) NULL,
	[CGTWithoutPAN] [numeric](18, 6) NULL,
	[LastUpdatedBy] [varchar](20) NULL,
	[LastUpdatedOn] [datetime] NULL
) ON [PRIMARY]
END
GO
