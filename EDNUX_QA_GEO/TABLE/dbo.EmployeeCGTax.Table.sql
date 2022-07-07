/****** Object:  Table [dbo].[EmployeeCGTax]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeCGTax]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EmployeeCGTax](
	[EMPCGTAXID] [int] IDENTITY(1,1) NOT NULL,
	[Employeeid] [varchar](20) NOT NULL,
	[CapitalGainTax] [numeric](18, 6) NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
