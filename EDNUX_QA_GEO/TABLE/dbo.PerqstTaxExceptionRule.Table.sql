/****** Object:  Table [dbo].[PerqstTaxExceptionRule]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PerqstTaxExceptionRule]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PerqstTaxExceptionRule](
	[perqid] [int] IDENTITY(1,1) NOT NULL,
	[Action] [char](1) NULL,
	[Employeeid] [varchar](20) NULL,
	[Grantoptionid] [varchar](100) NULL,
	[PerqValue] [char](1) NULL,
	[Perqtax] [char](1) NULL,
	[Perq_tax_rate] [numeric](18, 6) NULL,
	[LastUpdatedBy] [varchar](20) NULL,
	[LastUpdatedOn] [datetime] NULL,
	[TaxHeading] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[perqid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__PerqstTax__Emplo__60283922]') AND parent_object_id = OBJECT_ID(N'[dbo].[PerqstTaxExceptionRule]'))
ALTER TABLE [dbo].[PerqstTaxExceptionRule]  WITH CHECK ADD FOREIGN KEY([Employeeid])
REFERENCES [dbo].[EmployeeMaster] ([EmployeeID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__PerqstTax__Grant__611C5D5B]') AND parent_object_id = OBJECT_ID(N'[dbo].[PerqstTaxExceptionRule]'))
ALTER TABLE [dbo].[PerqstTaxExceptionRule]  WITH CHECK ADD FOREIGN KEY([Grantoptionid])
REFERENCES [dbo].[GrantOptions] ([GrantOptionId])
GO
